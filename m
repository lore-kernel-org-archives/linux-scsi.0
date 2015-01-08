From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion
Date: Thu, 08 Jan 2015 06:50:15 -0800
Message-ID: <1420728615.2100.2.camel@HansenPartnership.com>
References: <54AD5DDD.2090808@dev.mellanox.co.il> <54AD6563.4040603@suse.de>
	 <54ADA777.6090801@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40426 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754271AbbAHOuR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2015 09:50:17 -0500
In-Reply-To: <54ADA777.6090801@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@dev.mellanox.co.il>, lsf-pc@lists.linux-foundation.org, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, open-iscsi@googlegroups.com

On Wed, 2015-01-07 at 15:39 -0600, Mike Christie wrote:
> On 01/07/2015 10:57 AM, Hannes Reinecke wrote:
> > On 01/07/2015 05:25 PM, Sagi Grimberg wrote:
> >> Hi everyone,
> >>
> >> Now that scsi-mq is fully included, we need an iSCSI initiator that
> >> would use it to achieve scalable performance. The need is even greater
> >> for iSCSI offload devices and transports that support multiple HW
> >> queues. As iSER maintainer I'd like to discuss the way we would choose
> >> to implement that in iSCSI.
> >>
> >> My measurements show that iSER initiator can scale up to ~2.1M IOPs
> >> with multiple sessions but only ~630K IOPs with a single session where
> >> the most significant bottleneck the (single) core processing
> >> completions.
> >>
> >> In the existing single connection per session model, given that command
> >> ordering must be preserved session-wide, we end up in a serial command
> >> execution over a single connection which is basically a single queue
> >> model. The best fit seems to be plugging iSCSI MCS as a multi-queued
> >> scsi LLDD. In this model, a hardware context will have a 1x1 mapping
> >> with an iSCSI connection (TCP socket or a HW queue).
> >>
> >> iSCSI MCS and it's role in the presence of dm-multipath layer was
> >> discussed several times in the past decade(s). The basic need for MCS is
> >> implementing a multi-queue data path, so perhaps we may want to avoid
> >> doing any type link aggregation or load balancing to not overlap
> >> dm-multipath. For example we can implement ERL=0 (which is basically the
> >> scsi-mq ERL) and/or restrict a session to a single portal.
> >>
> >> As I see it, the todo's are:
> >> 1. Getting MCS to work (kernel + user-space) with ERL=0 and a
> >>    round-robin connection selection (per scsi command execution).
> >> 2. Plug into scsi-mq - exposing num_connections as nr_hw_queues and
> >>    using blk-mq based queue (conn) selection.
> >> 3. Rework iSCSI core locking scheme to avoid session-wide locking
> >>    as much as possible.
> >> 4. Use blk-mq pre-allocation and tagging facilities.
> >>
> >> I've recently started looking into this. I would like the community to
> >> agree (or debate) on this scheme and also talk about implementation
> >> with anyone who is also interested in this.
> >>
> > Yes, that's a really good topic.
> > 
> > I've pondered implementing MC/S for iscsi/TCP but then I've figured my
> > network implementation knowledge doesn't spread that far.
> > So yeah, a discussion here would be good.
> > 
> > Mike? Any comments?
> 
> I have been working under the assumption that people would be ok with
> MCS upstream if we are only using it to handle the issue where we want
> to do something like have a tcp/iscsi connection per CPU then map the
> connection to a blk_mq_hw_ctx. In this more limited MCS implementation
> there would be no iscsi layer code to do something like load balance
> across ports or transport paths like how dm-multipath does, so there
> would be no feature/code duplication. For balancing across hctxs, then
> the iscsi layer would also leave that up to whatever we end up with in
> upper layers, so again no feature/code duplication with upper layers.
> 
> So pretty non controversial I hope :)

If you can make that work, so we expose MCS in a way that allows upper
layers to use it, I'd say it was pretty much perfect.  The main
objection I've had over the years to multiple connections per session is
that it required a duplication of the multi-path code within the iscsi
initiator (and that was after several long fights to get multi path out
of other fabric initiators), so something that doesn't require the
duplication overcomes that objection.

> If people want to add something like round robin connection selection in
> the iscsi layer, then I think we want to leave that for after the
> initial merge, so people can argue about that separately.

Well, you're right, we can argue about it later, but if it's just round
robin, why would it be better done in the initator rather than dm?

James


