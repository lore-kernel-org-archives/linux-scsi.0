Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB37E15574E;
	Wed, 23 Oct 2024 19:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729712070; cv=none; b=HGafBLnODTPPkXzl1eIcLbofO/3sL90ZlzwGX4eD5JwqsJszP++33pyCjgt8ZhWU5Yv39MW+4psiezcY5ACiQFpYOnF9r4/B/vJTtrDTRW41ncrxk1airtmaVIcvzFJqCXb36d7EKngqrc5+3vpcZ4f2EIpQbgzP34oXHCWSBJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729712070; c=relaxed/simple;
	bh=/8D3WOgwZvNkLo5HSlS3lC/gZ1W4ruG1/qLQOlw0EO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CQOql/jF5HW3kkpKrIh/3mzoJqIH6+kC+OT5Y+2RpeKwjzyfMdSY5fEWguKggQuFOqHn8tW33RE4vy1WsXZx42qlip0dhcVlwNpO+/ixDmXZfFn4Os1vWxrw0jiaJBjnv2JGWO+EjW+8p2YXGqW4CmXOXXkIH81VCUv0wtM3F3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nGEVIbuC; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nGEVIbuC"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XYfPT0CMDz6ClY8x;
	Wed, 23 Oct 2024 19:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729712052; x=1732304053; bh=UGZNZ2BEBqO2PQX0Ox1H5dzx
	ZcADvb4w3SzhgMbYpks=; b=nGEVIbuC1gcaUni7Fn93l2J36pDTnraKOmMNXw18
	bGY7GBjekfxniPcbjAeC4fFzlMBaoNcmplRA/LgN72zZM8R208C/Xr+B23UV5zVV
	S5BcnJXLg1beukAiT3JdMgnDe7VmKkEhBbFiGGXqWfAX25MoeMLuoveLZ7PS9Ivq
	q5JXmw4mt4p0EBXMsJi5+PipZd6Fyfd0WY6G+ijJh3F07zkORnLypI4IpXLeT3Kt
	Ad4Hl+l0ahKvI5A5l9C+voDUh+Fi6O/fczbJDUqPszKYP7HJnagtJkncWCsSChnB
	vlysbViqf2bgBcU1sbPKagtu/v7fWJW3U7/8++m1fRqc2Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9ptD4NLkaz8m; Wed, 23 Oct 2024 19:34:12 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XYfPG4mn0z6ClY9V;
	Wed, 23 Oct 2024 19:34:10 +0000 (UTC)
Message-ID: <9805c64f-70ab-4693-aa49-b3659ebb38be@acm.org>
Date: Wed, 23 Oct 2024 12:34:10 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: fix another deadlock when rtc update
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com, beanhuo@micron.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com, stable@vger.kernel.org
References: <20241023131904.9749-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241023131904.9749-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 10/23/24 6:19 AM, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> When ufshcd_rtc_work calls ufshcd_rpm_put_sync and the pm's
> usage_count is 0, it will enter the runtime suspend callback.
> However, the runtime suspend callback will wait to flush
> ufshcd_rtc_work, causing a deadlock.
> Replacing ufshcd_rpm_put_sync with ufshcd_rpm_put can avoid
> the deadlock.
> 
> Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")
> Cc: <stable@vger.kernel.org> 6.11.x
> 
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>

No blank lines in the tags section please. Additionally, a hash sign
(#) is missing between "<stable@vger.kernel.org>" and "6.11.x".
Otherwise this patch looks good to me. Hence:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
