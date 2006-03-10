From: Ralf Baechle <ralf@linux-mips.org>
Subject: [SCSI] Fix sgiwd93 build as a module.
Date: Fri, 10 Mar 2006 20:14:23 +0000
Message-ID: <20060310201423.GA9988@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ftp.linux-mips.org ([194.74.144.162]:748 "EHLO
	ftp.linux-mips.org") by vger.kernel.org with ESMTP id S1752006AbWCJUO3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 15:14:29 -0500
Received: from localhost.localdomain ([127.0.0.1]:48032 "EHLO bacchus.dhis.org")
	by ftp.linux-mips.org with ESMTP id S8133976AbWCJUFj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 20:05:39 +0000
Received: from denk.linux-mips.net (denk.linux-mips.net [127.0.0.1])
	by bacchus.dhis.org (8.13.4/8.13.4) with ESMTP id k2AKENcb010332
	for <linux-scsi@vger.kernel.org>; Fri, 10 Mar 2006 20:14:23 GMT
Received: (from ralf@localhost)
	by denk.linux-mips.net (8.13.4/8.13.4/Submit) id k2AKENlD010331
	for linux-scsi@vger.kernel.org; Fri, 10 Mar 2006 20:14:23 GMT
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

wd33c93 needs to call sgiwd93_reset.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -14,6 +14,7 @@
 #include <linux/interrupt.h>
 #include <linux/types.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
@@ -197,6 +198,7 @@ void sgiwd93_reset(unsigned long base)
 	udelay(50);
 	hregs->ctrl = 0;
 }
+EXPORT_SYMBOL_GPL(sgiwd93_reset);
 
 static inline void init_hpc_chain(struct hpc_data *hd)
 {
