Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A3F2EA75A;
	Wed, 18 Jun 2025 15:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750261294; cv=none; b=BEH8sN8nEOIbRjRDfCYvoiIpBt1jQFoqGMsFOY3ZfyNtrHbxmzSC/O2tKWbq8Wt3wAkFxP8bTXsI6dLTN8lEt7FLgw1QoLoPC7cqqTl5lngHWqKUoyrGA47002RMw9bIfM7YrprTu7356dHbqry7wbV74TGXxFVd2QObsOdp5Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750261294; c=relaxed/simple;
	bh=hdG/zwIsCWZkIONkfDvkdDcnRyFUeW/tA0YCLoutMGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KNMrj2HQAe9bRBvyAvYuMqY65FY0gLwM9wkkMYPvJbyvAgD2Rnywj6pEYcfKu/6p2k2OSHH3O9Xs7gFs7Iccrd6haoUW5C47wCYqTqt3o1aLBD5CyQlvsE9oVskVKNjmqwdEE67j2DmRQsQT+K8GMSJZF5i7L1WLNHUZlS0npmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3I4PQ/+s; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3I4PQ/+s"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bMnyz5gRjzm0gc4;
	Wed, 18 Jun 2025 15:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1750261289; x=1752853290; bh=nmFeV9PGFxpQa4XmHKHPSEoT
	jrYc8+35f2/sKc3/eFE=; b=3I4PQ/+sdK4kxjiWnEnRbo2Yax0zJm9AA4D66Rbr
	L0ixVIFNgvLlPf7/e1xi92lO2XTbWT5wUgtJHQODdV27y0PA5SUTwxoZn821ZEtR
	GFS1etli5Q+ccS5yQAvlXBU4NYBjx1wh6Ph4mH+EJKjdkqm8KI1zHvVZQY/iRdK5
	RTweY9bbjwcVYXesVdVXd+JkJOZXMxNEnwtrH+zcPy723Q+MhdNSsrUvm32TP8KD
	UhxrmNkQtam3kqG8p0EaWSwNJG3U54TnCvC7Bqtpg13dfZvtCmi9SqrbLpXZxcMa
	pJs6oHdo93+npxbXgkTlI7xnVk6p1QezyGo5Wg9ctsOhtg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id McMx0C33U6so; Wed, 18 Jun 2025 15:41:29 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bMnyn11NVzm0gc6;
	Wed, 18 Jun 2025 15:41:20 +0000 (UTC)
Message-ID: <6e088a4a-2665-472a-ac44-a645d17b2e99@acm.org>
Date: Wed, 18 Jun 2025 08:41:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: Fix clk scaling to be conditional in
 reset and restore
To: Anvith Dosapati <anvithdosapati@google.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
 Subhash Jadavani <subhashj@codeaurora.org>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, manugautam@google.com,
 vamshigajjela@google.com, stable@vger.kernel.org
References: <20250616085734.2133581-1-anvithdosapati@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250616085734.2133581-1-anvithdosapati@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/16/25 1:57 AM, Anvith Dosapati wrote:
> From: anvithdosapati <anvithdosapati@google.com>
> 
> In ufshcd_host_reset_and_restore, scale up clocks only when clock
> scaling is supported. Without this change cpu latency is voted for 0
> (ufshcd_pm_qos_update) during resume unconditionally.
> 
> Signed-off-by: anvithdosapati <anvithdosapati@google.com>
> Fixes: a3cd5ec55f6c7 ("scsi: ufs: add load based scaling of UFS gear")
> Cc: stable@vger.kernel.org
> ---
> v2:
> - Update commit message
> - Add Fixes and Cc stable
> 
>   drivers/ufs/core/ufshcd.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 4410e7d93b7d..fac381ea2b3a 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -7802,7 +7802,8 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
>   	hba->silence_err_logs = false;
>   
>   	/* scale up clocks to max frequency before full reinitialization */
> -	ufshcd_scale_clks(hba, ULONG_MAX, true);
> +	if (ufshcd_is_clkscaling_supported(hba))
> +		ufshcd_scale_clks(hba, ULONG_MAX, true);
>   
>   	err = ufshcd_hba_enable(hba);
>   

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
