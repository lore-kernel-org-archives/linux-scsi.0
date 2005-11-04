From: "Timothy Thelin" <Timothy.Thelin@wdc.com>
Subject: RE: [usb-storage] [Merging ATA passthru] on integratingSMART/ATA-Security in usb-storage driver
Date: Fri, 4 Nov 2005 11:59:41 -0800
Message-ID: <CA45571DE57E1C45BF3552118BA92C9D69BF40@WDSCEXBECL03.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wdscexfe02.sc.wdc.com ([129.253.170.52]:58593 "EHLO
	wdscexfe02.sc.wdc.com") by vger.kernel.org with ESMTP
	id S1750745AbVKDT7q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2005 14:59:46 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, t.schorpp@gmx.de, usb-storage@lists.one-eyed-alien.net, linux-ide@vger.kernel.org, Linux SCSI list <linux-scsi@vger.kernel.org>

> 
> On Fri, 2005-11-04 at 10:30 -0800, Timothy Thelin wrote:
> > And for an even more concrete example:
> > The CY7C68300B cypress bridge board (has various siblings as well
> > on their site that act very similar) implements SCSI spec 0 (ie it
> > doesn't claim to support any scsi spec).  Now usb-storage sees
> > this in inquiry, and decides to export the device as a scsi2 device
> > since based on the usb-storage devs' experience most usb devices
> > really want scsi2 cdbs.  So SCSI core thinks this is a scsi2 device
> > and procedes to mangle the cdbs as they're going through.
> 
> What happens if you prevent USB mangling the scsi_level?  I think, for
> the most part, we would handle 0 in about the same way as we handle 2.
> However, we could gate the if around the CDB[1] mangling as
> 
> if (scsi_level != SCSI_UNKNOWN && scsi_level <= SCSI_2)
> 
> which should fix your problem, I think.
> 
> James
> 

Irconically that was one of the solutions I was investigating
first.  Here is the usb mailing list discussion on it:
http://marc.theaimsgroup.com/?t=112672009700004&r=1&w=2

In summary, the idea of making the scsi stack "level 0 aware" was
suggested and rejected because usb devs want to keep promoting
the devices to level 2 for various reaons.  At the end of it
they suggested using SG_FLAG_LUN_INHIBIT so that the usb device
could stay level 2 yet vendor specific commands could get passed
through un-touched. Neither of us knew that flag didn't work
anymore, and after I wasn't able to get it to work, that
other conversation I posted previously occured to figure out
what was going on with SG_FLAG_LUN_INHIBIT.

Regards,
Tim Thelin
