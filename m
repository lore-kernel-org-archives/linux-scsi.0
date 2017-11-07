From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] SCSI: don't get target/host busy_count in
 scsi_mq_get_budget()
Date: Tue, 7 Nov 2017 09:29:32 -0700
Message-ID: <74925156-b425-de0e-de39-0a166ef5c5f3@kernel.dk>
References: <20171104015534.32684-1-ming.lei@redhat.com>
 <adb7f6bd-bf0d-8176-808b-32a84ac4273a@kernel.dk>
 <1509997522.2409.58.camel@wdc.com> <20171107021125.GB15090@ming.t460p>
 <1510071607.2656.17.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1510071607.2656.17.camel@wdc.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "john.garry@huawei.com" <john.garry@huawei.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 11/07/2017 09:20 AM, Bart Van Assche wrote:
> On Tue, 2017-11-07 at 10:11 +0800, Ming Lei wrote:
>> If you can reproduce, please provide me at least the following log
>> first:
>>
>> 	find /sys/kernel/debug/block -name tags | xargs cat | grep busy
>>
>> If any pending requests arn't completed, please provide the related
>> info in dbgfs about where is the request.
> 
> Every time I ran the above or a similar command its output was empty. I
> assume that's because the hang usually occurs in a phase where these debugfs
> attributes either have not yet been created or have already disappeared.

Bart, do you still see a hang with the patch that fixes the tag leak when
we fail to get a dispatch budget?

https://marc.info/?l=linux-block&m=151004881411480&w=2

I've run a lot of stability testing here, and I haven't run into any
issues. This is with shared tags as well. So if you still see the failure
case with the current tree AND the above patch, then I'll try and get
a test case setup that hits it too so we can get to the bottom of this.

-- 
Jens Axboe
