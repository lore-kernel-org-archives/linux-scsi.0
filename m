From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion
Date: Fri, 09 Jan 2015 19:28:13 +0100
Message-ID: <54B01DBD.5020707@suse.de>
References: <54AD5DDD.2090808@dev.mellanox.co.il> <54AD6563.4040603@suse.de> <54ADA777.6090801@cs.wisc.edu> <54AE36CE.8020509@acm.org> <1420755361.2842.16.camel@haakon3.risingtidesystems.com> <1420756142.11310.9.camel@HansenPartnership.com> <1420757822.2842.39.camel@haakon3.risingtidesystems.com> <1420759360.11310.13.camel@HansenPartnership.com> <1420779808.21830.21.camel@haakon3.risingtidesystems.com> <38CE4ECA-D155-4BF9-9D6D-E1A01ADA05E4@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <38CE4ECA-D155-4BF9-9D6D-E1A01ADA05E4@cs.wisc.edu>
Sender: target-devel-owner@vger.kernel.org
To: Michael Christie <michaelc@cs.wisc.edu>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, lsf-pc@lists.linux-foundation.org, Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, target-devel <target-devel@vger.kernel.org>, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On 01/09/2015 07:00 PM, Michael Christie wrote:
>=20
> On Jan 8, 2015, at 11:03 PM, Nicholas A. Bellinger <nab@linux-iscsi.o=
rg> wrote:
>=20
>> On Thu, 2015-01-08 at 15:22 -0800, James Bottomley wrote:
>>> On Thu, 2015-01-08 at 14:57 -0800, Nicholas A. Bellinger wrote:
>>>> On Thu, 2015-01-08 at 14:29 -0800, James Bottomley wrote:
>>>>> On Thu, 2015-01-08 at 14:16 -0800, Nicholas A. Bellinger wrote:
>>
>> <SNIP>
>>
>>>> The point is that a simple session wide counter for command sequen=
ce
>>>> number assignment is significantly less overhead than all of the
>>>> overhead associated with running a full multipath stack atop multi=
ple
>>>> sessions.
>>>
>>> I don't see how that's relevant to issue speed, which was the measu=
re we
>>> were using: The layers above are just a hopper.  As long as they're
>>> loaded, the MQ lower layer can issue at full speed.  So as long as =
the
>>> multipath hopper is efficient enough to keep the queues loaded ther=
e's
>>> no speed degradation.
>>>
>>> The problem with a sequence point inside the MQ issue layer is that=
 it
>>> can cause a stall that reduces the issue speed. so the counter sequ=
ence
>>> point causes a degraded issue speed over the multipath hopper appro=
ach
>>> above even if the multipath approach has a higher CPU overhead.
>>>
>>> Now, if the system is close to 100% cpu already, *then* the multipa=
th
>>> overhead will try to take CPU power we don't have and cause a stall=
, but
>>> it's only in the flat out CPU case.
>>>
>>>> Not to mention that our iSCSI/iSER initiator is already taking a s=
ession
>>>> wide lock when sending outgoing PDUs, so adding a session wide cou=
nter
>>>> isn't adding any additional synchronization overhead vs. what's al=
ready
>>>> in place.
>>>
>>> I'll leave it up to the iSER people to decide whether they're redoi=
ng
>>> this as part of the MQ work.
>>>
>>
>> Session wide command sequence number synchronization isn't something=
 to
>> be removed as part of the MQ work.  It's a iSCSI/iSER protocol
>> requirement.
>>
>> That is, the expected + maximum sequence numbers are returned as par=
t of
>> every response PDU, which the initiator uses to determine when the
>> command sequence number window is open so new non-immediate commands=
 may
>> be sent to the target.
>>
>> So, given some manner of session wide synchronization is required
>> between different contexts for the existing single connection case t=
o
>> update the command sequence number and check when the window opens, =
it's
>> a fallacy to claim MC/S adds some type of new initiator specific
>> synchronization overhead vs. single connection code.
>=20
> I think you are assuming we are leaving the iscsi code as it is today=
=2E
>=20
> For the non-MCS mq session per CPU design, we would be allocating and
> binding the session and its resources to specific CPUs. They would on=
ly
> be accessed by the threads on that one CPU, so we get our
> serialization/synchronization from that. That is why we are saying we
> do not need something like atomic_t/spin_locks for the sequence numbe=
r
> handling for this type of implementation.
>=20
Wouldn't that need to be coordinated with the networking layer?
Doesn't it do the same thing, matching TX/RX queues to CPUs?
If so, wouldn't we decrease bandwidth by restricting things to one CPU?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
