From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] fix check_region usage in eata_pio
Date: Wed, 2 Jun 2004 09:24:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD51AC@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:19637 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262766AbUFBNYr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jun 2004 09:24:47 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>, Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

As one of the engineers that developed this card, the EATA ISA cards
take 9 bytes of accessible space. I strongly recommend this patch since
taking 8 carries with it risks.

The EISA and PCI cards took 32 and 16 bytes respectively though, which
should not be a problem since these are (BIOS) managed resources. The
PCI card when forced to occupy ISA addresses (170 and 1F0) typically did
not collide with other ISA resources since most cards occupy several
registers on even boundaries and could not be placed into the touchy +9
to +15 region. 

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Randy.Dunlap
Sent: Tuesday, June 01, 2004 6:56 PM
To: Christoph Hellwig
Cc: jejb@steeleye.com; linux-scsi@vger.kernel.org
Subject: Re: [PATCH] fix check_region usage in eata_pio

On Mon, 31 May 2004 14:00:10 +0200 Christoph Hellwig wrote:

| I'd love to rework the init sequence a bit more, but without beeing
able
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


diff -Naurp ./drivers/scsi/eata_pio.c~eata_region
./drivers/scsi/eata_pio.c
--- ./drivers/scsi/eata_pio.c~eata_region	2004-06-01
15:13:25.000000000 -0700
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
 					DBG(DBG_PROBE && DBG_EISA,
print_pio_config(buf));
 					if (buf->IRQ) {
 						if
(!register_pio_HBA(base, buf, tpnt))
-
release_region(base, 8);
+
release_region(base, 9);
 					} else {
 						printk(KERN_NOTICE
"eata_dma: No valid IRQ. HBA " "removed from list\n");
-						release_region(base, 8);
+						release_region(base, 9);
 					}
 				}
 				/* Nothing found here so we take it from
the list */
@@ -900,7 +900,7 @@ static void find_pio_PCI(struct get_conf
 			/* We didn't find it in the primary search */
 			if (get_pio_conf_PIO(base, buf)) {
 				if (buf->FORCADR) {	/* If the
address is forced */
-					release_region(base, 8);
+					release_region(base, 9);
 					continue;	/* we'll find it
later      */
 				}
 
@@ -910,7 +910,7 @@ static void find_pio_PCI(struct get_conf
 				 */
 
 				if (!register_pio_HBA(base, buf, tpnt))
{
-					release_region(base, 8);
+					release_region(base, 9);
 					continue;
 				}
 
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
