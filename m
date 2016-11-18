From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 3/5] scsi: bnx2fc: clean up header definitions
Date: Fri, 18 Nov 2016 11:10:17 +0100
Message-ID: <20161118101019.2317-4-bigeasy@linutronix.de>
References: <20161118101019.2317-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:51372 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753015AbcKRKK4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2016 05:10:56 -0500
In-Reply-To: <20161118101019.2317-1-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Johannes Thumshirn <jth@kernel.org>, rt@linutronix.de, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>, Chad Dupuis <chad.dupuis@qlogic.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>

- All symbols which are only used within one .c file are marked static
  and removed from the bnx2fc.h file if possible.

- the declarion of bnx2fc_percpu is moved into the header file

This patch was only compile-tested due to -ENODEV.

Cc: QLogic-Storage-Upstream@qlogic.com
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |  5 +----
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 19 +++++++++----------
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  |  6 ++----
 3 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index fdd89935cac7..64308584405d 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -172,6 +172,7 @@ struct bnx2fc_percpu_s {
 	struct list_head work_list;
 	spinlock_t fp_work_lock;
 };
+DECLARE_PER_CPU(struct bnx2fc_percpu_s, bnx2fc_percpu);
=20
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
@@ -570,8 +569,6 @@ struct fc_seq *bnx2fc_elsct_send(struct fc_lport *lport=
, u32 did,
 						   struct fc_frame *,
 						   void *),
 				      void *arg, u32 timeout);
-void bnx2fc_arm_cq(struct bnx2fc_rport *tgt);
-int bnx2fc_process_new_cqes(struct bnx2fc_rport *tgt);
 void bnx2fc_process_cq_compl(struct bnx2fc_rport *tgt, u16 wqe);
 struct bnx2fc_rport *bnx2fc_tgt_lookup(struct fcoe_port *port,
 					     u32 port_id);
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc=
_fcoe.c
index 79ff0ed2b364..97424e0eaa23 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -49,7 +49,7 @@ struct workqueue_struct *bnx2fc_wq;
  * Here the io threads are per cpu but the l2 thread is just one
  */
 struct fcoe_percpu_s bnx2fc_global;
-DEFINE_SPINLOCK(bnx2fc_global_lock);
+static DEFINE_SPINLOCK(bnx2fc_global_lock);
=20
 static struct cnic_ulp_ops bnx2fc_cnic_cb;
 static struct libfc_function_template bnx2fc_libfc_fcn_templ;
@@ -107,22 +107,22 @@ MODULE_PARM_DESC(debug_logging,
 		"\t\t0x10 - fcoe L2 fame related logs.\n"
 		"\t\t0xff - LOG all messages.");
=20
-uint bnx2fc_devloss_tmo;
+static uint bnx2fc_devloss_tmo;
 module_param_named(devloss_tmo, bnx2fc_devloss_tmo, uint, S_IRUGO);
 MODULE_PARM_DESC(devloss_tmo, " Change devloss_tmo for the remote ports "
 	"attached via bnx2fc.");
=20
-uint bnx2fc_max_luns =3D BNX2FC_MAX_LUN;
+static uint bnx2fc_max_luns =3D BNX2FC_MAX_LUN;
 module_param_named(max_luns, bnx2fc_max_luns, uint, S_IRUGO);
 MODULE_PARM_DESC(max_luns, " Change the default max_lun per SCSI host. Def=
ault "
 	"0xffff.");
=20
-uint bnx2fc_queue_depth;
+static uint bnx2fc_queue_depth;
 module_param_named(queue_depth, bnx2fc_queue_depth, uint, S_IRUGO);
 MODULE_PARM_DESC(queue_depth, " Change the default queue depth of SCSI dev=
ices "
 	"attached via bnx2fc.");
=20
-uint bnx2fc_log_fka;
+static uint bnx2fc_log_fka;
 module_param_named(log_fka, bnx2fc_log_fka, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(log_fka, " Print message to kernel log when fcoe is "
 	"initiating a FIP keep alive when debug logging is enabled.");
@@ -167,7 +167,7 @@ static void bnx2fc_clean_rx_queue(struct fc_lport *lp)
 	spin_unlock_bh(&bg->fcoe_rx_list.lock);
 }
=20
-int bnx2fc_get_paged_crc_eof(struct sk_buff *skb, int tlen)
+static int bnx2fc_get_paged_crc_eof(struct sk_buff *skb, int tlen)
 {
 	int rc;
 	spin_lock(&bnx2fc_global_lock);
@@ -1396,10 +1396,9 @@ static struct bnx2fc_hba *bnx2fc_hba_create(struct c=
nic_dev *cnic)
 	return NULL;
 }
=20
-static struct bnx2fc_interface *
-bnx2fc_interface_create(struct bnx2fc_hba *hba,
-			struct net_device *netdev,
-			enum fip_state fip_mode)
+static struct bnx2fc_interface *bnx2fc_interface_create(struct bnx2fc_hba =
*hba,
+				      struct net_device *netdev,
+				      enum fip_state fip_mode)
 {
 	struct fcoe_ctlr_device *ctlr_dev;
 	struct bnx2fc_interface *interface;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_=
hwi.c
index 1ed7a1784e15..c2288d6cd217 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -14,8 +14,6 @@
=20
 #include "bnx2fc.h"
=20
-DECLARE_PER_CPU(struct bnx2fc_percpu_s, bnx2fc_percpu);
-
 static void bnx2fc_fastpath_notification(struct bnx2fc_hba *hba,
 					struct fcoe_kcqe *new_cqe_kcqe);
 static void bnx2fc_process_ofld_cmpl(struct bnx2fc_hba *hba,
@@ -980,7 +978,7 @@ void bnx2fc_process_cq_compl(struct bnx2fc_rport *tgt, =
u16 wqe)
 	spin_unlock_bh(&tgt->tgt_lock);
 }
=20
-void bnx2fc_arm_cq(struct bnx2fc_rport *tgt)
+static void bnx2fc_arm_cq(struct bnx2fc_rport *tgt)
 {
 	struct b577xx_fcoe_rx_doorbell *rx_db =3D &tgt->rx_db;
 	u32 msg;
@@ -1007,7 +1005,7 @@ static struct bnx2fc_work *bnx2fc_alloc_work(struct b=
nx2fc_rport *tgt, u16 wqe)
 	return work;
 }
=20
-int bnx2fc_process_new_cqes(struct bnx2fc_rport *tgt)
+static int bnx2fc_process_new_cqes(struct bnx2fc_rport *tgt)
 {
 	struct fcoe_cqe *cq;
 	u32 cq_cons;
--=20
2.10.2

