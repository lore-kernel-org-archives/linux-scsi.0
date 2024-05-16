Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176D9147C6E;
	Thu, 16 May 2024 14:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715868769; cv=none; b=mLeBH0hgBotHZdYugUJgqFKDlBbnqw5hAEzijRbAIDj34iSl5X1mETs5YEik4KKl2sw+20TnHfnTOAvCfG6W6cj5+UI19jEKnN55pKqXmPLikCSs/xJmrgZ+4GjbYe2V3Kdlbnduqgy83sziETIrukz5ZDf9Tac5nxcRpkMIyKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715868769; c=relaxed/simple;
	bh=Ojt3pjOCn0RbAGr2ayZl+L4kVqTQUmhctn6BUkSoUu4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p2Obrdufw4FQPNQ5pCygVfqV+qCGLuVqW2ajznwJOLJhoO/Y2lZKzYlbP2P491sII/wy82/MisisIm0hA0g5rMidFawcvurk4ZgV+0U1wTgxgoWqqpRiOaCIOcBeFPPByhb3d55jdjM6GGgFKZoIZ/7mqyMUwxs7z4T+VnFaf+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ysihGnLM; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ysihGnLM"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VgBrH40hfzlgMVL;
	Thu, 16 May 2024 14:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1715868765; x=1718460766; bh=4E23K/E1QtmA+PPs5r5aUQ3M
	7ln8vX71SiSe+oC10Aw=; b=ysihGnLMHCZn4B8wPShxfqEh5u2/Yst5fJGFhv2P
	2bbvQP3k9dzEweOFFpeLMM2lngies39mnX59UG8TD7GQbqybHj27ORpMUJ5H0FZ7
	3cACq2Y4Z/Yu5bnzXRJxqQVX+gJ7vJCqkOyc/HeSyNYGW6uUmP+ZWEHO1JClen2e
	EUPYVp0U7xJIbN1220UwK9JIpQVK44kld9Ve1q63pSdpFuztiJsUia8ebJrsinWW
	zNVOLz5X/R9HcPuuba95sOJIB4pjz4EXAvDfYMDbsYd5Vxn6TcKIHcRprLSpnjeR
	+vDsYOVpmlJUUX3D5OwIAL0nNzz8s4qwDGdtTQGA+7KqgQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id u_wCCydG-Q_S; Thu, 16 May 2024 14:12:45 +0000 (UTC)
Received: from [172.20.0.79] (unknown [8.9.45.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VgBrD723vzlgT1K;
	Thu, 16 May 2024 14:12:44 +0000 (UTC)
Message-ID: <e6a5c633-7de5-44bf-af1a-ead577d079e6@acm.org>
Date: Thu, 16 May 2024 08:12:39 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] scsi: ufs: Allow platform vendors to set rtt
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240516055124.24490-1-avri.altman@wdc.com>
 <20240516055124.24490-3-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240516055124.24490-3-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/24 23:51, Avri Altman wrote:
> Allow platform vendors to take precedence having their own rtt
> negotiation mechanism.  This makes sense because the host controller's
> nortt characteristic may defer among vendors.

defer -> vary?

> +	void	(*rtt_set)(struct ufs_hba *hba, u8 *desc_buf);

Please change "rtt_set" into "set_rtt" such that the word order matches
the regular word order in the English language.

Thanks,

Bart.

