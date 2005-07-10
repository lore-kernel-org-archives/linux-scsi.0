From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sun, 10 Jul 2005 12:05:54 -0500
Message-ID: <1121015154.5078.10.camel@mulgrave>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de>
	 <1120922306.5008.5.camel@mulgrave> <20050709230656.GS29099@phunnypharm.org>
	 <20050710033431.GB13883@havoc.gtf.org>
	 <20050710043645.GF2972@phunnypharm.org> <1121009100.5078.4.camel@mulgrave>
	 <20050710155839.GC14956@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:6284 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261975AbVGJRHM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 13:07:12 -0400
In-Reply-To: <20050710155839.GC14956@phunnypharm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <bcollins@debian.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net

On Sun, 2005-07-10 at 11:58 -0400, Ben Collins wrote:
> I didn't see that the scsi code made a distinction here. I thought it did
> the conversion for all devices if use_10_for_{rw,ms} was set, and did the
> fallback when it got ILLEGAL_REQUEST. Is there something in there that
> will disable use_10_for_{rw,ms} if it's not TYPE_RBC?

It doesn't.  As you say, the flags are universal for the device,
whatever the ULD is.  However, as you also say, if MS_10 fails with
ILLEGAL_REQUEST we do fall back to MS_6.

> Ok, I see something different in the MODE_SENSE:
[...]
> Looking the pre TYPE_RBC code, I can see that the modepage change wasn't
> there, so sure enough we were using 8. Could this cause an
> ILLEGAL_REQUEST, and thus disable use_10_for_{rw,ms}?

Yes, that was the core of the bug Al was fixing.  sd has been requesting
caching data for a while now.  However, for RBC devices it was probing
the wrong mode page and failing.  After the changes we actually get the
correct caching data.

> I'm starting to understand some of the code paths here. So before all of
> this, TYPE_RBC was not recognized by the scsi layer as a "disk" type
> device (which is why sbp2 forced TYPE_DISK for TYPE_RDC devices when
> commands passed into the scsi layer).

Exactly, but trying to pretend they were true TYPE_DISK was also causing
issues (most notably the cache problem).

James


