From: "Jack Wang" <jack_wang@usish.com>
Subject: Re: [PATCH] pm8001: PM8001F_RUN_TIME state, not bit.
Date: Wed, 18 Jan 2012 09:41:24 +0800
Message-ID: <92D7F475061B423D99929A5AB92990A3@usish.com.cn>
References: <E05C3B97-AF03-4B09-90B6-D124B78DE653@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:33443 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab2ARBnG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2012 20:43:06 -0500
In-Reply-To: <E05C3B97-AF03-4B09-90B6-D124B78DE653@xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Mark Salyzyn' <mark_salyzyn@xyratex.com>, 'linux-scsi' <linux-scsi@vger.kernel.org>
Cc: 'crystal_yu' <crystal_yu@usish.com>, 'lindar_liu' <lindar_liu@usish.com>, 'James Bottomley' <JBottomley@parallels.com>

> pm8001_phy_control PHY_FUNC_HARD_RESET locks up on second try via
> smp_phy_control because response HW_EVENT_PHY_START_STATUS fails to
complete
> previous command. The PM8001F_RUN_TIME flag is not treated as a bit, but a
state
> in all readers, yet once we are operational or in the run time state, the
flags
> use a bit-set operation.
> 
[Jack Wang] 
Thanks for fix.
Ack-by: Jack Wang <jack_wang@usish.com>

> Signed-off-by: mark_salyzyn@xyratex.com
> Cc: jack_wang@usish.com
> Cc: JBottomley@parallels.com
> Cc: crystal_yu@usish.com
> Cc: john_gong@usish.com
> Cc: lindar_liu <lindar_liu@usish.com>
> 
>  drivers/scsi/pm8001/pm8001_sas.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c
> b/drivers/scsi/pm8001/pm8001_sas.c
> index fb3dc99..7ae22a6 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -615,7 +615,7 @@ static int pm8001_dev_found_notify(struct
domain_device
> *dev)
>  	wait_for_completion(&completion);
>  	if (dev->dev_type == SAS_END_DEV)
>  		msleep(50);
> -	pm8001_ha->flags |= PM8001F_RUN_TIME ;
> +	pm8001_ha->flags = PM8001F_RUN_TIME;
>  	return 0;
>  found_out:
>  	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
> 
> Sincerely -- Mark Salyzyn--
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

