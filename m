From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: scsi: introduce a new result field in struct scsi_request
Date: Tue, 18 Apr 2017 22:34:20 +0000
Message-ID: <1492554858.2689.17.camel@sandisk.com>
References: <20170418155229.5977-1-hch@bombadil.infradead.org>
         <20170418155229.5977-8-hch@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:54255 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbdDRWeY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2017 18:34:24 -0400
In-Reply-To: <20170418155229.5977-8-hch@bombadil.infradead.org>
Content-Language: en-US
Content-ID: <7EA1ECB86EC18243A55B2A3A859E207E@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@bombadil.infradead.org" <hch@bombadil.infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@lst.de" <hch@lst.de>, "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>, "roger.pau@citrix.com" <roger.pau@citrix.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jbacik@fb.com" <jbacik@fb.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

On Tue, 2017-04-18 at 08:52 -0700, Christoph Hellwig wrote:
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -391,13 +391,13 @@ static int blk_complete_sgv4_hdr_rq(struct request =
*rq, struct sg_io_v4 *hdr,
>  	struct scsi_request *req =3D scsi_req(rq);
>  	int ret =3D 0;
> =20
> -	dprintk("rq %p bio %p 0x%x\n", rq, bio, rq->errors);
> +	dprintk("rq %p bio %p 0x%x\n", rq, bio, rq->result);

Hello Christoph,

Did you perhaps intend "req->result" instead of "rq->result"?

> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -229,8 +229,8 @@ void scsi_queue_insert(struct scsi_cmnd *cmd, int rea=
son)
>   * @rq_flags:	flags for ->rq_flags
>   * @resid:	optional residual length
>   *
> - * returns the req->errors value which is the scsi_cmnd result
> - * field.
> + * Returns the scsi_cmnd result field if a command was executed, or a ne=
gative
> + * Linux error code if we didn't get that war.

Did you intend "war" or is that perhaps a typo?

> @@ -1905,7 +1904,7 @@ static int scsi_mq_prep_fn(struct request *req)
>  static void scsi_mq_done(struct scsi_cmnd *cmd)
>  {
>  	trace_scsi_dispatch_cmd_done(cmd);
> -	blk_mq_complete_request(cmd->request, cmd->request->errors);
> +	blk_mq_complete_request(cmd->request, 0);
>  }

Why has cmd->request->errors been changed into 0?

Bart.=
