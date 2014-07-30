From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/4] qla4xxx: fix get_host_stats error propagation
Date: Wed, 30 Jul 2014 14:51:17 +0200
Message-ID: <53D8EA45.30600@suse.de>
References: <1405198311-64449-1-git-send-email-michaelc@cs.wisc.edu> <1405198311-64449-3-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37739 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbaG3MvS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2014 08:51:18 -0400
In-Reply-To: <1405198311-64449-3-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On 07/12/2014 10:51 PM, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
>
> qla4xxx was not always returning -EXYZ error codes when
> qla4xxx_get_host_stats failed.
>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> Acked-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
>
> ---
>   drivers/scsi/qla4xxx/ql4_os.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4=
_os.c
> index c5d9564..b79b48c 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -1050,6 +1050,7 @@ static int qla4xxx_get_host_stats(struct Scsi_H=
ost *shost, char *buf, int len)
>   	if (!ql_iscsi_stats) {
>   		ql4_printk(KERN_ERR, ha,
>   			   "Unable to allocate memory for iscsi stats\n");
> +		ret =3D -ENOMEM;
>   		goto exit_host_stats;
>   	}
>
> @@ -1058,6 +1059,7 @@ static int qla4xxx_get_host_stats(struct Scsi_H=
ost *shost, char *buf, int len)
>   	if (ret !=3D QLA_SUCCESS) {
>   		ql4_printk(KERN_ERR, ha,
>   			   "Unable to retrieve iscsi stats\n");
> +		ret =3D -EIO;
>   		goto exit_host_stats;
>   	}
>   	host_stats->mactx_frames =3D le64_to_cpu(ql_iscsi_stats->mac_tx_fr=
ames);
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
