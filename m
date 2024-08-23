Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0F3134A0
	for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 16:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724430128; cv=none; b=YKVVGGmZyzIgqsdmUou2k/sfDF55PVl6SDsLxLNocl2YUU4DDoQBNrmscFNo5cpTkRBIQxCWGYLQHSR1sxS8hbtLSxgV1yEom6iiscEFDtNgtDaxTFvZyjHn+eXqjBTk1P7K2EmcASMtNIoaJKzWDebopoh5R7lI+yysdw38mWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724430128; c=relaxed/simple;
	bh=uVPPyqXvcrLrLZkFGDKTMwif7sSyOkiS3MMJrazKcNQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tbKg6G1c06elBijGNwFFVM/RLmRdRWkB96aGNKXYv/SYwUkVyJIaDvDV/ntc9vXoRzAm+OfphEJtPHC9QwYM+vPBGkekROcklcV7s7GMEpxQWSwqMiQcHIIUn5i2OGSZGnSqmMYyf1gCsntMXxAR7M0/JH7IDLezon7vKqyDXuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OJ2HSjTz; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OJ2HSjTz"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wr51p113dzlgVnK;
	Fri, 23 Aug 2024 16:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724430121; x=1727022122; bh=uVPPyqXvcrLrLZkFGDKTMwif
	7sSyOkiS3MMJrazKcNQ=; b=OJ2HSjTzBQ3UdkJT3fgwC00rTm7eT4z3ZePq7o8w
	oCA9TaZdQYelszCgG8nM93nYGxx82KPJ9CmOC+Bao7o8IbUUZwWOp9kPOgnXHGVq
	Qisv6h8a2MK5MQO6E2o78cDhwftrnTz69BeO0JASKLWfogWlW/9n5xdmjNUPCafn
	KOTo0rFJy4s57IfpxIB17yHQKDZ0ApO/8pRNPJ6LQI+uaVt3btClWf/W42eqhjw0
	nMpdS1J2Sw1XJmh3V0hN5ffuOOpIcu2CiADD9S7RpsroMJ8IDqahfwmshwUmUA5m
	xl3ojRwfha+ofy4/lWpuQVMjvftBkP370TyKibQeQrm06Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id k8NigCZLvUK4; Fri, 23 Aug 2024 16:22:01 +0000 (UTC)
Received: from [172.20.20.20] (unknown [98.51.0.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wr51b3Bk1zlgVnF;
	Fri, 23 Aug 2024 16:21:55 +0000 (UTC)
Message-ID: <ab24891e-f7a6-4185-9235-ffdc13c88f53@acm.org>
Date: Fri, 23 Aug 2024 09:21:53 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] ufs: core: force reset after mcq abort all
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, chu.stanley@gmail.com
References: <20240823100707.6699-1-peter.wang@mediatek.com>
 <20240823100707.6699-3-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240823100707.6699-3-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/23/24 3:07 AM, peter.wang@mediatek.com wrote:
> In mcq mode gerneal case, cq (head/tail) poniter is same as
> sq pointer (head/tail) if the hwq is empty.

poniter -> pointer

Thanks,

Bart.
