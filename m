Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDC72F3C03
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 15:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752679376; cv=none; b=PEXAlKjp9JmRQSb1oQPegau5NAmFAcMf0EwXdVPnoDo8I5SiCFQOrvpDkk+4z68XOR6MgBEYTiJseYtE9XMz9jZgPDS9gIxtmgcoDnBdmK+MUKgb59oQpL/e1X/zDCOvnFzbOpFEm0PP7brEB7Z4UH9U5ITBtBdDTDc27fMh9gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752679376; c=relaxed/simple;
	bh=YtvtQ3trCIAKwj49MAGge44r3bdrA49Us6Pi47bFfEQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CdFFWf4j6PbCQbM5ITvRMPCi/qZp4dy/32J/y7SYnSYrCsa8LkmWnLRszpBmo1sjNDjZjALPDg1hnxHoHm08YKxmYav1U9YGsV3T7uC70uhweB+0Hwqgfd9R5zzotvrGEl6tM2IcF2nHlTIMyQNaHjnMAWGWhYN6Byl6rNI3q6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gu0eO/SM; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gu0eO/SM"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bj0DY3kjLzm0jw2;
	Wed, 16 Jul 2025 15:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752679370; x=1755271371; bh=C4GE33CgQ2bpHUiDwA1SuAmt
	uBpcGtsm8Gn0Quu2O7I=; b=gu0eO/SMvTj/F9ny2RwtZDCEJFqikqhe1HM3WNl5
	uVmfxt3sK0842mHnxqpXuCZ0F4ndOyiSBtpqS4MG0s4ifi8LWAlgDuZhmvcw33xS
	cocDQ+d/kpKiY7lK4O2PP7Z6dANpD2FaAPQFZERwl5BtUjnASRntzG5Giu3Mf0C+
	sjPwUPjIURBwqpBtXsJL4+NuCkcJEBB2P4XlhBhPO9WpnpyOenz2MS54x93LwJKX
	Z/I3KsPjpeVTO2zTAKYrEroVa2aoRc2HANGaJYcjvuYiwZCKpE4J5uHpSEQmWD/A
	IQkfCB8RxtKxtZXv7W/d/VqJzePt670b6m2ow0PntQpIFw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4EmoW36kRg-e; Wed, 16 Jul 2025 15:22:50 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bj0DD30bCzm174m;
	Wed, 16 Jul 2025 15:22:35 +0000 (UTC)
Message-ID: <9aafec2c-199a-4373-bdb1-6031f574af6d@acm.org>
Date: Wed, 16 Jul 2025 08:22:34 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 02/10] ufs: host: mediatek: Add DDR_EN setting
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250716062830.3712487-1-peter.wang@mediatek.com>
 <20250716062830.3712487-3-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250716062830.3712487-3-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/25 11:25 PM, peter.wang@mediatek.com wrote:
> On MT6989 and later platforms, control of DDR_EN has been switched from
> SPM to EMI. To prevent abnormal access to DRAM, it is necessary to wait
> for 'ddren_ack' or assert 'ddren_urgent' after sending 'ddren_req'.
> 
> This patch introduces the DDR_EN configuration in the UFS initialization
> flow, utilizing the assertion of 'ddren_urgent' to maintain performance.

What is SPM? What is EMI? What is DDR_EN? Please expand these acronyms.

> +/* UFS MTK ip version value */
> +enum {
> +	/* UFS 3.1 */
> +	IP_VER_MT6878    = 0x10420200,
> +
> +	/* UFS 4.0 */
> +	IP_VER_MT6897    = 0x10440000,
> +	IP_VER_MT6989    = 0x10450000,
> +
> +	IP_VER_NONE      = 0xFFFFFFFF
> +};

How can MediaTek IP versions be related to the UFS standard? Should
"UFS" perhaps be changed into "UFSHCI" in the above comments?

Thanks,

Bart.
