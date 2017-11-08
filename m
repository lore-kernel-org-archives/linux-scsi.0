From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] SCSI: don't get target/host busy_count in
 scsi_mq_get_budget()
Date: Tue, 7 Nov 2017 19:55:32 -0700
Message-ID: <26ee805b-883f-d588-5649-13700244b6e8@kernel.dk>
References: <20171104015534.32684-1-ming.lei@redhat.com>
 <adb7f6bd-bf0d-8176-808b-32a84ac4273a@kernel.dk>
 <1509997522.2409.58.camel@wdc.com> <20171107021125.GB15090@ming.t460p>
 <1510071607.2656.17.camel@wdc.com> <20171108003934.GB20599@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171108003934.GB20599@ming.t460p>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "john.garry@huawei.com" <john.garry@huawei.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 11/07/2017 05:39 PM, Ming Lei wrote:
> On Tue, Nov 07, 2017 at 04:20:08PM +0000, Bart Van Assche wrote:
>> On Tue, 2017-11-07 at 10:11 +0800, Ming Lei wrote:
>>> If you can reproduce, please provide me at least the following log
>>> first:
>>>
>>> 	find /sys/kernel/debug/block -name tags | xargs cat | grep busy
>>>
>>> If any pending requests arn't completed, please provide the related
>>> info in dbgfs about where is the request.
>>
>> Every time I ran the above or a similar command its output was empty. I
>> assume that's because the hang usually occurs in a phase where these debugfs
>> attributes either have not yet been created or have already disappeared.
> 
> Could you dump all tags? Then you can see if this attribute is disappeared.
> 
> If that output is empty, it often means there isn't pending request not
> completed. So if that is true, your hang is _not_ related with RESTART.

You need to check sched_tags as well. It could still be a restart race
or problem, if tags is empty but sched_tags has busy bits.

-- 
Jens Axboe
