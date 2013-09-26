From: "Sangeetha Gnanasekaran" <Sangeetha.Gnanasekaran@pmcs.com>
Subject: RE: [PATCH V2 06/10] pm80xx: Print SAS address of IO failed device.
Date: Thu, 26 Sep 2013 02:05:34 -0700
Message-ID: <E5DEE6F468524847995699AD11E8088501EDC910@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
References: <5243C831.9090309@pmc-sierra.com> <5243DC26.8090909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:56752 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751471Ab3IZJFh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Sep 2013 05:05:37 -0400
Content-class: urn:content-classes:message
In-Reply-To: <5243DC26.8090909@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <xjtuwjp@gmail.com>, Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
Cc: linux-scsi@vger.kernel.org, Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>, Viswas G <Viswas.G@pmcs.com>

We will resend the updated patch with this change.

-----Original Message-----
From: Jack Wang [mailto:xjtuwjp@gmail.com] 
Sent: Thursday, September 26, 2013 12:33 PM
To: Anand Kumar Santhanam
Cc: linux-scsi@vger.kernel.org; Sangeetha Gnanasekaran; Nikith
Ganigarakoppal; Viswas G
Subject: Re: [PATCH V2 06/10] pm80xx: Print SAS address of IO failed
device.

On 09/26/2013 07:37 AM, Anand wrote:
> From 5ddec5ef3033b4fee08dcdc7ba8b434425453e9d Mon Sep 17 00:00:00 2001
> From: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
> Date: Tue, 17 Sep 2013 16:47:21 +0530
> Subject: [PATCH V2 06/10] pm80xx: Print SAS address of IO failed
device.
> 
> Signed-off-by: Anandkumar.Santhanam@pmcs.com
> 
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c |   65
++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/pm8001/pm80xx_hwi.c |   65
++++++++++++++++++++++++++++++++++++++
>  2 files changed, 130 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c 
> b/drivers/scsi/pm8001/pm8001_hwi.c
> index 2fd8c38..c9cc744 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -1868,6 +1868,13 @@ mpi_ssp_completion(struct pm8001_hba_info
*pm8001_ha , void *piomb)
>  	if (unlikely(!t || !t->lldd_task || !t->dev))
>  		return;
>  	ts = &t->task_status;
> +	/* Print sas address of IO failed device */
> +	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
> +		(status != IO_UNDERFLOW))
> +		PM8001_FAIL_DBG(pm8001_ha,
> +			pm8001_printk("SAS Address of IO Failure Drive:"
> +			"%016llx", SAS_ADDR(t->dev->sas_addr)-1));
> +
>  	switch (status) {
>  	case IO_SUCCESS:
>  		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS"
> @@ -2276,6 +2283,11 @@ mpi_sata_completion(struct pm8001_hba_info
*pm8001_ha, void *piomb)
>  	u32 param;
>  	u32 status;
>  	u32 tag;
> +	int i, j;
> +	u8 sata_addr_low[4];
> +	u32 temp_sata_addr_low;
> +	u8 sata_addr_hi[4];
> +	u32 temp_sata_addr_hi;
>  	struct sata_completion_resp *psataPayload;
>  	struct task_status_struct *ts;
>  	struct ata_task_resp *resp ;
> @@ -2325,7 +2337,60 @@ mpi_sata_completion(struct pm8001_hba_info
*pm8001_ha, void *piomb)
>  			pm8001_printk("ts null\n"));
>  		return;
>  	}
> +	/* Print sas address of IO failed device */
> +	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
> +		(status != IO_UNDERFLOW)) {
> +		if (!((t->dev->parent) &&
> +			(DEV_IS_EXPANDER(t->dev->parent->dev_type)))) {
> +			for (i = 0 , j = 4 ; j <= 7 && i <= 3 ; i++ ,
j++)
> +				sata_addr_low[i] =
pm8001_ha->sas_addr[j];
> +			for (i = 0 , j = 0; j <= 3 && i <= 3; i++ , j++)
> +				sata_addr_hi[i] =
pm8001_ha->sas_addr[j];
> +			memcpy(&temp_sata_addr_low, sata_addr_low,
> +				sizeof(sata_addr_low));
> +			memcpy(&temp_sata_addr_hi, sata_addr_hi,
> +				sizeof(sata_addr_hi));
> +			temp_sata_addr_hi = (((temp_sata_addr_hi >> 24)
& 0xff)
> +						|((temp_sata_addr_hi <<
8) &
> +						0xff0000) |
> +						((temp_sata_addr_hi >>
8)
> +						& 0xff00) |
> +						((temp_sata_addr_hi <<
24) &
> +						0xff000000));
> +			temp_sata_addr_low = ((((temp_sata_addr_low >>
24)
> +						& 0xff) |
> +						((temp_sata_addr_low <<
8)
> +						& 0xff0000) |
> +						((temp_sata_addr_low >>
8)
> +						& 0xff00) |
> +						((temp_sata_addr_low <<
24)
> +						& 0xff000000)) +
> +						pm8001_dev->attached_phy
+
> +						0x10);
> +			PM8001_FAIL_DBG(pm8001_ha,
> +				pm8001_printk("SAS Address of IO Failure
Drive:"
> +				"%08x%08x", temp_sata_addr_hi,
> +					temp_sata_addr_low));
> +		} else {
> +			for (i = 0 , j = 4 ; j <= 7 && i <= 3; i++ ,
j++)
> +				sata_addr_low[i] = t->dev->sas_addr[j];
> +			for (i = 0 , j = 0 ; j <= 3 && i <= 3 ; i++ ,
j++)
> +				sata_addr_hi[i] = t->dev->sas_addr[j];
> +			temp_sata_addr_low = (sata_addr_low[0] << 24) |
> +						(sata_addr_low[1] << 16)
|
> +						(sata_addr_low[2] << 8)
|
> +						(sata_addr_low[3]);
> +			temp_sata_addr_hi =  (sata_addr_hi[0] << 24)|
> +						(sata_addr_hi[1] << 16)|
> +						(sata_addr_hi[2] << 8)|
> +						(sata_addr_hi[3]);
>  
> +			PM8001_FAIL_DBG(pm8001_ha,
> +				pm8001_printk("SAS Address of IO Failure
Drive:"
> +				"%08x%08x", temp_sata_addr_hi,
> +					temp_sata_addr_low));
> +		}
> +	}
>  	switch (status) {
>  	case IO_SUCCESS:
>  		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS\n"));
diff --git 
> a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index e1ab320..80a10aa 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1296,6 +1296,13 @@ mpi_ssp_completion(struct pm8001_hba_info
*pm8001_ha , void *piomb)
>  	if (unlikely(!t || !t->lldd_task || !t->dev))
>  		return;
>  	ts = &t->task_status;
> +	/* Print sas address of IO failed device */
> +	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
> +		(status != IO_UNDERFLOW))
> +		PM8001_FAIL_DBG(pm8001_ha,
> +			pm8001_printk("SAS Address of IO Failure Drive"
> +			":%016llx", SAS_ADDR(t->dev->sas_addr)-1));
> +
>  	switch (status) {
>  	case IO_SUCCESS:
>  		PM8001_IO_DBG(pm8001_ha,
> @@ -1719,6 +1726,10 @@ mpi_sata_completion(struct pm8001_hba_info
*pm8001_ha, void *piomb)
>  	u32 param;
>  	u32 status;
>  	u32 tag;
> +	int i, j;
> +	u8 sata_addr_low[4];
> +	u32 temp_sata_addr_low, temp_sata_addr_hi;
> +	u8 sata_addr_hi[4];
>  	struct sata_completion_resp *psataPayload;
>  	struct task_status_struct *ts;
>  	struct ata_task_resp *resp ;
> @@ -1768,7 +1779,61 @@ mpi_sata_completion(struct pm8001_hba_info
*pm8001_ha, void *piomb)
>  			pm8001_printk("ts null\n"));
>  		return;
>  	}
> +	/* Print sas address of IO failed device */
> +	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
> +		(status != IO_UNDERFLOW)) {
> +		if (!((t->dev->parent) &&
> +			(DEV_IS_EXPANDER(t->dev->parent->dev_type)))) {
> +			for (i = 0 , j = 4 ; i <= 3 && j <= 7 ; i++ ,
j++)
> +				sata_addr_low[i] =
pm8001_ha->sas_addr[j];
> +			for (i = 0 , j = 0; i <= 3 && j <= 3; i++ , j++)
> +				sata_addr_hi[i] =
pm8001_ha->sas_addr[j];
> +			memcpy(&temp_sata_addr_low, sata_addr_low,
> +				sizeof(sata_addr_low));
> +			memcpy(&temp_sata_addr_hi, sata_addr_hi,
> +				sizeof(sata_addr_hi));
> +			temp_sata_addr_hi = (((temp_sata_addr_hi >> 24)
& 0xff)
> +						|((temp_sata_addr_hi <<
8) &
> +						0xff0000) |
> +						((temp_sata_addr_hi >>
8)
> +						& 0xff00) |
> +						((temp_sata_addr_hi <<
24) &
> +						0xff000000));
> +			temp_sata_addr_low = ((((temp_sata_addr_low >>
24)
> +						& 0xff) |
> +						((temp_sata_addr_low <<
8)
> +						& 0xff0000) |
> +						((temp_sata_addr_low >>
8)
> +						& 0xff00) |
> +						((temp_sata_addr_low <<
24)
> +						& 0xff000000)) +
> +						pm8001_dev->attached_phy
+
> +						0x10);
> +			PM8001_FAIL_DBG(pm8001_ha,
> +				pm8001_printk("SAS Address of IO Failure
Drive:"
> +				"%08x%08x", temp_sata_addr_hi,
> +					temp_sata_addr_low));
> +
> +		} else {
> +			for (i = 0 , j = 4 ; i <= 3 && j <= 7; i++ ,
j++)
> +				sata_addr_low[i] = t->dev->sas_addr[j];
> +			for (i = 0 , j = 0 ; i <= 3 && j <= 3 ; i++ ,
j++)
> +				sata_addr_hi[i] = t->dev->sas_addr[j];
> +			temp_sata_addr_low = (sata_addr_low[0] << 24) |
> +						(sata_addr_low[1] << 16)
|
> +						(sata_addr_low[2] << 8)
|
> +						(sata_addr_low[3]);
> +			temp_sata_addr_hi =  (sata_addr_hi[0] << 24)|
> +						(sata_addr_hi[1] << 16)|
> +						(sata_addr_hi[2] << 8)|
> +						(sata_addr_hi[3]);
>  
> +			PM8001_FAIL_DBG(pm8001_ha,
> +				pm8001_printk("SAS Address of IO Failure
Drive:"
> +				"%08x%08x", temp_sata_addr_hi,
> +					temp_sata_addr_low));

you don't need convert for second else case just use
> +		":%016llx", SAS_ADDR(t->dev->sas_addr)-1)); should be
fine?

Jack
> +	}
>  	switch (status) {
>  	case IO_SUCCESS:
>  		PM8001_IO_DBG(pm8001_ha, pm8001_printk("IO_SUCCESS\n"));
> 

