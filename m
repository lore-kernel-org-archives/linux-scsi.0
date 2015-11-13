From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH 1/1] iscsi: fix regression caused by session lock patch
Date: Fri, 13 Nov 2015 17:06:38 +0200
Message-ID: <CAJ3xEMjiuCQ_ep1uF-8veM1C8TBvt2HWqgZMLsVmrApGHapT4Q@mail.gmail.com>
References: <1447304741-6594-1-git-send-email-mchristi@redhat.com>
	<56447FF7.40600@dev.mellanox.co.il>
	<5644FD6C.9070805@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f195.google.com ([209.85.213.195]:35697 "EHLO
	mail-ig0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932520AbbKMPGj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Nov 2015 10:06:39 -0500
Received: by igbhv6 with SMTP id hv6so2594453igb.2
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2015 07:06:38 -0800 (PST)
In-Reply-To: <5644FD6C.9070805@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, mchristi@redhat.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Guilherme Piccoli <gpiccoli@linux.vnet.ibm.com>, Or Gerlitz <ogerlitz@mellanox.com>, Shlomo Pongratz <shlomopongratz@gmail.com>

On Thu, Nov 12, 2015 at 10:58 PM, Mike Christie <michaelc@cs.wisc.edu> wrote:
> On 11/12/2015 06:03 AM, Sagi Grimberg wrote:
>>> The bug is caused by this patch:
>>>
>>> 659743b02c411075b26601725947b21df0bb29c8
>>>
>>> which allowed the task lists to be manipulated under different locks
>>> in the xmit and completion path.

>>> To fix the oops this patch just reverts that patch. It also reverts
>>> these 2 patches for regressions that were also a result of that patch:

>> Whoa now Mike, this is a major change. Can we take a step back and think
>> about this for a second?

> The issue has been on the open-iscsi list for a week! You are on the
> list still right? Or is even ccd on the thread.

The email you sent me a week ago also cc-ed open-iscsi hence was
routed by a rule in my mailer that made it to land in my open-iscsi
subscription folder which is don't visit much nowadays. Only when you
posted to linux-scsi we saw that and responded within few hours, to
begin with.

>> Can you provide a more detailed analysis of why is this list corruption
>> triggered? What scenario was not honoring the locking policy?

> Basic locking around a linked list bug. iscsi_queuecommand adds it under
> the frwd lock and iscsi_complete_task was taking it off the back_lock.

>> This code has been running reliably in our labs for a long time now
>> (both iser and tcp).

> The patch has caused multiple regressions, did not even compile when
> sent to me, and was poorly reviewed and I have not heard from you guys
> in a week. Given the issues the patch has had and the current time, I do
> not feel comfortable with it anymore. I want to re-review it and fix it
> up when there is more time.

Mike (Hi),

It's a complex patch that touches all the iscsi transports, and yes,
when it was send to you the 1st time, there was build error on one of
the offload transports (bad! but happens) and yes, as you pointed, one
static checker fix + one bug fix for it went upstream after this has
been merged, happens too.

What makes you say it was poorly reviewed?

And now after few years in upstream a possibly real bug was found
(happens), why rush and revert? lets see if we can fix.

Or.
