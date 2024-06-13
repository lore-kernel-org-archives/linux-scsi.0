Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B99137911;
	Thu, 13 Jun 2024 06:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718261508; cv=none; b=ZUn3LZNHQbIQijFNuMctWeNIlqVMtQ6M1Uz321e55Fqgop6Kw2UdphpcxD9xV9DaJUavV0h89bjrCAZqySJ3lU+IhSXsxjq46+M/4OzzSxm8lkVoSEcqGMXdl9OBqZBt+2Ssq8jAkYZSoJJms6V8aHys/CqRSUSU0zF1wGm41JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718261508; c=relaxed/simple;
	bh=LvAer61IVH3wkuY3o1V+TCBKGzSLg//rzxfuqvW7yD4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HtNXTyxOIMIPr+1XwaCWIhu1lRGmgdGuyXD1+heAi2O0ly3TWlJEoaOblchVqihVd1y9+ureZnKO7ZPfwU18GjN0idCTKKPOMIBasLE6DRuhXz417pf/6asdm7efN0Jh5cyXdTkMq7m38zMC18Fko4OehKP8d2yTnmo+c9qy5M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: ee3d0b30294c11ef9305a59a3cc225df-20240613
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:74a01a1e-22e2-4f46-b7a0-1fcbd41cdafc,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:5
X-CID-INFO: VERSION:1.1.38,REQID:74a01a1e-22e2-4f46-b7a0-1fcbd41cdafc,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:-15,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-META: VersionHash:82c5f88,CLOUDID:67dda018e55f71979f6b6a6fb68dcbf9,BulkI
	D:240613141932DQLUDI5I,BulkQuantity:1,Recheck:0,SF:17|19|44|64|66|24|102,T
	C:nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:41,QS:nil,BEC:nil,
	COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_FSI,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-UUID: ee3d0b30294c11ef9305a59a3cc225df-20240613
