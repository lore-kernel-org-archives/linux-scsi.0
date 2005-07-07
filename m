From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] 2.6 aacraid: Fix sgmap error
Date: Thu, 07 Jul 2005 13:40:00 -0700
Message-ID: <1120768800.4472.10.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:55724 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261344AbVGGUkE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2005 16:40:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>


The wrong sgmap structure is being assigned in aac_send_raw_srb.

Patch against scsi-misc-2.6 git tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

Index: scsi-misc-2.6/drivers/scsi/aacraid/commctrl.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aacraid/commctrl.c	2005-06-24 10:51:16.000000000 -0700
+++ scsi-misc-2.6/drivers/scsi/aacraid/commctrl.c	2005-07-07 13:17:21.000000000 -0700
@@ -517,7 +517,7 @@
 	}
 	if (dev->dac_support == 1) {
 		struct user_sgmap64* upsg = (struct user_sgmap64*)&user_srbcmd->sg;
-		struct sgmap64* psg = (struct sgmap64*)&user_srbcmd->sg;
+		struct sgmap64* psg = (struct sgmap64*)&srbcmd->sg;
 		struct user_sgmap* usg;
 		byte_count = 0;
 

-- 
Mark Haverkamp <markh@osdl.org>

