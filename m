Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33683FBAD;
	Thu,  4 Jul 2024 17:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720115032; cv=none; b=iiFUdHXwq+OsOMoJ7N+xwWdPF70L/oathrlQqNzOi/ri1olW1qiFlsyUI0k6Wrg7VSnik1RL/0uTxEo/a3YJuDF62mIO1BL9rOzkkkWA9eKiKTwg9k4gTX2MYfblC4VVQX5roZI7xWUjEsCADqpjyEIY1J5SJGO6X3RgH9re+Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720115032; c=relaxed/simple;
	bh=+9lEm9eDcxA92FnC9ULOsZ45lMCXaMG10cE7k/rfHQE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DjTxnRV2CT4bPAej8sCoTLZAcAJdR/wllbP1oHDBOdwzvt5X0nUAX6k8L53NPZtrufHGzlf4vEKaGnvyaOlrYP5sBs4eU7KDM3Z4DjBZyGFuC2AY6KarIgcp5y7cNUVexyw7M14IjPxrHza0GyrN2DkX7pQULo1+mL01F46ytSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Pd77tDMe; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Pd77tDMe"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WFPCB2D2xzllCSD;
	Thu,  4 Jul 2024 17:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1720115028; x=1722707029; bh=4i8/na1KXtmg1Gp1AoFkVeiu
	WhkPo3TuxBePA0hiL8k=; b=Pd77tDMeIvMmOBIMGD9fZTQoAwqV9CAxWH0u3JfT
	d5jKcz807ov0mSyAzbPncb2OkIOgqZlA09Fr6I97RDZZ4/Om3mYXsUjWyVCdYrcG
	8pAWbUxTH2SG5hc9aXd+pFgggOmYTi4wP4s12eDoh/X44JXDZED8txfiQD8d3EJQ
	uiEudXJB5DRUPkviIWe0w4n/iR9x3j2rNe/Bno0Um14O0oFPR4AdpCDxo/PNNBMg
	aNM67HJXZZh4pW+Yrt1Z/bATmrhVlAdzv6gl7o1EeirfzNiKGGiEIt9wvfof2j2P
	8CC+oRi6CVmdfONM6fWjqUqSE8mOki5G4LKeo+vO0Bomuw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GyhQnC1Ol5-y; Thu,  4 Jul 2024 17:43:48 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WFPC66xMlzllCS9;
	Thu,  4 Jul 2024 17:43:46 +0000 (UTC)
Message-ID: <6183a803-ced8-48f8-abb5-3fcfab055bfa@acm.org>
Date: Thu, 4 Jul 2024 10:43:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v2] scsi: sd: Fix unsigned expression compared with
 zero in sd_spinup_disk()
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
 James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
 Mike Christie <michael.christie@oracle.com>
References: <20240704031437.33338-1-jiapeng.chong@linux.alibaba.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240704031437.33338-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/24 8:14 PM, Jiapeng Chong wrote:
> The return value from the call to scsi_execute_cmd() is int. However, the
> return value is being assigned to an unsigned int variable 'the_result',
> so making 'the_result' an int.
> 
> ./drivers/scsi/sd.c:2333:6-16: WARNING: Unsigned expression compared with zero: the_result > 0.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=9463
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

The following is missing from this patch:
- An explanation of why this patch fixes a read of uninitialized data.
- Fixed: and Cc: stable tags.

Thanks,

Bart.
