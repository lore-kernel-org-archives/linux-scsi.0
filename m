Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBB21C6899;
	Wed, 29 May 2024 20:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717013019; cv=none; b=TMp8dcA1JF54xwvVDMvkN07jYA99+MosRw1XfP7Th3yfsoSAA7ZwJ+koDm4K5HWoP/h+DvaZQZLeZal+fmWZzRrrN2PaLhHTiTp/rnInhrZ8OtzJqMB5n2Wlz1e8RuVhBkLusoM+Q/gR6dRRMgJXCqw/AZ+i3BRamEMbwTxVZUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717013019; c=relaxed/simple;
	bh=p0av47TaShiR61FN40gZoXyYyrFAYBICVnp0j1ey7u8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b3ROXojOV8wmuvU0Bj92WjeP5QrQk8WET96K5VnQkvS9KeN/ZHFCxQF8+mU7+GM7ofo4d5c66utljYhVnHeMLtEeU0EyPo/TQZBG+nc5bVgLedXztsqI/SuG1yLr8QTSUMWSNTt4ABcgF437HKbS9wCBQWuxoie8rY9g6zNUfao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=v1/pFV2k; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="v1/pFV2k"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VqL0z1JJLzlgMVR;
	Wed, 29 May 2024 20:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717013009; x=1719605010; bh=LKEg5H1dDGROJ86EFwGm1wWg
	YY1kka+ujq1KzN58Xfw=; b=v1/pFV2kN4XkzgtPwBD0INJPraLHuN4SF4bNSnm5
	sN7JMiuIkfRpuYfHLPBnJZarMFruFP0JDkYh7NLGw2hs7J58yeOxP/oP7Wx1ujm5
	FRkV1+uFl/t9/gSRB00Q1cU0hIMeBpo+x/cXSAaRBKfbb3SG4i7VLc84CpLiVcaS
	fwJOXCzIkGvyzmJkzE0ceN5GEkHh2ceRWfmfvFlidR3ESccw2GXYZODUQhIZYGYe
	DWRhoQcrVTmkVhD5RufzpbwQY0Ikx6DK0j+pive95FFiBbsSIj/zGGTkVd+2h4mG
	KVCp+Z/u0jVXm7ndf+dn7OwTbqUHJZUIjqRjv60GPeKieg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Zr4w4ZJVC6KK; Wed, 29 May 2024 20:03:29 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VqL0v5PR5zlgMVP;
	Wed, 29 May 2024 20:03:27 +0000 (UTC)
Message-ID: <9c066dfb-b84b-49fc-94da-806b71e261d1@acm.org>
Date: Wed, 29 May 2024 13:03:26 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/3] scsi: ufs: Allow RTT negotiation
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240526081636.2064-1-avri.altman@wdc.com>
 <20240526081636.2064-2-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240526081636.2064-2-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/26/24 01:16, Avri Altman wrote:
> The rtt-upiu packets precede any data-out upiu packets, thus
> synchronizing the data input to the device: this mostly applies to write
> operations, but there are other operations that requires rtt as well.
> 
> There are several rules binding this rtt - data-out dialog, specifically
> There can be at most outstanding bMaxNumOfRTT such packets.  This might
> have an effect on write performance (sequential write in particular), as
> each data-out upiu must wait for its rtt sibling.
> 
> UFSHCI expects bMaxNumOfRTT to be min(bDeviceRTTCap, NORTT). However,
> as of today, there does not appears to be no-one who sets it: not the
> host controller nor the driver.  It wasn't an issue up to now:
> bMaxNumOfRTT is set to 2 after manufacturing, and wasn't limiting the
> write performance.
> 
> UFS4.0, and specifically gear 5 changes this, and requires the device to
> be more attentive.  This doesn't come free - the device has to allocate
> more resources to that end, but the sequential write performance
> improvement is significant. Early measurements shows 25% gain when
> moving from rtt 2 to 9. Therefore, set bMaxNumOfRTT to be
> min(bDeviceRTTCap, NORTT) as UFSHCI expects.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
