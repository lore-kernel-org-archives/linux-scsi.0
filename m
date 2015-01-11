From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [LSF/MM TOPIC] iSCSI MQ adoption via MCS discussion
Date: Sun, 11 Jan 2015 11:52:39 +0200
Message-ID: <54B247E7.8040009@dev.mellanox.co.il>
References: <54AD5DDD.2090808@dev.mellanox.co.il> <54AD6563.4040603@suse.de> <54ADA777.6090801@cs.wisc.edu> <54AE36CE.8020509@acm.org> <54AE8A02.1030100@dev.mellanox.co.il> <54AE9010.5080609@acm.org> <54AFBDDC.1000107@dev.mellanox.co.il> <5EE87F5E6631894E80EB1A63198F964D040A6A8F@SACMBXIP03.sdcorp.global.sandisk.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Return-path: <open-iscsi+bncBCMYDBGM6EBBB24PZGSQKGQEAM52MAI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <5EE87F5E6631894E80EB1A63198F964D040A6A8F-cXZ6iGhjG0hm/BozF5lIdDJ2aSJ780jGSxCzGc5ayCJWk0Htik3J/w@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, "lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 1
9/2015 3:31 PM, Bart Van Assche wrote:
> On 01/09/15 12:39, Sagi Grimberg wrote:
>> On 1/8/2015 4:11 PM, Bart Van Assche wrote:
>>> On 01/08/15 14:45, Sagi Grimberg wrote:
>>>> Actually I started with that approach, but the independent connections
>>>> under a single session (I-T-Nexus) violates the command ordering
>>>> requirement. Plus, such a solution is specific to iSER...
>>>
>>> Which command ordering requirement are you referring to ? The Linux
>>> storage stack does not guarantee that block layer or SCSI commands will
>>> be processed in the same order as these commands have been submitted.
>>
>> I was referring to the iSCSI session requirement. I initially thought of
>> an approach to maintain multiple iSER connections under a single session
>> but pretty soon I realized that preserving commands ordering this way
>> is not feasible. So independent iSER connections means independent
>> iSCSI sessions (each with a single connection). This is indeed another
>> choice, which we are clearly debating on...
>>
>> I'm just wandering if we are not trying to force-fit this model. How
>> would this model look like? We will need to define another entity to
>> track and maintain the sessions and to allocate the scsi_host. Will that
>> be communicated to user-space? How will error recovery look like?
>
> Hello Sagi,

Hey Bart,

>
> As you probably remember scsi-mq support was added in the SRP initiator
> by changing the 1:1 relationship between scsi_host and RDMA connection
> into a 1:n relationship.

Of course I remember ;)

> I don't know how much work it would take to
> implement a similar transformation in the SCSI initiator. Maybe we
> should wait until Mike's workday starts such that Mike has a chance to
> comment on this.

So the question of the amount of work is not the main concern here.
After all I still think that MCS is a better fit to scsi-mq than coming
up with some other of abstraction layer to manage multiple sessions.
After all, MCS is specified and well defined.

There is the question of cmdsn as a potential synchronization point, but
shouldn't we discuss that instead of trying to get around it? If we
agree that iSCSI session-wide ordering requirements are too restrictive
in most use-cases, why not suggesting some form of relaxed ordering
mode that is would leave ordering to upper layers?

If this kind of mode would appear in the RFC 3720 family, was there
even a question of what we should do?

Sagi.

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
