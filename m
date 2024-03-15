Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F6AC8C7
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 02:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710470217; cv=none; b=j/lUZ1WK/UuwY5yLGWX7psHHwPYUzrenYEILBixd1a8CFsonjvSKF4Q6cXQjSoUNwkikIiPvECm7TxdyXZmJ1Y027KDskr7GERzVj62FPMeTDj3SNf8DevWuMaGO2VuvFsDO2r1omaQKibxruC2CIpuTXS/d0kT1/pGKRcPOmKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710470217; c=relaxed/simple;
	bh=9Yh1Zjd9g1l5z0DieCBOoItaFXJ1TFyVCwC19BzRLDU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lkyW+BBi3YrYmZZ3sU7pqYdgS/BgJZmckvg1Y+faxUELuRWU7TimSR293sk4raF1VUWRckZZPAebQ4L7DEXT24y+kWVatsNbvC6fi/6VK9NT5RWh8wMrvLrqzTcrsfPwUxjAIhL2h5+5iUjV70QFpeWeSW5Bhd+rPwMl6nkLC68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jXORtcdh; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jXORtcdh"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4TwpKy6cMNzlgVnf;
	Fri, 15 Mar 2024 02:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1710470210; x=1713062211; bh=9Yh1Zjd9g1l5z0DieCBOoIta
	FXJ1TFyVCwC19BzRLDU=; b=jXORtcdhGTtXabEcXSXXSZ9jInO1dIGtsVwmaqTW
	VorDLUd4ullT6vCRQpzWhEKoeMFv/1KoMgTNGGsum27fJMvFW5PQCsbktM7Ybm05
	WiVfbDNoO1xqY7XltxBB7ALkv2IfBXAquVPVY2CrsPir2pF/1YRx76UWqOUjPiKM
	vHg9QGL4lqj1fjsY5twl4QYPX+Cp3GwI7jUqCFN8Cih6bf37Qfgxm/t/VdqK+LPV
	NryCXIXaDM0G5xEEGJHkSKUOZnftS/gBSTWDes4DcpROKm6Y+au29QDX+AqI2Y/D
	raHHPCwmA3mqGsYqG1GP9axlC+I4bOEqd60rW4nxa+yC6w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GLOsBDmVu1oD; Fri, 15 Mar 2024 02:36:50 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4TwpKm4bG7zlgVnW;
	Fri, 15 Mar 2024 02:36:44 +0000 (UTC)
Message-ID: <67a4a108-2fec-4e65-b6a5-024f3175b1ca@acm.org>
Date: Thu, 14 Mar 2024 19:36:42 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 4/7] ufs: host: mediatek: ufs mtk sip command
 reconstruct
Content-Language: en-US
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, chu.stanley@gmail.com
References: <20240308070241.9163-1-peter.wang@mediatek.com>
 <20240308070241.9163-5-peter.wang@mediatek.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240308070241.9163-5-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/7/24 23:02, peter.wang@mediatek.com wrote:
> +/*
> + * SiP commands
> + */

An additional comment that explains what "SiP" means would be welcome.

Thanks,

Bart.

