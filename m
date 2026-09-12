Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1BB4718D7;
	Sat, 12 Sep 2026 11:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210812; cv=none; b=Hu5sBZALHfxJBkzk+bGw7hASeeLerCkFf704aASx3vwI2jPdSxYHdvGb0vmldfxFcuXTnMpmEYE2Vjo6E4Dg0exjPOfLpLWdPaLZmC2GNG29Mc3CuQoFJq+BR9OgJ4qghx7ZRTpA9DW42b1DPc1B6PyJZnEll1+YwGcbMLpk6ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210812; c=relaxed/simple;
	bh=yMOmuHQZeZO2DYB4FecN+9SKHrlnAi9MIs6rM4dzN8Y=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lPktYCZpcNDJIZFsZ1wwl+4UkwuK61iesiedcLu7R9mr41vYNgDYvgnjAez5do0JdxBLL0dQop4JEhF4tfWvLYFzJ8AGj7Mziwwv7E8A8uzU+9bDppOYSkITYwXysExsMlMmQZXPnqWe/v6eGEDnx91JtyWudj9/6x7DpJaflPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q8Yt7vt2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q8Yt7vt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C991F00893;
	Sat, 12 Sep 2026 11:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789210811;
	bh=xLww4sKnxO9neFXT3j4RVAXakrCt95cYTPTrtUYkk4U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Q8Yt7vt2zA9T7oJXUqwgXtJl++1dWs9Wyc/txnDnArGbsa5Ltq9V8/4AHXcXUNzjb
	 w0WfcKLqW3EuIAUHexWf8cP3DSCVH9I/+6WaKSNm0yA3NeqnazfVFmzVM/MNOYc1VE
	 PJ3j3Kz79v8PNPBP+kgMI7s+bAFWb6CxTwmwwYWoz67/NAPRUZWmt3MbuT6pze1GPp
	 LQi4dzfo3oyapfZpSzobdabTEo5s/KHikxd7i7UY+RZvXS0y5COysldbnsNK4mExzY
	 BYymrz3Owr/as2YOhmAh5diPMEbr3zt2EZbvsRRBxtmZjMVLSebch5lrNzPRZwMVHf
	 NPmPVz4Bytz9g==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>, jaemyung.lee@samsung.com
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
In-Reply-To: <2026091124-treason-trickily-bc52@gregkh>
References: <20260912-rufs-private-v1-1-716db733e655@samsung.com>
 <YKq4TcQM0v2dXF4wTHEvZKwASII6PDd_R7_UiHWe3NRnR4JsrC_ZS-x6jA_Kl7P6ONehU0REHYk7WaLz8Xv5gA==@protonmail.internalid>
 <2026091124-treason-trickily-bc52@gregkh>
Date: Sat, 12 Sep 2026 13:00:01 +0200
Message-ID: <87mrtmvioe.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

"Greg KH" <gregkh@linuxfoundation.org> writes:

> On Sat, Sep 12, 2026 at 12:52:55AM +0900, Jaemyung Lee via B4 Relay wrote:
>> Comments on the decision to bypass the SCSI midlayer, the blk-mq model used
>> in its place, and the proposed prerequisite API boundaries would be
>> especially welcome.
>
> Many many years ago, the USB subsystem tried to bypass the SCSI midlayer
> for its storage driver, and while it was a "quick solution" at the time,
> in the end, it didn't work out and we dropped the driver as it just made
> no sense to keep duplicating all of the logic all the time.
>
> So I wouldn't recommend it, as long as UFS builds on top of the SCSI
> commands and the like, you should not attempt to duplicate it in a
> separate driver, no matter how much "simpler" it initially seems to be.

The scsi related code in this driver is less than 300 lines and is
mostly struct packing/unpacking. I guess we could lift the struct
definitions from the scsi layer via bindgen. But at 280 lines I am not
sure it is worth it, and it hardly counts as duplication.

The ufshci driver is duplicated by this driver. Our suggestion is
replacing it.

> But really:
>
>>  30 files changed, 10005 insertions(+)
>
> 30 files and 10000 lines doesn't seem that simple :)

You can take a look and decide for yourself :) To each his own I guess.
To me, reading this ufshci driver is much easier than reading the C
ufshci driver along with the scsi subsystem.


Best regards,
Andreas Hindborg


