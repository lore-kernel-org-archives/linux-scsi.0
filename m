From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: RFC: Transport identifier
Date: Sat, 28 Feb 2009 07:36:36 -0800
Message-ID: <1235835396.3468.4.camel@localhost.localdomain>
References: <yq1iqmxg6o4.fsf@sermon.lab.mkp.net>
	 <1235663301.19035.44.camel@localhost.localdomain>
	 <yq1prh5ey7b.fsf@sermon.lab.mkp.net> <49A94FEB.6050400@s5r6.in-berlin.de>
	 <20090228150633.GQ16891@parisc-linux.org>
	 <49A95616.3070502@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59499 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751362AbZB1Pgo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Feb 2009 10:36:44 -0500
In-Reply-To: <49A95616.3070502@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Matthew Wilcox <matthew@wil.cx>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Sat, 2009-02-28 at 16:19 +0100, Stefan Richter wrote:
> Matthew Wilcox wrote:
> > On Sat, Feb 28, 2009 at 03:53:31PM +0100, Stefan Richter wrote:
> >> /Is/ the used transport protocol a good indicator for whether a
> >> particular target breaks by READ CAPACITY 16?  I have doubts.  Command
> >> set support is independent of transport protocol support.
> > 
> > You must admit there's a striking correlation between USB devices and
> > completely failing to follow the SCSI spec.  Our current workaround of
> > clamping USB devices at a SCSI_2 level does avoid much of the pain.
> 
> OK, but currently implementations typically are:
>  1. transport layer driver detects device with known flaws, switches on
>     a device quirk flag,
>  2. transport layer enables quirk for all devices which it serves by,
>     default, possibly disables quirk for some whitelisted devices.
> 
> Pulling the SCSI level down in usb-storage belongs into the latter category.
> 
> Martin's proposal for transport identifiers includes the suggestion of a
> third strategy:
>  3. transport layer identifies itself, upper layer enable some quirks
>     based on that information (alone or in combination with whatever
>     other information).

Actually, that's the piece of this proposal I'm explicitly saying no to:
we're not going to code transport knowledge into the mid-layer because
it's setting us up to get things wrong.

The thing that may be useful in all of this is for udev to get the
transport type from sysfs ... I'm not entirely sure about this one,
since udev seems to do a pretty good job on its own without an exported
identifier, but I can see an explicit one might be useful to it.

> So, while it may be prudent to deduct "it's USB" -> "don't try READ
> CAPACITY 16", why not keep implementing this in way #2?

We will.  That way if a wonderfully compliant USB device comes along
(big if, I know) you can white list it in the USB (or SBP-2) layer and
pass along its true SCSI compliance level.

James


