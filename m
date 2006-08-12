From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: dc395x: Report
Date: Sat, 12 Aug 2006 20:06:46 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0608092315060.3728@poirot.grange>
References: <44CF40F2.3080401@annessi.at> <Pine.LNX.4.60.0608020046510.8659@poirot.grange>
 <44D075A2.2080501@annessi.at> <Pine.LNX.4.60.0608021209310.5115@poirot.grange>
 <44D0BC2F.3030700@annessi.at> <Pine.LNX.4.60.0608022348570.12263@poirot.grange>
 <44D13418.2000005@annessi.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:39634 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S932465AbWHLSGr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Aug 2006 14:06:47 -0400
In-Reply-To: <44D13418.2000005@annessi.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Annessi <robert@annessi.at>
Cc: linux-scsi@vger.kernel.org

Sorry, was on a holiday...

On Thu, 3 Aug 2006, Robert Annessi wrote:

> dc395x: Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08
> PCI: setting IRQ 11 as level-triggered
> PCI: Found IRQ 11 for device 0000:00:02.0
> dc395x: Used settings: AdapterID=07, Speed=0(20.0MHz), dev_mode=0x37
> dc395x:                AdaptMode=0x4e, Tags=0(01), DelayReset=1s
> dc395x: (Wide) Connectors: int68  Termination: Auto Low High
> dc395x: Performing initial SCSI bus reset
> scsi0 : Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08
> dc395x: Target 00: Wide16 Sync: 48ns Offset 15 (41.7 MB/s)
>   Vendor: SEAGATE   Model: ST3146807LC       Rev: 0007
>   Type:   Direct-Access                      ANSI SCSI revision: 03
> SCSI device sda: 286749488 512-byte hdwr sectors (146816 MB)
> dc395x: inconsistent counters: FIFOCNT 64, left 16777215, wide

Ok, "left 16777215" = 0xffffff, which means we have read 0x01000000 from 
TRM_S1040_SCSI_COUNTER. There's a comment in the driver: 
".....TRM_S1040_SCSI_COUNTER (24bits)"

> > Well, this looks much better to me. So, I think, we may say for you the 
> > problem is solved. Globally, I think, the reason why other drivers have no 
> 
> For me the problem is definetely solved. Thank you!

Great, maybe you still could test the patch below (applied on the top of 
all my patches until now)?

Thanks
Guennadi
---
Guennadi Liakhovetski

--- drivers/scsi/dc395x.c-20060811	2006-08-12 19:56:50.000000000 +0200
+++ drivers/scsi/dc395x.c	2006-08-12 20:01:42.000000000 +0200
@@ -2123,7 +2123,7 @@
 		 */
 		if (srb->total_xfer_length > DC395x_LASTPIO)
 			d_left_counter +=
-			    DC395x_read32(acb, TRM_S1040_SCSI_COUNTER);
+			    DC395x_read32(acb, TRM_S1040_SCSI_COUNTER) & ((1 << 24) - 1);
 
 		/* Is this a good idea? */
 		/*clear_fifo(acb, "DOP1"); */
@@ -2253,7 +2253,7 @@
 				DC395x_read8(acb, TRM_S1040_DMA_FIFOSTAT));
 		}
 		/* Now: Check remainig data: The SCSI counters should tell us ... */
-		sc = DC395x_read32(acb, TRM_S1040_SCSI_COUNTER);
+		sc = DC395x_read32(acb, TRM_S1040_SCSI_COUNTER) & ((1 << 24) - 1);
 		fc = DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT);
 		d_left_counter = sc + ((fc & 0x1f)
 		       << ((srb->dcb->sync_period & WIDE_SYNC) ? 1 :
@@ -2307,6 +2307,14 @@
 
 				while (len) {
 					u8 byte;
+
+					fc = DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT);
+
+					if (fc == 0x40) {
+						left_io = 0;
+						break;
+					}
+
 					byte = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
 					*virt++ = byte;
 
@@ -2317,13 +2325,6 @@
 					sg_subtract_one(srb);
 
 					len--;
-
-					fc = DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT);
-
-					if (fc == 0x40) {
-						left_io = 0;
-						break;
-					}
 				}
 
 				if (((fc != 0x40) && !d_left_counter) ||
