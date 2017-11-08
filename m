From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] SCSI: don't get target/host busy_count in
 scsi_mq_get_budget()
Date: Tue, 7 Nov 2017 20:06:01 -0700
Message-ID: <1a153ff3-9d53-d347-cb16-b8480e690221@kernel.dk>
References: <20171104015534.32684-1-ming.lei@redhat.com>
 <adb7f6bd-bf0d-8176-808b-32a84ac4273a@kernel.dk>
 <1509997522.2409.58.camel@wdc.com> <20171107021125.GB15090@ming.t460p>
 <1510071607.2656.17.camel@wdc.com> <20171108003934.GB20599@ming.t460p>
 <26ee805b-883f-d588-5649-13700244b6e8@kernel.dk>
 <20171108025830.GA30129@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:50438 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753897AbdKHDGG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2017 22:06:06 -0500
Received: by mail-pf0-f178.google.com with SMTP id b6so892429pfh.7
        for <linux-scsi@vger.kernel.org>; Tue, 07 Nov 2017 19:06:05 -0800 (PST)
In-Reply-To: <20171108025830.GA30129@ming.t460p>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "john.garry@huawei.com" <john.garry@huawei.com>, "loberman@redhat.com" <loberman@redhat.com>

On 11/07/2017 07:58 PM, Ming Lei wrote:
> On Tue, Nov 07, 2017 at 07:55:32PM -0700, Jens Axboe wrote:
>> On 11/07/2017 05:39 PM, Ming Lei wrote:
>>> On Tue, Nov 07, 2017 at 04:20:08PM +0000, Bart Van Assche wrote:
>>>> On Tue, 2017-11-07 at 10:11 +0800, Ming Lei wrote:
>>>>> If you can reproduce, please provide me at least the following log
>>>>> first:
>>>>>
>>>>> 	find /sys/kernel/debug/block -name tags | xargs cat | grep busy
>>>>>
>>>>> If any pending requests arn't completed, please provide the related
>>>>> info in dbgfs about where is the request.
>>>>
>>>> Every time I ran the above or a similar command its output was empty. I
>>>> assume that's because the hang usually occurs in a phase where these debugfs
>>>> attributes either have not yet been created or have already disappeared.
>>>
>>> Could you dump all tags? Then you can see if this attribute is disappeared.
>>>
>>> If that output is empty, it often means there isn't pending request not
>>> completed. So if that is true, your hang is _not_ related with RESTART.
>>
>> You need to check sched_tags as well. It could still be a restart race
>> or problem, if tags is empty but sched_tags has busy bits.
> 
> Yeah, I didn't mention because SRP is MQ hardware, and the default
> scheduler is none, but if Bart changes that, the sched_tags need to
> checked first.

At this point, I have no idea what Bart's setup looks like. Bart, it
would be REALLY helpful if you could tell us how you are reproducing
your hang. I don't know why this has to be dragged out.

Ming/Bart - there seems to be an increasing amount of tension between
you two, for reasons that are unknown to me. I suggest you put that
aside in the pursuit of fixing the current issue, and then we can
discuss how to best resolve these going forward. But right now the top
priority is getting to the bottom of this. There's a chance that the
issue I can reproduce is the same that Bart is seeing, in which case we
might be fixing both in one fell swoop. But if that isn't the case, then
we have some work to do this week.

-- 
Jens Axboe
