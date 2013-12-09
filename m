From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: CONFIG_SCSI_MULTI_LUN default
Date: Mon, 9 Dec 2013 15:25:22 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1312091459330.1439-100000@iolanthe.rowland.org>
References: <1386617756.2028.104.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:39904 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753970Ab3LIUZX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2013 15:25:23 -0500
In-Reply-To: <1386617756.2028.104.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 9 Dec 2013, James Bottomley wrote:

> On Mon, 2013-12-09 at 14:28 -0500, Alan Stern wrote:
> > On Mon, 9 Dec 2013, James Bottomley wrote:
> > 
> > > On Mon, 2013-12-09 at 13:24 -0500, Alan Stern wrote:
> > > > James:
> > > > 
> > > > Is there any good reason why CONFIG_SCSI_MULTI_LUN still doesn't 
> > > > default to Y?
> > > 
> > > Assuming we've got all the screw ups (mostly CD ROMS) blacklisted, I
> > > think the only real reason is that some SCSI-2 devices don't respond to
> > > stuff not on LUN 0, so it keeps the boot process quick.
> > > 
> > > There isn't really any reason to change it, though, is there?  The
> > > option only applies to SCSI-2 and below devices which should be a self
> > > obsoleting class as their motors start to burn out.
> > 
> > I'm asking because every now and then we hear from somebody who built a
> > kernel without SCSI_MULTI_LUN and then doesn't understand why his USB
> > card reader seems to support only one type of card.  (The interfaces
> > for different digital card types typically are presented as different
> > logical units on USB card readers.)
> > 
> > This isn't a big deal; if boot-up time is a real reason for not
> > defaulting to Y, that's fine.
> 
> How about we fix this in another way?  If you can identify the class of
> devices which constitute card readers can't we just set BLIST_FORCELUN
> for them.  That way the config option can continue to die.

All right, how does this patch look?  us->max_lun gets set before we
call scsi_scan_host(), and devices with protocol equal to US_PR_BULK
actually tell us how many LUNs they have.  (Devices with other protocol
values may have more than one LUN, but they don't tell us.  These other
protocols are pactically never used nowadays, and I want to avoid
regressions on older equipment.)

Alan Stern



Index: usb-3.13/drivers/usb/storage/scsiglue.c
===================================================================
--- usb-3.13.orig/drivers/usb/storage/scsiglue.c
+++ usb-3.13/drivers/usb/storage/scsiglue.c
@@ -78,6 +78,8 @@ static const char* host_info(struct Scsi
 
 static int slave_alloc (struct scsi_device *sdev)
 {
+	struct us_data *us = host_to_us(sdev->host);
+
 	/*
 	 * Set the INQUIRY transfer length to 36.  We don't use any of
 	 * the extra data and many devices choke if asked for more or
@@ -102,6 +104,10 @@ static int slave_alloc (struct scsi_devi
 	 */
 	blk_queue_update_dma_alignment(sdev->request_queue, (512 - 1));
 
+	/* Tell the SCSI layer if we know there is more than one LUN */
+	if (us->protocol == USB_PR_BULK && us->max_lun > 0)
+		sdev->sdev_bflags = BLIST_FORCELUN;
+
 	return 0;
 }
 

