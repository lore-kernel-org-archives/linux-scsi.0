From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] iscsi class: Fix freeing of skb in get host error
 path
Date: Tue, 05 Aug 2014 14:52:49 +0200
Message-ID: <53E0D3A1.3050505@suse.de>
References: <1407109072-3351-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041AbaHEMwv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Aug 2014 08:52:51 -0400
In-Reply-To: <1407109072-3351-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On 08/04/2014 01:37 AM, michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
>
> If get_host_stats failes we are using kfree to free the
> skb. We should be using kfree_skb.
>
> This patch was made over Christoph's scsi-queue drivers-for-3.17 bran=
ch.
>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>   drivers/scsi/scsi_transport_iscsi.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_=
transport_iscsi.c
> index 534d3fb..67d43e3 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -3468,7 +3468,7 @@ iscsi_get_host_stats(struct iscsi_transport *tr=
ansport, struct nlmsghdr *nlh)
>
>   		err =3D transport->get_host_stats(shost, buf, host_stats_size);
>   		if (err) {
> -			kfree(skbhost_stats);
> +			kfree_skb(skbhost_stats);
>   			goto exit_host_stats;
>   		}
>
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
