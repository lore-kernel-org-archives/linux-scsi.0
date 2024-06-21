Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C85C14E2E4;
	Fri, 21 Jun 2024 08:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718958412; cv=none; b=ebVD8ON38uBxUX6GxG1BdxA2g8p83z/klVn7ueDoMXUuy1w7gFychRv2IdwYy9rzIujQAZYZJRqkrEXVTKtPZjSRyENJyqGdPwajP2/s/tnW07ar714TBycZlCitcFYUm/0iCJI7+6mv6DxMVJuYIhAfEzL+i8+tooLLSAMlDEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718958412; c=relaxed/simple;
	bh=JarBKBsaFTCGXmbsuxBZ6Nv5//lNkJCf51N1+0HetDY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P8/g/7tZG+CbNw/OPU+JznGef/U8VgKKM82r9cr5uR3D/nKvQ1ZHmKURqklkr+a4I4RGbyy6PthGYw7EtI5W9UxZ5g3qZiMN7nqBljAGDZbRHUWkKFUf22hg0BZfbuHD/QqfqyzfeNyToJXNRWU1tF5tjfYKm8VZgXxvVfPlVWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: fbba066c2fa711ef9305a59a3cc225df-20240621
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:c5c62c4b-4398-4200-9b61-0ec0b40a61d5,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-5
X-CID-INFO: VERSION:1.1.38,REQID:c5c62c4b-4398-4200-9b61-0ec0b40a61d5,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:82c5f88,CLOUDID:ae2de29ddb49c58889e76c9c6df65354,BulkI
	D:240621162642I8UXEJG5,BulkQuantity:0,Recheck:0,SF:64|66|24|17|19|44|102,T
	C:nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil
	,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: fbba066c2fa711ef9305a59a3cc225df-20240621
