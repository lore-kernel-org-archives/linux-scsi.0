Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36BF475334;
	Sat, 12 Sep 2026 15:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227959; cv=none; b=NekZH8g9dK4RuvYH+KBRCTXgILfpZSRuaAVzkJBVcKnggRm+pVQ0rroXn8mvYZLzPzPsPHrovdpOi+FwosHrtXW773T5PdV56GHo3dRDiRV9PGzpmOZ4jN/Aa2pmBjDkU1C804FV97VN8iN0AbSs9n3mP/da55d6c20mYiVYFww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227959; c=relaxed/simple;
	bh=8ER3or0aXOIo0/gTiBp/Gq/PHHeOUbuTmPzvW2r3QXE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=L9qxIbFs7+msMNpvyTumuXY/rGFKpYkG/CS2+pdtmmIMaB8u5eAaUKPHtDZfZ8Fbc0dL0KgQDJV71XL8CfUcxMWyedDoBRnF+56Yvw0WvzJpGbklIc/QO72+LMHQ4RXkt+Fj6EEm3E09xUgT6bgFEdVs44G8aT1wy47tjrdkWS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CkeJklpE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CkeJklpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE201F00893;
	Sat, 12 Sep 2026 15:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789227957;
	bh=gpE7hpvn6MeyqhNqz6cqrOOcN1VuNhouP3veEi9dIbg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=CkeJklpEnRwbNrIxrKlLQnEuLzgdLELqJF1eB/s+4eS7jLuzzVGSXv2L/zkCtJVcB
	 0Olv8XzAmLMSX1tpUITfj12F32msiFralKrN8PbiOKs4Bb5ewkANjrAO5k8HzXjAFW
	 J4HQFV9XRXFaYDj/HbU2OeJeGS+C5CbtD9vaTcYWW9eDqYUS+9aexjllTf5ZG46GWx
	 dxgkuPWTp2VhzZ+CtZ/stz+EbdbZbBgmoQ7Zi5fCjab5oHm1y7zbbwujCGB+ahWfGh
	 eLIRit3CWFjw4spA9hN77HJ6fnNSzbPhWYA2oBxrRUDrNjDFeZMLd/5kKx9GNi4gQH
	 mhdhSA1padJ3g==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH
 <gregkh@linuxfoundation.org>, jaemyung.lee@samsung.com
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Alice
 Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>, Onur =?utf-8?Q?=C3=96zkan?=
 <work@onurozkan.dev>,
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@iokpp.de>
Subject: Re: [PATCH RFC] drivers/rufs: add Rust UFS host controller driver
In-Reply-To: <77e00073a9254d5ea1ade771590da81a859b75a6.camel@HansenPartnership.com>
References: <20260912-rufs-private-v1-1-716db733e655@samsung.com>
 <YKq4TcQM0v2dXF4wTHEvZKwASII6PDd_R7_UiHWe3NRnR4JsrC_ZS-x6jA_Kl7P6ONehU0REHYk7WaLz8Xv5gA==@protonmail.internalid>
 <2026091124-treason-trickily-bc52@gregkh> <87mrtmvioe.fsf@kernel.org>
 <6JMwZ4EuSfQ8V4TGaPwatQ31m30TceLJblORsuILQmy4VV8Fx2lHbihL8ARsRUuJmaSUqek8L54y4Nk6DuZMXQ==@protonmail.internalid>
 <bdcff6a168e6d4b8e9c9524bd598281817a7df2c.camel@HansenPartnership.com>
 <87eceyvdnv.fsf@kernel.org>
 <RJ3H-1s-vh5YR7DRuPZ6p050ld3umNGcKNeBigg7n3KUQt1WJ2C-sR9kEqrF6f4ubj5AHoHNvB0MRGJyw6tf_Q==@protonmail.internalid>
 <77e00073a9254d5ea1ade771590da81a859b75a6.camel@HansenPartnership.com>
Date: Sat, 12 Sep 2026 17:45:45 +0200
Message-ID: <87bja2v5g6.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

"James Bottomley" <James.Bottomley@HansenPartnership.com> writes:

