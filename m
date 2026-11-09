Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794196545;
	b=U88gKhhkgpAOP7GY22HViR4QN4DuJTkiQFOqth7Sha/jHuPqVIJ+QN1lG/zMJVA+6Hiq
	 iRGIJtpEtFwFbm4du8WSFEeEMgsFjY7/pG3j10jkgOonM+V9F3Ud87SzooNpUS68S9qZB
	 8SKc4HV7QLskHW5WaGVV3tFXmaCpc37MMYVxvbrf3TyFD31HWy9iiz7HQewexXN7CLPiB
	 1e75yGV6mb4j28AwMGBm9TDGFiL5GUEn7uixcZ5uAyUNpd928qWJuU+ZU/HCgK3qcR6U5
	 Fxw3h7Hh1/FzonZZM3/6WpbiKZXuUYPYguWWFUG4AoPd3DMDpiwto+CSH6JFTH8pV/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794196545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=LETuMPa26i6sdaOmtniE0RZ4Ar7sk6ZdHV8owkJvnbo=;
	b=gyvOSz9qNXOddKLcFyNM8YN/7sawqdWaAR1VtuHGZWzb78JHp5fcpUhpA8VyfIrxCNn6
	 53SNoxydrrd3h1Zc8daUeRAO0oLjEeBR1ltHgxFHM3twlmL6wF4VNbwQQq5Y/oY4jDRZy
	 FoHntBcYFxfG3/7984+ERO9PT/JAN04l2fF6ePwPCt7o8gHj4u47Hz8qZ51rpjyKF8w0J
	 w8L9zGQheA3GbpXIgAAFJWhavI/gzyBGuDxWVeKnRBZz4u6yQ1VPD7fCqVQDImvAjf32A
	 H/vIb/4vrOfTKCO+CR18hUF7Nya7AldIR8kPOqD/lz3lo4ujoTkKtFQqrVnaTvT8hKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lIpsnzIf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D5F606D830;
	Mon,  9 Nov 2026 03:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lIpsnzIf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90ACB1F008A1;
	Mon,  9 Nov 2026 03:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794196544;
	bh=LETuMPa26i6sdaOmtniE0RZ4Ar7sk6ZdHV8owkJvnbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lIpsnzIfOp7wexlLwrA9UvJRObTQzlCFQmOCbN5czrcfCoJQN4He0tp2NZOVif1Lk
	 mURKppX8X8mDGOsMgLvPywMPI+i9Svi9hAbFFJFpEmKEboRBmU6EdyQ7Pz+i1838Tb
	 E0EYVlCc/eFOuFqaDyqcPXtEbkuOgkyXmdXz1pd1sHNbFs1tR/rwdjCwUSJt2JXaK3
	 FQVwXHkx0Kz9WdDzdIvUGNGxcYO9EiRR2Og/QTPhxynJpXbyYQ9ZPKb7EH+ClG7sdm
	 57s8gebd2AjKEXLaZi3g2LQtw3rDevTXgu1Hc4QIukvS0r+pR72DbadwYDAFS4NEhN
	 BHhdNpv1q6VMg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com,
	jejb@linux.ibm.com,
	bvanassche@acm.org,
	kwangwon.min@samsung.com,
	hy50.seo@samsung.com,
	cpgs@samsung.com,
	h10.kim@samsung.com,
	"Martin K. Petersen" <mkp@kernel.org>,
	Kiwoong Kim <kwmad.kim@samsung.com>
Cc: stable@vger.kernel.org,
	stanleyjhu@google.com
Subject: Re: [PATCH v7 0/2] scsi: ufs: fix the abort path of device management commands in MCQ mode
Date: Sun,  8 Nov 2026 22:55:25 -0500
Message-ID: <179419615231.1941224.10886487867480018133.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1793938245.git.kwmad.kim@samsung.com>
References: <cover.1793938245.git.kwmad.kim@samsung.com>
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

On Fri, 06 Nov 2026 13:12:45 +0900, Kiwoong Kim wrote:

> This series fixes how a timed-out device management command (query, NOP)
> is aborted in MCQ mode.
> 
> Patch 1 makes ufshcd_try_to_abort_task() skip the task management path
> for device management commands and clear them with ufshcd_clear_cmd()
> directly. ufshcd_mcq_abort() sends these commands to
> the QUERY TASK / ABORT TASK path, which is meant for SCSI I/O commands.
> With this change, the SDB path in ufshcd_abort() no longer needs
> its own branch for reserved requests, so that branch is removed.
> 
> [...]

Applied to 7.4/scsi-fixes, thanks!

[1/2] scsi: ufs: core: skip ABORT TASK for device management commands
      https://git.kernel.org/mkp/scsi/c/30bdadc9aa3a
[2/2] scsi: ufs: mcq: poll OCS after sq cleanup for device management commands
      https://git.kernel.org/mkp/scsi/c/e510b597d8af

-- 
Martin K. Petersen
