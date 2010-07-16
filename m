From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 06/10] zfcp: Post events through FC transport class
Date: Fri, 16 Jul 2010 15:37:39 +0200
Message-ID: <20100716134300.565288000@de.ibm.com>
References: <20100716133733.621672000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:43171 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965509Ab0GPNnE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2010 09:43:04 -0400
Content-Disposition: inline; filename=711-zfcp-post-fc-events.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Sven Schuetz <sven@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Sven Schuetz <sven@linux.vnet.ibm.com>

Post FC transport class netlink events for usage in the userspace,
e.g. for HBAAPI. Supported events are those required for the
polled events in HBAAPI.
- link up
- link down
- incoming RSCN
(events related to FC-AL are not supported, as zfcp has no support for FC-AL)

Signed-off-by: Sven Schuetz <sven@linux.vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |    4 +++
 drivers/s390/scsi/zfcp_def.h |    2 +
 drivers/s390/scsi/zfcp_ext.h |    3 ++
 drivers/s390/scsi/zfcp_fc.c  |   54 +++++++++++++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_fc.h  |   24 +++++++++++++++++++
 drivers/s390/scsi/zfcp_fsf.c |    3 ++
 6 files changed, 90 insertions(+)

--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -524,6 +524,10 @@ struct zfcp_adapter *zfcp_adapter_enqueu
 	rwlock_init(&adapter->port_list_lock);
 	INIT_LIST_HEAD(&adapter->port_list);
 
+	INIT_LIST_HEAD(&adapter->events.list);
+	INIT_WORK(&adapter->events.work, zfcp_fc_post_event);
+	spin_lock_init(&adapter->events.list_lock);
+
 	init_waitqueue_head(&adapter->erp_ready_wq);
 	init_waitqueue_head(&adapter->erp_done_wqh);
 
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -37,6 +37,7 @@
 #include <asm/ebcdic.h>
 #include <asm/sysinfo.h>
 #include "zfcp_fsf.h"
+#include "zfcp_fc.h"
 #include "zfcp_qdio.h"
 
 struct zfcp_reqlist;
