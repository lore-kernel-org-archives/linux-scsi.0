From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/1] libosd: Fix blk_put_request locking again
Date: Thu, 10 Dec 2009 13:53:43 +0200
Message-ID: <4B20E147.3050005@panasas.com>
References: <4B15367C.9040405@panasas.com> <4B1537F5.6050600@panasas.com> <4B177E0C.60407@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:4661 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934086AbZLJLxh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2009 06:53:37 -0500
In-Reply-To: <4B177E0C.60407@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Vineet Agarwal <checkout.vineet@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

On 12/03/2009 10:59 AM, Boaz Harrosh wrote:
> On 12/01/2009 05:36 PM, Boaz Harrosh wrote:
>>
>> So libosd has decided to sacrifice some code simplicity for the sake of
>> a clean API. One of these things is the possibility for users to call
>> osd_end_request, in any condition at any state. This opens up some
>> problems with calling blk_put_request when out-side of the completion
>> callback but calling __blk_put_request when detecting a from-completion
>> state.
>>
>> The current hack was working just fine until exofs decided to operate on
>> all devices in parallel and wait for the sum of the requests, before
>> deallocating all osd-requests at once. There are two new possible cases
>> 1. All request in a group are deallocated as part of the last request's
>>    async-done, request_queue is locked.
>> 2. All request in a group where executed asynchronously, but
>>    de-allocation was delayed to after the async-done, in the context of
>>    another thread. Async execution but request_queue is not locked.
>>
>> The solution I chose was to separate the deallocation of the osd_request
>> which has the information users need, from the deallocation of the
>> internal(2) requests which impose the locking problem. The internal
>> block-requests are freed unconditionally inside the async-done-callback,
>> when we know the queue is always locked. If at osd_end_request time we
>> still have a bock-request, then we know it did not come from within an
>> async-done-callback and we can call the regular blk_put_request.
>>
>> The internal requests were used for carrying error information after
>> execution. This information is now copied to osd_request members for
>> later analysis by user code.
>>
>> The external API and behaviour was unchanged, except now it really
>> supports what was previously advertised.
>>
>> Reported-by: Vineet Agarwal <checkout.vineet@gmail.com>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> 
> James Hi
> 
> Linus has locked the 2.6.32 Kernel. I absolutely must have this patch
> submitted in this merge window. The all of exofs patches depend on it.
> Please submit ASAP
> 
> Boaz
> 

James I'm reminding you of this patch.
If you do not have another round of patches for the merge window, then please
submit it through rc-fixes. It is a very important bug-fix for exofs.

Thanks
Boaz
