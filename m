From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 2.6.24-rc3-mm1
Date: Fri, 14 Dec 2007 09:26:45 -0500
Message-ID: <1197642405.3154.71.camel@localhost.localdomain>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	 <47462F3C.3040700@googlemail.com>
	 <20071122201250.f957e280.akpm@linux-foundation.org>
	 <47466B5D.90607@googlemail.com>
	 <20071126221509.8f437b61.akpm@linux-foundation.org>
	 <1197390783.3812.19.camel@localhost.localdomain> <47624649.3040209@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-76-243-235-52.dsl.chcgil.sbcglobal.net ([76.243.235.52]:36245
	"EHLO accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515AbXLNO0z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Dec 2007 09:26:55 -0500
In-Reply-To: <47624649.3040209@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


On Fri, 2007-12-14 at 10:00 +0100, Hannes Reinecke wrote:
> James Bottomley wrote:
> > On Mon, 2007-11-26 at 22:15 -0800, Andrew Morton wrote:
> >> OK, thanks.  I'll assume that James and Hannes have this in hand (or will
> >> have, by mid-week) and I won't do anything here.
> > 
> > Just to confirm what I think I'm going to be doing:  rebasing the
> > scsi-misc tree to remove this commit:
> > 
> > commit 8655a546c83fc43f0a73416bbd126d02de7ad6c0
> > Author: Hannes Reinecke <hare@suse.de>
> > Date:   Tue Nov 6 09:23:40 2007 +0100
> > 
> >     [SCSI] Do not requeue requests if REQ_FAILFAST is set
> > 
> > And its allied fix ups:
> > 
> > commit 983289045faa96fba8841d3c51b98bb8623d9504
> > Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Date:   Sat Nov 24 19:47:25 2007 +0200
> > 
> >     [SCSI] fix up REQ_FASTFAIL not to fail when state is QUIESCE
> > 
> > commit 9dd15a13b332e9f5c8ee752b1ccd9b84cb5bdf17
> > Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Date:   Sat Nov 24 19:55:53 2007 +0200
> > 
> >     [SCSI] fix domain validation to work again
> > 
> > James
> > 
> > 
> Or just apply my latest patch (cf Undo __scsi_kill_request).
> The main point is that we shouldn't retry requests
> with FAILFAST set when the queue is blocked. AFAICS
> only FC and iSCSI transports set the queue to blocked,
> and use this to indicate a loss of connection. So any
> retry with queue blocked is futile.

I still don't think this is the right approach.

For link up/down events, those are direct pathing events and should be
signalled along a kernel notifier, not by mucking with the SCSI state
machine.  However, there's still devloss_tmo to consider ... even in
multipath, I don't think you want to signal path failure until
devloss_tmo has fired otherwise you'll get too many transient up/down
events which damage performance if the array has an expensive failover
model.

The other problem is what to do with in-flight commands at the time the
link went down.  With your current patch, they're still stuck until they
time out ... surely there needs to be some type of recovery mechanism
for these?

James


