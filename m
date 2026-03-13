Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11AD2313267;
	Fri, 13 Mar 2026 15:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773416240; cv=none; b=gIcz/v+rIlmhcH1CaVoUY0/6lNkklzm+MetyQqQrR2UoD9Z7ivFfJOr81jzyXSyfplQcGPcpDsSDMQYq2lhRlj61I+DM3ToXihsEm11k6URQJ5OJwBhFQmHS74h/ovLkjJTGWY6i4GNYUFxp18EmrxVH3PnUNbCWILsaS6IbdZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773416240; c=relaxed/simple;
	bh=Lq4Cs/UjN1YYM3lxwRR6FuodfhjXJFuFV3Kw6ipIAkc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fj9sFJBRbbaPEg4d/jfeFR85ycnJV62yqJjoFVqMXLOCn6Xd4zSkHK9i3KUhXgd98rf0jTC3nXCLb3fFVGMwVpKl6yaVyMaoXMR1VmXR/vUeHG+/jbQ0RcsJs+oH+Gxl4WNQgGPTJtEqdH6jbAZYZKnz9lxPTsBp//sTnLUbw9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VRBu+av4; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VRBu+av4"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fXTBQ4k3Zzlfc9G;
	Fri, 13 Mar 2026 15:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773416235; x=1776008236; bh=fwTlrE7W9YlBzE45EbCXgLTg
	NZlbjMPq9I9sC+Dm/60=; b=VRBu+av4bYn5bysWUCRxbRTOP8knMpQH8sjMdbvN
	cURXi3mYoDlPtFv7mXLDTXh6/2doiNcYNsuxAG1rtC6di+Wb6QFvGpjftSR+J34E
	h9R3i844wX9+U0ytLX9DkDPO2N/NwFjXYRsesDrC8EcDeVBhBSqjkT02oO/Cmtqx
	ambtUXq1gyyD+Z9NnuScwobnoy9hkacMQwpU6IfTnPSmx/WCOKO+C4+DZuMKMsT3
	Cg14NPCj3KzvV5nUN7/vjUuAdVsYCL2dLdNN2Thi7Jfv/Zc1IC1DbdoX0gyYEPTX
	LVsbNAgcBQM+lq2fHPH4I75PXdrMSFfywSWVGIjgiwXxoA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mhVwUa2RWWsM; Fri, 13 Mar 2026 15:37:15 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fXTBK5Xtczlfc9C;
	Fri, 13 Mar 2026 15:37:13 +0000 (UTC)
Message-ID: <aa1e0517-3b90-4c14-aaac-d0f9526e088d@acm.org>
Date: Fri, 13 Mar 2026 08:37:13 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/3] scsi: bsg: add io_uring passthrough handler
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: axboe@kernel.dk, fujita.tomonori@lab.ntt.co.jp,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20260312092237.2464560-1-yangxiuwei@kylinos.cn>
 <20260312092237.2464560-4-yangxiuwei@kylinos.cn>
 <e6167003-82e4-4814-9e11-d1609681b5a9@acm.org>
 <20260313073415.102437-3-yangxiuwei@kylinos.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260313073415.102437-3-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/13/26 12:34 AM, Yang Xiuwei wrote:
> In particular, when there is a
> tension between keeping the reverse Christmas tree order and making
> data/control dependencies explicit in the declaration order, I would
> very much appreciate your advice on how to handle such cases, so that I
> can do better here and in future patches.

I think that combining declarations and initializations is considered 
more important than strictly ordering declarations from longest to
shortest.

Thanks,

Bart.
