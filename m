From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion
Date: Fri, 09 Jan 2015 14:19:11 -0600
Message-ID: <54B037BF.1010903@cs.wisc.edu>
References: <54AD5DDD.2090808@dev.mellanox.co.il> <54AD6563.4040603@suse.de> <54ADA777.6090801@cs.wisc.edu> <54AE36CE.8020509@acm.org> <1420755361.2842.16.camel@haakon3.risingtidesystems.com> <1420756142.11310.9.camel@HansenPartnership.com> <1420757822.2842.39.camel@haakon3.risingtidesystems.com> <1420759360.11310.13.camel@HansenPartnership.com> <1420779808.21830.21.camel@haakon3.risingtidesystems.com> <38CE4ECA-D155-4BF9-9D6D-E1A01ADA05E4@cs.wisc.edu> <54B01DBD.5020707@suse.de>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBCZ4TFNN2YMRBTHPYCSQKGQEJSG2PPA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <54B01DBD.5020707-l3A5Bk7waGM@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 01/09/2015 12:28 PM, Hannes Reinecke wrote:
> On 01/09/2015 07:00 PM, Michael Christie wrote:
>>
>> On Jan 8, 2015, at 11:03 PM, Nicholas A. Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
>>
>>> On Thu, 2015-01-08 at 15:22 -0800, James Bottomley wrote:
>>>> On Thu, 2015-01-08 at 14:57 -0800, Nicholas A. Bellinger wrote:
>>>>> On Thu, 2015-01-08 at 14:29 -0800, James Bottomley wrote:
>>>>>> On Thu, 2015-01-08 at 14:16 -0800, Nicholas A. Bellinger wrote:
>>>
>>> <SNIP>
>>>
>>>>> The point is that a simple session wide counter for command sequence
>>>>> number assignment is significantly less overhead than all of the
>>>>> overhead associated with running a full multipath stack atop multiple
>>>>> sessions.
>>>>
>>>> I don't see how that's relevant to issue speed, which was the measure we
>>>> were using: The layers above are just a hopper.  As long as they're
>>>> loaded, the MQ lower layer can issue at full speed.  So as long as the
>>>> multipath hopper is efficient enough to keep the queues loaded there's
>>>> no speed degradation.
>>>>
>>>> The problem with a sequence point inside the MQ issue layer is that it
>>>> can cause a stall that reduces the issue speed. so the counter sequence
>>>> point causes a degraded issue speed over the multipath hopper approach
>>>> above even if the multipath approach has a higher CPU overhead.
>>>>
>>>> Now, if the system is close to 100% cpu already, *then* the multipath
>>>> overhead will try to take CPU power we don't have and cause a stall, but
>>>> it's only in the flat out CPU case.
>>>>
>>>>> Not to mention that our iSCSI/iSER initiator is already taking a session
>>>>> wide lock when sending outgoing PDUs, so adding a session wide counter
>>>>> isn't adding any additional synchronization overhead vs. what's already
>>>>> in place.
>>>>
>>>> I'll leave it up to the iSER people to decide whether they're redoing
>>>> this as part of the MQ work.
>>>>
>>>
>>> Session wide command sequence number synchronization isn't something to
>>> be removed as part of the MQ work.  It's a iSCSI/iSER protocol
>>> requirement.
>>>
>>> That is, the expected + maximum sequence numbers are returned as part of
>>> every response PDU, which the initiator uses to determine when the
>>> command sequence number window is open so new non-immediate commands may
>>> be sent to the target.
>>>
>>> So, given some manner of session wide synchronization is required
>>> between different contexts for the existing single connection case to
>>> update the command sequence number and check when the window opens, it's
>>> a fallacy to claim MC/S adds some type of new initiator specific
>>> synchronization overhead vs. single connection code.
>>
>> I think you are assuming we are leaving the iscsi code as it is today.
>>
>> For the non-MCS mq session per CPU design, we would be allocating and
>> binding the session and its resources to specific CPUs. They would only
>> be accessed by the threads on that one CPU, so we get our
>> serialization/synchronization from that. That is why we are saying we
>> do not need something like atomic_t/spin_locks for the sequence number
>> handling for this type of implementation.
>>
> Wouldn't that need to be coordinated with the networking layer?

Yes.

> Doesn't it do the same thing, matching TX/RX queues to CPUs?

Yes.

> If so, wouldn't we decrease bandwidth by restricting things to one CPU?

We have a session or connection per CPU though, so we end up hitting the
same problem you talked about last year where one hctx (iscsi session or
connection's socket or nic hw queue) could get overloaded. This is what
I meant in my original mail where iscsi would rely on whatever blk/mq
load balancers we end up implementing at that layer to balance requests
across hctxs.

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
