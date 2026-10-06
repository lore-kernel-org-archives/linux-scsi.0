Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179D13264D1;
	Tue,  6 Oct 2026 02:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791254645; cv=none; b=DMPXPbLQ7Ge0f1x5hL9PxDouRqP691m12II4zv5A7Y78ZZp6zIvg+mI980UyPYVS4orSvJ1aRG0P6safAhF4MOW3fH/hQGHxGz+VXC7RY8cOIEZ2Sc6HlR7hvc67pgo0zzfu+h9Iih3/omswNggxS3HUxgGejbb5HsoPI8ZqaL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791254645; c=relaxed/simple;
	bh=LqXQ8FiQ32sq0pqMmEuynOLwkn2RaZmotylQm59n33o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K3MpiHI5C2B5vXAnnNez2y8B0YGmB6EKaLyNt8LEgxAeewpz3WlNfe5y31K+/FkGTxa6m5d/G0CfIiERIFcH7a0ZAz9DLRoHiy46sZq229G7uXxlJHhiqdV0elwKFOT3ljalw0FKlBSkYbAJIGnVrTcIAMZX1BXf8Q4Qy7mawhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=brEG2Y09; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="brEG2Y09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDE51F00898;
	Tue,  6 Oct 2026 02:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791254644;
	bh=ADnkhVu7hPz3BJysYPkRDJkA4Wh5m1Yw/C2ijRshtJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=brEG2Y09lyalfMmzx/+LMJjIFrL11BEtebLsoLzaM2R66hC1/fxk6bcfslFeJ0T9P
	 0D1uqwqE2dcXm6R+G3CeFLbsWa5IWHeBNzy692QeBqODihde71S0Czhdqd1c57j5KZ
	 Dr4ou4d/U3vUNRoOyQyX/OzMVRcqc0sXmoIidB51nLnSXxb+T+kY7YoC8kf1u5dPfa
	 dDSL46CnhLjgYr0e3FVJ+zyr4DuV30TiiS9Kl1UUV7x7f3f77yijposVTvJB5ZkdLO
	 +UnX6GC0vSsG1LytHlid7RGJ5gmvxw3ZIK2p47XNn3cvKUQnCGCPUqG+J16zdCQkXV
	 1oGMPBD5JRFZg==
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
To: Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Stanley Jhu <stanleyjhu@google.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Peter Wang <peter.wang@mediatek.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Avri Altman <avri.altman@sandisk.com>
Subject: Re: [PATCH v3 0/2] scsi: ufs: core: Fix unsafe MMIO reads and redundant CQ sweeps in MCQ reset
Date: Mon,  5 Oct 2026 22:43:54 -0400
Message-ID: <179125457808.2089616.15797685655668816357.b4-ty@b4>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928035816.1294326-1-stanleyjhu@google.com>
References: <20260928035816.1294326-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 28 Sep 2026 11:58:14 +0800, Stanley Jhu wrote:

> During Multi-Circular Queue (MCQ) error recovery and host reset,
> ufshcd_mcq_compl_pending_transfer() sweeps or polls completion queues to
> reap pending transfers. Two bugs exist in this path:
> 
> 1. Unsafe MMIO read and spurious errors while HCE = 0 (Patch 1/2):
>    ufshcd_host_reset_and_restore() stops the controller (HCE = 0) before
>    calling ufshcd_mcq_compl_all_cqes_lock(). Calling
>    ufshcd_mcq_update_cq_tail_slot() at the end of the sweep reads CQTPy
>    over MMIO while HCE = 0, directly contradicting the function's own
>    documented contract that reading host controller registers may not be
>    safe when the controller is disabled. In addition, passing expected
>    empty slots during a full-ring sweep into ufshcd_mcq_process_cqe()
>    prints spurious "Abnormal CQ entry!" errors.
> 
> [...]

Applied to 7.3/scsi-fixes, thanks!

[1/2] scsi: ufs: core: Avoid unsafe MMIO reads in ufshcd_mcq_compl_all_cqes_lock()
      https://git.kernel.org/mkp/scsi/c/375f3a5691dd
[2/2] scsi: ufs: core: Decouple CQ sweep from request iterator in MCQ
      https://git.kernel.org/mkp/scsi/c/469fa055664b

-- 
Martin K. Petersen
