Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792554893;
	b=XtGId8ehWOzu8eKVqL+NrjIb/Ua2KpRWHpESY73X52AKfsUCKgpFDr9LSpm0MJ9WE3xn
	 29ycYpDrgMnPRoEiQb9hHh7hDMfEdrx3wGgpgc8arjZweDrAdvHY/+CVTn4ydvQW91ZuS
	 OGzEgnPw8VC3ETDQUT5cEWFsrzUJSj6hRs/ledpWQZAwrSMWMxvNWcsg+yjd1MJIb9ujd
	 cprAGKnZvROdZ2jNuj7Kcan3ARFpC5wTITF7u7DsIeAi2+D/ZJ+duyCf7vbfXhEs7hTpo
	 myr/Ko2aFj9jNxLqfSzww8/GWmR06JpawneUgiEUObKVXl1WaVXLsq5q9hG8NDADCPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792554893;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=AVgUGftv23qnyKaR98Ry6J0pi0AejgE9x/tUE/iZzF0=;
	b=IxjuRuatvDvbhDJdWi04e1LvF1aJ30wxqoV5PLEQi0wyW4im3i8XUTD3arZPcJxlRZIG
	 0ovqQEj2HXKW1nsD8kWAUd0mJtVvQY96nLn3TzR9H8Ffk/0R1skY02C4CwAzvbqb2Cd0Q
	 ORmiUZFUeW3I6trxo49tpFim/Pio1nGbHDfgeHQvczwqNtMKRWmlTxgmZoao9O0RMUlrl
	 T8CCuPyZk3HsuQV5RsFHDUUS1K9B0CJ1ysURCsgOXm3AHZ1+3EipHvmvpxTcNVMJmo+Ck
	 eYmgEOef4ZjcbJe3q7T9aDUlKmlNyze/Gt5Qh8mSE1PYvYPHEK2zF8xaEjYaQgpMVEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b="X12C/YrP";
	arc=none smtp.remote-ip=209.85.216.71
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C922606A31D
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 03:54:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C922606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=X12C/YrP
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3a46f0f158dso475129a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 20:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792554892; x=1793159692; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AVgUGftv23qnyKaR98Ry6J0pi0AejgE9x/tUE/iZzF0=;
        b=X12C/YrPi4UvZP4PPdawsp12ONp5zfxQDz5MEAc0UUZoWwPuF131NkOCJWxwr9ZqX8
         AAloZqhBaivgBG2FhUb3nnlMvyHxlRCjeyfMGTHxU5ozgVp9zMz/IatCW+doFZSZSSBo
         nW39l1B5HsGkWN+Jdt322Zk8pulaXraD1v7Vkn0Fe5g0Xtmg0ughkXLif+IaW/0PTeov
         eWBMMeEcItA5/sbCxV3lLJbk6nTOOJeRYnf1lvMuOpciIs9vGR4AvrFYTryHkq1ndLay
         Hrsfi9nPEJDwzOap4Va4Y6iJdoxE3PJQVSNkVCuHrhWwmLg57joCd/te/+nf/cPFXwXt
         Frrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792554892; x=1793159692;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AVgUGftv23qnyKaR98Ry6J0pi0AejgE9x/tUE/iZzF0=;
        b=BijdOcMuPipNhTevXUTO87ATAmqdmyvXytN3e+ZgbrPKGQh0BYuLCAjZw04SIEFr08
         HeeRn43ifsI024Pw9/vREhruEScnSwSpJHqzjoGzX1eTOhQIBg+cB2AaZTjdFc/eHjCe
         H3Nx8vFGhcndFiCW3HN9l+CjYIHEE97CF970/ukeGXSbwHJIk+dBG4hLiuGen0DVFNSB
         6frlEAUn8y1J8sZfSfzo0FWMuMkRMhdgA3WRIZxqE37zlGhTp1N4WmdVGsFftIzmysB4
         OetNZwdZht8zndcgDx+/F4feHpNS+oPoQd3tuQvVLjoZu+cbPT2uDd+qeCUgONQvKlin
         +HeA==
