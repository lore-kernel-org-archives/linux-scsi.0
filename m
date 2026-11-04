Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793764892;
	b=yxqssdj27b34ZXx9NLlew9LCHzjaGFmQswSv9BSguGnBidf/uBIFsX83re63CaCuQhkG
	 iapmTdCwVYno+9l1YWhfbrul5EhXcuD9NWkzLrhr4q81N2ZLP8wgmcu/0PFbNsI9dRrDO
	 hanVilY6AVTYLWh8AaGP2gJ6/aldDMbct4ERkEXHosKwE4Gjomhiyo3ZxoW0B4WIB/3nZ
	 gROtlcL6HnSxxktRLokNHp10DUTD6TEiS5pG4QTHgKKxB6qvnW/VKdikx55aEnBan8kuy
	 bM4afx1BH9dUtzhms3ZyczmXYAsyHN/5qX+O1xmRig4iDyt/9lrU49xbGJK39V2PkgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793764892;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=/1dU8e61s2vkxtqA+cfEG/dxLqcY89ivlUgGlD1anYU=;
	b=tugFCN6wZDEpJEswNrEzjWqRU5WXiIkXGkA40DIuu674ilNK4SLhrceZXSt0dKGSbFeW
	 yH1467VqY3qNskK3OAAoY3RB9u5iJ8dZsaASkvR1ooswXqwg/kMASOI/f5/ts1UldqHs1
	 Fanm2pQTms90AYUgFrB28yeNh2y9sQyxOvpXg+E1eZh9kjDVpyICW05XLKwhSThZ3fGCs
	 sqvxwGtLd/5S/7M2p/uiDn1k2Jtq9BtAR1Bedqdi7f/zJq00g2+m5IKbkR0QlMEz8/av0
	 Y9rSgNiD2NpqVX2vQcl0NUW8wJPCRh7Gzbn623l4QZ4BcSnPfb/gbuhLsM5dC0IH47Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XeldWw6q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8040A606A31B;
	Wed,  4 Nov 2026 04:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XeldWw6q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FDB1F000C1;
	Wed,  4 Nov 2026 04:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793764892;
	bh=/1dU8e61s2vkxtqA+cfEG/dxLqcY89ivlUgGlD1anYU=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=XeldWw6qgs30WTKwiJFcdrGPcSPnkCorMgpwxfD+p1I100McIPHH3qUML6TWwpAoO
	 cy43jis0ewNWprp/k3s8qTxEOw1pCMqClRBdyAlMZ/adn8LbtjY3CDLvR97iEQ+F74
	 XOSQhNWA19sTMMlqks3Z80FcO2i2gefVq65GQzxZR+f7vRVw0clTxd6fuJ6JYdgGiC
	 McOKIvqKuWCp4Nx5rL2ftk02GtJ0Ex8mE/DihLv1FHrxobcB/rMZgDPmgv8ommh5h2
	 xKjQCtGTaBs1FEwmWqUKqVYOoZUTGVCOTDJOO5RRvLiRh2R4+1Fb1DSamINDLUt1tx
	 +5vMRWpkBZVgA==
To: Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,  "James E . J . Bottomley"
 <James.Bottomley@HansenPartnership.com>,  Alim Akhtar
 <alim.akhtar@samsung.com>,  Bart Van Assche <bvanassche@acm.org>,  Bean
 Huo <beanhuo@micron.com>,  "Rafael J . Wysocki" <rafael@kernel.org>,
  Praveen Talari <praveen.talari@oss.qualcomm.com>,  Peter Wang
 <peter.wang@mediatek.com>,  Can Guo <can.guo@oss.qualcomm.com>,  John
 Garry <john.garry@linux.dev>,  linux-scsi@vger.kernel.org,
  linux-pm@vger.kernel.org,  linux-kernel@vger.kernel.org,
  stable@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: core: Keep clock-gating hold on failed W-LUN
 runtime resume
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261029040002.2100002-1-stanleyjhu@google.com>
Message-ID: <yq1a4np1bzk.fsf@mail.kernel.org>
References: <20261029040002.2100002-1-stanleyjhu@google.com>
Date: Tue, 03 Nov 2026 23:01:30 -0500
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


Stanley,

> 1. __ufshcd_wl_suspend() takes one ufshcd_hold() reference and sets
>    hba->clk_gating.is_suspended while the UFS device W-LUN enters
>    RPM_SUSPENDED.
> 2. Since commit eef1d74bf88f ("PM: runtime: Only set runtime_error on
>    suspend callback failures"), a failed runtime resume (for example
>    START STOP UNIT completing with an error) leaves the W-LUN in
>    RPM_SUSPENDED with power.runtime_error == 0, while
>    __ufshcd_wl_resume() already clears hba->clk_gating.is_suspended and
>    calls ufshcd_release().
> 3. The next W-LUN runtime resume runs __ufshcd_wl_resume() again without
>    an intervening suspend and calls ufshcd_release() a second time,
>    dropping a reference it does not own and underflowing
>    hba->clk_gating.active_reqs on UFSHCD_CAP_CLK_GATING hosts.

Applied to 7.4/scsi-fixes, thanks!

-- 
Martin K. Petersen
