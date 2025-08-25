Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92B219D07E
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2025 15:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756136816; cv=none; b=D2x/UO8BMzP9KFduVcaD+yjnZooGNUTO74la/nmQQ09WGgpcB9/reDOkg1nGfgCFoA3nyedMIyQ6GeKS8XtW5HkG+tKRE46UhHAJ/Egte4IWHEs30YgE/+UlY99zrTBVQ4F+Qcypl/vpVxe2DXA+oxIDiVSBG+M7DOO9VhDeMEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756136816; c=relaxed/simple;
	bh=wQfVoLRsNftS3/c7b1kym2aWW1QAWzQ22A1A5qVqnDY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UG8sfGGY8yfUT2BmLVxSXWvmtELxjIVBRQY605sH+NPBPUbH9U17trThY0x9d1iHI5Bj7bPu3qfOe8EmreeZxmPiiXmkMNRiAg+HCrDjenZcjOhLHZDYucuIq44DvVFMAP5c2qtzN9M0thSsbjSIyHL25i/EEFuEZJc4VIpvmDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=syCfV9lX; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="syCfV9lX"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c9Zsn6Qmxzm1748;
	Mon, 25 Aug 2025 15:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1756136810; x=1758728811; bh=WQC/JKHgtGrsJiCNW2Z3p+nW
	gYJUS6k58RGfZfgsCq8=; b=syCfV9lXN1voBKvfmmoAfYUBjEZenHWnvrgLx8tN
	gG5uu6EaKG+kE4A19d6zhGf/HzJrTvRkw6DHOLc7szPnw8Li/QYOCoJUVi1TSnWB
	F0ml0/72p6/RsUgq0INkIYsHKkoGCWC3Qx4nMAA+7H0+yb2cvEnxMdF6XoFxUZ2c
	LSvoMpNa8ARbaFxemVl9pUVLhz1wgaQU3QIDvXCnrDi4ZXXDJQ+jYfHc9eRS6/jK
	G9T/BU94o7/lytO/qX6YrAme0qLr6MjGWV+gbHnAbTqNygs/nsN870xxCtBupkck
	xxgQObuNmHp5V58MvAmV99Qcz9bixByYJVWWqbDoPVGJxA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ErtzJIO4oFjW; Mon, 25 Aug 2025 15:46:50 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c9ZsR0SHVzm0yVB;
	Mon, 25 Aug 2025 15:46:33 +0000 (UTC)
Message-ID: <5f3c62fb-ed35-428c-8862-ad1fe607daa0@acm.org>
Date: Mon, 25 Aug 2025 08:46:32 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 01/10] ufs: host: mediatek: Enhance recovery on
 hibernation exit failure
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com, sanjeev.y@mediatek.com
References: <20250825101815.2891905-1-peter.wang@mediatek.com>
 <20250825101815.2891905-2-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250825101815.2891905-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/25 3:10 AM, peter.wang@mediatek.com wrote:
> @@ -1697,8 +1698,20 @@ static void ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
>   	ufs_mtk_wait_idle_state(hba, 5);
>   
>   	ret = ufs_mtk_wait_link_state(hba, VS_LINK_UP, 100);
> -	if (ret)
> +	if (ret) {
>   		dev_warn(hba->dev, "exit h8 state fail, ret=%d\n", ret);
> +
> +		spin_lock_irqsave(hba->host->host_lock, flags);
> +		hba->force_reset = true;
> +		hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_FATAL;
> +		schedule_work(&hba->eh_work);
> +		spin_unlock_irqrestore(hba->host->host_lock, flags);
> +
> +		/* trigger error handler and break suspend */
> +		ret = -EBUSY;
> +	}
> +
> +	return ret;
>   }

Hi Peter,

UFS host drivers shouldn't touch hba->force_reset, hba->ufshcd_state nor 
hba->eh_work. Please add a helper function in the UFS driver core and 
export it.

Thanks,

Bart.
