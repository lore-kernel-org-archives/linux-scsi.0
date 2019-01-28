From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] block: set rq->cmd_flags with bio->opf instead of
 data->cmd_flags when bio is not Null
Date: Mon, 28 Jan 2019 16:05:47 +0000
Message-ID: <872f8c26-1c88-fe50-ffec-01c1e882245b@huawei.com>
References: <1548337430-66690-1-git-send-email-chenxiang66@hisilicon.com>
 <1c34d6f9-8c3c-a7ff-a956-46e9dc3c2298@hisilicon.com>
 <20190128140716.GA18162@infradead.org>
 <55972c1a-051a-1396-6796-84f349830a35@huawei.com>
 <20190128155752.GA29076@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190128155752.GA29076@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "chenxiang (M)" <chenxiang66@hisilicon.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 28/01/2019 15:57, Christoph Hellwig wrote:
> On Mon, Jan 28, 2019 at 03:36:58PM +0000, John Garry wrote:
>> As I understood, the problem is the scenario of calling
>> blk_mq_make_request()->bio_integrity_prep() where we then allocate a bio
>> integrity payload in calling bio_integrity_alloc().
>>
>> In this case, bio_integrity_alloc() sets bio->bi_opf |= REQ_INTEGRITY, which
>> is no longer consistent with data.cmd_flags.
>
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
>         rq = blk_mq_get_request(q, bio, &data);
>
>

Your code is different to mine, then I see that this has been fixed in 
5.0-rc3:

commit 7809167da5c86fd6bf309b33dee7a797e263342f
Author: Ming Lei <ming.lei@redhat.com>
Date:   Wed Jan 16 19:08:15 2019 +0800

     block: don't lose track of REQ_INTEGRITY flag

     We need to pass bio->bi_opf after bio intergrity preparing, otherwise
     the flag of REQ_INTEGRITY may not be set on the allocated request, then
     breaks block integrity.

     Fixes: f9afca4d367b ("blk-mq: pass in request/bio flags to queue 
mapping")
     Cc: Hannes Reinecke <hare@suse.com>
     Cc: Keith Busch <keith.busch@intel.com>
     Signed-off-by: Ming Lei <ming.lei@redhat.com>
     Signed-off-by: Jens Axboe <axboe@kernel.dk>


Sorry for the noise,
John

> .
>
