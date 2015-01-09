From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion
Date: Thu, 08 Jan 2015 21:03:28 -0800
Message-ID: <1420779808.21830.21.camel@haakon3.risingtidesystems.com>
References: <54AD5DDD.2090808@dev.mellanox.co.il> <54AD6563.4040603@suse.de>
	 <54ADA777.6090801@cs.wisc.edu> <54AE36CE.8020509@acm.org>
	 <1420755361.2842.16.camel@haakon3.risingtidesystems.com>
	 <1420756142.11310.9.camel@HansenPartnership.com>
	 <1420757822.2842.39.camel@haakon3.risingtidesystems.com>
	 <1420759360.11310.13.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1420759360.11310.13.camel@HansenPartnership.com>
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: lsf-pc@lists.linux-foundation.org, Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, target-devel <target-devel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-01-08 at 15:22 -0800, James Bottomley wrote:
> On Thu, 2015-01-08 at 14:57 -0800, Nicholas A. Bellinger wrote:
> > On Thu, 2015-01-08 at 14:29 -0800, James Bottomley wrote:
> > > On Thu, 2015-01-08 at 14:16 -0800, Nicholas A. Bellinger wrote:

<SNIP>

> > The point is that a simple session wide counter for command sequence
> > number assignment is significantly less overhead than all of the
> > overhead associated with running a full multipath stack atop multiple
> > sessions.
> 
> I don't see how that's relevant to issue speed, which was the measure we
> were using: The layers above are just a hopper.  As long as they're
> loaded, the MQ lower layer can issue at full speed.  So as long as the
> multipath hopper is efficient enough to keep the queues loaded there's
> no speed degradation.
> 
> The problem with a sequence point inside the MQ issue layer is that it
> can cause a stall that reduces the issue speed. so the counter sequence
> point causes a degraded issue speed over the multipath hopper approach
> above even if the multipath approach has a higher CPU overhead.
> 
> Now, if the system is close to 100% cpu already, *then* the multipath
> overhead will try to take CPU power we don't have and cause a stall, but
> it's only in the flat out CPU case.
> 
> > Not to mention that our iSCSI/iSER initiator is already taking a session
> > wide lock when sending outgoing PDUs, so adding a session wide counter
> > isn't adding any additional synchronization overhead vs. what's already
> > in place.
> 
> I'll leave it up to the iSER people to decide whether they're redoing
> this as part of the MQ work.
> 

Session wide command sequence number synchronization isn't something to
be removed as part of the MQ work.  It's a iSCSI/iSER protocol
requirement.

That is, the expected + maximum sequence numbers are returned as part of
every response PDU, which the initiator uses to determine when the
command sequence number window is open so new non-immediate commands may
be sent to the target.

So, given some manner of session wide synchronization is required
between different contexts for the existing single connection case to
update the command sequence number and check when the window opens, it's
a fallacy to claim MC/S adds some type of new initiator specific
synchronization overhead vs. single connection code.

--nab
