Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC85C3DDAFB;
	Fri, 11 Sep 2026 19:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789153412; cv=none; b=InGkIDPEW7JaRf+riPrNn/INJ3t4WPYJ3i/TB/DcDFsOw+S2dJmrjexmRKTNt320OxliYn5SvVzzntSxNBOcbUBkymBTssWNSzUqQVP/zpJ8Kr6EMU/MfR361b/aWF8WEVD+5baPR9n0gwuh0pvVi7osLTEcHh/MpXugADf39Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789153412; c=relaxed/simple;
	bh=AAJxS1ZeWVorNTNsOrxKWTuYDxU3bdBsDIZpKFEvAmw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CLCq1/Lk9XICTyWDyG+EoqjExhNzXTeIGY89uIvnae+A9v4GXxspxJdvHQIVoISY+lvcBGcs56797amlhKCeRyfv1XA+RhABmWmEWSljNbZjhBam/tkpxDtQRMDO9f58plQKPVojxMvDo8OT0Z96jcPpz2kuo9XBWfDoBmxOPBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cvtq3BMS; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cvtq3BMS"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hhP8K6yzjz1XM6JN;
	Fri, 11 Sep 2026 19:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1789153394; x=1791745395; bh=HKB85OlUopoTlP2cYiFJXnK6
	cXsUfRhylsdCN0AeosE=; b=cvtq3BMSIvQZr2O49qdJ6rlypEbTYIyBHGdXHuqv
	zIQoCJdk6hmmw5EQ8jzvupgBakf1+/wLZ89T7v3w0Df7xOz5KW7YPY0X3o9ydnSj
	CPRUrlf7SLM8jqy5fWIrjAHa7BxSWD3RK6/ju+f2klBF8xBun202aSqXZxvtzg6o
	zLmS+GHWyIXINcaqUmyBwOkN/JgqhPnUR9B5GRFwVnuGQOZyfIHu0Ik1d/UdKHSZ
	FNOpXXNQLRcYFEBsfyf+gZ3dZxQQScj7pAmki8+tGVzPSC6abnP7OG9en+86g7Dc
	rpEaaypiB1JNtoZDKWHSA8uhSTBfyT5838f2QYxB1GsQTg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qvovV8J3T_kX; Fri, 11 Sep 2026 19:03:14 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hhP7t6bfRz1XM4Sx;
	Fri, 11 Sep 2026 19:03:06 +0000 (UTC)
Message-ID: <94ee6bd1-8126-4a99-9b9c-d58e16fd9d9e@acm.org>
Date: Fri, 11 Sep 2026 12:03:05 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] drivers/rufs: add Rust UFS host controller driver
To: jaemyung.lee@samsung.com, Andreas Hindborg <a.hindborg@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Daniel Almeida <daniel.almeida@collabora.com>,
 Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot
 <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 James Bottomley <james.bottomley@hansenpartnership.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-arm-msm@vger.kernel.org
References: <20260912-rufs-private-v1-1-716db733e655@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260912-rufs-private-v1-1-716db733e655@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/26 8:52 AM, Jaemyung Lee via B4 Relay wrote:
> Add a Rust UFS host controller driver that exposes UFS logical units as
> native blk-mq block devices without depending on the SCSI midlayer.

One of the goals in the Linux kernel is *not* to duplicate code.
Decoupling the UFS driver from the SCSI mid-layer implies duplicating
the functionality of the SCSI mid-layer. I do not agree with this.

> The driver is written in Rust.

Most UFS driver contributors are not familiar with Rust so I think the
choice of Rust will make this driver unpopular.

> The existing UFS driver is built on the SCSI subsystem. That made sense
> historically: UFS adopted the SCSI Architecture Model as its application
> layer, so reusing the SCSI midlayer's command queuing, error handling,
> power management, and logical-unit addressing let UFS reach Linux quickly
> and reliably. ufshcd bridges the SCSI midlayer to UFS Protocol Information
> Units.
> 
> That foundation has become a source of friction. The evolution of UFS is
> governed by JEDEC and increasingly includes UFS-specific features outside
> the SCSI command set standardized by T10.

Huh? As long as I was attending JEDEC meetings I insisted on using
commands already standardized by T10 and *not* introducing new commands.

I do not want to give UFS vendors the freedom to introduce new commands
without coordinating with a standards body that has more experience with
the introduction of new commands, e.g. T10.

Linux filesystems support the NVMe and SCSI command sets via the
abstractions offered by the block layer. Introducing new types of
storage commands would require that the block layer and all filesystems
are modified. I have not yet seen an good example of a new command that
warrants such changes.

> On Intel UFS 2.1 hardware, 4 KiB direct io_uring at QD32/job gave
> these optimized-mode ranges over 1/2/4 jobs (three samples):
> 
>    Workload  Op     RUFS kIOPS   C kIOPS      Difference
>    --------  -----  -----------  -----------  ---------------
>    randread  read   48.91-61.26  41.56-41.60  +17.6% to +47.4%
>    randwrite write  8.19-8.30    8.21-8.22    -0.4% to +1.1%
>    randrw    read   5.26-5.34    5.28-5.38    -0.9% to -0.4%
>    randrw    write  5.27-5.34    5.29-5.37    -0.8% to -0.5%

"Intel UFS 2.1" sounds weird to me since Intel never produced any UFS
devices as far as I know. Did you perhaps want to write "Intel UFSHCI
2.1"? If so, these measurements are not representative since UFSHCI
2.1 does not support MCQ. Measurement results for legacy (SDB) mode
are highly sensitive to whether or not the I/O submitter runs on the
same CPU core as the completion interrupt.

Bart.
