Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDE7326D4A
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 03:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790567900; cv=none; b=rgiPeXSetaKYOBQ3BHQeUPigkq75vudd61c+8LPl6JNahSiTNI8lzGLd0c2OSCIGQL4iepopc9JtevZja6mAaneuaRpikYhkJ0q+jN4lVtOwG0iBEdaGAw76KcUw2zDF6pJ9gtlcBPFJz6X1n4TAeEdVHZ4sNJ8BtQieu/izL3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790567900; c=relaxed/simple;
	bh=FIhPAzXwg/qtrLoF491TC4c1NKMSimYJshz3XmI+eUI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=CSptunpMp7AYEJbzGm+BPjIJXKm6J2UohlHgqgB1+DDxWAmkgLWx9kgE+4TFBkLwAkM3GcRJ40FVHgXMuNZsdHlrgjp6Zj2Obr6oWIOlHynWUSFJxnn369zCqmGTAkAxRdnxl88ds//EZx8QFFSAKMMf2aRZSwG17jNR5x5dvNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tikHUTJk; arc=none smtp.client-ip=209.85.215.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tikHUTJk"
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc1b8088202so1778405a12.3
        for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2026 20:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790567899; x=1791172699; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tKMPIn2Ykffp/y17paNKzcsBWnRW0WFBDaU2V3Kx7r8=;
        b=tikHUTJk2iO552dbkac/n+50FEJj6VRiMPXOg7yvDR61AIj1jy5VX2XbPxwYKGCntn
         Ino1euAY7D/lxR87/W20jmPaABailJNO3l5uc4aFW13LV6cLmS/b5K/TUAvUgR016NBp
         XYkfcrCKZyLZvNwRZ7ENpEMNxWX0BYPcuRnun2XLLcJImv1uW0YmgMmSEcTXwcrb68ts
         sH3Qc+wYb5u7vHmaHFETQQT4LIr38GxLzdmXhplFJ8Csn420Nh08CloS19yKCLT20dvY
         eBBKU1NQWIyS3geTojTm1o5cJVHaX9mRw0GgEDnGZvQV2cE/svqXDrjAahcwedjOHdPw
         I0gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790567899; x=1791172699;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tKMPIn2Ykffp/y17paNKzcsBWnRW0WFBDaU2V3Kx7r8=;
        b=YkOLJC90bIGDBeIw6p3S0glDIVd6ngjULwWgvNPmAeVNvQ6iM932EnRvDTSMk27XYJ
         kbrWm5XIgwDIawm2z1cNxNcShreJL54nQjVtXnuF+xfLZP2ANa3pIHi4aMwHZN4aeK03
         JY5D6++reevwJmB9UEbwJpStq9J+jJQG8zKboqf7TW/0JRhXzk/8i/e6dOtpOBzMsNvo
         CA7cjm60JOlrY3qGGtUKybgOJtzu9sSkMeznaG2pD+uU60pB0tPIM2Wo//e1XvMbK1Co
         Lyf4ueM//auKNQof9hD2Kb31glQ8xeHoEDgPP7V1g1hzFgyozmxOC4IsiGwGfeXz3U/I
         W9bw==
X-Forwarded-Encrypted: i=1; AKwUvBzp7ZQOgICFoOcLa/ScmsdcwSWisdjgqVE+nXt/r+JcDXcP7SRiZwy3bCkkKhh7MZ26z+Srf15SU1Uj@vger.kernel.org
X-Gm-Message-State: AFuF++mml1mVLy0n20SAIo7crOIS7Rh1AwOEVW7XVq3UK0T00AGPV0dp
	8tG+GdFuJuZR814nsewf76s1j16bvXbQP+kMwgj1f4Je+h0xvXkLL/f/LzUWh+aME5Scy8IgcMY
	aolO93pRDlTLIsDRmLnDJtg==