> On Sat, 2026-09-12 at 14:48 +0200, Andreas Hindborg wrote:
>> "James Bottomley" <James.Bottomley@HansenPartnership.com> writes:
>>
>> > On Sat, 2026-09-12 at 13:00 +0200, Andreas Hindborg wrote:
>> > > "Greg KH" <gregkh@linuxfoundation.org> writes:
>> > >
>> > > > On Sat, Sep 12, 2026 at 12:52:55AM +0900, Jaemyung Lee via B4
>> > > > Relay
>> > > > wrote:
>> > > > > Comments on the decision to bypass the SCSI midlayer, the
>> > > > > blk-mq model used in its place, and the proposed prerequisite
>> > > > > API boundaries would be especially welcome.
>> > > >
>> > > > Many many years ago, the USB subsystem tried to bypass the SCSI
>> > > > midlayer for its storage driver, and while it was a "quick
>> > > > solution" at the time, in the end, it didn't work out and we
>> > > > dropped the driver as it just made no sense to keep duplicating
>> > > > all of the logic all the time.
>> > > >
>> > > > So I wouldn't recommend it, as long as UFS builds on top of the
>> > > > SCSI commands and the like, you should not attempt to duplicate
>> > > > it in a separate driver, no matter how much "simpler" it
>> > > > initially seems to be.
>> > >
>> > > The scsi related code in this driver is less than 300 lines and
>> > > is mostly struct packing/unpacking. I guess we could lift the
>> > > struct definitions from the scsi layer via bindgen. But at 280
>> > > lines I am not sure it is worth it, and it hardly counts as
>> > > duplication.
>> >
>> > You didn't actually read the above did you?
>>
>> Yes.
>>
>> > The problem isn't necessarily the duplication of code per-se it's
>> > the duplication of function without understanding the subtlety.=C2=A0=
=C2=A0
>> > Every fool thinks they can duplicate the core features of SCSI in a
>> > few hundred lines (andthey can: the core SCSI model looks
>> > beguilingly simple).
>>
>> Yes, it's really just encoding/decoding. Not much semantics or logic.
>>
>> > They then usually spend years adding back the necessary corner
>> > cases and quirks before finally concluding that actually they
>> > shouldn't have tried in the first place.
>>
>> Please educate this fool then. I am curious what SCSI logic we would
>> spend years re-implementing in a detached ufshci driver.
>
> The "duplication" is incomplete (it's actually only sense code handling
> in scsi.rs, but the rest of the duplication is sprayed all over the
> driver).

The SCSI logic is the CDB encoding in scsi.rs and about 50 lines of
completion disposition in queue.rs (status to block status, unit
attention requeue). I agree that the latter is the start of what
scsi_decide_disposition and sd_done do, and that it is incomplete. What
I am not yet convinced of is that the complete version for UFS is large
or subtle compared to scsi midlayer combined with current ufshcd.

> The incompleteness is fine if you never test for it, but your
> users will run into it in the field (almost certainly in error
> handling), which is when you begin the reinvention.

Correct, the RFC deliberately leaves out recovery and task management.
We wanted to get this discussion going sooner rather than later.

Of course we would validate the driver with proper testing before
declaring it stable.

And yes, the encoding/decoding surface will expand a bit once we
implement TMF and recovery. And there would have to be a bit of logic to
handle that as well. And that logic would be similar in semantics to
code in the scsi midlayer. I doubt it will be many lines, but I feel
like I have to build it first to convince you of that.

> As Greg said, this
> is the exact path USB storage tried ... and they did it because their
> devices barely behave like SCSI ones so they seemed different enough
> that there was little overlap with core SCSI (i.e. exactly like the
> JEDEC comment in the cover letter).
>
> What I don't quite get is this isn't a criticism of the language or the
> rust project, it's a criticism of the implementation methodology of
> this particular driver; and it isn't a theoretical criticism: it's
> practical; this path has been tried before and failed.  The definition
> of insanity is doing the same thing over and expecting different
> results.

Agreed, and I did not read it as a criticism of the language.

For ub, the deprecation commit from 2012 says it was removed because
every device it handled was also handled by usb-storage. Not because the
SCSI midlayer turned out to be deep. The UFS situation is different. The
device population is a handful of vendors behind one host controller
spec.

If we expected this new driver to be a strict subset of ufshcd, we would
not build it. The reason to do it is the features that do not fit the
scsi midlayer.

Here is what I count the midlayer doing for UFS today: sense to
retry/errno disposition (scsi_decide_disposition, scsi_check_sense,
sd_done), the abort to LU reset to host reset escalation in scsi_eh with
ufshcd supplying the handlers, the sd device model (capacity, write
cache, UNMAP, runtime PM), and the SG_IO ioctl plus the scsi_device
sysfs tree. Which of these is the part you expect to take years?

Best regards,
Andreas Hindborg


