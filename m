Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AC74FDE65;
	Wed, 16 Sep 2026 16:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789575733; cv=none; b=KKfWQPHi8XA+iv2grPUaKX8LVGUT8IQ3esbik8xG99SNwyILjpuIyKOGxYS8ztdtbrStt1HeldWreWrTeXh02Q7PuDgBVUzlDaoMbdqQVzuGRPuuLYhIaT5kGuSC1MkiUkP54OtnoKUwAXFofKzw+4lS5EHTWdjexLdn6qkHQFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789575733; c=relaxed/simple;
	bh=PXPYrVFlU0tYj/yNWMnzGDjhCXDfMRpZr8XpmJ/vHFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RpOBzL3JPMOLHMXKcve4jOayR5HrAZCz3zwXZDF9wiI+7QDPIbyK8rhJdZJ9CtAr8+WsHuilpHBkRDNGkS3cst8akUEZDFgRmXU9krbR50WYJuv3lizSPEiFz5iawzBTPM+WjeQw3WvSdR4tAUOo4DU0ivK3H+Dk4+iGN2PUUaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bdVpx8O8; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bdVpx8O8"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hlPKq0Zkzz1XM6J7;
	Wed, 16 Sep 2026 16:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1789575718; x=1792167719; bh=PXPYrVFlU0tYj/yNWMnzGDjh
	CXDfMRpZr8XpmJ/vHFA=; b=bdVpx8O8iFgBJ5zwfESb6/wkovkjAKuQhsIYbDFL
	DKYF2rRbpyfRUFlT8y5iOi55qn0ONz32v0Jaexgn4B4SnabiIFBv4o3nFjld6mh8
	xKCDO7dWeL+IOD+GA51TejoC92+u3ET7bLA+yvpj0aDu/MATMfXEnZODlfQuF8Kb
	6wnB8WamecFbPTIqO2rjBeR3MnYn9R6V8D/3/0JLDs2yIiu5BT9HgXXKULB3D6v1
	OF4qAd9A+0AoSffT4R4U5w85Mk5uapurBLAuSKiSGNSYF6lfe4U7YR8X/7pWZiFM
	OP8zL7uUNcx162KIP5Bo76d+3wpNV4bZ7+JzEIS5hRi6AQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id f32hYN8Iu33m; Wed, 16 Sep 2026 16:21:58 +0000 (UTC)
Received: from [100.86.177.31] (unknown [104.133.214.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hlPKW4jYRz1XM4Sx;
	Wed, 16 Sep 2026 16:21:51 +0000 (UTC)
Message-ID: <d19d0b37-a599-426c-b54f-cf9b16462904@acm.org>
Date: Wed, 16 Sep 2026 09:21:50 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] drivers/rufs: add Rust UFS host controller driver
To: Andreas Hindborg <a.hindborg@kernel.org>, Bean Huo <beanhuo@iokpp.de>,
 jaemyung.lee@samsung.com, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Daniel Almeida <daniel.almeida@collabora.com>,
 Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot
 <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-arm-msm@vger.kernel.org
References: <20260912-rufs-private-v1-1-716db733e655@samsung.com>
 <8mLXEMDMxh8mZQqVywUYUeOiZPZIPmrVGRlOkDbHptW0NEJeszKVpff5h39MjUvD5yyivwY3Z7kCXIH5VlGoiw==@protonmail.internalid>
 <4c38f13af8f75020fefc35827463e9bc643b99f4.camel@iokpp.de>
 <87jyoqvhpm.fsf@kernel.org>
 <01d56517261d397f5e17101f03554f91529e23f0.camel@iokpp.de>
 <8733vduwin.fsf@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8733vduwin.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/13/26 6:10 AM, Andreas Hindborg wrote:
> I understand that userland tools need to be updated, and that
> carries cost.
Hmm ... my understanding is that the Rust UFS host driver needs to be
modified. Why should user space code have to know what UFS driver has
been activated in the kernel? sysfs ABIs are assumed to be stable, isn't
it?

Thanks,

Bart.
