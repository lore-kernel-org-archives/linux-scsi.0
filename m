Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E58287253
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 21:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758750990; cv=none; b=uzZIWb9IBstyZdT6YWSwfwL0kPlernekdyjhPyxpC+fXB1vWIVDA80KFwQ1xTGWtxJGDyWkQSHnKuthroSSaqRtrw20oA/gTqfs8ITas9Z8nA9XYG0q245/bsgbQIIsZa+LbFDZkjCJripTWqEtCMpcBfIuDCVCxAawQovYCPuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758750990; c=relaxed/simple;
	bh=Tc33BGQmN5NZLK5xk6Rge4pyTPkIDaqJAXJTfQ5dWz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hbvN6P9bGcK6lWrJ2nJdXH8vti7n/kiX1OMzEHCHjn78qT7eYy4UVp6DYDe+ANOuCIMxogOT0ew/qBe/H6EY0hWGpqRwN1cbhubc7EAdEUc4FfXTLGJ34TSC+r3ArHYRugOpMoY2mdXK8qUPOtk6wL1U2kmH1c/D5oYRWQSooNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sS1Gpm3U; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sS1Gpm3U"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cX9fN3TFLzlgqy8;
	Wed, 24 Sep 2025 21:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758750985; x=1761342986; bh=Tc33BGQmN5NZLK5xk6Rge4py
	TPkIDaqJAXJTfQ5dWz0=; b=sS1Gpm3UWA+EoIgFSBh1DFjJBChVEqtgR4knoGan
	dFSh9ovSJHEB8RFiCwQ+ohS77A0bOSQ+fvS/AFfO2TqPRl/yZHV+3xUo4+PdmgOZ
	M0nLqhZ+4GlwDaHdbpRx0EqBoqrXDngN1TJvSghpbsTo9TeBiEcrMZY6kb3sE4gg
	TXVzBdpMMctvSCO2FnH2JyMBeKYcXZD2mNrDq60PyvFtwjlL0v0lXRvWJZgPOX0a
	1tDjcXhXGVsHB0ZMTkZfVNeBoPEH0bj5MV+HSBf3CziFHXVHNB6UJdJ8eVodGOv3
	RDZQhqAh3lXNxw1l0rOf2uoT8AvVO4p3KPCgyY6wgKDwtg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ss87GujbnOcl; Wed, 24 Sep 2025 21:56:25 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cX9f51MgmzlgqTv;
	Wed, 24 Sep 2025 21:56:12 +0000 (UTC)
Message-ID: <eb79d807-c036-4c25-9da1-72899da8069c@acm.org>
Date: Wed, 24 Sep 2025 14:56:11 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/8] ufs: host: mediatek: Correct clock scaling with PM
 QoS flow
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250924094527.2992256-1-peter.wang@mediatek.com>
 <20250924094527.2992256-2-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250924094527.2992256-2-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/24/25 2:43 AM, peter.wang@mediatek.com wrote:
> Correct clock scaling with PM QoS during suspend and resume.
> Ensure PM QoS is released during suspend if scaling up and
> re-applied after resume. This prevents performance issues
> and maintains proper power management.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
