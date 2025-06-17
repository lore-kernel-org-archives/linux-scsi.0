Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76AD2EF9C7;
	Tue, 17 Jun 2025 20:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750193066; cv=none; b=ZeVLG71I660OcbvkGLffWBT5ITp3Rw73QnzIBPX1DAg+5uUCtgDciWl3H+knWnoQ7yEJOm+GCLdn3KuEr93IzIbDhWWC/+2IhqfHQnQIuCWWunzOH9z2soCXfRBsPf2K7V1t/EysnA+agtgeEEdbxmbn+P8HNbWC0EpLkpijfdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750193066; c=relaxed/simple;
	bh=NenoU6iJEOzpUiP+jsIKZvLpP3TvdBXNqcmpwU2kdYk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fO+jkmvhfTz8iZrAcza3SLKz2xF9IHc7BQwDk6G/tTzeWkQP48U5KkJ1PcDj1RjQZ7V/GkBJzLfdzAU4zF5jnTcdOc4RLIPAy2JeuUkUCAdXLJMlfn8a+jLlsEfpJAUWJ676FIER/CHCuNUqToc/oJAYKuODolwUlov/wOr1LA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zDH400Cg; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zDH400Cg"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bMJkn6z8qzm1HbT;
	Tue, 17 Jun 2025 20:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1750193056; x=1752785057; bh=mXfic0ItqVeP4UWsBKuKWGxL
	90Cx/yU9vDDLjBUlkbA=; b=zDH400CgWpACsxBmkw4yU6WG7quKVjwGhzRTuE6p
	MDYGIHZFgTISrbkntnw6Vu3iHyG/Bs7kUR5uidTP755lUQp3ub7yIF5sYZIDe0SP
	2nwcIBAVTHLBjGQZEdXJebQaMrudFfY5CXsnCB2Ylx/EWCkHmN7J19YgM1mRAdEv
	B71IEolwc4utFahlLYBoDtu18C40L8FO4P56i8Z6kVIk6hzNAyHqj3NdxKJjql2F
	045qJHCPAN2nkBx29m9P4d/52i0IOMYdDh83SwDwiCdCVq50ioH3hu6LumWL4fEi
	FDHwOhdVz3KnV5hzhHCBv5SvG56TRk5Ty2Sq5U3oDtB4jA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 28xjMBXV75lE; Tue, 17 Jun 2025 20:44:16 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bMJkh5411zm0yVb;
	Tue, 17 Jun 2025 20:44:11 +0000 (UTC)
Message-ID: <07c4c84d-0c52-4843-b32d-6806e58892fe@acm.org>
Date: Tue, 17 Jun 2025 13:44:10 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: fix out of bounds error in /drivers/scsi
To: jackysliu <1972843537@qq.com>, James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <tencent_BD16D2DE705D6E27FC5B93ECDEEF9A7B5009@qq.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <tencent_BD16D2DE705D6E27FC5B93ECDEEF9A7B5009@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/17/25 2:03 AM, jackysliu wrote:
> Out-of-bounds vulnerability found in ./drivers/scsi/sd.c,
> sd_read_block_limits_ext Function Due to Unreasonable boundary checks.
> Out-of-bounds read vulnerability exists in the
> Linux kernel's SCSI disk driver (./drivers/scsi/sd.c).
> The flaw occurs in the sd_read_block_limits_ext function
>   when processing Vital Product Data (VPD) page B7 (Block Limits Extension)
>   responses from storage devices
> 
> Signed-off-by: jackysliu <1972843537@qq.com>
> ---
>   drivers/scsi/sd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 3f6e87705b62..eeaa6af294b8 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3384,7 +3384,7 @@ static void sd_read_block_limits_ext(struct scsi_disk *sdkp)
>   
>   	rcu_read_lock();
>   	vpd = rcu_dereference(sdkp->device->vpd_pgb7);
> -	if (vpd && vpd->len >= 2)
> +	if (vpd && vpd->len >= 6)
>   		sdkp->rscs = vpd->data[5] & 1;
>   	rcu_read_unlock();
>   }

Fixes: and Cc: stable tags are missing. Please add these.

How has this been detected? Please mention this in the patch
description. When I wrote the above code I was assuming that vpd->len
represents the contents of the PAGE LENGTH field (bytes 2 and 3).
Apparently vpd->len is the length in bytes of the entire VPD page.

Thanks,

Bart.
