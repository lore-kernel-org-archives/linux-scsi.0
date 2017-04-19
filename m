From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 02/23] block: remove the blk_execute_rq return value
Date: Wed, 19 Apr 2017 21:07:45 +0000
Message-ID: <1492636063.2543.18.camel@sandisk.com>
References: <20170419192708.22098-1-hch@lst.de>
         <20170419192708.22098-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170419192708.22098-3-hch@lst.de>
Content-Language: en-US
Content-ID: <4F2B3A2E36573B4E97784C6009B45ED1@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jbacik@fb.com" <jbacik@fb.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-04-19 at 21:26 +0200, Christoph Hellwig wrote:
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -489,7 +489,10 @@ static void _set_error_resid(struct osd_request *or,=
 struct request *req,
> =20
>  int osd_execute_request(struct osd_request *or)
>  {
> -	int error =3D blk_execute_rq(or->request->q, NULL, or->request, 0);
> +	int error;
> +
> +	blk_execute_rq(or->request->q, NULL, or->request, 0);
> +	error =3D or->request ? -EIO : 0;

Hello Christoph,

Did you perhaps intend or->request->errors instead of or->request?

Otherwise this patch looks fine to me.

Bart.=
