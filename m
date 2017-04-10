From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v4 4/6] blk-mq: Introduce blk_mq_delay_run_hw_queue()
Date: Mon, 10 Apr 2017 09:02:14 -0600
Message-ID: <601a809a-b552-3084-b41d-a89767ba5c84@kernel.dk>
References: <20170407181654.27836-1-bart.vanassche@sandisk.com>
 <20170407181654.27836-5-bart.vanassche@sandisk.com>
 <20170410071219.GD5559@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:33047 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753664AbdDJPCU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Apr 2017 11:02:20 -0400
Received: by mail-io0-f171.google.com with SMTP id t68so66260639iof.0
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 08:02:20 -0700 (PDT)
In-Reply-To: <20170410071219.GD5559@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Long Li <longli@microsoft.com>, "K . Y . Srinivasan" <kys@microsoft.com>

On 04/10/2017 01:12 AM, Christoph Hellwig wrote:
>> +	if (msecs == 0)
>> +		kblockd_schedule_work_on(blk_mq_hctx_next_cpu(hctx),
>> +					 &hctx->run_work);
>> +	else
>> +		kblockd_schedule_delayed_work_on(blk_mq_hctx_next_cpu(hctx),
>> +						 &hctx->delayed_run_work,
>> +						 msecs_to_jiffies(msecs));
>> +}
> 
> I'd rather make run_work a delayed_work (again) and use
> kblockd_schedule_delayed_work_on with a timeout of zero for the immediate
> run case instead of having two competing work structs.

Yeah that's a good point, it'd have to be an incremental patch at this
point though. Also note that blk_mq_stop_hw_queue() isn't currently
canceling the new ->delayed_run_work, that looks like a bug.

And looking at it, right now we have 3 (three!) work items in the
hardware queue. The two delayed items differ in that one of them only
runs the queue it was previously stopped, that's it. The non-delayed one
is identical to the non stopped checking delayed variant.

I'll send out a patch.

-- 
Jens Axboe
