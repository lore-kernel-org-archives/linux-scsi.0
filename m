Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792615394;
	b=1etMaZXVMGCch1gjVQwbe4CfIMaa8ZW+gJvuQ3BUk/0aih5LZlbh+H41zrcxtUmHpDlz
	 0ZxIdVVT+B0FVqczoNrLlSTyhaX5DaIEnxa3VfZgMwsG95g5OXZWDin2YSJ/E0A9yVZqm
	 4MyQ6SArqttiDDkES3+KqNSBKEOeU35Vzua4w4KaDuR1Kz24q6X35uc4rLInCUY4kDW/V
	 jnnn7NPcFEBGNzaG9sovFzaP8EOKrLjztu9KfuR7kFrMvcYKG1o+ilrfIKX/jaI+4Jx0r
	 lQjVQt2Jbg/HbAGx4Pa+xc6fKtYNajQV8Ml0oSEsvJnTk6VIP3UkAAhV5lVNkPJM/5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792615394;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=X+hgZpi6s8zitINqxdtV3NY32G2toc0s1ujAuu40Bds=;
	b=JWsjWYs/6POFVc0FE2/auMT3d2UDTF/8v0JumvEsdEjShfelE04FPl0Un/FPefxgbDVR
	 60gT6LKUSTa4LQqmzqsb2e4cSACyGUFoashCfPIOcpc24M82lp73R4ZHQaewQOjYx0Cm+
	 5SJJd8sNpNG+DooXvQ6yYwpJs8jOEjce6V8tsuFEIFyZlTYtFbKZvIRzsIXQLyVE4pnM3
	 hmg8IMGp31FH6FnqadBcl031ygjS7fMsF6s4afk0iWkSgEfFfHmKw97YXjYONqFYhmsMG
	 hxEJfXLytJ9c7RWQgkkCz1Rokdf9Ck89U/S9ig/J5jWYwM4U2EV9ST3EEjWy8jetqvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WCvT85l+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA901606A31A;
	Wed, 21 Oct 2026 20:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WCvT85l+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56C61F000C1;
	Wed, 21 Oct 2026 20:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792615393;
	bh=X+hgZpi6s8zitINqxdtV3NY32G2toc0s1ujAuu40Bds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WCvT85l+M7vTXVdOSjvWu80mi6GWub+PZZf3lI8wNnsP/A/vd2Xa6CnSvLHJF1lYJ
	 ldFG4vYTZ4hx0b0/Uu0Iz19+/9418gCW0jP79P/LMsCtGL4YnMULwet2uEGibn1jh8
	 pbjUcYUH424ZeWdOvaP0RHhndcc6u7bQnNKyzAOAunAUt8/xRIqQHYbc77/eKe46wD
	 o6b8akppup4YR0drKqecUYAaRet3P9REgqiSo+CzN/r7TUHmdZe7HSFqvCkxbnpCoZ
	 KCp1zteSv40HEZNvYL+U6u4dhQtinkxeKoHLjN1O0P0bB0gduZ9PAAMY0MAfPrUb2v
	 9wOy2B/bMwq0g==
Date: Wed, 21 Oct 2026 14:43:11 -0600
From: Keith Busch <kbusch@kernel.org>
To: Runyu Xiao <runyu.xiao@seu.edu.cn>
Cc: Christoph Hellwig <hch@lst.de>, Breno Leitao <leitao@debian.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Lee Duncan <lduncan@suse.com>, Hannes Reinecke <hare@suse.com>,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: Re: [PATCH v6 0/4] nvmet: avoid recursive configfs open
Message-ID: <atkj3yg7e_ff1vt2@kbusch-mbp>
References: <20260926092148.128937-1-runyu.xiao@seu.edu.cn>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926092148.128937-1-runyu.xiao@seu.edu.cn>

On Sat, Sep 26, 2026 at 05:21:44PM +0800, Runyu Xiao wrote:
> Several configfs store callbacks open user-configured paths while holding
> the item's frag_sem.  If a configured path resolves into configfs, the open
> can re-enter __configfs_open_file() and try to acquire the same
> non-recursive semaphore again.
> 
> Add helpers in configfs for opening non-configfs paths, then use them in the
> nvmet file-backed namespace and passthru paths.  The series also pins the
> target-core db_root path and uses the root-relative helper for ALUA and APTPL
> metadata, so the helper has its target-core consumer in the same series.

For the nvme changes:

Acked-by: Keith Busch <kbusch@kernel.org>

The bulk of the series is outside nvme though, so probably should go
through a different tree.
