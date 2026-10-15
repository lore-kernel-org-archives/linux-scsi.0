Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB401424D76
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 07:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792049198; cv=none; b=MMcnKEDDLwBhHg6vyU9WXhUz3c/HojSzth9UU6oH09hBcTopYDWOWr2zjo9sLHm+n8o9DfC3EmN65+W0RMYes3T32qs9RPNaCS8K5Kf/mRi/oHkS/p5nAocEKMvUDcWnxw2asKBF9Izuw1bUZ7wf17vQjt0hvZhK5Ti6JbjztVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792049198; c=relaxed/simple;
	bh=hwdNJteCF2UYN9dA77ChB03VK9w7Fqhyx9KhxgEpbDI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KclgJsDZ8vqUzY/Ava/xWtWlwjv1AJ7ElpQw4K1hVP6Nt/9EJlRZNtn5657+43X8syTUfubobJB8VkUuRf2NZDYzdrRgdBDP3C6vfLU0UlhBLqtlwtSQEQGqPzw/wGI7/hRDqIMFAt8S6llVfMnHc9476UFBaUcGiI5HZDP5Wr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=oZMGJZOQ; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="oZMGJZOQ"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ac9f49b984so191828a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792049184; x=1792653984; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LHVIvo7ImdizzbFTBs9Bb5lPLWEkfS0ZMEj3JexZwCI=;
        b=oZMGJZOQQ1CuzRocim424LX4Q3fvbc0PV1eEdWU16mdfeAT1jAr6Y6KjyWcMaRDj8k
         sMQqoZyTftqo022qMsUfi+YShrolBeqUQpR3dSV0UUw5ZkTdnev64JPxVgMJf/QIgw1C
         eFG+G2DhATn5AkbAUXzppRhQTJOcGx8SEGlN26ACUnr/q4vZEeC4QTS1/ts0OWsXWhIz
         tqq8LDvAeII+txAqscInuCSqcZQHZq/SRB3IYl9fo8qGQ9KHOp0Et6mZO3+XTyY5ZV6R
         GiUzFWkts2GNBdDgG5CKvxRPLeF2vcdN/x2pQsgK+isgmcp8DEDV1SekrCxJMgDNBmuo
         BzcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792049184; x=1792653984;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LHVIvo7ImdizzbFTBs9Bb5lPLWEkfS0ZMEj3JexZwCI=;
        b=N7UWv4w2ADzp3V69AfiM60UKkoRFmwVRh7KTypNEvCJslOM3mcx0iDBJ4W64CrEsXE
         U0TdrufiqDFVT3MyCRnlazNCQe9hemTCMapNmltNE+kDCQiL7xCVoeyD0XxCxvbxC3qj
         b3I3MDOTDb0d0KGT50C3P7qsES380ow/q+FdcvXyMP98bdfseAvpoGFyDf1gJXqkbDTO
         +6hTEk/MmIaDdjFX2C/46AAR7n2Tlhd16qSkLytvQx0aZ6YX3AdIrWd1TUbfJRytlrhz
         7Q2c/fQknjbCCaL29FjL1P1iAzvbwe81ONMKq+iFFDsd50a5kYTNwcfv5RKTC5u000du
         sAig==
X-Gm-Message-State: AFq9FYJhQ4TjBPlcms9WJfy9Oqd1nu2HvLF5e7VT4wOcUQi+8S6ixivF
	XdF6jBgFuFt6HQA1y7VQixi7I+ykFtB/IFYqpFAxFr3YLr3OvkC+Kx9sg5V+ORkciLhbIq2TAZk
	6xrwx
X-Gm-Gg: AYBFou3A6iC/aik7WhyNuQm5vwMncjN001SHX619gQKAYvud4Dd3G50Qj61Vjr/EVtR
	WQHXXeb61iSZjOPepSyNRAXtgmEroLiT0HKbeb4M+deb513rV6Ngj95R/+WW7D4iRgOFJnvLbEK
	SaKwCjx6xv9qfPQfk+Vuihbx1z62Ob/hGh1mgk3UW9oiS9IVHkbUVB9OP/385Q4Zqhnr2p0kklZ
	gaZ2Zb9xAHvBN0Lxo81c8g648qS6f2F4aX0t+8rkWNg6nnGQ6yOzNfqk4f0W3Kdmx+xYFjo457g
	S8cmjPevOqqDPMFFnXU7zOwSC+EJrtxKlJvdXRw860ZPpTz8W/F5icIAW9W6j+FOCJ8NblxfVkS
	AJLOeJ6Jmk6KF5eb1L5bTRdkq83YcKuNf7TasyeyYLVXkqVx5mae8OZ0xEYxQMD8zIULwosKGHS
	qvI/H4Q2YXZb9yJIDI3cqf9UUoLFi6TIqpXd11TDf7bwXqlM6PlItI4Y1xj6H8hEuBKaBY3nWT7
	ckEWsc=
