Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E6C363C5A;
	Thu, 17 Sep 2026 02:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789612127; cv=none; b=NfsQa+YYhS9EB2PvtmsVvF9VGEQakg1EH3EnL8BgeChMov7mG8RFyRbbMoeKuLxGm1+8ihqq4RTxfrDIYehORd+ODc1sFO0ngeGXCcABRrwv8KmrSA/KxDjJtVrWHqhRWBL5GOxsZoAQSayxLYC7B9QXKH7k8X05XPUdchaa+OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789612127; c=relaxed/simple;
	bh=+h/6BUa2JTzU0H09cFmdvh5pstXh9+A0yD4FHi9Ga7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E9krVCVjZrkETBMdbBe8FlUlui2rBYvEpOjjc7b0PfptGCt2yM348neRwNcpW13Yz5uj5Ksqiogu7lqR620SiWivLlEMxOnKC/Xf75fY0VQ2YQPL9urMABiw765P8WRaQF+EvsRVq0tzH35yGI78ijCtqhla6ZP5kD2Upf4sQFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bYYZ6bkL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bYYZ6bkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB451F0089C;
	Thu, 17 Sep 2026 02:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789612115;
	bh=emXmYOuF+tfT5M625pdnqLmTtGeJrrfh6Bt6ARP8fAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bYYZ6bkLViN9LUPUwnTyDIRDIHVFKFQUI8Gt13igU21Hcgry6WSKE2HLbtBIOihi9
	 us69HxMtLePSKJeM2XplMLyaZMFnCPgnJybYNcJvqGTU4TllKht5m2P8Xs9vRpoVgD
	 P1kQaZjMtFBo4gJk0BFYiLrGgNoj1KrdJKu8jRsE7jD9jXbKwtni0CTrWE+dez+pX2
	 cVqmDxczkxfq4XtS+9LTshsOhyU9Bn7SEvW5dAabdUN7dmpQ2cqTqKUFK76rw+iulj
	 2cFkNXu0idoYdYy9fu2FCphVX54zDlqoHiLa0XCqd0RMF8Av4BTSCyn9lOsy9oSLRk
	 zdh3XkLBbj7aQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Palash Kambar <palash.kambar@oss.qualcomm.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Koichiro Den <den@valinux.co.jp>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: pltfrm: Add quirk for R-Car S4 lacking lanes-per-direction
Date: Wed, 16 Sep 2026 22:28:17 -0400
Message-ID: <178961190590.3672510.13511823061890997194.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <ae0cc2bd764e6dfffce99db3d8b44a55887c508c.1789394185.git.geert+renesas@glider.be>
References: <ae0cc2bd764e6dfffce99db3d8b44a55887c508c.1789394185.git.geert+renesas@glider.be>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 14 Sep 2026 16:00:01 +0200, Geert Uytterhoeven wrote:

> Since commit e72323f3b09f ("scsi: ufs: core: Configure only active lanes
> during link"), the following error is observed on R-Car S4:
> 
>     ufshcd-renesas e6860000.ufs: Tx lane mismatch [config,reported] [2,1]
>     ufshcd-renesas e6860000.ufs: link startup failed -67
>     ufshcd-renesas e6860000.ufs: error -ENOLINK: Initialization failed with error -67
>     ufshcd-renesas e6860000.ufs: probe with driver ufshcd-renesas failed with error -67
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/1] scsi: ufs: pltfrm: Add quirk for R-Car S4 lacking lanes-per-direction
      https://git.kernel.org/mkp/scsi/c/c9ee65113326

-- 
Martin K. Petersen
