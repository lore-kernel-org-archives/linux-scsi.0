From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] fix check_region usage in eata_pio
Date: Tue, 1 Jun 2004 15:56:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040601155626.1ac76ff3.rddunlap@osdl.org>
References: <20040531120010.GA16293@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:20174 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S265276AbUFAXHq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2004 19:07:46 -0400
In-Reply-To: <20040531120010.GA16293@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Mon, 31 May 2004 14:00:10 +0200 Christoph Hellwig wrote:

| I'd love to rework the init sequence a bit more, but without beeing able
| to actually test the driver I'd rather stick to the bulletproof fix.
| 
| 
| --- 1.21/drivers/scsi/eata_pio.c	2003-08-16 16:01:30 +02:00
| +++ edited/drivers/scsi/eata_pio.c	2004-05-31 13:30:48 +02:00
| @@ -593,14 +593,14 @@
|  	int z;
|  	unsigned short *p;
|  
| -	if (check_region(base, 9))
| -		return (FALSE);
| +	if (!request_region(base, 8, "eata_pio"))
| +		return 0;
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Using region size of 8 instead of 9 caught my eye.
The driver isn't very consistent about it.
However, "eata_generic.h" says that there is a register
at offset 8 and the code does inb() on that register,
so region size (apparently) should be 9.

Here's an update that applies on top of Christoph's patch.

--
~Randy


Based on "eata_generic.h", this SCSI controller has 9 bytes of IO
space, not 8, so update request_region(), release_region(), and
n_io_port to use 9 instead of 8.

diffstat:=
 drivers/scsi/eata_pio.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)


diff -Naurp ./drivers/scsi/eata_pio.c~eata_region ./drivers/scsi/eata_pio.c
--- ./drivers/scsi/eata_pio.c~eata_region	2004-06-01 15:13:25.000000000 -0700
+++ ./drivers/scsi/eata_pio.c	2004-06-01 15:29:30.000000000 -0700
@@ -593,7 +593,7 @@ static int get_pio_conf_PIO(u32 base, st
 	int z;
 	unsigned short *p;
 
-	if (!request_region(base, 8, "eata_pio"))
+	if (!request_region(base, 9, "eata_pio"))
 		return 0;
 
 	memset(buf, 0, sizeof(struct get_conf));
@@ -641,7 +641,7 @@ static int get_pio_conf_PIO(u32 base, st
 	return 1;
 
  fail:
-	release_region(base, 8);
+	release_region(base, 9);
 	return 0;
 }
 
@@ -784,7 +784,7 @@ static int register_pio_HBA(long base, s
 	sh->unique_id = base;
 	sh->base = base;
 	sh->io_port = base;
-	sh->n_io_port = 8;
+	sh->n_io_port = 9;
 	sh->irq = gc->IRQ;
 	sh->dma_channel = PIO;
 	sh->this_id = gc->scsi_id[3];
@@ -825,7 +825,7 @@ static void find_pio_ISA(struct get_conf
 		if (!get_pio_conf_PIO(ISAbases[i], buf))
 			continue;
 		if (!register_pio_HBA(ISAbases[i], buf, tpnt))
-			release_region(ISAbases[i], 8);
+			release_region(ISAbases[i], 9);
 		else
 			ISAbases[i] = 0;
 	}
@@ -857,10 +857,10 @@ static void find_pio_EISA(struct get_con
 					DBG(DBG_PROBE && DBG_EISA, print_pio_config(buf));
 					if (buf->IRQ) {
 						if (!register_pio_HBA(base, buf, tpnt))
-							release_region(base, 8);
+							release_region(base, 9);
 					} else {
 						printk(KERN_NOTICE "eata_dma: No valid IRQ. HBA " "removed from list\n");
-						release_region(base, 8);
+						release_region(base, 9);
 					}
 				}
 				/* Nothing found here so we take it from the list */
@@ -900,7 +900,7 @@ static void find_pio_PCI(struct get_conf
 			/* We didn't find it in the primary search */
 			if (get_pio_conf_PIO(base, buf)) {
 				if (buf->FORCADR) {	/* If the address is forced */
-					release_region(base, 8);
+					release_region(base, 9);
 					continue;	/* we'll find it later      */
 				}
 
@@ -910,7 +910,7 @@ static void find_pio_PCI(struct get_conf
 				 */
 
 				if (!register_pio_HBA(base, buf, tpnt)) {
-					release_region(base, 8);
+					release_region(base, 9);
 					continue;
 				}
 
