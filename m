Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794977374;
	b=SltpTwC57s7TrX3nAUgNGXUs+kCD55Kr6wvbxY8UniqAh1E87tdtLXOowEUfsEVoO3S8
	 T9vqWBIbrOi0NjTn6PLSQlQ6lZLm4Alm1pUPhCtXOo8bkIbjzngmRnavxkc17+xgEcLf6
	 M7egMRiA0SSwEZhkY/7oq0DOEpSYZMhuz0dgYQLGRAzE0cqhF/hiBTti8DGk3psIBGSwW
	 PBuZfKfHlhQtLkqJQGjY/hJ5ER0MBSdNOQH45nJXYCbEtLzNAemFdp/xTamAOs0G+2a7W
	 NwqVnKQEnQBMkiJS4BWED64n0a38J9aW3ilPApVylQaEtKrI9wSygVYg9SZdepCx3aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794977374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=CvCHzuVLqXCPEwLIoRCqyouZE4b9IQxzVknyWeegm/A=;
	b=i8Hg7/JqugvVe/BRap0efSMOj72Cu/iLL1q4X+DnukBlLL+0aYTcGPC4QYqcecgVlT95
	 +Xzfqr8e5LiCGMwAVQYoIP/BQLUg4vVofNWLpcSGdzYJ4q3Bg4cDIqtYv6zzuQA0T3d1C
	 BNDhGtTbIM5AqcBhw75T0pTNzortMhqG9hXtxXw4qp9nzXPid37feXqCHTye6zTZfEfZ0
	 xr/bVcyQLlPMGm+HB+2Wd2jvpo39CtqvHmNLWXvN6Nwvbm7/YMjYwwqOOgO/rAYMmtayQ
	 7f7lJZ0QnBi+9c9NxBQT+fxmWgyqiwfCvXkCtC7rjFjH5HXYQGyGYZGJtlySbMmKyAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eMCXwDkq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18D9606A33E;
	Wed, 18 Nov 2026 04:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eMCXwDkq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED30B1F000C5;
	Wed, 18 Nov 2026 04:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794977373;
	bh=CvCHzuVLqXCPEwLIoRCqyouZE4b9IQxzVknyWeegm/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eMCXwDkqf3jCnnmUK89QyGHVVgRD6I40x7gm84YKIUtuFLRMYBNYniUPNWPeSlQeR
	 d/ZZRNGNtOjXr2fWoWcN30roGS7batnB9ws81mRVomSFQSBbjPyx1RQ7wX2XfpI2UY
	 wxcJzEVeS6DLKszwcNK1+ZbgPlCAY7eedpHPwY1qXgx5TwaKI5zoqnMi/K6LOVjyCt
	 /Ar3neRDht0AUmRI9Vf3yx3vDhS2yZ5qKNI1i9CMEOToPvjcFDdhEaOUxIRWWB8ZZA
	 BZatzT0xz/Zx10FzxbnlT4FJcE5u8vUnHLbIxZuPeOBGP4x+pmijwMvhJsZIRiofyF
	 zYhO81Wvm9Nqg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Changyul Lee <lcy8047@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ch: Remove the minor from ch_index_idr after device_destroy()
Date: Tue, 17 Nov 2026 23:49:22 -0500
Message-ID: <179497726112.2093762.6233686313671984860.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261109160651.986356-1-lcy8047@gmail.com>
References: <20261109160651.986356-1-lcy8047@gmail.com>
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

On Mon, 09 Nov 2026 11:06:51 -0500, Changyul Lee wrote:

> ch_remove() removes the minor from ch_index_idr before device_destroy()
> removes the "sch<N>" device. A changer probed in between can get the
> same minor, and its device_create() fails:
> 
>   sysfs: cannot create duplicate filename '/class/scsi_changer/sch0'
>   ...
>   ch 1:0:0:0: ch0: device_create failed
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/1] scsi: ch: Remove the minor from ch_index_idr after device_destroy()
      https://git.kernel.org/mkp/scsi/c/9f9e0b1e5399

-- 
Martin K. Petersen
