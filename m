From: "Jack Wang" <jack_wang@usish.com>
Subject: RE: [PATCH] pm8001: fix enum checks
Date: Wed, 15 Feb 2012 09:02:51 +0800
Message-ID: <19540A16097A409F9E4999160E0B25BC@usish.com.cn>
References: <1329230455-27084-1-git-send-email-danny.kukawka@bisect.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:58802 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525Ab2BOBFK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Feb 2012 20:05:10 -0500
In-Reply-To: <1329230455-27084-1-git-send-email-danny.kukawka@bisect.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Danny Kukawka' <danny.kukawka@bisect.de>, "'James E.J. Bottomley'" <JBottomley@parallels.com>
Cc: 'Danny Kukawka' <dkukawka@suse.de>, lindar_liu@usish.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Thanks for fix.
Acked-by: Jack Wang <jack_wang@usish.com> 

[PATCH] pm8001: fix enum checks
> 
> Fix for:
> drivers/scsi/pm8001/pm8001_hwi.c: In function 'hw_event_sas_phy_up':
> drivers/scsi/pm8001/pm8001_hwi.c:2932:32: warning: comparison between
>   'enum sas_device_type' and 'enum sas_dev_type' [-Wenum-compare]
> drivers/scsi/pm8001/pm8001_hwi.c:2934:37: warning: comparison between
>   'enum sas_device_type' and 'enum sas_dev_type' [-Wenum-compare]
> 
> Changed SAS_END_DEV to SAS_END_DEVICE and NO_DEVICE with
> SAS_PHY_UNUSED.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
> b/drivers/scsi/pm8001/pm8001_hwi.c
> index b7b92f7..46fd7219 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -2929,9 +2929,9 @@ hw_event_sas_phy_up(struct pm8001_hba_info
*pm8001_ha,
> void *piomb)
>  	phy->phy_type |= PORT_TYPE_SAS;
>  	phy->identify.device_type = deviceType;
>  	phy->phy_attached = 1;
> -	if (phy->identify.device_type == SAS_END_DEV)
> +	if (phy->identify.device_type == SAS_END_DEVICE)
>  		phy->identify.target_port_protocols = SAS_PROTOCOL_SSP;
> -	else if (phy->identify.device_type != NO_DEVICE)
> +	else if (phy->identify.device_type != SAS_PHY_UNUSED)
>  		phy->identify.target_port_protocols = SAS_PROTOCOL_SMP;
>  	phy->sas_phy.oob_mode = SAS_OOB_MODE;
>  	sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
> --
> 1.7.7.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

