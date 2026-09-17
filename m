Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67F0390CB8;
	Thu, 17 Sep 2026 02:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789612163; cv=none; b=eN1DmX6XD97yXl4dtv9YDau3kkilEhwaODUYJeW9wGioIPeTNMC55J60QiN6e5XDc21ypN3FbtSIr9Dc9OSacaSibg7z8wTCTaxti9+80isP+L5mwuPnSfFthiPepcSCNC6oJMbMS6q22ww1poEXjGAjDAqzd7Bj2e7x788SrYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789612163; c=relaxed/simple;
	bh=X4zoU829ML15fsnGN9PrrVuRJuQuaB17AxJeEgGT2lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q7hz6OpnJ2J9wdzOvcGUFJk2kmh5aFis9a5YMRuyKjbxO+GjMil0m7+nlG6mtvqlzr7qtXkhe0ZFYVsE+knm4/Jlh+0t3OvhKp5r2gptpaWhDJBjAOh+u/ZzsjbyTK0l4xkuC8gLsUEyerBEXKyMBWyNl9SEizzmcL5RfGd3c/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WDkzTBSw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WDkzTBSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AACDC1F000FF;
	Thu, 17 Sep 2026 02:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789612148;
	bh=etZWzf+rdXXaZHJJC+yfMjc9Q4+L0ijxEbKQ8xbrFqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WDkzTBSwybzXtwo7r4D3Kc4ha+PA0dbS+ZKOZleJO5fGtTzQ1uzQtRSqD5FG14Fwd
	 1NB0NQdIhpvWOb1mbWtXYLWTHiQbFWHBBMKRGsAydb8sOMGTg3UCFRSm4TVHkIAvqh
	 0dRGPUrhJYKmUnFr11uc+s7pEqFMFvfA5LFzEpEb0n31xEqtjxMjVYSsgfnsDuf3ng
	 L2sfQgMtzANSESzhS0Vk+imqtMffVhTHwruu9nX0ZzAvPk4NP/C8wgFmOWg3EQS0ET
	 GHlrr3WIuJ4aaYJFwLmmRiVL4VLyjx2P10+0S/phcsF83ClvQqxfQ6FW55Dk6IzPeh
	 5cYPrDvZLyeHQ==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-pm@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Bean Huo <beanhuo@iokpp.de>
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	linux-kernel@vger.kernel.org,
	MyungJoo Ham <myungjoo.ham@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Stanley Jhu <stanleyjhu@google.com>
Subject: Re: [PATCH v2 0/4] devfreq: check the get_cur_freq() return value and use it in ufshcd
Date: Wed, 16 Sep 2026 22:28:57 -0400
Message-ID: <178952247942.2757716.2234123805266440818.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907192140.2701755-1-beanhuo@iokpp.de>
References: <20260907192140.2701755-1-beanhuo@iokpp.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 07 Sep 2026 21:21:36 +0200, Bean Huo wrote:

> The devfreq core has three users of the optional ->get_cur_freq()
> callback. Two of them check the return value, the third one does not and
> passes an uninitialized frequency to the transition notifiers when the
> callback fails. Patch 1 fixes that.
> 
> Patch 2 writes down what a driver is expected to return from the
> callback. Today this has to be found by reading the devfreq core.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[3/4] scsi: ufs: core: Record the frequency the controller starts at
      https://git.kernel.org/mkp/scsi/c/20ae446921e7
[4/4] scsi: ufs: core: Report the current clock frequency to devfreq
      https://git.kernel.org/mkp/scsi/c/55ad5deeea92

-- 
Martin K. Petersen
