Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DD3BA53
	for <linux-scsi@vger.kernel.org>; Thu, 13 Mar 2025 01:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741828136; cv=none; b=PY9yO32whVjLYBiyqy1ri1GmWiKOf35oMZPB4AB7RLXGAeBxpoF+45i/qEmnWWWpogQyYcjCcm9NksEb1NJdKN2Rej8l8l0jmZpHAPIffQaTzANfmMVcYJYLMiVcEhXJS/1lm0d1Mdey5rF8YW0WvPhkh81nYw6rhXJlCZE049Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741828136; c=relaxed/simple;
	bh=wPCb7zqh2qbnINpM1a+ctJzIh31xymENDi998Jjsq+E=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=RCYiotB3qp5CqPxztq8nq4Yr5Wqm19sLT5fmelchd+I6BIW2JV+w6/2LwltMFzzDlYf6A4UsVmLfJVc590YCymc6+DnclJGuLiJ4htinuE0RqyVelm5ET9yhb5cPg2uQsNuSx1CUPthgshh8SRIXGRUKh/i4q5Xg1jcOghq75Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4ZCq714M4gzDt0C;
	Thu, 13 Mar 2025 09:05:33 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id E8DEA18006C;
	Thu, 13 Mar 2025 09:08:44 +0800 (CST)
Received: from [10.67.120.126] (10.67.120.126) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 13 Mar 2025 09:08:44 +0800
Subject: Re: [PATCH] scsi: hisi_sas: Fixed failure to issue vendor specific
 commands
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
References: <20250220090011.313848-1-liyihang9@huawei.com>
CC: <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
	<liuyonglong@huawei.com>, <prime.zeng@hisilicon.com>
From: Yihang Li <liyihang9@huawei.com>
Message-ID: <d56071d0-44b8-9572-753f-6db23709cf20@huawei.com>
Date: Thu, 13 Mar 2025 09:08:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250220090011.313848-1-liyihang9@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf100013.china.huawei.com (7.185.36.179)

Gentle ping...

On 2025/2/20 17:00, Yihang Li wrote:
> From: Xingui Yang <yangxingui@huawei.com>
> 
> At present, we determine the protocol through the cmd type, but other
> cmd types, such as vendor-specific commands, default to the pio protocol.
> This strategy often causes the execution of different vendor-specific
> commands to fail. In fact, for these commands, a better way is to use the
> protocol configured by the command's tf to determine its protocol.
> 
> Fixes: 6f2ff1a1311e ("hisi_sas: add v2 path to send ATA command")
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> Reviewed-by: Yihang Li <liyihang9@huawei.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas.h       |  3 +--
>  drivers/scsi/hisi_sas/hisi_sas_main.c  | 28 ++++++++++++++++++++++++--
>  drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  4 +---
>  drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  4 +---
>  4 files changed, 29 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
> index 2d438d722d0b..e17f5d8226bf 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas.h
> +++ b/drivers/scsi/hisi_sas/hisi_sas.h
> @@ -633,8 +633,7 @@ extern struct dentry *hisi_sas_debugfs_dir;
>  extern void hisi_sas_stop_phys(struct hisi_hba *hisi_hba);
>  extern int hisi_sas_alloc(struct hisi_hba *hisi_hba);
>  extern void hisi_sas_free(struct hisi_hba *hisi_hba);
> -extern u8 hisi_sas_get_ata_protocol(struct host_to_dev_fis *fis,
> -				int direction);
> +extern u8 hisi_sas_get_ata_protocol(struct sas_task *task);
>  extern struct hisi_sas_port *to_hisi_sas_port(struct asd_sas_port *sas_port);
>  extern void hisi_sas_sata_done(struct sas_task *task,
>  			    struct hisi_sas_slot *slot);
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index da4a2ed8ee86..3596414d970b 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -21,8 +21,32 @@ struct hisi_sas_internal_abort_data {
>  	bool rst_ha_timeout; /* reset the HA for timeout */
>  };
>  
> -u8 hisi_sas_get_ata_protocol(struct host_to_dev_fis *fis, int direction)
> +static u8 hisi_sas_get_ata_protocol_from_tf(struct ata_queued_cmd *qc)
>  {
> +	if (!qc)
> +		return HISI_SAS_SATA_PROTOCOL_PIO;
> +
> +	switch (qc->tf.protocol) {
> +	case ATA_PROT_NODATA:
> +		return HISI_SAS_SATA_PROTOCOL_NONDATA;
> +	case ATA_PROT_PIO:
> +		return HISI_SAS_SATA_PROTOCOL_PIO;
> +	case ATA_PROT_DMA:
> +		return HISI_SAS_SATA_PROTOCOL_DMA;
> +	case ATA_PROT_NCQ_NODATA:
> +	case ATA_PROT_NCQ:
> +		return HISI_SAS_SATA_PROTOCOL_FPDMA;
> +	default:
> +		return HISI_SAS_SATA_PROTOCOL_PIO;
> +	}
> +}
> +
> +u8 hisi_sas_get_ata_protocol(struct sas_task *task)
> +{
> +	struct host_to_dev_fis *fis = &task->ata_task.fis;
> +	struct ata_queued_cmd *qc = task->uldd_task;
> +	int direction = task->data_dir;
> +
>  	switch (fis->command) {
>  	case ATA_CMD_FPDMA_WRITE:
>  	case ATA_CMD_FPDMA_READ:
> @@ -93,7 +117,7 @@ u8 hisi_sas_get_ata_protocol(struct host_to_dev_fis *fis, int direction)
>  	{
>  		if (direction == DMA_NONE)
>  			return HISI_SAS_SATA_PROTOCOL_NONDATA;
> -		return HISI_SAS_SATA_PROTOCOL_PIO;
> +		return hisi_sas_get_ata_protocol_from_tf(qc);
>  	}
>  	}
>  }
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> index 71cd5b4450c2..6e7f99fcc824 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> @@ -2538,9 +2538,7 @@ static void prep_ata_v2_hw(struct hisi_hba *hisi_hba,
>  			(task->ata_task.fis.control & ATA_SRST))
>  		dw1 |= 1 << CMD_HDR_RESET_OFF;
>  
> -	dw1 |= (hisi_sas_get_ata_protocol(
> -		&task->ata_task.fis, task->data_dir))
> -		<< CMD_HDR_FRAME_TYPE_OFF;
> +	dw1 |= (hisi_sas_get_ata_protocol(task)) << CMD_HDR_FRAME_TYPE_OFF;
>  	dw1 |= sas_dev->device_id << CMD_HDR_DEV_ID_OFF;
>  	hdr->dw1 = cpu_to_le32(dw1);
>  
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index 48b95d9a7927..095bbf80c34e 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -1456,9 +1456,7 @@ static void prep_ata_v3_hw(struct hisi_hba *hisi_hba,
>  			(task->ata_task.fis.control & ATA_SRST))
>  		dw1 |= 1 << CMD_HDR_RESET_OFF;
>  
> -	dw1 |= (hisi_sas_get_ata_protocol(
> -		&task->ata_task.fis, task->data_dir))
> -		<< CMD_HDR_FRAME_TYPE_OFF;
> +	dw1 |= (hisi_sas_get_ata_protocol(task)) << CMD_HDR_FRAME_TYPE_OFF;
>  	dw1 |= sas_dev->device_id << CMD_HDR_DEV_ID_OFF;
>  
>  	if (FIS_CMD_IS_UNCONSTRAINED(task->ata_task.fis))
> 
