From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] NCR_Q720: fix init/exit section usage
Date: Thu, 6 Jan 2005 23:02:44 -0800
Message-ID: <20050106230244.296c78ee.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:10422 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261290AbVAGHOp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jan 2005 02:14:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb <james.bottomley@steeleye.com>
Cc: scsi <linux-scsi@vger.kernel.org>


Fix init & exit section usage, stemming from this diagnostic
(from reference_discarded.pl == make buildcheck):
Error: ./drivers/scsi/NCR_Q720.o .data refers to 0000010c R_386_32          .exit.text

Signed-off-by: Randy Dunlap <rddunlap@osdl.org>

diffstat:=
 drivers/scsi/NCR_Q720.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff -Naurp ./drivers/scsi/NCR_Q720.c~ncr_q720_devexit ./drivers/scsi/NCR_Q720.c
--- ./drivers/scsi/NCR_Q720.c~ncr_q720_devexit	2004-12-24 13:34:00.000000000 -0800
+++ ./drivers/scsi/NCR_Q720.c	2005-01-06 21:54:59.387367256 -0800
@@ -22,7 +22,7 @@
 
 #include "NCR_Q720.h"
 
-static struct ncr_chip q720_chip __initdata = {
+static struct ncr_chip q720_chip = {
 	.revision_id =	0x0f,
 	.burst_max =	3,
 	.offset_max =	8,
@@ -73,7 +73,7 @@ NCR_Q720_intr(int irq, void *data, struc
 	return IRQ_HANDLED;
 }
 
-static int __init
+static int __devinit
 NCR_Q720_probe_one(struct NCR_Q720_private *p, int siop,
 		int irq, int slot, __u32 paddr, void __iomem *vaddr)
 {
@@ -134,7 +134,7 @@ NCR_Q720_probe_one(struct NCR_Q720_priva
  * essentially connectecd to the MCA bus independently, it is easier
  * to set them up as two separate host adapters, rather than one
  * adapter with two channels */
-static int __init
+static int __devinit
 NCR_Q720_probe(struct device *dev)
 {
 	struct NCR_Q720_private *p;
@@ -319,14 +319,14 @@ NCR_Q720_probe(struct device *dev)
 	return -ENODEV;
 }
 
-static void __exit
+static void __devexit
 NCR_Q720_remove_one(struct Scsi_Host *host)
 {
 	scsi_remove_host(host);
 	ncr53c8xx_release(host);
 }
 
-static int __exit
+static int __devexit
 NCR_Q720_remove(struct device *dev)
 {
 	struct NCR_Q720_private *p = dev_get_drvdata(dev);


---
