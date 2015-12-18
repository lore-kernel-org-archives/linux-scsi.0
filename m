From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/15] be2iscsi: Fix VLAN support for IPv6 network
Date: Fri, 18 Dec 2015 10:01:40 +0100
Message-ID: <5673CB74.5030008@suse.de>
References: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1450194906-12925-9-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933376AbbLRJBn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Dec 2015 04:01:43 -0500
In-Reply-To: <1450194906-12925-9-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On 12/15/2015 04:54 PM, Jitendra Bhivare wrote:
> From: Jitendra <jitendra.bhivare@avagotech.com>
>
> Configuring VLAN parameters through IPv6 interface was not supported =
in driver.
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
