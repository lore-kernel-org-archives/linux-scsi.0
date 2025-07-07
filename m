Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19E41E3DC8;
	Mon,  7 Jul 2025 16:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751904898; cv=none; b=qGv8mpC5NMaW7QutQzcnIXwd1w/iBqB30EabiZ2mcYoxVL3v06McDNFPqe3EnRRod+szjb8030JHmfyYec+LrsKQOG7rwgtboYHtjXQ1yA9HzHQlX+AY/upEfAzj9JruaY+eD2c0VwV0Ry6DscIOK7bdqXh0FH4bqAGlQKm5BZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751904898; c=relaxed/simple;
	bh=LO7QEAUNlrgXSkEoT3jKZHQtzk6EPA+7iKa1WuhezPM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VxESjnGbDv+IjtYUCQZ607ZeZZaNVnLC2Va25s8JP9VdldQDC3KfqDcN+JV6GJk6b9lSLdBCAAOG3alSgk+M5fe7SXdYRun2YSN/EKejAmf0m7qCV96BlYkd7UVuNX9jFvYoinLbXvNLsEA1812y61/VQ39R3dLG19hq4JICPe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XCzhS0Mh; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XCzhS0Mh"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bbTpd6XF1zltKGZ;
	Mon,  7 Jul 2025 16:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1751904887; x=1754496888; bh=DhBmOe4x1JLcoZy9mys+lB4+
	WJiQRcQ3Aao9PKPfMf8=; b=XCzhS0MhtHZh1gZfve9dCCHnaQ14ohGk/X9Al/G4
	WG8xmUu0nDRuTkjj5caY+e5sBmnc4rdlHVAIQl2karkC8vuCbg0+PJkxy6QQXMIf
	nNvr7YdzL9WUmRHpLsKAW6zaTVQb86ezgxVMHgrHByXTSYM1olbx48Ipl+To23Eh
	RBrrMxAeheBcJ4jaSVlDOgeYVKaI3pZHYNchGZKq79XzcuFE2GDjMEn/EAMUkms7
	BJsmdxqA6yygCkjQ17Ypq1XU840d/a74YyEj9VjIYdLrbu0TMmxsk5oZ7q5FfRgF
	kfR8rJsrzmjWN3vzvumoynJ1JO3FFoCB8NwLH8rSMi9/Hw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SVxenN_q8gk4; Mon,  7 Jul 2025 16:14:47 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bbTpQ64vXzlng93;
	Mon,  7 Jul 2025 16:14:37 +0000 (UTC)
Message-ID: <2700084c-5241-468a-a80e-971e42560d31@acm.org>
Date: Mon, 7 Jul 2025 09:14:36 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: preventing bus hang crash during emergency
 power off
To: Bo Ye <bo.ye@mediatek.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: xiujuan.tan@mediatek.com, Qilin Tan <qilin.tan@mediatek.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
References: <20250519073814.167264-1-bo.ye@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250519073814.167264-1-bo.ye@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 5/19/25 12:38 AM, Bo Ye wrote:
> The root cause is that scsi_device_quiesce and blk_mq_freeze_queue
> only drain the requests in the request queue but don't guarantee that
> all requests have been dispatched to the UFS host and completed.
> Requests may remain pending in the hardware dispatch queue and be
> rescheduled later.

The above is confusing. scsi_device_quiesce() drains both the request
queue and the hardware queues for all commands associated with a single
logical unit. The problem that you are encountering is probably that
scsi_device_quiesce() is only called for the WLUN but not for the other
logical units and hence that there still may be commands being processed
for other logical units after scsi_device_quiesce() has returned.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 7735421e3991..a1013aea8e90 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -10262,6 +10262,7 @@ static void ufshcd_wl_shutdown(struct device *dev)
>   		scsi_device_set_state(sdev, SDEV_OFFLINE);
>   		mutex_unlock(&sdev->state_mutex);
>   	}
> +	ufshcd_wait_for_doorbell_clr(hba, 5 * USEC_PER_SEC);
>   	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
>   
>   	/*

The name of the ufshcd_wait_for_doorbell_clr() function is confusing
since "doorbell" refers to a legacy single doorbell mode concept while
the function supports both legacy mode and MCQ. After this patch has
been queued I plan to submit a patch that renames this function.

If the patch description of this patch is improved I will add my
Reviewed-by to this patch.

Thanks,

Bart.
