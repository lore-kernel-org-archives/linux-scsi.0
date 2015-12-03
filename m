From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/5] libsas: allow async aborts
Date: Thu, 03 Dec 2015 09:17:02 +0100
Message-ID: <1449130622.3311.4.camel@suse.de>
References: <1449127063-94512-1-git-send-email-hare@suse.de>
	 <1449127063-94512-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbbLCIRD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Dec 2015 03:17:03 -0500
In-Reply-To: <1449127063-94512-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org

On Thu, 2015-12-03 at 08:17 +0100, Hannes Reinecke wrote:
> From: Christoph Hellwig <hch@lst.de>
>=20
> We now first try to call ->eh_abort_handler from a work queue, but li=
bsas
> was always failing that for no good reason.=C2=A0=C2=A0Allow async ab=
orts.
>=20
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> =C2=A0drivers/scsi/libsas/sas_scsi_host.c | 3 ---
> =C2=A01 file changed, 3 deletions(-)
>=20
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c
> b/drivers/scsi/libsas/sas_scsi_host.c
> index 519dac4..37a2a84 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -491,9 +491,6 @@ int sas_eh_abort_handler(struct scsi_cmnd *cmd)
> =C2=A0	struct Scsi_Host *host =3D cmd->device->host;
> =C2=A0	struct sas_internal *i =3D to_sas_internal(host->transportt);
> =C2=A0
> -	if (current !=3D host->ehandler)
> -		return FAILED;
> -
> =C2=A0	if (!i->dft->lldd_abort_task)
> =C2=A0		return FAILED;
> =C2=A0

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
