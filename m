From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] scsi: Fix dm-multipath starvation when scsi host is
 busy
Date: Tue, 22 May 2012 08:54:45 -0400
Message-ID: <20120522125445.GA26233@redhat.com>
References: <4FBB555B.5060608@ce.jp.nec.com>
 <1337677994.28492.12.camel@dabdike.int.hansenpartnership.com>
 <4FBB62FD.5040008@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab2EVMzA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 May 2012 08:55:00 -0400
Content-Disposition: inline
In-Reply-To: <4FBB62FD.5040008@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, Alasdair G Kergon <agk@redhat.com>

On Tue, May 22 2012 at  5:57am -0400,
Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> On 05/22/12 18:13, James Bottomley wrote:
> > Isn't a more understandable explanation:
> 
> Thank you. That's quite elegant.
> I replaced the description with it.
> 
> > And please put a comment in the code as well otherwise someone will
> > eventually send a "fix" for this because we're not paying attention to
> > host busy (and I'll have forgotten about the issue by then and might
> > apply it).
> 
> Added the comment in code.
> 
> > A final note is that this is more a band aid than a fix because this is
> > still a congestion situation dm-mp should be aware of.
> 
> Yes. To do that, we have to generalize the concept of "host"
> and share it with block layer.
> 
> Attached below is the revised patch.
> 
> ----------------------------------------------------------
> [PATCH v2] scsi: Fix dm-multipath starvation when scsi host is busy
> 
> block congestion control doesn't have any concept of fairness across
> multiple queues.  This means that if SCSI reports the host as busy in
> the queue congestion control it can result in an unfair starvation
> situation in dm-mp if there are multiple multipath devices on the same
> host.  For example:
> http://www.redhat.com/archives/dm-devel/2012-May/msg00123.html
> 
> The fix for this is to report only the sdev busy state (and ignore the
> host busy state) in the block congestion control call back.
> The host is still congested, but the SCSI subsystem will sort out the
> congestion in a fair way because it knows the relation between the
> queues and the host.
> 
> Reported-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
> Tested-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
> Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Mike Snitzer <snitzer@redhat.com>

Acked-by: Mike Snitzer <snitzer@redhat.com>
