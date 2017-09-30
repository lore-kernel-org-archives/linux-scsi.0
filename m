From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.14-rc2
Date: Sat, 30 Sep 2017 11:28:23 +0200
Message-ID: <1506763703.3565.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Eight mostly minor fixes for recently discovered issues in drivers.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Dave Carroll (1):
      scsi: aacraid: Fix 2T+ drives on SmartIOC-2000

Guilherme G. Piccoli (1):
      scsi: aacraid: Add a small delay after IOP reset

Hannes Reinecke (2):
      scsi: scsi_transport_fc: Also check for NOTPRESENT in fc_remote_port_add()
      scsi: scsi_transport_fc: set scsi_target_id upon rescan

Martin Wilck (1):
      scsi: ILLEGAL REQUEST + ASC==27 => target failure

Nikola Pajkovsky (1):
      scsi: aacraid: error: testing array offset 'bus' after use

Stefano Brivio (1):
      scsi: lpfc: Don't return internal MBXERR_ERROR code from probe function

Xin Long (1):
      scsi: scsi_transport_iscsi: fix the issue that iscsi_if_rx doesn't parse nlmsg properly

And the diffstat:

drivers/scsi/aacraid/aachba.c       | 12 ++++++------
 drivers/scsi/aacraid/aacraid.h      |  5 +++++
 drivers/scsi/aacraid/linit.c        | 20 ++++++++++++--------
 drivers/scsi/aacraid/src.c          |  2 ++
 drivers/scsi/lpfc/lpfc_init.c       |  1 +
 drivers/scsi/scsi_error.c           |  3 ++-
 drivers/scsi/scsi_transport_fc.c    | 14 +++-----------
 drivers/scsi/scsi_transport_iscsi.c |  2 +-
 8 files changed, 32 insertions(+), 27 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index a64285ab0728..af3e4d3f9735 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -699,13 +699,13 @@ static void _aac_probe_container1(void * context, struct fib * fibptr)
 	int status;
 
 	dresp = (struct aac_mount *) fib_data(fibptr);
-	if (!(fibptr->dev->supplement_adapter_info.supported_options2 &
-	    AAC_OPTION_VARIABLE_BLOCK_SIZE))
+	if (!aac_supports_2T(fibptr->dev)) {
 		dresp->mnt[0].capacityhigh = 0;
-	if ((le32_to_cpu(dresp->status) != ST_OK) ||
-	    (le32_to_cpu(dresp->mnt[0].vol) != CT_NONE)) {
-		_aac_probe_container2(context, fibptr);
-		return;
+		if ((le32_to_cpu(dresp->status) == ST_OK) &&
+			(le32_to_cpu(dresp->mnt[0].vol) != CT_NONE)) {
+			_aac_probe_container2(context, fibptr);
+			return;
+		}
 	}
 	scsicmd = (struct scsi_cmnd *) context;
 
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 92fabf2b0c24..403a639574e5 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2701,6 +2701,11 @@ static inline int aac_is_src(struct aac_dev *dev)
 	return 0;
 }
 
+static inline int aac_supports_2T(struct aac_dev *dev)
+{
+	return (dev->adapter_info.options & AAC_OPT_NEW_COMM_64);
+}
+
 char * get_container_type(unsigned type);
 extern int numacb;
 extern char aac_driver_version[];
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 87cc4a93e637..62beb2596466 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -906,12 +906,14 @@ static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
 
 	bus = aac_logical_to_phys(scmd_channel(cmd));
 	cid = scmd_id(cmd);
-	info = &aac->hba_map[bus][cid];
-	if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS ||
-	    info->devtype != AAC_DEVTYPE_NATIVE_RAW)
+
+	if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS)
 		return FAILED;
 
-	if (info->reset_state > 0)
+	info = &aac->hba_map[bus][cid];
+
+	if (info->devtype != AAC_DEVTYPE_NATIVE_RAW &&
+	    info->reset_state > 0)
 		return FAILED;
 
 	pr_err("%s: Host adapter reset request. SCSI hang ?\n",
@@ -962,12 +964,14 @@ static int aac_eh_target_reset(struct scsi_cmnd *cmd)
 
 	bus = aac_logical_to_phys(scmd_channel(cmd));
 	cid = scmd_id(cmd);
-	info = &aac->hba_map[bus][cid];
-	if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS ||
-	    info->devtype != AAC_DEVTYPE_NATIVE_RAW)
+
+	if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS)
 		return FAILED;
 
