From: Abhilash Jindal <klock.android@gmail.com>
Subject: [PATCH] 3w-9xxx: use boottime to compare time
Date: Sun, 31 Jan 2016 23:14:47 -0500
Message-ID: <1454300087-19910-1-git-send-email-klock.android@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:36566 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757654AbcBAEOu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Jan 2016 23:14:50 -0500
Received: by mail-io0-f180.google.com with SMTP id g73so145437199ioe.3
        for <linux-scsi@vger.kernel.org>; Sun, 31 Jan 2016 20:14:49 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, JBottomley@odin.com, linuxraid@lsi.com, Abhilash Jindal <klock.android@gmail.com>

Wall time is susceptible to sudden jumps due to user setting the time or
due to NTP.  Boot time is constantly increasing time better suited for
subtracting two timestamps.

Signed-off-by: Abhilash Jindal <klock.android@gmail.com>
---
 drivers/scsi/3w-9xxx.c |   13 ++++++-------
 drivers/scsi/3w-9xxx.h |    2 +-
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index a56a7b2..12e9141 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -651,8 +651,7 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 	TW_Command_Full *full_command_packet;
 	TW_Compatibility_Info *tw_compat_info;
 	TW_Event *event;
-	struct timeval current_time;
-	u32 current_time_ms;
+	ktime_t current_time;
 	TW_Device_Extension *tw_dev = twa_device_extension_list[iminor(inode)];
 	int retval = TW_IOCTL_ERROR_OS_EFAULT;
 	void __user *argp = (void __user *)arg;
@@ -843,17 +842,17 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 		break;
 	case TW_IOCTL_GET_LOCK:
 		tw_lock = (TW_Lock *)tw_ioctl->data_buffer;
-		do_gettimeofday(&current_time);
-		current_time_ms = (current_time.tv_sec * 1000) + (current_time.tv_usec / 1000);
+		current_time = ktime_get_boottime();
 
-		if ((tw_lock->force_flag == 1) || (tw_dev->ioctl_sem_lock == 0) || (current_time_ms >= tw_dev->ioctl_msec)) {
+		if ((tw_lock->force_flag == 1) || (tw_dev->ioctl_sem_lock == 0) 
+			|| (ktime_compare(current_time, tw_dev->ioctl_time) >= 0)) {
 			tw_dev->ioctl_sem_lock = 1;
-			tw_dev->ioctl_msec = current_time_ms + tw_lock->timeout_msec;
+			tw_dev->ioctl_time = ktime_add_ms(current_time, tw_lock->timeout_msec);
 			tw_ioctl->driver_command.status = 0;
 			tw_lock->time_remaining_msec = tw_lock->timeout_msec;
 		} else {
 			tw_ioctl->driver_command.status = TW_IOCTL_ERROR_STATUS_LOCKED;
-			tw_lock->time_remaining_msec = tw_dev->ioctl_msec - current_time_ms;
+			tw_lock->time_remaining_msec = ktime_to_ms(ktime_sub(tw_dev->ioctl_time, current_time));
 		}
 		break;
 	case TW_IOCTL_RELEASE_LOCK:
diff --git a/drivers/scsi/3w-9xxx.h b/drivers/scsi/3w-9xxx.h
index 0fdc83c..6f5d7e3 100644
--- a/drivers/scsi/3w-9xxx.h
+++ b/drivers/scsi/3w-9xxx.h
@@ -669,7 +669,7 @@ typedef struct TAG_TW_Device_Extension {
 	unsigned char		event_queue_wrapped;
 	unsigned int            error_sequence_id;
 	int                     ioctl_sem_lock;
-	u32                     ioctl_msec;
+	ktime_t                 ioctl_time;
 	int			chrdev_request_id;
 	wait_queue_head_t	ioctl_wqueue;
 	struct mutex		ioctl_lock;
-- 
1.7.9.5

