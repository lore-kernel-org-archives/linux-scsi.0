Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AF01F1302
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 21:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755207121; cv=none; b=WqtmlbNWzakC8srQxh+ev5JNJSUKauSv93AAjY2mKTM2XAp5lKv0UvZc1SRsB0DqSZ+9M9xF3+7FkpgHgZwP7Y3FR2BraRBxbIsUsjBmMcBAs3v1UOtyux/UO59CZsTvtaywRnUnwC0//0/h5UqozfPHzlEJSNvRd0Oh1ZMm600=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755207121; c=relaxed/simple;
	bh=VhvIsB+xWzpHU040QeNuf10ez/GigjRDcoZSPQId078=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eO/eLBvWfP8fTihlxYsqyRCdoTZdTGWt6t+gDHnoELXmrp67R+I4zWWy/l+5fZrUgBmE5ugwA8R9CGADfZpbgzwJMqv2wdcmVUxnD1LG/OMcWXV1VDZWGWi++Mzdiwf/VLrf3YDEbs8aaVpNph2y2DTYxprdgvVvvuxSQJSq7II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qdvrdpQP; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qdvrdpQP"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c2z324wBjzm0xjs;
	Thu, 14 Aug 2025 21:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755207117; x=1757799118; bh=PoAn5mdZORyJ6Vdeqdi8zILz
	LF6FKsch6khSamtncTo=; b=qdvrdpQPCAxtnMjsGtPYyH8Y/WfaHHMhXjpIZhJ9
	GZx6SJkYhXY4QsMP/UvlmeitkpGyaLuaz5emC7HDBcDmsvPmTvmM6VMUNbKUQYkB
	aRgQqJy9huma5oj7yzk8PQNgPEQJ7bHYPu0sMZZoKZYR5VCDxJVTu1OiZiDG0Xbe
	ol3uaJGlYsO/nBlhQ9h0wWLm+uaEHfSeOVEwFYbFTa8al+v4o8YLl7A0Y7Hddsv3
	Xf4hVKXrlr9/AnrOtX5n04E/zBxkCdiEso+cZ3tfd91Xz+/McJvWUtIXN2GMu/Ve
	BW31+GBSqvbteYeXp5JHfJft4mrMi4ydpPPSXJvguATxSw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3cbmpCIsJadp; Thu, 14 Aug 2025 21:31:57 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c2z2x2xtwzm174H;
	Thu, 14 Aug 2025 21:31:51 +0000 (UTC)
Message-ID: <a69046fc-ba44-471c-8702-dbed4846eecd@acm.org>
Date: Thu, 14 Aug 2025 14:31:49 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/9] scsi: sd: Pass buffer length as argument to
 sd_read_capacity() et al.
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com
References: <20250814182907.1501213-1-emilne@redhat.com>
 <20250814182907.1501213-4-emilne@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250814182907.1501213-4-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/25 11:29 AM, Ewan D. Milne wrote:
> -		memset(buffer, 0, RC16_LEN);
> +		memset(buffer, 0, buflen);

Hmm ... why to clear the entire buffer (512 bytes?) while only the first
32 bytes of the buffer will be used?

> -	memset(buffer, 0, 8);
> +	memset(buffer, 0, buflen);

A similar comment applies here.

Thanks,

Bart.
