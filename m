From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] aacraid:  2.6.13 aacraid bad BUG_ON fix
Date: Thu, 01 Sep 2005 08:19:23 -0700
Message-ID: <1125587963.21124.9.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:36481 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030193AbVIAPWf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2005 11:22:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

This was noticed by Doug Bazamic and the fix found by Mark Salyzyn at
Adaptec.

There was an error in the BUG_ON() statement that validated the
calculated fib size which can cause the driver to panic.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

--- a/drivers/scsi/aacraid/aachba.c	2005-08-28 19:41:01.000000000 -0400
+++ b/drivers/scsi/aacraid/aachba.c	2005-09-01 08:05:29.118304656 -0400
@@ -968,7 +968,7 @@
 		fibsize = sizeof(struct aac_read64) + 
 			((le32_to_cpu(readcmd->sg.count) - 1) * 
 			 sizeof (struct sgentry64));
-		BUG_ON (fibsize > (sizeof(struct hw_fib) - 
+		BUG_ON (fibsize > (dev->max_fib_size - 
 					sizeof(struct aac_fibhdr)));
 		/*
 		 *	Now send the Fib to the adapter

-- 
Mark Haverkamp <markh@osdl.org>

