From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 3/4] bnx2fc: Fix kernel panic when deleting NPIV ports
Date: Mon, 28 Mar 2011 16:12:56 -0700
Message-ID: <1301353976.6312.52.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4739 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402Ab1C1XNS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2011 19:13:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, devel@open-fcoe.org, mchan@broadcom.com

Deleting NPIV port causes a kernel panic when the NPIV port is in the same zone
as the physical port and shares the same LUN. This happens due to the fact that
vport destroy and unsolicited ELS are scheduled to run on the same workqueue,
and vport_destroy destroys the lport and the unsolicited ELS tries to access
the invalid lport.  This patch fixes this issue by maintaining a list of valid
lports and verifying if the lport is valid or not before accessing it.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |    8 +++++++-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   28 +++++++++++++++++++++++++++-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  |   24 +++++++++++++++++++++++-
 3 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index b6d350a..e9cfda3 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -152,7 +152,6 @@ struct bnx2fc_percpu_s {
 	spinlock_t fp_work_lock;
 };
 
-
 struct bnx2fc_hba {
 	struct list_head link;
 	struct cnic_dev *cnic;
@@ -179,6 +178,7 @@ struct bnx2fc_hba {
 		#define BNX2FC_CTLR_INIT_DONE		1
 		#define BNX2FC_CREATE_DONE		2
 	struct fcoe_ctlr ctlr;
+	struct list_head vports;
 	u8 vlan_enabled;
 	int vlan_id;
 	u32 next_conn_id;
@@ -232,6 +232,11 @@ struct bnx2fc_hba {
 
 #define bnx2fc_from_ctlr(fip) container_of(fip, struct bnx2fc_hba, ctlr)
 
+struct bnx2fc_lport {
+	struct list_head list;
+	struct fc_lport *lport;
+};
+
 struct bnx2fc_cmd_mgr {
 	struct bnx2fc_hba *hba;
 	u16 next_idx;
@@ -423,6 +428,7 @@ struct bnx2fc_work {
 struct bnx2fc_unsol_els {
 	struct fc_lport *lport;
 	struct fc_frame *fp;
+	struct bnx2fc_hba *hba;
 	struct work_struct unsol_els_work;
 };
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 754e9c6..41456c5 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1223,6 +1223,7 @@ static int bnx2fc_interface_setup(struct bnx2fc_hba *hba,
 	hba->ctlr.get_src_addr = bnx2fc_get_src_mac;
 	set_bit(BNX2FC_CTLR_INIT_DONE, &hba->init_done);
 
+	INIT_LIST_HEAD(&hba->vports);
 	rc = bnx2fc_netdev_setup(hba);
 	if (rc)
 		goto setup_err;
@@ -1259,9 +1260,16 @@ static struct fc_lport *bnx2fc_if_create(struct bnx2fc_hba *hba,
 	struct fcoe_port	*port;
 	struct Scsi_Host	*shost;
 	struct fc_vport		*vport = dev_to_vport(parent);
+	struct bnx2fc_lport	*blport;
 	int			rc = 0;
 
 	/* Allocate Scsi_Host structure */
+	blport = kzalloc(sizeof(struct bnx2fc_lport), GFP_KERNEL);
+	if (!blport) {
+		BNX2FC_HBA_DBG(hba->ctlr.lp, "Unable to alloc bnx2fc_lport\n");
+		return NULL;
+	}
+
 	if (!npiv) {
 		lport = libfc_host_alloc(&bnx2fc_shost_template,
 					  sizeof(struct fcoe_port));
@@ -1272,7 +1280,7 @@ static struct fc_lport *bnx2fc_if_create(struct bnx2fc_hba *hba,
 
 	if (!lport) {
 		printk(KERN_ERR PFX "could not allocate scsi host structure\n");
-		return NULL;
+		goto free_blport;
 	}
 	shost = lport->host;
 	port = lport_priv(lport);
@@ -1324,12 +1332,20 @@ static struct fc_lport *bnx2fc_if_create(struct bnx2fc_hba *hba,
 	}
 
 	bnx2fc_interface_get(hba);
+
+	spin_lock_bh(&hba->hba_lock);
+	blport->lport = lport;
+	list_add_tail(&blport->list, &hba->vports);
+	spin_unlock_bh(&hba->hba_lock);
+
 	return lport;
 
 shost_err:
 	scsi_remove_host(shost);
 lp_config_err:
 	scsi_host_put(lport->host);
+free_blport:
+	kfree(blport);
 	return NULL;
 }
 
@@ -1345,6 +1361,7 @@ static void bnx2fc_if_destroy(struct fc_lport *lport)
 {
 	struct fcoe_port *port = lport_priv(lport);
 	struct bnx2fc_hba *hba = port->priv;
+	struct bnx2fc_lport *blport, *tmp;
 
 	BNX2FC_HBA_DBG(hba->ctlr.lp, "ENTERED bnx2fc_if_destroy\n");
 	/* Stop the transmit retry timer */
@@ -1371,6 +1388,15 @@ static void bnx2fc_if_destroy(struct fc_lport *lport)
 	/* Free memory used by statistical counters */
 	fc_lport_free_stats(lport);
 
+	spin_lock_bh(&hba->hba_lock);
+	list_for_each_entry_safe(blport, tmp, &hba->vports, list) {
+		if (blport->lport == lport) {
+			list_del(&blport->list);
+			kfree(blport);
+		}
+	}
+	spin_unlock_bh(&hba->hba_lock);
+
 	/* Release Scsi_Host */
 	scsi_host_put(lport->host);
 }
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 1b680e2..8eaecd0 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -480,16 +480,36 @@ int bnx2fc_send_session_destroy_req(struct bnx2fc_hba *hba,
 	return rc;
 }
 
+static bool is_valid_lport(struct bnx2fc_hba *hba, struct fc_lport *lport)
+{
+	struct bnx2fc_lport *blport;
+
+	spin_lock_bh(&hba->hba_lock);
+	list_for_each_entry(blport, &hba->vports, list) {
+		if (blport->lport == lport) {
+			spin_unlock_bh(&hba->hba_lock);
+			return true;
+		}
+	}
+	spin_unlock_bh(&hba->hba_lock);
+	return false;
+
+}
+
+
 static void bnx2fc_unsol_els_work(struct work_struct *work)
 {
 	struct bnx2fc_unsol_els *unsol_els;
 	struct fc_lport *lport;
+	struct bnx2fc_hba *hba;
 	struct fc_frame *fp;
 
 	unsol_els = container_of(work, struct bnx2fc_unsol_els, unsol_els_work);
 	lport = unsol_els->lport;
 	fp = unsol_els->fp;
-	fc_exch_recv(lport, fp);
+	hba = unsol_els->hba;
+	if (is_valid_lport(hba, lport))
+		fc_exch_recv(lport, fp);
 	kfree(unsol_els);
 }
 
@@ -499,6 +519,7 @@ void bnx2fc_process_l2_frame_compl(struct bnx2fc_rport *tgt,
 {
 	struct fcoe_port *port = tgt->port;
 	struct fc_lport *lport = port->lport;
+	struct bnx2fc_hba *hba = port->priv;
 	struct bnx2fc_unsol_els *unsol_els;
 	struct fc_frame_header *fh;
 	struct fc_frame *fp;
@@ -557,6 +578,7 @@ void bnx2fc_process_l2_frame_compl(struct bnx2fc_rport *tgt,
 		fr_eof(fp) = FC_EOF_T;
 		fr_crc(fp) = cpu_to_le32(~crc);
 		unsol_els->lport = lport;
+		unsol_els->hba = hba;
 		unsol_els->fp = fp;
 		INIT_WORK(&unsol_els->unsol_els_work, bnx2fc_unsol_els_work);
 		queue_work(bnx2fc_wq, &unsol_els->unsol_els_work);
-- 
1.7.0.6




