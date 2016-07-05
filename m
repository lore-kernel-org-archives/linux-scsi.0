From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/4] scsi: bnx2fc: clean up header definitions
Date: Tue,  5 Jul 2016 18:08:47 +0200
Message-ID: <1467734929-24442-2-git-send-email-bigeasy@linutronix.de>
References: <1467734929-24442-1-git-send-email-bigeasy@linutronix.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:36117 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbcGEQJN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2016 12:09:13 -0400
In-Reply-To: <1467734929-24442-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jth@kernel.org, rt@linutronix.de, jejb@linux.vnet.ibm.com, "Martin K . Petersen" <martin.petersen@oracle.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>

- All symbols which are only used within one .c file are marked static
  and removed from the bnx2fc.h file if possible.

- the declarion of bnx2fc_percpu is moved into the header file

This patch was only compile-tested due to -ENODEV.

Cc: QLogic-Storage-Upstream@qlogic.com
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |  5 +----
 drivers/scsi/bnx2fc/bnx2fc_els.c  |  4 ++--
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 14 +++++++-------
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  |  8 +++-----
 drivers/scsi/bnx2fc/bnx2fc_io.c   |  2 +-
 5 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index fdd89935cac7..64308584405d 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -172,6 +172,7 @@ struct bnx2fc_percpu_s {
 	struct list_head work_list;
 	spinlock_t fp_work_lock;
 };
+DECLARE_PER_CPU(struct bnx2fc_percpu_s, bnx2fc_percpu);
 
 struct bnx2fc_fw_stats {
 	u64	fc_crc_cnt;
@@ -513,7 +514,6 @@ void bnx2fc_cmd_mgr_free(struct bnx2fc_cmd_mgr *cmgr);
 void bnx2fc_get_link_state(struct bnx2fc_hba *hba);
 char *bnx2fc_get_next_rqe(struct bnx2fc_rport *tgt, u8 num_items);
 void bnx2fc_return_rqe(struct bnx2fc_rport *tgt, u8 num_items);
-int bnx2fc_get_paged_crc_eof(struct sk_buff *skb, int tlen);
 int bnx2fc_send_rrq(struct bnx2fc_cmd *aborted_io_req);
 int bnx2fc_send_adisc(struct bnx2fc_rport *tgt, struct fc_frame *fp);
 int bnx2fc_send_logo(struct bnx2fc_rport *tgt, struct fc_frame *fp);
@@ -537,7 +537,6 @@ void bnx2fc_init_task(struct bnx2fc_cmd *io_req,
 void bnx2fc_add_2_sq(struct bnx2fc_rport *tgt, u16 xid);
 void bnx2fc_ring_doorbell(struct bnx2fc_rport *tgt);
 int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd);
-int bnx2fc_eh_host_reset(struct scsi_cmnd *sc_cmd);
 int bnx2fc_eh_target_reset(struct scsi_cmnd *sc_cmd);
 int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_cmd);
 void bnx2fc_rport_event_handler(struct fc_lport *lport,
@@ -570,8 +569,6 @@ struct fc_seq *bnx2fc_elsct_send(struct fc_lport *lport, u32 did,
 						   struct fc_frame *,
 						   void *),
 				      void *arg, u32 timeout);
-void bnx2fc_arm_cq(struct bnx2fc_rport *tgt);
-int bnx2fc_process_new_cqes(struct bnx2fc_rport *tgt);
 void bnx2fc_process_cq_compl(struct bnx2fc_rport *tgt, u16 wqe);
 struct bnx2fc_rport *bnx2fc_tgt_lookup(struct fcoe_port *port,
 					     u32 port_id);
diff --git a/drivers/scsi/bnx2fc/bnx2fc_els.c b/drivers/scsi/bnx2fc/bnx2fc_els.c
index 5beea776b9f5..68ca518d34b0 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_els.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_els.c
@@ -254,7 +254,7 @@ int bnx2fc_send_rls(struct bnx2fc_rport *tgt, struct fc_frame *fp)
 	return rc;
 }
 
-void bnx2fc_srr_compl(struct bnx2fc_els_cb_arg *cb_arg)
+static void bnx2fc_srr_compl(struct bnx2fc_els_cb_arg *cb_arg)
 {
 	struct bnx2fc_mp_req *mp_req;
 	struct fc_frame_header *fc_hdr, *fh;
@@ -364,7 +364,7 @@ void bnx2fc_srr_compl(struct bnx2fc_els_cb_arg *cb_arg)
 	kref_put(&orig_io_req->refcount, bnx2fc_cmd_release);
 }
 
