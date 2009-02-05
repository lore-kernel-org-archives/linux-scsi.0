From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/3] scsi dh alua: handle report luns data changed in
 check sense callout
Date: Thu, 05 Feb 2009 14:59:32 +0100
Message-ID: <498AF0C4.7070701@suse.de>
References: <12333564114078-git-send-email-michaelc@cs.wisc.edu> <12333564124151-git-send-email-michaelc@cs.wisc.edu> <12333564123194-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:41205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067AbZBEN7d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Feb 2009 08:59:33 -0500
In-Reply-To: <12333564123194-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, Ilgu Hong <ilgu.hong@promise.com>

Hi Mike,

michaelc@cs.wisc.edu wrote:
> From: Ilgu Hong <ilgu.hong@promise.com>
>=20
> When we switch controllers the Intel Multi-Flex reports
> REPORTED_LUNS_DATA_HAS_CHANGED. This patch just has us
> retry the command.
>=20
> Signed-off-by: Ilgu Hong <ilgu.hong@promise.com>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scs=
i/device_handler/scsi_dh_alua.c
> index 31e1df5..dba154c 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -461,6 +461,15 @@ static int alua_check_sense(struct scsi_device *=
sdev,
>  			 */
>  			return ADD_TO_MLQUEUE;
>  		}
> +		if (sense_hdr->asc =3D=3D 0x3f && sense_hdr->ascq =3D=3D 0x0e) {
> +			/*
> +			 * REPORTED_LUNS_DATA_HAS_CHANGED is reported
> +			 * when switching controllers on targets like
> +			 * Intel Multi-Flex. We can just retry.
> +			 */
> +			return ADD_TO_MLQUEUE;
> +		}
> +
>  		break;
>  	}
> =20
Hmm. We could as well always retry for Unit Attention; it's meant to be
a temporary condition anyway so no harm in retrying.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
