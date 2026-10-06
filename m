Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F171930ACF0
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 02:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791254688; cv=none; b=XB5TxNCDYIyA9cvWqb6h9tYkWHjHNhgM+JF75clxwzWFWK1zj51d3xtRhCQMynYVI+giBmOAnop3rd44Mfkl7Z7do2cjt/FNIY/Eq40iLQ1boeRRG93C3NXGYp1ee8Z/rUamz3Nb5snF2ggyoZ4NZudW2hMlOu+5RqiU48kL8IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791254688; c=relaxed/simple;
	bh=NYSTpOJndLdBN6E9fU8gqLezr217LKEqh0FIbxhd4Xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z7Nr45XHcCTrAOCckP8AIxXFg3+ZWwgFZoxamHa62j/37a99wzJfrjhiQ/T+h47HgaabzsraHL4qV/LK7Gv4zNqv1tbKZrcrcEdqEObtXhIdLPpq93CxHvcP8C8a83OGPHJiFkRpxMlD8BWyb38bXfpwLM6X1aYsYbupvATxeLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QeMWcZmM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QeMWcZmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4171F00893;
	Tue,  6 Oct 2026 02:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791254686;
	bh=XNYD+CpNcWz00HBG+LHdcTGmGAdIXiwkIYdQxEuIMOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QeMWcZmMVwkBXBy5HmXohbAOEdEszM74TAkTH/Twx2dNH91LmiQI5jdMZPf02Mm+4
	 ZQbKZwGvR8H26qj/LX8fuZNqKLqgspvfabI85oVHlECEbvoOsgtaaHs4HP/dtODT1i
	 UdQUWZdYgDwUIU0CS79NkMvJ7unnMPia6dHosJkCtyuRFazp6k3Szu/kCSaaDJVp00
	 fYQEBFboYWmpG2eNzGA4SIYs3LOAjRcwUKgQRxiEKSZHwU+vpA4g9vFvmF8pBjg8L8
	 ikckrItQFBTKYBbTmTmRGR3M8lnaLOtlDk5lvOxTw6XOQe9FF03Yma2UoD8nxD+fi4
	 u0RqhsdiD+c5w==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	avri.altman@sandisk.com,
	alim.akhtar@samsung.com,
	bvanassche@acm.org,
	santosh.sy@samsung.com,
	h.vinayak@samsung.com,
	"Martin K. Petersen" <mkp@kernel.org>,
	peter.wang@mediatek.com
Cc: wsd_upstream@mediatek.com,
	linux-mediatek@lists.infradead.org,
	chun-hung.wu@mediatek.com,
	alice.chao@mediatek.com,
	cc.chou@mediatek.com,
	chaotian.jing@mediatek.com,
	tun-yu.yu@mediatek.com,
	naomi.chu@mediatek.com,
	ed.tsai@mediatek.com
Subject: Re: [PATCH v2 0/2] ufs: fix POST_CHANGE pairing and AHIT race condition
Date: Mon,  5 Oct 2026 22:44:37 -0400
Message-ID: <179103513133.923653.2927639008481783507.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914085148.136429-1-peter.wang@mediatek.com>
References: <20260914085148.136429-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 14 Sep 2026 16:49:23 +0800, peter.wang@mediatek.com wrote:

> Patch 1 fixes a bug where POST_CHANGE was skipped on a failed gear
> switch, leaving the host in an inconsistent state if resources acquired
> in PRE_CHANGE were never released.
> 
> Patch 2 fixes a race between the sysfs AHIT update path and the
> MediaTek host driver's power mode change path. A mutex and depth
> counter are introduced to serialize AHIT register access and ensure
> AHIT is correctly restored after the last disabler completes.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/2] ufs: always notify POST_CHANGE even on gear switch failure
      https://git.kernel.org/mkp/scsi/c/6efee14ca0ae
[2/2] ufs: serialize AHIT register access between sysfs and host driver
      https://git.kernel.org/mkp/scsi/c/7dec5cedf7b2

-- 
Martin K. Petersen
