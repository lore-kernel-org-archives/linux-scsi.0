Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5741A2651;
	Wed,  9 Oct 2024 17:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728496787; cv=none; b=cDmrxiFvk+VRPW/SgsCBp/LcuyT2AuTvkJw8oko1edaM4cpO5U0fwiI9Y9T4+81oAc5i71ZAwmtTdfG2GpHpzdRr5MCVGsHyxDMPt3/P4UF1T0V0naf09Zx9dikQ4MoPrJr+26tVFS7qOxwbEOFQ9RUZWWdAO//TxnYBTKf+SU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728496787; c=relaxed/simple;
	bh=A8FLf6V4yhYuWHxakYl7wGgm6AgZdxYnrDZZ9Fhderc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z4gJGWeSbDZ98ywPoZH4/eFTzEWJXPAAh1cPLfYY8CKoGKjpbkcWs0mNJr9LkyWHdx0+71flRQIT9JMWMLYRzaa/DuhRxY0kqdJKVg3T/Y+EpNMMOXBKwqCx0o5nQQegP2Bz2+HxVJj9UthGBB+yyV2YcdCG2g96I+ztG8RJ0C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=eIitQHSq; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="eIitQHSq"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XP0yg24gHz6ClL9C;
	Wed,  9 Oct 2024 17:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1728496772; x=1731088773; bh=o486qkRTmFm5kVHy1JFWCG8u
	hHdivrYKhy+8m8fzBiA=; b=eIitQHSqyGw4bY2PL95rCyvMkA/zfDDa5a3oySod
	iTjXK53q8kKqdC99N0Q/5oFDtvT50Y8gaACyFLXDFK8nKEN4+y+PQ/SHa5U2SEBj
	a5tzviaH01H+6kNF+E4opRFwmuvaDHPQ/G13hNTs1KWfww/CZBfBWhgjIaksItTO
	rklH7uhTYMT7tzbJj8LuwSqtIzQ/fmhhgcNu9ZKmucgqQxp+Te/zW+4zKLWYnG0W
	F5/p7EXmFkymy0mRwv/1wKowcEH/M7GcaZZY9zGWd6RRX0qZprbmwiTVRaqdYE3L
	rvC8Vf7lQonO8oTSamsjgd9Vt7ixYLlTIyRR1QhVkr21mA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vSbDe1On-c5q; Wed,  9 Oct 2024 17:59:32 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XP0yQ5kLyz6ClL99;
	Wed,  9 Oct 2024 17:59:26 +0000 (UTC)
Message-ID: <53e04d93-63ff-456f-8bfa-8c68a136f580@acm.org>
Date: Wed, 9 Oct 2024 10:59:24 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/2] ufs: core: requeue aborted request
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com,
 quic_nguyenb@quicinc.com, stable@vger.kernel.org
References: <20241001091917.6917-1-peter.wang@mediatek.com>
 <20241001091917.6917-3-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241001091917.6917-3-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/1/24 2:19 AM, peter.wang@mediatek.com wrote:
> After the SQ cleanup fix, the CQ will receive a response with
> the corresponding tag marked as OCS: ABORTED. To align with
> the behavior of Legacy SDB mode, the handling of OCS: ABORTED
> has been changed to match that of OCS_INVALID_COMMAND_STATUS
> (SDB), with both returning a SCSI result of DID_REQUEUE.
> 
> Furthermore, the workaround implemented before the SQ cleanup
> fix can be removed.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
