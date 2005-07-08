From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] 2.6 aacraid: Fix for controller load based timeouts
Date: Fri, 08 Jul 2005 10:36:30 -0700
Message-ID: <1120844190.19677.46.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:31191 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S262729AbVGHRgh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2005 13:36:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>, Martin Drab <drab@kepler.fjfi.cvut.cz>

Martin Drab found that he could get aacraid timeouts with high load on
his controller / disk drive combinations.  After some experimentation
Mark Salyzyn has come up with a patch to reduce the default max_sectors
to something that will keep the controller from being overloaded and
will eliminate the timeout issues.

Patch against scsi-misc-2.6 git tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

Index: scsi-misc-2.6/drivers/scsi/aacraid/aacraid.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aacraid/aacraid.h	2005-07-08 09:22:20.000000000 -0700
+++ scsi-misc-2.6/drivers/scsi/aacraid/aacraid.h	2005-07-08 09:23:52.000000000 -0700
@@ -15,11 +15,7 @@
 #define AAC_MAX_LUN		(8)
 
 #define AAC_MAX_HOSTPHYSMEMPAGES (0xfffff)
-/*
- *  max_sectors is an unsigned short, otherwise limit is 0x100000000 / 512
- * Linux has starvation problems if we permit larger than 4MB I/O ...
- */
-#define AAC_MAX_32BIT_SGBCOUNT	((unsigned short)8192)
+#define AAC_MAX_32BIT_SGBCOUNT	((unsigned short)512)
 
 /*
  * These macros convert from physical channels to virtual channels
Index: scsi-misc-2.6/drivers/scsi/aacraid/linit.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aacraid/linit.c	2005-06-27 09:57:38.000000000 -0700
+++ scsi-misc-2.6/drivers/scsi/aacraid/linit.c	2005-07-08 09:23:52.000000000 -0700
@@ -374,7 +374,8 @@
 	else
 		scsi_adjust_queue_depth(sdev, 0, 1);
 
-	if (host->max_sectors < AAC_MAX_32BIT_SGBCOUNT)
+	if (!(((struct aac_dev *)host->hostdata)->adapter_info.options
+	  & AAC_OPT_NEW_COMM))
 		blk_queue_max_segment_size(sdev->request_queue, 65536);
 
 	return 0;

-- 
Mark Haverkamp <markh@osdl.org>

