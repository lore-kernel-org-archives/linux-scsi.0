Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792809755;
	b=OqPzMYprmokc8JiAg6aM+pGPY8XCKiw2GGAjiSB8lr1I4rOc4tgsgGrFrNA5pSD2qoRo
	 WIc135cARJe+mnrCTC3Wi6H8MUDSClFZRk63CH8A8gKS49p+UFijgw3s3JEiybAeXqQdo
	 f73uqjWeENlvMcNs2Jx88p38lgsX3keWChAcj6nSRiUYtCqh6HnKBS4Tkuo7j8w7B9+B0
	 IZlc3NqQBJPDZwdAQK5sToe2FffAshv8K3bB3y7nmzN7MEBfYs5lNCdc8XhkjEpOniR93
	 qwgarFiPWafIE3FXDhEwe4CgptGV30QwwyvgL3fULaJME9/SYQg4doU5N3QCDSNVw5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792809755;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=Vf45xBiVED2G/Oc0EkV8Bsna4r0DeZpLW4RTQFvxpdI=;
	b=kU3SWT8MWr1hCxXnI8ks/lI7ZD2XXmwnBAMd8YGuI2ckSeHB9ZlzcabaRIQxhtnjGSIV
	 IUfwdtf5i4zB2x0b18Dasb/spzz8xxKv6aZBRE2oT+2gHNn0s1wSAWBASXa75JL62k/Ap
	 dvEgm2gOU5RZqKsEFEYR8OfMWlhp57ouCf+JgFTovBctFcTEu0HmuZ9SmrXICZ6jidDP+
	 6yimlIKs0jv9/GmuX6lRRwQvwnz4Wd3hPqOTD0v8ycct6rt7kwcwe2yoVwkojgdMeDa/r
	 EIRSPn0abIlR2oytuyti5C4oOsPXLSO8q/wHui/jQ7/p9hu7RWh4Czwzqz0INOYpjHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="m/TUyXGA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17AE606A31A;
	Sat, 24 Oct 2026 02:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m/TUyXGA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21201F01825;
	Sat, 24 Oct 2026 02:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792809754;
	bh=Vf45xBiVED2G/Oc0EkV8Bsna4r0DeZpLW4RTQFvxpdI=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=m/TUyXGAAL36CHYzwH4zcdnSQkX7GfYhptvFpHc566t5b83EoztiHJavrWE53m8Q5
	 aZw7sZfWYec5KPRVScRpWB4g4N4LlqSPd07uXwUMo9V0ua1JlOeipVw4ashX46xwk5
	 id1ByvfpOUSeQDMu1TWQpp/7Cg8bW0HxzfmTktuHRY6xPNhIV6pT+lwlur4NsUTqRz
	 S3e6vpc/fDX7rLZO5eDLJ3Pb/SNfn3PLTBF3nHBSGOlVuebYrokjuTHpf8Ynf4ZitY
	 8vLS+8EOjFQBVt+gELBVslws9QF8IpY5Or2T2glIsI6YwWS/US5l3F3+ezYCvu/jds
	 sXDOJ4i9lX6ow==
To: Joonhoe Kim <26rote@gmail.com>
Cc: James.Bottomley@HansenPartnership.com,  mkp@kernel.org,
  alim.akhtar@samsung.com,  bvanassche@acm.org,  beanhuo@micron.com,
  stanleyjhu@google.com,  peter.wang@mediatek.com,
  can.guo@oss.qualcomm.com,  mani@kernel.org,  linux-scsi@vger.kernel.org,
  linux-arm-msm@vger.kernel.org,  linux-kernel@vger.kernel.org,
  stable@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: core: Fix a deadlock between clock scaling
 and device commands
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261016124608.46-1-26rote@gmail.com>
Message-ID: <yq17bj7akfk.fsf@mail.kernel.org>
References: <20261016124608.46-1-26rote@gmail.com>
Date: Fri, 23 Oct 2026 22:42:32 -0400
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


Joonhoe,

> Since commit 08b12cda6c44 ("scsi: ufs: core: Switch to
> scsi_get_internal_cmd()"), device management commands go through
> blk_execute_rq() on the pseudo SCSI device, which shares the tagset
> with the logical units, while ufshcd_dev_man_lock() holds
> clk_scaling_lock for reading.

Applied to 7.4/scsi-staging, thanks!

-- 
Martin K. Petersen
