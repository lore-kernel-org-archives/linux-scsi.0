Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177DD1E4A4
	for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 19:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719602890; cv=none; b=X3fUPo6AUSqEF4dR/RHPkGUJzfVXk2tnv5BVAwmKjrb6B5j4yejEnN+f8YQM7IzfmuiKJjzsTyKrhBf/JMko/DJcaI8EMxasJKKN85nAHSGAP4X6GalxF0us3PspOISay1hLn4CZGhMNyBdeCFkcs109g0fNzlU3olG4NOwTAYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719602890; c=relaxed/simple;
	bh=+qpuMMSkeufgGu35FNxkrwz1GzK/oHavTnmVx7Rejds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UuD2L5i4o2CmX0iCq/L/XUPRNWYr06AsqcB/F5eG1106KXGbuhj8xQ8X1/of9OsCGDphmFul6soB4Sfrx7tWRjEDvKa3vWAdj6IWD4TFNXZ1vBNrS+Za9OFi3BDyYDCneAlrsElpvG/FeZ8uMThbNUWSIfnFW7gRNqzsW2IW39M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ssxeoWq+; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ssxeoWq+"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W9lpJ4GQ6zlnPbk;
	Fri, 28 Jun 2024 19:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719602887; x=1722194888; bh=TqclGN1u4Ql5PknFgtKb/t9h
	0HvnGU5gIAtbIh+MjvA=; b=ssxeoWq+l0KsECXGPKqEffTpshOMUWDRibkCcF33
	5SA5Tc7p8Bs4Zw+SkeBDJ1CdVOXPB9o1IEPsBdrlt+UxVl9gTA+66FpZ6zCbEFCq
	Ppgavi0tXzFwhwGG1oPr9/NOB9T5xAI5dxyq6NTDKYvi7z1v9kF/owv1Nk0UJmWQ
	2h4DeZMWB8X+xhhSqQE3fIGbr36vtqUrvQ8zlD5Wz7ZpzmPxbVEXbJqGJ4VhDjcR
	UW4xcMsmihoiKkCqjXTZNM4w0LkZC725NvSO2CJDiTnT5m66RbJvJTh3ppmlYH+k
	eNw/zId8lrX3qWhVgDibs4vOPpQpekBS2QbL7Wy4s2VAVA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id BFESxudNhdlX; Fri, 28 Jun 2024 19:28:07 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W9lpF3lF6zlnPc0;
	Fri, 28 Jun 2024 19:28:05 +0000 (UTC)
Message-ID: <94929ee4-7eba-47f7-b516-1e11a484c43c@acm.org>
Date: Fri, 28 Jun 2024 12:28:03 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/7] scsi: ufs: Declare ufshcd_mcq_poll_cqe_lock() once
To: keosung.park@samsung.com, "Martin K . Petersen"
 <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20240627195918.2709502-2-bvanassche@acm.org>
 <20240627195918.2709502-1-bvanassche@acm.org>
 <CGME20240627200032epcas2p32fbc04e654e3bdde7298e90eb7350635@epcms2p3>
 <20240628021332epcms2p33801c04cb32d44c5fe3d396a6a45b256@epcms2p3>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240628021332epcms2p33801c04cb32d44c5fe3d396a6a45b256@epcms2p3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/27/24 7:13 PM, Keoseong Park wrote:
>> ufshcd_mcq_poll_cqe_lock() is declared in include/ufs/ufshcd.h and also in
>> drivers/ufs/core/ufshcd-priv.h. Remove the declaration from the latter file.
> 
> Hi Bart,
> 
> The functions below seem to be the same case.
>   - ufshcd_mcq_write_cqis()
>   - ufshcd_mcq_read_cqis()
>   - ufshcd_mcq_config_mac()
>   - ufshcd_mcq_make_queues_operational()
> 
> How about including these cases in the patch as well?

I will do that.

Thanks,

Bart.

