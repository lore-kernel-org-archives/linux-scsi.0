From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: atomic_kmap for PIO (was Re: Fw: Kernel panic with dc395x in
 2.6.12.2)
Date: Tue, 13 Sep 2005 18:56:04 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0509131852360.7665@poirot.grange>
References: <20050709175725.75f291bf.rdunlap@xenotime.net>  <42E03506.7030707@drzeus.cx>
 <42E17451.6090706@drzeus.cx>  <20050722153651.28d5db51.rdunlap@xenotime.net>
 <42E17772.3020903@drzeus.cx>  <20050723100945.7d43d063.rdunlap@xenotime.net>
 <42E2933C.4050808@drzeus.cx>  <20050723152714.4212ba52.rdunlap@xenotime.net>
 <42E2ECF1.8070501@drzeus.cx>  <20050723184014.49629f9e.rdunlap@xenotime.net>
 <42E39462.3040007@drzeus.cx>  <20050724100153.3e891484.rdunlap@xenotime.net>
 <42E565FE.4070708@drzeus.cx>  <20050725203133.3cfa650d.rdunlap@xenotime.net>
 <42E6A5C3.6070501@drzeus.cx>  <20050726202058.133382c1.rdunlap@xenotime.net>
 <42E964CC.5060600@drzeus.cx>  <20050728201339.216ab3b8.rdunlap@xenotime.net>
 <42F37893.30006@drzeus.cx>  <Pine.LNX.4.60.0508070003520.10832@poirot.grange>
  <42F5FCBF.7080902@drzeus.cx>  <Pine.LNX.4.60.0508072214240.7539@poirot.grange>
  <Pine.LNX.4.60.0509052241
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:45027 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S964893AbVIMQ5P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 12:57:15 -0400
In-Reply-To: <1126580941.4825.8.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 12 Sep 2005, James Bottomley wrote:

> On Mon, 2005-09-05 at 23:50 +0200, Guennadi Liakhovetski wrote:
> > 
> > 2) try to find some beta-testers by applying something like the below:
> 
> OK, why don't we do this.  I'll put it into scsi-misc-2.6; that will
> queue it for 2.6.14 and also put it in -mm.  It will probably be a month
> at least before scsi-misc-2.6 goes into 2.6.14, so you have until that
> time to find problems in it and back it out ...

You mean option 2? Then, please, take the one below - it will not give 
false positives on dc395x.

Thanks
Guennadi
---
Guennadi Liakhovetski

Index: linux-2_6/drivers/scsi/dc395x.c
===================================================================
RCS file: /usr/src/cvs/linux-2_6/drivers/scsi/dc395x.c,v
retrieving revision 1.1.1.8
diff -u -p -r1.1.1.8 dc395x.c
--- linux-2_6/drivers/scsi/dc395x.c	2 Sep 2005 19:16:29 -0000	1.1.1.8
+++ linux-2_6/drivers/scsi/dc395x.c	5 Sep 2005 20:38:23 -0000
@@ -976,6 +976,16 @@
 	}
 }
 
+static void pio_trigger(void)
+{
+	static int feedback_requested;
+
+	if (!feedback_requested) {
+		feedback_requested = 1;
+		printk(KERN_WARNING "%s: Please, contact <linux-scsi@vger.kernel.org> "
+		       "to help improve support for your system.\n", __FILE__);
+	}
+}
 
 /* Prepare SRB for being sent to Device DCB w/ command *cmd */
 static void build_srb(struct scsi_cmnd *cmd, struct DeviceCtlBlk *dcb,
@@ -2320,6 +2330,7 @@
 					      CFG2_WIDEFIFO);
 			while (DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) != 0x40) {
 				u8 byte = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
+				pio_trigger();
 				*(srb->virt_addr)++ = byte;
 				if (debug_enabled(DBG_PIO))
 					printk(" %02x", byte);
@@ -2331,6 +2342,7 @@
                 /* Read the last byte ... */
 				if (srb->total_xfer_length > 0) {
 					u8 byte = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
+					pio_trigger();
 					*(srb->virt_addr)++ = byte;
 					srb->total_xfer_length--;
 					if (debug_enabled(DBG_PIO))
@@ -2507,6 +2519,7 @@
 				if (debug_enabled(DBG_PIO))
 					printk(" %02x", (unsigned char) *(srb->virt_addr));
 
+				pio_trigger();
 				DC395x_write8(acb, TRM_S1040_SCSI_FIFO, 
 				     *(srb->virt_addr)++);
 
Index: linux-2_6/drivers/scsi/tmscsim.c
===================================================================
RCS file: /usr/src/cvs/linux-2_6/drivers/scsi/tmscsim.c,v
retrieving revision 1.1.1.9
diff -u -p -r1.1.1.9 tmscsim.c
--- linux-2_6/drivers/scsi/tmscsim.c	2 Sep 2005 19:16:29 -0000	1.1.1.9
+++ linux-2_6/drivers/scsi/tmscsim.c	5 Sep 2005 20:38:31 -0000
@@ -989,6 +989,14 @@ din_1:
 	    if( residual )
 	    {
 		bval = DC390_read8 (ScsiFifo);	    /* get one residual byte */
+		static int feedback_requested;
+
+		if (!feedback_requested) {
+			feedback_requested = 1;
+			printk(KERN_WARNING "%s: Please, contact <linux-scsi@vger.kernel.org> "
+			       "to help improve support for your system.\n", __FILE__);
+		}
+
 		ptr = (u8 *) bus_to_virt( pSRB->SGBusAddr );
 		*ptr = bval;
 		pSRB->SGBusAddr++; xferCnt++;
