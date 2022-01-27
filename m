Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BBFFC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jan 2022 11:31:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240393AbiA0Lbt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jan 2022 06:31:49 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:32125 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240384AbiA0Lbs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jan 2022 06:31:48 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Jkyym27Hmz8wgG;
        Thu, 27 Jan 2022 19:28:48 +0800 (CST)
Received: from [10.40.193.166] (10.40.193.166) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Thu, 27 Jan 2022 19:31:46 +0800
Subject: Re: [PATCH 01/16] scsi: libsas: Use enum for response frame DATAPRES
 field
To:     John Garry <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <artur.paszkiewicz@intel.com>,
        <jinpu.wang@cloud.ionos.com>, <Ajish.Koshy@microchip.com>
References: <1643110372-85470-1-git-send-email-john.garry@huawei.com>
 <1643110372-85470-2-git-send-email-john.garry@huawei.com>
CC:     <yanaijie@huawei.com>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linuxarm@huawei.com>, <liuqi115@huawei.com>,
        <Viswas.G@microchip.com>, <damien.lemoal@opensource.wdc.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <4a2986a4-8293-2a25-8ee1-109ff8aa0bc3@hisilicon.com>
Date:   Thu, 27 Jan 2022 19:31:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <1643110372-85470-2-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi John,


在 2022/1/25 19:32, John Garry 写道:
> As defined in table 126 of the SAS spec 1.1, use an enum for the DATAPRES
> field, which makes reading the code easier.
>
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>   drivers/scsi/libsas/sas_task.c | 12 +++++++++---
>   1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/libsas/sas_task.c b/drivers/scsi/libsas/sas_task.c
> index 2966ead1d421..7240fd22b154 100644
> --- a/drivers/scsi/libsas/sas_task.c
> +++ b/drivers/scsi/libsas/sas_task.c
> @@ -7,6 +7,12 @@
>   #include <scsi/sas.h>
>   #include <scsi/libsas.h>
>   
> +enum {
> +	NO_DATA = 0,
> +	RESPONSE_DATA = 1,
> +	SENSE_DATA = 2,
> +};
> +

I find that iu->datapres is also used in other drivers with 0/1/2, and 
maybe it is worth to replace all of them with those enum.

   2    290 
/home/chenxiang/kernel_next/kernel-dev/drivers/scsi/aic94xx/aic94xx_tmf.c 
<<<unknown>>>
              if (ru->datapres == 1)
5   1055 
/home/chenxiang/kernel_next/kernel-dev/drivers/scsi/isci/request.c 
<<<unknown>>>
              if (datapres == 1 || datapres == 2) {
    6   1740 
/home/chenxiang/kernel_next/kernel-dev/drivers/scsi/isci/request.c 
<<<unknown>>>
              if (resp_iu->datapres == 0x01 ||
    7   1741 
/home/chenxiang/kernel_next/kernel-dev/drivers/scsi/isci/request.c 
<<<unknown>>>
                  resp_iu->datapres == 0x02) {
  17   1641 
/home/chenxiang/kernel_next/kernel-dev/drivers/scsi/mvsas/mv_sas.c 
<<<unknown>>>
              iu->datapres = 2;

>   /* fill task_status_struct based on SSP response frame */
>   void sas_ssp_task_response(struct device *dev, struct sas_task *task,
>   			   struct ssp_response_iu *iu)
> @@ -15,11 +21,11 @@ void sas_ssp_task_response(struct device *dev, struct sas_task *task,
>   
>   	tstat->resp = SAS_TASK_COMPLETE;
>   
> -	if (iu->datapres == 0)
> +	if (iu->datapres == NO_DATA)
>   		tstat->stat = iu->status;
> -	else if (iu->datapres == 1)
> +	else if (iu->datapres == RESPONSE_DATA)
>   		tstat->stat = iu->resp_data[3];
> -	else if (iu->datapres == 2) {
> +	else if (iu->datapres == SENSE_DATA) {
>   		tstat->stat = SAS_SAM_STAT_CHECK_CONDITION;
>   		tstat->buf_valid_size =
>   			min_t(int, SAS_STATUS_BUF_SIZE,



