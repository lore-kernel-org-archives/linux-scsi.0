From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion
Date: Thu, 08 Jan 2015 17:26:36 -0600
Message-ID: <54AF122C.9070703@cs.wisc.edu>
References: <54AD5DDD.2090808@dev.mellanox.co.il> <54AD6563.4040603@suse.de>  <54ADA777.6090801@cs.wisc.edu> <54AE36CE.8020509@acm.org>  <1420755361.2842.16.camel@haakon3.risingtidesystems.com>  <1420756142.11310.9.camel@HansenPartnership.com> <1420757822.2842.39.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1420757822.2842.39.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@acm.org>, open-iscsi@googlegroups.com, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@dev.mellanox.co.il>, lsf-pc@lists.linux-foundation.org, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 1/8/15, 4:57 PM, Nicholas A. Bellinger wrote:
> On Thu, 2015-01-08 at 14:29 -0800, James Bottomley wrote:
>> On Thu, 2015-01-08 at 14:16 -0800, Nicholas A. Bellinger wrote:
>>> On Thu, 2015-01-08 at 08:50 +0100, Bart Van Assche wrote:
>>>> On 01/07/15 22:39, Mike Christie wrote:
>>>>> On 01/07/2015 10:57 AM, Hannes Reinecke wrote:
>>>>>> On 01/07/2015 05:25 PM, Sagi Grimberg wrote:
>>>>>>> Hi everyone,
>>>>>>>
>>>>>>> Now that scsi-mq is fully included, we need an iSCSI initiator =
that
>>>>>>> would use it to achieve scalable performance. The need is even =
greater
>>>>>>> for iSCSI offload devices and transports that support multiple =
HW
>>>>>>> queues. As iSER maintainer I'd like to discuss the way we would=
 choose
>>>>>>> to implement that in iSCSI.
>>>>>>>
>>>>>>> My measurements show that iSER initiator can scale up to ~2.1M =
IOPs
>>>>>>> with multiple sessions but only ~630K IOPs with a single sessio=
n where
>>>>>>> the most significant bottleneck the (single) core processing
>>>>>>> completions.
>>>>>>>
>>>>>>> In the existing single connection per session model, given that=
 command
>>>>>>> ordering must be preserved session-wide, we end up in a serial =
command
>>>>>>> execution over a single connection which is basically a single =
queue
>>>>>>> model. The best fit seems to be plugging iSCSI MCS as a multi-q=
ueued
>>>>>>> scsi LLDD. In this model, a hardware context will have a 1x1 ma=
pping
>>>>>>> with an iSCSI connection (TCP socket or a HW queue).
>>>>>>>
>>>>>>> iSCSI MCS and it's role in the presence of dm-multipath layer w=
as
>>>>>>> discussed several times in the past decade(s). The basic need f=
or MCS is
>>>>>>> implementing a multi-queue data path, so perhaps we may want to=
 avoid
>>>>>>> doing any type link aggregation or load balancing to not overla=
p
>>>>>>> dm-multipath. For example we can implement ERL=3D0 (which is ba=
sically the
>>>>>>> scsi-mq ERL) and/or restrict a session to a single portal.
>>>>>>>
>>>>>>> As I see it, the todo's are:
>>>>>>> 1. Getting MCS to work (kernel + user-space) with ERL=3D0 and a
>>>>>>>      round-robin connection selection (per scsi command executi=
on).
>>>>>>> 2. Plug into scsi-mq - exposing num_connections as nr_hw_queues=
 and
>>>>>>>      using blk-mq based queue (conn) selection.
>>>>>>> 3. Rework iSCSI core locking scheme to avoid session-wide locki=
ng
>>>>>>>      as much as possible.
>>>>>>> 4. Use blk-mq pre-allocation and tagging facilities.
>>>>>>>
>>>>>>> I've recently started looking into this. I would like the commu=
nity to
>>>>>>> agree (or debate) on this scheme and also talk about implementa=
tion
>>>>>>> with anyone who is also interested in this.
>>>>>>>
>>>>>> Yes, that's a really good topic.
>>>>>>
>>>>>> I've pondered implementing MC/S for iscsi/TCP but then I've figu=
red my
>>>>>> network implementation knowledge doesn't spread that far.
>>>>>> So yeah, a discussion here would be good.
>>>>>>
>>>>>> Mike? Any comments?
>>>>>
>>>>> I have been working under the assumption that people would be ok =
with
>>>>> MCS upstream if we are only using it to handle the issue where we=
 want
>>>>> to do something like have a tcp/iscsi connection per CPU then map=
 the