@@ -190,6 +191,7 @@ struct zfcp_adapter {
 	struct service_level	service_level;
 	struct workqueue_struct	*work_queue;
 	struct device_dma_parameters dma_parms;
+	struct zfcp_fc_events events;
 };
 
 struct zfcp_port {
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -96,6 +96,9 @@ extern void zfcp_erp_adapter_access_chan
 extern void zfcp_erp_timeout_handler(unsigned long);
 
 /* zfcp_fc.c */
+extern void zfcp_fc_enqueue_event(struct zfcp_adapter *,
+				enum fc_host_event_code event_code, u32);
+extern void zfcp_fc_post_event(struct work_struct *);
 extern void zfcp_fc_scan_ports(struct work_struct *);
 extern void zfcp_fc_incoming_els(struct zfcp_fsf_req *);
 extern void zfcp_fc_port_did_lookup(struct work_struct *);
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -23,6 +23,58 @@ static u32 zfcp_fc_rscn_range_mask[] = {
 	[ELS_ADDR_FMT_FAB]		= 0x000000,
 };
 
+/**
+ * zfcp_fc_post_event - post event to userspace via fc_transport
+ * @work: work struct with enqueued events
+ */
+void zfcp_fc_post_event(struct work_struct *work)
+{
+	struct zfcp_fc_event *event = NULL, *tmp = NULL;
+	LIST_HEAD(tmp_lh);
+	struct zfcp_fc_events *events = container_of(work,
+					struct zfcp_fc_events, work);
+	struct zfcp_adapter *adapter = container_of(events, struct zfcp_adapter,
+						events);
+
+	spin_lock_bh(&events->list_lock);
+	list_splice_init(&events->list, &tmp_lh);
+	spin_unlock_bh(&events->list_lock);
+
+	list_for_each_entry_safe(event, tmp, &tmp_lh, list) {
+		fc_host_post_event(adapter->scsi_host, fc_get_event_number(),
+				event->code, event->data);
+		list_del(&event->list);
+		kfree(event);
+	}
+
+}
+
+/**
+ * zfcp_fc_enqueue_event - safely enqueue FC HBA API event from irq context
+ * @adapter: The adapter where to enqueue the event
+ * @event_code: The event code (as defined in fc_host_event_code in
+ *		scsi_transport_fc.h)
+ * @event_data: The event data (e.g. n_port page in case of els)
+ */
+void zfcp_fc_enqueue_event(struct zfcp_adapter *adapter,
+			enum fc_host_event_code event_code, u32 event_data)
+{
+	struct zfcp_fc_event *event;
+
+	event = kmalloc(sizeof(struct zfcp_fc_event), GFP_ATOMIC);
+	if (!event)
+		return;
+
+	event->code = event_code;
+	event->data = event_data;
+
+	spin_lock(&adapter->events.list_lock);
+	list_add_tail(&event->list, &adapter->events.list);
+	spin_unlock(&adapter->events.list_lock);
+
+	queue_work(adapter->work_queue, &adapter->events.work);
+}
+
 static int zfcp_fc_wka_port_get(struct zfcp_fc_wka_port *wka_port)
 {
 	if (mutex_lock_interruptible(&wka_port->mutex))
@@ -148,6 +200,8 @@ static void zfcp_fc_incoming_rscn(struct
 		afmt = page->rscn_page_flags & ELS_RSCN_ADDR_FMT_MASK;
 		_zfcp_fc_incoming_rscn(fsf_req, zfcp_fc_rscn_range_mask[afmt],
 				       page);
+		zfcp_fc_enqueue_event(fsf_req->adapter, FCH_EVT_RSCN,
+				      *(u32 *)page);
 	}
 	queue_work(fsf_req->adapter->work_queue, &fsf_req->adapter->scan_work);
 }
--- a/drivers/s390/scsi/zfcp_fc.h
+++ b/drivers/s390/scsi/zfcp_fc.h
@@ -30,6 +30,30 @@
 #define ZFCP_FC_CTELS_TMO	(2 * FC_DEF_R_A_TOV / 1000)
 
 /**
+ * struct zfcp_fc_event - FC HBAAPI event for internal queueing from irq context
+ * @code: Event code
+ * @data: Event data
+ * @list: list_head for zfcp_fc_events list
+ */
+struct zfcp_fc_event {
+	enum fc_host_event_code code;
+	u32 data;
+	struct list_head list;
+};
+
+/**
+ * struct zfcp_fc_events - Infrastructure for posting FC events from irq context
+ * @list: List for queueing of events from irq context to workqueue
+ * @list_lock: Lock for event list
+ * @work: work_struct for forwarding events in workqueue
+*/
+struct zfcp_fc_events {
+	struct list_head list;
+	spinlock_t list_lock;
+	struct work_struct work;
+};
+
+/**
  * struct zfcp_fc_gid_pn_req - container for ct header plus gid_pn request
  * @ct_hdr: FC GS common transport header
  * @gid_pn: GID_PN request
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -274,6 +274,7 @@ static void zfcp_fsf_status_read_handler
 		break;
 	case FSF_STATUS_READ_LINK_DOWN:
 		zfcp_fsf_status_read_link_down(req);
+		zfcp_fc_enqueue_event(adapter, FCH_EVT_LINKDOWN, 0);
 		break;
 	case FSF_STATUS_READ_LINK_UP:
 		dev_info(&adapter->ccw_device->dev,
@@ -286,6 +287,8 @@ static void zfcp_fsf_status_read_handler
 					ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
 					ZFCP_STATUS_COMMON_ERP_FAILED,
 					"fssrh_2", req);
+		zfcp_fc_enqueue_event(adapter, FCH_EVT_LINKUP, 0);
+
 		break;
 	case FSF_STATUS_READ_NOTIFICATION_LOST:
 		if (sr_buf->status_subtype & FSF_STATUS_READ_SUB_ACT_UPDATED)

