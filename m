From: "chenxiang (M)" <chenxiang66@hisilicon.com>
Subject: Re: [PATCH] block: set rq->cmd_flags with bio->opf instead of
 data->cmd_flags when bio is not Null
Date: Tue, 29 Jan 2019 08:47:25 +0800
Message-ID: <17ca562e-1681-c501-1cd3-ac229d893dd9@hisilicon.com>
References: <1548337430-66690-1-git-send-email-chenxiang66@hisilicon.com>
 <1c34d6f9-8c3c-a7ff-a956-46e9dc3c2298@hisilicon.com>
 <20190128140716.GA18162@infradead.org>
 <55972c1a-051a-1396-6796-84f349830a35@huawei.com>
 <20190128155752.GA29076@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190128155752.GA29076@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



在 2019/1/28 23:57, Christoph Hellwig 写道:
> On Mon, Jan 28, 2019 at 03:36:58PM +0000, John Garry wrote:
>> As I understood, the problem is the scenario of calling
>> blk_mq_make_request()->bio_integrity_prep() where we then allocate a bio
>> integrity payload in calling bio_integrity_alloc().
>>
>> In this case, bio_integrity_alloc() sets bio->bi_opf |= REQ_INTEGRITY, which
>> is no longer consistent with data.cmd_flags.
> I don't see how that could happen:
>
> static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
> {
> 	...
>
> 	if (!bio_integrity_prep(bio))
> 		return BLK_QC_T_NONE;
>
> 	...
>
> 	data.cmd_flags = bio->bi_opf;
>          rq = blk_mq_get_request(q, bio, &data);

Sorry to disturb, i used kernel 5.0-rc1 which has the issue, and it is 
fixed on linux-next branch.

>
>
> .
>
