From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion
Date: Thu, 08 Jan 2015 14:57:02 -0800
Message-ID: <1420757822.2842.39.camel@haakon3.risingtidesystems.com>
References: <54AD5DDD.2090808@dev.mellanox.co.il> <54AD6563.4040603@suse.de>
	 <54ADA777.6090801@cs.wisc.edu> <54AE36CE.8020509@acm.org>
	 <1420755361.2842.16.camel@haakon3.risingtidesystems.com>
	 <1420756142.11310.9.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1420756142.11310.9.camel@HansenPartnership.com>
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Bart Van Assche <bvanassche@acm.org>, open-iscsi@googlegroups.com, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@dev.mellanox.co.il>, lsf-pc@lists.linux-foundation.org, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-01-08 at 14:29 -0800, James Bottomley wrote:
> On Thu, 2015-01-08 at 14:16 -0800, Nicholas A. Bellinger wrote:
> > On Thu, 2015-01-08 at 08:50 +0100, Bart Van Assche wrote:
> > > On 01/07/15 22:39, Mike Christie wrote:
> > > > On 01/07/2015 10:57 AM, Hannes Reinecke wrote:
> > > >> On 01/07/2015 05:25 PM, Sagi Grimberg wrote:
> > > >>> Hi everyone,
> > > >>>
> > > >>> Now that scsi-mq is fully included, we need an iSCSI initiato=
r that
> > > >>> would use it to achieve scalable performance. The need is eve=
n greater
> > > >>> for iSCSI offload devices and transports that support multipl=
e HW
> > > >>> queues. As iSER maintainer I'd like to discuss the way we wou=
ld choose
> > > >>> to implement that in iSCSI.
> > > >>>
> > > >>> My measurements show that iSER initiator can scale up to ~2.1=
M IOPs
> > > >>> with multiple sessions but only ~630K IOPs with a single sess=
ion where
> > > >>> the most significant bottleneck the (single) core processing
> > > >>> completions.
> > > >>>
> > > >>> In the existing single connection per session model, given th=
at command
> > > >>> ordering must be preserved session-wide, we end up in a seria=
l command
> > > >>> execution over a single connection which is basically a singl=
e queue
> > > >>> model. The best fit seems to be plugging iSCSI MCS as a multi=
-queued
> > > >>> scsi LLDD. In this model, a hardware context will have a 1x1 =
mapping
> > > >>> with an iSCSI connection (TCP socket or a HW queue).
> > > >>>
> > > >>> iSCSI MCS and it's role in the presence of dm-multipath layer=
 was
> > > >>> discussed several times in the past decade(s). The basic need=
 for MCS is
> > > >>> implementing a multi-queue data path, so perhaps we may want =
to avoid
> > > >>> doing any type link aggregation or load balancing to not over=
lap
> > > >>> dm-multipath. For example we can implement ERL=3D0 (which is =
basically the
> > > >>> scsi-mq ERL) and/or restrict a session to a single portal.
> > > >>>
> > > >>> As I see it, the todo's are:
> > > >>> 1. Getting MCS to work (kernel + user-space) with ERL=3D0 and=
 a
