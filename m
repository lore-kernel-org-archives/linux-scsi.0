From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/6] scsi: return EAGAIN when resetting a device under
 EH
Date: Wed, 05 Nov 2014 15:14:56 +0100
Message-ID: <545A30E0.40201@suse.de>
References: <1414661229-15199-1-git-send-email-hch@lst.de> <1414661229-15199-7-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534AbaKEOO6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Nov 2014 09:14:58 -0500
In-Reply-To: <1414661229-15199-7-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dgilbert@interlog.com>, Robert Elliott <Elliott@hp.com>

On 10/30/2014 10:27 AM, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi_ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
> index 712f159..c4f7b56 100644
> --- a/drivers/scsi/scsi_ioctl.c
> +++ b/drivers/scsi/scsi_ioctl.c
> @@ -278,7 +278,7 @@ int scsi_ioctl_block_when_processing_errors(struc=
t scsi_device *sdev, int cmd,
>  {
>  	if (cmd =3D=3D SG_SCSI_RESET && ndelay) {
>  		if (scsi_host_in_recovery(sdev->host))
> -			return -ENODEV;
> +			return -EAGAIN;
>  	} else {
>  		if (!scsi_block_when_processing_errors(sdev))
>  			return -ENODEV;
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
