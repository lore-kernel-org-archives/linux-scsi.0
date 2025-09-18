Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1676E28DB54
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 18:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758220466; cv=none; b=KvcXoHiQZ+G0zaQ8lg4GdqZ+Wz4xPfAnxYsRA2yUQkypInhxKdkNw0mD+zn/BH8z/GkR9gnTgnqBczPIA2cS+N4m7ldESOrdROrL4Hk8FcR0wU6/2AXX6enqvqFzJzHxr+Y6JHhVpKEb81QQwmascafJSX4gALTLxHbaPBxWbUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758220466; c=relaxed/simple;
	bh=z7H7huVJz682pZBEWdQDRF47IMjQgtvG2iWmmNpI9NY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cSUz286pA5WLSMLBZPjunYBcQUe/8QBpHMR9WOs6NYR3WB09baZu4ydSjfSEqHFFzQJd5tV7V4gV/lCrU8b6zpw9DDLUlRV9QNgyPI7gPykUUzQOJ2tfFedyXNHf+cDW/T5ymAEsW1b1ViaEMgh/fSz+XM32riq8CywvJ3UKUxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Bq7mpJ7+; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Bq7mpJ7+"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cSPRz0RrfzlgqVk;
	Thu, 18 Sep 2025 18:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758220460; x=1760812461; bh=z7H7huVJz682pZBEWdQDRF47
	IMjQgtvG2iWmmNpI9NY=; b=Bq7mpJ7+FzlCaAsiD1kbuTSsUaUnWj3T4bJ2QrI+
	l9YWIGOmB19yc8Ik5YdqpTa6FQD+iilo2WxD+urmtrGgYvU+Vya21i0pYnKMqCMb
	KDCy5tIZG6ekklUkkuSAZkEse2M+5xRQVytbSNd/mGkDgEb/OaM3V+wrWrCD12Yx
	actggJ4V2vXrCnHXkcMZh3+ch8bzZ+orNfKs1Z05EbBJC1ZILrQdYwJSKMp2VnCq
	wObF8JCu22SFWifeCAUn9BdEjYJv+TwpsXa5J6IMEKekZWTxbOzmKuY9FtnVcTCc
	IA6N9/oj4s+Il3UT0g/y+CNnEFkVsQ91WQWN57T0gUtUnQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id CWBThPgueKXh; Thu, 18 Sep 2025 18:34:20 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cSPRh4GgbzlgqyC;
	Thu, 18 Sep 2025 18:34:07 +0000 (UTC)
Message-ID: <5ae6134f-6e41-4453-b11f-4e3eb92a1c04@acm.org>
Date: Thu, 18 Sep 2025 11:34:06 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 06/10] ufs: host: mediatek: Enable interrupts for MCQ
 mode
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250918104000.208856-1-peter.wang@mediatek.com>
 <20250918104000.208856-7-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250918104000.208856-7-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/18/25 3:36 AM, peter.wang@mediatek.com wrote:
> Enable interrupts in MCQ mode before making the host
> operational in the UFS Mediatek driver. This ensures proper
> handling of task request completions and error conditions.

All interrupt enable / disable code should occur in the UFS core driver.
Please do not add any code in host drivers that manipulates the
interrupt status.

Additionally, the above patch description doesn't make it clear what
makes the MediaTek driver different from other drivers and why only the
MediaTek driver needs this change.

Thanks,

Bart.
