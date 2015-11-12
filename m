From: Chris Leech <leech@pobox.com>
Subject: Re: [PATCH 1/1] iscsi: fix regression caused by session lock patch
Date: Thu, 12 Nov 2015 13:33:30 -0800
Message-ID: <CAHNqLyWjuTkZEGAfoAkOZxeYYnuwbC9xctEdi5TGttXVC5NVDA@mail.gmail.com>
References: <1447304741-6594-1-git-send-email-mchristi@redhat.com>
	<56447FF7.40600@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f196.google.com ([209.85.213.196]:36592 "EHLO
	mail-ig0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbbKLVda (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Nov 2015 16:33:30 -0500
Received: by igbmn7 with SMTP id mn7so387836igb.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Nov 2015 13:33:30 -0800 (PST)
In-Reply-To: <56447FF7.40600@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: mchristi@redhat.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Guilherme Piccoli <gpiccoli@linux.vnet.ibm.com>, Or Gerlitz <ogerlitz@mellanox.com>, shlomopongratz@gmail.com

On Thu, Nov 12, 2015 at 4:03 AM, Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:
>
>> The bug is caused by this patch:
>>
>> 659743b02c411075b26601725947b21df0bb29c8
>>
>> which allowed the task lists to be manipulated under different locks
>> in the xmit and completion path.
>>
>> To fix the oops this patch just reverts that patch. It also reverts
>> these 2 patches for regressions that were also a result of that patch:
>
>
> Whoa now Mike, this is a major change. Can we take a step back and think
> about this for a second?
>
> My understanding is that the kfifo circular buffer design allows a
> writer (e.g. the producer) and a reader (e.g. the consumer) to avoid
> extra locking when accessing the kfifo buffer.

I don't think the problem is with the kfifo cmdpool, but rather the
connection mgmtqueue/cmdqueue linked lists.   iscsi_task structs are linked
in using the task->running list_head.

- Chris
