Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02A247D466;
	Sat, 12 Sep 2026 12:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217316; cv=none; b=cVO5eQrlV8aJLcZkPewCfs/Z6lks5ngxro42JGBnTRCLdj1tnAFcF7/OCS7FtUVy+B6TT88qCvUNF5YiwyTG1OuUrOES4QYOCHsfQ32C1ficUKMEOxD6B/uuqFgeob0oy5P8xUXTKjQM0W7TiSM0k4GLw4mvklQmUTwarZBxoeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217316; c=relaxed/simple;
	bh=vyJGV4JTyUMJJxhfsFR2Nv1plQv8UDisiKH6uxehU7I=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=i2Oclh/kBDrc1b98b1HiYcWRUWQQrCFJ+rYgaZOqzAsQEhFojzmGNvyYNuaP+a9wEc89fWdkHGWJCg2sElYZjKZspx5/2Mw2lPWE/zoQU5pVo0zFR0c6mhSeTK8O5piZ9Hq2Gcxm2Xzi0iUmtULNzpTMSxKLER2iDsnpxXK5iUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JVpeWVFs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JVpeWVFs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D361F000FF;
	Sat, 12 Sep 2026 12:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789217314;
	bh=gIMrFH/Fq9pidQ2ah33PGbMQpe/2w1fY0Or2D5cQEHQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=JVpeWVFs3OwMcJ2I/anIKundOYz7e0ZE5cY2a9JBBSx55zbyQmIaXdhu4a1YTItRg
	 d4D2UvPjfBLisBtUjXnwnXRbV456q+ELSdNpJZkimduP9tlBqEq7rVPffjcEhkuZ7u
	 clfbU0wR7YUVhxDOHmY3ACWTgZ1Zo6tOqXFbeEaP7MpaVcRwgV+28Gbo9OJ5q5IPl/
	 0oB6G/lnFrdjEXr3Eei7pOUmKSPQSkvo35xDG9cPxxlUOSDh/38j4w1Ih9PG0Ef4tf
	 +iyIm1c5SYa4MPpCyhOg7mqo+7CH0DlknbSD06DfsFFuKGb3QH9MYEdXmXLrOAHO4Q
	 YgKdLXiTLN6RQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH
 <gregkh@linuxfoundation.org>, jaemyung.lee@samsung.com
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo
 <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Alice
 Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>,
 Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot
 <acourbot@nvidia.com>, Onur =?utf-8?Q?=C3=96zkan?= <work@onurozkan.dev>,
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH RFC] drivers/rufs: add Rust UFS host controller driver
In-Reply-To: <bdcff6a168e6d4b8e9c9524bd598281817a7df2c.camel@HansenPartnership.com>
References: <20260912-rufs-private-v1-1-716db733e655@samsung.com>
 <YKq4TcQM0v2dXF4wTHEvZKwASII6PDd_R7_UiHWe3NRnR4JsrC_ZS-x6jA_Kl7P6ONehU0REHYk7WaLz8Xv5gA==@protonmail.internalid>
 <2026091124-treason-trickily-bc52@gregkh> <87mrtmvioe.fsf@kernel.org>
 <6JMwZ4EuSfQ8V4TGaPwatQ31m30TceLJblORsuILQmy4VV8Fx2lHbihL8ARsRUuJmaSUqek8L54y4Nk6DuZMXQ==@protonmail.internalid>
 <bdcff6a168e6d4b8e9c9524bd598281817a7df2c.camel@HansenPartnership.com>
Date: Sat, 12 Sep 2026 14:48:20 +0200
Message-ID: <87eceyvdnv.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

"James Bottomley" <James.Bottomley@HansenPartnership.com> writes:

> On Sat, 2026-09-12 at 13:00 +0200, Andreas Hindborg wrote:
>> "Greg KH" <gregkh@linuxfoundation.org> writes:
>>
>> > On Sat, Sep 12, 2026 at 12:52:55AM +0900, Jaemyung Lee via B4 Relay
>> > wrote:
>> > > Comments on the decision to bypass the SCSI midlayer, the blk-mq
>> > > model used
>> > > in its place, and the proposed prerequisite API boundaries would
>> > > be
>> > > especially welcome.
>> >
>> > Many many years ago, the USB subsystem tried to bypass the SCSI
>> > midlayer for its storage driver, and while it was a "quick
>> > solution" at the time, in the end, it didn't work out and we
>> > dropped the driver as it just made no sense to keep duplicating all
>> > of the logic all the time.
>> >
>> > So I wouldn't recommend it, as long as UFS builds on top of the
>> > SCSI commands and the like, you should not attempt to duplicate it
>> > in a separate driver, no matter how much "simpler" it initially
>> > seems to be.
>>
>> The scsi related code in this driver is less than 300 lines and is
>> mostly struct packing/unpacking. I guess we could lift the struct
>> definitions from the scsi layer via bindgen. But at 280 lines I am
>> not sure it is worth it, and it hardly counts as duplication.
>
> You didn't actually read the above did you?

Yes.

> The problem isn't
> necessarily the duplication of code per-se it's the duplication of
> function without understanding the subtlety.   Every fool thinks they
> can duplicate the core features of SCSI in a few hundred lines (and
> they can: the core SCSI model looks beguilingly simple).

Yes, it's really just encoding/decoding. Not much semantics or logic.

> They then
> usually spend years adding back the necessary corner cases and quirks
> before finally concluding that actually they shouldn't have tried in
> the first place.

Please educate this fool then. I am curious what SCSI logic we would
spend years re-implementing in a detached ufshci driver.

> Just because it's in rust doesn't change that
> calculus ...

On this I agree with you. The implementation language is not what we
should discuss.

> and you're by no means the first people to try this, so
> listen to the voices of experience and don't.

In general I do not accept arguments that take shape along the lines of
"I have x YoE doing this, therefore I am right".

While it is possible that you are in fact on to something and that your
experience is the reason for this, it does not further the discussion. I
would much rather have you explain to me the reasoning behind your
expectations for this effort.

If it is "someone did it before and it did not work out" - who did it and why
did it not work out?

We have USB MSC as an example. I was not around back then. What
happened? Was their situation the same as it is for UFS? What scsi logic
did they try to implement in their driver that was a duplicate of scsi
midlayer? Surely it was not the 300 lines of command encoding/decoding
that made them fold?

At any rate, the rationale for extracting the UFS driver is to make room
for features that fit poorly into the SCSI midlayer and which are not
standardized in T10 - without making additional work for scsi subsystem
maintainers.

Best regards,
Andreas Hindborg


