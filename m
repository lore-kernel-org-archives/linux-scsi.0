From: rct@gherkin.frus.com (Bob Tracy)
Subject: [PATCH] sym53c500_cs driver update
Date: Fri, 26 Nov 2004 22:50:11 -0600 (CST)
Message-ID: <20041127045011.F0214DBDB@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=ELM781191431-21099-0_
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:21457 "EHLO gherkin.frus.com")
	by vger.kernel.org with ESMTP id S262294AbUK0EuQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Nov 2004 23:50:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: torvalds@osdl.org, hch@infradead.org, James.Bottomley@steeleye.com


--ELM781191431-21099-0_
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII

(Previously posted a month ago to linux-kernel and linux-scsi with
copies to James Bottomley and Christoph Hellwig.  No feedback received.
Would like to see this included in 2.6.10.  Thanks!)

The attached minor patch to linux/drivers/scsi/pcmcia/sym53c500_cs.c
allows interrupt sharing, which is evidently a "must have" feature for
at least G4 PowerBooks (ppc architecture).  The other user of the New
Media Bus Toaster reports that his powerbook consistently assigns the
yenta CardBus controller IRQ to whatever card he inserts.

Applies to version 0.9b of the sym53c500_cs driver, as included with
the 2.6.9 kernel.

Signed-off-by: Bob Tracy <rct@frus.com>

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------

--ELM781191431-21099-0_
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: attachment; filename=patch09_sym53c500

--- linux/drivers/scsi/pcmcia/sym53c500_cs.c.orig	Wed Jul  7 07:24:21 2004
+++ linux/drivers/scsi/pcmcia/sym53c500_cs.c	Wed Oct 27 22:21:20 2004
@@ -85,7 +85,7 @@
 module_param(pc_debug, int, 0);
 #define DEBUG(n, args...) if (pc_debug>(n)) printk(KERN_DEBUG args)
 static char *version =
-"sym53c500_cs.c 0.9b 2004/05/10 (Bob Tracy)";
+"sym53c500_cs.c 0.9c 2004/10/27 (Bob Tracy)";
 #else
 #define DEBUG(n, args...)
 #endif
@@ -95,7 +95,7 @@
 /* Parameters that can be set with 'insmod' */
 
 /* Bit map of interrupts to choose from */
-static unsigned int irq_mask = 0xdeb8;	/* 3, 6, 7, 9-12, 14, 15 */
+static unsigned int irq_mask = 0xdeb8;	/* 3-5, 7, 9-12, 14, 15 */
 static int irq_list[4] = { -1 };
 static int num_irqs = 1;
 
@@ -830,7 +830,7 @@
 	data = (struct sym53c500_data *)host->hostdata;
 
 	if (irq_level > 0) {
-		if (request_irq(irq_level, SYM53C500_intr, 0, "SYM53C500", host)) {
+		if (request_irq(irq_level, SYM53C500_intr, SA_SHIRQ, "SYM53C500", host)) {
 			printk("SYM53C500: unable to allocate IRQ %d\n", irq_level);
 			goto err_free_scsi;
 		}

--ELM781191431-21099-0_--