Received: from node2.com.cn [(39.156.73.10)] by mailgw.kylinos.cn
	(envelope-from <mengfanhui@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 586363061; Thu, 13 Jun 2024 14:19:46 +0800
Received: from node2.com.cn (localhost [127.0.0.1])
	by node2.com.cn (NSMail) with SMTP id 018F6B80758A;
	Thu, 13 Jun 2024 14:19:46 +0800 (CST)
X-ns-mid: postfix-666A8F81-83225835
Received: from [172.30.60.81] (unknown [172.30.60.81])
	by node2.com.cn (NSMail) with ESMTPA id 4DC5AB80758A;
	Thu, 13 Jun 2024 06:19:45 +0000 (UTC)
Message-ID: <c0ed2c60-47b9-4853-a164-8e66016e49d3@kylinos.cn>
Date: Thu, 13 Jun 2024 14:19:44 +0800
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
Content-Transfer-Encoding: quoted-printable

Can someone help review it? Thank you!

=E5=9C=A8 2024/5/30 17:45, mengfanhui =E5=86=99=E9=81=93:
> If DCMD timeout not handled, the next interaction between the driver an=
d firmware will still
> result in DCMD timeout, which may cause system crashes or hang up
>=20
> This patch will do proper error handling for DCMD command
> for Fusion adapters:
>=20
> 1. What action needs to be taken in case of DCMD timeout is decided by
> function dcmd_timeout_ocr_possible().  DCMD timeout causing OCR is
> applicable to the following situation:
>     INITIATE_OCR
>     KILL_ADAPTER
>     IGNORE_TIMEOUT
>=20
> 2. If those DCMDs fail, driver bails out.
>=20
> Error log:
> [ 201.689759] megaraid_sas 0001:05:00.0: megasas_sync_pd_seq_num DCMD t=
imed out, continue without JBOD sequence map
> [ 242.649061] [] megasas_init+0x114/0x4000 [megaraid_sas]
> [ 363.481009] [] megasas_issue_blocked_cmd+0x1d8/0x268 [megaraid_sas]
> [ 363.481159] [] megasas_get_pd_list+0x548/0x688 [megaraid_sas]
> [ 363.481309] [] megasas_init_fw+0xb38/0x1104 [megaraid_sas]
> [ 363.481459] [] megasas_probe_one+0x1f4/0x5c4 [megaraid_sas]
> [ 363.482419] [] megasas_init+0x114/0x4000 [megaraid_sas]
> [ 381.912298] megaraid_sas 0001:05:00.0: DCMD(opcode: 0x2010100) is tim=
ed out, func:megasas_issue_blocked_cmd
> [ 381.912979] megaraid_sas 0001:05:00.0: Ignore DCMD timeout: megasas_g=
et_pd_list 4727
> [ 484.313526] [] megasas_init+0x114/0x4000 [megaraid_sas]
> [ 562.136294] megaraid_sas 0001:05:00.0: DCMD(opcode: 0x3010100) is tim=
ed out, func:megasas_issue_blocked_cmd
> [ 562.137074] megaraid_sas 0001:05:00.0: Ignore DCMD timeout: megasas_l=
d_list_query 4973
> [ 562.137081] megaraid_sas 0001:05:00.0: failed to get LD list
> [ 562.137425] megaraid_sas 0001:05:00.0: megasas_init_fw: megasas_get_d=
evice_list failed
> [ 562.137767] megaraid_sas 0001:05:00.0: megasas_disable_intr_fusion is=
 called outbound_intr_mask:0x40000009
> [ 562.139232] megaraid_sas 0001:05:00.0: Failed from megasas_init_fw 65=
72
>=20
> Co-developed-by: Jackie Liu <liuyun01@kylinos.cn>
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> Signed-off-by: mengfanhui <mengfanhui@kylinos.cn>
> Suggested-by: Geliang Tang <geliang@kernel.org>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |  1 +
>  drivers/scsi/megaraid/megaraid_sas_base.c   |  4 +-
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 71 +++++++++++++++++----
>  3 files changed, 62 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megara=
id/megaraid_sas.h
> index 5680c6cdb221..91570c5e8456 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -2760,5 +2760,6 @@ void megasas_exit_debugfs(void);
>  void megasas_setup_debugfs(struct megasas_instance *instance);
>  void megasas_destroy_debugfs(struct megasas_instance *instance);
>  int megasas_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_nu=
m);
> +int dcmd_timeout_ocr_possible(struct megasas_instance *instance);
> =20
>  #endif				/*LSI_MEGARAID_SAS_H */
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/m=
egaraid/megaraid_sas_base.c
> index 170b38f04655..ba8061ea2078 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -4518,8 +4518,8 @@ int megasas_alloc_cmds(struct megasas_instance *i=
nstance)
>   * Return 0 for only Fusion adapter, if driver load/unload is not in p=
rogress
>   * or FW is not under OCR.
>   */
> -inline int
> -dcmd_timeout_ocr_possible(struct megasas_instance *instance) {
> +int dcmd_timeout_ocr_possible(struct megasas_instance *instance)
> +{
> =20
>  	if (instance->adapter_type =3D=3D MFI_SERIES)
>  		return KILL_ADAPTER;
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi=
/megaraid/megaraid_sas_fusion.c
> index 6c1fb8149553..f0aeb1ee83a2 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -1363,17 +1363,42 @@ megasas_sync_pd_seq_num(struct megasas_instance=
 *instance, bool pend) {
>  			"driver supports max %d JBOD, but FW reports %d\n",
>  			MAX_PHYSICAL_DEVICES, le32_to_cpu(pd_sync->count));
>  		ret =3D -EINVAL;
> +		goto out;
>  	}
> =20
> -	if (ret =3D=3D DCMD_TIMEOUT)
> -		dev_warn(&instance->pdev->dev,
> -			 "%s DCMD timed out, continue without JBOD sequence map\n",
> -			 __func__);
> -
> -	if (ret =3D=3D DCMD_SUCCESS)
> +	switch (ret) {
> +	case DCMD_SUCCESS:
>  		instance->pd_seq_map_id++;
> +		break;
> +	case DCMD_TIMEOUT:
> +		switch (dcmd_timeout_ocr_possible(instance)) {
> +		case INITIATE_OCR:
> +			cmd->flags |=3D DRV_DCMD_SKIP_REFIRE;
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
> +	if (ret !=3D DCMD_TIMEOUT)
> +		megasas_return_cmd(instance, cmd);
> =20
> -	megasas_return_cmd(instance, cmd);
>  	return ret;
>  }
> =20
> @@ -1449,12 +1474,34 @@ megasas_get_ld_map_info(struct megasas_instance=
 *instance)
>  	else
>  		ret =3D megasas_issue_polled(instance, cmd);
> =20
> -	if (ret =3D=3D DCMD_TIMEOUT)
> -		dev_warn(&instance->pdev->dev,
> -			 "%s DCMD timed out, RAID map is disabled\n",
> -			 __func__);
> +	switch (ret) {
> +	case DCMD_TIMEOUT:
> +		switch (dcmd_timeout_ocr_possible(instance)) {
> +		case INITIATE_OCR:
> +			cmd->flags |=3D DRV_DCMD_SKIP_REFIRE;
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
> =20
> -	megasas_return_cmd(instance, cmd);
> +	if (ret !=3D DCMD_TIMEOUT)
> +		megasas_return_cmd(instance, cmd);
> =20
>  	return ret;
>  }
