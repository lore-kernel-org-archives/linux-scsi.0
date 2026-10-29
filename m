Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793239388;
	b=E6O+8ILoqfbazEbG4fRg44/F2tZnDsprcyIkdyavyjhWaSEwC6WxGqra7TgJiH5mXTqQ
	 xpM9StHlmlY09KIIRxFulUFvvnQLB9JR3P/GQxtBBZqqwGJvtyX/xWpvbmJYttr383Ll6
	 Cd/skiUbLAvf/kBBkeHxiSXopCRCK0DQShC8trgUZcXMG3nd4EhyIW1Q0NOnuJOodUcob
	 AKMPqb5B20iy2mwyJey42cnWjIDMJxtd+8I2gcvrgSONd1LS/R0Z91dZBIPPIeBtSnv8m
	 5aR9bdiLv6braMDW9nSwBkcPXzjjbGLQO6gQ8zULRmGJ1HlDYgpHnZhj7Jfhp2cOu7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793239388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=hsjzbJh0YAhA7aU91BVufRu1UhrX9+xX2rsFcUjkoRE=;
	b=lkSAwRhDyZjaV6xEZPHgcAgaeFaOfMvrHcXjHvtIM1kBPAD4ahk2nPL2Ns3aboWMF75d
	 fPVWIc9t8732fA/Ek/6ehgz09XvGLplMqY4NjIX+2bggsxdVuZ9M899BEkCKFFy/KJ60A
	 j067qhNzC5BpgdFtgIt7k9h9JhAyRALTScXrcVLNz65tfYqUegeoQzrR/BD+1q0JZpuEn
	 ZWI9/7uDmPg12z9n4i26nWSBGLO7PXwBtOqB/7pPr5GtOloAv3bxxWfaLgcqOGP8DrlVx
	 rEQwc3oq+dyh4dzuygYcN5PlAEwPNn1QWUalsEKjtWcbCrn/F/MXeyXIcWcrUHR5NSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BhyW3HU5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31ED606A329;
	Thu, 29 Oct 2026 02:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BhyW3HU5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016201F01828;
	Thu, 29 Oct 2026 02:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793239388;
	bh=hsjzbJh0YAhA7aU91BVufRu1UhrX9+xX2rsFcUjkoRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BhyW3HU51R1W0N1kp8nr9+0HbArY2fdiqtHKdkCZMaom2TO8N3ppO1ACicN8tIHOQ
	 lNLYyfATDJkfx8hkrKZ72FHifFU0fMmNmoQ8QOS0xT0tcoGC+FZtoijVyvLyGud88r
	 GpygPEm8zISLgBpLwhgtyal+bY7DZ+W7c3PW9hvEwmwxEfgDWMBqwYRc9935qh1gU9
	 jEHK6AJbhjC/QSTqWXGip0izUq+qUIZp7vr1O2CrKFxHOIT7LqUcr8l9EEY6TekoxY
	 omhu9GtdZLJSPHPoLaVZoPfslfSzESDEcZzl9Nlx/ypCi1YSHf4eD9qXdaZVkFjh9C
	 VZuirgcZD3/Iw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Manivannan Sadhasivam <mani@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Alexander Koskovich <akoskovich@pm.me>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-arm-msm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: qcom: Power down UFS during system suspend on Milos
Date: Wed, 28 Oct 2026 22:02:45 -0400
Message-ID: <179323465394.491807.15697827904056465787.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261005-milos-ufs-suspend-v1-1-a6f8b89d5b63@pm.me>
References: <20261005-milos-ufs-suspend-v1-1-a6f8b89d5b63@pm.me>
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

On Mon, 05 Oct 2026 17:02:06 +0000, Alexander Koskovich wrote:

> On Milos the UFS PHY GDSC is turned off on every system suspend and the
> PHY loses its register state, so exiting hibern8 on resume fails:
> 
> ufshcd-qcom 1d84000.ufshc: pwr ctrl cmd 0x18 with (MIBattribute 0x0, mode 0x0) failed, host upmcrs:0x5
> ufshcd-qcom 1d84000.ufshc: ufshcd_uic_hibern8_exit: hibern8 exit failed. ret = 5
> ufshcd-qcom 1d84000.ufshc: __ufshcd_wl_resume: hibern8 exit failed 5
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: ufs: qcom: Power down UFS during system suspend on Milos
      https://git.kernel.org/mkp/scsi/c/fb2a238f15f0

-- 
Martin K. Petersen
