From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: block: remove the blk_execute_rq return value
Date: Tue, 18 Apr 2017 22:24:15 +0000
Message-ID: <1492554253.2689.15.camel@sandisk.com>
References: <20170418155229.5977-1-hch@bombadil.infradead.org>
         <20170418155229.5977-2-hch@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170418155229.5977-2-hch@bombadil.infradead.org>
Content-Language: en-US
Content-ID: <B4868B6855FC444D90439AD4D0F2BF3A@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@bombadil.infradead.org" <hch@bombadil.infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jbacik@fb.com" <jbacik@fb.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-04-18 at 08:52 -0700, Christoph Hellwig wrote:
> diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
> index b05e151c9b38..82c6d02193ae 100644
> --- a/drivers/block/paride/pd.c
> +++ b/drivers/block/paride/pd.c
> @@ -747,7 +747,8 @@ static int pd_special_command(struct pd_unit *disk,
> =20
>  	rq->special =3D func;
> =20
> -	err =3D blk_execute_rq(disk->gd->queue, disk->gd, rq, 0);
> +	blk_execute_rq(disk->gd->queue, disk->gd, rq, 0);
> +	err =3D req->errors ? -EIO : 0;
> =20
>  	blk_put_request(rq);
>  	return err;

Hello Christoph,

Sorry that I hadn't noticed this before but shouldn't "req" be changed into
"rq"? Otherwise this patch looks fine to me. If this comment gets addressed
you can add:

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
