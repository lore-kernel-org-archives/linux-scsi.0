Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792484473;
	b=fyK6NKacu3Qs1ovblNw4n9z2Wnsh4x8qLCtYFmsU+ixGe3jaNhLsUB3wQedwDPj1ELqQ
	 ddLwFIJ02lzb49Kc8SaMSScSTvTqAxtWSLBTTVT3JA+FWHNQDAQycupSGkj2c8WgopgZp
	 i2zlCrfjez8HOHbOZeCTZ0c/Ac02janNgVVXzXp9MJPChrvUQ7YC4/old0YnB4A6LELaW
	 qtP+fbR26g3cP9p+uFr+ib3UfyMbGPSlnTGpfYt7WfZW9SX36CfSKR1tIdNIVtLdtNEJL
	 NS7ffYGGh+NCMA0Y7bnXC8ibtV90qJULzarGFtbRtCyt0OLnhCrcNUMT15BC2vQyeig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792484473;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=xE59jIBZZHvUjKrjm7mkHjm9YH7/I5FFkNh3MoDpP5o=;
	b=Fr7vfe5nDKrPl8gVh2m8o3CV0ouU30LYsAmZXoeg/y/RiNFThoo5qFSsDFIM+XrPom47
	 cyC/GyPt8wol8XjS4vfUBwFRbnKtkJA2N1fqdRfva+8/pF9Plrm57/QYfhhCg+CQJ3eEx
	 8zeqDC3AEeRotQaWDZ4E8Dds2MVV2e2TSbJJhexFOrdXma1ewttNW3SX2feq8Q2vRKfgV
	 FSm7NyaU3M+U8YvdyT/o/wbAuHmqP/zv8ccIt1YhAYpzztlvSGGYXmhPRz3Weh/mlMpiq
	 ySZ+D5k27EJjAGkCb5I37vT6zASpCJ9bw2zUWrPmsWpgsOXRt4uP3g4+XYqY+Q6FAaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=egqzuDqa;
	arc=none smtp.remote-ip=209.85.215.198
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E81606A321
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 08:21:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03E81606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=egqzuDqa
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cd5ca3840c5so3419858a12.2
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 01:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792484472; x=1793089272; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xE59jIBZZHvUjKrjm7mkHjm9YH7/I5FFkNh3MoDpP5o=;
        b=egqzuDqaROCxpA9wEPwuX8gFaIAR8VyfSaNwp22zn/Eqn7+TL6Qph5xBbaUimxZmJM
         N6LbIdAa2pBT+CUw/LaVFkFlcDqUGFvlpXeXlsl0+6XoJeQnvg2vRsgtbxMeGvLzW+x2
         f3JJesiR47syfW0Kl9P++l1hCIgtOofUOXxwaPs2ZUvo7XbG8SWvAnKFMUBUvKWKnjDi
         wKK1pT6VP6ZVweHGcJSpSnOGJjZvY38+vi66E/QvBnhilrBZ9ckPp/UPlYl3y7PMyusp
         0SMfOsGfgANkS1yAvUgfcS9Bl+hnjCuIHXI6ljQdseNqdY5CCXnyRz9Npax4nkRvEmav
         2VBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792484472; x=1793089272;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xE59jIBZZHvUjKrjm7mkHjm9YH7/I5FFkNh3MoDpP5o=;
        b=QBKZnWeR8e4KQ2DIDMqmpGUxp2lzfgbMXzWUdeXNg8zfmBvE9RztLzrduHjD3FEC/4
         ucBLwb3WRLtMtzz/JY+u6blztu3+9xRZgVTeGGR1J98IxCPH87pIFP9NOBqVl4eVgYAm
         /GHIWZSekLRDvIeUG/LHBq2Whzycnn4QzxLSExNIykU5DCWQW4Mq8Ben5XHMteib0Lh2
         KY4Egi79H1zP76mFKVt7SdPIB3YcgwGGvxnJ3eDcfp20jr1lPqbvfKepauxQJCW4GT3n
         rzREqBDF2W0jD42hTtjTeAY33xBiOC6SmaClUbYAFF2qorr3mRE1htkMgXc35wLPDdVq
         IquQ==
X-Forwarded-Encrypted: i=1; AKwUvBxAmK/PVKUnEvc80EcfALEryma43Vp74t5LREyvpN2+90TWWioL4Fcae8PyjnWvCC7w50xW3EPPJ1gh@vger.kernel.org
X-Gm-Message-State: AFq9FYJivaC/tXd7EXE278MzkGKsXXz0I4VMSk3Ds2TvtBxwUQMx8O5+
	76i6Mbh+Uo7+2PWNuJHGAxf8/veTguClPM/6+oUntkm6DP+dYz3uRIAWNsU1HQg4pXu732yFk87
	t4UwIQzjIMuDFK2tiu+Y/NA==
X-Received: from pgfd11-n1.prod.google.com ([2002:a05:6a02:654b:10b0:cc9:f487:a423])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:4903:b0:3e2:d8f:600f with SMTP id adf61e73a8af0-3e22613d7e1mr9017309637.72.1792484472121;
 Tue, 20 Oct 2026 01:21:12 -0700 (PDT)
Date: Tue, 20 Oct 2026 16:21:03 +0800
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
Message-ID: <20261020082110.3511797-1-stanleyjhu@google.com>
Subject: [PATCH v3 0/7] scsi: ufs: core: Factor hba->outstanding_reqs helper
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

Patch 4 converts ufshcd_eh_timed_out() to the helper as a cleanup.

Patch 5 uses the helper return value in ufshcd_eh_timed_out() to prevent
releasing driver resources for a request already completed by another
context.

Patch 6 uses the helper in ufshcd_abort() to fix a double release in
the missing-interrupt path.

Patch 7 skips releasing reserved requests at the end of ufshcd_abort().

This series is based on mkp/for-next (db8b4d2bf2d3).

Tested on QEMU ARM64 UFS in SDB mode across LU reset, abort, and PM
timeout paths without double DMA unmaps.

Changes since v2:
- Move WARN_ONCE() removal to 1/7 and use __must_hold()/guard() (Bart).
- Add patch 5 to fix a double release in ufshcd_eh_timed_out().
- Add patch 6 to fix a double release in ufshcd_abort() (Bean, Bart).
- Add patch 7 to skip releasing reserved requests in ufshcd_abort().
- Link to v2: https://lore.kernel.org/r/20261017084403.875420-1-stanleyjhu@google.com

Stanley Jhu (7):
  scsi: ufs: core: Remove an always-false WARN_ONCE()
  scsi: ufs: core: Add a helper for clearing hba->outstanding_reqs
  scsi: ufs: core: Fix double completion in ufshcd_clear_lu_cmds()
  scsi: ufs: core: Use ufshcd_clear_outstanding_reqs() in
    ufshcd_eh_timed_out()
  scsi: ufs: core: Fix double release in ufshcd_eh_timed_out()
  scsi: ufs: core: Fix double release in ufshcd_abort()
  scsi: ufs: core: Do not release a reserved request in ufshcd_abort()

 drivers/ufs/core/ufshcd.c | 56 ++++++++++++++++++++++++---------------
 1 file changed, 35 insertions(+), 21 deletions(-)


base-commit: db8b4d2bf2d3e02b4ff78bbf69d00e11795840de
-- 
2.56.0.212.g129ede20d9-goog

