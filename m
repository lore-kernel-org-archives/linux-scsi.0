From: akpm@linux-foundation.org
Subject: [patch 11/11] sg_io: don't perform unneeded copy in compat code
Date: Fri, 09 Jan 2009 12:28:10 -0800
Message-ID: <200901092028.n09KSBK1024592@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752875AbZAIUgf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2009 15:36:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, alexey.zaytsev@gmail.com, dgilbert@interlog.com, fujita.tomonori@lab.ntt.co.jp

From: Alexey Zaytsev <alexey.zaytsev@gmail.com>

FUJITA Tomonori says:

The members from 'status' in struct sg_io_hdr to the last are used to
transfer information from kernel to user space. The values that user
space sets are just ignored.

Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN fs/compat_ioctl.c~sg_io-dont-perform-unneeded-copy-in-compat-code fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~sg_io-dont-perform-unneeded-copy-in-compat-code
+++ a/fs/compat_ioctl.c
@@ -782,12 +782,6 @@ static int sg_ioctl_trans(unsigned int f
 	if (put_user(compat_ptr(data), &sgio->usr_ptr))
 		return -EFAULT;
 
-	if (copy_in_user(&sgio->status, &sgio32->status,
-			 (4 * sizeof(unsigned char)) +
-			 (2 * sizeof(unsigned (short))) +
-			 (3 * sizeof(int))))
-		return -EFAULT;
-
 	err = sys_ioctl(fd, cmd, (unsigned long) sgio);
 
 	if (err >= 0) {
_
