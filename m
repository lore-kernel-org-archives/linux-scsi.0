From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: dc395x: can't write to tape
Date: Sun, 9 Jan 2005 12:42:26 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0501091238010.3910@poirot.grange>
References: <200501060518.25782.andrex@alumni.utexas.net>
 <Pine.LNX.4.60.0501062138580.7568@poirot.grange> <20050109053342.GA5799@twibble.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:7809 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261183AbVAILnI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Jan 2005 06:43:08 -0500
In-Reply-To: <20050109053342.GA5799@twibble.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jamie Lenehan <lenehan@twibble.org>
Cc: Andrew Schulman <andrex@alumni.utexas.net>, linux-scsi@vger.kernel.org

On Sun, 9 Jan 2005, Jamie Lenehan wrote:

> On Thu, Jan 06, 2005 at 10:48:38PM +0100, Guennadi Liakhovetski wrote:
> [...]
> > > Jan  5 22:50:18 helium kernel: dc395x: sg_update_list: sg_to_virt failed
> > 
> > This doesn't look good. However, after a brief look at the code, I cannot 
> > say what exactly went wrong there. Jamie?
> 
> This messages has been happening in the driver for ever for some
> people (mos tlikely related to specific devices they are using?). I

I think, the search createria are wrong. Possibly, the following would be 
better:

Index: drivers/scsi/dc395x.c
===================================================================
RCS file: /usr/src/cvs/linux-2_6/drivers/scsi/dc395x.c,v
retrieving revision 1.1.1.4
diff -u -r1.1.1.4 dc395x.c
--- drivers/scsi/dc395x.c	17 Nov 2004 21:04:51 -0000	1.1.1.4
+++ drivers/scsi/dc395x.c	9 Jan 2005 11:36:17 -0000
@@ -2004,9 +2004,7 @@
 	/* We have to walk the scatterlist to find it */
 	sg = (struct scatterlist *)cmd->request_buffer;
 	while (segment--) {
-		unsigned long mask =
-		    ~((unsigned long)sg->length - 1) & PAGE_MASK;
-		if ((sg_dma_address(sg) & mask) == (psge->address & mask)) {
+		if (sg_dma_address(sg) <= psge->address && sg_dma_address(sg) + psge->length > psge->address) {
 			srb->virt_addr = (page_address(sg->page)
 					   + psge->address -
 					   (psge->address & PAGE_MASK));

(untested). Andrew, could you test?

> believe the sg_to_virt thing is trying to convert from the bus
> address back to the virtual address to be able to recaculate the
> position for the next transfer after a partial transfer. I've never
> been able to actually reproduce this specific problem myself.

The driver is full of "hardware bug workarounds". Jamie, are those PIO 
operations really needed? Do you ever see, that DMA doesn't transfer the 
last 1-3 bytes of the segment?

> All the s/g list handling stuff really needs to be re-written. I'm
> certain that it's not high-mem safe and another rather nasty thing is
> that it modifies the sg lists after dma mapping them in some
> situations which isn't really on (and seems to be the cause of the
> hangs I see when running on sparc64 with some additional patches I
> have to support big endien machines.)

I could try to improve the highmem situation / sg-handling. Or do you plan 
to do it, Jamie?

Thanks
Guennadi
---
Guennadi Liakhovetski