X-Received: from pgdu12.prod.google.com ([2002:a05:6a02:2f4c:b0:cc7:8638:7dae])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:e104:b0:3b4:8880:2089 with SMTP id adf61e73a8af0-3de0e725cf3mr10356924637.16.1790567898455;
 Sun, 27 Sep 2026 20:58:18 -0700 (PDT)
Date: Mon, 28 Sep 2026 11:58:14 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928035816.1294326-1-stanleyjhu@google.com>
Subject: [PATCH v3 0/2] scsi: ufs: core: Fix unsafe MMIO reads and redundant
 CQ sweeps in MCQ reset
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>, Bean Huo <beanhuo@micron.com>, 
	Bart Van Assche <bvanassche@acm.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Manivannan Sadhasivam <mani@kernel.org>, Peter Wang <peter.wang@mediatek.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Stanley Jhu <stanleyjhu@google.com>
Content-Type: text/plain; charset="UTF-8"

During Multi-Circular Queue (MCQ) error recovery and host reset,
ufshcd_mcq_compl_pending_transfer() sweeps or polls completion queues to
reap pending transfers. Two bugs exist in this path:

1. Unsafe MMIO read and spurious errors while HCE = 0 (Patch 1/2):
   ufshcd_host_reset_and_restore() stops the controller (HCE = 0) before
   calling ufshcd_mcq_compl_all_cqes_lock(). Calling
   ufshcd_mcq_update_cq_tail_slot() at the end of the sweep reads CQTPy
   over MMIO while HCE = 0, directly contradicting the function's own
   documented contract that reading host controller registers may not be
   safe when the controller is disabled. In addition, passing expected
   empty slots during a full-ring sweep into ufshcd_mcq_process_cqe()
   prints spurious "Abnormal CQ entry!" errors.

2. Redundant per-request CQ sweeps and polls (Patch 2/2):
   ufshcd_mcq_compl_pending_transfer() runs hardware queue completion
   sweeps (force_compl == true) or CQTPy polls (force_compl == false)
   inside blk_mq_tagset_busy_iter() callbacks, repeating whole-queue
   operations once per busy request instead of once per hardware queue.

Patch 1/2 removes the unsafe ufshcd_mcq_update_cq_tail_slot() call and
redundant slot assignment in ufshcd_mcq_compl_all_cqes_lock(), and
extracts ufshcd_mcq_compl_cqe() so full-ring sweeps skip empty slots
silently. Patch 2/2 sweeps or polls each hardware queue once before
iterating residual requests and removes ufshcd_mcq_compl_one().

Differences from v2:
- Fix the grammar of the CQE comment in ufshcd_mcq_compl_cqe() (Bart).
- Drop the redundant cq_tail_slot assignment in
  ufshcd_mcq_compl_all_cqes_lock() (Bart).
- Add Reviewed-by tags from Peter and Bart.

Differences from v1:
- Split into a two-patch series separating ring sweep safety from
  per-request tagset iteration.
- Extract ufshcd_mcq_compl_cqe() to skip empty slots without double CQE
  checks.
- Decouple hardware queue polling/sweeping for both force_compl paths
  and remove ufshcd_mcq_compl_one().

Tested: QEMU ARM64 MCQ/SDB host reset and I/O without CQE error logs.

Link: https://lore.kernel.org/r/CAE14pdek6ynze+muDZrK+yNX-3ioe3vprxOA4W22qokg352tJQ@mail.gmail.com
Link: https://lore.kernel.org/r/20260918143809.3034592-1-stanleyjhu@google.com

Stanley Jhu (2):
  scsi: ufs: core: Avoid unsafe MMIO reads in
    ufshcd_mcq_compl_all_cqes_lock()
  scsi: ufs: core: Decouple CQ sweep from request iterator in MCQ

 drivers/ufs/core/ufs-mcq.c | 30 +++++++++++++++++-------------
 drivers/ufs/core/ufshcd.c  | 31 ++++++++++++-------------------
 2 files changed, 29 insertions(+), 32 deletions(-)


base-commit: f09d2c7485b32adb82336d0d748935c8237a649e
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

