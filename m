From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 01/24] uas: replace WARN_ON_ONCE() with lockdep_assert_held()
Date: Sat, 13 Sep 2014 12:26:28 +0200
Message-ID: <1410604011-3828-2-git-send-email-hdegoede@redhat.com>
References: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbaIMK07 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Sep 2014 06:26:59 -0400
In-Reply-To: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Sanjeev Sharma <Sanjeev_Sharma@mentor.com>, Hans de Goede <hdegoede@redhat.com>

From: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>

On some architecture spin_is_locked() always return false in
uniprocessor configuration and therefore it would be advise to replace
with lockdep_assert_held().

Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 75d2ccd..8c7d4a2 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -156,7 +156,7 @@ static void uas_mark_cmd_dead(struct uas_dev_info *devinfo,
 	struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd, SCp);
 
 	uas_log_cmd_state(cmnd, caller);
-	WARN_ON_ONCE(!spin_is_locked(&devinfo->lock));
+	lockdep_assert_held(&devinfo->lock);
 	WARN_ON_ONCE(cmdinfo->state & COMMAND_ABORTED);
 	cmdinfo->state |= COMMAND_ABORTED;
 	cmdinfo->state &= ~IS_IN_WORK_LIST;
@@ -183,7 +183,7 @@ static void uas_add_work(struct uas_cmd_info *cmdinfo)
 	struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd, SCp);
 	struct uas_dev_info *devinfo = cmnd->device->hostdata;
 
-	WARN_ON_ONCE(!spin_is_locked(&devinfo->lock));
+	lockdep_assert_held(&devinfo->lock);
 	cmdinfo->state |= IS_IN_WORK_LIST;
 	schedule_work(&devinfo->work);
 }
@@ -285,7 +285,7 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 	struct uas_dev_info *devinfo = (void *)cmnd->device->hostdata;
 
-	WARN_ON_ONCE(!spin_is_locked(&devinfo->lock));
+	lockdep_assert_held(&devinfo->lock);
 	if (cmdinfo->state & (COMMAND_INFLIGHT |
 			      DATA_IN_URB_INFLIGHT |
 			      DATA_OUT_URB_INFLIGHT |
@@ -624,7 +624,7 @@ static int uas_submit_urbs(struct scsi_cmnd *cmnd,
 	struct urb *urb;
 	int err;
 
-	WARN_ON_ONCE(!spin_is_locked(&devinfo->lock));
+	lockdep_assert_held(&devinfo->lock);
 	if (cmdinfo->state & SUBMIT_STATUS_URB) {
 		urb = uas_submit_sense_urb(cmnd, gfp, cmdinfo->stream);
 		if (!urb)
-- 
2.1.0

