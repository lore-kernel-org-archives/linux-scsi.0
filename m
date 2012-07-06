From: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH v5 3/4] block: implement runtime pm strategy
Date: Fri, 6 Jul 2012 22:51:21 +0800
Message-ID: <CAF1ivSb7_THm+ugR5D-bEA6VsDvrxeH8V-Dk5JqeWEQEgHhy2w@mail.gmail.com>
References: <1341547472-6863-4-git-send-email-ming.m.lin@intel.com>
	<Pine.LNX.4.44L0.1207061019170.28821-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1207061019170.28821-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 6, 2012 at 10:21 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 6 Jul 2012, Lin Ming wrote:
>
>> When a request is added:
>>     If device is suspended or is suspending and the request is not a
>>     PM request, resume the device.
>>
>> When a request finishes:
>>     Call pm_runtime_mark_last_busy().
>>
>> When pick a request:
>>     If device is resuming/suspending, then only PM request is allowed to go.
>>     Return NULL for other cases.
>>
>> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
>
> Generally okay, but...
>
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -908,6 +908,36 @@ extern int blk_pre_runtime_suspend(struct request_queue *q);
>>  extern void blk_post_runtime_suspend(struct request_queue *q, int err);
>>  extern void blk_pre_runtime_resume(struct request_queue *q);
>>  extern void blk_post_runtime_resume(struct request_queue *q, int err);
>> +
>> +static inline void blk_pm_put_request(struct request_queue *q)
>> +{
>> +     if (!(--q->nr_pending) && q->dev)
>> +              pm_runtime_mark_last_busy(q->dev);
>> +}
> ...
>
> These new helper routines are private to the block layer, not intended
> for use by clients.  Consequently they don't belong in include/linux;
> they should go in block/blk.h.

OK, will move it.

>
> Alan Stern
