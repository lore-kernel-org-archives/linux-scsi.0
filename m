Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354972609EE
	for <linux-scsi@vger.kernel.org>; Mon, 12 May 2025 22:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747088531; cv=none; b=g+sIjsAgQQBdhjDvjK9cjhiMr1VsMgeLOuGodlR4t9ZZpsv0QOHhbMzvRC3D9hfaeg7lk9fvvi6/HBjn9Oru4UI+BOB/CPaD81sp4yaU8QUW+k+PeQTKw06qFGpKGOZYcZnaUwcg/EpVT1+AD6RE/PP2nUu7Fe8RiGouNyWT/0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747088531; c=relaxed/simple;
	bh=zlaLzn+pVyebtw7YkjcB4lVpsHM1M8eH8Dnp9T3yH8M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dr1b45+73GIzR91Q68Bo9NVmZ2gH956cG5GsGE1tfSHc7XF/rJaA923WehoII7IYXZy4FVDv1ufratPHPA91MIc6X1AcNfXOkZHQfMa1gtDZog7Zg9zTQLfov9unGV3n+1XkFjwLX6Nvc/1ia78qebLdsb1gCAmartbedMVEaY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wbryJAuR; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wbryJAuR"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZxDcK0Vw7zm0yTL;
	Mon, 12 May 2025 22:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1747088525; x=1749680526; bh=bkNeTzwzChBPxnTQM5+0U/fF
	A9+o13xiapopYsinHT0=; b=wbryJAuRaHD3jtgIM+x3oAW5wVdXqTEudLBMx6GW
	l6iFrcgvkb4F1nZrJKg+NoPrjwWyVRjDEO7bQdBfd8FeKt3hYC21MMyXB8iYo4s2
	l701r5iz4ox5SpgzR494TN1GU08hH/Zas4KDF7ugqWpLWNmXshVYZbQrgzibuT6e
	HKXkN4lBFnwZUWlh5uj6t/71LSI/hafADSTHzYsEQ11mvH4u+XfIFnYa8NVHhsAs
	xrx6mgAO40yysbLvTteqkLTa4aZoldV/pmRfSJDQzoC0ai780Kk7mYeyVFBhaxqL
	nFZ+DVVvfYRQ1+35GSmekv74SeF1gmd8sFaa3jUZqn3yMw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id W43GxB88FXig; Mon, 12 May 2025 22:22:05 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZxDc00wnQzm0pK6;
	Mon, 12 May 2025 22:21:50 +0000 (UTC)
Message-ID: <a399d7d5-7829-42d6-84d8-d0956d07f8f0@acm.org>
Date: Mon, 12 May 2025 15:21:49 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: support updating device command timeout
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250510080345.595798-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250510080345.595798-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/10/25 1:01 AM, peter.wang@mediatek.com wrote:
> The default device command timeout remains 1.5 seconds,
> but platform drivers can override it if needed.
> 
> Some UFS device commands may timeout due to being blocked
> by regular SCSI write commands. Therefore, the maximun timeout
> needs to be extended to 30 seconds, matching the SCSI write
> command timeout. And for error injection purposes, set the
> minimum value to 1 ms.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
