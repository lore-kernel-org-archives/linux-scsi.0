From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2 3/8] blk-mq: use the introduced
 blk_mq_unquiesce_queue()
Date: Tue, 30 May 2017 15:12:41 +0000
Message-ID: <1496157160.2627.7.camel@sandisk.com>
References: <20170527142126.26079-1-ming.lei@redhat.com>
         <20170527142126.26079-4-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170527142126.26079-4-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <2B2EF5DA74383E4C9F687843D1D1183A@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2017-05-27 at 22:21 +0800, Ming Lei wrote:
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -3030,7 +3030,10 @@ scsi_internal_device_unblock(struct scsi_device *s=
dev,
>  		return -EINVAL;
> =20
>  	if (q->mq_ops) {
> -		blk_mq_start_stopped_hw_queues(q, false);
> +		if (blk_queue_quiesced(q))
> +			blk_mq_unquiesce_queue(q);
> +		else
> +			blk_mq_start_stopped_hw_queues(q, false);
>  	} else {
>  		spin_lock_irqsave(q->queue_lock, flags);
>  		blk_start_queue(q);

Hello Ming,

Sorry but that change looks wrong to me. All what's needed here is a call
to blk_mq_unquiesce_queue().

Bart.=