Received: from node2.com.cn [(39.156.73.10)] by mailgw.kylinos.cn
	(envelope-from <mengfanhui@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 486322860; Fri, 21 Jun 2024 16:26:40 +0800
Received: from node2.com.cn (localhost [127.0.0.1])
	by node2.com.cn (NSMail) with SMTP id D1579B803C9E;
	Fri, 21 Jun 2024 16:26:39 +0800 (CST)
X-ns-mid: postfix-6675393F-71261973
Received: from [172.30.60.81] (unknown [172.30.60.81])
	by node2.com.cn (NSMail) with ESMTPA id 546A1B803C9E;
	Fri, 21 Jun 2024 08:26:39 +0000 (UTC)
Message-ID: <7b27a776-176d-4885-94cc-a3fea56b385f@kylinos.cn>
Date: Fri, 21 Jun 2024 16:26:38 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: megaraid_sas: Fix DCMD issue command handling
To: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
 shivasharan.srikanteshwara@broadcom.com, chandrakanth.patil@broadcom.com
Cc: liuyun01@kylinos.cn, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, geliang@kernel.org
References: <20240530094514.2750723-1-mengfanhui@kylinos.cn>
Content-Language: en-US
From: mengfanhui <mengfanhui@kylinos.cn>
In-Reply-To: <20240530094514.2750723-1-mengfanhui@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Kindly PING.

On 2024/5/30 17:45, mengfanhui wrote:
> If DCMD timeout not handled, the next interaction between the driver and firmware will still
> result in DCMD timeout, which may cause system crashes or hang up
> 
> This patch will do proper error handling for DCMD command
> for Fusion adapters:
> 
> 1. What action needs to be taken in case of DCMD timeout is decided by
> function dcmd_timeout_ocr_possible().  DCMD timeout causing OCR is
> applicable to the following situation:
>     INITIATE_OCR
>     KILL_ADAPTER
>     IGNORE_TIMEOUT
> 
> 2. If those DCMDs fail, driver bails out.
> 
> Error log:
> [ 201.689759] megaraid_sas 0001:05:00.0: megasas_sync_pd_seq_num DCMD timed out, continue without JBOD sequence map
> [ 242.649061] [] megasas_init+0x114/0x4000 [megaraid_sas]
> [ 363.481009] [] megasas_issue_blocked_cmd+0x1d8/0x268 [megaraid_sas]
> [ 363.481159] [] megasas_get_pd_list+0x548/0x688 [megaraid_sas]
> [ 363.481309] [] megasas_init_fw+0xb38/0x1104 [megaraid_sas]
> [ 363.481459] [] megasas_probe_one+0x1f4/0x5c4 [megaraid_sas]
> [ 363.482419] [] megasas_init+0x114/0x4000 [megaraid_sas]
> [ 381.912298] megaraid_sas 0001:05:00.0: DCMD(opcode: 0x2010100) is timed out, func:megasas_issue_blocked_cmd
> [ 381.912979] megaraid_sas 0001:05:00.0: Ignore DCMD timeout: megasas_get_pd_list 4727
> [ 484.313526] [] megasas_init+0x114/0x4000 [megaraid_sas]
> [ 562.136294] megaraid_sas 0001:05:00.0: DCMD(opcode: 0x3010100) is timed out, func:megasas_issue_blocked_cmd
> [ 562.137074] megaraid_sas 0001:05:00.0: Ignore DCMD timeout: megasas_ld_list_query 4973
> [ 562.137081] megaraid_sas 0001:05:00.0: failed to get LD list
> [ 562.137425] megaraid_sas 0001:05:00.0: megasas_init_fw: megasas_get_device_list failed
> [ 562.137767] megaraid_sas 0001:05:00.0: megasas_disable_intr_fusion is called outbound_intr_mask:0x40000009
> [ 562.139232] megaraid_sas 0001:05:00.0: Failed from megasas_init_fw 6572
> 
> Co-developed-by: Jackie Liu <liuyun01@kylinos.cn>
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> Signed-off-by: mengfanhui <mengfanhui@kylinos.cn>
> Suggested-by: Geliang Tang <geliang@kernel.org>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |  1 +
>  drivers/scsi/megaraid/megaraid_sas_base.c   |  4 +-
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 71 +++++++++++++++++----
>  3 files changed, 62 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
> index 5680c6cdb221..91570c5e8456 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -2760,5 +2760,6 @@ void megasas_exit_debugfs(void);
>  void megasas_setup_debugfs(struct megasas_instance *instance);
>  void megasas_destroy_debugfs(struct megasas_instance *instance);
>  int megasas_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num);
> +int dcmd_timeout_ocr_possible(struct megasas_instance *instance);
>  
>  #endif				/*LSI_MEGARAID_SAS_H */
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 170b38f04655..ba8061ea2078 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -4518,8 +4518,8 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
>   * Return 0 for only Fusion adapter, if driver load/unload is not in progress
>   * or FW is not under OCR.
>   */
> -inline int
> -dcmd_timeout_ocr_possible(struct megasas_instance *instance) {
> +int dcmd_timeout_ocr_possible(struct megasas_instance *instance)
> +{
>  
>  	if (instance->adapter_type == MFI_SERIES)
>  		return KILL_ADAPTER;
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 6c1fb8149553..f0aeb1ee83a2 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -1363,17 +1363,42 @@ megasas_sync_pd_seq_num(struct megasas_instance *instance, bool pend) {
>  			"driver supports max %d JBOD, but FW reports %d\n",
>  			MAX_PHYSICAL_DEVICES, le32_to_cpu(pd_sync->count));
>  		ret = -EINVAL;
> +		goto out;
>  	}
>  
> -	if (ret == DCMD_TIMEOUT)
> -		dev_warn(&instance->pdev->dev,
> -			 "%s DCMD timed out, continue without JBOD sequence map\n",
> -			 __func__);
> -
> -	if (ret == DCMD_SUCCESS)
> +	switch (ret) {
> +	case DCMD_SUCCESS:
>  		instance->pd_seq_map_id++;
> +		break;
> +	case DCMD_TIMEOUT:
> +		switch (dcmd_timeout_ocr_possible(instance)) {
> +		case INITIATE_OCR:
> +			cmd->flags |= DRV_DCMD_SKIP_REFIRE;
> +			mutex_unlock(&instance->reset_mutex);
> +			megasas_reset_fusion(instance->host,
> +					     MFI_IO_TIMEOUT_OCR);
> +			mutex_lock(&instance->reset_mutex);
> +			break;
> +		case KILL_ADAPTER:
> +			megaraid_sas_kill_hba(instance);
> +			break;
> +		case IGNORE_TIMEOUT:
> +			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d\n",
> +				 __func__, __LINE__);
> +			break;
> +		}
> +		break;
> +	case DCMD_FAILED:
> +		dev_err(&instance->pdev->dev,
> +			"%s: MR_DCMD_SYSTEM_PD_MAP_GET_INFO failed\n",
> +			__func__);
> +		break;
> +	}
> +
> +out:
> +	if (ret != DCMD_TIMEOUT)
> +		megasas_return_cmd(instance, cmd);
>  
> -	megasas_return_cmd(instance, cmd);
>  	return ret;
>  }
>  
> @@ -1449,12 +1474,34 @@ megasas_get_ld_map_info(struct megasas_instance *instance)
>  	else
>  		ret = megasas_issue_polled(instance, cmd);
>  
> -	if (ret == DCMD_TIMEOUT)
> -		dev_warn(&instance->pdev->dev,
> -			 "%s DCMD timed out, RAID map is disabled\n",
> -			 __func__);
> +	switch (ret) {
> +	case DCMD_TIMEOUT:
> +		switch (dcmd_timeout_ocr_possible(instance)) {
> +		case INITIATE_OCR:
> +			cmd->flags |= DRV_DCMD_SKIP_REFIRE;
> +			mutex_unlock(&instance->reset_mutex);
> +			megasas_reset_fusion(instance->host,
> +					     MFI_IO_TIMEOUT_OCR);
> +			mutex_lock(&instance->reset_mutex);
> +			break;
> +		case KILL_ADAPTER:
> +			megaraid_sas_kill_hba(instance);
> +			break;
> +		case IGNORE_TIMEOUT:
> +			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d\n",
> +				 __func__, __LINE__);
> +			break;
> +		}
> +		break;
> +	case DCMD_FAILED:
> +		dev_err(&instance->pdev->dev,
> +			"%s: MR_DCMD_LD_MAP_GET_INFO failed\n",
> +			__func__);
> +		break;
> +	}
>  
> -	megasas_return_cmd(instance, cmd);
> +	if (ret != DCMD_TIMEOUT)
> +		megasas_return_cmd(instance, cmd);
>  
>  	return ret;
>  }
