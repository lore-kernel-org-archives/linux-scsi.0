Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B4B20CCE4
	for <linux-scsi@vger.kernel.org>; Tue, 26 Aug 2025 15:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756220826; cv=none; b=qH+hRgdhb9pBG5Bev5Sz/7lmsE8aByKemLXJ9XO6asPO3A9U4CDB+MsLfmz9BvCtASgvy7+jCGmncj1PZSFwkhZm0FpIEi9Aheb0L2qS2aJQf/FISt9qh9hlMD906b1olmszmlNtis2rWRR9IASqv1DRm+Iie/7KWXSAUA8ggAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756220826; c=relaxed/simple;
	bh=Vluf0lRThdc/XPN/J3in6of1bo6pzNAGErsCGqniwT0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eBqGVEThCSGJsrxmdaarV+46+g52f+7CqlVCvkFOJ51GDbQFuhPko3rF4A3S1DKce+GERPT2OFudERXNLmZx6/YrUqmgl06cioOQSCHQP08xUbQM/gqfGLXMpiBrfWH9LmH1J32zefduHn7Q9ARBSeBk/Lrf2GfGN4Y8qtkVM5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bQf77qhy; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bQf77qhy"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cB9xG3S53zlgqy9;
	Tue, 26 Aug 2025 15:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1756220815; x=1758812816; bh=Vluf0lRThdc/XPN/J3in6of1
	bo6pzNAGErsCGqniwT0=; b=bQf77qhyeI0134ORqxWpuJBTSV3XFwdb1jcp5+Yk
	D25WWJ5L2O+CJlgGTgX4+lmpC5NPir+4leGnKbbpwPDh5dqhb/+qUFaGlpmuLP3F
	PymQL+GHk0g4FfPkj4uZaIlOydxAqoke4dDGc8plQFl3aK4Pbbc8AUCOLCn/Zjca
	VT/GRYldJJtmW/WjPU0mcoGrvn6w4qH1K4Cm/fCpcg0U334LXCZT9i+2eSLLqyCl
	xtWzQkXRKEh09vefL38gDSkJjHdMhMGRmIdpkwsube7m0+9654kVqbEVZkCT8kNz
	JvMYY8ACpYtM3mj39dyztvJbm1h6wfGcTW5Bu+6/7Cgswg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6i5KAFw-Wt05; Tue, 26 Aug 2025 15:06:55 +0000 (UTC)
Received: from [172.20.6.188] (unknown [208.98.210.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cB9wn0GPFzlrnQ0;
	Tue, 26 Aug 2025 15:06:31 +0000 (UTC)
Message-ID: <ec57c49f-dc4d-49ef-a350-20b992d29487@acm.org>
Date: Tue, 26 Aug 2025 08:06:25 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/10] ufs: host: mediatek: Enhance recovery on
 hibernation exit failure
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com, sanjeev.y@mediatek.com
References: <20250826062314.3070425-1-peter.wang@mediatek.com>
 <20250826062314.3070425-2-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250826062314.3070425-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/25 11:22 PM, peter.wang@mediatek.com wrote:
> This patch improves the recovery process when exiting hibernation
> mode fails. It triggers the error handler and breaks the suspend
> operation, ensuring that the system can recover from hibernation
> errors more effectively. The error handling mechanism is activated
> by setting 'force_reset' and scheduling the error handler work.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
