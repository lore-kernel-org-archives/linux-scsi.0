From: "tom" <tom_peng@usish.com>
Subject: Re: [PATCH 3/5] reuse the original port when reenable the phy in a port
Date: Thu, 9 Jul 2009 10:12:24 +0800
Message-ID: <F09F16995B2840F690A3A7ABDFF58F95@usish.com.cn>
References: <7813BB8F7D624D168612B73E822A1ED9@usish.com.cn> <1247077767.4159.247.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from usish.com ([210.5.144.203]:46642 "EHLO sr-smtp.usish.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758149AbZGICam (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2009 22:30:42 -0400
In-Reply-To: <1247077767.4159.247.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@HansenPartnership.com>, 'jack wang' <jack_wang@usish.com>
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, lindar_liu@usish.com, aoqingyun@usish.com


On Wed, 2009-07-01 at 20:37 +0800, jack wang wrote:
> >From 24abd7f05d2293e03aacbdd9d620d6378ea5e2aa Mon Sep 17 00:00:00 2001
> From: Tom Peng <tom_peng@usish.com>
> Date: Wed, 1 Jul 2009 19:04:01 +0800
> Subject: [PATCH 3/5] reuse the original port when reenable the phy in a
port
> 
> Signed-off-by: Tom Peng <tom_peng@usish.com>
> Signed-off-by: Jack Wang <jack_wang@usish.com>
> Signed-off-by: Lindar Liu <lindar_liu@usish.com>
> ---
>  drivers/scsi/libsas/sas_port.c |   19 +++++++++++++++----
>  1 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_port.c
b/drivers/scsi/libsas/sas_port.c
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


--

Hi James,
Just think one situation: a HBA has two wide ports, port 0 (phy0, phy1,
phy2, phy3) attached to expander A, port1 (phy4, phy5, phy6, phy7) attached
to expander B, supposed the cable of port0 was plugged out, port1 still
here. After a while, for some reason phy4(or phy5 phy6 phy7) linked down
then linked up, the code will added this phy to form a new port, it is
port0, rather than added this phy to port1.

I have tested this bug, use SMP utility phy_control to disable phy4
(expander B)and then enabled it, it formed new port: port0.

To fix this, we can detect all of the ports existed and if no any port
matched, we form new one.

Best Regards

****************************************************************************
******************

Tom Peng     Software Engineer

Network & Storage Division, R & D Center

Universal Scientific Industrial (Shanghai) Co., Ltd

****************************************************************************
********************

To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

