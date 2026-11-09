Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794196543;
	b=irzRI7MeTDVwUv1sHmrqzxj7cyluYYoAlQEXrRED3wFHSvzZm6dsdOj57dHhZF3zYIG4
	 GHFnz0L4sADAmnFz/2jpcYob2mqNbjrg6SmWnBJrOZ71NujcYPhDsEPYb6l0JU+yaYWG5
	 1myUtVwoZ1VX4c90uSrO4cJ3K3Dml5sd6ohKBNR9zyLAoviGCME6hhSIaC2ifOV/O0nOn
	 te0sWCLUZpfm/re9VRHELsd8ncxmNdTsfavoThFunMBJCWqrogT8fPHwexqSDm4hhqYK1
	 XfdAqW+EVMb7DiXXVjwojW4LeIE/sBDdPMhsPZS6rBFwTtYsf5dEzy6zQ6UjRyZzfqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794196543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=JEVJBhPy/V4deCNOg24XuS4U2E56XDFsn/acO2RWXIc=;
	b=nSIwi1I9tHhIzEcV7D0ktJNuvx1bVV4XvfQTenv6o1UJCkBlieFhFR/o1KXJQ+Z18T5h
	 6r8cFhvgL/salcTSSiiEqLCafbjH/vvtNN+kWBea7/8+KaABlTS5UvA7GmJV64IJFe7/D
	 HjcV9hFV1cTMVkogD6+XdZQLmHp8PRKKi1Ps+i5t7SDfOK7HCVSNNXTFWH/QYGA77FHOk
	 Yxq1GpFa1Jl/4JjNZPEiG+NGYrCIAmgVeKllf+vWTWRTEZLGsUKpHWAAXxnCQs+oqQfHt
	 jB1zrOQCsWzLRqRgEC49zVd4324QYsb6EGjTtl0+pFEqj7GqBfjrhWyp/Oi9TiYgNPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YuXqcH+K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E27606D81D
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 03:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YuXqcH+K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAAD1F008A6;
	Mon,  9 Nov 2026 03:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794196543;
	bh=JEVJBhPy/V4deCNOg24XuS4U2E56XDFsn/acO2RWXIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YuXqcH+KAPVD0cJ1l3WvJcEzrP8LdexVZQofgS+gUxHOSWJBfv7lAT70C//rUfuKE
	 04EBcU8WfFAu/FdYr9gr7c4laix+PDAnOMK8YRrOSZER8RtRrte/aLnrrwq5by6rso
	 dNwg+RbvoC/TkU0NY+eKuSpad8PLVIX8EMNO62fVc30GVhuQ5mFDfjthMWem0mo3qL
	 FYC6T+3LWqCNuVjbHK1OIMmoFhcCGwWWBMQVLMxx0Vld8Mj+ZzZ49m28h4v0bHp2bJ
	 4bJViGNRcJZcxeTSesBnIxfh0U3UMtKph54vig2MHRJ1dPXHXREgg73nEn+ASfhUN5
	 gvj+rHsOtcFYQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: James.Bottomley@HansenPartnership.com,
	"Martin K. Petersen" <mkp@kernel.org>,
	Dongdong Hao <doubled@leap-io-kernel.com>
Cc: dlemoal@kernel.org,
	hare@kernel.org,
	hare@suse.de,
	yjzhang@leap-io-kernel.com,
	kezijie@leap-io-kernel.com,
	jzzhang@leap-io-kernel.com,
	baikefan@leap-io-kernel.com,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] scsi: leapraid: Fix init_cmd_priv error handling
Date: Sun,  8 Nov 2026 22:55:24 -0500
Message-ID: <179419615229.1941224.3635462012519013734.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104092808.206067-1-doubled@leap-io-kernel.com>
References: <20261104092808.206067-1-doubled@leap-io-kernel.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 04 Nov 2026 17:28:08 +0800, Dongdong Hao wrote:

> leapraid_init_cmd_priv() ignores the return value of
> leapraid_internal_init_cmd_priv() and always returns success. If
> dma_pool_alloc() fails, io_tracker->chain remains NULL, but the SCSI
> midlayer considers the command successfully initialized.
> 
> A subsequent I/O requiring more than LEAPRAID_SGL_INLINE_THRESHOLD
> DMA-mapped scatter-gather entries dereferences the NULL chain buffer
> while building the chained SGL, causing a kernel crash.
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: leapraid: Fix init_cmd_priv error handling
      https://git.kernel.org/mkp/scsi/c/04feb5fd2c23

-- 
Martin K. Petersen
