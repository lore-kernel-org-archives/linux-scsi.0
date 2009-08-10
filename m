From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Bugs in scsi_vpd_inquiry()
Date: Mon, 10 Aug 2009 17:14:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908101707230.4223-100000@iolanthe.rowland.org>
References: <yq13a7zfl7y.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:48082 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753216AbZHJVOi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2009 17:14:38 -0400
In-Reply-To: <yq13a7zfl7y.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 10 Aug 2009, Martin K. Petersen wrote:

> >>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:
> 
> >> First of all we're not going to send EVPD=1 out to devices reporting
> >> SCSI_SPC_2 or lower anymore, making some of this discussion moot in
> >> the short term.
> 
> Alan> Ah.  Has this change been posted anywhere yet?
> 
> ffd4bc2a984fab40ed969163efdff321490e8032

Looks good, thanks.

> But let's assume for a second that USB drives with 4KB physical blocks
> will be USB 3.0.  I think that's a likely scenario.  Couldn't we do
> something like?
> 
>    /* Dumb down SCSI level for USB 1.1 and 2.0 devices */
>    if (le16_to_cpu(udev->descriptor.bcdUSB) <= 0x0200 
>        && sdev->scsi_level > SCSI_2)
>           sdev->sdev_target->scsi_level = sdev->scsi_level = SCSI_2;
> 
> I'm sure that won't catch all devices.  But it would at least be a step
> in the right direction.  And if that breaks we can revisit.

That's a good idea.  At least it won't break any existing devices, 
although some new ones may fail.


> Alan> Even worse, the device-reported SCSI rev. is completely
> Alan> independent of the ID for the bridge chip, which is where the
> Alan> failures seem to occur.  (Although it's hard to be certain which
> Alan> component is failing.)
> 
> If the bridge doesn't provide the SCSI rev. where does it come from?  Or
> are you saying there's a USB "target" chip and then a USB-SATA bridge
> chip behind it?

There's the bridge chip and the drive itself.  The drive provides the 
INQUIRY data and the chip provides the USB identifiers.

The same bridge chip can be used with lots of different drives.  In
fact, you can buy a USB-(S)ATA converter and plug it into whatever
drives you have lying around.

> Alan> I'm not keen on the idea of collecting more failure data by
> Alan> changing the driver so as to cause failures!
> 
> I wasn't thinking a hard fail.  More like a:
> 
>   printk(KERN_ERR "Please mail this info to linux-scsi@vger...");
> 
> and have that sit in Fedora/Ubuntu for 6 months.
> 
> But if there's nothing we can key off of then there's no point.

About the only thing to key off of is failure of the device when we 
send it a REPORT LUNS command.  :-(

Alan Stern

