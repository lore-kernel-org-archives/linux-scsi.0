Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794196553;
	b=rbZKwbeHp5wN90jmDmTfriNQhtyeAScuGlC2s96jYJYhlyr2KUUDxvxHfTStg86/wpwC
	 WjC9Zgd3SqOTiEseY8M88DSXihG0OLnwjqrPSZRIkUyHjVhy82h1QpMnvy5Fz/SqG3dhH
	 xm3LFVrswH7m5WT2zIdrLyFci+xk929+ImGhbKffaxR0GB6bol+dQFQC/eZSQgEfZvfS7
	 x9ItTzzoQQXiorC3MDzQLzNJ1wKScrGiQrjAZspyt1j7NS9RDZ7yV9vPk4yP3iKmCeAlH
	 A+WeBrdrhSqPqHpE+mbZERiEz7pzB88rWSFt7vjGH+4KNr9Bq3pitdkt+BDqwoSvQbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794196553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=UkBYlDRfFAFHx0ZeU9YgTCt0FCfO4cFBWtXdrkaRvBU=;
	b=L2EbMXLeNdaRV2s2pNvFrWO3H6EKF9Tgkc+se5XoduHCBFV6/2pNOQcU78oJD/3yPk79
	 vQBJIXJaHwjdJdFO6amQTGDUtvDZuevwOT/tP5F/nSAH2nNCF5r6JFuvfQ0B/CFotpYyl
	 QvfabxreXQwyeIKDAl2/LIqjPjS+mUPyr7fnARqvRILReg7WQ7Di9k+SsPuNFFHL1UPh4
	 dCiX4S85Tqc71ja8MGPzWAfNh8elTTwvbSaq6XAFG85FNq7RAMAZQ6LHfTB564ZJUoDII
	 cpSleL75qtI/GmMpqBwFTUiaw+rNGymuFBbgGBzFTFmmEGzI8lu3tseB0+q1YIBpf7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ng1lNkbE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574AB606EEAF;
	Mon,  9 Nov 2026 03:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ng1lNkbE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDFB1F008A3;
	Mon,  9 Nov 2026 03:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794196553;
	bh=UkBYlDRfFAFHx0ZeU9YgTCt0FCfO4cFBWtXdrkaRvBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ng1lNkbEes0S8cHTbJoTuuaNVmfJJUh2Y9oMvDPbv5o6/i+PE/BZfkcJCtxSh74a0
	 cGF2YndecuMxkl6Tlsr3FBJSoi7fTq7+ws79Ca/9CTGRVExhucx8tjXUlRBFX2mAd5
	 9cdeVa/B8QOAyWTnzKdWAZZ05uBFWempuPeezR1sOMhcho3DS0VZqRYUAkFCPTIAc+
	 f1qLxgS15YzBDEuSoNLjvQR+TQpa4QKwGEtOVoyw+NazpZLsDs55BJ2AUgxp7f0DaX
	 NgEIbTnnzeUaRT+Vgq1E7tnSZ8r8SdoSubvscxUY6P7kMI9bx8X2HcwaSRzS+77LLd
	 fH6GuZSecviyQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	Can Guo <can.guo@oss.qualcomm.com>,
	Peter Wang <peter.wang@mediatek.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] scsi: ufs: Fix device management timeouts and runtime PM errors
Date: Sun,  8 Nov 2026 22:55:33 -0500
Message-ID: <179419615223.1941224.16892442993527729749.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029040003.2100003-1-stanleyjhu@google.com>
References: <20261029040003.2100003-1-stanleyjhu@google.com>
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

On Thu, 29 Oct 2026 15:08:35 +0800, Stanley Jhu wrote:

> This series fixes two problems in UFS core entry points that issue
> device management commands or touch host registers.
> 
> Patch 1/5 restores the millisecond to jiffies conversion of device
> management command timeouts. Since the timeout moved to rq->timeout,
> a 1500 ms query timeout waits 6 s with CONFIG_HZ=250.
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/5] scsi: ufs: core: Restore jiffies conversion of device management timeouts
      https://git.kernel.org/mkp/scsi/c/ebf5cab0dd22
[2/5] scsi: ufs: core: Introduce ufshcd_rpm_resume_and_get() helper
      https://git.kernel.org/mkp/scsi/c/cbab12e5b4a7
[3/5] scsi: ufs: sysfs: Propagate runtime PM resume errors
      https://git.kernel.org/mkp/scsi/c/93891d1c486e
[4/5] scsi: ufs: bsg: Abort ufs_bsg_request() when runtime resume fails
      https://git.kernel.org/mkp/scsi/c/2b8541edf7c4
[5/5] scsi: ufs: hwmon, debugfs: Propagate runtime PM resume errors
      https://git.kernel.org/mkp/scsi/c/9eb89611d959

-- 
Martin K. Petersen
