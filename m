Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDC6377A87;
	Wed, 16 Sep 2026 17:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789580842; cv=none; b=XQCsjL8l2SsG/ulMZdQJ5Q2hwpvdVaqvvj1QDan11pL5O5/Av6jURo2HMOMT03bFyjq8akKUvCHaZoyeKo9ZCSOmdxl5rBFghR1iJRcbitIRV5jkh8DO6RuPfXLKCcbUQ2Az+DquVQwFdU0YRwqgqYYujnD8Fu4UBMrRIsBRqjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789580842; c=relaxed/simple;
	bh=Ybmndea+9BVFEsrsa54+odnni4estZ50obHtla6/t5g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Ar0YflxiRSsh+OAUSAuPGFmlVnshwHtkwcIsOkZQS0XbOc63Q//9o7EUPK2eZkM41TJJMiNwt5QyjYvOI44g1Q5Out/eLE/CRBLaPMb1OwcJtDDgkIG8lXW9AbEyaNnBKQpF43lbBPs6BWQk4DUlZ2gJnTqFP94sNlKB50xCuvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KPyAL0Hi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KPyAL0Hi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DA81F00898;
	Wed, 16 Sep 2026 17:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789580830;
	bh=Ybmndea+9BVFEsrsa54+odnni4estZ50obHtla6/t5g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=KPyAL0HilCLyPj5ml21WZPDVC+r/jiafBL7OK0lvJuyx9Z7TxbYiVD0yWTDmkoISy
	 hoaCIZbQCcMdk/jJ65RC6xMQA/+6ql3ymd2ZQ7aPvJ2bkzIxVIAs+uR3ezh4GID6VW
	 McnEj0B/xaPnVbZlaARK+9sZB+8FUlHg9ghcmAR8kFEMjlRsiaz+6bFA0hzGEDM691
	 eCSR2enFAU718trhrhbC3zsTBrjDMBubFiAXXIzfbOxKwyyX3teSuXEhvihRAJZlvQ
	 zaTgW4tf5zMLAQwWJZpLa2YpTQ12JGobTvJzd/zoTYIrbcVN8MigMKNflybz/LuJyb
	 VfT64YbuaTigQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@iokpp.de>,
 jaemyung.lee@samsung.com, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng
 <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Alice Ryhl
 <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo Krummrich
 <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, Tamir
 Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>,
 Onur =?utf-8?Q?=C3=96zkan?= <work@onurozkan.dev>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH RFC] drivers/rufs: add Rust UFS host controller driver
In-Reply-To: <d19d0b37-a599-426c-b54f-cf9b16462904@acm.org>
References: <20260912-rufs-private-v1-1-716db733e655@samsung.com>
 <8mLXEMDMxh8mZQqVywUYUeOiZPZIPmrVGRlOkDbHptW0NEJeszKVpff5h39MjUvD5yyivwY3Z7kCXIH5VlGoiw==@protonmail.internalid>
 <4c38f13af8f75020fefc35827463e9bc643b99f4.camel@iokpp.de>
 <87jyoqvhpm.fsf@kernel.org>
 <01d56517261d397f5e17101f03554f91529e23f0.camel@iokpp.de>
 <8733vduwin.fsf@kernel.org> <d19d0b37-a599-426c-b54f-cf9b16462904@acm.org>
Date: Wed, 16 Sep 2026 19:46:59 +0200
Message-ID: <87a4ph3x7w.fsf@t14s.mail-host-address-is-not-set>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Bart Van Assche <bvanassche@acm.org> writes:

> On 9/13/26 6:10 AM, Andreas Hindborg wrote:
>> I understand that userland tools need to be updated, and that
>> carries cost.
> Hmm ... my understanding is that the Rust UFS host driver needs to be
> modified. Why should user space code have to know what UFS driver has
> been activated in the kernel? sysfs ABIs are assumed to be stable, isn't
> it?

There is a choice to be made. Arguments could be made in both
directions. One could argue that this is a new driver, so technically it
is a new ABI and as such there, is no stability requirement.

With a goal of constructing a more simple driver, sticking with scsi
legacy user space interfaces might not make sense.

Best regards,
Andreas Hindborg


