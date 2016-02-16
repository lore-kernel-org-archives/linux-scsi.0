From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH] aic7xxx: Fix queue depth handling
Date: Tue, 16 Feb 2016 07:51:47 +0100
Message-ID: <56C2C703.7080803@suse.com>
References: <20160215185301.27731.20754.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615AbcBPGvt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Feb 2016 01:51:49 -0500
In-Reply-To: <20160215185301.27731.20754.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan <gnomes@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org

On 02/15/2016 07:53 PM, Alan wrote:
> We were setting the queue depth correctly, then setting it back to tw=
o. If
> you hit this as a bisection point then please send me an email as it =
would
> imply we've been hiding other bugs with this one.
>=20
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>  drivers/scsi/aic7xxx/aic7xxx_osm.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xx=
x/aic7xxx_osm.c
> index b846a46..fc6a831 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -1336,6 +1336,7 @@ ahc_platform_set_tags(struct ahc_softc *ahc, st=
ruct scsi_device *sdev,
>  	case AHC_DEV_Q_TAGGED:
>  		scsi_change_queue_depth(sdev,
>  				dev->openings + dev->active);
> +		break;
>  	default:
>  		/*
>  		 * We allow the OS to queue 2 untagged transactions to
>=20
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
