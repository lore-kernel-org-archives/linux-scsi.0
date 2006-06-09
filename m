From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: fc transport creates second set of targets for devices in an
	"md"
Date: Fri, 09 Jun 2006 14:23:29 -0500
Message-ID: <1149881009.4071.10.camel@mulgrave.il.steeleye.com>
References: <448876C8.3090303@sgi.com>
	 <1149813836.3276.3.camel@mulgrave.il.steeleye.com>
	 <4489A368.3080105@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:23694 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030435AbWFITXe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jun 2006 15:23:34 -0400
In-Reply-To: <4489A368.3080105@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James.Smart@Emulex.Com, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jim Nead <jnead@sgi.com>

On Fri, 2006-06-09 at 11:35 -0500, Michael Reed wrote:
> In this instance, there was no i/o in progress so the mid-layer didn't
> take the device off line.  It was simply removed by the transport.

Oh, OK, it's as mike said then ... we end up with a transport disconnect
and the openers of the device are left with a reference that simply
fails all I/O until they close it.

> > Basically, when a path goes dead it's up to the multi-path user level to
> > remove it an wait for udev to inform it that another SCSI node has
> > appeared and has the correct signature to be another path to the device.
> 
> Are there notification mechanisms in place such that a driver which has
> the device opened (claimed?) will be notified upon it's removal?  Should
> there be?  Could it happen via a driver callback?  Udev?  Both?
> I like the idea of a callback so that the removal has a chance of being
> complete.

Well, yes, there was an event sent, at least a kobject remove event for
the device which could have been picked up by udev or anything else
listening.

> Is it possible to do a better job of reconnecting a removed target
> to an open sd?

Not really, and that's by choice.  What constitutes removal, and what
action should be taken on it (and even how you recognise the same device
returning) are pretty much policy issues to be sorted out at user level.
We do allow the transports to set a local remove policy (as FC does with
the devloss timer) but since you explicitly defeated that, you get into
the user arena.

James


