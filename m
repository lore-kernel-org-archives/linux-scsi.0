Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF61719C563
	for <linux-scsi@vger.kernel.org>; Wed,  9 Oct 2024 21:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728508769; cv=none; b=SW1t6hAxDHXMdaQ9uPGSuWSC/ETkf4u9fHw3Qs7gSc4Y10vly1YJWqXBq0saxGeMWQKxOxoFboHBdqlDYuyUIzvYQyqP6+k88dJOStgb79KvRKwqlk5DLdnSILgWKlAM7sfBpaCE6vLgH6ToxLX6oAEw1U+MIB1KQlypOLQ2Qp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728508769; c=relaxed/simple;
	bh=3FFXuGRCM9GaqNUBXGT7ueOebW8Mh6Wsfl6es2iDLWM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yo6kU4HmRlf3nMOUndQJzsEh76tqWNrEfCj5/oZB/8wTnAsUaE0zMztaRC0jyzNnvq91T0yKUDSAE8nqexLKfQ9I7Kd2f6cdrvFLC7lVnysxqyeMvbuHzeS4QmIiHDxm4XaxbDjjDI4ueOYzjHGHLJcXZfCKmolyAvyh2lYQ16o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=P6vz4PxG; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="P6vz4PxG"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XP5PC0F9HzlgTWK;
	Wed,  9 Oct 2024 21:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1728508764; x=1731100765; bh=/uelAca0vSWpdJdvCdPbLApy
	FCI6iCFhjCO4DMQ8Stk=; b=P6vz4PxGLQHOuuaIT6wdV8WyLfbIFVZLPpUwwIjW
	XTyRMq5z5KsQwesgEFMBntHFPBWteqrOoNbIJ9LzXKgxOJ5Zvv8kRsizh7Pt9cJX
	rvD+GR9h3L+qYj5G8C/Dx0gJR8cj/cyaxUOANLZzpDDcRCLCtNgPl+d9Uc5GE1S6
	BkiFKnvX+ikuA3A7NR0XtyiecPHJL/0EhLZP8qebwcEwjbyvZ42c+7bxLeCdEI8p
	NWsx04aIikWWxuNGhMZNDDrJBrv9lQVNbFVGkoMWn7Jlf+wNEWCzraBcclY1m5/v
	siDp5bfhbRPUouZ1uc6w8ePcjTtbOY0ILBlwqeBx6qQ9jA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NcdKAsinNmCg; Wed,  9 Oct 2024 21:19:24 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XP5P61yRCzlgTWG;
	Wed,  9 Oct 2024 21:19:21 +0000 (UTC)
Message-ID: <5a362252-449c-4169-aea1-d5a5e5781d2d@acm.org>
Date: Wed, 9 Oct 2024 14:19:20 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/10] scsi: ufs: core: Introduce
 ufshcd_process_device_init_result()
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>,
 Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>
References: <20240910215139.3352387-1-bvanassche@acm.org>
 <20240910215139.3352387-5-bvanassche@acm.org>
 <6a6c4497-4847-70a1-1f0f-45d071abe9f5@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6a6c4497-4847-70a1-1f0f-45d071abe9f5@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/24 9:31 PM, Bao D. Nguyen wrote:
> On 9/10/2024 2:50 PM, Bart Van Assche wrote:
> 
>> +/**
>> + * ufshcd_process_device_init_result - Process the 
>> ufshcd_device_init() result.
>> + * @hba: UFS host controller instance.
>> + * @start: time when the ufshcd_device_init() call started.
> 
> Replace @start with @device_init_start?

I will fix this.

Thanks,

Bart.

