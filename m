Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793410824;
	b=4P8QnpEC+aoda9jFzAkaoa7qspaKogkhFhlR73sAPYnFBP7pH8p662UcP8VsBYyvezu3
	 +yyoYKzbAprftc1KfcgIvrPXaXVWmpVsw1LC7x69R5kfmt6MYv4VCuNximBrxU7CoE/4p
	 RhoDPBkq9vq2nEhnQTL+rL3VJjlMEaQ9F+ChsYuIaGFf/CDgXaMqn6kum7gFr+yTRi+8m
	 6jJ9X4rn6S8J94KPMTR+uuTmtrP/KM+I69FaqkyaBGn6Q4aF2lsK77Ro9BuOI63DFmnK4
	 OGCVQK3fA7rv/fHX4aZiQ7jsy0XMw94caqg5KjTDTCgowM0ZliwT8cgJBKXJ9YU5SSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793410824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=1/86xQn13sQ2wQsTVCOqnQlazj8JTkW7FmVpuw8Eg9U=;
	b=rhpL3LnCoa1kAiYE2fJTqQAmBt0lIsiVq7ha4uhWRsbwHoZ1bir8OF+/eWt/yuPGBxDt
	 BcXujJ/I9Q18n9UVndpRJiMwjpj0UggZGjSSQE4s9EAXDG6SjyQxzCc72lGN5qmqnFUqn
	 oBvRhtNMH2ToF5dRW3WXsi62SFoBVhjecblQ8chMw/TcrXuhluMiDPSNVBOFZYBagIslH
	 RAtup4gJAixvBeGTmcL7HcAOd9ojlfXXx1B9eGJy9yVzUIQit3BHuJpWAdXyNgLdEucF+
	 ij4ZNe391KwaG1AZa+83nraSsxUpxPhQhAApxvXRbhDV9TQ+3BA7H687rbkZQyY8Fsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="d/M0yBOj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1252606A322;
	Sat, 31 Oct 2026 01:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d/M0yBOj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66AF1F00A02;
	Sat, 31 Oct 2026 01:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793410823;
	bh=1/86xQn13sQ2wQsTVCOqnQlazj8JTkW7FmVpuw8Eg9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d/M0yBOjUq5yz9zCLdUxc8F9FfVLKk0ra1zMVYwiRkbJ830XbNc/my7PGdbowHeMu
	 BEmX4cGv444nJsQg8ZsOy6xgbA86aP9cIV9pbRc1naY75WxCgyVUQya+YUny0kde+h
	 pv/QjwZhE8oE6rG/W/KCmiMuprNQCFkmDudet5eBe1Dhbq1guk1tg4/k/egkkAS9OO
	 baD5IwYmapVSsl42sGr4vwBx57nkZ0U1DsHkuBpbyiKoD/YaKw/XJVsGenDap695ku
	 m1f+2gVj5Bl8FLEIbm839NH+f/QcZRbVpQ/xEmHYR0aobaUGqT7SMG2DJbAkhgQa75
	 KrAEF0/7V89Yw==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com,
	jejb@linux.ibm.com,
	bvanassche@acm.org,
	kwangwon.min@samsung.com,
	kwmad.kim@samsung.com,
	cpgs@samsung.com,
	h10.kim@samsung.com,
	Avri Altman <avri.altman@sandisk.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	HOYOUNG SEO <hy50.seo@samsung.com>
Cc: stable@vger.kernel.org,
	Stanley Jhu <stanleyjhu@google.com>
Subject: Re: [PATCH v6] scsi: ufs: Change the error check sequence for auto hibern8
Date: Fri, 30 Oct 2026 21:40:08 -0400
Message-ID: <179340755635.952351.686725763455220200.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027110357.3649301-1-hy50.seo@samsung.com>
References: <20261027110357.3649301-1-hy50.seo@samsung.com>
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

On Tue, 27 Oct 2026 20:03:57 +0900, HOYOUNG SEO wrote:

> Auto-hibern8 enter and exit are performed by the host controller without
> a UIC command, and the auto-hibern8 idle timer only runs while no UIC
> command is outstanding. An auto-hibern8 error (IS.UHES or IS.UHXS) is
> therefore usually reported while hba->active_uic_cmd is NULL.
> 
> Since commit fcd8b0450a9a ("scsi: ufs: core: Make ufshcd_uic_cmd_compl()
> easier to analyze"), ufshcd_uic_cmd_compl() returns early when
> hba->active_uic_cmd is NULL, before ufshcd_is_auto_hibern8_error() is
> called. Such auto-hibern8 errors are no longer recorded in hba->errors,
> so ufshcd_check_errors() is not called for them and the error handler is
> not scheduled.
> 
> [...]

Applied to 7.4/scsi-queue, thanks!

[1/1] scsi: ufs: Change the error check sequence for auto hibern8
      https://git.kernel.org/mkp/scsi/c/6b2ff2b3eafa

-- 
Martin K. Petersen
