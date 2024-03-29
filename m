Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C64E2C197
	for <linux-scsi@vger.kernel.org>; Fri, 29 Mar 2024 18:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711736863; cv=none; b=QoZeLCiklzoih1qNnBvtKC8SJUNJOaMxH6dov3GtDKduBo1qn1gRy8H3RBW5Jp24JISO8uyFiJbPXMFyJkmx00SpvHwzgJFQhyDsRGFYmjb+L67xs7uMQylTqPqRlILbyw0Fj6r4BXP4tgeEFnp9V/smu/IO7g0uVZ7+z+GVFaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711736863; c=relaxed/simple;
	bh=4YBZWqBkSUv7ch15sq5yXuPsdi5P9MWlsqMawvgvm2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aIV6al4HFN2VBQFDNzw8u8Td5H2CYFuDjXdsfQO5HBFe7PA8bj98kVE2SkVRNrbUidjmpwGxtL4yNoTIt4wEFVaxy5jXXXbTiPbNvhJk5PmHSMQkIpFUntcKBRwwrKCheH3/Vt2paOk+ybQ50FmJ9g07AlNAy8K1oyG5zAXhyF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=H82NeuPG; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="H82NeuPG"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V5pmX71dwzlgTGW;
	Fri, 29 Mar 2024 18:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711736856; x=1714328857; bh=4YBZWqBkSUv7ch15sq5yXuPs
	di5P9MWlsqMawvgvm2o=; b=H82NeuPGekOXpGoL11zRKXqqLtJ5N1e+fp5DgC7/
	qzyVScq5XMuFn2NVkHJP14RYfw1zdecmCkjxHr5Zz+BgUa/fJbLlSC+BDDFq5emy
	Igvl/qWeobhzdOAHNU/09SMpVntAtQK7FivYU4tJis7Lc16LFD3Wf/aKBtY4U2AR
	WNGrvYtURcAYASa307HOcsrJ3aEK9GpmtHoIEQFfWh9p1zA4qnvOf+u337vsLHew
	bI7V+RJOFmqU2cTgC0YPm7tWwwDkqo/NKO3EoSQHxXneN56UE/1ZPlBtPzkNdSMF
	J6MLtz9x4ukS+j0imIKbW3spqKi2J2J9zHpUJjmThPO64g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2elengDEaMkT; Fri, 29 Mar 2024 18:27:36 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V5pmL4dsSzlgTHp;
	Fri, 29 Mar 2024 18:27:30 +0000 (UTC)
Message-ID: <a92979fa-dadb-4758-9066-96b3b21c7d98@acm.org>
Date: Fri, 29 Mar 2024 11:27:28 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: fix mcq mode dev commad timeout
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, chu.stanley@gmail.com
References: <20240328111244.3599-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328111244.3599-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/24 4:12 AM, peter.wang@mediatek.com wrote:
> When dev command timeout in mcq mode, clear success should return
> retry, because return 0, caller consider success and have error log.
> "Invalid offset 0x0 in descriptor IDN 0x9, length 0x0"

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

