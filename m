From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 3/5] reuse the original port when reenable the phy in a
 port
Date: Wed, 08 Jul 2009 18:29:27 +0000
Message-ID: <1247077767.4159.247.camel@mulgrave.site>
References: <7813BB8F7D624D168612B73E822A1ED9@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42022 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751847AbZGHS3b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2009 14:29:31 -0400
In-Reply-To: <7813BB8F7D624D168612B73E822A1ED9@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack wang <jack_wang@usish.com>
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, lindar_liu@usish.com, tom_peng@usish.com, aoqingyun@usish.com

On Wed, 2009-07-01 at 20:37 +0800, jack wang wrote:
> >From 24abd7f05d2293e03aacbdd9d620d6378ea5e2aa Mon Sep 17 00:00:00 2001
> From: Tom Peng <tom_peng@usish.com>
> Date: Wed, 1 Jul 2009 19:04:01 +0800
> Subject: [PATCH 3/5] reuse the original port when reenable the phy in a port
> 
> Signed-off-by: Tom Peng <tom_peng@usish.com>
> Signed-off-by: Jack Wang <jack_wang@usish.com>
> Signed-off-by: Lindar Liu <lindar_liu@usish.com>
> ---
>  drivers/scsi/libsas/sas_port.c |   19 +++++++++++++++----
>  1 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
> index e6ac59c..5aad165 100644
> --- a/drivers/scsi/libsas/sas_port.c
> +++ b/drivers/scsi/libsas/sas_port.c
> @@ -69,16 +69,27 @@ static void sas_form_port(struct asd_sas_phy *phy)
>  			SAS_DPRINTK("phy%d matched wide port%d\n", phy->id,
>  				    port->id);
>  			break;
> -		} else if (*(u64 *) port->sas_addr == 0 &&
> port->num_phys==0) {
> -			memcpy(port->sas_addr, phy->sas_addr,
> SAS_ADDR_SIZE);
> -			break;
>  		}
>  		spin_unlock(&port->phy_list_lock);
>  	}
> +	/* The phy does not match any port currently existed, create new one
> */
> +	if (i == sas_ha->num_phys) {
> +		for (i = 0; i < sas_ha->num_phys; i++) {
> +			port = sas_ha->sas_port[i];
> +			spin_lock(&port->phy_list_lock);
> +			if (*(u64 *)port->sas_addr == 0
> +				&& port->num_phys == 0) {
> +				memcpy(port->sas_addr, phy->sas_addr,
> +					SAS_ADDR_SIZE);
> +				break;
> +			}
> +			spin_unlock(&port->phy_list_lock);
> +		}
> +	}

I don't understand why you need this.  It seems identical to the else
leg of the if in the for loop above it, so it wouldn't seem to add
anything to the code.

James


