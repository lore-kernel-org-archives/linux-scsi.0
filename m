From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [RFC v2 PATCH 1/2] bsg: Add infrastructure to send in kernel
 bsg commands.
Date: Fri, 20 May 2011 18:26:52 -0400
Message-ID: <alpine.LFD.2.02.1105201816550.4468@localhost6.localdomain6>
References: <alpine.LFD.2.02.1105181445490.7238@localhost6.localdomain6> <20110521010226J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:10170
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753307Ab1ETW1C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 May 2011 18:27:02 -0400
In-Reply-To: <20110521010226J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



On Fri, 20 May 2011, FUJITA Tomonori wrote:

> On Wed, 18 May 2011 14:47:13 -0400
> Chad Dupuis <chad.dupuis@qlogic.com> wrote:
>
>> From: Chad Dupuis <chad.dupuis@qlogic.com>
>>
>> This patch adds a new exported function, bsg_private_command(), and a few
>> supporting functions that allow a device driver or other kernel code to be
>> able to send bsg commands from within the kernel using sg_io_v4.  The private
>> command infrastructure mimics the ioctl interface except that the bsg request
>> queue needs to be explicitly passed in.
>
> I can't recall the discussion conclusion about sending bsg requests from
> kernel space at lsf. The conclusion is that we need this feature?
>

We had proposed some additional rport attributes awhile back but the
concensus at the time was that the code to  send and parse
the CT commands should be done via the bsg CT passthrough interface so as
to make it vendor agnostic.  There is currently, to my knowledge, no mechanism to
send bsg commands from kernel space so this patch was to create that mechanism.

>> The helper functions are similar to the bsg_map_hdr() function except that
>> no bsg_device is needed and kernel buffers are used instead of user buffers.
>> This was done so that the current semantics of user space bsg calls would
>> remain undisturbed, to avoid the complications of mixing user vs. kernel
>> buffers and not having to create a dummy bsg device for each command submitted.
>>
>> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
>> ---
>>   block/bsg.c         |  207 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>   include/linux/bsg.h |    1 +
>>   2 files changed, 208 insertions(+), 0 deletions(-)
>
> Looks like the majority of the code is the copy of the exisiting code. Can we
> avoid the duplication by creating some common helper functions?

Yes, we will refactor the functions so as to avoid duplication.

>
> Don't we need to take care of a race that sending a bsg request to a bsg
> device in the process of removal?

We do check for a valid request_queue in bsg_private_command() before we
dispatch the request but we'll double check to make sure we don't hit any
other race conditions

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

