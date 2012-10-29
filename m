From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/7] block: Avoid that blk_drain_queue() finishes early
Date: Mon, 29 Oct 2012 15:35:50 +0100
Message-ID: <508E9446.1040700@acm.org>
References: <508A7B63.60608@acm.org> <508A7B93.4090409@acm.org> <20121029014722.GC5171@htj.dyndns.org> <20121029015234.GD5171@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:33011 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757917Ab2J2Ofv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Oct 2012 10:35:51 -0400
In-Reply-To: <20121029015234.GD5171@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Chanho Min <chanho.min@lge.com>

On 10/29/12 02:52, Tejun Heo wrote:
> On Sun, Oct 28, 2012 at 06:47:22PM -0700, Tejun Heo wrote:
>> On Fri, Oct 26, 2012 at 02:01:23PM +0200, Bart Van Assche wrote:
>>> Code like "drain |= q->nr_rqs[i]" might result in blk_drain_queue()
>>> to finish early if the expression at the RHS is a multiple of 256
>>> since the drain variable is only eight bits wide. Avoid this by
>>> changing the type of the drain variable from bool into unsigned.
>>
>> No, it doesn't happen that way.  One of the reasons we have bool at
>> all is to avoid this type of problems caused by implicit type-casting.
>>
>> Why do you keep pushing this?  It's WRONG.  Please drop it.
>
>>From C99 std draft.
>
>   6.3 Conversions
>   6.3.1.2 Boolean type
>
>    When any scalar value is converted to _Bool, the result is 0 if the
>    value compares equal to 0; otherwise, the result is 1.
>
> It doesn't care the width or signedness of the type being converted.
> If the origin value equals zero, it converts to 0; otherwise 1.

For one or another reason I was assuming that bool was a typedef for 
unsigned char. But you are right, it's a synonym for the C99 type _Bool 
so I'll drop this patch.

Bart.

