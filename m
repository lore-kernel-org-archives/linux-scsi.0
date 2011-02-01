From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: hpsa: Convert SCSI LLD ->queuecommand() for host_lock less	operation
Date: Tue, 01 Feb 2011 11:13:54 +0200
Message-ID: <4D47CED2.4040303@panasas.com>
References: <1296340702.14831.219.camel@haakon2.linux-iscsi.org>	 <4D44DA55.7060505@garzik.org>	 <1296422299.14831.302.camel@haakon2.linux-iscsi.org>	 <20110131144235.GM27398@beardog.cce.hp.com> <1296505560.14831.389.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:22842 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1BAJN7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2011 04:13:59 -0500
In-Reply-To: <1296505560.14831.389.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: scameron@beardog.cce.hp.com, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, "J.H." <warthog9@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On 01/31/2011 10:26 PM, Nicholas A. Bellinger wrote:
>>> +static void enqueue_cmd_and_start_io(struct ctlr_info *h,
>>> +       struct CommandList *c)
>>> +{
>>> +       unsigned long flags;
>>> +
>>> +       spin_lock_irqsave(&h->lock, flags);
>>> +       __enqueue_cmd_and_start_io(h, c);
>>>         spin_unlock_irqrestore(&h->lock, flags);
>>>  }
>>
>> Should that be "static inline"?  Or maybe the compiler's smart enough
>> to decide whether to inline that on its own these days?
>>
> 
> Inlining both of these makes sense to me.  I will add this change and
> send out an updated [PATCH] with your Reviewed-by shortly.
> 

Don't do that. Yes in an header but in a .c file never do.

If there is only a single user the compiler will inline it.
if there are lots of users then the compiler will choose by
the compile-for-size or not and the function size. In any way
the compiler will make a better choice then you regarding size
and speed gained.

I never put inline in .c files. Just make sure that functions
are not forward declared. (that will kill the inline) and
the gcc will always makes the better choice.

Thanks
Boaz

> Thanks for your comments!
> 
> --nab
