From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 07/21] qla2xxx: Add FC-transport Asynchronous Event Notification support.
Date: Thu,  3 Apr 2008 13:13:18 -0700
Message-ID: <1207253612-15538-7-git-send-email-andrew.vasquez@qlogic.com>
References: <20080403201152.GB8033@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6416 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761729AbYDCUNt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 16:13:49 -0400
In-Reply-To: <20080403201152.GB8033@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Supported events include LIP, LIP reset, RSCN, link up, and link
down.

To support AEN (and additional forthcoming features), we also
introduce a simple deferred-work construct to manage events which
require a non-atomic sleeping-capable context.  This work-list is
processed as part of the driver's standard DPC routine.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |   22 ++++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h |    2 +
 drivers/scsi/qla2xxx/qla_isr.c |    5 +++
 drivers/scsi/qla2xxx/qla_os.c  |   73 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 102 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index f70c78b..35c730a 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2115,6 +2115,26 @@ struct qla_msix_entry {
 
 #define	WATCH_INTERVAL		1       /* number of seconds */
 
+/* Work events.  */
+enum qla_work_type {
+	QLA_EVT_AEN,
+};
+
+
+struct qla_work_evt {
+	struct list_head	list;
+	enum qla_work_type	type;
+	u32			flags;
+#define QLA_EVT_FLAG_FREE	0x1
+
+	union {
+		struct {
+			enum fc_host_event_code code;
+			u32 data;
+		} aen;
+	} u;
+};
+
 /*
  * Linux Host Adapter structure
  */
@@ -2354,6 +2374,8 @@ typedef struct scsi_qla_host {
         uint32_t	login_retry_count;
 	int		max_q_depth;
 
+	struct list_head	work_list;
+
 	/* Fibre Channel Device List. */
 	struct list_head	fcports;
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 97625d4..ee52f3e 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -67,6 +67,8 @@ extern int num_hosts;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
+extern int qla2x00_post_aen_work(struct scsi_qla_host *, enum
+    fc_host_event_code, u32);
 
 /*
  * Global Functions in qla_mid.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 4e9f410..e9d8a79 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -408,6 +408,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		set_bit(REGISTER_FC4_NEEDED, &ha->dpc_flags);
 
 		ha->flags.management_server_logged_in = 0;
+		qla2x00_post_aen_work(ha, FCH_EVT_LIP, mb[1]);
 		break;
 
 	case MBA_LOOP_UP:		/* Loop Up Event */
@@ -427,6 +428,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		    link_speed);
 
 		ha->flags.management_server_logged_in = 0;
+		qla2x00_post_aen_work(ha, FCH_EVT_LINKUP, ha->link_data_rate);
 		break;
 
 	case MBA_LOOP_DOWN:		/* Loop Down Event */
@@ -450,6 +452,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 		ha->link_data_rate = PORT_SPEED_UNKNOWN;
 		if (ql2xfdmienable)
 			set_bit(REGISTER_FDMI_NEEDED, &ha->dpc_flags);
+		qla2x00_post_aen_work(ha, FCH_EVT_LINKDOWN, 0);
 		break;
 
 	case MBA_LIP_RESET:		/* LIP reset occurred */
@@ -473,6 +476,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 
 		ha->operating_mode = LOOP;
 		ha->flags.management_server_logged_in = 0;
+		qla2x00_post_aen_work(ha, FCH_EVT_LIPRESET, mb[1]);
 		break;
 
 	case MBA_POINT_TO_POINT:	/* Point-to-Point */
@@ -610,6 +614,7 @@ qla2x00_async_event(scsi_qla_host_t *ha, uint16_t *mb)
 
 		set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
 		set_bit(RSCN_UPDATE, &ha->dpc_flags);
+		qla2x00_post_aen_work(ha, FCH_EVT_RSCN, rscn_entry);
 		break;
 
 	/* case MBA_RIO_RESPONSE: */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 661a159..eb77067 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1704,6 +1704,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	INIT_LIST_HEAD(&ha->list);
 	INIT_LIST_HEAD(&ha->fcports);
 	INIT_LIST_HEAD(&ha->vp_list);
+	INIT_LIST_HEAD(&ha->work_list);
 
 	set_bit(0, (unsigned long *) ha->vp_idx_map);
 
@@ -2197,6 +2198,76 @@ qla2x00_mem_free(scsi_qla_host_t *ha)
 	kfree(ha->nvram);
 }
 
+struct qla_work_evt *
+qla2x00_alloc_work(struct scsi_qla_host *ha, enum qla_work_type type,
+    int locked)
+{
+	struct qla_work_evt *e;
+
+	e = kzalloc(sizeof(struct qla_work_evt), locked ? GFP_ATOMIC:
+	    GFP_KERNEL);
+	if (!e)
+		return NULL;
+
+	INIT_LIST_HEAD(&e->list);
+	e->type = type;
+	e->flags = QLA_EVT_FLAG_FREE;
+	return e;
+}
+
+int
+qla2x00_post_work(struct scsi_qla_host *ha, struct qla_work_evt *e, int locked)
+{
+	unsigned long flags;
+
+	if (!locked)
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+	list_add_tail(&e->list, &ha->work_list);
+	qla2xxx_wake_dpc(ha);
+	if (!locked)
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	return QLA_SUCCESS;
+}
+
+int
+qla2x00_post_aen_work(struct scsi_qla_host *ha, enum fc_host_event_code code,
+    u32 data)
+{
+	struct qla_work_evt *e;
+
+	e = qla2x00_alloc_work(ha, QLA_EVT_AEN, 1);
+	if (!e)
+		return QLA_FUNCTION_FAILED;
+
+	e->u.aen.code = code;
+	e->u.aen.data = data;
+	return qla2x00_post_work(ha, e, 1);
+}
+
+static void
+qla2x00_do_work(struct scsi_qla_host *ha)
+{
+	struct qla_work_evt *e;
+
+	spin_lock_irq(&ha->hardware_lock);
+	while (!list_empty(&ha->work_list)) {
+		e = list_entry(ha->work_list.next, struct qla_work_evt, list);
+		list_del_init(&e->list);
+		spin_unlock_irq(&ha->hardware_lock);
+
+		switch (e->type) {
+		case QLA_EVT_AEN:
+			fc_host_post_event(ha->host, fc_get_event_number(),
+			    e->u.aen.code, e->u.aen.data);
+			break;
+		}
+		if (e->flags & QLA_EVT_FLAG_FREE)
+			kfree(e);
+		spin_lock_irq(&ha->hardware_lock);
+	}
+	spin_unlock_irq(&ha->hardware_lock);
+}
+
 /**************************************************************************
 * qla2x00_do_dpc
 *   This kernel thread is a task that is schedule by the interrupt handler
@@ -2248,6 +2319,8 @@ qla2x00_do_dpc(void *data)
 			continue;
 		}
 
+		qla2x00_do_work(ha);
+
 		if (test_and_clear_bit(ISP_ABORT_NEEDED, &ha->dpc_flags)) {
 
 			DEBUG(printk("scsi(%ld): dpc: sched "
-- 
1.5.5.rc2

