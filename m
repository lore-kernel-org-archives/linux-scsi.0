Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5D73E8C56
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 15:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773849067; cv=none; b=J/l/TL6AJL4Tmzx7uLIbiRSlNNrBKJ3LOWCCUPH4BmxEacEMYWkylo47fb9bZWskaenQvZ+UM35O1N1jCmL33hzHiajb0lXmmTd9KZ9MmXoc2LPdIj0njFdt03WTIL/t7jHf7jn3vaCg5RGDqD0Yd/DkWcPmAWws0jC9J30V1zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773849067; c=relaxed/simple;
	bh=9sQXwJ1FzGVJ7xKCBySBZy29kme5NQc3kevwspvZDXA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oAO6HVmegeqS7CJN8tk7Iu/BLPZJOWkTjMLKOkCXj4kiHnec43uM5W0WZyxETRHt7AJJThdqesSlsb6seqLhqtzN7QPZGndwxKeK804Y7/VDX0zguHSrh3iNqr6Jj5LnvQT3w1jmpNguIHPtyml0lZVXiJHEkoFyTLVQXGjuIEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=phtHDDPA; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="phtHDDPA"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fbYFz2D2bz1XLyhK;
	Wed, 18 Mar 2026 15:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773849043; x=1776441044; bh=ObCIHIt+y1waPC5OHqwhFDJK
	k36uZG6g9VeggOOMmyo=; b=phtHDDPAlPO0w3tQCoex29e6eplm/NbfToZxFsg9
	qhAHTYduf98uq70MgDTUKP6aSu5ncicptLKzbPoyoASRTXVZ5b2VIPbnx+mxMPwK
	gU4/GSVk6W9GiaxDKKkRfh7LpIGhohot2fTgRqsddT5ZtdWmuyYyCCAMcKli36KV
	RJyyRawKojCcPbgd5TPoK45DvTQ6ZRzBIOKs3KGEgfr0NRiWQnYqp/gvNK5ZS0Gq
	axy+SiVQt4s0b5ZxEGGIZJM2oht6Ti3jHia3YUXvQ5TkIyGRrI9xb3+nht7m3zJv
	MPSBZJjtvSIES/v+haYEFxemqtlTUw50uY9Ihm+rUCfSKQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gpOWt2FBNAJu; Wed, 18 Mar 2026 15:50:43 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fbYFM4VsXz1XM6Ht;
	Wed, 18 Mar 2026 15:50:30 +0000 (UTC)
Message-ID: <df1d0b3f-6822-4c49-aeea-fc513e2b05cb@acm.org>
Date: Wed, 18 Mar 2026 08:50:29 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: Avoid IRQ thread wakeup during active UIC
 command
To: Marek Szyprowski <m.szyprowski@samsung.com>, peter.wang@mediatek.com,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
 avri.altman@sandisk.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com
References: <20260306054419.3816557-1-peter.wang@mediatek.com>
 <CGME20260317171131eucas1p25dd55bf1aad6d5b310526d51885b3b7a@eucas1p2.samsung.com>
 <1f88b91c-59e6-4347-84c2-50b7cf106c47@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1f88b91c-59e6-4347-84c2-50b7cf106c47@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/17/26 10:11 AM, Marek Szyprowski wrote:
> This patch landed in linux-next as commit 6475cfb81fc4 ("scsi: ufs:
> core: Avoid IRQ thread wakeup during active UIC command"). In my tests I
> found that it causes the following regression on QCom RB5 board
> (arch/arm64/boot/dts/qcom/qrb5165-rb5.dts):
> 
> =============================
> [ BUG: Invalid wait context ]
> 7.0.0-rc4-next-20260316 #16535 Not tainted
> -----------------------------
> swapper/0/0 is trying to lock:
> ffff000089f58048 (shost->host_lock){....}-{3:3}, at:

This line is a mystery to me. Are there perhaps any local changes in
your kernel tree on top of linux-next? I haven't been able to find the
text "shost->host_lock" in the UIC completion path. Instead, this is
what I found:

	guard(spinlock_irqsave)(hba->host->host_lock);

> ufshcd_sl_intr+0x3c0/0x6b4

Can you please help with translating this information into a line
number? Tools like addr2line, llvm-addr2line or llvm-objdump -d -l -S
can be used to perform such a conversion.

Thanks,

Bart.
