From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fusion: streamline ->queuecommand
Date: 05 Oct 2004 19:48:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097023705.2173.340.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E570526235F@exa-atlanta>
	<1097017890.1765.216.camel@mulgrave>
	<20041005233714.GA18081@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:46496 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266547AbUJFAsp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Oct 2004 20:48:45 -0400
In-Reply-To: <20041005233714.GA18081@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Eric Dean Moore <Emoore@lsil.com>, "Stephens, Larry" <larry.stephens@lsil.com>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>, "Gibbons, Terry" <Terry.Gibbons@lsil.com>, Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-10-05 at 18:37, Patrick Mansfield wrote:
> On Tue, Oct 05, 2004 at 06:11:22PM -0500, James Bottomley wrote:
> Yes, we want drivers to move forward, but with our current model, we don't
> have any 2.6.x kernel.org stable kernels. 

>From the API point of view, that's correct

> When we first went to this model I thought it did not matter, you could
> just get stable kernels from a distro, but now I see problems with it.
> 
> If code changes for a mainline kernel scsi driver, there is no place to
> keep a stable driver as part of a stable kernel.org series.

True, but on the other hand no-one really keeps their stable drivers in
vanilla 2.4 either.

> Driver maintainers are getting requests to backport current 2.6.x code to
> distributions in order to support stable kernel series, else they have to
> (effectively) maintain a driver version for each distro.

This is normal.

> When we had 2.4 stable and 2.5 development, there was a single repository
> for stable kernels, and one for development. Maintainers did not have to
> track distros, the distros could (generally) pull from the latest 2.4.x
> tree to sync up with the latest driver fixes.

This isn't really the case.  In the 2.4 timeframe, distribution kernels
were positively awash with backports from 2.5 (and generally different
backports or implementations too) ... you only have to look at something
like the adaptec driver with it's redhat specific pieces to appreciate
this.

A distribution is a snapshot, so there'll always be a backport issue for
vendors who interact directly with distribution kernels.  However, the
difference between sles 9 and the current 2.6 is a lot less than between
sles 8 and 2.5.  So, I accept that there's backport work to be done but
I don't accept necessarily that the situation is worse than what we had
in 2.4 where the amount of distribution patches were bigger and no
vendor tracked the 2.5 tree.

In theory, the vendor promise of "upstream first" means that the vendor
kernels should be tracking 2.6 more closely and thus the backports
should be easier ... and the requirement is that the vendor feature be
in vanilla 2.6 first.

James


