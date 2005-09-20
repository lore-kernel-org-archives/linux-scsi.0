From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 6/7] aacraid: fib size math fix
Date: Tue, 20 Sep 2005 12:57:04 -0700
Message-ID: <1127246224.1891.37.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:38590 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965111AbVITUAR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Sep 2005 16:00:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn from Adaptec.

The size of the command packet's scatter gather list maximum size was
miscalculated in the low range leading to the driver initialization
limiting the maximum i/o size that could go to the Adapter. There were
no negative operational side effects resulting from this bad math, only
a subtle limit in performance of the Adapter at the top end of the
range.

Applies to the scsi-misc-2.6 git tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>



Index: scsi-misc-aac-2/drivers/scsi/aacraid/aachba.c
===================================================================
--- scsi-misc-aac-2.orig/drivers/scsi/aacraid/aachba.c	2005-09-20 09:12:07.000000000 -0700
+++ scsi-misc-aac-2/drivers/scsi/aacraid/aachba.c	2005-09-20 09:12:10.000000000 -0700
@@ -843,8 +843,8 @@
 	if (!(dev->raw_io_interface)) {
 		dev->scsi_host_ptr->sg_tablesize = (dev->max_fib_size -
 			sizeof(struct aac_fibhdr) -
-			sizeof(struct aac_write) + sizeof(struct sgmap)) /
-				sizeof(struct sgmap);
+			sizeof(struct aac_write) + sizeof(struct sgentry)) /
+				sizeof(struct sgentry);
 		if (dev->dac_support) {
 			/* 
 			 * 38 scatter gather elements 
@@ -853,8 +853,8 @@
 				(dev->max_fib_size -
 				sizeof(struct aac_fibhdr) -
 				sizeof(struct aac_write64) +
-				sizeof(struct sgmap64)) /
-					sizeof(struct sgmap64);
+				sizeof(struct sgentry64)) /
+					sizeof(struct sgentry64);
 		}
 		dev->scsi_host_ptr->max_sectors = AAC_MAX_32BIT_SGBCOUNT;
 		if(!(dev->adapter_info.options & AAC_OPT_NEW_COMM)) {
Index: scsi-misc-aac-2/drivers/scsi/aacraid/comminit.c
===================================================================
--- scsi-misc-aac-2.orig/drivers/scsi/aacraid/comminit.c	2005-09-20 09:12:07.000000000 -0700
+++ scsi-misc-aac-2/drivers/scsi/aacraid/comminit.c	2005-09-20 09:12:10.000000000 -0700
@@ -313,8 +313,8 @@
 	dev->max_fib_size = sizeof(struct hw_fib);
 	dev->sg_tablesize = host->sg_tablesize = (dev->max_fib_size
 		- sizeof(struct aac_fibhdr)
-		- sizeof(struct aac_write) + sizeof(struct sgmap))
-			/ sizeof(struct sgmap);
+		- sizeof(struct aac_write) + sizeof(struct sgentry))
+			/ sizeof(struct sgentry);
 	dev->raw_io_64 = 0;
 	if ((!aac_adapter_sync_cmd(dev, GET_ADAPTER_PROPERTIES,
 		0, 0, 0, 0, 0, 0, status+0, status+1, status+2, NULL, NULL)) &&
@@ -349,8 +349,8 @@
 			dev->max_fib_size = 512;
 			dev->sg_tablesize = host->sg_tablesize
 			  = (512 - sizeof(struct aac_fibhdr)
-			    - sizeof(struct aac_write) + sizeof(struct sgmap))
-			     / sizeof(struct sgmap);
+			    - sizeof(struct aac_write) + sizeof(struct sgentry))
+			     / sizeof(struct sgentry);
 			host->can_queue = AAC_NUM_IO_FIB;
 		} else if (acbsize == 2048) {
 			host->max_sectors = 512;

-- 
Mark Haverkamp <markh@osdl.org>

