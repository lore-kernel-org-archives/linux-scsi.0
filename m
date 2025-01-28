Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528F91DE4C8
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jan 2025 17:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738085558; cv=none; b=TFi6TnOFPfSeqHCxwaNVWZRcaQ4gWR/JXMAaGiAv3SB5hVlrcfnOuYsgMunKwArm8ty5YcIx22UdQBSOd/8Qr6l6tXiST6o4/5oSoczOVYFguvbG5jf/0frTor+3W77nZyi2vh1A/HhZWyp0WljPwJ+KBYU+BMQzEhWjfSlCxnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738085558; c=relaxed/simple;
	bh=nMiVwk5wnsvQfsHooNA4FNzI0woDmK/uFr6Eg+xYjBI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i0LX55nQ8RX0oZBNNBpEoTFRBKXN5BaserbO9Y6qh/QJTHqCLTudAEncOin9zLkTt+nMZcSCSas7mkfe9kj2xd6hAgGgCwFHAB2UWx8jkXMfORwfPgfgVbpvQwGvRbRWrDIGeNvPMNr10rWgROBBZmF9B5zpxbJGOY3yNhho+cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=P1KBDelA; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="P1KBDelA"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4YjC6D4gBlz6CmQwQ;
	Tue, 28 Jan 2025 17:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1738085554; x=1740677555; bh=cX8CvxIF1OwaJw5vUGhkEa3Y
	XQCgo8wAoUJgSM+rGkw=; b=P1KBDelAhQLrgGTHC9fzNsMDRuS489TAJswyKVX6
	bwp0GOnX5aBJJkEsgpk1UcFmyHkwfnX1q0jKw1jxOfP/SYYxMnHGB9SxaP8gIr/A
	RIOKtBh01eldhg90145p0zDjIKbBWf4R3H2Owzf5ZFJltcUGyFxuLkqRL+4DhKS7
	k76dqpnABO2tVmfqN0R5czs1tCM2pokr2TLItWUXWYqw8CIbpeW/jXSbwirFdnZE
	PNiVtGsaUVSO18tXpGcD8ZKmcfnFJ+Qundmv5icjNnQ2Ajqo5VpKRzmxD+/YG+AN
	GYXI20ZEEY22JxGvbv+ct0kCTiW5jtIXQ6LOBmNrCp+xKw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lQN965phOseI; Tue, 28 Jan 2025 17:32:34 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2e14:8:1e8a:33f3:2626:73d8] (unknown [104.135.204.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4YjC692BjLz6CmR09;
	Tue, 28 Jan 2025 17:32:32 +0000 (UTC)
Message-ID: <d471315c-2e6a-4f16-8a3b-805379998376@acm.org>
Date: Tue, 28 Jan 2025 09:32:29 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/6] scsi: scsi_debug: Add READ BLOCK LIMITS and
 modify LOAD for tapes
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org, dgilbert@interlog.com
Cc: jmeneghi@redhat.com
References: <20250128142250.163901-1-Kai.Makisara@kolumbus.fi>
 <20250128142250.163901-3-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250128142250.163901-3-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 1/28/25 6:22 AM, Kai M=C3=A4kisara wrote:
> +#define SDEBUG_READ_BLOCK_LIMITS_ARR_SZ 6

Isn't enum or 'static const' preferred for declaring constants that are=20
only used inside a single function?

> +	unsigned char arr[SDEBUG_READ_BLOCK_LIMITS_ARR_SZ];
> +
> +	memset(arr, 0, SDEBUG_READ_BLOCK_LIMITS_ARR_SZ);

The above two statements can be combined in a single statement:

	u8 arr[SDEBUG_READ_BLOCK_LIMITS_ARR_SZ] =3D { };

Thanks,

Bart.
