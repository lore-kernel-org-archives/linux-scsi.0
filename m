From: "Anand Kumar Santhanam" <AnandKumar.Santhanam@pmcs.com>
Subject: RE: [PATCH V5 11/12] pm80xx: NCQ error handling changes
Date: Tue, 7 May 2013 04:14:16 -0700
Message-ID: <E5DEE6F468524847995699AD11E80885017C77BD@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
References: <5187DBC6.40307@pmc-sierra.com> <1367906803.1868.73.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:57844 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756181Ab3EGLO0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 May 2013 07:14:26 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1367906803.1868.73.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, sakthivel.sk@hcl.com, Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>, xjtuwjp@gmail.com, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>, Vishwanath Maram <Vishwanath.Maram@pmcs.com>

Hi James,

Got it. Will be more careful next time.

Regards
Anand

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Tuesday, May 07, 2013 11:37 AM
To: Anand Kumar Santhanam
Cc: linux-scsi@vger.kernel.org; sakthivel.sk@hcl.com; Sangeetha
Gnanasekaran; xjtuwjp@gmail.com; Harry Yang; Rich Bono; Vishwanath Maram
Subject: Re: [PATCH V5 11/12] pm80xx: NCQ error handling changes

On Mon, 2013-05-06 at 09:35 -0700, Anand wrote:
> >From 2738e0b59fe103a363b0ea600b3eccc687a7fa3c Mon Sep 17 00:00:00 
> >2001
> From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Date: Tue, 19 Mar 2013 18:08:08 +0530
> Subject: [PATCH V5 11/12] pm80xx: NCQ error handling changes
> 
> Handled NCQ errors in the low level driver as the FW is not providing 
> the faulty tag for NCQ errors for libsas to recover.
> 
> Signed-off-by: Anand Kumar S <AnandKumar.Santhanam@pmcs.com>
> Acked-by: Jack Wang <jack_wang@usish.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c |  270
++++++++++++++++++++++++++++++++++++--
>  drivers/scsi/pm8001/pm8001_sas.c |   22 +++-
>  drivers/scsi/pm8001/pm8001_sas.h |   15 ++-
>  drivers/scsi/pm8001/pm80xx_hwi.c |  262
+++++++++++++++++++++++++++++++++++--
>  drivers/scsi/pm8001/pm80xx_hwi.h |    1 +
>  5 files changed, 543 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c 
> b/drivers/scsi/pm8001/pm8001_hwi.c
> index 265dbf4..a90c002 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -1707,6 +1707,123 @@ int pm8001_handle_event(struct pm8001_hba_info
*pm8001_ha, void *data,
>  	return ret;
>  }
>  
> +static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
> +		struct pm8001_device *pm8001_ha_dev) {
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
> +		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("dev is null
\n"));

This space before a \n is quite a pattern with you.  Please don't do it
because it can lead to odd problems with logging.  I fixed it up this
time.

Thanks,

James


