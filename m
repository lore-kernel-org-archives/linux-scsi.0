From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH 1/1] iscsi: fix regression caused by session lock patch
Date: Tue, 17 Nov 2015 18:55:52 +0200
Message-ID: <CAJ3xEMino5AwBaj=LYAUbTga7SyXiB1ZMxunOejS3WnXKTq+eg@mail.gmail.com>
References: <1447304741-6594-1-git-send-email-mchristi@redhat.com>
	<56447FF7.40600@dev.mellanox.co.il>
	<5644FD6C.9070805@cs.wisc.edu>
	<CAJ3xEMjiuCQ_ep1uF-8veM1C8TBvt2HWqgZMLsVmrApGHapT4Q@mail.gmail.com>
	<56461502.70306@cs.wisc.edu>
	<CAJ3xEMhQiywXo0=kRO7f=fW--1kc6mbNs_X7wLoYtXmRWeqBkg@mail.gmail.com>
	<9ECEE53C-B836-4A80-A9D4-4C2EDA74ED8F@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:34003 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbbKQQzw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2015 11:55:52 -0500
Received: by ioo197 with SMTP id 197so2632964ioo.1
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2015 08:55:52 -0800 (PST)
In-Reply-To: <9ECEE53C-B836-4A80-A9D4-4C2EDA74ED8F@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Christie <michaelc@cs.wisc.edu>
Cc: Chris Leech <cleech@redhat.com>, open-iscsi@googlegroups.com, Sagi Grimberg <sagig@dev.mellanox.co.il>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Guilherme Piccoli <gpiccoli@linux.vnet.ibm.com>, Or Gerlitz <ogerlitz@mellanox.com>, Shlomo Pongratz <shlomopongratz@gmail.com>

On Mon, Nov 16, 2015 at 7:30 PM, Michael Christie <michaelc@cs.wisc.edu> wrote:
>> On Nov 15, 2015, at 4:10 AM, Or Gerlitz <gerlitz.or@gmail.com> wrote:

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
>> which per my reading of the code never comes into play, can you comment?

>> The bug occurs when a target completes a command while we are still
>> processing it. If we are doing a WRITE and the iscsi_task
>> is on the cmdqueue because we are handling a R2T. The target shouldn't
>> send a Check Condition at this time, but some do. If that happens, then
>> iscsi_queuecommand could be adding a new task to the cmdqueue, while the
>> recv path is handling the CC for the task with the outsanding R2T.  The
>> recv path iscsi_complete_task call sees that task it on the cmdqueue and
>> deletes it from the list at the same time iscsi_queuecommand is adding a new
>> task.

So we're now a bit beyond trivial bug and

>> This should not happen per the iscsi spec. There is some wording about
>> waiting to finish the sequence in progress, but targets goof this up.

we have target/s that violate the spec, this is life, but can explain
why it took us 18m to get
bug report. Can you provide few point pointers into the relevant code
pieces that one need
to look at to realize what's going on there? was this code added
before or after the patch?

Or.
