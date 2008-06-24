From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: 2.6.27-rc7-git1: usb-storage breakage with non-functional disk
Date: Tue, 24 Jun 2008 10:41:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0806241032490.2160-100000@iolanthe.rowland.org>
References: <200806232358.33602.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <200806232358.33602.rjw-KKrjLPT3xs0@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>
Cc: Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, USB development list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 23 Jun 2008, Rafael J. Wysocki wrote:

> On Monday, 23 of June 2008, R. J. Wysocki wrote:
> > [sorry for the broken USB list address in the original post.]
> 
> [and now my univeristy address instead of the usual one ...]
> 
> > On Monday, 23 of June 2008, Rafael J. Wysocki wrote:
> > > Hi,
> > > 
> > > This has just happened to me with -rc7-git1 while trying to use a not
> > > sufficiently powered external disk (we should survive that IMO):
> > > 
...
> > > scsi 12:0:0:0: Direct-Access     IC25N060 ATMR04-0         MO3O PQ: 0 ANSI: 0 CCS
> > > sd 12:0:0:0: [sdc] 117210240 512-byte hardware sectors (60012 MB)
> > > sd 12:0:0:0: [sdc] Write Protect is off
> > > sd 12:0:0:0: [sdc] Mode Sense: 00 14 00 00
> > > sd 12:0:0:0: [sdc] Assuming drive cache: write through
> > > sd 12:0:0:0: [sdc] 117210240 512-byte hardware sectors (60012 MB)
> > > sd 12:0:0:0: [sdc] Write Protect is off
> > > sd 12:0:0:0: [sdc] Mode Sense: 00 14 00 00
> > > sd 12:0:0:0: [sdc] Assuming drive cache: write through
> > >  sdc:<6>usb 2-1: USB disconnect, address 2
> > > sd 12:0:0:0: [sdc] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
> > > end_request: I/O error, dev sdc, sector 0
> > > Buffer I/O error on device sdc, logical block 0
> > > sd 12:0:0:0: [sdc] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
> > > end_request: I/O error, dev sdc, sector 0
> > > Buffer I/O error on device sdc, logical block 0
> > >  unable to read partition table
> > > sd 12:0:0:0: [sdc] Attached SCSI disk
> > > sd 12:0:0:0: Attached scsi generic sg3 type 0
> > > BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
> > > IP: [<ffffffffa038e6f1>] :usb_storage:slave_alloc+0x41/0x80
...
> > > It resulted in usb-storage being unusable and a system reboot.

This is a nasty problem.  What happened is that the endpoint pointer 
arrays ep_in and ep_out in struct usb_device get cleared before the 
device drivers' disconnect methods are called.  Since usb-storage 
dereferences one of the pointers in those arrays, you ended up with an 
invalid memory access.

In principle the arrays should not be cleared until after the drivers 
have been unbound.  However for now it is simpler to remove the 
dereference in usb-storage.  Especially since the reason for adding it 
in the first place turned out to be wrong.

Is this oops fairly reproducible?  If it is, then you should be able to 
test whether this patch fixes it.

Alan Stern



Index: usb-2.6/drivers/usb/storage/scsiglue.c
===================================================================
--- usb-2.6.orig/drivers/usb/storage/scsiglue.c
+++ usb-2.6/drivers/usb/storage/scsiglue.c
@@ -71,7 +71,6 @@ static const char* host_info(struct Scsi
 static int slave_alloc (struct scsi_device *sdev)
 {
 	struct us_data *us = host_to_us(sdev->host);
-	struct usb_host_endpoint *bulk_in_ep;
 
 	/*
 	 * Set the INQUIRY transfer length to 36.  We don't use any of
@@ -80,16 +79,22 @@ static int slave_alloc (struct scsi_devi
 	 */
 	sdev->inquiry_len = 36;
 
-	/* Scatter-gather buffers (all but the last) must have a length
-	 * divisible by the bulk maxpacket size.  Otherwise a data packet
-	 * would end up being short, causing a premature end to the data
-	 * transfer.  We'll use the maxpacket value of the bulk-IN pipe
-	 * to set the SCSI device queue's DMA alignment mask.
+	/* USB has unusual DMA-alignment requirements: Although the
+	 * starting address of each scatter-gather element doesn't matter,
+	 * the length of each element except the last must be divisible
+	 * by the Bulk maxpacket value.  There's currently no way to
+	 * express this by block-layer constraints, so we'll cop out
+	 * and simply require addresses to be aligned at 512-byte
+	 * boundaries.  This is okay since most block I/O involves
+	 * hardware sectors that are multiples of 512 bytes in length,
+	 * and since host controllers up through USB 2.0 have maxpacket
+	 * values no larger than 512.
+	 *
+	 * But it doesn't suffice for Wireless USB, where Bulk maxpacket
+	 * values can be as large as 2048.  To make that work properly
+	 * will require changes to the block layer.
 	 */
-	bulk_in_ep = us->pusb_dev->ep_in[usb_pipeendpoint(us->recv_bulk_pipe)];
-	blk_queue_update_dma_alignment(sdev->request_queue,
-			le16_to_cpu(bulk_in_ep->desc.wMaxPacketSize) - 1);
-			/* wMaxPacketSize must be a power of 2 */
+	blk_queue_update_dma_alignment(sdev->request_queue, (512 - 1));
 
 	/*
 	 * The UFI spec treates the Peripheral Qualifier bits in an

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
