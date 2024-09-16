Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3F85258;
	Mon, 16 Sep 2024 22:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726525215; cv=none; b=BylIabZM76fWUm7Mfi2pYFmJ7I8QgSeBb8jaLe10tqbww0LWNA/DXAuPmbC3qlEkOx0KrfJYyrg71HvGIc+Zy27WDMj05ehvhMm/X0/sBYGLF793BIo1UOwmd6IiJDVBo6VCujwEgPsoJ8OmcsCmTwnPo/i89i7zmGQw+BEx26E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726525215; c=relaxed/simple;
	bh=+InVEWE0Mpd4J3Rz2f4jDb3qmxPIzpo4f+FAxdFGD7o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HSm/ojM9CpmVZb0eVUlG8NTnTvjqHpuMazpb6p+6ulvaMmqoraHak/PecKaEdQJ8xCFUsh2RDx+zGZuJ7NPZabwK7hiP3i9OVtPDavidV06poAg6+VhghXT71EPyqTmqDufNo2HJGOQl7jqBZ1e9bUQU3W+Atc7PfWMX97sFSjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0IdQfl72; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0IdQfl72"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4X6zqx1lwGzlgVnY;
	Mon, 16 Sep 2024 22:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726525210; x=1729117211; bh=+j/qcWzBpYZvumV7JP65E988
	K3KeirTASQ77gkik3O0=; b=0IdQfl72nz7L3AEJ9v0Ln1oaBOFZfDI44AOQWFfl
	y/T5pT5fACRAlRBUMqn4nlAAbYY165TT+q8ZCTslpxUGFkobAmol3icNgmIYS6YV
	1BWY1jQIEjiZQI2UFIyLIhydbm6DTM3PHw+acl9g63SaDvhgM8nGNC+NFZKQROzX
	iPtJyJ/zOuLXiZ3qJynyeMRyyWMJlD4Cl0UuDc/YXOXWBg/P05tfjvSUbTWgJvYl
	UmFIdOgCJ9ZyU+le1MpcHIAgNdOLAJu6AEWapHQP1Wr9J4j14dXYgVbO6no9z0wy
	O8d+GHdYXQTlOymjvf9LLg0aBbcHJfUvvmNc+dM9areGiA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ee9mvfVONJYn; Mon, 16 Sep 2024 22:20:10 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4X6zqs62hlzlgTWR;
	Mon, 16 Sep 2024 22:20:09 +0000 (UTC)
Message-ID: <83fed524-a235-493c-81f6-16736027eeb1@acm.org>
Date: Mon, 16 Sep 2024 15:20:07 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: Zero utp_upiu_req at the beginning of each
 command
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240915074842.4111336-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240915074842.4111336-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/15/24 12:48 AM, Avri Altman wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 8ea5a82503a9..1f6575afc1c5 100644
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
> @@ -2834,6 +2833,8 @@ static int ufshcd_compose_devman_upiu(struct ufs_hba *hba,
>   	u8 upiu_flags;
>   	int ret = 0;
>   
> +	memset(lrbp->ucd_req_ptr, 0, sizeof(*lrbp->ucd_req_ptr));
> +
>   	ufshcd_prepare_req_desc_hdr(hba, lrbp, &upiu_flags, DMA_NONE, 0);
>   
>   	if (hba->dev_cmd.type == DEV_CMD_TYPE_QUERY)
> @@ -2858,6 +2859,8 @@ static void ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>   	unsigned int ioprio_class = IOPRIO_PRIO_CLASS(req_get_ioprio(rq));
>   	u8 upiu_flags;
>   
> +	memset(lrbp->ucd_req_ptr, 0, sizeof(*lrbp->ucd_req_ptr));
> +
>   	ufshcd_prepare_req_desc_hdr(hba, lrbp, &upiu_flags, lrbp->cmd->sc_data_direction, 0);
>   	if (ioprio_class == IOPRIO_CLASS_RT)
>   		upiu_flags |= UPIU_CMD_FLAGS_CP;
> @@ -7165,6 +7168,8 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
>   
>   	ufshcd_setup_dev_cmd(hba, lrbp, cmd_type, 0, tag);
>   
> +	memset(lrbp->ucd_req_ptr, 0, sizeof(*lrbp->ucd_req_ptr));
> +
>   	ufshcd_prepare_req_desc_hdr(hba, lrbp, &upiu_flags, DMA_NONE, 0);
>   
>   	/* update the task tag in the request upiu */
> @@ -7317,6 +7322,8 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *r
>   
>   	ufshcd_setup_dev_cmd(hba, lrbp, DEV_CMD_TYPE_RPMB, UFS_UPIU_RPMB_WLUN, tag);
>   
> +	memset(lrbp->ucd_req_ptr, 0, sizeof(*lrbp->ucd_req_ptr));
> +
>   	ufshcd_prepare_req_desc_hdr(hba, lrbp, &upiu_flags, DMA_NONE, ehs);
>   
>   	/* update the task tag */

Something unfortunate about the above patch is that it spreads the
initialization of *lrbp->ucd_req_ptr over two functions. Wouldn't it be
better to have all the code that initializes *lrbp->ucd_req_ptr in the
same function, e.g. as in the untested patch below?

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8d90af6434da..9d826e5d610b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2770,13 +2770,14 @@ void ufshcd_prepare_utp_scsi_cmd_upiu(struct 
ufshcd_lrb *lrbp, u8 upiu_flags)
  		.task_tag = lrbp->task_tag,
  		.command_set_type = UPIU_COMMAND_SET_TYPE_SCSI,
  	};
+	memset(&ucd_req_ptr->header + 1, 0, sizeof(*ucd_req_ptr) -
+	       sizeof(ucd_req_ptr->header));

  	WARN_ON_ONCE(ucd_req_ptr->header.task_tag != lrbp->task_tag);

  	ucd_req_ptr->sc.exp_data_transfer_len = cpu_to_be32(cmd->sdb.length);

  	cdb_len = min_t(unsigned short, cmd->cmd_len, UFS_CDB_SIZE);
-	memset(ucd_req_ptr->sc.cdb, 0, UFS_CDB_SIZE);
  	memcpy(ucd_req_ptr->sc.cdb, cmd->cmnd, cdb_len);

  	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
@@ -2809,6 +2810,8 @@ static void 
ufshcd_prepare_utp_query_req_upiu(struct ufs_hba *hba,
  				cpu_to_be16(len) :
  				0,
  	};
+	memset(&ucd_req_ptr->header + 1, 0, sizeof(*ucd_req_ptr) -
+	       sizeof(ucd_req_ptr->header));

  	/* Copy the Query Request buffer as is */
  	memcpy(&ucd_req_ptr->qr, &query->request.upiu_req,
@@ -2825,12 +2828,12 @@ static inline void 
ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
  {
  	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;

-	memset(ucd_req_ptr, 0, sizeof(struct utp_upiu_req));
-
  	ucd_req_ptr->header = (struct utp_upiu_header){
  		.transaction_code = UPIU_TRANSACTION_NOP_OUT,
  		.task_tag = lrbp->task_tag,
  	};
+	memset(&ucd_req_ptr->header + 1, 0, sizeof(*ucd_req_ptr) -
+	       sizeof(ucd_req_ptr->header));

  	memset(lrbp->ucd_rsp_ptr, 0, sizeof(struct utp_upiu_rsp));
  }

Thanks,

Bart.
