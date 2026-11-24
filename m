Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795483794;
	b=eetKU8n7QjVYIXxAwQ9S5SHXcd/EaYdljEpbBf7F/yIx3CT7IEOj7W5dlY6Bvd6z+1OM
	 8MA8LEp8vPes9fUFKoss7aYmcwgT1HUCqmFmmOUYiuK8kwX9bjaWnU/Y6Nh0rQ+2iQN2N
	 a5pUjf2QWkslgAWf+mK7EU1DvFEVxMiPlk9bO1SFuKVdDuTjonD+PiVebm+gdm0Lq6D+r
	 4Jyty8yJU6OqxCB1VCEyjiIV0CWymRfBApb3CKysR17ByvkUxbwIH/CRFneY9lk9T1O7g
	 kiVioUka08irjTimxPbdpFLviHeBX9oM2GGBho081HwHsIz91ipf+b5J3Eniq4UhLYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795483794;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=7Vg6PurV5UOdaOTFx6icToMm2644jnZk8d1GCxFL0v8=;
	b=EwXXwfVElrqIcNz6GKX6ZWzoTfEsPh2cxye/fsU+olnkIKMcc/2U42lHOluuc5vksO1q
	 RoXMdJVPtF9H2o0u7jY7B9/DY3VgMOSzfiF0i12ggiHniFx9nNRqI9csjDnfF3roN1QA7
	 H6rWnfzeObHDyAaCR++MpgTUvC+/Lp8zQLrDRc+kEmTSuTKThQWSLTxaRfeSG5uJkAzu/
	 Cm0qz1QgKvehMUv+9QjkATV4PoX85n340GvU4Zofdsho4/MTHXW50TdAjWQlk0Xdst+kl
	 P2yMmcnTLCV/CBwgtsxQ+K1lXNoDGat1kDa7QdGQpwjxMM9vPLkgNleG4Rlt5ALgMgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BRpdwTkz;
	arc=none smtp.remote-ip=209.85.216.71
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E0A606A31E
	for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2026 01:29:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48E0A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BRpdwTkz
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3b45655b428so2851208a91.0
        for <linux-scsi@vger.kernel.org>; Mon, 23 Nov 2026 17:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795483793; x=1796088593; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7Vg6PurV5UOdaOTFx6icToMm2644jnZk8d1GCxFL0v8=;
        b=BRpdwTkzX3uMbTb9hpoprIHxT9lgcQKY7BT1UgUsWvPYDeBjA9eXl+9/utperUYQvY
         vdAO8XLnHATXVCTFGyTy1KTKiSyI++BstuMJucJI5/T839obRy85crLPxV4MQFY5yRTW
         mjlC6iJb+PsRj4EPDkJIVSmvGCkkRaRcsVONjAliOM1Y2KMnjn5pnUWNdATCQppmhDgF
         r1caZ+z059HHmv4xzyaqfOifoLW/UtD3sFDmSbtLgHXcNh6JV/5VX/Z2KWAYoFyrZTY+
         lAaPv/tjhu0cjns4peqZJSoDJJXmtn4SLqRj7QTCbtFcCE1nplxevEyauATw8glyB9yW
         98qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795483793; x=1796088593;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7Vg6PurV5UOdaOTFx6icToMm2644jnZk8d1GCxFL0v8=;
        b=cmWrSwPhlHv+Hgn8uHDn2JJ0nTp4s4lWhJmn3sxGqdsh2773giuDGAaN28EP5d6wAf
         Y8YfZOdzLM9TWOyX7JY39mYh1i+wDNtIswsVtIhP4iBbp9RW0mmkvIh/9ely93jd1hFI
         TDL+T8i8C5fcYc04REJ4lhxp0hmS/B/1FXYg4pk+3Xkqi4ZxCISl5dxqvKpm0q+IfK5t
         Vz6TjoBdDjopJRkqDrXZupBxlfNmuoQxJGc5hkCmdcANWsHIKZPagMxXCHM4xCcHfuxQ
         RbP+bj8qV5mDwevl4A5bVvnkzgzO1TgfGpa0jin2vrj0YS+E8Iy3L0+f/W2sNj7GbTj4
         YubA==
X-Gm-Message-State: APuU4Z//e1cKtQYEoGKPJ+mxVDAe/U+tFAGEkCJzWU7feNjfMI7ROWUE
	0fpDl4lIpSSMLoAL6XH8kNwr6jcNCM6nFlfQEQOdtkW8bhOopuKIgA9nDaDx6oYo8S/niSsAohf
	FxhjffC8hPF/GZoxE9TQKUX5vHtOQaLsuR2FA0oDzrUjePQO7jFT4ltT6SjVXCf+UXkoUvMgxmf
	YCdAHmLf5xKZZJVyHAlLo3pLPF3Tj8rmiGwUnqlAW1YZNs2Coek8pg
X-Received: from pjbgm11.prod.google.com ([2002:a17:90b:100b:b0:3b4:3d61:7517])
 (user=powenkao job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:d2cf:b0:3b0:9781:ee8b with SMTP id 98e67ed59e1d1-3b41c9e46b9mr12143945a91.26.1795483793342;
 Mon, 23 Nov 2026 17:29:53 -0800 (PST)
Date: Tue, 24 Nov 2026 09:29:31 +0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261124012951.3143833-1-powenkao@google.com>
Subject: [PATCH v2 0/2] scsi: ufs: core: Add debugfs for PA TFS/FEC error counters
From: Po-Wen Kao <powenkao@google.com>
To: linux-scsi@vger.kernel.org
Cc: Konstantin Vyshetsky <vkon@google.com>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>, 
	Stanley Jhu <stanleyjhu@google.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <mkp@kernel.org>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	Brian Kao <powenkao@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Brian Kao <powenkao@google.com>

This series exposes the MIPI UniPro v3.0 PA layer TFS/FEC error
counters (0x15C3-0x15C7) under debugfs:

  /sys/kernel/debug/ufshcd/<dev>/pa_err_stats/{host,device}/

Patch 1 defers debugfs initialization until after device init so host
and device spec versions are available. Patch 2 adds the PA_TFS_* MIB
definitions and creates pa_err_stats/{host,device}/ only when supported.

Changes in v2:
- Defer ufs_debugfs_hba_init() until after device init in patch 1
  (suggested by Peter Wang).
- Create pa_err_stats/host/ and device/ only when supported instead of
  returning -EOPNOTSUPP on read/write.

Link: https://lore.kernel.org/linux-scsi/20261123025745.1743640-1-powenkao@google.com/

Brian Kao (2):
  scsi: ufs: core: Defer debugfs init until after device init
  scsi: ufs: core: Add debugfs for PA TFS/FEC error counters

 drivers/ufs/core/ufs-debugfs.c | 213 ++++++++++++++++++++++++++++++++-
 drivers/ufs/core/ufshcd.c      |   7 +-
 include/ufs/unipro.h           |   5 +
 3 files changed, 220 insertions(+), 5 deletions(-)


base-commit: 08fec21faae44fe002467976befd68e6e62969b5
-- 
2.56.1.809.ga0b61035b5-goog

