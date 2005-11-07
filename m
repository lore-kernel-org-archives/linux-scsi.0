From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] [Merging ATA passthru] on integrating SMART/ATA-Security
 in usb-storage driver
Date: Mon, 7 Nov 2005 14:53:34 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0511071449560.5078-100000@iolanthe.rowland.org>
References: <20051107185718.GA16791@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:39627 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932325AbVKGTxf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Nov 2005 14:53:35 -0500
In-Reply-To: <20051107185718.GA16791@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: thomas schorpp <t.schorpp@gmx.de>, James Bottomley <James.Bottomley@SteelEye.com>, usb-storage@lists.one-eyed-alien.net, Timothy Thelin <Timothy.Thelin@wdc.com>, Linux SCSI list <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

On Mon, 7 Nov 2005, Patrick Mansfield wrote:

> On Mon, Nov 07, 2005 at 06:54:58PM +0100, thomas schorpp wrote:
> > Bus 004 Device 003: ID 04b4:6830 Cypress Semiconductor Corp. USB-2.0 IDE Adapter
> > Device Descriptor:
> >   bLength                18
> >   bDescriptorType         1
> >   bcdUSB               2.00
> >   bDeviceClass            0 (Defined at Interface level)
> >   bDeviceSubClass         0
> >   bDeviceProtocol         0
> >   bMaxPacketSize0        64
> >   idVendor           0x04b4 Cypress Semiconductor Corp.
> >   idProduct          0x6830 USB-2.0 IDE Adapter
> 
> So this is a USB to ATA/ATAPI bridge?
> 
> Can we trigger black listing based on the above vendor/product values?
> i.e. can you check for these values in usb-storage slave_configure code?

Yes.  The patch below illustrates how.  You'll have to change the name of 
the sdev flag to something sensible...

I firmly believe this is the wrong approach, however.  It's a specific 
solution to a general problem.  I would much prefer to add a new flag to 
struct request.

> Yeh, some other hardware might want lun inihibit in the future, and that
> could still be added back, but IMHO black list is better.

I'd say it's inevitable.  And it may even end up being standard-based, not 
vendor/product based.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/usb/storage/scsiglue.c
===================================================================
--- usb-2.6.orig/drivers/usb/storage/scsiglue.c
+++ usb-2.6/drivers/usb/storage/scsiglue.c
@@ -185,6 +185,13 @@ static int slave_configure(struct scsi_d
 	if (us->flags & US_FL_NOT_LOCKABLE)
 		sdev->lockable = 0;
 
+	/* SCSI-ATA pass-thru whitelist for Cypress chip */
+	if (le16_to_cpu(us->pusb_dev->descriptor.idVendor) == 
+				USB_VENDOR_ID_CYPRESS &&
+			le16_to_cpu(us->pusb_dev->descriptor.idProduct) ==
+				USB_PRODUCT_ID_CYPRESS_CY7C68320)
+		sdev->ata_passthru = 1;
+
 	/* this is to satisfy the compiler, tho I don't think the 
 	 * return code is ever checked anywhere. */
 	return 0;
Index: usb-2.6/drivers/usb/storage/usb.h
===================================================================
--- usb-2.6.orig/drivers/usb/storage/usb.h
+++ usb-2.6/drivers/usb/storage/usb.h
@@ -169,7 +169,10 @@ extern void fill_inquiry_response(struct
 #define scsi_lock(host)		spin_lock_irq(host->host_lock)
 
 
-/* Vendor ID list for devices that require special handling */
+/* Vendor/Product ID list for devices that require special handling */
 #define USB_VENDOR_ID_GENESYS		0x05e3	/* Genesys Logic */
 
+#define USB_VENDOR_ID_CYPRESS		0x04b4	/* Cypress Semiconductor */
+#define USB_PRODUCT_ID_CYPRESS_CY7C68320	0x6830
+
 #endif

