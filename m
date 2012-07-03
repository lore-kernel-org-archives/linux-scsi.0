From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [ 38/48] SCSI & usb-storage: add try_rc_10_first flag
Date: Tue, 3 Jul 2012 14:35:12 -0600
Message-ID: <20120703203512.GE28804@parisc-linux.org>
References: <Pine.LNX.4.44L0.1207031540410.29825-100000@netrider.rowland.org> <1341346072.3076.6.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:46930 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab2GCUfP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jul 2012 16:35:15 -0400
Content-Disposition: inline
In-Reply-To: <1341346072.3076.6.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Hans de Goede <hdegoede@redhat.com>, Ben Hutchings <ben@decadent.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Jul 04, 2012 at 12:07:52AM +0400, James Bottomley wrote:
> > The reason for the try_rc_10_first flag is that some devices return
> > bogus data in response to RC16.  Like, an 800 GB device claiming to
> > have 3 exabytes.
> 
> So we could easily send both and only believe RC10 if the device is
> under 2TB.  However, what about all the extra flags we read out of RC16,
> like trim, large sector size and DIF capability?  If the device lies
> about its capacity, won't we get bogus values for those as well, which
> is going to cause other screw ups?

I think the necessary algorithm is simpler than that:

Send RC10 (unless the device supports PI, in which case it's probably
	enterprisey and well-tested)
Send RC16
If RC10 capacity agrees with RC16 capacity, use extra RC16 data.
(for values of "agrees with" that include the "-1 to use RC16" indicator)

Sure, it's one extra command, but really, who cares?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
