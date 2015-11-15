From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH 1/1] iscsi: fix regression caused by session lock patch
Date: Sun, 15 Nov 2015 12:10:48 +0200
Message-ID: <CAJ3xEMhQiywXo0=kRO7f=fW--1kc6mbNs_X7wLoYtXmRWeqBkg@mail.gmail.com>
References: <1447304741-6594-1-git-send-email-mchristi@redhat.com>
	<56447FF7.40600@dev.mellanox.co.il>
	<5644FD6C.9070805@cs.wisc.edu>
	<CAJ3xEMjiuCQ_ep1uF-8veM1C8TBvt2HWqgZMLsVmrApGHapT4Q@mail.gmail.com>
	<56461502.70306@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35233 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbbKOKKs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2015 05:10:48 -0500
Received: by ioc74 with SMTP id 74so13921274ioc.2
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2015 02:10:48 -0800 (PST)
In-Reply-To: <56461502.70306@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Chris Leech <cleech@redhat.com>, open-iscsi@googlegroups.com
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Guilherme Piccoli <gpiccoli@linux.vnet.ibm.com>, Or Gerlitz <ogerlitz@mellanox.com>, Shlomo Pongratz <shlomopongratz@gmail.com>

On Fri, Nov 13, 2015 at 6:51 PM, Mike Christie <michaelc@cs.wisc.edu> wrote:
> On 11/13/2015 09:06 AM, Or Gerlitz wrote:
>>> The patch has caused multiple regressions, did not even compile when
>>> > sent to me, and was poorly reviewed and I have not heard from you guys
>>> > in a week. Given the issues the patch has had and the current time, I do
>>> > not feel comfortable with it anymore. I want to re-review it and fix it
>>> > up when there is more time.
>> Mike (Hi),
>>
>> It's a complex patch that touches all the iscsi transports, and yes,
>> when it was send to you the 1st time, there was build error on one of
>> the offload transports (bad! but happens) and yes, as you pointed, one
>> static checker fix + one bug fix for it went upstream after this has
>> been merged, happens too.
>
> A patch should not cause this many issues.
>
>> What makes you say it was poorly reviewed?
>
> I just did not do a good job at looking at the patch. I should have
> caught all of these issues.
>
> - The bnx2i cleanup_task bug should have been obvious, especially for me
> because I had commented about the back lock and the abort path.
>
> - This oops, was so basic. Incorrect locking around a linked list being
> accessed from 2 threads is really one of those 1st year kernel
> programmer things.

Mike, Chris

After the locking change, adding a task to any of the connection
mgmtqueue, cmdqueue, or requeue lists is under the session forward lock.

Removing tasks from any of these lists in iscsi_data_xmit is under
the session forward lock and **before** calling down to the transport
to handle the task.

The iscsi_complete_task helper was added by Mike's commit
3bbaaad95fd38ded "[SCSI] libiscsi: handle cleanup task races"
and is indeed typically called under the backward lock && has this section

+       if (!list_empty(&task->running))
+               list_del_init(&task->running);

which per my reading of the code never comes into play, can you comment?

Lets address this area before we move to the others claims made on the patch.

Again, the patch is around for ~18 months, since 3.15, and no deep
complaints so far, lets
not jump to conclusions.

Or.
