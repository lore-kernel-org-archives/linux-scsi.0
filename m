Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81CB1F0E29
	for <linux-scsi@vger.kernel.org>; Wed, 11 Dec 2024 22:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733955298; cv=none; b=u2qUApk/1nYNdTzxRuzDWChD1Ab2CXOi1lzhN4svgWycUwvBjt8voHYX/XrnSBL/RfWZcbAuQNtRcGfdNMTlXHkuH6NkjhHA5wY5Kwil/BZYB8mE93gXkcB1ggGGPtFFWJTRYbCX+OjG0/FGN4kO6CSYTP3JUMamJh6O3a4oNM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733955298; c=relaxed/simple;
	bh=bSrByfkoqYdKpF0famt5jb9JcTfkFX2z/Y+W9IN14Dk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QiOmXnxDt+FxLxb8SzC1vRMj1CmgxA6aauU5vyJJEPOsflR5iHXY+97kM6g7Z6atEDJMyGa1CHPKm/6yFdGeVXJXphAo/GPK83GSY6Ucg8t2wX3z/MphGuanq2/Wl8XfhAHAoQLmW8hNqP/R0cVJmDz6ghatLqzVznMKqHIx+MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=R34w7vyn; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="R34w7vyn"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Y7qf804sFzlff0K;
	Wed, 11 Dec 2024 22:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1733955293; x=1736547294; bh=k2jVbTao7XhRUC90BiORCt+M
	/h8IZHm3jryAUbQC+7Q=; b=R34w7vyncJDrVpkTThmhzuuArlzlr/LhD4PoSbgM
	rfvA1OQW7EViUiF1ZBqWBseT7WGzJy5pFHFKhQxwz0ub9GoQjg3CsW+7TVrS4YTa
	n/Nb32X4ILLh5myHS15Bet48l23egaiuVloBrqjHAygRpXYn25C0nZutXqLADQKR
	TsA+EJfoJC9O9Fn6ZuzqEiSixlyT7viNcG9WtV6wS5J2/OgWI3FORlEzltqcD2uy
	8FsHbmJZVZIEWb0CHXIkaI/8B+s35osx7lzqAVJosSyIhsGU8nUkizPITuywKdMP
	EGOfEzZr69wdPPWumVAPLTgTD5PQGQivs0h5vnD1YvGQFw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Zp0GWx7Cm8uH; Wed, 11 Dec 2024 22:14:53 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Y7qf33CsTzlff0H;
	Wed, 11 Dec 2024 22:14:50 +0000 (UTC)
Message-ID: <2e21a7f9-f59c-4f8c-a942-ced71cace6df@acm.org>
Date: Wed, 11 Dec 2024 14:14:48 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] scsi: scsi_error: Add counters for New Media and
 Power On/Reset UNIT ATTENTIONs
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org, jmeneghi@redhat.com
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
 loberman@redhat.com
References: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
 <20241125140301.3912-3-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241125140301.3912-3-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 11/25/24 6:02 AM, Kai M=C3=A4kisara wrote:
> +	unsigned char ua_new_media_ctr;	/* Counter for New Media UNIT ATTENTI=
ONs */
> +	unsigned char ua_por_ctr;	/* Counter for Power On / Reset UAs */

Why unsigned char instead of e.g. u16 or u32? With one of the latter two=20
data types, no cast would be necessary in the macros below.

> +/* Macros to access the UNIT ATTENTION counters */
> +#define scsi_get_ua_new_media_ctr(sdev) \
> +	((const unsigned int)(sdev->ua_new_media_ctr))
> +#define scsi_get_ua_por_ctr(sdev) \
> +	((const unsigned int)(sdev->ua_por_ctr))

Please introduce macros in the patch that introduces the first user of=20
these macros. I don't see any users of these macros in this patch?

Thanks,

Bart.

