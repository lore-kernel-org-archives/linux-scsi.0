From: Muthu Kumar <muthu.lkml@gmail.com>
Subject: Re: [PATCH 1/4] block: Fix blk_execute_rq_nowait() dead queue handling
Date: Mon, 25 Jun 2012 12:18:23 -0700
Message-ID: <CAFR8ueeGbwhNfF1x6KLhKn-vWL7ziMGCEBzCG0p+H8kU35CTgQ@mail.gmail.com>
References: <4FE8A9FC.6040805@acm.org>
	<4FE8AA77.5050005@acm.org>
	<20120625184112.GI3869@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35480 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab2FYTSX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jun 2012 15:18:23 -0400
Received: by vbbff1 with SMTP id ff1so2174220vbb.19
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jun 2012 12:18:23 -0700 (PDT)
In-Reply-To: <20120625184112.GI3869@google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Muthukumar Ratty <muthur@gmail.com>

On Mon, Jun 25, 2012 at 11:41 AM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Jun 25, 2012 at 06:14:15PM +0000, Bart Van Assche wrote:
>> From: Muthukumar Ratty <muthur@gmail.com>
>>
>> If the queue is dead blk_execute_rq_nowait() doesn't invoke the done()
>> callback function. That will result in blk_execute_rq() being stuck
>> in wait_for_completion(). Avoid this by initializing rq->end_io to the
>> done() callback before we check the queue state. Also, make sure the
>> queue lock is held around the invocation of the done() callback. Found
>> this through source code review.
>>
>> Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
>
> Acked-by: Tejun Heo <tj@kernel.org>
>
> Thanks a lot!
>

Yep.. Thanks for the help Bart.


> --
> tejun
