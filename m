Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779F3C2EA;
	Sun, 13 Sep 2026 00:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789259452; cv=none; b=kJmaOBU8NGod+jAmnbTyYHcvByuSunNZCWEKhn6iZsylpHkN7JzrsWnikBP2cTnyVzACRn3Cxh6AGM9Hgv95Q4Sb0oVzdOnuNj4rISSbUHHH0pki1LJutoUhlFJlMgmLeoZiU/4jSxx1XF1iWjJmyvNXE9txaVBfSg/V2x6AXpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789259452; c=relaxed/simple;
	bh=HlbGcHncXgxeJnyIgMYYOBgqjwLfT1+DovrzLoZeEKw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P0IG1vqQPQR8++786EG1szpK9qOQHP2zkQlwFxjSegh1t3qUg3GbkJIPH0NUAPnLDfd1B96skk/BWnpey03rcP9RYMm9NBVwXOp/JX6pee+X+Za1l6snXPwYUYhQfKgww1TRcGaUxY2xgtmxXYvTDmH3cHyhX7aEI7QnzJwkVVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=myJRdf8Y; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="myJRdf8Y"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hj8MT064Fz1XM4TB;
	Sun, 13 Sep 2026 00:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1789259432; x=1791851433; bh=HlbGcHncXgxeJnyIgMYYOBgq
	jwLfT1+DovrzLoZeEKw=; b=myJRdf8Y48khX3oHnCfykX7JiM8D2p5lIv3j4Z+T
	aqMmyojak/oUaZg9HU3ffg2DzINFpfGQMNqF2vvMiZ5MyfRzobSLAlwNIamtpg9p
	8qMjmuBtGcmsu3uO4eDC49Ywoeamp2WYkmaU6ICKrK2eb8Kx1KBls2bkUeYIFCAK
	QfN5KHlGv7nlvmGRW2Q8fPuoV4dy2z+5NGrotqoFnbNf7HsC4+W2Da6BIevicBjf
	46OCNPmf5G9aO44la11cSoea2SgjXP2/7Iy+74bYZBom6/ZYUpJN0B9MLc7sgR9u
	RurcDhNuN8EQZ5aJl2sedu8CW4n7IeY4vhm0wSm5FOshjw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TTRlBX5WCrYz; Sun, 13 Sep 2026 00:30:32 +0000 (UTC)
Received: from [192.168.0.215] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hj8M40tmMz1XM4Sx;
	Sun, 13 Sep 2026 00:30:23 +0000 (UTC)
Message-ID: <ba386a0a-8022-4c3f-a1c1-bb22205b51d4@acm.org>
Date: Sat, 12 Sep 2026 17:30:22 -0700
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
 <87bja2v5g6.fsf@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <87bja2v5g6.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/26 8:45 AM, Andreas Hindborg wrote:
> If we expected this new driver to be a strict subset of ufshcd, we would
> not build it. The reason to do it is the features that do not fit the
> scsi midlayer.

That's a super vague statement. What features do you want to implement
that do not fit the SCSI mid-layer? If this is about implementing non-
standard SCSI commands, REQ_OP_DRV_IN and REQ_OP_DRV_OUT should be
sufficient, isn't it? Please note that this is not an endorsement for
implementing non-standard commands in UFS devices. Non-standard storage
commands complicate filesystem development and maintenance, especially
if which commands are supported depends on both the manufacturer of the
storage device and the device model.

> Here is what I count the midlayer doing for UFS today: sense to
> retry/errno disposition (scsi_decide_disposition, scsi_check_sense,
> sd_done), the abort to LU reset to host reset escalation in scsi_eh with
> ufshcd supplying the handlers, the sd device model (capacity, write
> cache, UNMAP, runtime PM), and the SG_IO ioctl plus the scsi_device
> sysfs tree.
Logical unit scanning, DMA support, /dev/sg* support, /dev/bsg support,
timeout handling, pausing I/O while error handling is ongoing and zoned
storage support is missing from the above list.

Thanks,

Bart.
