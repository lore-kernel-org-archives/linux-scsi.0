Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEE6317163;
	Tue,  6 Oct 2026 02:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791254642; cv=none; b=djlddt8apDXYHdiXGWryba3KZ170zV5lrgC5pnG5CBohpS0ztIzB0xYAH2mg4o00W9iXAg7/Jqecf1Y6WgYEpvjhkmvbJoAFBckg0M5TvWEwTBinc1VlnZLH2yExbrqbG8h8OSMv6Y7g6IsbEBL08wz0j7TkPgTHKY7bLvsrf24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791254642; c=relaxed/simple;
	bh=yIQCHRMpTimKgdNo0eJ4LXeiGdsdoBWR07YG5/kOOag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l/BQ+d+jaeB2YHoskWUjKGVz6HbbA+VkvWPluJ6ibu6Lu/XPPDSydOB++OQXNMM71+wQ+R6vTkzwqMiSjUFddty3TzYRObq14puDlL4dLFmtcbXTMACdkDJbbIIcirnD+p2cgUGEK6qLS+obDMhYXUzglz1HLsAeZfRK5FH73uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EfA/Km37; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EfA/Km37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3D71F00898;
	Tue,  6 Oct 2026 02:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791254641;
	bh=w3eMaA/dAfZyaaGYxGAXlh6BdUVFikHvMq+/MCgOaIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EfA/Km37Mj1DsqWmYwF/N9WuXnilKwPt5410n92WnDb+mGs/nL7NfFJdcaN8QKUdD
	 QFnk9vQSAJLjvr9hxZENYxD6E90WhURJLJXbLSzRdiI2aJCvQJbkEobIYhmsHkTe2J
	 jCDum9UnGplArfF0WgAikdUWtz/mJDZtZagnS6H4TPaP9mny4FHcnOM7ZTY/J8JK2L
	 dUrfdqqUS1Uj4OKbkSOBnacuco5gI9JaF8inB2PxM/qV4oT8NTSXU3Kf3TOeziieyY
	 zAbnDkOiyWOVCEYnW0ramUvMdzVKtZn7PyIovNInFvwyMUOzhU3JnWflA8cby3sjhG
	 l1uClUDRfdlWw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	avri.altman@sandisk.com,
	alim.akhtar@samsung.com,
	James.Bottomley@HansenPartnership.com,
	bvanassche@acm.org,
	Naomi Chu <naomi.chu@mediatek.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	wsd_upstream@mediatek.com,
	peter.wang@mediatek.com,
	alice.chao@mediatek.com,
	chun-hung.wu@mediatek.com,
	linux-mediatek@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	ed.tsai@mediatek.com
Subject: Re: [PATCH v1] scsi: ufs: core: Hold a clock reference across the probe
Date: Mon,  5 Oct 2026 22:43:52 -0400
Message-ID: <179125457799.2089616.17339382964055151353.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909091045.1134956-1-naomi.chu@mediatek.com>
References: <20260909091045.1134956-1-naomi.chu@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Wed, 09 Sep 2026 17:10:45 +0800, Naomi Chu wrote:

> Clock gating becomes possible as soon as ufshcd_init_clk_gating() has
> run, and from that point on the probe keeps accessing host registers
> without ever taking a clock reference. This has been safe only because
> of the state check in __ufshcd_release(): gate_work is not queued
> unless hba->ufshcd_state is UFSHCD_STATE_OPERATIONAL, and the promotion
> to that state used to happen after the last register access of the
> probe, at the end of ufshcd_probe_hba().
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: ufs: core: Hold a clock reference across the probe
      https://git.kernel.org/mkp/scsi/c/02a317831963

-- 
Martin K. Petersen
