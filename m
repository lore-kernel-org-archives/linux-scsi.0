From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 05/12] IB/srp: Fix connection state tracking
Date: Mon, 18 May 2015 13:23:57 +0200
Message-ID: <5559CBCD.6070905@sandisk.com>
References: <5559CB3A.6060102@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5559CB3A.6060102-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <jbottomley-wo1vFcy6AUs@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Reception of a DREQ message only causes the state of a single
channel to change. Hence move the 'connected' member variable
from the target to the channel data structure. This patch
avoids that following false positive warning can be reported
by srp_destroy_qp():

WARNING: at drivers/infiniband/ulp/srp/ib_srp.c:617 srp_destroy_qp+0xa6/0x120 [ib_srp]()
Call Trace:
[<ffffffff8106e10f>] warn_slowpath_common+0x7f/0xc0
[<ffffffff8106e16a>] warn_slowpath_null+0x1a/0x20
[<ffffffffa0440226>] srp_destroy_qp+0xa6/0x120 [ib_srp]
[<ffffffffa0440322>] srp_free_ch_ib+0x82/0x1e0 [ib_srp]
[<ffffffffa044408b>] srp_create_target+0x7ab/0x998 [ib_srp]
[<ffffffff81346f60>] dev_attr_store+0x20/0x30
[<ffffffff811dd90f>] sysfs_write_file+0xef/0x170
[<ffffffff8116d248>] vfs_write+0xc8/0x190
[<ffffffff8116d411>] sys_write+0x51/0x90

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #v3.19
---
 drivers/infiniband/ulp/srp/ib_srp.c | 60 ++++++++++++++++++-------------------
 drivers/infiniband/ulp/srp/ib_srp.h |  2 +-
 2 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 034d755..83e4d8a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -465,14 +465,13 @@ static struct srp_fr_pool *srp_alloc_fr_pool(struct srp_target_port *target)
  */
 static void srp_destroy_qp(struct srp_rdma_ch *ch)
 {
-	struct srp_target_port *target = ch->target;
 	static struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
 	static struct ib_recv_wr wr = { .wr_id = SRP_LAST_WR_ID };
 	struct ib_recv_wr *bad_wr;
 	int ret;
 
 	/* Destroying a QP and reusing ch->done is only safe if not connected */
-	WARN_ON_ONCE(target->connected);
+	WARN_ON_ONCE(ch->connected);
 
 	ret = ib_modify_qp(ch->qp, &attr, IB_QP_STATE);
 	WARN_ONCE(ret, "ib_cm_init_qp_attr() returned %d\n", ret);
@@ -827,35 +826,19 @@ static bool srp_queue_remove_work(struct srp_target_port *target)
 	return changed;
 }
 
-static bool srp_change_conn_state(struct srp_target_port *target,
-				  bool connected)
-{
-	bool changed = false;
-
-	spin_lock_irq(&target->lock);
-	if (target->connected != connected) {
-		target->connected = connected;
-		changed = true;
-	}
-	spin_unlock_irq(&target->lock);
-
-	return changed;
-}
-
 static void srp_disconnect_target(struct srp_target_port *target)
 {
 	struct srp_rdma_ch *ch;
 	int i;
 
-	if (srp_change_conn_state(target, false)) {
-		/* XXX should send SRP_I_LOGOUT request */
+	/* XXX should send SRP_I_LOGOUT request */
 
-		for (i = 0; i < target->ch_count; i++) {
-			ch = &target->ch[i];
-			if (ch->cm_id && ib_send_cm_dreq(ch->cm_id, NULL, 0)) {
-				shost_printk(KERN_DEBUG, target->scsi_host,
-					     PFX "Sending CM DREQ failed\n");
-			}
+	for (i = 0; i < target->ch_count; i++) {
+		ch = &target->ch[i];
+		ch->connected = false;
+		if (ch->cm_id && ib_send_cm_dreq(ch->cm_id, NULL, 0)) {
+			shost_printk(KERN_DEBUG, target->scsi_host,
+				     PFX "Sending CM DREQ failed\n");
 		}
 	}
 }
@@ -1002,12 +985,26 @@ static void srp_rport_delete(struct srp_rport *rport)
 	srp_queue_remove_work(target);
 }
 
+/**
+ * srp_connected_ch() - number of connected channels
+ * @target: SRP target port.
+ */
+static int srp_connected_ch(struct srp_target_port *target)
+{
+	int i, c = 0;
+
+	for (i = 0; i < target->ch_count; i++)
+		c += target->ch[i].connected;
+
+	return c;
+}
+
 static int srp_connect_ch(struct srp_rdma_ch *ch, bool multich)
 {
 	struct srp_target_port *target = ch->target;
 	int ret;
 
-	WARN_ON_ONCE(!multich && target->connected);
+	WARN_ON_ONCE(!multich && srp_connected_ch(target) > 0);
 
 	ret = srp_lookup_path(ch);
 	if (ret)
@@ -1030,7 +1027,7 @@ static int srp_connect_ch(struct srp_rdma_ch *ch, bool multich)
 		 */
 		switch (ch->status) {
 		case 0:
-			srp_change_conn_state(target, true);
+			ch->connected = true;
 			return 0;
 
 		case SRP_PORT_REDIRECT:
@@ -1946,7 +1943,7 @@ static void srp_handle_qp_err(u64 wr_id, enum ib_wc_status wc_status,
 		return;
 	}
 
-	if (target->connected && !target->qp_in_error) {
+	if (ch->connected && !target->qp_in_error) {
 		if (wr_id & LOCAL_INV_WR_ID_MASK) {
 			shost_printk(KERN_ERR, target->scsi_host, PFX
 				     "LOCAL_INV failed with status %d\n",
@@ -2384,7 +2381,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 	case IB_CM_DREQ_RECEIVED:
 		shost_printk(KERN_WARNING, target->scsi_host,
 			     PFX "DREQ received - connection closed\n");
-		srp_change_conn_state(target, false);
+		ch->connected = false;
 		if (ib_send_cm_drep(cm_id, NULL, 0))
 			shost_printk(KERN_ERR, target->scsi_host,
 				     PFX "Sending CM DREP failed\n");
@@ -2440,7 +2437,7 @@ static int srp_send_tsk_mgmt(struct srp_rdma_ch *ch, u64 req_tag,
 	struct srp_iu *iu;
 	struct srp_tsk_mgmt *tsk_mgmt;
 
-	if (!target->connected || target->qp_in_error)
+	if (!ch->connected || target->qp_in_error)
 		return -1;
 
 	init_completion(&ch->tsk_mgmt_done);
@@ -2814,7 +2811,8 @@ static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
 	scsi_scan_target(&target->scsi_host->shost_gendev,
 			 0, target->scsi_id, SCAN_WILD_CARD, 0);
 
-	if (!target->connected || target->qp_in_error) {
+	if (srp_connected_ch(target) < target->ch_count ||
+	    target->qp_in_error) {
 		shost_printk(KERN_INFO, target->scsi_host,
 			     PFX "SCSI scan failed - removing SCSI host\n");
 		srp_queue_remove_work(target);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index a611556..e690847 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -170,6 +170,7 @@ struct srp_rdma_ch {
 
 	struct completion	tsk_mgmt_done;
 	u8			tsk_mgmt_status;
+	bool			connected;
 };
 
 /**
@@ -214,7 +215,6 @@ struct srp_target_port {
 	__be16			pkey;
 
 	u32			rq_tmo_jiffies;
-	bool			connected;
 
 	int			zero_req_lim;
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
