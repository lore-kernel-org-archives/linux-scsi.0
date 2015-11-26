From: Ming Lei <ming.lei@canonical.com>
Subject: Re: QUEUE_FLAG_NO_SG_MERGE and non-block-mq
Date: Thu, 26 Nov 2015 17:21:25 +0800
Message-ID: <CACVXFVMSNmtcVN1zZ5f=xNbMfpnt7wiQ4U03f1Dk95rOMUQBSw@mail.gmail.com>
References: <5656BF25.3000407@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5656BF25.3000407@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 26, 2015 at 4:13 PM, Hannes Reinecke <hare@suse.de> wrote:
> Hi all,
>
> while investigating the crash in scsi_lib.c I found a rather curious
> behaviour for QUEUE_FLAG_NO_SG_MERGE.
>
> While the flag is evaluated in blk_recalc_rq_segments and
> blk_recount_segments (resulting in nr_phys_segments being
> computed based on that flag) it is completely ignored
> during blk_rq_map_sg() or the actual merging itself.

Yes, I guess Jens introduced the flag for decreasing CPU
consumption when comuputing segments, but it is still
ignored by blk_rq_map_sg(), but it may not be used
by some drivers.

After bio splitting is introduced, the flag is also ignored
when computing segments.

>
> This typically shouldn't be an issue, seeing that with
> QUEUE_FLAG_NO_SG_MERGE nr_phys_segments will always be
> larger than the actual segment count.
>
> However, it still makes me wonder:
> What is the point of having a QUEUE_FLAG_NO_SG_MERGE
> which doesn't work as advertised?
> Or, to be precise, which only works for blk-mq?
> Should we make it work for non-block-mq, too?

Thanks bio splitting, this flag has little effect on performance now,
so I think it can be removed if Jens has no objection.

Thanks,

>
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                            zSeries & Storage
> hare@suse.de                                   +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=C3=BCrnberg)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
