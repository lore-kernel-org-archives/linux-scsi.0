From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH] pm80xx: fix Adaptec 71605H hang
Date: Mon, 15 Jul 2013 11:44:14 +0200
Message-ID: <51E3C46E.8030600@gmail.com>
References: <51E2605D.3000301@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:54914 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547Ab3GOJnm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jul 2013 05:43:42 -0400
Received: by mail-bk0-f43.google.com with SMTP id jm2so4530536bkc.16
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jul 2013 02:43:41 -0700 (PDT)
In-Reply-To: <51E2605D.3000301@xs4all.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-scsi@vger.kernel.org, AnandKumar.Santhanam@pmcs.com, lindar_liu@usish.com, Sangeetha.Gnanasekaran@pmcs.com, jinpu.wang@profitbricks.com

On 07/14/2013 10:25 AM, Hans Verkuil wrote:
> The IO command size is 128 bytes for these new controllers as opposed to 64
> for the old 8001 controller.
> 
> The Adaptec out-of-tree driver did this correctly. After comparing the two
> this turned out to be the crucial difference.
Thanks Hans for this fix.
We'd better use more meaningful Micro like:

#define MPI_IOMB_SIZE_SPCV 128 and replace current hard coded one.

Thanks,
Jack
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: AnandKumar.Santhanam@pmcs.com
> Cc: stable@vger.kernel.org      # for v3.10 and up
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 302514d..e1db5ca 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -275,7 +275,7 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
>  
>  	for (i = 0; i < PM8001_MAX_SPCV_INB_NUM; i++) {
>  		pm8001_ha->inbnd_q_tbl[i].element_pri_size_cnt	=
> -			PM8001_MPI_QUEUE | (64 << 16) | (0x00<<30);
> +			PM8001_MPI_QUEUE | (128 << 16) | (0x00<<30);
>  		pm8001_ha->inbnd_q_tbl[i].upper_base_addr	=
>  			pm8001_ha->memoryMap.region[IB + i].phys_addr_hi;
>  		pm8001_ha->inbnd_q_tbl[i].lower_base_addr	=
> @@ -301,7 +301,7 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
>  	}
>  	for (i = 0; i < PM8001_MAX_SPCV_OUTB_NUM; i++) {
>  		pm8001_ha->outbnd_q_tbl[i].element_size_cnt	=
> -			PM8001_MPI_QUEUE | (64 << 16) | (0x01<<30);
> +			PM8001_MPI_QUEUE | (128 << 16) | (0x01<<30);
>  		pm8001_ha->outbnd_q_tbl[i].upper_base_addr	=
>  			pm8001_ha->memoryMap.region[OB + i].phys_addr_hi;
>  		pm8001_ha->outbnd_q_tbl[i].lower_base_addr	=
> 

