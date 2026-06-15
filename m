Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96893E557F;
	Mon, 15 Jun 2026 13:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781530863; cv=none; b=AIEDZrWqLeoFdEnZwd+AoeVwk/7CqmmBZPWldPJxJSgd4sITKuS8xvInFdo4llHID//IjVUInRyvpzvVhg6QfCPRH5SG1985GGUlLLnu0pEsqVq3YystWcWBmtiR2Ics7tYqmnA0yGdMBjEbmcpi7xFoP6r0/q2AgBqMoEJ0frw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781530863; c=relaxed/simple;
	bh=dGVKq3DqkJdswBGgVG+gslnExkfAwrSp65EizBZiGKM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YcjAa6cGj7XhPgoWu8sLXH4QytnUGfKrP0a7m6SQXtuoSAENZcTlKVQQ0emSWErzxpu1hsjHXJr6vLEXWsCgRs2hvfZbrNPIbDrKWCiA37OvdDiuWsHJFjd9iMsLkyhqVvMrIrzY69uIU6E9mxFoooNmgf9ww6gGdAbyVuiKDFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DzWHun1z; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DzWHun1z"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gfB8t2kqszlfl5V;
	Mon, 15 Jun 2026 13:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1781530855; x=1784122856; bh=dGVKq3DqkJdswBGgVG+gslnE
	xkfAwrSp65EizBZiGKM=; b=DzWHun1z/cTIPfcFjYWFAYKfGzApZhmJY3T8Ic1l
	ekMU1Vrdc3A9lkGKQ1cloPe6yfEd/kHkn+ja9LQf3wKTeBF6qomGJhpl/y8FNcNB
	Ibif9KtpeVwA75hxytJTulSkPZyuQJ9H4qZwynVTiS9B7x41yD2jOJBgQaaLizeA
	WJhj6CC/jATxIE0Hpr7pDnSAVhJRu2/mRw5FxwZrn+2cLV5hYF08w5DYDi8fk1yN
	RiAEWcaZFvwBedNbp2H51nQPCvVMJMM3zbTjlhJXbsJN/2QVAeCpzIihhOnMBy7c
	ArvCMhF2WooauWI1qpBRk9gFZ+9uxUl3tyoadkMMhmo5kA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id m8jRUe-O9L6p; Mon, 15 Jun 2026 13:40:55 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gfB8f1dQfzlfvpG;
	Mon, 15 Jun 2026 13:40:49 +0000 (UTC)
Message-ID: <414c9338-0e3e-4d68-941d-18cb83dc78f5@acm.org>
Date: Mon, 15 Jun 2026 06:40:49 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] ufs: core: Remove max_num_rtt field from
 ufs_hba_variant_ops
To: ed.tsai@mediatek.com, alim.akhtar@samsung.com, avri.altman@wdc.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
 peter.wang@mediatek.com, alice.chao@mediatek.com, naomi.chu@mediatek.com,
 chun-hung.wu@mediatek.com
References: <20260615055802.105479-1-ed.tsai@mediatek.com>
 <20260615055802.105479-4-ed.tsai@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260615055802.105479-4-ed.tsai@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/14/26 10:57 PM, ed.tsai@mediatek.com wrote:
> Remove the max_num_rtt field from ufs_hba_variant_ops as it has been
> replaced by the get_hba_nortt() callback which provides more flexible
> platform-specific RTT capability handling.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