X-Received: by 2002:a17:90b:2644:b0:3ac:860e:1af9 with SMTP id 98e67ed59e1d1-3ac860e1b6emr1889099a91.41.1792049183653;
        Thu, 15 Oct 2026 00:26:23 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac937c4e7asm1754279a91.3.2026.10.15.00.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 00:26:23 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH 0/3] scsi: aic94xx: validate the sequencer-supplied EDB index
Date: Thu, 15 Oct 2026 16:26:09 +0900
Message-ID: <20261015072612.4144043-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

aic94xx derives an index into seq->edb_arr[] from a byte the sequencer
wrote, in three places, and subtracts one from it:

  aic94xx_scb.c  escb_tasklet_complete()
                   (dl->opcode & DL_PHY_MASK) - 1
  aic94xx_task.c asd_get_response_tasklet()
                   ((resp_sb->flags & 0x70) >> 4) - 1
  aic94xx_tmf.c  asd_get_tmf_resp_tasklet()      same

The field is three bits in each case, so the result runs from -1 to 6 while
the designed range is [0, ASD_EDBS_PER_SCB). escb_tasklet_complete()
already notices -- it has a check that prints "edb is 0x%x!" -- but the
block falls through, and the other two do not look at all.
asd_assign_edbs2escbs() gives the first ESCB edb_index 0, so for that one
an index of -1 reads seq->edb_arr[-1]; for the others it reads the last
buffer of the previous ESCB.

 1  add the missing return to the check escb_tasklet_complete() has.
    This also covers asd_invalidate_edb() at that function's out:
    label, which indexes escb->eb[] and seq->edb_arr[] alike.
 2  the same check in asd_get_response_tasklet(), which has none.
 3  the same check in asd_get_tmf_resp_tasklet(), which has none.

What I cannot tell you is whether the sequencer ever writes the value that
makes this -1. The sequencer is firmware loaded with request_firmware();
status_block[] is an opaque u8[4] in aic94xx_sas.h whose layout appears
only as a struct declared locally in aic94xx_task.c and copied into
aic94xx_tmf.c; there is no Documentation/ file and no MAINTAINERS entry for
this driver to ask. So these are not fixes for a demonstrated out-of-bounds
access, and I have not written them up as such. What they do is stop the
driver indexing an array with a value it either has already decided is
invalid, or never looked at. The driver clamps a device-supplied length in
asd_bytes_dmaed_tasklet() a few lines after indexing seq->edb_arr[] with
a device-supplied index and no bound, which is the inconsistency these
close.

Patch 1 carries Cc: stable, because completing a check the author wrote
stands on its own. Patches 2 and 3 add checks that were never there; I have
left stable off those and would rather a maintainer decide.

Worth naming: a response dropped by any of these leaves its ESCB
uninvalidated and so not reposted to the sequencer, because the repost
happens inside asd_invalidate_edb(). That costs one empty buffer per
malformed index. Recovering the ESCB instead would mean picking some other
buffer to invalidate, which the index does not tell us, so I did not invent
that.

I have not reproduced this on a controller; injecting edb_id = -1 through a
KUnit test on a KASAN kernel does reach seq->edb_arr[-1], which shows the
index arithmetic is wrong but not that the sequencer emits that value.

Yehyeong Lee (3):
  scsi: aic94xx: bail out of escb_tasklet_complete() on a bad EDB index
  scsi: aic94xx: validate the EDB index in asd_get_response_tasklet()
  scsi: aic94xx: validate the EDB index in asd_get_tmf_resp_tasklet()

 drivers/scsi/aic94xx/aic94xx_scb.c  | 1 +
 drivers/scsi/aic94xx/aic94xx_task.c | 6 ++++++
 drivers/scsi/aic94xx/aic94xx_tmf.c  | 6 ++++++
 3 files changed, 13 insertions(+)


base-commit: 2c3418fffa9d037b2038a6db48be63f9e2291806
-- 
2.43.0

