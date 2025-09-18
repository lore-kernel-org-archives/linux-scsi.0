Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8550624E4D4
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 18:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758220772; cv=none; b=JRH8qlLcNqfEniS1cvWhlq4EcrQDbqrJDOcewIcuhWE/aKN0igZ4KY8nh0EAUpmeWlZaJV50n3zYyWnRXRan6RQ36aEa1acKhqjDNaSnanVWWsXhj2Di4hLnIxkQb21+svglLf0yJLRQvnfYjO8LuJjcKhV56Di0LQAiwr4D7hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758220772; c=relaxed/simple;
	bh=/2Kha1IT8DcMp2pOYY79CYDENJmSAq3cVEdOpIgytBU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mDegRVqDSgkena1abmXvjVlvYTAvqPH3hi0FioM0YANzB1/gc5tzsNJ2EbQfOQ3DQsWmeeoUMvPxkvL6x4XlznVG9W5dAuKjw9DrQV9OzRzMu2udWnICJ7jbZSLyAhu4EwKja4axH0nJ7sX+X2CRk95bSWLzhctGnD/0CtVhP5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EaYHxFWx; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EaYHxFWx"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cSPYs4JCDzm0yQq;
	Thu, 18 Sep 2025 18:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758220766; x=1760812767; bh=18F93i41DECTqPUgQ1X9ryaK
	GagXJ2RY9pp/WFcaWng=; b=EaYHxFWxi0sCpUbl0fBUnsDg04dblHAt/YKnRnmd
	ytjOaWdwInRGmm/A/15xKdKd78Xh0RuLfN2ZPKcNM9pxgyKNG18c69aFNdKDhWGD
	x5y0GhR9ClnPV85rwZqCTttRWo2PRATGlOr495kM0LoAR+dV+vZdetd1uvbX5wne
	xihCmWPdnKshJCVq6WQ/yUJ1B9UiS1fm5Le2tS/Wp7Rq5BgSg+I+9scEKMobZsd7
	AZIlp044N8UZaCLSR3XT7APSGm49tmnp9O2bdoDEavJ4XWBzKbhqcm6wzClSG7wQ
	zaCtJpTSwrH6zHC/PvBrA5ne/nn3yhG0VOiUjNOfveCCGw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Y1jNnBRTRRlB; Thu, 18 Sep 2025 18:39:26 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cSPYb0kv9zm0yVJ;
	Thu, 18 Sep 2025 18:39:13 +0000 (UTC)
Message-ID: <6f4f954d-64fe-461e-9c65-6630b0409710@acm.org>
Date: Thu, 18 Sep 2025 11:39:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 07/10] ufs: host: mediatek: Fix shutdown/suspend race
 condition
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250918104000.208856-1-peter.wang@mediatek.com>
 <20250918104000.208856-8-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250918104000.208856-8-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/18/25 3:36 AM, peter.wang@mediatek.com wrote:
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
> index 109cbb36c02d..7df475ebd06d 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -1436,6 +1436,11 @@ static inline int ufshcd_disable_host_tx_lcc(struct ufs_hba *hba)
>   	return ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0);
>   }
>   
> +static inline bool ufshcd_is_user_access_allowed(struct ufs_hba *hba)
> +{
> +	return !hba->shutting_down;
> +}
> +

Please do not move the ufshcd_is_user_access_allowed() definition - I'd
like to remove this function. Please either use hba->shutting_down
directly or add a .shutdown callback in ufs_mtk_pltform.

Thanks,

Bart.
