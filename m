From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 RESEND_2] scsi: report 'INQUIRY result too short' once
 per host
Date: Thu, 19 Nov 2015 15:17:45 +0100
Message-ID: <564DDA09.6030801@suse.de>
References: <1447939026-25306-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934205AbbKSORr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2015 09:17:47 -0500
In-Reply-To: <1447939026-25306-1-git-send-email-vkuznets@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vitaly Kuznetsov <vkuznets@redhat.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>, Long Li <longli@microsoft.com>, Dexuan Cui <decui@microsoft.com>

On 11/19/2015 02:17 PM, Vitaly Kuznetsov wrote:
> Some host adapters (e.g. Hyper-V storvsc) are known for not respectin=
g the
> SPC-2/3/4 requirement for 'INQUIRY data (see table ...) shall contain=
 at
> least 36 bytes'. As a result we get tons on 'scsi 0:7:1:1: scsi scan:
> INQUIRY result too short (5), using 36' messages on console. This can=
 be
> problematic for slow consoles. Introduce short_inquiry flag in struct
> Scsi_Host to print the message once per host.
>=20
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> Changes since v3 RESEND:
> - No changes, this is just a RESEND.
>=20
> Changes since v3:
> - No changes, this is just a RESEND.
>=20
> Changes since v2:
> - This is a successor of previously sent (and still not merged) "scsi=
:
>   introduce short_inquiry flag for broken host adapters" patch. I'm n=
ot
>   particularly sure which solution is better but I'm leaning towards =
this
>   one as it doesn't require changes to adapter drivers.
> ---
>  drivers/scsi/scsi_scan.c | 9 ++++++---
>  include/scsi/scsi_host.h | 3 +++
>  2 files changed, 9 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 8324539..054923e 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -701,9 +701,12 @@ static int scsi_probe_lun(struct scsi_device *sd=
ev, unsigned char *inq_result,
>  	 * strings.
>  	 */
>  	if (sdev->inquiry_len < 36) {
> -		sdev_printk(KERN_INFO, sdev,
> -			    "scsi scan: INQUIRY result too short (%d),"
> -			    " using 36\n", sdev->inquiry_len);
> +		if (!sdev->host->short_inquiry) {
> +			shost_printk(KERN_INFO, sdev->host,
> +				    "scsi scan: INQUIRY result too short (%d),"
> +				    " using 36\n", sdev->inquiry_len);
> +			sdev->host->short_inquiry =3D 1;
> +		}
>  		sdev->inquiry_len =3D 36;
>  	}
> =20
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index ed52712..fcfa3d7 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -668,6 +668,9 @@ struct Scsi_Host {
>  	unsigned use_blk_mq:1;
>  	unsigned use_cmd_list:1;
> =20
> +	/* Host responded with short (<36 bytes) INQUIRY result */
> +	unsigned short_inquiry:1;
> +
>  	/*
>  	 * Optional work queue to be utilized by the transport
>  	 */
>=20
Ok, that's fine with me.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