>>>>> connection to a blk_mq_hw_ctx. In this more limited MCS implement=
ation
>>>>> there would be no iscsi layer code to do something like load bala=
nce
>>>>> across ports or transport paths like how dm-multipath does, so th=
ere
>>>>> would be no feature/code duplication. For balancing across hctxs,=
 then
>>>>> the iscsi layer would also leave that up to whatever we end up wi=
th in
>>>>> upper layers, so again no feature/code duplication with upper lay=
ers.
>>>>>
>>>>> So pretty non controversial I hope :)
>>>>>
>>>>> If people want to add something like round robin connection selec=
tion in
>>>>> the iscsi layer, then I think we want to leave that for after the
>>>>> initial merge, so people can argue about that separately.
>>>>
>>>> Hello Sagi and Mike,
>>>>
>>>> I agree with Sagi that adding scsi-mq support in the iSER initiato=
r
>>>> would help iSER users because that would allow these users to conf=
igure
>>>> a single iSER target and use the multiqueue feature instead of hav=
ing to
>>>> configure multiple iSER targets to spread the workload over multip=
le
>>>> cpus at the target side.
>>>>
>>>> And I agree with Mike that implementing scsi-mq support in the iSE=
R
>>>> initiator as multiple independent connections probably is a better
>>>> choice than MC/S. RFC 3720 namely requires that iSCSI numbering is
>>>> session-wide. This means maintaining a single counter for all MC/S
>>>> sessions. Such a counter would be a contention point. I'm afraid t=
hat
>>>> because of that counter performance on a multi-socket initiator sy=
stem
>>>> with a scsi-mq implementation based on MC/S could be worse than wi=
th the
>>>> approach with multiple iSER targets. Hence my preference for an ap=
proach
>>>> based on multiple independent iSER connections instead of MC/S.
>>>>
>>>
>>> The idea that a simple session wide counter for command sequence nu=
mber
>>> assignment adds such a degree of contention that it renders MC/S at=
 a
>>> performance disadvantage vs. multi-session configurations with all =
of
>>> the extra multipath logic overhead on top is at best, a naive
>>> proposition.
>>>
>>> On the initiator side for MC/S, literally the only thing that needs=
 to
>>> be serialized is the assignment of the command sequence number to
>>> individual non-immediate PDUs.  The sending of the outgoing PDUs +
>>> immediate data by the initiator can happen out-of-order, and it's u=
p to
>>> the target to ensure that the submission of the commands to the dev=
ice
>>> server is in command sequence number order.
>>>
>>> All of the actual immediate data + R2T -> data-out processing by th=
e
>>> target can also be done out-of-order as well.
>>
>> Right, but what he's saying is that we've taken great pains in the M=
Q
>> situation to free our issue queues of all entanglements and cross qu=
eue
>> locking so they can fly as fast as possible.  If we have to assign a=
n
>> in-order sequence number across all the queues, this becomes both a
>> cross CPU bus lock point to ensure atomicity and a sync point to ens=
ure
>> sequencing.  Na=C3=AFvely that does look to be a bottleneck which wo=
uldn't
>> necessarily be mitigated simply by allowing everything to proceed ou=
t of
>> order after this point.
>>
>
> The point is that a simple session wide counter for command sequence
> number assignment is significantly less overhead than all of the
> overhead associated with running a full multipath stack atop multiple
> sessions.

I think we are still going to want to use dm multipath on top of iscsi=20
for devices that do failover across some sort group of paths like with=20
ALUA, so we have to solve dm multipath problems either way.

There is greater memory overhead, but how bad is it? With lots of CPUs=20
and lots of transport paths, I can see where it could get crazy. I have=
=20
no idea how bad it will be though.

Are you also seeing a perf issue that is caused by dm?

Hannes had an idea where we could merge the lower and upper levels=20
somehow and that might solve some of the issues you are thinking about.

>
> Not to mention that our iSCSI/iSER initiator is already taking a sess=
ion
> wide lock when sending outgoing PDUs, so adding a session wide counte=
r
> isn't adding any additional synchronization overhead vs. what's alrea=
dy
> in place.

I am not sure if we want this to be a deciding factor. I think the=20
session wide lock is something that can be removed in the main IO paths=
=2E

A lot of what it is used for now is cmd/task related handling like list=
=20
accesses. When we have the scsi layer alloc/free/manage that, then we=20
can simplify that a lot for iser/bnx2i/cxgb*i since there send path is=20
less complicated than software iscsi.

It is also used for the state check but I think that is overkill.
