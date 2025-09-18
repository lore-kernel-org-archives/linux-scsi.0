Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E844B1DDC2B
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 19:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758223706; cv=none; b=qlfBftPGfpUjVLD1UAv2DJxekJju5/i2pQxS6Nc5xk+f9bGkaoKDDMbCSI2ffLVlKHXNlSQcRTkplbd9DtSzoiMK4AbnfYDdwtllnsjK9gsMVZXQlH1HwONEG/a9XLJO7aOXmD4PrLbY+Xg1daGqjlQTrGqIJER4CAw5MXLjViM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758223706; c=relaxed/simple;
	bh=DmsuSXRya+AuEMpYm4myvICHIZufhIehrKdUEWo96Mg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FYccIWUVSxL41/SybFDLixndQriks33SdAOHgWByuXnwrsvNsLga/zu0ASUjZtO0em7XIs3j+taNFvfilBp2tYrjfZj5qrZQI8qYNOIEsij+lpoHTjiolt+F1swtkYIrkJj8YIq1xp9zJyhScrJZqKk97f+VifPoeSwCshdGIOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RxQ7sbFB; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RxQ7sbFB"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cSQfF5hZczltP0V;
	Thu, 18 Sep 2025 19:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758223698; x=1760815699; bh=to7t8pxAzeROLpmJIHcDUV0b
	8IiZYPu9MdlR3yTFEEY=; b=RxQ7sbFBuhiYQqS4qCCXqSLljtifSIsQPdZATkYn
	8eVR6TSpfunIS5o2Fg+yNVLpUn5xhBkpjPEen9WH+yec6dCW3dNmfiRxvti+iqdn
	HuhArA6/gHtGsYccotFW7FhDz8bmmrexXv+2jriWVNzodmR+JgGb+zztowN0ixj2
	ozaJ2oDgPmu2YWLVty+vkd45lTsARcpVYO4oi6bVK7VR9RCIYbwwkyD7CCCyT9S1
	JIGCiM2jHhyLrrNwVrID2fkaOVCP3ukFCI/zRgl2CvFzAXINwpBuPW2e+YBvZqJK
	AiX4nj2TP7Yp20Xl6E7qp+v0tU0QuXHr7+ATnyWTQVwcLg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DHCMMoKn-ojq; Thu, 18 Sep 2025 19:28:18 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cSQdz0wq3zlrnQ8;
	Thu, 18 Sep 2025 19:28:06 +0000 (UTC)
Message-ID: <ff2243ed-3f7d-4746-80cc-b8f3f1b9e8b7@acm.org>
Date: Thu, 18 Sep 2025 12:28:05 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 05/10] ufs: host: mediatek: Adjust sync length for
 FASTAUTO mode
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250918104000.208856-1-peter.wang@mediatek.com>
 <20250918104000.208856-6-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250918104000.208856-6-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/18/25 3:36 AM, peter.wang@mediatek.com wrote:
> @@ -160,7 +163,9 @@
>   #define PA_PACPFRAMECOUNT	0x15C0
>   #define PA_PACPERRORCOUNT	0x15C1
>   #define PA_PHYTESTCONTROL	0x15C2
> -#define PA_TXHSADAPTTYPE       0x15D4
> +#define PA_TXHSG4SYNCLENGTH	0x15D0
> +#define PA_TXHSADAPTTYPE	0x15D4
> +#define PA_TXHSG5SYNCLENGTH	0x15D6
>   
>   /* Adpat type for PA_TXHSADAPTTYPE attribute */
>   #define PA_REFRESH_ADAPT       0x00

The "#define PA_TXHSADAPTTYPE	0x15D4" line shouldn't have been
changed. It seems like this patch changes the whitespace before the
"0x"?

Thanks,

Bart.
