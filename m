From: Peter Missel <peter.missel@onlinehome.de>
Subject: Re: SYM8xx_2 driver ignores certain EEPROM settings
Date: Fri, 31 Dec 2004 16:20:44 +0100
Message-ID: <200412311620.44488.peter.missel@onlinehome.de>
References: <200412311343.42484.peter.missel@onlinehome.de> <20041231145306.GB18080@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.176]:62702 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S262106AbULaPVY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Dec 2004 10:21:24 -0500
In-Reply-To: <20041231145306.GB18080@parcelfarce.linux.theplanet.co.uk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Greetings!

Thanks for the quick reply.

> Yes, that's right.  I'm not a big fan of dealing with distro kernels
> because they make changes without informing me.  An earlier SuSE kernel
> commented out the domain validation calls from the sym2 driver -- without
> putting the previous code back in.  However, that problem doesn't seem to
> be present in this kernel.

I'm fine with the additional safety from the Domain Validation. Nonetheless, 
the driver shouldn't validate speeds and/or transfer widths that have been 
forbidden by the user.
Another example (which I can't verify right now) is negotiation width. 
External HDD enclosures might be connected through a Narrow cable but 
actually contain a Wide drive. That'll be one thing where the user would use 
the SCSI BIOS to limit the particular unit to Narrow. This however would 
possibly be caught by the DM failing.

> > For example (and that's why I noticed), if in SCSI BIOS a certain SCSI
> > channel (or a single device) has been limited by the user to 10 MT/s, the
> > Linux SCSI driver nonetheless negotiates to 20 MT/s.
> >
> > It is necessary to stick to the settings from BIOS (as read from EEPROM),
> > simply because there might be a good reason why the user did that. In my
> > particular case, I need to restrict the sym0 channel from doing Ultra (20
> > MT/s) altogether because the total cable length doesn't allow me to,
>
> The Domain Validation code is supposed to catch problems like this, and
> automatically fall back to a setting that works without requiring the
> user to set magic bits in their NVRAM.  Are you actually experiencing
> problems due to the faster speed, or is it just that you know the cable
> is out of spec?
>
I do actually see failures when using the one drive that supports Ultra (it's 
a CDRW). They're gone as soon as I either disconnect the external branch, or 
when using only Fast-10 transfers.
Same for the old Fujitsu MO (an early revision 2513, btw). Running it at 10 
MT/s causes SCSI hangs and resets galore, it's fine at 5.

> Hm, I see we skip the write tests, presumably because the drive doesn't
> support a write buffer.  Drat.

Domain validation on the CDRW drive comes out OK even with the external branch 
connected, but in actual usage, operation fails pretty quickly.

> Buggy drive firmware keeps on biting us ;-(  It does seem worth honouring
> the NVRAM settings, but the thing is that we then have to support such
> fixes in each driver.

Honouring the NVRAM settings should do for the individual user, although some 
method of blacklisting known-bad devices wouldn't be bad either. It's been a 
while since I've been digging around in Linux SCSI driver architecture, but 
didn't we once have a device blacklist in the SCSI core?

> > Being a system BIOS developper, I have the means to do an EEPROM dump of
> > my SCSI adapter. So in case this is helpful to you, I'll do that as soon
> > as I'm back to work on Jan 10.
>
> I don't need you to do that -- I know the ability has been removed from the
> driver.  I bet I can put it back without disturbing things too much.

Ah. Go on then ;)

Please let me know when there's something I can give a test run.

regards,
Peter
