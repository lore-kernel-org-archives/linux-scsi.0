Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FD315442D;
	Wed, 11 Sep 2024 22:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726093978; cv=none; b=ZRf6RAm7czGx0+uM6g4Yb6Ck6hbZo8MwHPBpn16T7LigDye9rXtdWpuGRfs0jmIQEP29/AqJvphQRG8pjzhVsMUt+53KZgv2jMNtkrWpIs3veTjH46+lFwLOuRDkY/ixYwuDdFUAwh6sbyCnvsWQR6auA6zYugKns1a1juyFw60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726093978; c=relaxed/simple;
	bh=ri02tmiI/Fny0K80RpVCmC5qXeAd5Ny5JNmTjqHehXM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aHa94+EF23Kg+DxBKayPN8D/+KC0QZqV3X/r3c6QS6VNGy+IwPHbLbCn9BMY5+cApJdt3xHvpKcNInjE2iL6CnLIOQm2zQIjfl2PsxFErlQVAuhPeK7+SiO30KalftwJKD6lN/64cz55YLPAWx4RlQLZGxacLMFHoIGLOd71CwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=elLjxVwx; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="elLjxVwx"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X3wLw35Ysz6ClY9S;
	Wed, 11 Sep 2024 22:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726093974; x=1728685975; bh=ri02tmiI/Fny0K80RpVCmC5q
	XeAd5Ny5JNmTjqHehXM=; b=elLjxVwx9VAzFxniWyRO+6x14OWsxd4+yZQjLRp8
	duo1F+3Y5swt8w6/LFDzgo0pCPYJXMM9i7Lx9j0Z5MnU3Isu/EHKmxVZccHnQ2uq
	PJ+mmmRrMTVcJUMvdwvx0a81vmkfYXGTEHizroYPZLQ3i/59k1pmmnXiQ8igageI
	G5+AsqvWmNbOPiSErbCZM8GmB7IcpOlC+V2g7qGccjKq+EiRWDTC824U3QT+ABn2
	RozWDl4f7qj037tloIHEzc7qjDaAUW8rvs4G7pFxGlsesngNxSfCS1GLmNWLOqKV
	VgEIpeY6K9xrsRoSSWFy5R761fUi2/eTeZ1VQ6hhGYQdfg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0Bz_iw8E3IBp; Wed, 11 Sep 2024 22:32:54 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X3wLt0fq3z6ClY9R;
	Wed, 11 Sep 2024 22:32:53 +0000 (UTC)
Message-ID: <f47a00da-a072-491d-80a0-59b984ea92b0@acm.org>
Date: Wed, 11 Sep 2024 15:32:52 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: Use pre-calculated offsets in
 ufshcd_init_lrb
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20240910044543.3812642-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240910044543.3812642-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/24 9:45 PM, Avri Altman wrote:
> Replace manual offset calculations for response_upiu and prd_table in
> ufshcd_init_lrb() with pre-calculated offsets already stored in the
> utp_transfer_req_desc structure. The pre-calculated offsets are set
> differently in ufshcd_host_memory_configure() based on the
> UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk, ensuring correct alignment and
> access.

With which host controllers has this patch been tested?

Thanks,

Bart.