> > > >>>     round-robin connection selection (per scsi command execut=
ion).
> > > >>> 2. Plug into scsi-mq - exposing num_connections as nr_hw_queu=
es and
> > > >>>     using blk-mq based queue (conn) selection.
> > > >>> 3. Rework iSCSI core locking scheme to avoid session-wide loc=
king
> > > >>>     as much as possible.
> > > >>> 4. Use blk-mq pre-allocation and tagging facilities.
> > > >>>
> > > >>> I've recently started looking into this. I would like the com=
munity to
> > > >>> agree (or debate) on this scheme and also talk about implemen=
tation
> > > >>> with anyone who is also interested in this.
> > > >>>
> > > >> Yes, that's a really good topic.
> > > >>
> > > >> I've pondered implementing MC/S for iscsi/TCP but then I've fi=
gured my
> > > >> network implementation knowledge doesn't spread that far.
> > > >> So yeah, a discussion here would be good.
> > > >>
> > > >> Mike? Any comments?
> > > >
> > > > I have been working under the assumption that people would be o=
k with
> > > > MCS upstream if we are only using it to handle the issue where =
we want
> > > > to do something like have a tcp/iscsi connection per CPU then m=
ap the
> > > > connection to a blk_mq_hw_ctx. In this more limited MCS impleme=
ntation
> > > > there would be no iscsi layer code to do something like load ba=
lance
> > > > across ports or transport paths like how dm-multipath does, so =
there
> > > > would be no feature/code duplication. For balancing across hctx=
s, then
> > > > the iscsi layer would also leave that up to whatever we end up =
with in
> > > > upper layers, so again no feature/code duplication with upper l=
ayers.
> > > >
> > > > So pretty non controversial I hope :)
> > > >
> > > > If people want to add something like round robin connection sel=
ection in
> > > > the iscsi layer, then I think we want to leave that for after t=
he
> > > > initial merge, so people can argue about that separately.
> > >=20
> > > Hello Sagi and Mike,
> > >=20
> > > I agree with Sagi that adding scsi-mq support in the iSER initiat=
or=20
> > > would help iSER users because that would allow these users to con=
figure=20
> > > a single iSER target and use the multiqueue feature instead of ha=
ving to=20
> > > configure multiple iSER targets to spread the workload over multi=
ple=20
> > > cpus at the target side.
> > >=20
> > > And I agree with Mike that implementing scsi-mq support in the iS=
ER=20
> > > initiator as multiple independent connections probably is a bette=
r=20
> > > choice than MC/S. RFC 3720 namely requires that iSCSI numbering i=
s=20
> > > session-wide. This means maintaining a single counter for all MC/=
S=20
> > > sessions. Such a counter would be a contention point. I'm afraid =
that=20
> > > because of that counter performance on a multi-socket initiator s=
ystem=20
> > > with a scsi-mq implementation based on MC/S could be worse than w=
ith the=20
> > > approach with multiple iSER targets. Hence my preference for an a=
pproach=20
> > > based on multiple independent iSER connections instead of MC/S.
> > >=20
> >=20
> > The idea that a simple session wide counter for command sequence nu=
mber
> > assignment adds such a degree of contention that it renders MC/S at=
 a
> > performance disadvantage vs. multi-session configurations with all =
of
> > the extra multipath logic overhead on top is at best, a naive
> > proposition.
> >=20
> > On the initiator side for MC/S, literally the only thing that needs=
 to
> > be serialized is the assignment of the command sequence number to
> > individual non-immediate PDUs.  The sending of the outgoing PDUs +
> > immediate data by the initiator can happen out-of-order, and it's u=
p to
> > the target to ensure that the submission of the commands to the dev=
ice
> > server is in command sequence number order.
> >=20
> > All of the actual immediate data + R2T -> data-out processing by th=
e
> > target can also be done out-of-order as well.
>=20
> Right, but what he's saying is that we've taken great pains in the MQ
> situation to free our issue queues of all entanglements and cross que=
ue
> locking so they can fly as fast as possible.  If we have to assign an
> in-order sequence number across all the queues, this becomes both a
> cross CPU bus lock point to ensure atomicity and a sync point to ensu=
re
> sequencing.  Na=C3=AFvely that does look to be a bottleneck which wou=
ldn't
> necessarily be mitigated simply by allowing everything to proceed out=
 of
> order after this point.
>=20

The point is that a simple session wide counter for command sequence
number assignment is significantly less overhead than all of the
overhead associated with running a full multipath stack atop multiple
sessions.

Not to mention that our iSCSI/iSER initiator is already taking a sessio=
n
wide lock when sending outgoing PDUs, so adding a session wide counter
isn't adding any additional synchronization overhead vs. what's already
in place.

--nab
