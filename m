From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH] scsi: cxgb4i,libcxgbi: add missing module_put()
Date: Wed,  7 Dec 2016 21:06:45 +0530
Message-ID: <1481125005-17177-1-git-send-email-varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:19301 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932283AbcLGPhS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2016 10:37:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, indranil@chelsio.com, varun@chelsio.com

Add module_put() in cxgbi_sock_act_open_req_arp_failure()
to release module reference in case of arp failure, also
check return value of try_module_get() before posting active
open hw cmd.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c | 11 ++++++++---
 drivers/scsi/cxgbi/libcxgbi.c      |  3 +++
 drivers/scsi/cxgbi/libcxgbi.h      |  1 +
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 8f797db..2bebda0 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -800,7 +800,7 @@ static void do_act_establish(struct cxgbi_device *cdev, struct sk_buff *skb)
 		       (&csk->saddr), (&csk->daddr),
 		       atid, tid, csk, csk->state, csk->flags, rcv_isn);
 
-	module_put(THIS_MODULE);
+	module_put(cdev->owner);
 
 	cxgbi_sock_get(csk);
 	csk->tid = tid;
@@ -949,7 +949,7 @@ static void do_act_open_rpl(struct cxgbi_device *cdev, struct sk_buff *skb)
 	if (is_neg_adv(status))
 		goto rel_skb;
 
-	module_put(THIS_MODULE);
+	module_put(cdev->owner);
 
 	if (status && status != CPL_ERR_TCAM_FULL &&
 	    status != CPL_ERR_CONN_EXIST &&
@@ -1712,7 +1712,11 @@ static int init_act_open(struct cxgbi_sock *csk)
 		       csk->mtu, csk->mss_idx, csk->smac_idx);
 
 	/* must wait for either a act_open_rpl or act_open_establish */
-	try_module_get(THIS_MODULE);
+	if (!try_module_get(cdev->owner)) {
+		pr_err("%s, try_module_get failed.\n", ndev->name);
+		goto rel_resource;
+	}
+
 	cxgbi_sock_set_state(csk, CTP_ACTIVE_OPEN);
 	if (csk->csk_family == AF_INET)
 		send_act_open_req(csk, skb, csk->l2t);
@@ -2026,6 +2030,7 @@ static void *t4_uld_add(const struct cxgb4_lld_info *lldi)
 	cdev->skb_tx_rsvd = CXGB4I_TX_HEADER_LEN;
 	cdev->skb_rx_extra = sizeof(struct cpl_iscsi_hdr);
 	cdev->itp = &cxgb4i_iscsi_transport;
+	cdev->owner = THIS_MODULE;
 
 	cdev->pfvf = FW_VIID_PFN_G(cxgb4_port_viid(lldi->ports[0]))
 			<< FW_VIID_PFN_S;
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index eb4af12..9f4fde9 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -896,6 +896,7 @@ EXPORT_SYMBOL_GPL(cxgbi_sock_fail_act_open);
 void cxgbi_sock_act_open_req_arp_failure(void *handle, struct sk_buff *skb)
 {
 	struct cxgbi_sock *csk = (struct cxgbi_sock *)skb->sk;
+	struct module *owner = csk->cdev->owner;
 
 	log_debug(1 << CXGBI_DBG_SOCK, "csk 0x%p,%u,0x%lx,%u.\n",
 		csk, (csk)->state, (csk)->flags, (csk)->tid);
@@ -906,6 +907,8 @@ void cxgbi_sock_act_open_req_arp_failure(void *handle, struct sk_buff *skb)
 	spin_unlock_bh(&csk->lock);
 	cxgbi_sock_put(csk);
 	__kfree_skb(skb);
+
+	module_put(owner);
 }
 EXPORT_SYMBOL_GPL(cxgbi_sock_act_open_req_arp_failure);
 
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 85bae61..95ba990 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -468,6 +468,7 @@ struct cxgbi_device {
 	struct pci_dev *pdev;
 	struct dentry *debugfs_root;
 	struct iscsi_transport *itp;
+	struct module *owner;
 
 	unsigned int pfvf;
 	unsigned int rx_credit_thres;
-- 
2.0.2

