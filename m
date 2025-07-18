Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A69F3B7A8
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jul 2025 15:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752851662; cv=none; b=azE36dwauwSOYc+xJBDATJ6juw2uHbuqB7S9yB1NodF2IvMHW9HE+Bcdsn0gItp/Fy9zqmDILgDfznrD3X20iTjomUgnSDP+9K7JlHfOYDOwZt5i8Fsd8K3mU/Vaiy+JaKV6nv9/evY/xs3HAnsGud7DtrAC8Bw/1LanZwasaiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752851662; c=relaxed/simple;
	bh=lxCicdyYa2UDznDrLaresdWm+vxV1ezRLMBmAB8ZAnE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L5PZNvClYHYKAR45yU4tnd0R00fnBrgs9Foivi6vSpvNG6DzPrcLOqt2w0SL8eEHa6xXL9H1Vkudd082RXaT4MuJ/mkitGR24+npQnO36HpKlRXoggz0ddyhhuRjIbQlH7nNovDRElLE79KWePsvXVU8NPcSkNi5c9JqO33uZqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CIu3S/uB; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CIu3S/uB"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bkCxm2bcdzm0yTg;
	Fri, 18 Jul 2025 15:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752851657; x=1755443658; bh=sZ8e+i3SVXijO2acStSnOiP7
	fhcCGCyTomSnYRqHsHc=; b=CIu3S/uBvt4asIIh+GU6ZFLDaBTvbGLAaI6dSJAt
	m69GbmaiFavH0OPNW7OODBph0eDEINFWhnA1YsnFDDUOiZOk977CJ5BEHlLladOO
	LLeIJ4qVnLcLHlLvXXvzi0PKaTHL1sH7Jf2cqxTg7Tg1e+yKODH667I6ne6i/q1D
	CJvAI1+rzYoSD7pfXJxVg3pm528R2YGGRRhLrVJOCuCFK8Xp94IrDF0QyGJKSzx0
	YetUQ7TGTguQ4zbISL1UYhOoQYjNWQTaAXh4FeUN1HXOcEX2rsF8kbZVM6/jpCwb
	WB5UCpuEtqJC4JmInEhKSw6b9tcWUkRLfmAqwdLp4OTmUQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ECewcsMADdaB; Fri, 18 Jul 2025 15:14:17 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bkCxT3YB6zm0ySb;
	Fri, 18 Jul 2025 15:14:04 +0000 (UTC)
Message-ID: <a2352960-0586-4e34-8f80-446010383778@acm.org>
Date: Fri, 18 Jul 2025 08:14:03 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/9] ufs: host: mediatek: Add DDR_EN setting
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250718095524.682599-1-peter.wang@mediatek.com>
 <20250718095524.682599-3-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250718095524.682599-3-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/18/25 2:51 AM, peter.wang@mediatek.com wrote:
> diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
> index 05d76a6bd772..474fdec0a880 100644
> --- a/drivers/ufs/host/ufs-mediatek.h
> +++ b/drivers/ufs/host/ufs-mediatek.h
> @@ -192,4 +192,16 @@ struct ufs_mtk_host {
>   /* MTK RTT support number */
>   #define MTK_MAX_NUM_RTT 2
>   
> +/* UFSHCI MTK ip version value */
> +enum {
> +	/* UFS 3.1 */
> +	IP_VER_MT6878    = 0x10420200,
> +
> +	/* UFS 4.0 */
> +	IP_VER_MT6897    = 0x10440000,
> +	IP_VER_MT6989    = 0x10450000,
> +
> +	IP_VER_NONE      = 0xFFFFFFFF
> +};

I still see "UFSHCI" in the comment above the enum and "UFS" in the
comments inside the enum? Is that intentional?

Thanks,

Bart.
