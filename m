From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH V1 2/3] pm80xx: Resetting the phy state.
Date: Wed, 13 Nov 2013 10:35:41 +0100
Message-ID: <528347ED.6050007@gmail.com>
References: <528104C1.3050300@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:63865 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758570Ab3KMJfl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Nov 2013 04:35:41 -0500
Received: by mail-bk0-f41.google.com with SMTP id v15so190378bkz.14
        for <linux-scsi@vger.kernel.org>; Wed, 13 Nov 2013 01:35:40 -0800 (PST)
In-Reply-To: <528104C1.3050300@pmc-sierra.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anand <anandkumar_santhanam@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, Sangeetha.Gnanasekaran@pmcs.com, Viswas.G@pmcs.com, Nikith.Ganigarakoppal@pmcs.com

On 11/11/2013 05:24 PM, Anand wrote:
> From 800d934dd22f3ef5d7f52d900295d371d17004bd Mon Sep 17 00:00:00 2001
> From: Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>
> Date: Wed, 30 Oct 2013 16:23:47 +0530
> Subject: [PATCH V1 2/3] pm80xx: Resetting the phy state.
> 
> Setting the phy state for hard reset response.
> After sending hard reset for a device ,phy down event sets
> the phy state to zero but for phy up event it will not set
> the phy state again.This will cause problem to successive
> hard resets.
> 
> 
> Signed-off-by: Anandkumar.Santhanam@pmcs.com
> Signed-off-by: Nikith.Ganigarakoppal@pmcs.com
Nice catch, Thanks

Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>

PS: same about the signed-off chain.
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c |    2 ++
>  drivers/scsi/pm8001/pm8001_hwi.h |    4 ++++
>  drivers/scsi/pm8001/pm80xx_hwi.c |    2 ++
>  drivers/scsi/pm8001/pm80xx_hwi.h |    2 ++
>  4 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 9961616..b23f49d 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -3403,6 +3403,7 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  	unsigned long flags;
>  	u8 deviceType = pPayload->sas_identify.dev_type;
>  	port->port_state =  portstate;
> +	phy->phy_state = PHY_STATE_LINK_UP_SPC;
>  	PM8001_MSG_DBG(pm8001_ha,
>  		pm8001_printk("HW_EVENT_SAS_PHY_UP port id = %d, phy id = %d\n",
>  		port_id, phy_id));
> @@ -3483,6 +3484,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  		pm8001_printk("HW_EVENT_SATA_PHY_UP port id = %d,"
>  		" phy id = %d\n", port_id, phy_id));
>  	port->port_state =  portstate;
> +	phy->phy_state = PHY_STATE_LINK_UP_SPC;
>  	port->port_attached = 1;
>  	pm8001_get_lrate_mode(phy, link_rate);
>  	phy->phy_type |= PORT_TYPE_SATA;
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
> index 6d91e24..e4867e6 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.h
> +++ b/drivers/scsi/pm8001/pm8001_hwi.h
> @@ -131,6 +131,10 @@
>  #define LINKRATE_30			(0x02 << 8)
>  #define LINKRATE_60			(0x04 << 8)
>  
> +/* for phy state */
> +
> +#define PHY_STATE_LINK_UP_SPC		0x1
> +
>  /* for new SPC controllers MEMBASE III is shared between BIOS and DATA */
>  #define GSM_SM_BASE			0x4F0000
>  struct mpi_msg_hdr{
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 4ebc79b..41bee62 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -2894,6 +2894,7 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  	unsigned long flags;
>  	u8 deviceType = pPayload->sas_identify.dev_type;
>  	port->port_state = portstate;
> +	phy->phy_state = PHY_STATE_LINK_UP_SPCV;
>  	PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
>  		"portid:%d; phyid:%d; linkrate:%d; "
>  		"portstate:%x; devicetype:%x\n",
> @@ -2978,6 +2979,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
>  				port_id, phy_id, link_rate, portstate));
>  
>  	port->port_state = portstate;
> +	phy->phy_state = PHY_STATE_LINK_UP_SPCV;
>  	port->port_attached = 1;
>  	pm8001_get_lrate_mode(phy, link_rate);
>  	phy->phy_type |= PORT_TYPE_SATA;
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
> index c86816b..9970a38 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.h
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
> @@ -215,6 +215,8 @@
>  #define SAS_DOPNRJT_RTRY_TMO            128
>  #define SAS_COPNRJT_RTRY_TMO            128
>  
> +/* for phy state */
> +#define PHY_STATE_LINK_UP_SPCV		0x2
>  /*
>    Making ORR bigger than IT NEXUS LOSS which is 2000000us = 2 second.
>    Assuming a bigger value 3 second, 3000000/128 = 23437.5 where 128
> 