-void bnx2fc_rec_compl(struct bnx2fc_els_cb_arg *cb_arg)
+static void bnx2fc_rec_compl(struct bnx2fc_els_cb_arg *cb_arg)
 {
 	struct bnx2fc_cmd *orig_io_req, *new_io_req;
 	struct bnx2fc_cmd *rec_req;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index ab08d3ab8a44..10e1d42b1cb7 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -49,7 +49,7 @@ struct workqueue_struct *bnx2fc_wq;
  * Here the io threads are per cpu but the l2 thread is just one
  */
 struct fcoe_percpu_s bnx2fc_global;
-DEFINE_SPINLOCK(bnx2fc_global_lock);
+static DEFINE_SPINLOCK(bnx2fc_global_lock);
 
 static struct cnic_ulp_ops bnx2fc_cnic_cb;
 static struct libfc_function_template bnx2fc_libfc_fcn_templ;
@@ -107,22 +107,22 @@ MODULE_PARM_DESC(debug_logging,
 		"\t\t0x10 - fcoe L2 fame related logs.\n"
 		"\t\t0xff - LOG all messages.");
 
-uint bnx2fc_devloss_tmo;
+static uint bnx2fc_devloss_tmo;
 module_param_named(devloss_tmo, bnx2fc_devloss_tmo, uint, S_IRUGO);
 MODULE_PARM_DESC(devloss_tmo, " Change devloss_tmo for the remote ports "
 	"attached via bnx2fc.");
 
-uint bnx2fc_max_luns = BNX2FC_MAX_LUN;
+static uint bnx2fc_max_luns = BNX2FC_MAX_LUN;
 module_param_named(max_luns, bnx2fc_max_luns, uint, S_IRUGO);
 MODULE_PARM_DESC(max_luns, " Change the default max_lun per SCSI host. Default "
 	"0xffff.");
 
-uint bnx2fc_queue_depth;
+static uint bnx2fc_queue_depth;
 module_param_named(queue_depth, bnx2fc_queue_depth, uint, S_IRUGO);
 MODULE_PARM_DESC(queue_depth, " Change the default queue depth of SCSI devices "
 	"attached via bnx2fc.");
 
-uint bnx2fc_log_fka;
+static uint bnx2fc_log_fka;
 module_param_named(log_fka, bnx2fc_log_fka, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(log_fka, " Print message to kernel log when fcoe is "
 	"initiating a FIP keep alive when debug logging is enabled.");
@@ -167,7 +167,7 @@ static void bnx2fc_clean_rx_queue(struct fc_lport *lp)
 	spin_unlock_bh(&bg->fcoe_rx_list.lock);
 }
 
-int bnx2fc_get_paged_crc_eof(struct sk_buff *skb, int tlen)
+static int bnx2fc_get_paged_crc_eof(struct sk_buff *skb, int tlen)
 {
 	int rc;
 	spin_lock(&bnx2fc_global_lock);
@@ -1396,7 +1396,7 @@ static struct bnx2fc_hba *bnx2fc_hba_create(struct cnic_dev *cnic)
 	return NULL;
 }
 
-struct bnx2fc_interface *bnx2fc_interface_create(struct bnx2fc_hba *hba,
+static struct bnx2fc_interface *bnx2fc_interface_create(struct bnx2fc_hba *hba,
 				      struct net_device *netdev,
 				      enum fip_state fip_mode)
 {
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index acad76d3a81b..c2288d6cd217 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -14,8 +14,6 @@
 
 #include "bnx2fc.h"
 
-DECLARE_PER_CPU(struct bnx2fc_percpu_s, bnx2fc_percpu);
-
 static void bnx2fc_fastpath_notification(struct bnx2fc_hba *hba,
 					struct fcoe_kcqe *new_cqe_kcqe);
 static void bnx2fc_process_ofld_cmpl(struct bnx2fc_hba *hba,
@@ -980,7 +978,7 @@ void bnx2fc_process_cq_compl(struct bnx2fc_rport *tgt, u16 wqe)
 	spin_unlock_bh(&tgt->tgt_lock);
 }
 
-void bnx2fc_arm_cq(struct bnx2fc_rport *tgt)
+static void bnx2fc_arm_cq(struct bnx2fc_rport *tgt)
 {
 	struct b577xx_fcoe_rx_doorbell *rx_db = &tgt->rx_db;
 	u32 msg;
@@ -994,7 +992,7 @@ void bnx2fc_arm_cq(struct bnx2fc_rport *tgt)
 
 }
 
-struct bnx2fc_work *bnx2fc_alloc_work(struct bnx2fc_rport *tgt, u16 wqe)
+static struct bnx2fc_work *bnx2fc_alloc_work(struct bnx2fc_rport *tgt, u16 wqe)
 {
 	struct bnx2fc_work *work;
 	work = kzalloc(sizeof(struct bnx2fc_work), GFP_ATOMIC);
@@ -1007,7 +1005,7 @@ struct bnx2fc_work *bnx2fc_alloc_work(struct bnx2fc_rport *tgt, u16 wqe)
 	return work;
 }
 
-int bnx2fc_process_new_cqes(struct bnx2fc_rport *tgt)
+static int bnx2fc_process_new_cqes(struct bnx2fc_rport *tgt)
 {
 	struct fcoe_cqe *cq;
 	u32 cq_cons;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 8f24d60f09d7..f501095f91ac 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1079,7 +1079,7 @@ int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	return bnx2fc_initiate_tmf(sc_cmd, FCP_TMF_LUN_RESET);
 }
 
-int bnx2fc_abts_cleanup(struct bnx2fc_cmd *io_req)
+static int bnx2fc_abts_cleanup(struct bnx2fc_cmd *io_req)
 {
 	struct bnx2fc_rport *tgt = io_req->tgt;
 	int rc = SUCCESS;
-- 
2.8.1

