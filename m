From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 1/1] iscsi: fix regression caused by session lock patch
Date: Wed, 18 Nov 2015 12:39:23 -0600
Message-ID: <564CC5DB.2040509@cs.wisc.edu>
References: <1447304741-6594-1-git-send-email-mchristi@redhat.com> <56447FF7.40600@dev.mellanox.co.il> <5644FD6C.9070805@cs.wisc.edu> <CAJ3xEMjiuCQ_ep1uF-8veM1C8TBvt2HWqgZMLsVmrApGHapT4Q@mail.gmail.com> <56461502.70306@cs.wisc.edu> <CAJ3xEMhQiywXo0=kRO7f=fW--1kc6mbNs_X7wLoYtXmRWeqBkg@mail.gmail.com> <9ECEE53C-B836-4A80-A9D4-4C2EDA74ED8F@cs.wisc.edu> <CAJ3xEMiu4XBO2d1oLnrgay1uLQmY871n9Kn-yp73PAkfKNnp9A@mail.gmail.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Return-path: <open-iscsi+bncBCZ4TFNN2YMRBYULWOZAKGQED5QRHNQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <CAJ3xEMiu4XBO2d1oLnrgay1uLQmY871n9Kn-yp73PAkfKNnp9A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

On 11/18/15, 5:30 AM, Or Gerlitz wrote:
> On Mon, Nov 16, 2015 at 7:30 PM, Michael Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org> wrote:
>>> On Nov 15, 2015, at 4:10 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> On Fri, Nov 13, 2015 at 6:51 PM, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org> wrote:
>>>> On 11/13/2015 09:06 AM, Or Gerlitz wrote:
>
>>> After the locking change, adding a task to any of the connection
>>> mgmtqueue, cmdqueue, or requeue lists is under the session forward lock.
>>>
>>> Removing tasks from any of these lists in iscsi_data_xmit is under
>>> the session forward lock and **before** calling down to the transport
>>> to handle the task.
>>>
>>> The iscsi_complete_task helper was added by Mike's commit
>>> 3bbaaad95fd38ded "[SCSI] libiscsi: handle cleanup task races"
>>> and is indeed typically called under the backward lock && has this section
>>>
>>> +       if (!list_empty(&task->running))
>>> +               list_del_init(&task->running);
>>>
>>> which per my reading of the code never comes into play, can you comment?
>
>> I had sent this to Sagi and your mellanox email the other day:
>
>> The bug occurs when a target completes a command while we are still
>> processing it. If we are doing a WRITE and the iscsi_task
>> is on the cmdqueue because we are handling a R2T.
>
> Mike,
>
> I failed to find how an iscsi_task can be added again to the cmdqueue list,
> nor how it can be added to the requeue list without the right locking, nor how
> can an iscsi_task be on either of these lists when iscsi_complete_task
> is invoked.

Are you only considering normal execution or also the cc case I 
mentioned in the last mail? For normal execution we are ok.

>
> Specifically, my reading of the code says that these are the events over time:
>
> t1. queuecommand :: we put the task on the cmdqueue list
> (libiscsi.c:1741) - under fwd lock
>
> t2. iscsi_data_xmit :: we remove the task from the cmdqueue list
> (libiscsi.c:1537) - under fwd lock
>
> when the R2T flow happens, we do the following
>
> t3. iscsi_tcp_hdr_dissect --> iscsi_tcp_r2t_rsp --> iscsi_requeue_task ::
> put the task on the requeue list -- the call to iscsi_tcp_r2t_rsp is
> under the fwd lock

If the target were to send a CC at this point, we are adding the task 
under the frwd lock, but the completion path would only have the back 
lock. The list_empty, list_add and list_del calls then race and we could 
end up in a bad state right?

>
> t4. iscsi_data_xmit :: we remove the task from the requeue list
> (libiscsi.c: 1578) - under fwd lock

We could also get the bad CC at this time and end up doing 2 list_dels 
at the same time. The t4 one under the frwd lock and the cc handling 
completion one under the back lock like in t3.

>
> Do you agree to t1...t4 being what's possible for a given task? or I
> missed something?
>
>>> The target shouldn't
>>> send a Check Condition at this time, but some do. If that happens, then
>>> iscsi_queuecommand could be adding a new task to the cmdqueue, while the
>>> recv path is handling the CC for the task with the outsanding R2T.  The
>>> recv path iscsi_complete_task call sees that task it on the cmdqueue and
>>> deletes it from the list at the same time iscsi_queuecommand is adding a new task.
>
>
>>> This should not happen per the iscsi spec. There is some wording about
>>> waiting to finish the sequence in progress, but targets goof this up.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
