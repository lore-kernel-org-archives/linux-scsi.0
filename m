From: Michael Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 1/1] iscsi: fix regression caused by session lock patch
Date: Mon, 16 Nov 2015 11:30:38 -0600
Message-ID: <9ECEE53C-B836-4A80-A9D4-4C2EDA74ED8F@cs.wisc.edu>
References: <1447304741-6594-1-git-send-email-mchristi@redhat.com> <56447FF7.40600@dev.mellanox.co.il> <5644FD6C.9070805@cs.wisc.edu> <CAJ3xEMjiuCQ_ep1uF-8veM1C8TBvt2HWqgZMLsVmrApGHapT4Q@mail.gmail.com> <56461502.70306@cs.wisc.edu> <CAJ3xEMhQiywXo0=kRO7f=fW--1kc6mbNs_X7wLoYtXmRWeqBkg@mail.gmail.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0 (Mac OS X Mail 9.1 \(3096.5\))
Content-Type: text/plain; charset=UTF-8
Return-path: <open-iscsi+bncBCZ4TFNN2YMRBRVFVCZAKGQE6FEXCAQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <CAJ3xEMhQiywXo0=kRO7f=fW--1kc6mbNs_X7wLoYtXmRWeqBkg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Guilherme Piccoli <gpiccoli-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shlomo Pongratz <shlomopongratz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


> On Nov 15, 2015, at 4:10 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> On Fri, Nov 13, 2015 at 6:51 PM, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org> wrote:
>> On 11/13/2015 09:06 AM, Or Gerlitz wrote:
>>>> The patch has caused multiple regressions, did not even compile when
>>>>> sent to me, and was poorly reviewed and I have not heard from you guys
>>>>> in a week. Given the issues the patch has had and the current time, I do
>>>>> not feel comfortable with it anymore. I want to re-review it and fix it
>>>>> up when there is more time.
>>> Mike (Hi),
>>> 
>>> It's a complex patch that touches all the iscsi transports, and yes,
>>> when it was send to you the 1st time, there was build error on one of
>>> the offload transports (bad! but happens) and yes, as you pointed, one
>>> static checker fix + one bug fix for it went upstream after this has
>>> been merged, happens too.
>> 
>> A patch should not cause this many issues.
>> 
>>> What makes you say it was poorly reviewed?
>> 
>> I just did not do a good job at looking at the patch. I should have
>> caught all of these issues.
>> 
>> - The bnx2i cleanup_task bug should have been obvious, especially for me
>> because I had commented about the back lock and the abort path.
>> 
>> - This oops, was so basic. Incorrect locking around a linked list being
>> accessed from 2 threads is really one of those 1st year kernel
>> programmer things.
> 
> Mike, Chris
> 
> After the locking change, adding a task to any of the connection
> mgmtqueue, cmdqueue, or requeue lists is under the session forward lock.
> 
> Removing tasks from any of these lists in iscsi_data_xmit is under
> the session forward lock and **before** calling down to the transport
> to handle the task.
> 
> The iscsi_complete_task helper was added by Mike's commit
> 3bbaaad95fd38ded "[SCSI] libiscsi: handle cleanup task races"
> and is indeed typically called under the backward lock && has this section
> 
> +       if (!list_empty(&task->running))
> +               list_del_init(&task->running);
> 
> which per my reading of the code never comes into play, can you comment?


I had sent this to Sagi and your mellanox email the other day:


> The bug occurs when a target completes a command while we are still
> processing it. If we are doing a WRITE and the iscsi_task
> is on the cmdqueue because we are handling a R2T. The target shouldn't
> send a Check Condition at this time, but some do. If that happens, then
> iscsi_queuecommand could be adding a new task to the cmdqueue, while the
> recv path is handling the CC for the task with the outsanding R2T.  The
> recv path iscsi_complete_task call sees that task it on the cmdqueue and
> deletes it from the list at the same time iscsi_queuecommand is adding a new
> task.
> 
> This should not happen per the iscsi spec. There is some wording about
> waiting to finish the sequence in progress, but targets goof this up.




-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
