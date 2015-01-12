From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion
Date: Mon, 12 Jan 2015 14:05:06 -0600
Message-ID: <54B428F2.2010507@cs.wisc.edu>
References: <54AD5DDD.2090808@dev.mellanox.co.il> <54AD6563.4040603@suse.de> <54ADA777.6090801@cs.wisc.edu> <54AE36CE.8020509@acm.org> <1420755361.2842.16.camel@haakon3.risingtidesystems.com> <1420756142.11310.9.camel@HansenPartnership.com> <1420757822.2842.39.camel@haakon3.risingtidesystems.com> <1420759360.11310.13.camel@HansenPartnership.com> <1420779808.21830.21.camel@haakon3.risingtidesystems.com> <38CE4ECA-D155-4BF9-9D6D-E1A01ADA05E4@cs.wisc.edu> <54B24117.7050204@dev.mellanox.co.il>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBCZ4TFNN2YMRBAGS2CSQKGQEMB7T6YI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <54B24117.7050204-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 01/11/2015 03:23 AM, Sagi Grimberg wrote:
> On 1/9/2015 8:00 PM, Michael Christie wrote:
> <SNIP>
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
>> binding the session and its resources to specific CPUs. They would
>> only be accessed by the threads on that one CPU, so we get our
>> serialization/synchronization from that. That is why we are saying we
>> do not need something like atomic_t/spin_locks for the sequence number
>> handling for this type of implementation.
>>
>> If we just tried to do this with the old code where the session could
>> be accessed on multiple CPUs then you are right, we need locks/atomics
>> like how we do in the MCS case.
>>
> 
> I don't think we will want to restrict session per CPU. There is a
> tradeoff question of system resources. We might want to allow a user to
> configure multiple HW queues but still not to use too much of the system
> resources. So the session locks would still be used but definitely less
> congested...

Are you talking about specifically the session per CPU or also MCS and
doing a connection per CPU?

Based on the srp work, how bad do you think it will be to do a
session/connection per CPU? What are you thinking will be more common?
Session per 4 CPU? 2 CPUs? 8?

There is also multipath to take into account here. We could do a mq/MCS
session/connection per CPU (or group of CPS) then also one of those per
transport path. We could also do a mq/MCS session/connection per
transport path, then bind those to specific CPUs. Or something in between.

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
