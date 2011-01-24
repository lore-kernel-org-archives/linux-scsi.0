From: Joe Eykholt <joe.eykholt@gmail.com>
Subject: Re: [PATCH 3/3] target: Minor sparse warning fixes and annotations
Date: Mon, 24 Jan 2011 15:18:18 -0800
Message-ID: <4D3E08BA.6000105@gmail.com>
References: <1295901446-17089-1-git-send-email-nab@linux-iscsi.org>	 <1295901446-17089-4-git-send-email-nab@linux-iscsi.org>	 <1295902567.15425.13.camel@mulgrave.site> <1295904802.24778.47.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34198 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab1AXXSf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jan 2011 18:18:35 -0500
Received: by pva4 with SMTP id 4so768409pva.19
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jan 2011 15:18:34 -0800 (PST)
In-Reply-To: <1295904802.24778.47.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Fubo Chen <fubo.chen@gmail.com>, Christoph Hellwig <hch@lst.de>

On 1/24/11 1:33 PM, Nicholas A. Bellinger wrote:
> On Mon, 2011-01-24 at 14:56 -0600, James Bottomley wrote:
>> On Mon, 2011-01-24 at 12:37 -0800, Nicholas A. Bellinger wrote:
>>> -#define TASK_CMD(task) ((struct se_cmd *)task->task_se_cmd)
>>> -#define TASK_DEV(task) ((struct se_device *)task->se_dev)
>>> +#define TASK_CMD(task) ((task)->task_se_cmd)
>>> +#define TASK_DEV(task) ((task)->se_dev)
Part of the problem with the old code is that task was not parenthesized,
so if TASK_CMD() were used with an expression, you might not get what
you want.  If you did TASK_CMD(p + 5), for example, you would get

     ((struct se_cmd *)p + 5->task_se_cmd)

Which wouldn't compile, but maybe other examples would compile and
would cause strange problems.   So, it's a bad macro as it is.
Just my 2 cents.

      Cheers,
      Joe

>>> If sparse is objecting to things like this then sparse needs fixing:
>>> It's decreasing typesafety.  the things being cast are void * ... they'd
>>> be depositable into any pointer whatsoever without the cast.  With the
>>> cast in the #define, we pick up pointer mismatches (as we should).
>>> Without it, we don't.  As long as the define is always a specific type,
>>> it *should* cast to it.
>>>
>
> Hmmm, good point..  In that case I will go ahead and drop this part of
> the patch.
>
> Thanks!
>
> --nab
>

