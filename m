Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3633E2AD1;
	Sun, 13 Sep 2026 13:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789305068; cv=none; b=P+Uz7r5LdWdVX+IC6b50gJ52J/6EBNmTOz+CKiDe4gnZs9mIJCCg7b4sg1vv5rMksZb1Qi3zYCPw1k3S5ycXSsmxghA9x9lRynmdtcDR1ZHih1akuC58MZCfAtOBGbmf0iGiYWHdQnUypPR/oQ+Nf6S5FHdnEi69WbIaB5RlzQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789305068; c=relaxed/simple;
	bh=7LqoacasArToHW8EBZ+BbyUhaJRWJbi5UTgqUiX4QmU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=V/PawHcwWVWUSSP38+dWgQ7c8E7/y6eTtnzbC4bDdJlFaLiDQHygachdzy+SXlSUplyF4Ecg2rY699340roD5o7MDw3sBVssjKfpcZaEXotzZp04X6WaRryFLuhaVpOmK+ceYd9H4VB5OUVrlOKjdJu6gPn0G1HUp+mODNrSKaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K4WbhqY4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K4WbhqY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0017A1F000FF;
	Sun, 13 Sep 2026 13:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789305066;
	bh=FoXI7tUIwvAH0hgDQPDMq5KaxZw7gRoW9bqX5f5mb4w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=K4WbhqY4/88Fn5sp1tjdFDjgPvDVnpiy3ybEMmYc9v5ByVwyK148jgeViEVG9Ns2V
	 KawgqvZUc5vwlRAQcWRTeS9jcfpPnxXdo25HL31ZGjuDEMsFTyZvKQpSbqrw2bxkbf
	 DN55P/K1YsKumYKDCap057M/eAXPgjXRoTejUUSrFcjFcM/6HGDTfW4GO6avW/Lzcc
	 3rw19IjHPtOkUD9hVHPb19pHPRERGJmTpDhmrLu/q3oj/b0TPlrZu1d0D5G/ng9WEj
	 I3n5N8+c4EqL8J9AYNgF2n/XhREIuVA4juB2Yk7yYUs+lOfwHBEDZ/k1Zy6JgVNLnF
	 FAw2iSqe9uZrA==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Bean Huo <beanhuo@iokpp.de>, jaemyung.lee@samsung.com, Miguel Ojeda
 <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo
 <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Daniel
 Almeida <daniel.almeida@collabora.com>, Tamir
 Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>,
 Onur =?utf-8?Q?=C3=96zkan?= <work@onurozkan.dev>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH RFC] drivers/rufs: add Rust UFS host controller driver
In-Reply-To: <01d56517261d397f5e17101f03554f91529e23f0.camel@iokpp.de>
References: <20260912-rufs-private-v1-1-716db733e655@samsung.com>
 <8mLXEMDMxh8mZQqVywUYUeOiZPZIPmrVGRlOkDbHptW0NEJeszKVpff5h39MjUvD5yyivwY3Z7kCXIH5VlGoiw==@protonmail.internalid>
 <4c38f13af8f75020fefc35827463e9bc643b99f4.camel@iokpp.de>
 <87jyoqvhpm.fsf@kernel.org>
 <01d56517261d397f5e17101f03554f91529e23f0.camel@iokpp.de>
Date: Sun, 13 Sep 2026 15:10:56 +0200
Message-ID: <8733vduwin.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Bean Huo <beanhuo@iokpp.de> writes:

> On Sat, 2026-09-12 at 13:20 +0200, Andreas Hindborg wrote:

[cut]

>
>> > I would also like to see the heavy and hard parts, because they are the
>> > parts
>> > that decide if this design worrks:
>> > 
>> > 1, error handling: abort, LU reset, retries with limits, sense decoding,
>> > this is
>> > the very hard part of UFS driver.
>> 
>> I agree. However, we decided to get the discussion going with a smaller
>> feature set. We can build an efficient feature complete driver, but we
>> would really like to talk to the community about it first.
>> 
>
> I understand you want to start small. But error handling is not only a missing
> feature. It decides the design. Things like getting a free tag for a device
> command while I/O is stuck, abort, LU reset, and what happens when recovery
> fails, are the parts the SCSI midlayer gives us today. In this RFC, when
> recovery fails the queue stays quiesced and I/O hangs forever. So I would like
> to see at least a design for this before we discuss the rest.

I understand. I'd love to help flesh out the current draft if people are
interested in seeing the result upstream. Maybe as an experimental
driver for a while.

>
>> > 2, user-space tools interface: SG_IO and bsg (sg3_utils, ufs-utils, FFU with
>> > WRITE BUFFER), and the UFS sysfs tree..
>> 
>> On the account of this not being a scsi driver, some changes would have
>> to be made. But we should be able support
>> /sys/bus/platform/drivers/ufshcd/* just fine.
>> 
>
> the host attributes in sysfs are only a small part. The per-LU attributes are
> documented under /sys/class/scsi_device//device/unit_descriptor/, and ufs-bsg is
> named after the SCSI host number. More important, FFU with WRITE BUFFER, RPMB
> with SECURITY PROTOCOL, and vendor tools all use SG_IO through  /dev/sg. These
> are user-space interfaces people use in products today, so "some changes" here
> means breaking them. How do you plan to keep them working? Also, the sysfs path
> contains "ufshcd", while RUFS registers as "rufs".

Right. I don't think we should build a ufshci driver outside the scsi
midlayer and still provide (linux) scsi compatible interfaces for it. I
understand that userland tools need to be updated, and that carries
cost. I don't imagine enabling a standalone ufshci driver being an over
night switch. If we go down this road, I would assume the legacy driver
and a new driver would coexist for some time.

When that is said, I do think we can provide efficient user space
interfaces that would require minimal code changes for user space
tooling.

For instance, `ufs-bsg` is not really scsi related, it is just a
pass-through interface to the ufs host controller. How you find it would
be the primary change.

Best regards,
Andreas Hindborg

