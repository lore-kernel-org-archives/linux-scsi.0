Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5304E18E050;
	Fri,  7 Feb 2025 17:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738950678; cv=none; b=dVr5BSxuxNstNjPb1D9VXO260nuBEOqUDRCJksb6TNsfA0z0BCgR4R7lZaedzJ7FaRzhxPJ0Iz3JUu7Gzr7aXZF/FSrvNJRYTDF81Ywp0i6HATyDhPUvpXAy5kG5ZMpR2cWO4kj0MtiyR4TquxCacYzyA5lB19WZCY2alJbhUuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738950678; c=relaxed/simple;
	bh=MPsbYwDUYNurUngqJp6G/NBnW5xTPrQhzn/NqyWKp/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ju2hpJ/z5DsxS5jiSoD3QA78k1IhkPl6d6MmPAv1cF92wePu1Fgvzuwwg9LQekTOQEgd+vsQ8M4hI0oR7srBVnBtVFE71ygM0tXIB1MYv9wWr8oeCv93w576iIDTOcbKAS93gK98+hFTIzaU2F3F9W5cc2yKBzH4qJpFUH87vgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4p0Wz68f; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4p0Wz68f"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YqM383gzPz6CmQyW;
	Fri,  7 Feb 2025 17:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1738950670; x=1741542671; bh=arZC9itOZYPHb4htpROweMNR
	ItRM9wRu6g3C03a4eNw=; b=4p0Wz68fs9rAFvaE6K+Pcnw03c8oypR+LYtDCAWe
	4MZxuL392j8HAiu+d4K0EtwY9DMs53aDzTL6wxzRY3NyUkil8G5dQYZKq7kLKC1U
	pPyZWAWLVj3TaOolA4lGnbv0TDRrhGqdL48OnDhVlE0985t/i7tnXF0rPUjBmX3Q
	I5tLJbBxNzkjx5l1t/yag8XGTS7AYSHPBdYEHkvm4/dr1L382tLQKFwQB39JfhUD
	AfvwTs2XQo8vLlBF7tYYWILOlcxdZqQRJVAfSMUnPb4vTKESzDckohXqZADMdYDB
	yv/MtpqEPDvoqzF5zNuGuDz7+nsluGg9R3UO9woX1CLi2g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QRwso-HXEgj6; Fri,  7 Feb 2025 17:51:10 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YqM2y6hzWz6CmR1W;
	Fri,  7 Feb 2025 17:51:06 +0000 (UTC)
Message-ID: <ad4bd008-8d0d-439b-879c-e9cf4c89ec56@acm.org>
Date: Fri, 7 Feb 2025 09:51:05 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: Bypass certain SCSI commands on disks with
 "use_192_bytes_for_3f" attribute
To: WangYuli <wangyuli@uniontech.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
 zhanjun@uniontech.com, guanwentao@uniontech.com, chenlinxuan@uniontech.com,
 Xinwei Zhou <zhouxinwei@uniontech.com>, Xu Rao <raoxu@uniontech.com>,
 Yujing Ming <mingyujing@uniontech.com>
References: <5653B7D4FD7224D2+20250207091723.258095-1-wangyuli@uniontech.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <5653B7D4FD7224D2+20250207091723.258095-1-wangyuli@uniontech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/7/25 1:17 AM, WangYuli wrote:
> +	/* Bofore we queue this comman, check attribute use_192_bytes_for_3f */

Please replace this source code comment with a comment that explains why 
the code below is necessary. The above comment duplicates the code below
rather than explaining something that cannot be derived from the code
easily. Additionally, there are spelling errors in the above comment.

> +	if (cmd->cmnd[0] == MODE_SENSE && sdev->use_192_bytes_for_3f == 1 &&

Please remove "== 1" because this part is redundant when using a single
bit in a boolean "and" expression.

> +		cmd->result = (DID_ABORT << 16);

Please remove the superfluous parentheses from the above statement.

Thanks,

Bart.
