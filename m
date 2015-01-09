From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion
Date: Thu, 08 Jan 2015 22:25:27 -0800
Message-ID: <1420784727.11310.22.camel@HansenPartnership.com>
References: <54AD5DDD.2090808@dev.mellanox.co.il> <54AD6563.4040603@suse.de>
	 <54ADA777.6090801@cs.wisc.edu> <54AE36CE.8020509@acm.org>
	 <1420755361.2842.16.camel@haakon3.risingtidesystems.com>
	 <1420756142.11310.9.camel@HansenPartnership.com>
	 <1420757822.2842.39.camel@haakon3.risingtidesystems.com>
	 <1420759360.11310.13.camel@HansenPartnership.com>
	 <1420779808.21830.21.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44324 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751108AbbAIGZa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2015 01:25:30 -0500
In-Reply-To: <1420779808.21830.21.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: open-iscsi@googlegroups.com, Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, target-devel <target-devel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, lsf-pc@lists.linux-foundation.org

On Thu, 2015-01-08 at 21:03 -0800, Nicholas A. Bellinger wrote:
> On Thu, 2015-01-08 at 15:22 -0800, James Bottomley wrote:
> > On Thu, 2015-01-08 at 14:57 -0800, Nicholas A. Bellinger wrote:
> > > On Thu, 2015-01-08 at 14:29 -0800, James Bottomley wrote:
> > > > On Thu, 2015-01-08 at 14:16 -0800, Nicholas A. Bellinger wrote:
> 
> <SNIP>
> 
> > > The point is that a simple session wide counter for command sequence
> > > number assignment is significantly less overhead than all of the
> > > overhead associated with running a full multipath stack atop multiple
> > > sessions.
> > 
> > I don't see how that's relevant to issue speed, which was the measure we
> > were using: The layers above are just a hopper.  As long as they're
> > loaded, the MQ lower layer can issue at full speed.  So as long as the
> > multipath hopper is efficient enough to keep the queues loaded there's
> > no speed degradation.
> > 
> > The problem with a sequence point inside the MQ issue layer is that it
> > can cause a stall that reduces the issue speed. so the counter sequence
> > point causes a degraded issue speed over the multipath hopper approach
> > above even if the multipath approach has a higher CPU overhead.
> > 
> > Now, if the system is close to 100% cpu already, *then* the multipath
> > overhead will try to take CPU power we don't have and cause a stall, but
> > it's only in the flat out CPU case.
> > 
> > > Not to mention that our iSCSI/iSER initiator is already taking a session
> > > wide lock when sending outgoing PDUs, so adding a session wide counter
> > > isn't adding any additional synchronization overhead vs. what's already
> > > in place.
> > 
> > I'll leave it up to the iSER people to decide whether they're redoing
> > this as part of the MQ work.
> > 
> 
> Session wide command sequence number synchronization isn't something to
> be removed as part of the MQ work.  It's a iSCSI/iSER protocol
> requirement.

The sequence number is a requirement of the session.  Multiple separate
sessions means no SN correlation between the different connections, so
no global requirement for a SN counter across the queues ... that's what
Mike was saying about implementing multipath not using MCS.  With MCS we
have a single session for all the queues and thus have to correlate the
sequence number across all the connections and hence all the queues;
without it we don't.  That's why the sequence number becomes a potential
stall point in MQ implementation of MCS which can be obviated if we use
a separate session per queue.

James


