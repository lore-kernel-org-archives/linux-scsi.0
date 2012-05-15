From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/3] scsi: usb-storage: hide errors for five devices
Date: Tue, 15 May 2012 08:35:39 -0700
Message-ID: <20120515153539.GA25206@kroah.com>
References: <1336491453.1933.67.camel@x61.thuisdomein>
 <Pine.LNX.4.44L0.1205081240450.1479-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65135 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965262Ab2EOPfp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2012 11:35:45 -0400
Received: by pbbrp8 with SMTP id rp8so7673875pbb.19
        for <linux-scsi@vger.kernel.org>; Tue, 15 May 2012 08:35:45 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1205081240450.1479-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Paul Bolle <pebolle@tiscali.nl>, "James E.J. Bottomley" <JBottomley@parallels.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 01:03:17PM -0400, Alan Stern wrote:
> On Tue, 8 May 2012, Paul Bolle wrote:
> 
> > On Tue, 2012-05-08 at 10:02 -0400, Alan Stern wrote:
> > > On Tue, 8 May 2012, Paul Bolle wrote: 
> > > > 1) These patches try to hide those errors by:
> > > > - downgrading one error to a notice; and
> > > 
> > > That's a reasonable thing to do, IMO.
> > > 
> > > > - setting the NO_WP_DETECT quirk for these five devices.
> > > 
> > > But that isn't.  These quirks are intended for devices that crash when
> > > they receive the command in question.
> > 
> > Yes, these USB memory sticks don't crash. (They actually seem to work
> > just fine, something that I perhaps should have emphasized in the commit
> > descriptions.)
> > 
> > > They aren't meant to suppress sending commands to devices that can
> > > properly reject them.
> > 
> > Even the sticks that hit "bad_sense" (in sd_read_cache_type(), which I
> > forgot to mention in the comment descriptions)? Is that not as severe as
> > it suggests?
> 
> It means that the device either doesn't support the MODE SENSE command
> or it returned useless data.  As a result, we will assume it has a
> write-through cache when it might not.
> 
> For memory sticks this doesn't matter.  For other devices it might be 
> more important (although anything with a working cache should not hit 
> this error case).
> 
> > Of course, an easy way out would be to downgrade both the "Asking for
> > cache data failed" and the "No Caching mode page present" errors to
> > notices. But the SCSI people might disagree with that approach.
> 
> Well, let's see what they say.

What ever happened here, are these 3 patches acceptable, or do they need
to be reworked or something else?

thanks,

greg k-h
