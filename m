From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [patch] qla2xxx: fix a timeout loop
Date: Wed, 16 Dec 2015 12:45:42 +0100
Message-ID: <20151216114542.GF31151@c203.arch.suse.de>
References: <20151216110746.GB21018@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54879 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbbLPLpp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2015 06:45:45 -0500
Content-Disposition: inline
In-Reply-To: <20151216110746.GB21018@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: qla2xxx-upstream@qlogic.com, Atul Deshmukh <atul.deshmukh@qlogic.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Wed, Dec 16, 2015 at 02:07:46PM +0300, Dan Carpenter wrote:
> After the loop we test for "if (!retries) " as a failure, but actuall=
y
> the post-op here will end with retries set to -1.  I have fixed this =
by
> using a pre-op instead.
>=20
> Fixes: 7ec0effd30bb ('[SCSI] qla2xxx: Add support for ISP8044.')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/ql=
a_nx2.c
> index 007192d..66d629e 100644
> --- a/drivers/scsi/qla2xxx/qla_nx2.c
> +++ b/drivers/scsi/qla2xxx/qla_nx2.c
> @@ -3491,7 +3491,7 @@ qla8044_poll_flash_status_reg(struct scsi_qla_h=
ost *vha)
>  	int retries =3D QLA8044_FLASH_READ_RETRY_COUNT;
>  	int ret_val =3D QLA_SUCCESS;
> =20
> -	while (retries--) {
> +	while (--retries) {
>  		ret_val =3D qla8044_rd_reg_indirect(vha, QLA8044_FLASH_STATUS,
>  		    &flash_status);
>  		if (ret_val) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Good catch.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
