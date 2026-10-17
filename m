Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80CD53A7D82
	for <linux-scsi@vger.kernel.org>; Sat, 17 Oct 2026 08:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792226647; cv=none; b=ZmUstP25iRPGwUVqdjOt3GftKZX0qfO3vbY1ejimU7RXiUW0qfTUMR9OPlXfbHYgH755IzvhiLdcwG+Tv69z2srLWPg5vnAXo6Cm8WhWOdbMA8fQL6SrSITT3T2X6a2+gg+Z5j2+DjX+5vct7ro59fHPg1SzQQqtIZxcQ9T3+x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792226647; c=relaxed/simple;
	bh=OB5a9c47gcrtaB33RnFBUdoM0/MNrAN9fCIvLeE5eAg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=pkicB2kUBwNe0dMvMLjUDulEWutvWsuPh3NzgBvIwnrEeFlJPtRdSIdeAE80tDxkqqMl35Tf0vKRvHAp2mSwC2UnM5vqQHshrDQE7rH6gIQYyZMKd8zEYFkD9qWEYXUvbLv/ELeCx+zIGxADyQnVbTRbhfBFmG+F+IBdTQfYL9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RedzXpeB; arc=none smtp.client-ip=209.85.210.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RedzXpeB"
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8a05b68f851so6845b3a.1
        for <linux-scsi@vger.kernel.org>; Sat, 17 Oct 2026 01:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792226646; x=1792831446; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UR8Zb9Xx7OTldAeX59cf+0Og6v4oeyuYR3zryhwiJ2Q=;
        b=RedzXpeB1Ma9p2u+qPgnVR4IBU+76qM4sn2bA0VieknKi/Z8VU+uiHa47HPFieXfRw
         AzCvGXB6h6KZbvK1LNDfH+KVLvEt85jEnW4uxXcXS7CkqKzVJnjiXi4fTkdovmD+cA6U
         wRL0ryW64pd1l1honfkkMUaaq/WXtQrQeB+ofcG6rqAkarDkjFIx7gaP1xaqrWS50ajw
         MJS2P73uKqMIg0IDndxIXRQvCVNeNK4jD3mCgz1dqtiE1KeyIX0P0eSd9RL3R0A8fpB+
         Wovj4fk5eDovzzjqD41iJbhqvqJvDKYWORLUuRTPYeJohNG7izFyrXku4H+TrYAVfQ8c
         SAvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792226646; x=1792831446;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UR8Zb9Xx7OTldAeX59cf+0Og6v4oeyuYR3zryhwiJ2Q=;
        b=VDekDIYxO9wST4F8bjd9mKuIa6cDjxYaBLTn4PX6Nbmj61xUjIx1y72hohnFnbSoAy
         3EdOi5hsNEaFlTumfLkCjZM0qR471/4dx3iac94mnCBV0G5yoyr+XgFzYaJdJzIBMBgK
         ldNuM/FXbWi13F7tMLpGDIDCX91+TuAydqMW3qJ1vnLJ5hbCQbiB57hQ0crx3gc1PcUz
         zGjOJLpA42DLLQ6IgrobIfSjVPyxI792H3xTlyNuQqCdY2Rb8MeyjGhKQM5y8fWCgDPi
         /RYJUkG+3Axj2SrWS6xu6PdGIL7kaLZu4l5X71tWVglYjOYE5HT/C0pThL/4sFk23zwI
         TpZg==
X-Forwarded-Encrypted: i=1; AKwUvBzoDbYZZ3rxNy043P8JRCi8Tep+OiOnA0WDKyCToKLWryXnhTaNKJ9CJJov6rO8aldW7ILVneKjZm83@vger.kernel.org
X-Gm-Message-State: AFq9FYK3NA7Y184EDxH+k3g6aMpN5hjoCjTYrOybTmRzAGa5sdEa5vmo
	Z2tpTulPE8lP+fxf3EQcRMInLWOewBgTnT68m3XAaIG/8ygnVxSaoIhfSFqE9bW2jccGbeaVdN9
	fJzT2N5S59QPy4MDZ6XkF4Q==
X-Received: from pfbbd20.prod.google.com ([2002:a05:6a00:2794:b0:89b:8753:6000])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3e28:b0:8a0:5afe:ea63 with SMTP id d2e1a72fcca58-8a05afeed3dmr52876b3a.5.1792226645554;
 Sat, 17 Oct 2026 01:44:05 -0700 (PDT)
Date: Sat, 17 Oct 2026 16:43:59 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261017084403.875420-1-stanleyjhu@google.com>
Subject: [PATCH v2 0/4] scsi: ufs: core: Factor hba->outstanding_reqs helper
 and fix double completion
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

In Single Doorbell (SDB) mode, ufshcd_clear_lu_cmds() clears a transfer
request slot in the controller and completes the request without
claiming its bit in hba->outstanding_reqs. A subsequent ufshcd_poll()
call sees the stale bit with its doorbell bit cleared and completes the
request a second time, causing a double DMA unmap.

Patch 1 adds __ufshcd_clear_outstanding_reqs() and
ufshcd_clear_outstanding_reqs() to share the bit-claim logic across
ufshcd_poll() and ufshcd_abort() with no functional change. Patch 2 uses
the new helper in ufshcd_clear_lu_cmds() to fix the SDB double
completion. Patch 3 uses the new helper in ufshcd_eh_timed_out(). It is
a follow-on cleanup and is not needed for the fix. Patch 4 removes a
WARN_ONCE() whose condition is always false.

This series is based on mkp/for-next (db8b4d2bf2d3).

Tested on QEMU ARM64 UFS in SDB and MCQ modes across LU reset, polled
and interrupt I/O, and task abort without double completion or DMA
unmap warnings.

Changes since v1:
- Add a helper for clearing hba->outstanding_reqs and use it in
  ufshcd_poll(), ufshcd_abort(), and ufshcd_clear_lu_cmds()
  (Bart Van Assche).
- Convert ufshcd_eh_timed_out() to use the new helper in patch 3.
- Remove an always-false WARN_ONCE() in patch 4.
- Link to v1: https://lore.kernel.org/r/20261016085403.1711740-1-stanleyjhu@google.com

Stanley Jhu (4):
  scsi: ufs: core: Add a helper for clearing hba->outstanding_reqs
  scsi: ufs: core: Fix double completion in ufshcd_clear_lu_cmds()
  scsi: ufs: core: Use ufshcd_clear_outstanding_reqs() in
    ufshcd_eh_timed_out()
  scsi: ufs: core: Remove an always-false WARN_ONCE()

 drivers/ufs/core/ufshcd.c | 55 +++++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 20 deletions(-)


base-commit: db8b4d2bf2d3e02b4ff78bbf69d00e11795840de
-- 
2.56.0.176.g3575e65682-goog
