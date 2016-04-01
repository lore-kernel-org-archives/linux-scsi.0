From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH] mpt3sas - remove unused fw_event_work delayed_work
Date: Fri, 1 Apr 2016 13:56:29 -0400
Message-ID: <1459533389-19648-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0140.outbound.protection.outlook.com ([207.46.100.140]:33328
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751732AbcDAR4l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2016 13:56:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Calvin Owens <calvinowens@fb.com>, Joe Lawrence <joe.lawrence@stratus.com>

The driver's fw events are queued up using the the fw_event_work's
struct work, not its delayed_work member.  The latter appears to be
unused and may provoke CONFIG_DEBUG_OBJECTS_TIMERS "assert_init not
available" false warnings in _scsih_fw_event_cleanup_queue.  Remove it
and update _scsih_fw_event_cleanup_queue accordingly.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---

I think this goes all the way back to the introduction of the mpt3sas
driver.  The previous generation mpt2sas driver uses delayed_work, so
perhaps it was simply copied and pasted into the mpt3sas but never
updated.

 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index e0e4920d0fa6..67643602efbc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -189,7 +189,6 @@ struct fw_event_work {
 	struct list_head	list;
 	struct work_struct	work;
 	u8			cancel_pending_work;
-	struct delayed_work	delayed_work;
 
 	struct MPT3SAS_ADAPTER *ioc;
 	u16			device_handle;
@@ -2804,12 +2803,12 @@ _scsih_fw_event_cleanup_queue(struct MPT3SAS_ADAPTER *ioc)
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

