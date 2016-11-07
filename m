From: "Guilherme G. Piccoli" <gpiccoli-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 1/1] iscsi: fix regression caused by session lock patch
Date: Mon, 7 Nov 2016 16:23:10 -0200
Message-ID: <5820C68E.6050206@linux.vnet.ibm.com>
References: <1447304741-6594-1-git-send-email-mchristi@redhat.com>
 <56447FF7.40600@dev.mellanox.co.il> <5644FD6C.9070805@cs.wisc.edu>
 <CAJ3xEMjiuCQ_ep1uF-8veM1C8TBvt2HWqgZMLsVmrApGHapT4Q@mail.gmail.com>
 <56461502.70306@cs.wisc.edu>
 <CAJ3xEMhQiywXo0=kRO7f=fW--1kc6mbNs_X7wLoYtXmRWeqBkg@mail.gmail.com>
 <20161107181556.cnhwst4nu63xtrqk@straylight.hirudinean.org>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBD235QUNTYKBBE4NQPAQKGQEHQI5VFQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <20161107181556.cnhwst4nu63xtrqk-r8IHplWLGbA5tHQWs+pTeqPFFGjUI2lm2LY78lusg7I@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lduncan-IBi9RG/b67k@public.gmane.org, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shlomo Pongratz <shlomopongratz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 11/07/2016 04:15 PM, Chris Leech wrote:
> Hi,
> 
> I'm kicking this old thread because I don't think this ever got
> resolved.  I wish I had more info, but it seems to involve target
> specific behavior that hasn't come up in our test labs.

Thanks very much for reopening this thread! We have the Or's patch
reverted in multiple distros, so the issue is not likely to happen on
customer's from IBM, but upstream kernel never saw a proper fix for this.


> 
> So what can I do at this point to help resolve this?
> 
> On Sun, Nov 15, 2015 at 12:10:48PM +0200, Or Gerlitz wrote:
>> Mike, Chris
>>
>> After the locking change, adding a task to any of the connection
>> mgmtqueue, cmdqueue, or requeue lists is under the session forward lock.
>>
>> Removing tasks from any of these lists in iscsi_data_xmit is under
>> the session forward lock and **before** calling down to the transport
>> to handle the task.
>>
>> The iscsi_complete_task helper was added by Mike's commit
>> 3bbaaad95fd38ded "[SCSI] libiscsi: handle cleanup task races"
>> and is indeed typically called under the backward lock && has this section
>>
>> +       if (!list_empty(&task->running))
>> +               list_del_init(&task->running);
>>
>> which per my reading of the code never comes into play, can you comment?
>>
>> Lets address this area before we move to the others claims made on the patch.
> 
> This bit in particular is where I see a cause for concern.  If that
> list_del_init call ever races against other list operations, there's a
> potential corruption.  It's presumably there for a reason, and Mike
> explained a case where some targets have been known to send a check
> condition at unexpected times that would hit it.
> 
> I don't like having known list locking violations hanging around, based
> on an expectation that we'll never hit that path with well behaved
> targets.
> 
> If we can get a fix worked up for the list locking here, can we get any
> testing on it from the original reports at IBM?  That was very helpful
> in testing a full reversion patch.

Sure! Count on us to test any patches. I guess the first step is to
reproduce on upstream right? We haven't tested specifically this
scenario for long time. Will try to reproduce on 4.9-rc4 and update here.

Cheers,



Guilherme


> 
> - Chris Leech
> 

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
