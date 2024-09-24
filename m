Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F36282F4;
	Tue, 24 Sep 2024 19:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727207536; cv=none; b=p1W2ognqNhtpHzO4AKzAxwfx7fogo5BBrKrMrRWujN8yc8/MwuncXoR4E4U3k6KLHBAIQHaJgVO8ICUfiv5gK9csCC5KmWBkj8GyT7e86qURB6mMrMTYVZjYEXeub97+53B0gTIMM2LPzXhJReRk6SAmpLdA/q5zmINWFSUHq50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727207536; c=relaxed/simple;
	bh=GBfPl46p3Qqe6ckVePVV4hgMaOCUbspLx+WDceCd36g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WXTvqzeVkcAxJ32zJb15pMQUv70VtsMtDF2fpKwor9sJm39uf5LmQ7qwxD8hpnMdt43Pish26B3KRx+XOk9I30nujhBxH1QykbFJqou6sLNWoKdX6TCQH7YNrOKGNWb2fkpSvqI30tdEV42zPOpBRSL2C24eR4HcISik5UaJ4pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nxP/MB1E; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nxP/MB1E"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XCr9N6W7NzlgTWK;
	Tue, 24 Sep 2024 19:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727207526; x=1729799527; bh=GJda8fhfxXefGlmLq7zLa+LN
	hw8pcTKg3Mnj21Cyvzs=; b=nxP/MB1EesPglse33V2POfq65q17IS3bboThLGEj
	rT2eUfGYJBG8pv2FjtS47fR63Yl/WC+haUOYrDR+YD5vgyzAEibaRCigXOSo4qvZ
	FgkBuDUI6QbBPPNVOmv1cRtzgN/3sT+J4J0J+XAohMfOTMvHPjrjDqZKXpZqxLmp
	7YXCAu7GXy3vxsd9Kg/qo96N3hYjVZnZRC1/R5gKeeAxa0pbmZab70271tDkqjU7
	AU0C/s6oBdsaUaa5eNG8ycBgBiiRIga0xkwNVEMcjgvWahdLFAMnrZ5RjCufGcCo
	jQ/Rfr6cEgB7R1o+dVhNNoeIPa5+b5vbDN32Utq2m8SDTg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id aGwnB5ttcOzw; Tue, 24 Sep 2024 19:52:06 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XCr9L2CpczlgTWG;
	Tue, 24 Sep 2024 19:52:06 +0000 (UTC)
Message-ID: <8bb504f5-9ed6-4fc0-bea0-f0561164f70f@acm.org>
Date: Tue, 24 Sep 2024 12:52:05 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] scsi: ufs: Zero utp_upiu_req at the beginning of each
 command
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240921062306.56019-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240921062306.56019-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/24 11:23 PM, Avri Altman wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 8ea5a82503a9..9187cf5c949c 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2761,7 +2761,6 @@ void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u8 upiu_flags)
>   	ucd_req_ptr->sc.exp_data_transfer_len = cpu_to_be32(cmd->sdb.length);
>   
>   	cdb_len = min_t(unsigned short, cmd->cmd_len, UFS_CDB_SIZE);
> -	memset(ucd_req_ptr->sc.cdb, 0, UFS_CDB_SIZE);
>   	memcpy(ucd_req_ptr->sc.cdb, cmd->cmnd, cdb_len);
>   
>   	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
> @@ -2864,6 +2863,26 @@ static void ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>   	ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
>   }
>   
> +static void __ufshcd_setup_cmd(struct ufshcd_lrb *lrbp, struct scsi_cmnd *cmd, u8 lun, int tag)
> +{
> +	memset(lrbp->ucd_req_ptr, 0, sizeof(*lrbp->ucd_req_ptr));
> +
> +	lrbp->cmd = cmd;
> +	lrbp->task_tag = tag;
> +	lrbp->lun = lun;
> +	ufshcd_prepare_lrbp_crypto(cmd ? scsi_cmd_to_rq(cmd) : NULL, lrbp);
> +}
> +
> +static void ufshcd_setup_scsi_cmd(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
> +				  struct scsi_cmnd *cmd, u8 lun, int tag)
> +{
> +	__ufshcd_setup_cmd(lrbp, cmd, lun, tag);
> +	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba);
> +	lrbp->req_abort_skip = false;
> +
> +	ufshcd_comp_scsi_upiu(hba, lrbp);
> +}
> +
>   /**
>    * ufshcd_upiu_wlun_to_scsi_wlun - maps UPIU W-LUN id to SCSI W-LUN ID
>    * @upiu_wlun_id: UPIU W-LUN id
> @@ -2997,16 +3016,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>   	ufshcd_hold(hba);
>   
>   	lrbp = &hba->lrb[tag];
> -	lrbp->cmd = cmd;
> -	lrbp->task_tag = tag;
> -	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
> -	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba);
>   
> -	ufshcd_prepare_lrbp_crypto(scsi_cmd_to_rq(cmd), lrbp);
> -
> -	lrbp->req_abort_skip = false;
> -
> -	ufshcd_comp_scsi_upiu(hba, lrbp);
> +	ufshcd_setup_scsi_cmd(hba, lrbp, cmd, ufshcd_scsi_to_upiu_lun(cmd->device->lun), tag);
>   
>   	err = ufshcd_map_sg(hba, lrbp);
>   	if (err) {
> @@ -3034,11 +3045,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>   static void ufshcd_setup_dev_cmd(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
>   			     enum dev_cmd_type cmd_type, u8 lun, int tag)
>   {
> -	lrbp->cmd = NULL;
> -	lrbp->task_tag = tag;
> -	lrbp->lun = lun;
> +	__ufshcd_setup_cmd(lrbp, NULL, lun, tag);
>   	lrbp->intr_cmd = true; /* No interrupt aggregation */
> -	ufshcd_prepare_lrbp_crypto(NULL, lrbp);
>   	hba->dev_cmd.type = cmd_type;
>   }
>   

This should have been two patches: one patch that introduces the
ufshcd_setup_scsi_cmd() function and a second patch that adds the code
for zeroing the UPIU header. Anyway, I'm fine with this patch.

Bart.
