From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SCSI mid layer and high IOPS capable devices
Date: Wed, 19 Dec 2012 09:23:09 -0500
Message-ID: <20121219142309.GA13278@infradead.org>
References: <20121213172513.GH20898@beardog.cce.hp.com>
 <50CA0692.2010903@acm.org>
 <20121213164912.GA28496@infradead.org>
 <50CAF502.3070300@acm.org>
 <20121214164421.GQ20898@beardog.cce.hp.com>
 <50CB50A9.1050202@acm.org>
 <20121214195533.GS20898@beardog.cce.hp.com>
 <50CB7DF8.5020002@acm.org>
 <20121214210645.GV20898@beardog.cce.hp.com>
 <50CC4588.1010608@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33417
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753608Ab2LSOXP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Dec 2012 09:23:15 -0500
Content-Disposition: inline
In-Reply-To: <50CC4588.1010608@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: scameron@beardog.cce.hp.com, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, dab@hp.com

On Sat, Dec 15, 2012 at 10:40:24AM +0100, Bart Van Assche wrote:
> On 12/14/12 22:06, scameron@beardog.cce.hp.com wrote:
> >[ ... ] how to get the scsi mid layer to provide a wide enough
> >highway for requests destined for very low latency devices.
> 
> While the SCSI mid-layer is processing an I/O request not only the
> queue lock has to be locked and unlocked several times but also the
> SCSI host lock. The reason that it's unavoidable to lock and unlock
> the host lock is because the SCSI core has been designed for SCSI
> equipment that has a queue depth limit per host (shost->can_queue).
> For single LUN devices that model could be changed in a queue depth
> limit per LUN. Also, it's probably not that hard to modify software
> SCSI target implementations such that these have a queue depth limit
> per LUN instead of per host.

We'd also better avoid needing a lock to check these limits, especially
if we normally don't hit them.  The easiest way to get started would
be to simply allow a magic can_queue value that keeps these as unlimited
and only let the driver return one of the busy values from
->queuecommand.  We could then use unlocked list empty checks to see
if anything is in a waiting list and enter a slow path mode.

