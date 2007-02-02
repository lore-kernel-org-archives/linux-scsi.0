From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
Date: Fri, 2 Feb 2007 17:07:25 -0600
Message-ID: <20070202230725.GG10108@waste.org>
References: <200701301947.08478.liml@rtr.ca> <1170206199.10890.13.camel@mulgrave.il.steeleye.com> <45C2474E.9030306@rtr.ca> <1170366920.3388.62.camel@mulgrave.il.steeleye.com> <45C32C7F.9050706@emc.com> <20070202145003.525bd682@localhost.localdomain> <45C3617B.2020400@rtr.ca> <20070202194956.GF16722@waste.org> <45C3C1FC.8020500@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from waste.org ([66.93.16.53]:55644 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946157AbXBBXUH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Feb 2007 18:20:07 -0500
Content-Disposition: inline
In-Reply-To: <45C3C1FC.8020500@rtr.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Ric Wheeler <ric@emc.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Feb 02, 2007 at 05:58:04PM -0500, Mark Lord wrote:
> Matt Mackall wrote:
> >..
> >Also worth considering is that spending minutes trying to reread
> >damaged sectors is likely to accelerate your death spiral. More data
> >may be recoverable if you give up quickly in a first pass, then go
> >back and manually retry damaged bits with smaller I/Os.
> 
> All good input.  But what was being debated here is not so much
> the retrying of known-bad sectors, but rather what to do about
> the kiBs or MiBs of sectors remaining in a merged request after
> hitting a single bad sector mid-way.

Yep, that's precisely what was addressed in the part you snipped. 

My main point being that what to do about the remaining workload
should be dependent on the size of the I/O. If we encounter errors on
sectors 4,5,6,7,8.. of a 1MB request, we should have a threshold for
giving up. It's not unreasonable for that threshold to be larger than
1, but it should not be 2048.

And if we do the I/O as four 256KB requests, we should have
approximately the same number of retries (assuming the whole region's
bad).

-- 
Mathematics is the supreme nostalgia of our time.
