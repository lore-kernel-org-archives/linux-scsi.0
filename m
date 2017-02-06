From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH 1/1] iscsi: fix regression caused by session lock patch
Date: Mon, 6 Feb 2017 21:22:37 +0200
Message-ID: <b43df358-3e26-b1bd-d5c4-24eeb57d91fd@grimberg.me>
References: <1447304741-6594-1-git-send-email-mchristi@redhat.com>
 <CAJ3xEMjiuCQ_ep1uF-8veM1C8TBvt2HWqgZMLsVmrApGHapT4Q@mail.gmail.com>
 <56461502.70306@cs.wisc.edu>
 <CAJ3xEMhQiywXo0=kRO7f=fW--1kc6mbNs_X7wLoYtXmRWeqBkg@mail.gmail.com>
 <20161107181556.cnhwst4nu63xtrqk@straylight.hirudinean.org>
 <5820C68E.6050206@linux.vnet.ibm.com>
 <20161109052142.j4psips7yvx7uohx@straylight.hirudinean.org>
 <631008bd-1e05-2c88-b153-695c76128eb4@linux.vnet.ibm.com>
 <1976057129.23970152.1486402069647.JavaMail.zimbra@redhat.com>
 <469fd8a7-d9d6-1b04-6cf7-0a66ecfea74f@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:32952 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751989AbdBFTWm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 14:22:42 -0500
Received: by mail-wj0-f195.google.com with SMTP id le4so4248011wjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 11:22:41 -0800 (PST)
In-Reply-To: <469fd8a7-d9d6-1b04-6cf7-0a66ecfea74f@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>, Chris Leech <cleech@redhat.com>
Cc: Or Gerlitz <gerlitz.or@gmail.com>, lduncan@suse.com, Mike Christie <michaelc@cs.wisc.edu>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Shlomo Pongratz <shlomop@mellanox.com>

Hey Chris and Guilherme,

I'm indeed not responsive under this email address.

>> Thanks for the testing, looks like you have the magic target to reproduce this.
>>
>> I think this verifies what Mike's idea of what was going wrong, and we're way overdue to get this fixed upstream.  Thanks to IBM for pushing this, I don't think any major distro is shipping this patch and we don't want to keep having to back it out.
>>
>> The options look like
>> 1) back out the session lock changes that split it into two locks
>> 2) add in the additional locking from this test patch
>> 3) some other fix for the issue of targets that complete tasks oddly
>>
>> I'm leaning to #1, as I don't want to keep adding more locks for this.
>
> Thanks Chris! IIRC, the lock changes from Shlomo/Or are not on RHEL,
> SLES and Ubuntu anymore, as you mentioned. We requested them to revert
> the patch, and it was accepted.
>
> On the other hand, your patch is great and a cool fix to this. If we
> have any good numbers and/or reasons to keep their patch, guess the
> alternative #2 is cool too. I can perform more testing if you plan to
> send this (or similar) patch to iscsi list.
>
>
>> Sagi, Or, Shlomo?  You pushed to keep this from being backed out before.  Here's your cause, any better ideas on fixing it?  I also tried to go back in the mailing list archives, but I don't see any real numbers for the performance gains.
>
> I'll loop Sagi here based on the email I see he's using on NVMe list
> currently - seems it's different from the one showed in the header of
> this message.

IIRC, this was brought up more than two years ago? it's been
a while now.

The motivation for the fined grained locking from Shlomo was
designed to address the submission/completion inter-locking
scheme that was not needed for iser.

In iser, task completions are triggered from soft-irq only for
task responses, the data-transfer is driven in HW, so we don't need
the inter-locking between submissions and task management or error
handling.

My recollection is that this scheme solved a contention point we had
back then, if I'm not mistaken it was as much as 50% improvement in
IOPs scalability in some scenarios.

Now, this was all pre block-mq. So I think the correct solution for
iscsi (iser, tcp and offloads) is to use block-mq facilities for
task pre-allocations (scsi host tagset) and have iscsi tcp take care
of it's own locking instead of imposing it inherently in libiscsi.

We can have LOGIN, LOGOUT, NOOP_OUT, TEXT, TMR as reserved tags,
and queue_depth with max session cmds. I had a prototype for that
back when I experimented with scsi-mq conversion (way back...),
but kinda got stuck with trying to figure out how to convert the
offload drivers qla4xxx, bnx2i and cxgbi which seemed to rely heavily
on on the task pools.

If people are more interested in improving iscsi locking schemes we
can discuss on approaches for it.
