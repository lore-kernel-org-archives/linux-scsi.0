From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] block: set rq->cmd_flags with bio->opf instead of
 data->cmd_flags when bio is not Null
Date: Mon, 28 Jan 2019 06:07:16 -0800
Message-ID: <20190128140716.GA18162@infradead.org>
References: <1548337430-66690-1-git-send-email-chenxiang66@hisilicon.com>
 <1c34d6f9-8c3c-a7ff-a956-46e9dc3c2298@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1c34d6f9-8c3c-a7ff-a956-46e9dc3c2298@hisilicon.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "chenxiang (M)" <chenxiang66@hisilicon.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, axboe@kernel.dk, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> > for rq->cmd_flags. It will cause dix=0 in function
> > sd_setup_read_write_cmnd() when enabled DIX, which will cause IO
> > exception when enabled DIX.
> > 
> > For some IOs such as internal IO from SCSI layer, the parameter bio of
> > function blk_mq_get_request() is Null, so need to check bio to
> > decise rq->cmd_flags.

We have data->cmd_flags to deal with the NULL bio case.
blk_mq_make_request initializes data->cmd_flags from bio->bi_opf
just before calling blk_mq_get_request, so I'm really missing what you
are trying to fix here.
