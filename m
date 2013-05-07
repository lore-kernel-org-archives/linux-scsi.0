From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V5 11/12] pm80xx: NCQ error handling changes
Date: Mon, 06 May 2013 23:06:43 -0700
Message-ID: <1367906803.1868.73.camel@dabdike>
References: <5187DBC6.40307@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45590 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348Ab3EGGGp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 May 2013 02:06:45 -0400
In-Reply-To: <5187DBC6.40307@pmc-sierra.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anand <anandkumar_santhanam@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, sakthivel.sk@hcl.com, Sangeetha.Gnanasekaran@pmcs.com, xjtuwjp@gmail.com, Harry.Yang@pmcs.com, Rich.Bono@pmcs.com, Vishwanath.Maram@pmcs.com

On Mon, 2013-05-06 at 09:35 -0700, Anand wrote:
> >From 2738e0b59fe103a363b0ea600b3eccc687a7fa3c Mon Sep 17 00:00:00 2001
> From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Date: Tue, 19 Mar 2013 18:08:08 +0530
> Subject: [PATCH V5 11/12] pm80xx: NCQ error handling changes
> 
> Handled NCQ errors in the low level driver as the FW
> is not providing the faulty tag for NCQ errors for libsas
> to recover.
> 
> Signed-off-by: Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
> Acked-by: Jack Wang <jack_wang@usish.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de> 
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c |  270 ++++++++++++++++++++++++++++++++++++--
>  drivers/scsi/pm8001/pm8001_sas.c |   22 +++-
>  drivers/scsi/pm8001/pm8001_sas.h |   15 ++-
>  drivers/scsi/pm8001/pm80xx_hwi.c |  262 +++++++++++++++++++++++++++++++++++--
>  drivers/scsi/pm8001/pm80xx_hwi.h |    1 +
>  5 files changed, 543 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 265dbf4..a90c002 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -1707,6 +1707,123 @@ int pm8001_handle_event(struct pm8001_hba_info *pm8001_ha, void *data,
>  	return ret;
>  }
>  
> +static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
> +		struct pm8001_device *pm8001_ha_dev)
> +{
> +	int res;
> +	u32 ccb_tag;
> +	struct pm8001_ccb_info *ccb;
> +	struct sas_task *task = NULL;
> +	struct task_abort_req task_abort;
> +	struct inbound_queue_table *circularQ;
> +	u32 opc = OPC_INB_SATA_ABORT;
> +	int ret;
> +
> +	if (!pm8001_ha_dev) {
> +		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("dev is null \n"));

This space before a \n is quite a pattern with you.  Please don't do it
because it can lead to odd problems with logging.  I fixed it up this
time.

Thanks,

James


