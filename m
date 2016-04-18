From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH v2] mpt3sas - remove unused fw_event_work elements
Date: Mon, 18 Apr 2016 10:50:12 -0400
Message-ID: <1460991012-10018-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0116.outbound.protection.outlook.com ([207.46.100.116]:50806
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751671AbcDROu1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Apr 2016 10:50:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Joe Lawrence <joe.lawrence@stratus.com>

Firmware events are queued up using the fw_event_work's struct work, not
its delayed_work member.  The initial driver for SAS2 controllers had
handled firmware reset using the rescan barrier and was later redesigned
through "mpt2sas: [Resend] Host Reset code cleanup".  The delayed_work
variables are now unused and may provoke CONFIG_DEBUG_OBJECTS_TIMERS
"assert_init not available" false warnings in
_scsih_fw_event_cleanup_queue.

Cleanup fw_event_work's unused entries, update it's kerneldoc, and update
_scsih_fw_event_cleanup_queue accordingly.

Fixes: 146b16c8071f (mpt3sas: Refcount fw_events and fix unsafe list usage)
Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index e0e4920d0fa6..f2139e5604a3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -174,13 +174,13 @@ struct sense_info {
  * struct fw_event_work - firmware event struct
  * @list: link list framework
  * @work: work object (ioc->fault_reset_work_q)
- * @cancel_pending_work: flag set during reset handling
  * @ioc: per adapter object
  * @device_handle: device handle
  * @VF_ID: virtual function id
  * @VP_ID: virtual port id
  * @ignore: flag meaning this event has been marked to ignore
- * @event: firmware event MPI2_EVENT_XXX defined in mpt2_ioc.h
+ * @event: firmware event MPI2_EVENT_XXX defined in mpi2_ioc.h
+ * @refcount: kref for this event
  * @event_data: reply event data payload follows
  *
  * This object stored on ioc->fw_event_list.
@@ -188,8 +188,6 @@ struct sense_info {
 struct fw_event_work {
 	struct list_head	list;
 	struct work_struct	work;
-	u8			cancel_pending_work;
-	struct delayed_work	delayed_work;
 
 	struct MPT3SAS_ADAPTER *ioc;
 	u16			device_handle;
@@ -2804,12 +2802,12 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
 		/*
 		 * Wait on the fw_event to complete. If this returns 1, then
 		 * the event was never executed, and we need a put for the
-		 * reference the delayed_work had on the fw_event.
+		 * reference the work had on the fw_event.
 		 *
 		 * If it did execute, we wait for it to finish, and the put will
 		 * happen from _firmware_event_work()
 		 */
-		if (cancel_delayed_work_sync(&fw_event->delayed_work))
+		if (cancel_work_sync(&fw_event->work))
 			fw_event_work_put(fw_event);
 
 		fw_event_work_put(fw_event);
-- 
1.8.3.1

