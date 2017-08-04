From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 2/2] sd_zbc: Write unlock zones from sd_uninit_cmnd()
Date: Fri, 4 Aug 2017 15:47:23 +0000
Message-ID: <1501861640.2757.9.camel@wdc.com>
References: <20170804075237.2089-1-damien.lemoal@wdc.com>
         <20170804075237.2089-3-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:19003 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752242AbdHDPsK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2017 11:48:10 -0400
In-Reply-To: <20170804075237.2089-3-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <0E4A0A093A1DE4409F504D9F4A618DBE@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>

On Fri, 2017-08-04 at 16:52 +0900, Damien Le Moal wrote:
> Releasing the write lock of a zone when the write commnand that
> acquired the lock completes can cause deadlocks with scsi-mq due to
> potential queue reordering if the lock owning request is requeued and
> not executed.
>=20
> Since sd_uninit_cmnd() is always called when a request is requeued,
> call sd_zbc_write_unlock_zone() from that function for write requests
> that acquired a zone lock. Acquisition of a zone lock by a write command
> is indicated using the new command flag SCMD_ZONE_WRITE_LOCK.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>

Hello Damien,

Should "Cc: <stable@vger.kernel.org>" be added to this patch?

> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 96855df9f49d..6423ae70477e 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -294,6 +294,9 @@ int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
>  	    test_and_set_bit(zno, sdkp->zones_wlock))
>  		return BLKPREP_DEFER;
> =20
> +	WARN_ON(cmd->flags & SCMD_ZONE_WRITE_LOCK);
> +	cmd->flags |=3D SCMD_ZONE_WRITE_LOCK;
> +
>  	return BLKPREP_OK;
>  }

Did you perhaps intend WARN_ON_ONCE() instead of WARN_ON()?

Thanks,

Bart.=
