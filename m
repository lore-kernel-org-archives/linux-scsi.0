From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3] scsi: report 'INQUIRY result too short' once per host
Date: Mon, 12 Oct 2015 14:33:31 +0200
Message-ID: <561BA89B.2040504@suse.de>
References: <1444323291-16447-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbbJLMde (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2015 08:33:34 -0400
In-Reply-To: <1444323291-16447-1-git-send-email-vkuznets@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vitaly Kuznetsov <vkuznets@redhat.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>, Long Li <longli@microsoft.com>, Dexuan Cui <decui@microsoft.com>

On 10/08/2015 06:54 PM, Vitaly Kuznetsov wrote:
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
> index f9f3f82..cd347e4 100644
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
At least you need to check if you've received any valid data here;
'INQUIRY result too short' is also a common error if the interrupt
is hosed when trying to access the device.
So please check for 'inquiry_len > 4' before setting 'short_inquiry'.

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
