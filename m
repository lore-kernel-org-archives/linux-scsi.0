Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795231504;
	b=CHx5dIgZfoGsln+hmSFTi5Q5/TYKkly1eMNP8tr1wSJi03SdkBGZsU7+xu6O4Z7QE1TI
	 lYQ/Xy4lsIdlVyMarAOvaZRnYDnElgo72PvuB4/alVbwRh634p0TszONB9UM3qMXVL77I
	 HlH/pzj08yyjo3BI4oDd82zA4E9OZoZZsSxMYNpucuXNEu/qrY0SonfHxSWaDgdfWUc2e
	 ZQOCgHsMKz8U/++mLG+nx3maT/HVsYokMx511a08WeefIDOqC5gAP7VxRUf3DMFFFlQFe
	 246SG9HXvzpbpDX7xH9ANtRdQeV8A8RhbtGTvKliNjKlCH+qTaSFAlkbMZFsB4804MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795231504;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=dFoQ7O2IGK1nSFEodFxJ6wg6pducvyR4YJQYYfyNJSQ=;
	b=2ngx07B10u/GXOipTU9YDOCUbJLHDFPQaqJQ4+LhWJ5aGWy/E6LOKetA7DLynVZsFfIy
	 glqti9631WFxmrOk1Tnjamu4cBVeuT91bErPR52hu071qZzP1uJqRUU3JeAvXwYXTSMMS
	 KwGFWI/LGATZu//3ZqoxYRcB4t6lXqM+OlfnLQkc26gmpNMmta++2R6duPFrPAjwU7B6e
	 zSuZZt+EVWvRwZEnvFJoP8L1kFxcsKAlYbNu01rPouu5U/XE+5OTS9NvxVu732wTuxi6L
	 0VgarYKtYzg1Z/mtM4/eMUZzhAdyKBfJ41VeAcfDECsxEyaat5yZs/8fD0ngmTdIs9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jHvicj5p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F044606A6B4;
	Sat, 21 Nov 2026 03:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jHvicj5p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903611F000CA;
	Sat, 21 Nov 2026 03:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795231503;
	bh=dFoQ7O2IGK1nSFEodFxJ6wg6pducvyR4YJQYYfyNJSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jHvicj5pwn9sYzEq1EiiCrmFI0Hs6b30eRNfU74OyjDjM5Crvj03ZpxKJRnP8nJFK
	 1j7SCBSWNseSzmrN6O5KJ78OL0kVXhs2IhiZj2Yr5fma9zoR36msDxSBFmj+RnsbGF
	 w6RUmVRU6Tq+rl24BS9RmbaJ2zu1hdmYyRRAz32CPsgBaoL3bv0fvW5ZGdrHeexNL/
	 EflvAcfZ6dva0yvTtXNIhYmnMJCQL3iZl5RZK51OmzOIXMkirufoDlcfNN5L/0bo4H
	 L0p0lKRJjTqFduq/9eDcsG7caqmt4lgEpwhiaABYJDdyWOIBFZ9lCyjGII9v6ntLQ0
	 hL/0u58IAORPg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: peter.wang@mediatek.com,
	chaotian.jing@mediatek.com,
	Xiangwu Lai <laixiangwu@cmss.chinamobile.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	chu.stanley@gmail.com,
	alim.akhtar@samsung.com,
	bvanassche@acm.org,
	stanley.chu@mediatek.com,
	sashiko-bot@kernel.org,
	linux-scsi@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] scsi: ufs-mediatek: fix va09 regulator lifecycle
Date: Fri, 20 Nov 2026 22:24:50 -0500
Message-ID: <179523145639.420187.12014570853735820164.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261119071611.117-1-laixiangwu@cmss.chinamobile.com>
References: <20261119071611.117-1-laixiangwu@cmss.chinamobile.com>
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

On Thu, 19 Nov 2026 15:16:08 +0800, Xiangwu Lai wrote:

> Two fixes for the va09 regulator handling of the Mediatek UFS variant
> driver.
> 
> Patch 1 converts the va09 acquisition to devm_regulator_get() and adds
> an .exit callback that powers the M-PHY off, so the enable count is
> balanced when devm releases the regulator.
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/2] scsi: ufs-mediatek: use devm_regulator_get() for the va09 regulator
      https://git.kernel.org/mkp/scsi/c/def1745a6a8b
[2/2] scsi: ufs-mediatek: restore the M-PHY power state when va09 disable fails
      https://git.kernel.org/mkp/scsi/c/71b5da0b45fb

-- 
Martin K. Petersen
