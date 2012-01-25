From: Daniel Taylor <Daniel.Taylor@wdc.com>
Subject: RE: [usb-storage] Re: [PATCH 0/3] SCSI & usb-storage: new flags for
 VPD pages and REPORT LUNS
Date: Wed, 25 Jan 2012 05:42:21 +0000
Message-ID: <5A9BC72FD5CEC94EA024CED8E31D701A2765C25A@wdscexmb03.sc.wdc.com>
References: <E9801365-C2D1-4E5C-8BE4-BD712DA0D2FD@mac.com>
 <Pine.LNX.4.44L0.1201101327030.1594-100000@iolanthe.rowland.org>
 <20120124200122.GA7739@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wdmail02.wdc.com ([129.253.55.42]:53754 "EHLO wdmail02.wdc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab2AYFvm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2012 00:51:42 -0500
In-Reply-To: <20120124200122.GA7739@kroah.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Greg KH' <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Perry Wagle <wagle@mac.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, Daniel Taylor <Daniel.Taylor@wdc.com>

 

> -----Original Message-----
> From: usb-storage@lists.one-eyed-alien.net 
> [mailto:usb-storage@lists.one-eyed-alien.net] On Behalf Of Greg KH
> Sent: Tuesday, January 24, 2012 12:01 PM
> To: Alan Stern; James Bottomley
> Cc: Matthew Dharm; Perry Wagle; USB Storage list; SCSI 
> development list
> Subject: [usb-storage] Re: [PATCH 0/3] SCSI & usb-storage: 
> new flags for VPD pages and REPORT LUNS
> 
> On Tue, Jan 10, 2012 at 01:42:40PM -0500, Alan Stern wrote:
> > James and Greg:
> > 
> > Perry Wagle reports that his new USB-ESATA drives don't 
> work properly 
> > because they don't like getting the LUN bits in the second 
> byte of the 
> > command string.  We set those bits only because usb-storage 
> adjusts the 
> > SCSI revision level for all devices to SCSI-2; the drives 
> themselves 
> > report a value of 0x06 (which would be SCSI-7).
> > 
> > The reason for mangling the scsi_level value was that some 
> USB devices 
> > reported SCSI-3 but couldn't handle some of the mandatory 
> features: VPD 
> > pages and the REPORT LUNS command.  It's now clear that instead of 
> > abusing scsi_level, we should have separate flags for the 
> individual 
> > features we need to control.
> > 
> > That's what this patch series does.  The first merely corrects an 
> > existing typo in the definition of struct scsi_target.  The 
> second adds 
> > the new flags and makes usb-storage use them.  The third takes this 
> > opportunity to do a little code clean-up in usb-storage.
> > 
> > The changes are more or less equally divided between SCSI and
> > usb-storage.  James, if they look okay to you and you don't 
> mind taking
> > them through your tree, that would be fine.  Or if you 
> prefer, I'm sure
> > Greg won't mind taking them.
> 
> I'll be glad to take these, James, any objection?
> 
> thanks,
> 
> greg k-h

I handled this a bit differently, for our old 2.6.32 kernel, based on
discussions on this list with Matthew Dharm back in April 2011.

I changed the scsi_level entry in /sys to be read/write, rather than
read-only.  This allows a ussr-space white-list handler to fixup
drives that are known to work.

The gist of the discussion was whether the kernel should keep a white
or black list for every drive on the planet to handle the scsi_level
change/no-change or that user space could have the database and either
apply it manually or automatically through udevd.  Matthew expressed
a preference for user space to manage the information.

I can't find the patch set for these flag changes in my local email
archive, but can we have controls for these available in user-space?

Thanks,

Dan

> 
> -- 
> You received this message because you are subscribed to the 
> Google Groups "USB Mass Storage on Linux" group.
> To post to this group, send email to 
> usb-storage@lists.one-eyed-alien.net.
> To unsubscribe from this group, send email to 
> usb-storage+unsubscribe@lists.one-eyed-alien.net.
> For more options, visit this group at 
> http://groups.google.com/a/lists.one-eyed-alien.net/group/usb-
> storage/?hl=en.
> 
> 