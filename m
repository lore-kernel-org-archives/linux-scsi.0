From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 1/4] aacraid: Fix default FIB size
Date: Wed, 11 Jan 2006 09:28:07 -0800
Message-ID: <1137000487.20470.39.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:17796 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751692AbWAKR2K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jan 2006 12:28:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn.

If the adapter has not instructed us otherwise that it can handle a
'large' FIB, then it can handle at most a 2KB FIB.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

--- scsi-misc-aac.orig/drivers/scsi/aacraid/commctrl.c	2006-01-11 09:19:58.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/commctrl.c	2006-01-11 09:20:04.000000000 -0800
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

