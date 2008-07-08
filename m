From: "Indan Zupancic" <indan@nul.nu>
Subject: Re: 2.6.27-rc7-git1: usb-storage breakage with non-functional disk
Date: Tue, 8 Jul 2008 15:00:30 +0200 (CEST)
Message-ID: <13988.84.245.32.19.1215522030.squirrel@secure.samage.net>
References: <Pine.LNX.4.44L0.0806241032490.2160-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smarthost1.greenhost.nl ([85.17.153.87]:43559 "EHLO
	smarthost1.samage.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbYGHNWx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jul 2008 09:22:53 -0400
In-Reply-To: <Pine.LNX.4.44L0.0806241032490.2160-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB development list <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

Hello,

On Tue, June 24, 2008 16:41, Alan Stern wrote:
> This is a nasty problem.  What happened is that the endpoint pointer
> arrays ep_in and ep_out in struct usb_device get cleared before the
> device drivers' disconnect methods are called.  Since usb-storage
> dereferences one of the pointers in those arrays, you ended up with an
> invalid memory access.
>
> In principle the arrays should not be cleared until after the drivers
> have been unbound.  However for now it is simpler to remove the
> dereference in usb-storage.  Especially since the reason for adding it
> in the first place turned out to be wrong.
>
> Is this oops fairly reproducible?  If it is, then you should be able to
> test whether this patch fixes it.
>
> Alan Stern
>
>
>
> Index: usb-2.6/drivers/usb/storage/scsiglue.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/storage/scsiglue.c
> +++ usb-2.6/drivers/usb/storage/scsiglue.c
> @@ -71,7 +71,6 @@ static const char* host_info(struct Scsi
>  static int slave_alloc (struct scsi_device *sdev)
>  {
>  	struct us_data *us = host_to_us(sdev->host);
> -	struct usb_host_endpoint *bulk_in_ep;
>
>  	/*
>  	 * Set the INQUIRY transfer length to 36.  We don't use any of
> @@ -80,16 +79,22 @@ static int slave_alloc (struct scsi_devi
>  	 */
>  	sdev->inquiry_len = 36;
>
> -	/* Scatter-gather buffers (all but the last) must have a length
> -	 * divisible by the bulk maxpacket size.  Otherwise a data packet
> -	 * would end up being short, causing a premature end to the data
> -	 * transfer.  We'll use the maxpacket value of the bulk-IN pipe
> -	 * to set the SCSI device queue's DMA alignment mask.
> +	/* USB has unusual DMA-alignment requirements: Although the
> +	 * starting address of each scatter-gather element doesn't matter,
> +	 * the length of each element except the last must be divisible
> +	 * by the Bulk maxpacket value.  There's currently no way to
> +	 * express this by block-layer constraints, so we'll cop out
> +	 * and simply require addresses to be aligned at 512-byte
> +	 * boundaries.  This is okay since most block I/O involves
> +	 * hardware sectors that are multiples of 512 bytes in length,
> +	 * and since host controllers up through USB 2.0 have maxpacket
> +	 * values no larger than 512.
> +	 *
> +	 * But it doesn't suffice for Wireless USB, where Bulk maxpacket
> +	 * values can be as large as 2048.  To make that work properly
> +	 * will require changes to the block layer.
>  	 */
> -	bulk_in_ep = us->pusb_dev->ep_in[usb_pipeendpoint(us->recv_bulk_pipe)];
> -	blk_queue_update_dma_alignment(sdev->request_queue,
> -			le16_to_cpu(bulk_in_ep->desc.wMaxPacketSize) - 1);
> -			/* wMaxPacketSize must be a power of 2 */
> +	blk_queue_update_dma_alignment(sdev->request_queue, (512 - 1));
>
>  	/*
>  	 * The UFI spec treates the Peripheral Qualifier bits in an
>

I hit almost the same BUG, so tried out this patch, and can confirm that
it fixes the BUG. Other devices still work too. As it's 2.6.26-rc9 it might
be time to send this patch upstream, before it's too late.

Any idea why my cardreader doesn't work in the first place though?

The error is basically:

usb 1-5: new high speed USB device using ehci_hcd and address 22
usb 1-5: device not accepting address 22, error -71
usb 1-5: new high speed USB device using ehci_hcd and address 23
usb 1-5: configuration #1 chosen from 1 choice
scsi17 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 23
usb-storage: waiting for device to settle before scanning
usb 1-5: reset high speed USB device using ehci_hcd and address 23
usb 1-5: reset high speed USB device using ehci_hcd and address 23
usb 1-5: reset high speed USB device using ehci_hcd and address 23
scsi 17:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
usb 1-5: reset high speed USB device using ehci_hcd and address 23
usb 1-5: device not accepting address 23, error -71
usb 1-5: reset high speed USB device using ehci_hcd and address 23
usb 1-5: reset high speed USB device using ehci_hcd and address 23
usb 1-5: reset high speed USB device using ehci_hcd and address 23
usb 1-5: reset high speed USB device using ehci_hcd and address 23
usb 1-5: can't restore configuration #1 (error=-71)
usb 1-5: USB disconnect, address 23
sd 17:0:0:0: [sdb] READ CAPACITY failed
sd 17:0:0:0: [sdb] Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK,SUGGEST_OK
sd 17:0:0:0: [sdb] Sense not available.
sd 17:0:0:0: [sdb] Write Protect is off
sd 17:0:0:0: [sdb] Mode Sense: 00 00 00 00
sd 17:0:0:0: [sdb] Assuming drive cache: write through
sd 17:0:0:0: [sdb] Attached SCSI removable disk
sd 17:0:0:0: Attached scsi generic sg2 type 0
usb-storage: device scan complete
usb 1-5: new high speed USB device using ehci_hcd and address 24
usb 1-5: string descriptor 0 read error: -71
usb 1-5: configuration #1 chosen from 1 choice
usb 1-5: can't set config #1, error -71

It's a new Trust Mini Cardreader, model CR-1350p.

$ lsusb -s 24 -v

Bus 001 Device 024: ID 058f:6332 Alcor Micro Corp.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x058f Alcor Micro Corp.
  idProduct          0x6332
  bcdDevice            1.02
  iManufacturer           1
  iProduct                2
  iSerial                 3
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass         8 Mass Storage
      bInterfaceSubClass      6 SCSI
      bInterfaceProtocol     80 Bulk (Zip)
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0

It doesn't matter in which port I put the thing (front, back),
and I've tried older kernels too (2.6.12), but I get the same
error there. This is with an Intel 945G chipset.
(I've no Windows to test if it works there.)

Is it just a crappy device which I should bring back, or is
there more going on?

Greetings,

Indan


