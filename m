Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18E0419305
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 11:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791805282; cv=none; b=uuu8dRV66dRRaVeRQ1QGTlyijpvzOuCeguxzdkgYjZJXUtDWgJsnbIFqmvy4Ghaf+UrRy7eBeA1Fso8/8fE5Gw2coq+bdjDsmAPWyDvHf6/Dltg2crCko4djeCnYth1pNLL9OwzQqhfpoJfeMZkBODuCm3ZkMkTT/YihEiNl1l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791805282; c=relaxed/simple;
	bh=9f1qP22E7ACqG8t1APh1XFdIVpv9e3uZVhIP8YPFdKw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OpECrz71bqlRuMVtTkLnI+BUJFAaJgOrLi0bwpfRToaORMJR3vG1WRWoI7135Js6ftrHSNnWXdJ8uDcn1HaOzolQKPAnheDTcsxgtsDbXDbv82DFu8f/A0vbG9UI/I3QZrgB6AvOcduHyeYWLfoKkXjNwrddnGuGT3/PMhFfQY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=zO+WFfWh; arc=none smtp.client-ip=74.125.82.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="zO+WFfWh"
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso6080306eec.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 04:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791805278; x=1792410078; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aa4X8EZIe6RRJuWAcoODb4Shn92a/60HzOzQllDMN1g=;
        b=zO+WFfWhDdnmruaoe1lkfDrhV/Qm9cyhgfimNCJdksBOKXdztg6CEQ0reZHIsbcITs
         EXhzq4hLSz0+/JIDUdb9PHtlxHUaOrtkMbvQJdeTpcKMfDmF4V7D7wMc+f/g+on23n9K
         bBtt/M+19nSVdXka5/pJYZLsUkQ/gRln20nRUmt1iw0pRyLYrE/3KO98jA/4DfXrWch2
         +Lwm3A44EW3mthVNglpjSh/bIU4hGhUIQ39txQ+glrUrwiB+3Ij6lK2tPNml0BiTyWRx
         HUNy2jFoqu5bBn5sOHI0FxQOce4IP2VrLY8prRJpOrw6jEy7f/eRwWcrW84uGhrm2HvT
         i8vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791805278; x=1792410078;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aa4X8EZIe6RRJuWAcoODb4Shn92a/60HzOzQllDMN1g=;
        b=W76ySV7a0dTZSffmBVBF2+6LvjvXIkt7C8+JkjZG3J6I7U0X8eAIuo+aR2ulnBeLyc
         l6KxJc4FbEzhwrvhUer7QWksyTb2RsLI+2ltAGO2shUjQmH37HYW+Ki3dbRo3HF3rkhe
         q3qVihFxN5zHR3wtLntrJBmNM3idyc4VL1DDHF+eMQ6E1BJTYsy9fSXRMsNOc/0yI4XT
         bRxoGkjHegEgYIO7vIpGvSwAniVhJOYEnFeJm5KksZgVD45d/Y4B87ULKj9Y9Iw7ftCx
         Xf3UGoRGKXrA6xjZ0eQ+0jy5+oxuwyeGPI0wB17oHB1PTXm7aHb3veXML3jeWzdaLJOU
         czjQ==
X-Gm-Message-State: AFq9FYLiuOUaqdZJn86gixqInxtAF/OJtBEKsJy7TqsRwj+lriDOCBPt
	aMbmpBEwp5o7cH1fy8gJagOlDXe7fe3c7JkTOyt3JyO6EtuWZTA0ZDvW++NNffl03Jk=
X-Gm-Gg: AYBFou0dI34dPFe4wVuqAOGpt8g6lN9nxlrTsGSNO6wICVElhfHmne2xK2XQqrw7386
	yRRX5atNXaxd3NhlFH3Y30cnr2DqChxpeIPbJOQkYb47ClCr/njIQnLOcjXgGzeZsT4680a+WGE
	HtdZafCtuvRnx7dO99iyUzltbDtFBaFoRmiKAM6Peb98b4FnEnDYPKcd3NrEguJvi5mBArE8+XT
	+N4MNMug4FDP0ZEVM1C2Z7S/rKuQ4Vuc2jqfh5e2OgJnN2pTWgc+LNj+sqVLf3/i1gknWauCiLr
	FBt57f6QW1FIznH0tLRCRV88jMAwTE1WCixx2i961ZerHkSY45bIg9xt1KaW1dJ/0zODhOG9eZu
	otVNtCeGRK7Y2j9ScMmf5CrBionN2hR+4ILaVqBrnWQvbVg5G40Aez5tflWpOjgCqdQjatwj02y
	VlTUrN4tQDq6CBNQBqbOxVt5T0e1DEp+ISdwqeL0U1LWMHeSF0WrsIBvBgGfD8GKH39/IeSWVYZ
	84kmaFBh+kfFdSBaR2oRQ==
X-Received: by 2002:a05:7022:7f07:b0:152:91d0:dfc3 with SMTP id a92af1059eb24-16a62eaa220mr14745427c88.23.1791805277782;
        Mon, 12 Oct 2026 04:41:17 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:7bd2:1202:246d:44ce])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1746482c978sm8725533c88.13.2026.10.12.04.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 04:41:17 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ching2048@areca.com.tw,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	thenzl@redhat.com,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH v3 0/3] scsi: arcmsr: bound adapter-supplied completion indices and message lengths
Date: Mon, 12 Oct 2026 20:41:00 +0900
Message-ID: <cover.1791803953.git.yhlee@isslab.korea.ac.kr>
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
v2: https://lore.kernel.org/linux-scsi/cover.1791792888.git.yhlee@isslab.korea.ac.kr/

v3: patch 2 -- bound against maxFreeCCB (not the pool size) and clamp
    maxFreeCCB to the pool at init, so the index cannot hit an
    unpopulated (NULL) slot; v2's ARCMSR_MAX_FREECCB_NUM bound could.
    patches 1, 3 unchanged.

v2: patch 2 -- bound against ARCMSR_MAX_FREECCB_NUM rather than
    acb->maxFreeCCB, and on a reject release the entry and step the
    queue index instead of stopping, so the consumer index does not fall
    behind the producer.  patches 1, 3 unchanged.

Yehyeong Lee (3):
  scsi: arcmsr: bound the firmware-supplied message length
  scsi: arcmsr: check the completion index the adapter reports
  scsi: arcmsr: wrap the type B completion index before using it

 drivers/scsi/arcmsr/arcmsr_hba.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

-- 
2.43.0

