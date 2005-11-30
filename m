From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 2/5] aacraid: Fix default FIB size
Date: Wed, 30 Nov 2005 10:36:06 -0800
Message-ID: <1133375766.2288.22.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:19086 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751502AbVK3SgJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 13:36:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn.

If the adapter has not instructed us otherwise that it can handle a
'large' FIB, then it can handle at most a 2KB FIB.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---
Applies to the scsi-misc-2.6 git tree.

Index: scsi-misc-aac/drivers/scsi/aacraid/commctrl.c
===================================================================
--- scsi-misc-aac.orig/drivers/scsi/aacraid/commctrl.c	2005-11-28 14:56:46.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/commctrl.c	2005-11-28 15:15:09.000000000 -0800
@@ -85,6 +85,10 @@
 	if (size < le16_to_cpu(kfib->header.SenderSize))
 		size = le16_to_cpu(kfib->header.SenderSize);
 	if (size > dev->max_fib_size) {
+		if (size > 2048) {
+			retval = -EINVAL;
+			goto cleanup;
+		}
 		/* Highjack the hw_fib */
 		hw_fib = fibptr->hw_fib;
 		hw_fib_pa = fibptr->hw_fib_pa;

-- 
Mark Haverkamp <markh@osdl.org>

