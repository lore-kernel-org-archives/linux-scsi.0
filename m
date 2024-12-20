Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F91E225A55
	for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2024 17:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734715193; cv=none; b=XkdYAhwtGUO4p9o9xgXQ96JfnhRHZZWZBn60uLB8KmX91lZlC2IdoeT7IZNwTHVh7BTnuK+APva4YNPKE9Parp2DT3mfs5sRBIoiEoWyZIbZ6+Fh3FhtJceqj7o5ipKsbZHMrOB40Cf1etKS7HM2/CMJMdHBHZaaiSdPX0y1BEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734715193; c=relaxed/simple;
	bh=SA7wCv5D5mxHh+FiLTd7ePm9hQ5Oml7Z5yx5NPGd5cs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j3/ZAu2KH8INGAeTDyAsp7dPQnz5xk6ATY2QkUGRpXsWaVg0CiBAdUALwOYWp+CFA98FNuEx6vr6eRGO0EVjHdjINOtyCk1zuibgzEE2gWi3cY7E9JBecNKKcmBTsQU5u0NVjyzY67gdNBQWb1C1enh434/QZ80OCmrhqf8lPBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EHZZ9UX/; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EHZZ9UX/"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YFDgW3PMCz6CmM6d;
	Fri, 20 Dec 2024 17:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1734715188; x=1737307189; bh=SA7wCv5D5mxHh+FiLTd7ePm9
	hQ5Oml7Z5yx5NPGd5cs=; b=EHZZ9UX/LCj/IuzbiqgMctW7GouzM6UZ10UxoFlG
	GyZUNqj9rXRg8LUopsoj2Tp5WN58y6oHW7DPIWmg0sRdZc/Lb/2Saa2gO8K5NQsK
	363FY+ShZsZPIz0pLE0nGZ7sD4LJjsV1MMC0U7cTO0OLrKN+3GOMQoanAt+o2A9z
	eiaGOEHlGtZ6Nwp8/lwKn8qhphxD8jrBexP3JARCj54GFlDHYBUqxk3kl4A6zA3f
	Jpe1iUR/c7VGfDPmpbcMcaQpQ1i+iOK7BTfNhK5mCEhU3yGVWqJgbp0rCXm4CHmd
	6To/Rsi7wYWiF554OMvRDt9Zu4R5XKH3d66D+9wOOQXYbg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3kfDpJB97Qoc; Fri, 20 Dec 2024 17:19:48 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YFDgP1nPGz6CmM6c;
	Fri, 20 Dec 2024 17:19:44 +0000 (UTC)
Message-ID: <dc5c5de8-4bd9-4e57-a989-06d9e9213f68@acm.org>
Date: Fri, 20 Dec 2024 09:19:43 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: mpi3mr: fix possible crash when setup bsg fail
To: Guixin Liu <kanie@linux.alibaba.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org
References: <20241217110408.126413-1-kanie@linux.alibaba.com>
 <8e783802-a74f-42f9-b0cd-9b831179c472@linux.alibaba.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8e783802-a74f-42f9-b0cd-9b831179c472@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/24 5:37 PM, Guixin Liu wrote:
> Gentle ping...

Has this patch been tested?

Bart.

