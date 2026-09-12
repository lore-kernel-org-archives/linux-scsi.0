Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F2847A872;
	Sat, 12 Sep 2026 13:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220294; cv=none; b=ijnb2nSLbAXK/xJxa8QMs7eDCB0+w6K1sPWL0auQtqw8tjRskv34Zajqdi9mzkAewsvXxAqttY59NkuE72gyp3lwWVBkHdmH+85d0WVrSPhQTNNU1sVkmb+Agpe5yKczaEHxnRHaa/5m0HSjMFAAlULuDQTU1+9CZJsgJorTkkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220294; c=relaxed/simple;
	bh=RTJWQPVnP2cOgXsP4ClBmG+cOVJE5siN7LC/E44GvyE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e/yZc04xk0C+PJFHxdQXwSeAtE6qlcqkq/Py0rthuZrmTWFzWrUfQ8MA3EHZJu5pVuvUGwGiu7dunrz0jqXIHx6PyfDTT7qZrJbqJVOCx7F5n9kETO8geOuLDi+yNU9PFtzrHtrfN0qVuwNqbeaUyYzBAJ/TA1COwd70c4DNfdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kylMEAS/; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kylMEAS/"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hhstW3k24z1XM4Tn;
	Sat, 12 Sep 2026 13:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1789220282; x=1791812283; bh=RTJWQPVnP2cOgXsP4ClBmG+c
	OVJE5siN7LC/E44GvyE=; b=kylMEAS/uohEmArHVY5mu2GljCVVBZEG8faduRUp
	cv1Ez/x1NhcE7opQCNoneTYveQnTM6n4ivZJlYeCCi5MfApFihkf5Lv5arA8d+ua
	5C9Zyua1Mdv3dKU03I7PsXGIUEBD0J5EEM0tzG74Jwv5pzaENkoMgl+oHfuncZ7l
	+qTJTUUYnk3YbRi8gM6P7UQ9ED7uzWDfLnOSd8vKR9u2scuDkdYwqievv88QzQ6O
	DBflHp3acTkqXHWkXZtYIZ+mQh71t7Ec9QJSHzms9YRyXCB1tYuOBN8X/I9UvTsW
	3t0AZSBop7GqbkvbQMXa1oAzFnLqrzeCvdaBiBItIz3LXg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4OGwJAQrYKY2; Sat, 12 Sep 2026 13:38:02 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hhstC2kndz1XM4Sx;
	Sat, 12 Sep 2026 13:37:54 +0000 (UTC)
Message-ID: <fb1d0993-4349-406c-8721-41602e5fe5a7@acm.org>
Date: Sat, 12 Sep 2026 06:37:53 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] drivers/rufs: add Rust UFS host controller driver
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
 linux-arm-msm@vger.kernel.org
References: <20260912-rufs-private-v1-1-716db733e655@samsung.com>
 <YKq4TcQM0v2dXF4wTHEvZKwASII6PDd_R7_UiHWe3NRnR4JsrC_ZS-x6jA_Kl7P6ONehU0REHYk7WaLz8Xv5gA==@protonmail.internalid>
 <2026091124-treason-trickily-bc52@gregkh> <87mrtmvioe.fsf@kernel.org>
 <6JMwZ4EuSfQ8V4TGaPwatQ31m30TceLJblORsuILQmy4VV8Fx2lHbihL8ARsRUuJmaSUqek8L54y4Nk6DuZMXQ==@protonmail.internalid>
 <bdcff6a168e6d4b8e9c9524bd598281817a7df2c.camel@HansenPartnership.com>
 <87eceyvdnv.fsf@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <87eceyvdnv.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/26 5:48 AM, Andreas Hindborg wrote:
> At any rate, the rationale for extracting the UFS driver is to make room
> for features that fit poorly into the SCSI midlayer and which are not
> standardized in T10 - without making additional work for scsi subsystem
> maintainers.

This rationale is completely wrong. I have seen multiple proposals for
the introduction of new SCSI commands in JEDEC that made me think
"Yikes. This proposal shouldn't be accepted." Some of these commands
were attempts to introduce ZBC-like functionality for traditional block
devices. That is wrong - if ZBC-like functionality is needed, ZBC should
be implemented. Other proposals were about the introduction of new copy
offload commands. Copy offload commands should be standardized by T10
instead of JEDEC.

Bart.
