From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] block: set rq->cmd_flags with bio->opf instead of
 data->cmd_flags when bio is not Null
Date: Mon, 28 Jan 2019 15:36:58 +0000
Message-ID: <55972c1a-051a-1396-6796-84f349830a35@huawei.com>
References: <1548337430-66690-1-git-send-email-chenxiang66@hisilicon.com>
 <1c34d6f9-8c3c-a7ff-a956-46e9dc3c2298@hisilicon.com>
 <20190128140716.GA18162@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190128140716.GA18162@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, "chenxiang (M)" <chenxiang66@hisilicon.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 28/01/2019 14:07, Christoph Hellwig wrote:
>>> for rq->cmd_flags. It will cause dix=0 in function
>>> sd_setup_read_write_cmnd() when enabled DIX, which will cause IO
>>> exception when enabled DIX.
>>>
>>> For some IOs such as internal IO from SCSI layer, the parameter bio of
>>> function blk_mq_get_request() is Null, so need to check bio to
>>> decise rq->cmd_flags.
>
> We have data->cmd_flags to deal with the NULL bio case.
> blk_mq_make_request initializes data->cmd_flags from bio->bi_opf
> just before calling blk_mq_get_request, so I'm really missing what you
> are trying to fix here.

As I understood, the problem is the scenario of calling 
blk_mq_make_request()->bio_integrity_prep() where we then allocate a bio 
integrity payload in calling bio_integrity_alloc().

In this case, bio_integrity_alloc() sets bio->bi_opf |= REQ_INTEGRITY, 
which is no longer consistent with data.cmd_flags.

John

>
> .
>
