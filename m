Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB5B28A2B3
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 17:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739467205; cv=none; b=E5OIE3W3b0vgepvmFXggp5Zpx2dKgg0f9C2miRePWABp+ah0EWn/mMV5dek9Js8cyUJXVU2Nyl5UfFgZJ9lSKLs0SsoMWUhASU9aDOtCoDtegCK/Rze68A1iheI9kQ4xDDxoRXNVmqKAoow+9mmT2AYYiAseKw5ip+qKdVxzvXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739467205; c=relaxed/simple;
	bh=3mgX5c3nGCa1fp0mm77KClkgptOzdlmwEvojCDeGo6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ci0cvXDRHt9bBWzzMXUFxFpKNVZLLwV7Uel3GCdo4Yp5j11+EtUxnwMocstgpguAaC+5LcBmy52hQidqAND+rSWMQa29D+AhpidEM27qLX33CF5WgNN2p6oErtvYjnOcxS8qq4GfACbRzYMOtrn8N4R8297aK34UT1qyRW3dLjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nPZJIv8g; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nPZJIv8g"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Yv24D6jyszlgTxf;
	Thu, 13 Feb 2025 17:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1739467188; x=1742059189; bh=izx9olkj/og783bsPzUi8osg
	MgxwmY/GXmYfAw+ZG+s=; b=nPZJIv8gAlsGA8QQ5RZJeFaWsmwS69BZPzdZkK93
	T5GVf/lPW7P+BSTVPA2dAEXrbQOXwmBRGnM8CB4rM4j79iKi3by0MhhcgPb/oNX2
	DWm/1TFu5tfcwCJTaPNz4udON0vlVYk7AtnUaL26CkusrWu/UniSY3UVbcZMNIUu
	7cuCMKv6S0NmP2L6Ci2M4XPI2dr8eSwe5r7O2QM6ssoezbRhTRk7bNxkE/mFFslj
	sGvacvVftlwE0c79tWyST7ef6+jj9ZbHOZWtHPJScbRSqLqoYmXd7SJF46Keltbz
	MAZG9OCphMgaM+lthFy0t1h/TVyk6cMMHgndRK0PkQ1XcQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kQsvQ0A_wL77; Thu, 13 Feb 2025 17:19:48 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Yv23z25qdzlgTwj;
	Thu, 13 Feb 2025 17:19:42 +0000 (UTC)
Message-ID: <16f26ea9-69d6-4f2f-9adc-c576c288a2f5@acm.org>
Date: Thu, 13 Feb 2025 09:19:42 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: add hba parameter to trace events
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com, sutoshd@codeaurora.org
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250213113707.955255-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250213113707.955255-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/25 3:35 AM, peter.wang@mediatek.com wrote:
> diff --git a/drivers/ufs/core/ufs_trace.h b/drivers/ufs/core/ufs_trace.h
> index 84deca2b841d..2f79982846b6 100644
> --- a/drivers/ufs/core/ufs_trace.h
> +++ b/drivers/ufs/core/ufs_trace.h
> @@ -83,16 +83,18 @@ UFS_CMD_TRACE_TSF_TYPES
>   
>   TRACE_EVENT(ufshcd_clk_gating,
>   
> -	TP_PROTO(const char *dev_name, int state),
> +	TP_PROTO(struct ufs_hba *hba, int state),
>   
> -	TP_ARGS(dev_name, state),
> +	TP_ARGS(hba, state),
>   
>   	TP_STRUCT__entry(
> -		__string(dev_name, dev_name)
> +		__field(struct ufs_hba *, hba)
> +		__string(dev_name, dev_name(hba->dev))
>   		__field(int, state)
>   	),

Please reduce the size of the tracing entries by removing dev_name from 
TP_STRUCT__entry() and by replacing 'dev_name' with 'dev_name(hba->dev)'
in the TP_printk() calls.

Thanks,

Bart.
