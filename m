From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix assorted wd7000 warnings
Date: Wed, 19 May 2004 22:33:50 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040519203350.GA10507@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:6044 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264500AbUESUdz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 May 2004 16:33:55 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

 - needs linux/delay.h for udelay
 - C doesn't allow taking addresses of register variables and gcc even
   complains these days


--- 1.28/drivers/scsi/wd7000.c	Fri May  2 21:48:35 2003
+++ edited/drivers/scsi/wd7000.c	Wed May 19 17:46:14 2004
@@ -165,6 +165,7 @@
  * Removed now obsolete wd7000.h
  */
 
+#include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
@@ -846,7 +847,7 @@
 static inline Scb *alloc_scbs(struct Scsi_Host *host, int needed)
 {
 	register Scb *scb, *p = NULL;
-	register unsigned long flags;
+	unsigned long flags;
 	register unsigned long timeout = jiffies + WAITnexttimeout;
 	register unsigned long now;
 	int i;
@@ -898,7 +899,7 @@
 
 static inline void free_scb(Scb * scb)
 {
-	register unsigned long flags;
+	unsigned long flags;
 
 	spin_lock_irqsave(&scbpool_lock, flags);
 
@@ -936,7 +937,7 @@
  */
 {
 	register int i, ogmb;
-	register unsigned long flags;
+	unsigned long flags;
 	unchar start_ogmb;
 	Mailbox *ogmbs = host->mb.ogmb;
 	int *next_ogmb = &(host->next_ogmb);
