From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: Fix dm-multipath starvation when scsi host is busy
Date: Tue, 22 May 2012 10:13:14 +0100
Message-ID: <1337677994.28492.12.camel@dabdike.int.hansenpartnership.com>
References: <4FBB555B.5060608@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47821 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754944Ab2EVJNY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 May 2012 05:13:24 -0400
In-Reply-To: <4FBB555B.5060608@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>

On Tue, 2012-05-22 at 17:59 +0900, Jun'ichi Nomura wrote:
> When a scsi host is kept busy by a dm-mpath device, other dm-mpath device
> on the same host could be starved. For example:
> http://www.redhat.com/archives/dm-devel/2012-May/msg00123.html
> 
> It happens because dm-mpath delays request submission when the underlying
> scsi host is busy even if sdev is not busy.
> 
> For case like this, it is better to send the request down and let scsi do
> appropriate starvation control over the shared resource.
> 
> Though it might seem odd to change scsi's definition of a LLD being "busy",
> it is reasonable because scsi_lld_busy (and blk_lld_busy) was introduced
> to provide a hint for request-based stacking driver (i.e. dm-multipath)
> and dm-multipath is the only user of this function.

This explanation is rather dense.

Isn't a more understandable explanation:

block congestion control doesn't have any concept of fairness across
multiple queues.  This means that if SCSI reports the host as busy in
the queue congestion control it can result in an unfair starvation
situation in dm-mp if there are multiple multipath devices on the same
host.  The fix for this is to report only the sdev busy state (and
ignore the host busy state) in the block congestion control call back.
The host is still congested, but the SCSI subsystem will sort out the
congestion in a fair way because it knows the relation between the
queues and the host.

And please put a comment in the code as well otherwise someone will
eventually send a "fix" for this because we're not paying attention to
host busy (and I'll have forgotten about the issue by then and might
apply it).

A final note is that this is more a band aid than a fix because this is
still a congestion situation dm-mp should be aware of.

James


