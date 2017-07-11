From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 2/6] SCSI: use blk_mq_run_hw_queues() in scsi_kick_queue()
Date: Tue, 11 Jul 2017 19:57:53 +0000
Message-ID: <1499803071.2586.29.camel@wdc.com>
References: <20170711182103.11461-1-ming.lei@redhat.com>
         <20170711182103.11461-3-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170711182103.11461-3-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <C43945FFDBFA264FAE199AAC4CBD3E66@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "sagi@grimberg.me" <sagi@grimberg.me>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-07-12 at 02:20 +0800, Ming Lei wrote:
> Now SCSI won't stop queue, and not necessary to use
> blk_mq_start_hw_queues(), so switch to blk_mq_run_hw_queues()
> instead.
>=20
> Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/scsi_lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index f6097b89d5d3..91d890356b78 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -333,7 +333,7 @@ void scsi_device_unbusy(struct scsi_device *sdev)
>  static void scsi_kick_queue(struct request_queue *q)
>  {
>  	if (q->mq_ops)
> -		blk_mq_start_hw_queues(q);
> +		blk_mq_run_hw_queues(q, false);
>  	else
>  		blk_run_queue(q);
>  }

Hello Ming,

Now that we have separate flags to represent the "stopped" and "quiesced"
states, wouldn't it be better not to modify scsi_kick_queue() but instead t=
o
stop a SCSI hardware queue again if scsi_queue_rq() returns BLK_STS_RESOURC=
E?
See also commits 36e3cf273977 ("scsi: Avoid that SCSI queues get stuck") an=
d
commit 52d7f1b5c2f3 ("blk-mq: Avoid that requeueing starts stopped queues")=
.

Bart.=