-	if (info->reset_state > 0)
+	info = &aac->hba_map[bus][cid];
+
+	if (info->devtype != AAC_DEVTYPE_NATIVE_RAW &&
+	    info->reset_state > 0)
 		return FAILED;
 
 	pr_err("%s: Host adapter reset request. SCSI hang ?\n",
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 48c2b2b34b72..0c9361c87ec8 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -740,6 +740,8 @@ static void aac_send_iop_reset(struct aac_dev *dev)
 	aac_set_intx_mode(dev);
 
 	src_writel(dev, MUnit.IDR, IOP_SRC_RESET_MASK);
+
+	msleep(5000);
 }
 
 static void aac_send_hardware_soft_reset(struct aac_dev *dev)
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 7e7ae786121b..100bc4c8798d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -6131,6 +6131,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 				"Extents and RPI headers enabled.\n");
 		}
 		mempool_free(mboxq, phba->mbox_mem_pool);
+		rc = -EIO;
 		goto out_free_bsmbx;
 	}
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 38942050b265..dab876c65473 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -580,7 +580,8 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
 		if (sshdr.asc == 0x20 || /* Invalid command operation code */
 		    sshdr.asc == 0x21 || /* Logical block address out of range */
 		    sshdr.asc == 0x24 || /* Invalid field in cdb */
-		    sshdr.asc == 0x26) { /* Parameter value invalid */
+		    sshdr.asc == 0x26 || /* Parameter value invalid */
+		    sshdr.asc == 0x27) { /* Write protected */
 			set_host_byte(scmd, DID_TARGET_FAILURE);
 		}
 		return SUCCESS;
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index ba9d70f8a6a1..cbd4495d0ff9 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2739,7 +2739,8 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 
 	list_for_each_entry(rport, &fc_host->rports, peers) {
 
-		if ((rport->port_state == FC_PORTSTATE_BLOCKED) &&
+		if ((rport->port_state == FC_PORTSTATE_BLOCKED ||
+		     rport->port_state == FC_PORTSTATE_NOTPRESENT) &&
 			(rport->channel == channel)) {
 
 			switch (fc_host->tgtid_bind_type) {
@@ -2876,7 +2877,6 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 			memcpy(&rport->port_name, &ids->port_name,
 				sizeof(rport->port_name));
 			rport->port_id = ids->port_id;
-			rport->roles = ids->roles;
 			rport->port_state = FC_PORTSTATE_ONLINE;
 			rport->flags &= ~FC_RPORT_FAST_FAIL_TIMEDOUT;
 
@@ -2885,15 +2885,7 @@ fc_remote_port_add(struct Scsi_Host *shost, int channel,
 						fci->f->dd_fcrport_size);
 			spin_unlock_irqrestore(shost->host_lock, flags);
 
-			if (ids->roles & FC_PORT_ROLE_FCP_TARGET) {
-				scsi_target_unblock(&rport->dev, SDEV_RUNNING);
-
-				/* initiate a scan of the target */
-				spin_lock_irqsave(shost->host_lock, flags);
-				rport->flags |= FC_RPORT_SCAN_PENDING;
-				scsi_queue_work(shost, &rport->scan_work);
-				spin_unlock_irqrestore(shost->host_lock, flags);
-			}
+			fc_remote_port_rolechg(rport, ids->roles);
 			return rport;
 		}
 	}
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 8934f19bce8e..0190aeff5f7f 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3689,7 +3689,7 @@ iscsi_if_rx(struct sk_buff *skb)
 		uint32_t group;
 
 		nlh = nlmsg_hdr(skb);
-		if (nlh->nlmsg_len < sizeof(*nlh) ||
+		if (nlh->nlmsg_len < sizeof(*nlh) + sizeof(*ev) ||
 		    skb->len < nlh->nlmsg_len) {
 			break;
 		}
