Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB41836C0DC
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 09:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791795726; cv=none; b=h8U6jxR/x/5zSYJtQFtlg0FTBnaPJkk9HsjX5OjwiEeeElvzzxfc+piHk+fnASe0rm6/mZUNJnuB5cIvUeg3A6Qw5LyKr8HVcjPmOQxLnzKdMQvaN0k62CP+HfZSe9Kl0dpIPS0NWbhAZ6bsCCU+eMq7G0e0UUd7thWDHpNWEj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791795726; c=relaxed/simple;
	bh=r5gT4zEbVmLNb848SgDkhWM1kOaJDLLxEYia9+NzsdE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=siCH/dqyC9lecJETCiujl9IJ/UnPllTKEB21uevHERrxTGXGzQT/1OjNc72njzPKmuUqHQKqsURxSrXzg7NYbHtYf4dlulXM6HcNeEUOkNP9K3KUjKjFA9hRO67fmNrDxH5Z7q+bcPYS+ccvFxpRKWWNNBOBfJRcMUDUueOBug4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=0p8Y5qnN; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="0p8Y5qnN"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2db80fcdf8bso9015645ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 02:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791795724; x=1792400524; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KRIZkJTuAFVV6WLPWb+wMz4OO8owKguCsufpDjwvnJQ=;
        b=0p8Y5qnN4Tme46/P3V2sHR+DEPcfl86gtydFLneW2pdjhGqbsumPm+OR2uVXqPnvB3
         B2ndw1RbnoPeh44DUrEosfi16xHTkfIUtfp1AzpaOtbRpe5NCISCC4YFhQ+eN4TwEEaI
         fQUDtiNuWjsl7+3LHStRi21bGvvdjVNCDxlheXNi4/6mWiAMkXNffWHPxxGHSc0dRfOX
         gBmCe0rYYKh68vJALYN+vR0VqK/78Z21Gf0deoeJzg5ZAlWQzC/30HOd3e727w/GCvgW
         kGad04Bitqe5RVBjL98H2qIY64s01wkB8OdjTKjFu1rH/m/+rqbXYJIdGTEuHD2NCo7X
         YMvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791795724; x=1792400524;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KRIZkJTuAFVV6WLPWb+wMz4OO8owKguCsufpDjwvnJQ=;
        b=PR/X+Rk7A+VqgpNrfEnqzQSZxCn7hNR7H6AX+y1dpqQOOmkqchR7QJrIEyXORcPNXL
         /49gDBDwrAabq9tQsH1/rot9wFo6RsYhgR4JHdxHoxJC33yAhPojmWmPcMG0RfAzltWg
         9phTXGBy/SmG+B9EPqMhjitB142TXKyiDlKPFSivcCk5vjyYG3oyiapTbVseUwXDhMQk
         qePDtDfcAyWs2QH3lSdmKJU2jdgI7kpJikMxfhStsrqyyIbLGiqfeFWMRo40KKZ1LzY0
         Kx5XHHS+He0PNlxq000cIFcOCNtGF7Rjwx0oC6Ne2em5oZC8zBAT20Ys3eDQlspqSqYW
         d3tg==
X-Gm-Message-State: AFq9FYIuZjPOGkqFtecAU21sY2eua7RSgX8pSEOa+/WLn9EAyahkSjMi
	tFEcdLI1TMWko5mV0fk6pbMxFPpAZEzEU4BY2tIU+p01p1aWrnhq4HXMIEbkNwQl20A=
X-Gm-Gg: AYBFou2PlE6W2+zHS5/pOcT56tZM/6T8mn1mukZtw7EzhIG3fzGQ2m0+FS77ilgQhtr
	GALBJYSh9ZztQ/sFAwM3wfKXUu/3vkblIkWnQ4d7vEm46mj7V4Gr9JfE2cEMEbA/zWjaplE74Zb
	tssYr6iKg/VBObHjBLw7JzFWYzF3MkFxO22J+XP927Ixa4uzQtSYQKwmUSyzTQEKARso1f2e6Xa
	NajeFUHBESRsHrFqFEKsou4FS9oca8dp4gOdBosqOu2tYrf1uorJDGznPrcwaXekKS2s5Tyv5xs
	sTAQTK1eTFw/eguH/Mfpbk/qNPI9z38jz+MJaEu04amPBvVqOvryog+tDlSIrhANFwOzTtKZH0t
	tD7qLjaTrcRgUVAYf2jmI7i/3ZVoekhuF3qS1L99kqTWIw/4wR79EOdTNKBqhv9exrkrGiyUEPI
	RLwwopX+YCZZ+1F6B1zO2rQZh45uoENO4MvzULVZfWbPSvLmGOmIKqnr5Y7wkystQ9zrutmeM+O
	pmX/2FbqWtvUjl8
X-Received: by 2002:a17:902:ce07:b0:2dd:ad73:5b6c with SMTP id d9443c01a7336-2e8429ad1d4mr75888675ad.28.1791795723812;
        Mon, 12 Oct 2026 02:02:03 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422e4ebfsm41638795ad.78.2026.10.12.02.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 02:02:03 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ching2048@areca.com.tw,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	thenzl@redhat.com,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH v2 0/3] scsi: arcmsr: bound adapter-supplied completion indices and message lengths
Date: Mon, 12 Oct 2026 18:01:45 +0900
Message-ID: <cover.1791792888.git.yhlee@isslab.korea.ac.kr>
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

v1: https://lore.kernel.org/linux-scsi/cover.1791789900.git.yhlee@isslab.korea.ac.kr/

Changes since v1 (patches 1 and 3 unchanged):
 - patch 2: check the completion index against ARCMSR_MAX_FREECCB_NUM
   (the pccb_pool size) rather than acb->maxFreeCCB, which
   arcmsr_get_firmware_spec() can raise above it; and skip a bad entry
   and continue rather than break, so the completion consumer index
   still advances (clearing the entry to 0xffff on type F), instead of
   stalling the queue.

Yehyeong Lee (3):
  scsi: arcmsr: bound the firmware-supplied message length
  scsi: arcmsr: check the completion index the adapter reports
  scsi: arcmsr: wrap the type B completion index before using it

 drivers/scsi/arcmsr/arcmsr_hba.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

-- 
2.43.0

