From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 05/27] hpsa: check for null arguments to dev_printk
Date: Mon, 09 Nov 2015 10:37:54 +0100
Message-ID: <56406972.1000304@suse.de>
References: <20151104214910.15472.23179.stgit@brunhilda> <20151104215025.15472.12183.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49255 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbbKIJh5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Nov 2015 04:37:57 -0500
In-Reply-To: <20151104215025.15472.12183.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 11/04/2015 10:50 PM, Don Brace wrote:
> Check for NULLs.
>=20
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> Reviewed-by: Manoj Kumar <manoj@linux.vnet.ibm.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |    3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 5a996273..b64913f 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -1138,6 +1138,9 @@ static int hpsa_find_target_lun(struct ctlr_inf=
o *h,
>  static inline void hpsa_show_dev_msg(const char *level, struct ctlr_=
info *h,
>  	struct hpsa_scsi_dev_t *dev, char *description)
>  {
> +	if (h =3D=3D NULL || h->pdev =3D=3D NULL || h->scsi_host =3D=3D NUL=
L)
> +		return;
> +
>  	dev_printk(level, &h->pdev->dev,
>  			"scsi %d:%d:%d:%d: %s %s %.8s %.16s RAID-%s SSDSmartPathCap%c En%=
c Exp=3D%d\n",
>  			h->scsi_host->host_no, dev->bus, dev->target, dev->lun,
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
