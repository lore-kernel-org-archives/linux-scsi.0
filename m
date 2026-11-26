Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795664100;
	b=hiHW0VI+QaRLTCHLtwrrfdFiHrHWiddpxdYdOmOgZEPOfwHRaGCEUVOOrkU5QYLT45QV
	 iaWg1BbEXQIMUqe6lOiV5KWkY+l+KZG9mm0f87FtmDc/Hc8Zc7VmVFPxhZLzWymXuRl5O
	 lDJOa5kA5TvHi+NyRmjgjzVDa5SauA7RQYfUDqMmk8jkStrkNzuGxN3Ct30S1lL0ZTYJe
	 xnnMx5rIEuMLT4SjkcleTXP1CAYD1GBcB6H64W8UGpg/colAX817uiDweUBbIi4xkb++z
	 KzMyg15SEcc9n6mPMpCe0MiUBTnOYpt4SZJXj5NqEXIdcdv4MySHjtrKvDsO7RYY/Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795664100;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=oCMBTJs6hAheq11GB+nvv82b3H3Up8qNZapd21sR0gE=;
	b=IAYYwtSsRnd5uH8/50wn3IJ5v9uvxBYa1/3Hl8dluQivV52DP/hElpzS9tW/2MaUcWqE
	 ET3rvpaliVJJaGxTNPPz0L2Lx/FWzU8wyLYNo2yvvMUKhl/U6t7zbt+8PwR+7D/cbOVRd
	 +JEGasgeRDGhP0Omv3ixdNZQ8VztKCx5kVreWL6m1eBWR4zA1g90fs0F39JGwpigetgBL
	 eC5nFn6GtFTIeWjhsWCKFwVIhtvXcEWFINHM1xmIHmcMAqH5MuKiMrBjBw3FS0++45F5d
	 pJfQ2RmanaEo/SWunq8XGmUTaDSA3RRVJJQVwut47bNbRSNzCcWVlgw8/zUmr18alNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ajGDbepz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE92606A31E
	for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2026 03:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ajGDbepz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1004E1F000CA;
	Thu, 26 Nov 2026 03:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795664100;
	bh=oCMBTJs6hAheq11GB+nvv82b3H3Up8qNZapd21sR0gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ajGDbepzeAwBdDKa5pr/4EgQ8crYW3SAzGKtFSfIVvN9bujKKip4i2dvfP4uJYMeM
	 qSmjs79k+bXU2xhe3SH2JR7GBUSXytzpTdiQhS8SsUHrU1fgWzD+IhuQvjmUkEpeiJ
	 IDmDgaZiYSfVI9+yqcQfuIW9iViPAjX6ZngZ2sQ+EZ3FiH8Vem9Nxz+cXr4Q17pI5X
	 Mie54vwJs9pkDp6o5tukQcf72dOLogPIM2/NdqyE2+31N6Fky+opQD6ynr95A2yL0Y
	 Wr4w6Tm7k4w+bgCkTkOUqTszxnEyZCFZVEpDaEb8ONKYA1AVsscjhFqJswclvN53T5
	 Bmv/9VuMFJ6RQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "Martin K. Petersen" <mkp@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org,
	kernel test robot <lkp@intel.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Chaotian Jing <chaotian.jing@mediatek.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH] ufs: mediatek: Use ARRAY_SIZE() instead of open-coding it
Date: Wed, 25 Nov 2026 22:34:46 -0500
Message-ID: <179566062773.467514.15833634009150035105.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <547675c30e66d7664c0adec81f025986ab6ddfce.1795135740.git.bvanassche@acm.org>
References: <547675c30e66d7664c0adec81f025986ab6ddfce.1795135740.git.bvanassche@acm.org>
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

On Thu, 19 Nov 2026 16:49:11 -0800, Bart Van Assche wrote:

> The kernel test robot reported the following Coccinelle warning:
> 
> drivers/ufs/host/ufs-mediatek.c:1351:32-33: WARNING: Use ARRAY_SIZE
> 
> Derive array bounds from the arrays themselves such that these bounds
> remain correct if array elements are added or removed.
> 
> [...]

Applied to 7.5/scsi-queue, thanks!

[1/1] ufs: mediatek: Use ARRAY_SIZE() instead of open-coding it
      https://git.kernel.org/mkp/scsi/c/0943d0da9366

-- 
Martin K. Petersen
