Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C1647CC99;
	Mon, 14 Sep 2026 20:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789417674; cv=none; b=LTfTrLqX6FloHTDYJf/HUu0KNs3doveqLjSoeIIIEaK3fwybDJpmFxZyWd4lpkr1K7SYtIEF+k1HHuOfU47aqNJYJoXLmFJswMDBw2a80iNIZWOLqW6Y/AwmweCh5yOhvQCoCR6HyQ+uRBuchdfftPiNi9jKV0wDeCq5uoskIbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789417674; c=relaxed/simple;
	bh=3xGGCaIfKo59yYUoPrTHjEyNAbBk2RJXUibjDZEiTOA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=gR2HfO6fPRoLVgPROpz52D6LIaRVrZFdtXkk3+dQ+uff35FmqrITynn1MYOSvFy/IHeEfVHFCXdklU2LGeBh4GsapRBYU12ih1I2tDC1B3dNnalG67Jy3jGiqmaxUZiC7yyPgnOfhv81kGGrrQOIM3BKaoZS34w+X0NqhZSZxDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hM9QBcOZ; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hM9QBcOZ"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hkGtB04gQz1XM5kW;
	Mon, 14 Sep 2026 20:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:content-language:references:from:from:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1789417653; x=1792009654; bh=J1CKBIiEpPMc/bzFX/8Ii0Ki
	p8JzihDw9DTYdiO28kQ=; b=hM9QBcOZyt7afYXjNUCNLYtkegXZ88nhJ18xPmFl
	0bPQXMrCSWy4N5DAC1CXxDeUHiGWpNtRseHDrPnIUbEgHIZrxqrfNFEDU+16Ngjr
	MEweINwGtGGUevL99McpBwHjt7SLpkShIIRl0T4KBFlHOZIbxbu1O5cyuynPbBP/
	TF7NQ0036DoMmq7FB3XfUNS4Dvkd8jlXcnYvgymaHru0SOgS0WpBNueNG19rCPiT
	CJINKC8oebrS1XC9ywRx3xaBiXPujFdoJeMbXMieM+aQ+gMsyVQ58bUQYDhK+B3H
	9ymTDaIGRZJq/nE1fmGP50hy4alQjJnFUAcvRLe4hYWg5g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VSWTyGqAaRSJ; Mon, 14 Sep 2026 20:27:33 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:e88:b67e:bf8c:1880] (unknown [104.135.182.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hkGsn21HYz1XM4Tl;
	Mon, 14 Sep 2026 20:27:24 +0000 (UTC)
Message-ID: <3c1c0025-2a88-463d-8aeb-6331dd09bad3@acm.org>
Date: Mon, 14 Sep 2026 13:27:23 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] drivers/rufs: add Rust UFS host controller driver
From: Bart Van Assche <bvanassche@acm.org>
To: Andreas Hindborg <a.hindborg@kernel.org>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Greg KH <gregkh@linuxfoundation.org>, jaemyung.lee@samsung.com
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Daniel Almeida <daniel.almeida@collabora.com>,
 Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot
 <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Bean Huo <beanhuo@iokpp.de>
References: <20260912-rufs-private-v1-1-716db733e655@samsung.com>
 <YKq4TcQM0v2dXF4wTHEvZKwASII6PDd_R7_UiHWe3NRnR4JsrC_ZS-x6jA_Kl7P6ONehU0REHYk7WaLz8Xv5gA==@protonmail.internalid>
 <2026091124-treason-trickily-bc52@gregkh> <87mrtmvioe.fsf@kernel.org>
 <6JMwZ4EuSfQ8V4TGaPwatQ31m30TceLJblORsuILQmy4VV8Fx2lHbihL8ARsRUuJmaSUqek8L54y4Nk6DuZMXQ==@protonmail.internalid>
 <bdcff6a168e6d4b8e9c9524bd598281817a7df2c.camel@HansenPartnership.com>
 <87eceyvdnv.fsf@kernel.org>
 <RJ3H-1s-vh5YR7DRuPZ6p050ld3umNGcKNeBigg7n3KUQt1WJ2C-sR9kEqrF6f4ubj5AHoHNvB0MRGJyw6tf_Q==@protonmail.internalid>
 <77e00073a9254d5ea1ade771590da81a859b75a6.camel@HansenPartnership.com>
 <87bja2v5g6.fsf@kernel.org> <ba386a0a-8022-4c3f-a1c1-bb22205b51d4@acm.org>
Content-Language: en-US
In-Reply-To: <ba386a0a-8022-4c3f-a1c1-bb22205b51d4@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/26 5:30 PM, Bart Van Assche wrote:
> On 9/12/26 8:45 AM, Andreas Hindborg wrote:
>> If we expected this new driver to be a strict subset of ufshcd, we would
>> not build it. The reason to do it is the features that do not fit the
>> scsi midlayer.
> 
> That's a super vague statement. What features do you want to implement
> that do not fit the SCSI mid-layer? If this is about implementing non-
> standard SCSI commands, REQ_OP_DRV_IN and REQ_OP_DRV_OUT should be
> sufficient, isn't it? Please note that this is not an endorsement for
> implementing non-standard commands in UFS devices. Non-standard storage
> commands complicate filesystem development and maintenance, especially
> if which commands are supported depends on both the manufacturer of the
> storage device and the device model.
(replying to my own e-mail)

Since my question has not been answered, I assume that REQ_OP_DRV_IN and
REQ_OP_DRV_OUT are sufficient. If REQ_OP_DRV_IN and REQ_OP_DRV_OUT are
sufficient, there is no longer a reason to implement a new UFS driver
subsystem because the upstream UFS driver already supports these
operations, isn't it?

Bart.
