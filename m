Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E41D214813;
	Mon, 14 Sep 2026 06:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789367058; cv=none; b=jY/IAL+cW2lx2UeHaflpZY9YcN6wmn4LOjH6tD64p0k9DwxSGCHkAAUGMZo76F6Te6fGzS+c727zyq+uPjC9Sf8ooySUd41b6DtX9nj9WqlyBcpwMp4DEqKLS1Qv/mAUlQylZs0BELeO+v7TYt8yNHaiG4VwmRHoQdGl4cKH/Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789367058; c=relaxed/simple;
	bh=9B4XH0II4xZ1j+bNjSDBu3eGMS1m7Y+HYDd5JbKuO40=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=nO+HYxfxaQ4qVc71zbCJzuUxY10gKJyI7YPHDkWxRRuNDrN0HkqKGm6lu+3zjsz7hCqAeskr0F1jsvdkhhHzUwL/vxE2YsLLdQBUZ38hBbPMkKjPFdJNCNj3+MeGFf8WHS3chrwaXsf0wLe9T6IHVhx90OHanGsz9NeUFLhYr90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hjvw23SD8zKm6K;
	Mon, 14 Sep 2026 14:13:06 +0800 (CST)
Received: from kwepemf200017.china.huawei.com (unknown [7.202.181.10])
	by mail.maildlp.com (Postfix) with ESMTPS id 7C6124055B;
	Mon, 14 Sep 2026 14:24:07 +0800 (CST)
Received: from [10.67.121.58] (10.67.121.58) by kwepemf200017.china.huawei.com
 (7.202.181.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 14 Sep
 2026 14:24:06 +0800
Message-ID: <cda318e3-806c-4388-8f1d-cd814ec194e0@hisilicon.com>
Date: Mon, 14 Sep 2026 14:24:05 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] PM / devfreq: Fall back to previous_freq when
 get_cur_freq() fails
To: Bean Huo <beanhuo@iokpp.de>, <linux-pm@vger.kernel.org>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>, Chanwoo Choi
	<cw00.choi@samsung.com>, "Martin K . Petersen" <mkp@kernel.org>, "James E . J
 . Bottomley" <James.Bottomley@HansenPartnership.com>, Avri Altman
	<avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, Alim Akhtar
	<alim.akhtar@samsung.com>, Stanley Jhu <stanleyjhu@google.com>, Bean Huo
	<beanhuo@micron.com>
References: <20260907192140.2701755-1-beanhuo@iokpp.de>
 <20260907192140.2701755-2-beanhuo@iokpp.de>
Content-Language: en-US
From: Jie Zhan <zhanjie9@hisilicon.com>
In-Reply-To: <20260907192140.2701755-2-beanhuo@iokpp.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemf200017.china.huawei.com (7.202.181.10)



On 9/8/2026 3:21 AM, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> devfreq_set_target() calls the optional ->get_cur_freq() callback to get
> the frequency that is passed as freqs.old to the DEVFREQ_PRECHANGE and
> DEVFREQ_POSTCHANGE notifiers, but it does not check the return value. If
> the callback fails without setting @freq, cur_freq is never assigned, and
> an uninitialized stack value is passed to the notifiers.
> 
> hisi_uncore_get_cur_freq() can hit this. It returns -ENODEV without
> setting @freq when its PCC channel is missing. On the mailbox error path
> it sets @freq to 0 instead, so that the core does not read a random
> value.
> 
> The other two callers, cur_freq_show() and devfreq_monitor_resume(),
> already check the return value and use devfreq->previous_freq when the
> callback fails. Do the same in devfreq_set_target().
> 
> This does not seem to cause a visible problem today. The passive governor
> is the only DEVFREQ_TRANSITION_NOTIFIER user in the tree, and it only
> reads freqs.new. So this patch is not marked for stable.
It's a really rare error path indeed.
> 
> Fixes: 0fe3a66410a3 ("PM / devfreq: Add new DEVFREQ_TRANSITION_NOTIFIER notifier")
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Thanks, LGTM.
Reviewed-by: Jie Zhan <zhanjie9@hisilicon.com> 
> ---
>  drivers/devfreq/devfreq.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index f08fc6966eae..f20d9a660779 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -348,9 +348,8 @@ static int devfreq_set_target(struct devfreq *devfreq, unsigned long new_freq,
>  	unsigned long cur_freq;
>  	int err = 0;
>  
> -	if (devfreq->profile->get_cur_freq)
> -		devfreq->profile->get_cur_freq(devfreq->dev.parent, &cur_freq);
> -	else
> +	if (!devfreq->profile->get_cur_freq ||
> +	    devfreq->profile->get_cur_freq(devfreq->dev.parent, &cur_freq))
>  		cur_freq = devfreq->previous_freq;
>  
>  	freqs.old = cur_freq;
