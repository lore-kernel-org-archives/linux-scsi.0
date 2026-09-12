Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E1D3542F8;
	Sat, 12 Sep 2026 11:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212804; cv=none; b=RT/pB7qEKjuvJB2lRoB2Gsgi95MrgC0pj0VVOs6lQ0v42vqkjhrpClK+6HcQSfYI9EhfQ4Zc77hEqARz40Prry0VzY/wY0dukBTbdgvv2v5hJsBDjrkQEov9u3nf4To1Hn8P83c4wiYPL9k7X3eufKSeddZbH3TYGeHr5PPvspI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212804; c=relaxed/simple;
	bh=jHMpy7W+6pYaxQUIW6oyr569wiZlfptEuuhGKXUk7Nc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=eaWNPaE9G1DvyFIGSRER7Bn+1MJX1oYEvHH8tNKqWInYJuoNGkosiQkSBV4KAFp/4azvp01TqLaZG7Ik/HSVdtF7TepXnVAqRzcbfGyxmKzM53X0Sq+hzFWqMMhXZof9zR74d+rZjokWgLdYWWYIgs/6kIaCxuBb5pO/dx+YPaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UHPnf6Vt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UHPnf6Vt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE371F00899;
	Sat, 12 Sep 2026 11:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789212803;
	bh=S47KYQb4Neki++unFILrRCKoWSsYxzIvskBpIQiIYVo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=UHPnf6VtIgexvSEkgH7cRCPW+V+h6nnlIyA/6OMBVq9AeHJP4uVhy8RXBlpbA4I+m
	 tI/vj+KJwAcZc9UvEW+6jf1PrrYBkj6hn4ovY9FsQ28HBxPewkfflLGlojPUhrMlLk
	 VztOcrkja6nRAZXW5NbtP3eeNQN9PIZAgOc5M1BMjgavZ3Bguv34qgJEP5MeaBeCpc
	 pgK2AkibgD3A2c1aH7Qr0qcJT4DKvhfGu19zQS2wF1eY4S5u+Wl6bj40BBWnJzCmfV
	 6DbGWlsLFS0UI33Ma+/BvpMcwMJAIYpNxJ9hTWYfherCw2WGqRziRKLvlhsKoygVUk
	 exe2sP1vwHZWA==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>, jaemyung.lee@samsung.com, Miguel
 Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo
 <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Daniel
 Almeida <daniel.almeida@collabora.com>, Tamir Duberstein
 <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, Onur
 =?utf-8?Q?=C3=96zkan?=
 <work@onurozkan.dev>, "Martin K. Petersen" <martin.petersen@oracle.com>,
 James Bottomley <james.bottomley@hansenpartnership.com>, Jens Axboe
 <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH RFC] drivers/rufs: add Rust UFS host controller driver
In-Reply-To: <94ee6bd1-8126-4a99-9b9c-d58e16fd9d9e@acm.org>
References: <20260912-rufs-private-v1-1-716db733e655@samsung.com>
 <94ee6bd1-8126-4a99-9b9c-d58e16fd9d9e@acm.org>
Date: Sat, 12 Sep 2026 13:33:13 +0200
Message-ID: <87h5juvh52.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Bart Van Assche <bvanassche@acm.org> writes:

> On 9/11/26 8:52 AM, Jaemyung Lee via B4 Relay wrote:
>> Add a Rust UFS host controller driver that exposes UFS logical units as
>> native blk-mq block devices without depending on the SCSI midlayer.
>
> One of the goals in the Linux kernel is *not* to duplicate code.
> Decoupling the UFS driver from the SCSI mid-layer implies duplicating
> the functionality of the SCSI mid-layer. I do not agree with this.

As I answered Greg, the SCSI specific part of this driver is less than
300 lines of code. The driver is 10k lines. That is not really
duplication to be worried about.

>> The driver is written in Rust.
>
> Most UFS driver contributors are not familiar with Rust so I think the
> choice of Rust will make this driver unpopular.

What an excellent opportunity for those developers to get familiar with
Rust in a domain they are already experts in :)

[cut]

>> On Intel UFS 2.1 hardware, 4 KiB direct io_uring at QD32/job gave
>> these optimized-mode ranges over 1/2/4 jobs (three samples):
>> 
>>    Workload  Op     RUFS kIOPS   C kIOPS      Difference
>>    --------  -----  -----------  -----------  ---------------
>>    randread  read   48.91-61.26  41.56-41.60  +17.6% to +47.4%
>>    randwrite write  8.19-8.30    8.21-8.22    -0.4% to +1.1%
>>    randrw    read   5.26-5.34    5.28-5.38    -0.9% to -0.4%
>>    randrw    write  5.27-5.34    5.29-5.37    -0.8% to -0.5%
>
> "Intel UFS 2.1" sounds weird to me since Intel never produced any UFS
> devices as far as I know. Did you perhaps want to write "Intel UFSHCI
> 2.1"? If so, these measurements are not representative since UFSHCI
> 2.1 does not support MCQ. Measurement results for legacy (SDB) mode
> are highly sensitive to whether or not the I/O submitter runs on the
> same CPU core as the completion interrupt.

Of course PCIe attached Intel UFSHCI 2.1. As you probably know, this
target is more simple to bring up due to less platform knobs to turn.

We will provide measurements on recent MCQ based hardware, as soon as
possible. We elected to start the conversation sooner rather than later.


Best regards,
Andreas Hindborg

