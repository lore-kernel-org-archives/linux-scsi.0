Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DBA2BE026;
	Tue, 16 Jun 2026 13:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781616727; cv=none; b=d55s5/PLPMHMrFzhNMium4EncEWCJbKhph5+g89J9SoUbXM12N8RarkxMMuG3k2m9KnXxkbQVWssTGKFH9bsWO4hq/SdbjOraFCV/9gYPUt55qzgKhm9d7H4XyuxwyDPK9UMaQyaYEa+rGZSKuo+5mxyEOUa4nQNL9DtM0BgqG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781616727; c=relaxed/simple;
	bh=jxOG0NzHsauXEs7z3nbLWa7qkGgHAS0glsQ0ME3e5cE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XwNb2mVf7tKMrJyfwzMOl4u1v6KDZX0o3HA4I/+8m5mamqEsoSY2VEhw0HV3+2/5zCAu1HFrfiG06hnwK9b2GN7uULQ7uF6usTnUihf8U2MCv8Mj2ZZYtb92OHlItyBpTuBAvglj2NwVvHJyWZLp5s20O7AA4PUcCjMl0dNCrA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2IBggzwF; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2IBggzwF"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gfnw602whz1XM6JB;
	Tue, 16 Jun 2026 13:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1781616718; x=1784208719; bh=4gM/vvwTYlyUiY3PTYetGs4N
	aK0ezXlkJGM5eDLgyEs=; b=2IBggzwFoPC2GoHdaM7+yEKWJWQXnDXJubqMh1yH
	pXP631Rw2XASUDPwBu41A8YbuOWXrdydyoBUJO04ihfRIF/57sIrtos8PY1tzqu5
	ldbtrS8VJgdBotVZCYG89i0xVa5mih/v5I4e+bZocWSy9p8bxA2zA5wPem+rC1mq
	4rP9SdfnEBdkMPQYgMjK8dFOOZtkK7Eb0LYlSBvJQNhnHcxd5uDtua9MgVP74qkS
	PQvtI265oGEMuB+CZsH1QyLzI1l4RBBLM1vc0vG8+DKZeMfrPT7D8jYDYiVGx671
	F0n6+sBxx6NRyctc4ZoYgJsho065F0cUrVqPtHsrq3q1uA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XuVc9N0bw-Vg; Tue, 16 Jun 2026 13:31:58 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gfnvv0Z7Rz1XM31H;
	Tue, 16 Jun 2026 13:31:54 +0000 (UTC)
Message-ID: <ab8de800-0e16-44db-9dd8-377f92b3d408@acm.org>
Date: Tue, 16 Jun 2026 06:31:48 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Avoid possible memory reclaim deadlock
 in TX EQTR context
To: Can Guo <can.guo@oss.qualcomm.com>, beanhuo@micron.com,
 peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:ARM/QUALCOMM MAILING LIST" <linux-arm-msm@vger.kernel.org>
References: <20260616090654.421850-1-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260616090654.421850-1-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/16/26 2:06 AM, Can Guo wrote:
> diff --git a/drivers/ufs/core/ufs-txeq.c b/drivers/ufs/core/ufs-txeq.c
> index 4b264adfdf49..3a2fb5329d27 100644
> --- a/drivers/ufs/core/ufs-txeq.c
> +++ b/drivers/ufs/core/ufs-txeq.c
> @@ -1059,7 +1059,7 @@ static int __ufshcd_tx_eqtr(struct ufs_hba *hba,
>   			    struct ufs_pa_layer_attr *pwr_mode)
>   {
>   	struct ufshcd_tx_eqtr_data *eqtr_data  __free(kfree) =
> -		kzalloc(sizeof(*eqtr_data), GFP_KERNEL);
> +		kzalloc(sizeof(*eqtr_data), GFP_NOIO);
>   	struct tx_eqtr_iter h_iter = {};
>   	struct tx_eqtr_iter d_iter = {};
>   	u32 gear = pwr_mode->gear_tx;
> @@ -1217,7 +1217,7 @@ static int ufshcd_tx_eqtr(struct ufs_hba *hba,
>   	if (!params->eqtr_record) {
>   		params->eqtr_record = devm_kzalloc(hba->dev,
>   						   sizeof(*params->eqtr_record),
> -						   GFP_KERNEL);
> +						   GFP_NOIO);
>   		if (!params->eqtr_record)
>   			return -ENOMEM;
>   	}
> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
> index c084ccc72523..e7f104987c6a 100644
> --- a/drivers/ufs/host/ufs-qcom.c
> +++ b/drivers/ufs/host/ufs-qcom.c
> @@ -2760,7 +2760,7 @@ static int ufs_qcom_get_rx_fom(struct ufs_hba *hba,
>   			       struct tx_eqtr_iter *d_iter)
>   {
>   	struct ufshcd_tx_eq_params *params __free(kfree) =
> -		kzalloc(sizeof(*params), GFP_KERNEL);
> +		kzalloc(sizeof(*params), GFP_NOIO);
>   	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
>   	struct ufs_pa_layer_attr old_pwr_info;
>   	u32 fom[PA_MAXDATALANES] = { 0 };

Modifying individual memory allocation calls is error prone. The next
person who modifies this code may not be aware of this conversation and
might reintroduce a GFP_KERNEL allocation in the TX equalization code.

Please use memalloc_noio_save() and memalloc_noio_restore() instead of
changing GFP_KERNEL into GFP_NOIO. Additionally, please add a comment
above the memalloc_noio_save() call that explains why it is necessary.
See also https://docs.kernel.org/core-api/gfp_mask-from-fs-io.html.

Thanks,

Bart.
