From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RFC] Remove the cancel_delayed_work() call from scsi_put_command()
Date: Fri, 23 May 2014 13:28:22 +0200
Message-ID: <537F30D6.9060206@redhat.com>
References: <537CAA79.2030304@acm.org> <537EE637.50408@suse.de> <537F13B6.2060708@redhat.com> <537F24FA.7000608@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbaEWL2y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2014 07:28:54 -0400
In-Reply-To: <537F24FA.7000608@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Joe Lawrence <jdl1291@gmail.com>

Il 23/05/2014 12:37, Bart Van Assche ha scritto:
> On 05/23/14 11:24, Paolo Bonzini wrote:
>> Il 23/05/2014 08:09, Hannes Reinecke ha scritto:
>>>
>>> And when freeing a command we absolutely need to make sure that
>>> the workqueue is empty.
>>> So calling cancel_delayed_work() was the obvious thing to do.
>>
>> You would need cancel_delayed_work_sync, but if it really happened that
>> the work item is running, it would cause a double free.
>>
>>> I'd be fine with adding a WARN_ON(!list_empty(&cmd->abort_work))
>>> here, however. This will clear up the intent of this statement.
>>
>> BUG_ON even, since you'd get badness from the double free anyway.
>
> Hello Paolo,
>
> Are you aware that Linus strongly prefers WARN_ON_ONCE() over BUG_ON() ?
> See e.g. https://lkml.org/lkml/2012/9/27/461 or
> https://lkml.org/lkml/2014/4/28/657.

Yes, I am and I even downgraded some KVM BUG_ONs recently.

But in this case I think that memory corruption is going to happen 
anyway unless you consciously leak the Scsi_Cmnd * (because if you use 
WARN_ON, you also need to return early as Linus suggested in the second 
email).

So the WARN_ON/BUG_ON choice here should not just consider what makes 
the problem easier to debug; hanging the machine before guaranteed 
badness seems to me like a good use for BUG_ON.

Paolo