X-Forwarded-Encrypted: i=1; AKwUvBzURjZ8Uptqa/vQ+2SW24UFpTyKZhHaE0E2ZunwCnXBnpEyLUxzlK6Y7OVZavA2pT4RBUNCd+TzwtoZ@vger.kernel.org
X-Gm-Message-State: AFq9FYKU2BLczMIvIUazALUtHxrBSTVi1ahD+/cFkFP6ZI1SAh4WlZeT
	gssc5lSQUI8uGHM8kbNJhed0nUkyPRYTeEKVD0n77Cp9c2OYCMtZIainM41UuhrA6jShAhKaJeH
	tW2jbBLwrmsuYAfW5dKccTQ==
X-Received: from pgca13-n1.prod.google.com ([2002:a05:6a02:638d:10b0:cd6:1e9b:7977])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4c4f:b0:3a7:ef4:74ba with SMTP id 98e67ed59e1d1-3ad6592f94emr2865592a91.55.1792554892142;
 Tue, 20 Oct 2026 20:54:52 -0700 (PDT)
Date: Wed, 21 Oct 2026 11:54:44 +0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261021035450.3488805-1-stanleyjhu@google.com>
Subject: [PATCH v4 0/6] scsi: ufs: core: Factor hba->outstanding_reqs helper
 and fix double completions
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In Single Doorbell (SDB) mode, multiple completion and error handling
paths can race on the same transfer request when bits in
hba->outstanding_reqs are not claimed atomically with completing the
request. A stale bit in hba->outstanding_reqs lets a later poll or
reset complete the request again and unmap its DMA buffers twice.

Patch 1 removes a WARN_ONCE() in ufshcd_poll() whose condition is always
false.

Patch 2 adds __ufshcd_clear_outstanding_reqs() and
ufshcd_clear_outstanding_reqs() to share the bit-claim logic across
ufshcd_poll() and ufshcd_abort() with no functional change.

Patch 3 uses the helper in ufshcd_clear_lu_cmds() to fix a double
completion during LU reset.

Patch 4 uses the helper in ufshcd_eh_timed_out() and checks its return
value to prevent releasing driver resources twice.

Patch 5 uses the helper in ufshcd_abort() to fix a double release in
the missing-interrupt path and returns SUCCESS when it claims the bit.

Patch 6 skips releasing reserved requests at the end of ufshcd_abort().

This series is based on mkp/for-next (db8b4d2bf2d3).

Tested: QEMU ARM64 in SDB mode across LU reset, abort, and PM timeout
paths without double DMA unmaps or active_reqs underflow.

Changes since v3:
- Document the helper return value in patch 2 and add Cc: stable to
  patch 1 (Bart).
- Squash v3 patches 4 and 5 into patch 4 (Bart).
- Return SUCCESS when ufshcd_abort() claims BIT(tag) in patch 5 (Bart).
- Link to v3:
  https://lore.kernel.org/r/20261020082110.3511797-1-stanleyjhu@google.com

Stanley Jhu (6):
  scsi: ufs: core: Remove an always-false WARN_ONCE()
  scsi: ufs: core: Add a helper for clearing hba->outstanding_reqs
  scsi: ufs: core: Fix double completion in ufshcd_clear_lu_cmds()
  scsi: ufs: core: Fix double release in ufshcd_eh_timed_out()
  scsi: ufs: core: Fix double release in ufshcd_abort()
  scsi: ufs: core: Do not release a reserved request in ufshcd_abort()

 drivers/ufs/core/ufshcd.c | 67 +++++++++++++++++++++++++++------------
 1 file changed, 46 insertions(+), 21 deletions(-)


base-commit: db8b4d2bf2d3e02b4ff78bbf69d00e11795840de
-- 
2.56.0.212.g129ede20d9-goog

