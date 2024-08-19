Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D643832C8B;
	Mon, 19 Aug 2024 16:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724086757; cv=none; b=OQE0Bzd3ZYJ/EAV0uR669TKniXgsRU0MFxJN39OenZ/CRySYgcYkm4sP7jrZQuka58kiusDeE0eGE+q0bytbfnZTq7UpWVAPqFyobNMUsbAiN8gaQJDkPW5Z4BLIBUehHCJxiuFQQyQrPtpuagpjYWsjhYIzkYVdAhXq1uu8RJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724086757; c=relaxed/simple;
	bh=f+KJuWJFMGUsJAeFJsSIsDWVUOqYKBUZpAu649sCn3Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M7wwWLsS5DGHM9OoRiQVpuU0v0xamfFQqBHTF0/L1+uEaltX1dNWP8qcySsEEHHdQUnNtxF7FktN52pOVeA1p+CRTBOPIUW7C/Qav8JMM/Zx6GAK1UzUlZZyl5qRixJc668wl5nclTlyhbrb9Fk3EMZ5lwqsoGeETA1mldrbF8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0GXnUBzE; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0GXnUBzE"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wnf2W25XRzlgVnN;
	Mon, 19 Aug 2024 16:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724086753; x=1726678754; bh=M1VDugTmr7up1scz+8tkeHkh
	uI36rlkvQKWXthiAyAo=; b=0GXnUBzEHCQYLsBSfaPbEQI0Oct2JWodh9Y/zTGG
	FS4979zCijJib5hpwA5k8fFPDpYmQCh5CD1+MhGOKlatfd+GApYNijdJA9+66G3k
	gMEr6WR0z+WWZPDRI0V5q0Je8pzcRRk0Es4jhpBz9P2eRZUtgGiFxeTkxqQZz+V3
	iI1BCADnB7bYppm1MxSBFd+QLHOGNRm9cpBLJnfh3VhoD3zbvMfu5cHw7bKDqMS4
	pBvlZblXESFj1F7zpnjEMWIYeAtYWrKgz/MQ5ND6cQvSkrU6unrCdR50wdB1tBcW
	XwnjodgjwUHsKK1ANQmOB3XquUR/Gp59XU9VByEs27HipQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Zfu9rOgwgwpZ; Mon, 19 Aug 2024 16:59:13 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wnf2Q5ZjmzlgVnK;
	Mon, 19 Aug 2024 16:59:10 +0000 (UTC)
Message-ID: <bfce098e-a070-40b1-95fc-951e2b3c1c22@acm.org>
Date: Mon, 19 Aug 2024 09:59:08 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] scsi: sd: Ignore command SYNC CACHE error if format in
 progress
To: Yihang Li <liyihang9@huawei.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 dlemoal@kernel.org, linuxarm@huawei.com, prime.zeng@huawei.com,
 stable@vger.kernel.org
References: <20240819090934.2130592-1-liyihang9@huawei.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240819090934.2130592-1-liyihang9@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/19/24 2:09 AM, Yihang Li wrote:
> +			if ((sshdr.asc == 0x04 && sshdr.ascq == 0x04) ||

Shouldn't symbolic names be introduced for these numeric constants?
Although there is more code in the SCSI core that compares ASC / ASCQ
values with numeric constants, I think we need symbolic names for these
constants to make code like the above easier to read. There is already
a header file for definitions that come directly from the SCSI standard
and that is used by both SCSI initiator and SCSI target code:
<scsi/scsi_proto.h>.

Thanks,

Bart.
