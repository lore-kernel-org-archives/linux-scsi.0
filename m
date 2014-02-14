From: "lindar_liu" <lindar_liu@usish.com>
Subject: RE: [PATCH] [scsi] : pm80xx : fix problem of pm8001_work_fn reseting uncorrect phy device
Date: Fri, 14 Feb 2014 17:00:14 +0800
Message-ID: <004001cf2963$30b40900$921c1b00$@com>
References: <1392364888-6996-1-git-send-email-zxh3737@163.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:55471 "EHLO msb01.usish.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbaBNJA2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Feb 2014 04:00:28 -0500
In-Reply-To: <1392364888-6996-1-git-send-email-zxh3737@163.com>
Content-Language: zh-cn
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'XinHong Zhu' <zxh3737@163.com>, linux-scsi@vger.kernel.org

On Friday, February 14, 2014 4:01 PM, XinHong Zhu wrote: 
> If a phy device is removed ,the device can get error of I/O and HBA maybe
> receieve IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS of event which causes
pm8001_work_fn
> to reset the phy device ,but in pm8001_task_exec don't assign a value for
> field device of ccb  and in other case a ccb used have device field set ,
when
> ccb is freeed the field device of the ccb don't be set NULL.So there is
> possibility of getting another devcie reset in fun of mpi_ssp_completion
.Also
> there are another way to solve problem by adding following code in
> mpi_SSP_completion:
>   pm8001_dev = t->dev->lldd_dev;
> Signed-off-by: zhuxh <zxh3737@163.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c
> b/drivers/scsi/pm8001/pm8001_sas.c
> index f50ac44..f0ea5db 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -434,6 +434,7 @@ static int pm8001_task_exec(struct sas_task *task,
const
> int num,
>  		ccb->n_elem = n_elem;
>  		ccb->ccb_tag = tag;
>  		ccb->task = t;
> +		ccb->device = pm8001_dev;
>  		switch (t->task_proto) {
>  		case SAS_PROTOCOL_SMP:
>  			rc = pm8001_task_prep_smp(pm8001_ha, ccb);

Acked-by: Lindar Liu <lindar_liu@usish.com>

This is the best way to fix such issue. Thanks.

> --
> 1.7.9


