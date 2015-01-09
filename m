From: Michael Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion
Date: Fri, 9 Jan 2015 12:00:12 -0600
Message-ID: <38CE4ECA-D155-4BF9-9D6D-E1A01ADA05E4@cs.wisc.edu>
References: <54AD5DDD.2090808@dev.mellanox.co.il> <54AD6563.4040603@suse.de> <54ADA777.6090801@cs.wisc.edu> <54AE36CE.8020509@acm.org> <1420755361.2842.16.camel@haakon3.risingtidesystems.com> <1420756142.11310.9.camel@HansenPartnership.com> <1420757822.2842.39.camel@haakon3.risingtidesystems.com> <1420759360.11310.13.camel@HansenPartnership.com> <1420779808.21830.21.camel@haakon3.risingtidesystems.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <open-iscsi+bncBCZ4TFNN2YMRBPVOYCSQKGQE2OWAY5I-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1420779808.21830.21.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


On Jan 8, 2015, at 11:03 PM, Nicholas A. Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wr=
ote:

> On Thu, 2015-01-08 at 15:22 -0800, James Bottomley wrote:
>> On Thu, 2015-01-08 at 14:57 -0800, Nicholas A. Bellinger wrote:
>>> On Thu, 2015-01-08 at 14:29 -0800, James Bottomley wrote:
>>>> On Thu, 2015-01-08 at 14:16 -0800, Nicholas A. Bellinger wrote:
>=20
> <SNIP>
>=20
>>> The point is that a simple session wide counter for command sequence
>>> number assignment is significantly less overhead than all of the
>>> overhead associated with running a full multipath stack atop multiple
>>> sessions.
>>=20
>> I don't see how that's relevant to issue speed, which was the measure we
>> were using: The layers above are just a hopper.  As long as they're
>> loaded, the MQ lower layer can issue at full speed.  So as long as the
>> multipath hopper is efficient enough to keep the queues loaded there's
>> no speed degradation.
>>=20
>> The problem with a sequence point inside the MQ issue layer is that it
>> can cause a stall that reduces the issue speed. so the counter sequence
>> point causes a degraded issue speed over the multipath hopper approach
>> above even if the multipath approach has a higher CPU overhead.
>>=20
>> Now, if the system is close to 100% cpu already, *then* the multipath
>> overhead will try to take CPU power we don't have and cause a stall, but
>> it's only in the flat out CPU case.
>>=20
>>> Not to mention that our iSCSI/iSER initiator is already taking a sessio=
n
>>> wide lock when sending outgoing PDUs, so adding a session wide counter
>>> isn't adding any additional synchronization overhead vs. what's already
>>> in place.
>>=20
>> I'll leave it up to the iSER people to decide whether they're redoing
>> this as part of the MQ work.
>>=20
>=20
> Session wide command sequence number synchronization isn't something to
> be removed as part of the MQ work.  It's a iSCSI/iSER protocol
> requirement.
>=20
> That is, the expected + maximum sequence numbers are returned as part of
> every response PDU, which the initiator uses to determine when the
> command sequence number window is open so new non-immediate commands may
> be sent to the target.
>=20
> So, given some manner of session wide synchronization is required
> between different contexts for the existing single connection case to
> update the command sequence number and check when the window opens, it's
> a fallacy to claim MC/S adds some type of new initiator specific
> synchronization overhead vs. single connection code.

I think you are assuming we are leaving the iscsi code as it is today.

For the non-MCS mq session per CPU design, we would be allocating and bindi=
ng the session and its resources to specific CPUs. They would only be acces=
sed by the threads on that one CPU, so we get our serialization/synchroniza=
tion from that. That is why we are saying we do not need something like ato=
mic_t/spin_locks for the sequence number handling for this type of implemen=
tation.

If we just tried to do this with the old code where the session could be ac=
cessed on multiple CPUs then you are right, we need locks/atomics like how =
we do in the MCS case.

--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
