Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3A13112DC
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 18:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770748886; cv=none; b=nDHd8EUEX6cN7/KyM3SOc+LRRYxZmOI1jTQWLpRDaIICgQWJ2tyZSydb+sDHo2Dzn979Ue567jo9+z+9YofnTSX1sEYKvg38AJkdAlLWcOJSH56eAe6qq9TKGwdGJgcx+8W4oyDeY/hj/yAH0+ZVgnwZ3GG+uvWKbns1fc7v4L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770748886; c=relaxed/simple;
	bh=GvDSLzhqfBnDBJx1xAR+BW2sz49JtwEz8GcVsJZBELM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qglQOUssvwT4MUiWlT9UpUGZAJqRR9YsiiVOcTWTlgKRANy+S9hV9j9zYqUdACjMHWbzh8hP+g732b09Q6X6oJ08zj25sFklQPz8IMRaYTQxKD3xZ9YpHIbNNjsUkrm2dYDj65PDVuaSAg+1qyS6p2K6clFpVjibdasNn1yYFKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jWXF9ghg; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jWXF9ghg"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4f9Vl91T09zlfl6P;
	Tue, 10 Feb 2026 18:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1770748882; x=1773340883; bh=GvDSLzhqfBnDBJx1xAR+BW2s
	z49JtwEz8GcVsJZBELM=; b=jWXF9ghgA3XfZ70rSx1Sz/9RGKoa+NK6zvNqEdZV
	WrKWTOTZayjbUKJtd0/Y+UWwoOgzLBZO9uhSf7CUIetMNhamLQk8/NIpCFtyHLUu
	XLmfXLRkMugY+BiLyCo0Z0LECWpngllRlQY1OzIfsasYIS3qxMEbNoQAtZOp8mFa
	jLstRoFo5gjpbrPiMctdD8bfwag7xaiIWIZ6ilF4Ur28kroyFW37PCYk+Jne8p84
	0Gz1ei4jKyHKs41agjrlNgdqMaUPK0USgGjkUxNdOSmNnwGmvUu8SD/5iIxpljkC
	usdz6JmwgoxAP4sUVHkZvwHdjI7akf4/TgvuaLk/rDEPOA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PKYxIdbrF1ip; Tue, 10 Feb 2026 18:41:22 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4f9Vl13krZzlfvpH;
	Tue, 10 Feb 2026 18:41:17 +0000 (UTC)
Message-ID: <fbf4c8e9-bf51-4607-be30-8c3ba2af3d86@acm.org>
Date: Tue, 10 Feb 2026 10:41:15 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: support UFSHCI 4.1 CQ entry tag
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@sandisk.com,
 alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com
References: <20260210071834.1837878-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260210071834.1837878-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/9/26 11:17 PM, peter.wang@mediatek.com wrote:
> The UFSHCI 4.1 specification introduces a new completion queue(CQ)
> entry format, allowing the tag to be obtained directly.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
