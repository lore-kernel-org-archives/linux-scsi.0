Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050EE15ADB4;
	Thu, 17 Apr 2025 21:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744925759; cv=none; b=jyjFRp9UHnP8UWDCesX8Ck4QA0Thtv6FltWIATvggZUZLyGxSq5Me9pkS/ozMs5p73ZJFHxjPKGBotnLLz3psyfaxDDdl6tT/AzVPHEbml9/DTDU53Cn/0Atdwu+A7+NLwmWgif/7INsLgUEGn7eidPOBUBXj5owUywctuSLu4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744925759; c=relaxed/simple;
	bh=MyiQkslkXnkL/9CWbGJIC+jcYPU7Z1g6zBpSblxDa28=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ur5qwAXAuAS4vml7jw+ZrDJEr2Z3kN4qUhx101N6WaY2tuvivAmG+XSC+tZyoq+z3saE10HkXvY6BtqLrHoaopovSpg0R/4S9VPFc3d/BJi+vrTBPQDOyAY10V6kemhzqXHO84h3pSUMpDkLA8n+JpWzOMbrGO+VCu6ZtnGndrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nvcKf8VD; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nvcKf8VD"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZdrmQ6CnVzlgqyG;
	Thu, 17 Apr 2025 21:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1744925747; x=1747517748; bh=JDCrab6QUmlWvGRIySBTmurE
	y7/IxjOZr4B2PNlCkC0=; b=nvcKf8VDAHmRMNQdFvXN/jtQUI4SCE9o+ZEFFEPg
	nRrKG0veG254TV7A9K2rBi4UZNFtIPXnccYO01vTXjPudbxuoQp643avEl9CMrdc
	vnx1qthIrtVc1tg9c1eMPSJohfeW4joceuNa7/zLgWt+I5rDP+t25kZWBpnwYvq3
	wic9SC0km3Lhi/k8lc1D/EKM5tM8eeae+yDk38caWcKEPjbFJDY1k+DU5oYti2sT
	xAcUN50ybEIvhYK5wDYxL4eIgJyG1+dVGAPNzgi61wFwbokOu7W75J1AqO/6dRtX
	iNVJr9LKZ1jNZ4ZeyI90Bj1hEcrSAVAIuADxGFmHdXlrNw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id r-wPwt3aOQC1; Thu, 17 Apr 2025 21:35:47 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4Zdrm74Jsjzlgqxf;
	Thu, 17 Apr 2025 21:35:34 +0000 (UTC)
Message-ID: <17781804-d36f-41c2-a858-1edf905ca8ac@acm.org>
Date: Thu, 17 Apr 2025 14:35:33 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Add a trace function calling when
 uic command error occurs
To: DooHyun Hwang <dh0421.hwang@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 peter.wang@mediatek.com, manivannan.sadhasivam@linaro.org,
 quic_mnaresh@quicinc.com
Cc: grant.jung@samsung.com, jt77.jang@samsung.com, junwoo80.lee@samsung.com,
 jangsub.yi@samsung.com, sh043.lee@samsung.com, cw9316.lee@samsung.com,
 sh8267.baek@samsung.com, wkon.kim@samsung.com
References: <20250417023405.6954-1-dh0421.hwang@samsung.com>
 <CGME20250417023419epcas1p343060855c4470f8056116a207a584956@epcas1p3.samsung.com>
 <20250417023405.6954-3-dh0421.hwang@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250417023405.6954-3-dh0421.hwang@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 7:34 PM, DooHyun Hwang wrote:
> When a uic command error occurs, there is no trace function calling.
> Therefore, trace function calls are added when a uic command error happens.
> 
> Signed-off-by: DooHyun Hwang <dh0421.hwang@samsung.com>
> ---
>   drivers/ufs/core/ufshcd.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index ab98acd982b5..baac1ae94efc 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2534,6 +2534,9 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
>   	hba->active_uic_cmd = NULL;
>   	spin_unlock_irqrestore(hba->host->host_lock, flags);
>   
> +	if (ret)
> +		ufshcd_add_uic_command_trace(hba, uic_cmd, UFS_CMD_ERR);
> +
>   	return ret;
>   }
>   
> @@ -4306,6 +4309,8 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
>   	}
>   out:
>   	if (ret) {
> +		ufshcd_add_uic_command_trace(hba, hba->active_uic_cmd,
> +					     UFS_CMD_ERR);
>   		ufshcd_print_host_state(hba);
>   		ufshcd_print_pwr_info(hba);
>   		ufshcd_print_evt_hist(hba);

Shouldn't the value of 'ret' be included in the UFS_CMD_ERR trace output?

Thanks,

Bart.
