Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2A813C68E;
	Mon,  9 Sep 2024 16:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725899068; cv=none; b=uqyHx5O+etrw+Pb94X1ayZ8YTFIWERnSC401vvS0zDz50Z2yWqCynPEm8l76aFrSihZAAf/+6tHY7HeKhRo5ehgrkk3WRVRxjDgAetL7MBabXOytK3huO6gau+StfUAbScpBnKMMVwkMC3LcoLNOi+mp3BTuUPMKlhJUaMVsyWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725899068; c=relaxed/simple;
	bh=pSLJJubqHBSfkQEqFFeyLAUGQucYkuyC1/6eCu7BKEE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QwmUt2ppx8nADIzjEvSXEAU3Cis88ccsopXO3J6+71f0Cz3oWQXQ0xX4sPLyUVxz7cDJA//Zj0hgXVFutKHcapKd+PWHQ+IBHWzwi6hmedtCGjoGryOPeh/YbWmZfGH92HuwpCKMA7uuzTbRNFpRaAVcTMIKHN9ONCYdEOFpHHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rR++cUl2; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rR++cUl2"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X2XGW6KRsz6ClbFf;
	Mon,  9 Sep 2024 16:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1725899049; x=1728491050; bh=v/bF203iU7vUDeGns7N4RvzO
	gpMdF7ZklfpBuMpeGbw=; b=rR++cUl2hcZr6HeuFF9vBBnPe1y41T6XsOWgcOwK
	yGzrUUoil/PdVoDo7bgW/qpdkM8PYi3oZkMc6qtMS96c9hh61qEY0/A2Lssu4WtB
	MJJa+XnjKDRHW0z2XBZy9UtWUPck5QcCBrVmMHXzo/zqPGseg27IZIMBpq9CI5uw
	sHokbw/MbClnMEbiSWXnkYDWdSY2wjx6gP9AxIYYSU75a1Sei6i/qx/3HlPurTxV
	0H3LvSmhd6Vw1DBkZyTIqSBO2/nxH+zXUcv8LEEmU9hS2LCWoJ7ftImR8PWGZ3hr
	E+LvsB+dUuhP9BYuvKQ9N9Wcedw5/RIsqiZ8RbnpN7av9w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kQvfdU8MHhMJ; Mon,  9 Sep 2024 16:24:09 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X2XGD5F0tz6ClbFZ;
	Mon,  9 Sep 2024 16:24:04 +0000 (UTC)
Message-ID: <edbabf35-8111-4672-b14c-52d76ed46fd9@acm.org>
Date: Mon, 9 Sep 2024 09:24:02 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] ufs: core: fix the issue of ICU failure
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com,
 quic_nguyenb@quicinc.com, stable@vger.kernel.org
References: <20240909082100.24019-1-peter.wang@mediatek.com>
 <20240909082100.24019-2-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240909082100.24019-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/24 1:20 AM, peter.wang@mediatek.com wrote:
> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
> index 5891cdacd0b3..3903947dbed1 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -539,7 +539,7 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
>   	struct scsi_cmnd *cmd = lrbp->cmd;
>   	struct ufs_hw_queue *hwq;
>   	void __iomem *reg, *opr_sqd_base;
> -	u32 nexus, id, val;
> +	u32 nexus, id, val, rtc;
>   	int err;
>   
>   	if (hba->quirks & UFSHCD_QUIRK_MCQ_BROKEN_RTC)
> @@ -569,17 +569,18 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
>   	opr_sqd_base = mcq_opr_base(hba, OPR_SQD, id);
>   	writel(nexus, opr_sqd_base + REG_SQCTI);
>   
> -	/* SQRTCy.ICU = 1 */
> -	writel(SQ_ICU, opr_sqd_base + REG_SQRTC);
> +	/* Initiate Cleanup */
> +	writel(readl(opr_sqd_base + REG_SQRTC) | SQ_ICU,
> +		opr_sqd_base + REG_SQRTC);
>   
>   	/* Poll SQRTSy.CUS = 1. Return result from SQRTSy.RTC */
>   	reg = opr_sqd_base + REG_SQRTS;
>   	err = read_poll_timeout(readl, val, val & SQ_CUS, 20,
>   				MCQ_POLL_US, false, reg);
> -	if (err)
> -		dev_err(hba->dev, "%s: failed. hwq=%d, tag=%d err=%ld\n",
> -			__func__, id, task_tag,
> -			FIELD_GET(SQ_ICU_ERR_CODE_MASK, readl(reg)));
> +	rtc = FIELD_GET(SQ_ICU_ERR_CODE_MASK, readl(reg));
> +	if (err || rtc)
> +		dev_err(hba->dev, "%s: failed. hwq=%d, tag=%d err=%d RTC=%d\n",
> +			__func__, id, task_tag, err, rtc);
>   
>   	if (ufshcd_mcq_sq_start(hba, hwq))
>   		err = -ETIMEDOUT;

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
