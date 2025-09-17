Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BBD2F7AAE;
	Wed, 17 Sep 2025 16:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758126852; cv=none; b=mhZeVLTLSFP2DgZpY8IpxBPGBWsqyKRqyl113t60YP4Y4RgiESuiNXBL0aN0bg2bJt4vNn18OND1lMVzjVGy1yjF2AedDVXDLBd0aJRfHbmHwP54Hf9dVI/0izVkiiFNfOZ1yS1pkAj9qXDmOeetInDtYDY8XHM9Da/tT1dX8oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758126852; c=relaxed/simple;
	bh=aeS9l2tTCDKgWAxwJ8mToW14uNusa+g81dSkxQCfmxc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SwZz3sARu6sS8Oc4VdK44T1MTe8wGPNbZu87jwOUjc23ZbgNSQrIeaZH15slqG7Ba9osw5Nt+gEAKIm4r/0hxMKqw0kRoYvm3Rgo74I1hd374DgqrNROCUy7FSCIuP5Lyx0s3R3J9RNn0CRXAZTaSqxMaqXbhFtTTy2LhobqWz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1XDHKkGE; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1XDHKkGE"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cRkqc2FS0zm10gb;
	Wed, 17 Sep 2025 16:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758126840; x=1760718841; bh=aeS9l2tTCDKgWAxwJ8mToW14
	uNusa+g81dSkxQCfmxc=; b=1XDHKkGEGpHrx0LRQPUitQQsoYjNHCvGTCmMC+8a
	zCT/OcU6aMv3IPKhABXFh054g/KaC05SdTNGr8RARkk8EeoABSf6T2k6QHmI/xi7
	o5XzmiH0Asc0D7DL0f6qpa6Li2jt5UQN6VkCUaAByCEplKxcjaWpKTVM+Yea3G4P
	QAjqakWq1YT6g0LacZSLub3kd9leW6hyDkXXNfzCmVaN+jjlJw6tEmrmZnNj6VaY
	ofvhPY6zyoUFipog1/mFWzBPS3VZbT6WGKS6wURY7O+e7dfOdXjdhHOZft86NTxO
	vhxv+g93LuqHdTH05SUx061HGmGtQUjCDighAO7xxeCfkQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vvNpeq7vN_Z4; Wed, 17 Sep 2025 16:34:00 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cRkq72k82zm1744;
	Wed, 17 Sep 2025 16:33:37 +0000 (UTC)
Message-ID: <c276985b-dff1-48ea-a4b4-d9526b7dece6@acm.org>
Date: Wed, 17 Sep 2025 09:33:36 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: ufs: core: Fix data race in CPU latency PM QoS
 request handling
To: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: peter.wang@mediatek.com, tanghuan@vivo.com, liu.song13@zte.com.cn,
 quic_nguyenb@quicinc.com, viro@zeniv.linux.org.uk, huobean@gmail.com,
 adrian.hunter@intel.com, can.guo@oss.qualcomm.com, ebiggers@kernel.org,
 neil.armstrong@linaro.org, angelogioacchino.delregno@collabora.com,
 quic_narepall@quicinc.com, quic_mnaresh@quicinc.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 nitin.rawat@oss.qualcomm.com, ziqi.chen@oss.qualcomm.com
References: <20250917094143.88055-1-zhongqiu.han@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250917094143.88055-1-zhongqiu.han@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/17/25 2:41 AM, Zhongqiu Han wrote:
> This patch introduces a dedicated mutex to serialize PM QoS operations,
> preventing data races and ensuring safe access to PM QoS resources,
> including sysfs interface reads.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

