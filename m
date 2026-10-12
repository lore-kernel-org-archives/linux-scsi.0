Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A0C36D9EB
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 07:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791790722; cv=none; b=VYcEZcJP5FffyRKgIiKQOiJvCnvOlUk7G9tZCiNjZkxMuf6Zt63/9AK90dsekbArOyhaBSE7lzXyg6TVZxAjPDNa0chzCCmX+iPnusDdlo5uGBiToMC9hpiAS7SMtD2oTR9boWmTcrSmv1RD0k7I6RCif9Vtp0Evx4sPY9Hbkas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791790722; c=relaxed/simple;
	bh=k/Ste6K7riK4U4H/eng95jFc4SxOT/Gqt0qm28BCbg8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oQhuCJ5qtL9e72KvZ8ZnezU3VOvhVJ1s3X2SuWsxxAj/3pL9f1fZZIyv6sfx8Juc4gLF1+nHMgaWJIJa3TW1cFSfdaPyHt79Dczqe+VwavQqrlPZ+PVZxtt5Fzpa6eOLrOOibH+uFj1J6NlZacXGQ0DlQdPOQ0qY5cJTocQkz5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=T+wbXCxG; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="T+wbXCxG"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8875d220446so689400b3a.3
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 00:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791790719; x=1792395519; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vZUQvIk4esipOPh6JhqFb4csORQpQ+ynl//reiEHu0Y=;
        b=T+wbXCxGgTnhphpkonj48h6xs/SlKTARDJ10qxiN8638nCpw67LWa+ufKrcYric90e
         /8wHA14wcNI024sOrpaOM7x4Pqg50paB9TabW0TBkbNjKtDGnPVSwXYuM2bfZp7IFSAc
         tF2hkKFKxnprZQAh2Q5EZWd/fUtRgBAvEItrbXuULtGAwpG0oX7O3ePZeWAUZhrs9C4u
         agyFFcoWMr8UBzMXgajbDG778uYizcTZ4g7vz5Td9NqwdxV3/9MfpEM5imHl9HLdN6EK
         J45O9By9FHSLCB53WWTZd0GF2ruoVUTdGcd81WDcMIRe0OwRzwaJQlJFXYkBN8xCPoqH
         msSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791790719; x=1792395519;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vZUQvIk4esipOPh6JhqFb4csORQpQ+ynl//reiEHu0Y=;
        b=Ghr+Myb3zBfEGUqfMaF2Ot7a+84zwRdSZUt18skPGkaptRHLMd5mfhNtR6Hyl0mOAX
         zjX9IpWb3Jn8NcSp44kbdx1nWjM43Y8BKJjfMT5Nsmg7ipeAu7uYpfNRfCxQoC+A5yLa
         oWuq2XIquj0xobFJzavUv268UxF69IMJ+DgFGLvU0tAPcfoxUuYZeg0iC0G55ahMvt5K
         ytZL+UYz4tqFXgx+SYLuoILyy9ps04ovrqeQ+/McmgtL5r/DfC1OuVdMVJU3RNK8yf6P
         nS2DxoSRn3Dn6kTy9oAbbTrfNt6K778hLaWgOeW1dCnueiMV0CeqhFkRGMNObk7DvsVp
         f16w==
X-Gm-Message-State: AFq9FYIbeUnx2laM8maAOvNNkncePCe+5Kg9+yvuhTRH/x0KfcFHJOys
	Ap0NPapbiDfnB9ZOAv81d4cu1lWmM9gRYck2XsEXVgoFi4DCtl7V/brvKRTijeQIcTc=
X-Gm-Gg: AYBFou04ojCKPrwzsTxRKnOTcLTu9CUilaUcC32M37lE6YmhOkrVExMU4+TAv8UXxBd
	5N4tINGa1hdaCIjolm4v700kLmbi+JasqbmHTvVrFGu+tw7HdBkQR5NCeGfWCNEV2AAEMkkRSpk
	mR6YQlbolR6ro0IzuAJy9fVLixaQeOubY7fTz9bFJGZRlTDw3THDGmzE/tCwy33n9S60+HRF/od
	L7M020H2a4Y4ZKMIDmzRk6YMcGcD86VzQKcww7BTpVre7H1m+N12l/ycUzwnvxwXnjILbxq1NeP
	KoA/JvcYKce9Q5U1It13yr6KzQ2EXiWlBmjyZznJ839o0ZBUxeHZ4OjmebL2G5oWbyFGPUq/IOS
	js9BG8MnhY5ge3FpC9y50teuCFxXPwHIk0kCZkugO52ZaRA3HH4HvScQ1ZEGyRPgqyi1qmEC2nx
	UsV0CkduHV+TsM85D2WM6lXO593CpCuYttorNdGq3TQKoBYlCS0ssJMuZUCWYLLkhTgCKckmA1s
	9sJLQ==
X-Received: by 2002:a05:6a20:430c:b0:3e0:c961:b5b1 with SMTP id adf61e73a8af0-3e16be576acmr6010134637.45.1791790719022;
        Mon, 12 Oct 2026 00:38:39 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-898c9ee8bc5sm2148780b3a.60.2026.10.12.00.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 00:38:38 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ching2048@areca.com.tw,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	thenzl@redhat.com,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH 0/3] scsi: arcmsr: bound adapter-supplied completion indices and message lengths
Date: Mon, 12 Oct 2026 16:38:25 +0900
Message-ID: <cover.1791789900.git.yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The arcmsr completion and message paths take several values straight
from the DMA area the adapter writes -- a completion slot number, a
type B completion-ring index, and an inbound message length -- and use
them as array subscripts or copy lengths without checking them against
the array or buffer they index.  A malfunctioning or malicious adapter
can therefore drive an out-of-bounds access from the completion
interrupt or an ioctl.

Patch 1 clamps the firmware-supplied message length to the staging
window (heap out-of-bounds write).  Patch 2 rejects a completion slot
the driver never handed out (wild pointer load and dereference on types
E and F).  Patch 3 wraps the type B completion index before it is used
(out-of-bounds read, and an out-of-bounds store when the word read is
non-zero).

Each was reproduced on a KASAN build with a crafted DMA area; the
per-patch changelogs have the reports.  The three are independent and
carry separate Fixes tags.

Yehyeong Lee (3):
  scsi: arcmsr: bound the firmware-supplied message length
  scsi: arcmsr: check the completion index the adapter reports
  scsi: arcmsr: wrap the type B completion index before using it

 drivers/scsi/arcmsr/arcmsr_hba.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

-- 
2.43.0

