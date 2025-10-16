Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761AF3346B7
	for <linux-scsi@vger.kernel.org>; Thu, 16 Oct 2025 17:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760636759; cv=none; b=MZ+m8uQbQ1rolyb8nsZvRXYhyhGvuWVNSsnNG4La9c0KfhnTqOL+0gbAT1OK4Y8jxouwU7byCcdHw9F4wBNxAgcSpVra7aQILdMZr9iTxUxEuw7OIDzT/2qXkxM14SBhObPxatra6QRAL7a+zLfEPKFYK8aKQKyOq6T5pZmetBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760636759; c=relaxed/simple;
	bh=P5LrF4XUD3Qrzh57jCUubh/KmdYfbqo+2j4KHBLHHvk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lOYOu4eMcRm2UbbvFirjjEiWQ0Nqt5OKUuLtPj9iAIh/0Uvtxp6qfaseUYTFKTCSr7fackNxwfWMaofjlR0Kc84W2lraP0MB2+vBpz4M8buj17mt2Oz+BRifPtZqGBaRoZC4ay5SH5NDYWrVC1CQlDPFp6vuwgl5yFGlujmG47c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=S284tZt/; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="S284tZt/"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cnb3822qjzm0yNR;
	Thu, 16 Oct 2025 17:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1760636753; x=1763228754; bh=P5LrF4XUD3Qrzh57jCUubh/K
	mdYfbqo+2j4KHBLHHvk=; b=S284tZt/2XiA+I+2hPv7Cp0rDS5JIFtCFIBkVmFD
	F6YGNwGD3PXJjB/evk10Wk693SZlXsdjI1mNflyfz7nWWR5y3/06mOelh1yDUzGd
	rPxha2Ed1vxRxMw/Tys8E9y128XG7bAVfKuD6uH10+dYTuVE5W2pK3SpuWOyciXz
	WDtHR2hvKS2bjE8doR7UxItBUZbL3b6zc++BHMiXJxlIN4OWQsnw/VCQxrIvPNuD
	rm93labAQQQFIQ43QiJ/tUDhOJeWQPkyZY1L4YrT1PwBd+3baZCvj7c4YwVULcpG
	ebbJKR/PgSaAADBpL3xrQzwTx0eZT75CuEmDbUjcft3oRg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8bU9H-wIF0Ao; Thu, 16 Oct 2025 17:45:53 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cnb2r0dSVzm0ytM;
	Thu, 16 Oct 2025 17:45:38 +0000 (UTC)
Message-ID: <5d04501f-4bb8-40ce-a396-010faae38481@acm.org>
Date: Thu, 16 Oct 2025 10:45:37 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] update CQ entry and dump CQE in MCQ mode
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, qilin.tan@mediatek.com,
 lin.gui@mediatek.com, tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
 naomi.chu@mediatek.com, ed.tsai@mediatek.com
References: <20251016023507.1000664-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251016023507.1000664-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/15/25 7:32 PM, peter.wang@mediatek.com wrote:
> Update the CQ entry format for UFS 4.1 compatibility and
> add support for logging CQ entries in MCQ mode, enhancing
> debugging capabilities.

For the series:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

