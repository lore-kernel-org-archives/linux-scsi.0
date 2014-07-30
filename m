From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] iscsi class: fix get_host_stats return code when
 not supported
Date: Wed, 30 Jul 2014 14:52:00 +0200
Message-ID: <53D8EA70.5070505@suse.de>
References: <1405198311-64449-1-git-send-email-michaelc@cs.wisc.edu> <1405198311-64449-4-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428AbaG3MwC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2014 08:52:02 -0400
In-Reply-To: <1405198311-64449-4-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On 07/12/2014 10:51 PM, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
>
> When the get_host_stats call was not supported we were
> returing EINVAL. This has us return ENOSYS, because for
> software iscsi drivers where there is no host it is ok to not
> have this callout.
>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>   drivers/scsi/scsi_transport_iscsi.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_=
transport_iscsi.c
> index 14bfa53..534d3fb 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -3429,7 +3429,7 @@ iscsi_get_host_stats(struct iscsi_transport *tr=
ansport, struct nlmsghdr *nlh)
>   	char *buf;
>
>   	if (!transport->get_host_stats)
> -		return -EINVAL;
> +		return -ENOSYS;
>
>   	priv =3D iscsi_if_transport_lookup(transport);
>   	if (!priv)
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
