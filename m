From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1 03/25] hpsa: check for null arguments to dev_printk
Date: Fri, 30 Oct 2015 08:47:07 +0100
Message-ID: <5633207B.6030200@suse.de>
References: <20151028215206.5323.84194.stgit@brunhilda>
 <20151028220447.5323.79638.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40139 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758702AbbJ3HrJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 03:47:09 -0400
In-Reply-To: <20151028220447.5323.79638.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

On 10/28/2015 11:04 PM, Don Brace wrote:
> Check for NULLs.
>=20
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |    6 ++++++
>  drivers/scsi/hpsa.h |    2 +-
>  2 files changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 864fb03..6b6e9bb 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -1139,6 +1139,12 @@ static int hpsa_find_target_lun(struct ctlr_in=
fo *h,
>  static inline void hpsa_show_dev_msg(const char *level, struct ctlr_=
info *h,
>  	struct hpsa_scsi_dev_t *dev, char *description)
>  {
> +	if (dev =3D=3D NULL)
> +		return;
> +
> +	if (h =3D=3D NULL || h->pdev =3D=3D NULL || h->scsi_host =3D=3D NUL=
L)
> +		return;
> +
>  	dev_printk(level, &h->pdev->dev,
>  			"scsi %d:%d:%d:%d: %s %s %.8s %.16s RAID-%s SSDSmartPathCap%c En%=
c Exp=3D%d\n",
>  			h->scsi_host->host_no, dev->bus, dev->target, dev->lun,
> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
> index 27debb3..d6c4ebf 100644
> --- a/drivers/scsi/hpsa.h
> +++ b/drivers/scsi/hpsa.h
> @@ -34,7 +34,7 @@ struct access_method {
>  };
> =20
>  struct hpsa_scsi_dev_t {
> -	int devtype;
> +	unsigned int devtype;
>  	int bus, target, lun;		/* as presented to the OS */
>  	unsigned char scsi3addr[8];	/* as presented to the HW */
>  #define RAID_CTLR_LUNID "\0\0\0\0\0\0\0\0"
>=20
That's not really a check for NULL, isn't it?
Should rather be moved into an individual patch.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
