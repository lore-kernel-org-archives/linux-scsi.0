Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795231443;
	b=FIfl+/l1sQm278VW5TclEVLhMPpkRqjEUm4dYYU4v+FoE7t1JumS8SoFxA78J15B/XZI
	 lL+blEDnBQBmi7rULk5CzcvxsIQ0bR6ovr01fYaW/01CBIPDGaOQ84HpacCzaeeDOBOya
	 JKZwDhQphTtJwLWK4M3Y5O1l09y9ghqm199Ghbaw/FkCe3znAL+Te8eYK8FQRgbd8GCbc
	 gV6Mi+qYYrfZyeg7JaRTwgjozIfkn6P4gL1ACHB5Tuj2QpAR/VQf4PL0RIypHV2Je5L0U
	 s3BPrQQIaTaYQGU1aRsSNhid7bU7oOUqQepFPrF5q46atBR8RJ/MdDmqaUFuUo/OUfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795231443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=UcPonYX/qJhVs6OYVeHo/PTCvGk1511xRmhiYdan/oQ=;
	b=ojmzYQQG8GFaWIrrdISPurvac85khtCfKigNEYpV8qcg2oJowvuHv5GBOK9xaTKEiycb
	 vIn/7LJvfQHwUI+khYPZHn9id1e0hmyID9wh7ae0fICdN9xLvlurXq58YFuwlM/ravT7n
	 AXXYYjvSb2Vd12JhH0nqA0KB/8kyW6RmfJOYq010gwJbUfCdZBSwHCXssJSxV7uOrMkRK
	 LLp7JAmLeAOi5lx5QntqeV3ihzSfHvr2fkH/yCRiQjGQlbZg3Mab1aqHQKfqw0VYPPcLt
	 /zUpaxVB21fjcciNKl7DLu0Pdddgq78nummIlvJ+I30HZMoOH6Tkzkr3qT3tCXBCtVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ks1wmHm6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87440606A6A1;
	Sat, 21 Nov 2026 03:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ks1wmHm6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BE21F000C0;
	Sat, 21 Nov 2026 03:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795231443;
	bh=UcPonYX/qJhVs6OYVeHo/PTCvGk1511xRmhiYdan/oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ks1wmHm6kReBdc4yPU+Sin6sPk/cHjFsY4BEqeT1XwdBB0EcBhI6hvYr1DVf13ZcD
	 aOe5+T/RAygnDqC9lq6PMbglM/VO7ob6WlYQoa/oCLZy6Dc1AztNZb3b9ZQ8jtpV1l
	 frqU3Dp9NKbk1YVdiCrZtcRfSEGx7g16m4y8w6+lXmMgVw4C8VbiykMvu8GlAsJhrw
	 tZrLj3NON2x8braBNt/sNhWGpFbqfHff8fMMwlWjyXlwen2JJi0GPLrLHCZEAShsYR
	 rAOq9x8TCDE48N9bjC3ITUnxaaFWNB0+qi/Lh+GcmHD1s3sTw/TvYC/DDk5eG2aHK5
	 HuHDF5ceANXHA==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bvanassche@acm.org,
	stanleyjhu@google.com,
	peter.wang@mediatek.com,
	alim.akhtar@samsung.com,
	kwangwon.min@samsung.com,
	kwmad.kim@samsung.com,
	cpgsproxy1@samsung.com,
	h10.kim@samsung.com,
	"Martin K. Petersen" <mkp@kernel.org>,
	HOYOUNG SEO <hy50.seo@samsung.com>
Cc: Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v10 1/4] scsi: ufs: core: Clear saved errors in ufshcd_link_recovery()
Date: Fri, 20 Nov 2026 22:23:56 -0500
Message-ID: <179523138183.420037.8542083300301311231.b4-ty@b4>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <1384010761.101794387787447.JavaMail.epsvc@epcpadp2new>
References: <1384010761.101794387787447.JavaMail.epsvc@epcpadp2new>
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

On Wed, 11 Nov 2026 17:18:31 +0900, HOYOUNG SEO wrote:

> ufshcd_link_recovery() resets both the device and the host and then
> re-establishes the link. Unlike ufshcd_reset_and_restore(), however, it
> does not clear hba->saved_err, hba->saved_uic_err and hba->force_reset,
> so the errors latched before the recovery remain pending after the link
> has already been recovered.
> 
> When ufshcd_err_handler() runs afterwards,
> ufshcd_err_handling_should_stop() sees these stale errors. The error
> handler then quiesces all queues and, depending on the latched errors
> (e.g. a fatal error or UFSHCD_UIC_DL_PA_INIT_ERROR), performs another
> full ufshcd_reset_and_restore() on a link that is already operational.
> 
> [...]

Applied to 7.5/scsi-queue, thanks!

[1/4] scsi: ufs: core: Clear saved errors in ufshcd_link_recovery()
      https://git.kernel.org/mkp/scsi/c/e043bf8fa65e
[2/4] scsi: ufs: core: Add a helper for the system suspend callbacks
      https://git.kernel.org/mkp/scsi/c/280c35ec0099
[3/4] scsi: ufs: core: Make ufshcd_wl_poweroff() behave like ufshcd_wl_suspend()
      https://git.kernel.org/mkp/scsi/c/7be49f26454e
[4/4] scsi: ufs: core: Limit early link recovery in the error handler to runtime PM
      https://git.kernel.org/mkp/scsi/c/7693e76c9f8b

-- 
Martin K. Petersen
