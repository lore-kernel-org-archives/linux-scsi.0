From: Jens Axboe <axboe@fb.com>
Subject: Re: QUEUE_FLAG_NO_SG_MERGE and non-block-mq
Date: Fri, 27 Nov 2015 09:14:08 -0700
Message-ID: <56588150.1080900@fb.com>
References: <5656BF25.3000407@suse.de>
 <CACVXFVMSNmtcVN1zZ5f=xNbMfpnt7wiQ4U03f1Dk95rOMUQBSw@mail.gmail.com>
 <565868E7.2010807@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <565868E7.2010807@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@canonical.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/27/2015 07:29 AM, Hannes Reinecke wrote:
> On 11/26/2015 10:21 AM, Ming Lei wrote:
>> On Thu, Nov 26, 2015 at 4:13 PM, Hannes Reinecke <hare@suse.de> wrote:
>>> Hi all,
>>>
>>> while investigating the crash in scsi_lib.c I found a rather curious
>>> behaviour for QUEUE_FLAG_NO_SG_MERGE.
>>>
>>> While the flag is evaluated in blk_recalc_rq_segments and
>>> blk_recount_segments (resulting in nr_phys_segments being
>>> computed based on that flag) it is completely ignored
>>> during blk_rq_map_sg() or the actual merging itself.
>>
>> Yes, I guess Jens introduced the flag for decreasing CPU
>> consumption when comuputing segments, but it is still
>> ignored by blk_rq_map_sg(), but it may not be used
>> by some drivers.
>>
>> After bio splitting is introduced, the flag is also ignored
>> when computing segments.
>>
>>>
>>> This typically shouldn't be an issue, seeing that with
>>> QUEUE_FLAG_NO_SG_MERGE nr_phys_segments will always be
>>> larger than the actual segment count.
>>>
>>> However, it still makes me wonder:
>>> What is the point of having a QUEUE_FLAG_NO_SG_MERGE
>>> which doesn't work as advertised?
>>> Or, to be precise, which only works for blk-mq?
>>> Should we make it work for non-block-mq, too?
>>
>> Thanks bio splitting, this flag has little effect on performance now,
>> so I think it can be removed if Jens has no objection.
>>
> As per your suggestion we've made some performance measurements,
> and 4k fio showed little if no impact:
>
> NO_SG_MERGE:
>    IOPS R/W: 148097.7+-125.7 / 148124.1+-123.1
>    BW   R/W: 592392.4+-502.7 / 592498.3+-492.3
> SG_MERGE:
>    IOPS R/W: 148054.4+-123.3 / 148082.6+-120.0
>    BW   R/W: 592219.2+-493.5 / 592332.3+-479.7
>
> So the performance benefit lies squarely within the
> error margin, making me wonder if it's worth bothering
> with having the NO_SG_MERGE flag at all.
>
> Thanks to Johannes for doing the measurements :-)

150K iops is on the slow side, though. It's pointless to iterate the sg 
list if we don't have to. I can try and run a few tests next week.

-- 
Jens Axboe
