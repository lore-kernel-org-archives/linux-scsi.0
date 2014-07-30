From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/4] iscsi class: fix get_host_stats error handling
Date: Wed, 30 Jul 2014 14:50:55 +0200
Message-ID: <53D8EA2F.8040505@suse.de>
References: <1405198311-64449-1-git-send-email-michaelc@cs.wisc.edu> <1405198311-64449-2-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37732 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbaG3Mu6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2014 08:50:58 -0400
In-Reply-To: <1405198311-64449-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On 07/12/2014 10:51 PM, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
>
> iscsi_get_host_stats was dropping the error code returned
> by drivers like qla4xxx.
>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>   drivers/scsi/scsi_transport_iscsi.c |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_=
transport_iscsi.c
> index b481e62..14bfa53 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -3467,6 +3467,10 @@ iscsi_get_host_stats(struct iscsi_transport *t=
ransport, struct nlmsghdr *nlh)
>   		memset(buf, 0, host_stats_size);
>
>   		err =3D transport->get_host_stats(shost, buf, host_stats_size);
> +		if (err) {
> +			kfree(skbhost_stats);
> +			goto exit_host_stats;
> +		}
>
>   		actual_size =3D nlmsg_total_size(sizeof(*ev) + host_stats_size);
>   		skb_trim(skbhost_stats, NLMSG_ALIGN(actual_size));
>
What happens with the skbhost_stats allocated earlier? Shouldn't it=20
be freed here, too?

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
