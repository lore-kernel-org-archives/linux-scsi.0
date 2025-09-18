Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625D227AC3D
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 18:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758220091; cv=none; b=DWwFiaUNDF0f3dc3KyzziESlV+8znMqAHXb6XnWTl6cPrFbwVvt5LwxOz1WnZH/vDZ0hsS30OQr/jpOx3iGvdCEy/5aWv13/KBUd790gqvH4VIVJ26fBJumLGWWRYwWGwMJnAkwefz3RheiNlKaxsaCVzCXcUAdetycUh80YewU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758220091; c=relaxed/simple;
	bh=kylyHEHS3up1OVpa0rBVWqi2C2bd74XMt0HIcIf691E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HJqQaVRRL++TzYU0lT+Agz8fEhnJO36LqEebxeRUV0GMmu8TyPfOSWQ/TqoQApQXRdmbNsM/H0XE9UllKrKu8SYl9v7+VQ0O8FuyazuQ/3ntM6kSBE2VFly5CRxteKkGtbgKjOplOcMzKG8R19XmbvgLahE2Juf8qUzatslf37c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DUJE/h4V; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DUJE/h4V"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cSPJm0p28zlsxDv;
	Thu, 18 Sep 2025 18:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758220085; x=1760812086; bh=iwswQpmRWGLt+ejDK+SWw07B
	lgHgpmGx67rytuETAxw=; b=DUJE/h4VJ6WPGLjuIzQagHpEeZl4XJ1XRayzpZnN
	txDg4OSk+onPQEBWAJv72a4U5UmLHbdOnKsHT2LKCoHWriVQjOGAKKmSLO7KWsxq
	QH0EIVJl/7DttGETJRbmIzUKxAW+vJtLIFSUkjblGMgt02mDSEFNybbgkOmrtYI8
	38FxGSuRtTm78IUdHhSMGmKXmxdy4Fr3Swcpg495MVflYE2vQFDSeb6K8KDKl8sc
	iO9YXGZpsSoE4wne+WWJhcuq8bwR9zZ1cxZUoNC9hiSQa00cxngN1K+ryhpkoA6j
	dZ/L8wguNtNZjuzbWc5eMPjMlUCtKLMU1OFvaekOa8KQ5w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WBI0XP9FFmBY; Thu, 18 Sep 2025 18:28:05 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cSPJR5prpzltPtc;
	Thu, 18 Sep 2025 18:27:50 +0000 (UTC)
Message-ID: <80a31144-852f-4df5-802e-a8c5d04a298a@acm.org>
Date: Thu, 18 Sep 2025 11:27:49 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 01/10] ufs: host: mediatek: Fix runtime suspend error
 deadlock
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250918104000.208856-1-peter.wang@mediatek.com>
 <20250918104000.208856-2-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250918104000.208856-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/18/25 3:36 AM, peter.wang@mediatek.com wrote:
> Fix the deadlock issue during runtime suspend by checking
> the error handler's progress. If the error handler is active,
> break the runtime suspend process by returning -EAGAIN.
> This approach prevents potential deadlocks when acquiring
> runtime PM and enhances system stability.

"enhances system stability" sounds like marketing language to me. Please
provide a root-cause analysis and also explain why this change is only
required for the MediaTek driver and not for any other UFS host drivers.

> diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
> index 758a393a9de1..b1797386668c 100644
> --- a/drivers/ufs/host/ufs-mediatek.c
> +++ b/drivers/ufs/host/ufs-mediatek.c
> @@ -1746,9 +1746,15 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
>   	struct arm_smccc_res res;
>   
>   	if (status == PRE_CHANGE) {
> -		if (ufshcd_is_auto_hibern8_supported(hba))
> -			return ufs_mtk_auto_hibern8_disable(hba);
> -		return 0;
> +		if (!ufshcd_is_auto_hibern8_supported(hba))
> +			return 0;
> +		err = ufs_mtk_auto_hibern8_disable(hba);
> +
> +		/* May trigger EH work without exiting hibern8 error */
> +		if (ufshcd_eh_in_progress(hba))
> +			return -EAGAIN;
> +		else
> +			return err;
>   	}
>   
>   	if (ufshcd_is_link_hibern8(hba)) {

How can ufs_mtk_suspend() be called while the error handler is in
progress? ufshcd_err_handler() disables RPM before it sets the
UFSHCD_EH_IN_PROGRESS flag.

> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index ea0021f067c9..45e2ca65de90 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -97,6 +97,11 @@ enum uic_link_state {
>   	UIC_LINK_BROKEN_STATE	= 3, /* Link is in broken state */
>   };
>   
> +/* UFSHCD error handling flags */
> +enum {
> +	UFSHCD_EH_IN_PROGRESS = (1 << 0),
> +};
> +
>   #define ufshcd_is_link_off(hba) ((hba)->uic_link_state == UIC_LINK_OFF_STATE)
>   #define ufshcd_is_link_active(hba) ((hba)->uic_link_state == \
>   				    UIC_LINK_ACTIVE_STATE)
> @@ -129,6 +134,13 @@ enum uic_link_state {
>   #define ufshcd_is_ufs_dev_deepsleep(h) \
>   	((h)->curr_dev_pwr_mode == UFS_DEEPSLEEP_PWR_MODE)
>   
> +#define ufshcd_set_eh_in_progress(h) \
> +	((h)->eh_flags |= UFSHCD_EH_IN_PROGRESS)
> +#define ufshcd_eh_in_progress(h) \
> +	((h)->eh_flags & UFSHCD_EH_IN_PROGRESS)
> +#define ufshcd_clear_eh_in_progress(h) \
> +	((h)->eh_flags &= ~UFSHCD_EH_IN_PROGRESS)

The UFSHCD_EH_IN_PROGRESS definition and also the
ufshcd_set_eh_in_progress() and ufshcd_clear_eh_in_progress()
definitions must remain in the UFS core private code. Please do not move
these definitions into the include/ufs/ufshcd.h header file.

Thanks,

Bart.
