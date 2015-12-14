From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/9] be2iscsi: Fix VLAN support for IPv6 network
Date: Mon, 14 Dec 2015 16:11:32 +0100
Message-ID: <566EDC24.8090002@suse.de>
References: <1450073466-21077-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1450073466-21077-5-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbbLNPLe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Dec 2015 10:11:34 -0500
In-Reply-To: <1450073466-21077-5-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On 12/14/2015 07:11 AM, Jitendra Bhivare wrote:
> From: Jitendra <jitendra.bhivare@avagotech.com>
>
> Added VLAN operations in set IPv6 address for interface.
>
> Signed-off-by: Jitendra <jitendra.bhivare@avagotech.com>
> ---
>   drivers/scsi/be2iscsi/be_iscsi.c |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi=
/be_iscsi.c
> index 188d83f..c89a025 100644
> --- a/drivers/scsi/be2iscsi/be_iscsi.c
> +++ b/drivers/scsi/be2iscsi/be_iscsi.c
> @@ -466,6 +466,10 @@ beiscsi_set_ipv6(struct Scsi_Host *shost,
>   		ret =3D mgmt_set_ip(phba, iface_param, NULL,
>   				  ISCSI_BOOTPROTO_STATIC);
>   		break;
> +	case ISCSI_NET_PARAM_VLAN_ENABLED:
> +	case ISCSI_NET_PARAM_VLAN_TAG:
> +		ret =3D beiscsi_set_vlan_tag(shost, iface_param);
> +		break;
>   	default:
>   		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
>   			    "BS_%d : Param %d not supported\n",
>
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
