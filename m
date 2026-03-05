Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D9E17B418;
	Thu,  5 Mar 2026 14:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772719245; cv=none; b=GwA07ojwmRyZf+BG4qyRYJ2Y580nsECaYo2c03C54hJSDzD/4+VANBf4LQM7ENlst4THRhqv+Y8TPQyRhpIzjd9BvBQlNLZxfhuwJSXlhmxKi7yOI+0hmxjhcc/6md8MxunneB2BVZ57QTBe93RcRTFtRTwWXEJnDzt6UP7juVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772719245; c=relaxed/simple;
	bh=pvoT2u9xSBN5iWvWvToYSwvlsbPWBOBUPaM8wspO4rI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N/KGV0vf7bmXlGPAhr4cw/HEtcksu0QjrVCIS22BhtV77f1gBFa0qqwGzER219saDy6i5SMXiR/jBzpA+871wwxCC9BLqITKL5dS3ICYwONQdh5eJwLW6UCdaPEIbuTRuFGoBYdKqg+97ju87QQ4yhW6/D9gOs1avbdH3z+/9mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=vCUFmwGO; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="vCUFmwGO"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fRWQg5b5vzlffv7;
	Thu,  5 Mar 2026 14:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772719239; x=1775311240; bh=PxEGUIvO7hvjKI/gZlPCvjTW
	X45P2ztH/REzBc8gb0w=; b=vCUFmwGOvGesT221HovjqAiCU7NJLbIWW+jzMnkC
	jPZYX3NQMcmdz7kIZCrxUnLJqNDwbzboRddwJ/R6m88SFtdA7w9fK45sCgJgqThQ
	V0EE9p2A+PblDrBBic9Bwh1l9GP+fTjQxN/sfMPU4ytnH+jSEzJn2I7isdN69lIs
	P26v98WrpOCvTfAgfBAuBTV/YF24MNwt38BOhcW/p9R7B/6ev1oEeoheAINyOqNg
	FDgzCYu/D9bz/7x17wDW0c5cJ8MylkzDC1poXvHUHHHZKsV6pHoi+nGPulSm7SSM
	nbKVfYzNeTsuYpaRRaUFXrQLYzVT4Maufno7+Y+r3777uQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6fZmJaSuKSJS; Thu,  5 Mar 2026 14:00:39 +0000 (UTC)
Received: from [192.168.132.187] (unknown [12.150.89.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fRWQX6mz6zlfvpG;
	Thu,  5 Mar 2026 14:00:36 +0000 (UTC)
Message-ID: <665d28a0-3759-4148-8055-4b0236645e5b@acm.org>
Date: Thu, 5 Mar 2026 08:00:35 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/11] scsi: ufs: core: Add debugfs entries for TX
 Equalization params
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 beanhuo@micron.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260304135313.413688-1-can.guo@oss.qualcomm.com>
 <20260304135313.413688-6-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260304135313.413688-6-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/26 7:53 AM, Can Guo wrote:
> +static int ufs_tx_eq_params_show(struct seq_file *s, void *data)
> +{
> +	struct ufs_hba *hba = hba_from_file(s->file);
> +	struct ufshcd_tx_eq_settings *settings;
> +	struct ufshcd_tx_eq_params *params;
> +	const char *file_name = s->file->f_path.dentry->d_name.name;
> +	u32 gear = (u32)(uintptr_t)s->file->f_inode->i_private;
> +	u32 rate = hba->pwr_info.hs_rate;
> +	u32 num_lanes;
> +	int lane;

Please order declarations from longest to shortest.

> +static int ufs_tx_eqtr_record_show(struct seq_file *s, void *data)
> +{
> +	struct ufs_hba *hba = hba_from_file(s->file);
> +	struct ufshcd_tx_eq_params *params;
> +	unsigned long preshoot_bitmap, deemphasis_bitmap;
> +	unsigned int preshoot, deemphasis;
> +	const char *file_name = s->file->f_path.dentry->d_name.name;
> +	u32 (*record)[TX_HS_NUM_PRESHOOT][TX_HS_NUM_DEEMPHASIS];
> +	u32 gear = (u32)(uintptr_t)s->file->f_inode->i_private;
> +	u32 rate = hba->pwr_info.hs_rate;
> +	u32 num_lanes;
> +	int lane;
> +	char name[32];

Also here, please order declarations from longest to shortest.

> +		snprintf(name, 32, "tx_eq_hs_gear%d", gear);

Please change "32" into "sizeof(name)" as is done elsewhere in the
Linux kernel.

Thanks,

Bart.
