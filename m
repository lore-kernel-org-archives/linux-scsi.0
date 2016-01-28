From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: [PATCH 2/2] megaraid_sas: Fix SMAP issue
Date: Thu, 28 Jan 2016 21:14:26 +0530
Message-ID: <1453995866-25097-3-git-send-email-sumit.saxena@avagotech.com>
References: <1453995866-25097-1-git-send-email-sumit.saxena@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:35881 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbcA1PpA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 10:45:00 -0500
Received: by mail-pf0-f169.google.com with SMTP id n128so25214057pfn.3
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jan 2016 07:45:00 -0800 (PST)
In-Reply-To: <1453995866-25097-1-git-send-email-sumit.saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com, thenzl@redhat.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

Inside compat IOCTL hook of driver, driver was using wrong address of
ioc->frame.raw which leads sense_ioc_ptr to be calculated wrongly and
failing IOCTL.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 52f3419..cc92c81 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6843,9 +6843,9 @@ static int megasas_mgmt_compat_ioctl_fw(struct file *file, unsigned long arg)
 	int i;
 	int error = 0;
 	compat_uptr_t ptr;
-	unsigned long local_raw_ptr;
 	u32 local_sense_off;
 	u32 local_sense_len;
+	u32 user_sense_off;
 
 	if (clear_user(ioc, sizeof(*ioc)))
 		return -EFAULT;
@@ -6863,17 +6863,16 @@ static int megasas_mgmt_compat_ioctl_fw(struct file *file, unsigned long arg)
 	 * sense_len is not null, so prepare the 64bit value under
 	 * the same condition.
 	 */
-	if (get_user(local_raw_ptr, ioc->frame.raw) ||
-		get_user(local_sense_off, &ioc->sense_off) ||
-		get_user(local_sense_len, &ioc->sense_len))
+	if (get_user(local_sense_off, &ioc->sense_off) ||
+		get_user(local_sense_len, &ioc->sense_len) ||
+		get_user(user_sense_off, &cioc->sense_off))
 		return -EFAULT;
 
-
 	if (local_sense_len) {
 		void __user **sense_ioc_ptr =
-			(void __user **)((u8*)local_raw_ptr + local_sense_off);
+			(void __user **)((u8 *)((unsigned long)&ioc->frame.raw) + local_sense_off);
 		compat_uptr_t *sense_cioc_ptr =
-			(compat_uptr_t *)(cioc->frame.raw + cioc->sense_off);
+			(compat_uptr_t *)(((unsigned long)&cioc->frame.raw) + user_sense_off);
 		if (get_user(ptr, sense_cioc_ptr) ||
 		    put_user(compat_ptr(ptr), sense_ioc_ptr))
 			return -EFAULT;
-- 
1.8.3.1

