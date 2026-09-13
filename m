Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2A43EF0AA;
	Sun, 13 Sep 2026 13:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789307086; cv=none; b=WQ+ju4xY/LWQ1oauEzxdbwtxy8bEBm7w103DibE+m2+B6hznjTZ8QUYyFYWyYycjZPuMkFFv/1GJ/fGSKgw5G4+BINXvQx4K2ow7jwRW9ZdJuPLvmOIJSNtUsXlezD2qmwFQFheZWqmb73z9uaXBH5lXac1mJ0rdByBp6eDDotI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789307086; c=relaxed/simple;
	bh=i2WGeqQH68Q4Ba86qdnwpKbZXbPbJYs0hfODq/KlDsU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Iggc+jpt35L5zEIhfzW3lZH4/EaI24FJSKgbYZKP8B3YGZIyGVXy7j23/Cgpnt35BnFAxsM21HlxJlmLU5u5OKlDz+ggmk+XTQF13sFRSTUw3WtO/jOlR+t6rn02TpWSvsN+jVdQeUdM2ydd+l6Vh6WxCTTYZsPnHhNZJzDeE90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OwtMfMHk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OwtMfMHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEEE1F000FF;
	Sun, 13 Sep 2026 13:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789307084;
	bh=i2WGeqQH68Q4Ba86qdnwpKbZXbPbJYs0hfODq/KlDsU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=OwtMfMHkaeK8fzy6kMxd7McWxngHxwVyMbJomdrceij5d7CFaOoym9OYvBpu7+KIi
	 gLA8FFrqhysldQgBcT5sSM6xGSbTsRl5cMjn7VyUGF4AAtlVvYco+L4NY8NQ8QrkFT
	 TbR2/EBwb9nD+iJYpY5r1fylzLNPjw07Z7yolLH+np68kttOQhls7MwpInQ9VF31W0
	 NO4n7gkhel3KMjmafMADvEwjHcHuEIgzHd07/LzVBRdvOKZaLQ14PcqZi16BnXNPgn
	 PpnXSpTg++v5IXhJFafKPDfRM2q8mv/iJ0Jh7W3q5UeaDlibUwtgZwwn7dcis6zPw8
	 yFCESRSN+1xHg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Bean Huo <huobean@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
 jaemyung.lee@samsung.com
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
In-Reply-To: <182679ae5437916095a4b04187e350c80235c088.camel@gmail.com>
References: <20260912-rufs-private-v1-1-716db733e655@samsung.com>
 <YKq4TcQM0v2dXF4wTHEvZKwASII6PDd_R7_UiHWe3NRnR4JsrC_ZS-x6jA_Kl7P6ONehU0REHYk7WaLz8Xv5gA==@protonmail.internalid>
 <2026091124-treason-trickily-bc52@gregkh> <87mrtmvioe.fsf@kernel.org>
 <raUHMVWl_mMP5ffB5hk9eDe5BVvmO01q_9zfZ4NqJ3CymLnRO3EL0_X_K044vKerqwrwXshEVE-o45MXSlGVbw==@protonmail.internalid>
 <182679ae5437916095a4b04187e350c80235c088.camel@gmail.com>
Date: Sun, 13 Sep 2026 15:44:26 +0200
Message-ID: <87zexltged.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

"Bean Huo" <huobean@gmail.com> writes:

> On Sat, 2026-09-12 at 13:00 +0200, Andreas Hindborg wrote:
>> "Greg KH" <gregkh@linuxfoundation.org> writes:
>>
>> > On Sat, Sep 12, 2026 at 12:52:55AM +0900, Jaemyung Lee via B4 Relay wrote:
>> > > Comments on the decision to bypass the SCSI midlayer, the blk-mq model
>> > > used
>> > > in its place, and the proposed prerequisite API boundaries would be
>> > > especially welcome.
>> >
>> > Many many years ago, the USB subsystem tried to bypass the SCSI midlayer
>> > for its storage driver, and while it was a "quick solution" at the time,
>> > in the end, it didn't work out and we dropped the driver as it just made
>> > no sense to keep duplicating all of the logic all the time.
>> >
>> > So I wouldn't recommend it, as long as UFS builds on top of the SCSI
>> > commands and the like, you should not attempt to duplicate it in a
>> > separate driver, no matter how much "simpler" it initially seems to be.
>>
>> The scsi related code in this driver is less than 300 lines and is
>> mostly struct packing/unpacking. I guess we could lift the struct
>> definitions from the scsi layer via bindgen. But at 280 lines I am not
>> sure it is worth it, and it hardly counts as duplication.
>
> I agree the SCSI code in this RFC is small today. But I think it is small
> because the hard parts are not ready in your RFC yet, not because UFS does not
> need them.
>
> The SCSI logic is also not only in protocol/scsi.rs. upiu.rs decodes SAM status,
> and queue.rs parses sense data and decides retries.

Yes, you are right. But it is still very minimal bits of logic. I
definitely want to encapsulate all SCSI logic in a single place now, so
it is more clear.

> And some things are already
> missing because the driver does not use sd and the SCSI error handling:
>
> 1, VPD block limits are not read, and a discard of 4 GiB or more fails with
> EOVERFLOW
> 2, the cache mode page is not read, so FLUSH/FUA are likely never sent
> 3, the residual count is ignored, so a short transfer completes as success
> 4, UNIT ATTENTION and BUSY are requeued without a limit
> 5, LUs are found by 0..bNumberLU, not REPORT LUNS, so sparse LUs are missed
> 6, no START STOP UNIT at shutdown
>
> Each of these needs more SCSI code in your RUFS. For comparison, sd.c,
> scsi_error.c, scsi_lib.c and scsi_scan.c are about 15000+ lines today, and
> ufshcd uses all of them. Once RUFS has error handling, power management, RPMB
> and SG_IO, I expect the SCSI part will be large, and it will be a second copy of
> code we already have and maintain.

I cannot counter this argument without proof of existence. But I don't think
we will be anywhere near 15k lines extra to add these features.

> I suggest you samsung first works in JEDEC, together with the other UFS vendors
> and host controller vendors, to remove scsi from the UFS spec as the application
> layer.

I appreciate the input.

> As long as scsi is the UFS application layer, every UFS device must still
> uses scsi, decode scsi in FW, and RUFS must still send SCSI commands and handle
> SCSI status and sense data, as it does today. Moving this SCSI work out of the
> SCSI midlayer and into a new driver does not make the whole ecosystem simpler.

It may not make the ecosystem simpler at first, but I do believe it will
make the driver more simple.

> It only means the same SCSI work is done in two places, and it can even make
> things worse.

It's a very small part though, so it should be fairly easy to manage. I
do acknowledge that our RFC driver has bits sprinkled about, and that
making it feature complete will make these bits grow. I don't think it
will grow as much as you hint at.

> If the spec changes, then a new driver built on native UFS commands would make
> much more sense. That is the first thing to do, not just post an RFC
> patch.

We did send this patch with the intention of starting this exact
conversation, so there is that. I appreciate your input that you would
prefer the conversation to be started in a different channel.

> I
> could send a Rust based UFS driver as well with AI assist, but that does not
> make it sensible to change the base of our current UFS ecosystem.

I am not sure what to read from this. I want to make it very clear that
this patch is not some kind of vibe coded pile of AI slop. I'd love to
discuss responsible and efficient use of LLMs for kernel work, but this
thread is not the place for that conversation.

Best regards,
Andreas Hindborg

