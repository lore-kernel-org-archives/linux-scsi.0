Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E463168FC;
	Fri, 12 Sep 2025 16:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757694180; cv=none; b=kdpD3EuiQWRZB6kR/RO38eZ4+dKTsNTVbVUI8dCFSUmlHsZBEASdIM0kapYFj24gNQsH3ALsJbzP3wI00y8eGV+uoa/YW9jv30iaThipHC99eYSKULChpz1EskXx5GTqPN6EQyQfx5/zEo6aOJ9C+TU8zOkhXvLdOC2ExemnZUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757694180; c=relaxed/simple;
	bh=SMfCbfW/NmvBvuJmBRFQ226xjb/zCRx2xmPZCITywQg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S3ifs36BJUoM8BwafJnUsK/NriCpOGzDZCgp9Igj6PBsyj+VyuT2M4Q23xnOXWncXhpNIWC61RH3A5HMgRj8DgVIqtwn/aj/bxanMgPs6I+P2/fsThCsPuQvqmVw0LSmXLaKgtl4AUDhXnKe4pWgtMcRqjiMKiGVOLY8f+zv9Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=n25SYblR; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="n25SYblR"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cNfq5350szm0yVK;
	Fri, 12 Sep 2025 16:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757694173; x=1760286174; bh=AIYfdrXaDOZdsSxth4jnHlQ3
	5RQUiPJixCSQ7UpF92Y=; b=n25SYblRk43XetWmKUfDLmHs26np+FtcBwPSErZH
	crJkdk9Imy65U4tBTzBfAnbmlMhE0e3jB2sr8BE/enfWes3gfLx4yr5rtQwzRBPJ
	M7tVyCz9HtQYkb3LauxSJYFJM/DwRBWOtfOumkxFfXkTWe8A05rk3YbuiTtpVMfw
	bsxhVe6p7+k05x+BQuML74lkL+diJRUr2FzHKDKHYTUD1F2qQLrc+pKp2c6diq9x
	N5pmN/Dh3uTMyUr7c9Wkjd3ItDK6DARm4dGe1O7jE9VhMw2DRCtKxTR+n0vmpABp
	yZGRJnjUkyBKf16Pcw04hk2qxlX3SbgTGy+r6BOLEyI/9Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Poa3d1JfvX6k; Fri, 12 Sep 2025 16:22:53 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cNfpj67DCzm174x;
	Fri, 12 Sep 2025 16:22:37 +0000 (UTC)
Message-ID: <4b970683-bc36-4dc2-a404-e1440da83ae7@acm.org>
Date: Fri, 12 Sep 2025 09:22:35 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: Fix data race in CPU latency PM QoS
 request handling
To: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: peter.wang@mediatek.com, tanghuan@vivo.com, liu.song13@zte.com.cn,
 quic_nguyenb@quicinc.com, viro@zeniv.linux.org.uk, huobean@gmail.com,
 adrian.hunter@intel.com, can.guo@oss.qualcomm.com, ebiggers@kernel.org,
 neil.armstrong@linaro.org, angelogioacchino.delregno@collabora.com,
 quic_narepall@quicinc.com, quic_mnaresh@quicinc.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 nitin.rawat@oss.qualcomm.com, ziqi.chen@oss.qualcomm.com
References: <20250902074829.657343-1-zhongqiu.han@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250902074829.657343-1-zhongqiu.han@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/2/25 12:48 AM, Zhongqiu Han wrote:
> -	return sysfs_emit(buf, "%d\n", hba->pm_qos_enabled);
> +	return sysfs_emit(buf, "%d\n", READ_ONCE(hba->pm_qos_enabled));

Using READ_ONCE() here is inconsistent since none of the modifications
of hba->pm_qos_enabled use WRITE_ONCE(). Protecting hba->pm_qos_enabled
modifications with a mutex is not sufficient since the above read of
hba->pm_qos_enabled is not protected by the same mutex.

Has it been considered to leave out the READ_ONCE() from the above code
and instead to add the following above the sysfs_emit() call?

guard(mutex)(&hba->pm_qos_mutex);

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 926650412eaa..98b9ce583386 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -1047,14 +1047,19 @@ EXPORT_SYMBOL_GPL(ufshcd_is_hba_active);
>    */
>   void ufshcd_pm_qos_init(struct ufs_hba *hba)
>   {
> +	mutex_lock(&hba->pm_qos_mutex);
>   
> -	if (hba->pm_qos_enabled)
> +	if (hba->pm_qos_enabled) {
> +		mutex_unlock(&hba->pm_qos_mutex);
>   		return;
> +	}
>   
>   	cpu_latency_qos_add_request(&hba->pm_qos_req, PM_QOS_DEFAULT_VALUE);
>   
>   	if (cpu_latency_qos_request_active(&hba->pm_qos_req))
>   		hba->pm_qos_enabled = true;
> +
> +	mutex_unlock(&hba->pm_qos_mutex);
>   }

Please make the above code easier to review by using
guard(mutex)(&hba->pm_qos_mutex) instead of explicit mutex_lock() and
mutex_unlock() calls.

> @@ -1063,11 +1068,16 @@ void ufshcd_pm_qos_init(struct ufs_hba *hba)
>    */
>   void ufshcd_pm_qos_exit(struct ufs_hba *hba)
>   {
> -	if (!hba->pm_qos_enabled)
> +	mutex_lock(&hba->pm_qos_mutex);
> +
> +	if (!hba->pm_qos_enabled) {
> +		mutex_unlock(&hba->pm_qos_mutex);
>   		return;
> +	}
>   
>   	cpu_latency_qos_remove_request(&hba->pm_qos_req);
>   	hba->pm_qos_enabled = false;
> +	mutex_unlock(&hba->pm_qos_mutex);
>   }

Same comment here: please make the above code easier to review by using
guard(mutex)(&hba->pm_qos_mutex) instead of explicit mutex_lock() and
mutex_unlock() calls.

> @@ -1077,10 +1087,15 @@ void ufshcd_pm_qos_exit(struct ufs_hba *hba)
>    */
>   static void ufshcd_pm_qos_update(struct ufs_hba *hba, bool on)
>   {
> -	if (!hba->pm_qos_enabled)
> +	mutex_lock(&hba->pm_qos_mutex);
> +
> +	if (!hba->pm_qos_enabled) {
> +		mutex_unlock(&hba->pm_qos_mutex);
>   		return;
> +	}
>   
>   	cpu_latency_qos_update_request(&hba->pm_qos_req, on ? 0 : PM_QOS_DEFAULT_VALUE);
> +	mutex_unlock(&hba->pm_qos_mutex);
>   }

Also in the above code, please use the guard()() macro instead of
explicit mutex_lock() and mutex_unlock() calls.

Thanks,

Bart.
