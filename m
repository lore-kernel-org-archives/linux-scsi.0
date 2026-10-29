Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793239387;
	b=iHB9RPOqVQxRqtJ5KIM3VsdXzPwvEstAcxvV3KRbo6tdFiLPfpkFJz9EgPxxSOJpufJj
	 wcHf7BgxhwseGlqc6diKDwLmW5o4eiZxUaq+mDa9b3vDNNH7EfclIto4NmbLUtm8izsYz
	 gaEJDkzHx/LbdMPvKNl2D1L+cV2Gue1EeyyA3sqlNLzyPx1z2M44hN+sefyjBKsnjpHUD
	 e3NCR4NWb1KYSMGV+gQ3To35J6k56mG8T2ZP3fAg0andxIw24IqcAPq4oP8w0R2w4pxPd
	 kqSpDywov+fyUcogVnEUHZ91v3Imiy3BB9/UxdkLd3bVzqqM1blRrmbcGN1vi5O6R/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793239387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=82EWEmTBFTHlp3Xbk9DdfBWQDqYO1PeqHpfQuSaH6o8=;
	b=Q5yMS6XwOdl1bHzg9TkNR3cbyPDenwPyTZJ5CfjdE94HXyB1UsJf29XI8D/jsX1zIQfl
	 xCydqEevisakWn8/8tyUicIBXzV+eMpWlYBbPJfoabWLdf2Up2WMJonOmS26e7A5suh9m
	 iIcn9wQXv90v5XhSy+N4/sYkC976iYZ+UFfUPo0ly0wihHUjngWflVnMbIcf70e/JJXir
	 G3/75usJkK92X0fIOwm57+S77OPL8QBy+vipXC/eol90x8B9ak5vkr+ZMTzm3kGULfvKw
	 KlH5FyusCvsWkkg6/g3V2OdycuPScpirVMKZ9BFmfbRaSbDBb2jDA3RvKMHnA8oGYmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DCXGBdls;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B6E606A31C;
	Thu, 29 Oct 2026 02:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DCXGBdls
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5937F1F01829;
	Thu, 29 Oct 2026 02:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793239386;
	bh=82EWEmTBFTHlp3Xbk9DdfBWQDqYO1PeqHpfQuSaH6o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DCXGBdls4rNx+a5PDTFNAov6fZxMx8gV51xcRKLX9ieFKyMYjnNT/p5N973wDwERG
	 wYTe8o4yQynY7q6ihffPul38/8wj3TuDPWHCTmP9kmHnok7yjaO/stXmzPNTSn3JVG
	 6fKCfZBXMgj585GRyek361zkvugL6eHkW0arf5qYr2NuZPptsvrCi58a5rcrFVRyJK
	 Lw/6HFqXxyxRDDXt3zI8kYIjkHcEEceO/tAWtY7wvTvy4FqmyEB+YWQI+VdYrDgszf
	 Mu8cThzts2uR7cwbE8FFhQ9lRg0tUsepaswmp0i4gJMYa3Bmx+0EZDNbBOjPA6aho1
	 8L/svisLTTUIQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: James.Bottomley@HansenPartnership.com,
	Joonhoe Kim <26rote@gmail.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	alim.akhtar@samsung.com,
	bvanassche@acm.org,
	beanhuo@micron.com,
	stanleyjhu@google.com,
	peter.wang@mediatek.com,
	can.guo@oss.qualcomm.com,
	mani@kernel.org,
	linux-scsi@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: core: Fix a deadlock between clock scaling and device commands
Date: Wed, 28 Oct 2026 22:02:44 -0400
Message-ID: <179323465378.491807.15412315305334194970.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261016124608.46-1-26rote@gmail.com>
References: <20261016124608.46-1-26rote@gmail.com>
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

On Fri, 16 Oct 2026 21:46:08 +0900, Joonhoe Kim wrote:

> Since commit 08b12cda6c44 ("scsi: ufs: core: Switch to
> scsi_get_internal_cmd()"), device management commands go through
> blk_execute_rq() on the pseudo SCSI device, which shares the tagset
> with the logical units, while ufshcd_dev_man_lock() holds
> clk_scaling_lock for reading.
> 
> ufshcd_clock_scaling_prepare() and ufshcd_pause_command_processing()
> quiesce the tagset before taking clk_scaling_lock for writing. A device
> management command holding the lock for reading at that point is never
> dispatched and never times out, so the writer waits forever with all
> logical units quiesced. On a Lenovo Legion Tab Y700 Gen 5 this ended in
> a hung task panic.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: ufs: core: Fix a deadlock between clock scaling and device commands
      https://git.kernel.org/mkp/scsi/c/2327df6d2a29

-- 
Martin K. Petersen
