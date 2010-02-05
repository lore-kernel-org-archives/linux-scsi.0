From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] megaraid_sas: fix for 32bit apps
Date: Fri, 05 Feb 2010 18:04:01 +0100
Message-ID: <4B6C4F81.6090806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023Ab0BEREQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Feb 2010 12:04:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Yang, Bo" <Bo.Yang@lsi.com>, James.Bottomley@HansenPartnership.com, hch@infradead.org, thenzl@redhat.com

It looks like this patch -
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7b2519afa1abd1b9f63aa1e90879307842422dae
has caused a problem for 32bit programs with 64bit os - 
http://bugzilla.kernel.org/show_bug.cgi?id=15001

megaraid: convert user space 32bit pointer 
to a 64 bit one when needed.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>

diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index 708ea31..7617b8e 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -3781,6 +3781,8 @@ static int megasas_mgmt_compat_ioctl_fw(struct file *file, unsigned long arg)
 	    compat_alloc_user_space(sizeof(struct megasas_iocpacket));
 	int i;
 	int error = 0;
+	compat_uptr_t ptr;
+	u8 *sense_ptr;
 
 	if (clear_user(ioc, sizeof(*ioc)))
 		return -EFAULT;
@@ -3793,9 +3795,19 @@ static int megasas_mgmt_compat_ioctl_fw(struct file *file, unsigned long arg)
 	    copy_in_user(&ioc->sge_count, &cioc->sge_count, sizeof(u32)))
 		return -EFAULT;
 
-	for (i = 0; i < MAX_IOCTL_SGE; i++) {
-		compat_uptr_t ptr;
+	/*
+	 * The sense_ptr is used in megasas_mgmt_fw_ioctl only when
+	 * sense_len is not null, so prepare the 64bit value under
+	 * the same condition.
+	 */
+	if (ioc->sense_len) {
+		sense_ptr = ioc->frame.raw + ioc->sense_off;
+		if (get_user(ptr, (compat_uptr_t *)sense_ptr) ||
+		    put_user(ptr, (unsigned long *)sense_ptr))
+			return -EFAULT;
+	}
 
+	for (i = 0; i < MAX_IOCTL_SGE; i++) {
 		if (get_user(ptr, &cioc->sgl[i].iov_base) ||
 		    put_user(compat_ptr(ptr), &ioc->sgl[i].iov_base) ||
 		    copy_in_user(&ioc->sgl[i].iov_len,


