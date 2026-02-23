Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A78330D34
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2026 17:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771867455; cv=none; b=T8IycaiT5en+Uo1SYCOA/cZ3ys0abphDS/N3yiQm+s/bS6oRz9b4spNNGj/612Fv7ugqZoOl2MJl6HzQq5IRx7AtKOC5bAR48y+g6Z3CTPsclVpCGgQwJMlCzL3Fryh6Oro6XGYXLSAED5xt46owWRq9DWsbOJUqmvX6a6bS97U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771867455; c=relaxed/simple;
	bh=ZS6BmP1AhXGQxUC/hQyO1uH9bdWeGjv/kABSMi5JjHo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dWdKjVpsTk1r2SKZXzByIZ7Y8WB9AjdfEnh7bs5vtuUDhcdg87xrK2jZCwpPtaEKC/bspx0CJoEuaq+Y5bFPrwjPvSC8o8k0R7uQaCKiFPN2U4qe11Tt9RWhTI9ZLXpuOepmbE8K5dYjxN2qiUaO1D1vu9PoR6vRI8x7lTz8p44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=dB/oLCgX; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="dB/oLCgX"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fKSQ55jn5zlfddy;
	Mon, 23 Feb 2026 17:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1771867450; x=1774459451; bh=lkt0S9mMcUaUASmdJ3Lv+6XS
	tfU5iRAFdPpB/dYdz0A=; b=dB/oLCgXcfxxRPqpm98ZVtGmlFVhCskFoWDwi5FX
	fly25rD4JSPqLpR33R38RoWjZMGf8XCjk54FZ0US0p08wIjWBSDGOQd4p5Lf9PDd
	y6Q552xcbtcH7UF4fk6k5RWKAL5+D4IZuMxtqleWZJG8R3BLFXOcv6QkttBh5TCx
	esbdISLJr83Y4PTES8jWyXcp5QL5UqEEZfdvvbFs4CMmAJ9cXnTqB7XhS/nwgTFL
	dYM5TktwwQ2X7dqSu3c5cT+0aWjXAEi1CthAE1IFqSWPRUDzBKodmT0tMJ0oTcCh
	lkjWrFgaN8A6wDJs1iX8XCmZiB46s2LExsK62xl3wROEoA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SyCnbIyf9r_U; Mon, 23 Feb 2026 17:24:10 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fKSPc2qvWzlfddS;
	Mon, 23 Feb 2026 17:23:48 +0000 (UTC)
Message-ID: <d95704e9-64d2-458f-8a4f-8d6b5f668033@acm.org>
Date: Mon, 23 Feb 2026 09:23:46 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: Move link recovery for hibern8 exit failure
 to wl_resume
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@sandisk.com,
 alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com,
 sh043.lee@samsung.com
References: <20260223103906.2533654-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260223103906.2533654-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/26 2:37 AM, peter.wang@mediatek.com wrote:
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 44efb03765b9..9908375b2f98 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4385,14 +4385,6 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
>   	spin_unlock_irqrestore(hba->host->host_lock, flags);
>   	mutex_unlock(&hba->uic_cmd_mutex);
>   
> -	/*
> -	 * If the h8 exit fails during the runtime resume process, it becomes
> -	 * stuck and cannot be recovered through the error handler.  To fix
> -	 * this, use link recovery instead of the error handler.
> -	 */
> -	if (ret && hba->pm_op_in_progress)
> -		ret = ufshcd_link_recovery(hba);
> -
>   	return ret;
>   }
>   
> @@ -10175,7 +10167,15 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>   		} else {
>   			dev_err(hba->dev, "%s: hibern8 exit failed %d\n",
>   					__func__, ret);
> -			goto vendor_suspend;
> +			/*
> +			 * If the h8 exit fails during the runtime resume
> +			 * process, it becomes stuck and cannot be recovered
> +			 * through the error handler. To fix this, use link
> +			 * recovery instead of the error handler.
> +			 */
> +			ret = ufshcd_link_recovery(hba);
> +			if (ret)
> +				goto vendor_suspend;
>   		}
>   	} else if (ufshcd_is_link_off(hba)) {
>   		/*

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
