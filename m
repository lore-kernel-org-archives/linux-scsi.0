Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6989B1F0E26;
	Tue, 15 Jul 2025 13:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752584415; cv=none; b=bJOfiH91IzRYluDM5zW8zifiHwT2Nlt95u2X3YUjSF0KKxi8LjY9usgOJTbmFCgXnKaQAcYZe23ILuvnJrCQASmLN6/0SIn97w1VYpGTGrrkmma3z2AuFFajUaNhGFNIQ+6gem7wgQTP3HmmtKVOXiYi/DLWl+j1CNx7IQnH/m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752584415; c=relaxed/simple;
	bh=bTgdlisDBxZUmyTjHe9oE8WUHatc7nxNQ7Snosr/Feo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hXn6DttZv8LwNOJbHTw5YObCeWEvTC1pu7vRxaxFBmocJNrhbwaTO+ZfPviqLsiIofEPWJcbGfXjr2o3hcVSFkcBD+wHf8iPdGQwzMev7hMWw58xBByo2LfooQii1bhQqQjm3oV6c4l1y8Wwt/ClIwqrzoDSEX45x6LCfS/Zurw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=PkzN33od; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="PkzN33od"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bhK6M2WQQzlgqVm;
	Tue, 15 Jul 2025 13:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1752584410; x=1755176411; bh=3uty3ldef8Zkk8C4JM0Hq8I8
	V/OYg42j0oA7P77gR/o=; b=PkzN33odJy4YZ1BYQpwRGM0ZlV202CYKoicnPABf
	XyeIxhPxuD1bOvnvZLr2XJqEib/0mA9lqt9bj+oImufk8Nm9y8nlJyxZDCNXNSs1
	RW/FKfn7FFNG5f2HXRmpTYq9nVv5z7POy4PmcsMFFZp8dQjcAkWULIsj0tvPe9kq
	0eE1iCr0sWlBzDtfH4pJUV5yC5R4v4G8TUiQ9PXvluWEzh+wUCWxqGxaco4+UPUU
	KW2DS4gnTOB3k9jSueGB/9COtpyp3NOdHUXY0he0LPohHatJVuoE8K8M2t+cJQOb
	cVdk7HAha0Gtz70SXGmR3wzvrr40PSlEmPaBQEYem1OttA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id BwVRm5Kb9BEW; Tue, 15 Jul 2025 13:00:10 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bhK6F1KcWzlgqVB;
	Tue, 15 Jul 2025 13:00:03 +0000 (UTC)
Message-ID: <bf166912-80ef-435e-885d-affce237afe7@acm.org>
Date: Tue, 15 Jul 2025 06:00:00 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: fix out of bounds error in /drivers/scsi
To: jackysliu <1972843537@qq.com>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com
References: <07c4c84d-0c52-4843-b32d-6806e58892fe@acm.org>
 <tencent_ADA5210D1317EEB6CD7F3DE9FE9DA4591D05@qq.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <tencent_ADA5210D1317EEB6CD7F3DE9FE9DA4591D05@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/18/25 9:03 PM, jackysliu wrote:
> 6.15-stable review patch, vulnerability exists since v6.9
> 
> Out-of-bounds vulnerability found in ./drivers/scsi/sd.c
> The vulnerability is found by  is found by Wukong-Agent
>   (formerly Tencent Woodpecker), a code security AI agent,
>   through static code analysis.
> 
> sd_read_block_limits_ext Function Due to Unreasonable boundary checks.
> Out-of-bounds read vulnerability exists in the
> Linux kernel's SCSI disk driver (./drivers/scsi/sd.c).
> The flaw occurs in the sd_read_block_limits_ext function
>   when processing Vital Product Data (VPD) page B7 (Block Limits Extension)
>   responses from storage devices
> 
> A maliciously crafted 4-byte VPD page (0xB7) would cause Out-of-Bounds
> Memory Read, leading to potential system Instability
> and Driver State Corruption.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
