From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] libsas: allow async aborts
Date: Mon, 24 Nov 2014 09:52:11 +0100
Message-ID: <5472F1BB.2000303@suse.de>
References: <1416818414-19430-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35621 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbaKXIwM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 03:52:12 -0500
In-Reply-To: <1416818414-19430-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, intel-linux-scu@intel.com

On 11/24/2014 09:40 AM, Christoph Hellwig wrote:
> We now first try to call ->eh_abort_handler from a work queue, but li=
bsas
> was always failing that for no good reason.  Allow async aborts.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/libsas/sas_scsi_host.c | 3 ---
>  1 file changed, 3 deletions(-)
>=20
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsa=
s/sas_scsi_host.c
> index 89e8b68..3ebdfaf 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -539,9 +539,6 @@ int sas_eh_abort_handler(struct scsi_cmnd *cmd)
>  	struct Scsi_Host *host =3D cmd->device->host;
>  	struct sas_internal *i =3D to_sas_internal(host->transportt);
> =20
> -	if (current !=3D host->ehandler)
> -		return FAILED;
> -
>  	if (!i->dft->lldd_abort_task)
>  		return FAILED;
> =20
>=20
Was about to post a similar patch myself.

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
