Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09E6446AF;
	Mon, 15 Jul 2024 17:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721063890; cv=none; b=q5zomAQwDGBHk+6n1KA4B7cLZDae72Cq7QuiuXQP+Yn6A9uOnHZXCf0h2Cgj3Df1meJNHASWEhAgAmCUzBLXORiV+0ny+JjlE0Da1knsxaVbksCg8JceR/1ophnAOGgSWApUs9qPyLBCwvI7pO+kRJyh0tBnKLb0zv2jISp+fVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721063890; c=relaxed/simple;
	bh=Kc6gbiGyEmsVnB1vPxC1tTwvIpD0gWXSMS/KS+dJzxA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DsW24ejaGUmyzH8pfpYXuuf43wbvosj91HWid6GzGmGPPf5Cj9155DPFXR3ZBM/9iYjVt7lOhn014Rzv32qdK3FMZfWbsOzBIw0tGSw1TRvg32B8FZIQKWkALUIF66nlVqdlez30cEu+y8FpGvwykacWHJ6updJY/xEaSPfRNJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=F30Pq+Uv; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="F30Pq+Uv"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WN86L5F5BzlgMVQ;
	Mon, 15 Jul 2024 17:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1721063877; x=1723655878; bh=Kc6gbiGyEmsVnB1vPxC1tTwv
	IpD0gWXSMS/KS+dJzxA=; b=F30Pq+UvVEfiLLMb5CzuwRCSNbWtz47LqN/b3x2a
	e4BBGHhsb+s7Hbyu7S/AcIZfp1zM5ibyynLqUK6p+zU5TUPSB2cmg+AEpgks5M0S
	wcKJB2JfczZZWjBpdHi5aJGYQoX7Z/w85MepNLb01JlGY4BuRrWYLMoJU2vcwBkD
	S4Qgqi7AqpfmRb1qGXK8SiEiIyfxovoqBaen5tVMOrDK2Q2Ut+NMoTdZEC+elq9i
	29j4SQc2cBcWGeDiVmASqr1q4zfHHUm7j24K3kxtcDp1SNlxTG7eLLMwecoohgly
	Itjq1KVdWyuJvK5vxQlw6gEBtitVwHXsTMrKJsFrmGEItg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id R5oPzZTHmg02; Mon, 15 Jul 2024 17:17:57 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2e14:8:30c:88a5:456e:8b88] (unknown [104.135.204.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WN86C1jNwzlgMVL;
	Mon, 15 Jul 2024 17:17:55 +0000 (UTC)
Message-ID: <814b2e3f-3386-45b6-ba72-7a1143e57e33@acm.org>
Date: Mon, 15 Jul 2024 10:17:54 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: fix deadlock when rtc update
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, chu.stanley@gmail.com,
 huobean@gmail.com, stable@vger.kernel.org
References: <20240715063831.29792-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240715063831.29792-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/14/24 11:38 PM, peter.wang@mediatek.com wrote:
> There is a deadlock when runtime suspend waits for the flush of RTC work,
> and the RTC work calls ufshcd_rpm_get_sync to wait for runtime resume.

The above description is too brief - a description of how the fix works
is missing. Please include a more detailed description in future
patches.

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
