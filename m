Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792640686;
	b=qwzFXGJ+I/UEFlkx55O5FJpnP9FUBK9/szSz/mcZUxT31uyQISEa4aogfdlfY4d5UJrB
	 si1DyT5uwmcyQ604taO82cqi/eBW82NMmdzbrjU6pOpvdWYzrhqJO3IxFHTcLlEn6/n9L
	 hgaNIadPyYjZENflXVmD8oW9NUGwx+kxLvI0dw8IPunegspOdOTywE7iasrjA1bXPVFBv
	 fjRohoDj+BmitGUaOk/t/sZKksV7TvNRH7JF/0wxzbqu0OvVqez1U1ylzX3ToOpC3M+2b
	 zMkKgPIsZu8yCBOJwUoQk5AlnQKfvj3Foy5i20TVAY2gGZwP0SifEnN1xvFEtCUmm/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792640686;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=cAOkPWRp8YvKWUWIxl2IXJ8ilv8tHvpDegM+zVdAFT4=;
	b=qUizJuucBlsrfGWENkh9Goz1NuNghJ6u6qrg53YJc6KB3H2Bw7XLFIKPWtDeEX5K1vU2
	 d59xU7yMmN4rfT5K/5F049ruYipdkfk0j9fLyD8OT2ChDDqL8NQryKJnS7ZL5igTL+5yc
	 owiQ+5SYJ0gSINL7/1J2BcGb/2+JrVh/d+QIJeaKOdy92n/6ooLVFT1F5zx/shEXVqjnn
	 nrKQXStSISR6D3bU7Yq+eT9/unJynps8Oqhs6UA1lgz0BIKHQbc6ACBbMFGJERsH46OCh
	 aaZJMCNliEGkPBCuucVFkwCyPBJqgjL1Xd5ZRsXhCUZgguQiBnaNHHPmEUC+VmvgkbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=ZC7snNqo;
	arc=none smtp.remote-ip=209.85.210.198
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6B4606A31F
	for <linux-scsi@vger.kernel.org>; Thu, 22 Oct 2026 03:44:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB6B4606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=ZC7snNqo
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8a06bc723b1so1770020b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 20:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792640685; x=1793245485; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cAOkPWRp8YvKWUWIxl2IXJ8ilv8tHvpDegM+zVdAFT4=;
        b=ZC7snNqoz/9upuvpChHKN54cnDw0ELy0L2uPW2Uwe3xOm461emWb30h4KjqdWiCjdD
         KvmuTMGWajGD7QTkkpn8fXDToMvmn1y9clydOHcTSz3PfFi2HOy5dOA78Ah86XctTJ62
         z93I8CIKebO0f3M8bUmZiC1Hnirvk+dIM4ku1ykzE5z1C5Vx2c+xFVFNV70JiCGLbVpa
         SfW8jf6+vvYrc64jxIpbc0KXlofZxbsIYnVO28i5ltQbYHEuXsabwg2LB0n4Hp3TPzBf
         KACBEVeK34ndwlGxSm1ebVnfD1BN90WEZSjv2c+anMq2jsEZkd9KSJ7nUE8HdYUA9OF6
         3jwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792640685; x=1793245485;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cAOkPWRp8YvKWUWIxl2IXJ8ilv8tHvpDegM+zVdAFT4=;
        b=B09glrToo0vMsus5pYBMewGwfQSHuaeGIekXvMvm21wVLG1qv+mssDEPU3wVRjoXxK
         /wUQmJk1HejE/EpxbW7hbFFY1FozWbbbG6ics9jCA1aQvkdLLFWOmf1HuVidH7Z4gCv9
         YYXf32Z9LqXuZmsKvo2inU8CNBPwZIwIKK5YoUP2bsSF9YlQM3SOrFIvC4FqzpsRf/xk
         /QavjCBkE5TnL9AO0m0syGZI2L/QmwkYh3jrQhK3rxQMq13RMSSbQ42VzotSb4wNb3sF
         Uut3s8G3QwHiKgfHswjoyWJDOCPck8DDXxAg+JDcf6ZQPoCklKibcEbVQo34kfEWVteA
         NYlQ==
X-Forwarded-Encrypted: i=1; AKwUvByPWIlzBBC9qNxYqzNX/n5vSHxraJEO2IwYAZPbENU/C288lgC+I7jrb7vm6Z6P170i3Coxw0w311Ja@vger.kernel.org
X-Gm-Message-State: AFq9FYIMJfw3ZlfP7K8098WCH91uelhN1l34MzWCEQJLKyoJvJgYrxPI
	qS902GK6g3wFYEWn9ehbcjAwG+cE3TunTZDgSqfXRqkgtSNXTlnPhCfQ2i5ThXJgg7ELpNI426Q
	KgS3T792pFmMna4uLLerG2Q==
X-Received: from pfmu4.prod.google.com ([2002:aa7:8384:0:b0:89e:861c:6b1f])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3e1e:b0:881:750f:b142 with SMTP id d2e1a72fcca58-8a089d532b5mr3181649b3a.55.1792640684699;
 Wed, 21 Oct 2026 20:44:44 -0700 (PDT)
Date: Thu, 22 Oct 2026 11:44:37 +0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <20261022034443.3034432-1-stanleyjhu@google.com>
Subject: [PATCH v5 0/6] scsi: ufs: core: Factor hba->outstanding_reqs helper
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

Patch 5 removes the completed-without-interrupt branch in ufshcd_abort()
to fix a double completion on timed-out commands.

Patch 6 skips releasing reserved requests at the end of ufshcd_abort().

This series is based on mkp/for-next (db8b4d2bf2d3).

Tested: QEMU ARM64 in SDB mode across probe, I/O, abort, LU reset, and
PM timeout paths without double completion or resource underflow.

Changes since v4:
- Patch 5/6: remove the completed-without-interrupt branch in
  ufshcd_abort() instead of claiming the request there (Bart).
- Collect Reviewed-by tags from Peter Wang on patches 4/6 and 6/6.
- Link to v4:
  https://lore.kernel.org/r/20261021035450.3488805-1-stanleyjhu@google.com

Stanley Jhu (6):
  scsi: ufs: core: Remove an always-false WARN_ONCE()
  scsi: ufs: core: Add a helper for clearing hba->outstanding_reqs
  scsi: ufs: core: Fix double completion in ufshcd_clear_lu_cmds()
  scsi: ufs: core: Fix double release in ufshcd_eh_timed_out()
  scsi: ufs: core: Remove completed-without-interrupt path in
    ufshcd_abort()
  scsi: ufs: core: Do not release a reserved request in ufshcd_abort()

 drivers/ufs/core/ufshcd.c | 70 +++++++++++++++++++++++----------------
 1 file changed, 41 insertions(+), 29 deletions(-)


base-commit: db8b4d2bf2d3e02b4ff78bbf69d00e11795840de
-- 
2.56.0.218.g1ec904b173-goog
