Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7544C4E13E8
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 09:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792055884; cv=none; b=SWrtb7kU80tNsxQjygCtr623aFEjeH2IaIgAc0x4KwYHfG7VOyF1BUSvqy3VIK/Doo4hd/NO+7Jp5eHr4bJy1sBxWhVhzCPKIst7H4NdSkEJdaQtmdbh34ESPuj1hdEn2wLsCyPSOANR5kTZfAIEoscZf2euiHMuViVuCJ+Vh2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792055884; c=relaxed/simple;
	bh=I+Sej2zsaou8ZC5bWE8uIdgpps4InDWrIMdzXaw5pRI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DnPsWZ2Hajn++Z5KVQ2TERspKP9oSHOFwqgoM6lcsZFUTKI8zC/6IDnIr3m6y8e1mUvpKrbvxvflSRbQ3Ko/TWpPpt69Q9K++VX6aEFo5MmNZxklIptJVi7m/xsobtL8qN6xpXoizLfIBQygYgx6/bx+ZdsLxOuSpDIAGgpZK8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=Lvi9H91y; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="Lvi9H91y"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cc4b1f7e8f4so3203842a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 02:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792055881; x=1792660681; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=n4F9I43MamT/SxqYA1QZ+SX7IAOsbvvA++4GPflnXnM=;
        b=Lvi9H91yD+0nf05Jn+od8ZyjhZVBTZ+YzRY3rCcfAedJmUDjbxyEY0NDAi0sDk9AZ8
         lNc3F36U/DE2vCj0RjHoofCQwxQO68WfPqU0S2Ia1fp01UH9YhZl1I0NllrNKuA97Qo8
         6WWfTwUG1/xHT4LBESEn04YBMX2UK9o9PcRGpApc9OgxGuzvzp9Mqxox4a93gvkbzKef
         f71jhPJenzg0963zZNfgR2ujl0YdjBTxQIeGu/cYtELof8dzeaA8pSJfsque6J2eoDGY
         YRpYHXoT3E0fa/dR7P/+4FHmp44ZG1+o+sAJCbL7FU4414yIQR3XufE8LhP5RGDTB6wk
         idcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792055881; x=1792660681;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n4F9I43MamT/SxqYA1QZ+SX7IAOsbvvA++4GPflnXnM=;
        b=iYLkn7vebX21nD0XqkY2CO28mpg6PrS7yCEJF29PKCBfkroeqpIFj9v9kX7nFhcNjJ
         z86WbuvoDo3zWO9HH7YKqgr3mN28z9QNB3pAoaQ1NLgCMRz138h+9J94TuwOspcnAEJW
         8jQ1HSlqsO6k0o63Glxqn/r1A/aA/O5yAVNo1QG25UgqFuXrQqNYuWoiChhpKzixZq8T
         5OXYYK1Kcnj5nyqmQkOc4Wrag9I31tp18b7NjGdediqBmkcfgfQjKXBAW6ftk5+3dqdD
         8eNHiEoUps409tp7r1fUilBuGjniT8A/zFMVtI1zjHIuPiMTkjy4W7eKBsQM816wnGo1
         tXtA==
X-Gm-Message-State: AFq9FYLH08Ic8ZqufLRS4MvW57EjIbAVQpRQYfi/N09KU03j4jz0H50D
	0aW51uvRWqRhg+ZxwfAl+SIWPK+wMHF1NcQDemozrtBWQs+AMry0XTr1dU6oHE44t0s=
X-Gm-Gg: AYBFou0g4ihXseS1vdtrg5V3mmIA9i01o7rMIu0HQ8TcGfpDQTo/Mii4ZXtNCnFWqeT
	wDQ8M6CHqNKxB/xRoCgbu/oHNHJYFPpTozHzo26af6U6RsNztdeCUTLV31b/1ygzrrjarZJeH0A
	CL6esdrHh+g/jAQI0OWrc+svq9wwiyA3qA5/DRlF6ntE8VQHZSlDzrpLDqPkIc+7bCHkFpw6grQ
	3d1gmAuDolwlmEY5a1y+KW8+6NRIP9nW7Wahna0nsGfZVgdSn7B24UZWnT7+niQfHnY24ih5COq
	FYB7ds095haS3YSm6Oj+kCdPVBfwyprp459VfeoRXpKRWIIFk/1YgFVawn2dzz1kvkAXNxMPuSb
	UJdLLpSYuFios0G4ERG+sxAiCJ1i3ftypb3wD5nv0V7gnGFK4s8OaiPpYGEz17RQRP72QvEcSQk
	HvSPcvNZGK3S1M6oLO8q6tLUMzNsI5udRhWJnDAKuNCGNsF16+v8Di1+O4jYvDseAvbLhAQjLjn
	Mek49JxXsy3miB9
X-Received: by 2002:a17:90b:35d0:b0:3ac:450a:fa46 with SMTP id 98e67ed59e1d1-3ac450b7738mr6163126a91.10.1792055880554;
        Thu, 15 Oct 2026 02:18:00 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac943e821csm3412408a91.8.2026.10.15.02.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 02:18:00 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v3 0/5] scsi: aic94xx: validate the indices the sequencer supplies
Date: Thu, 15 Oct 2026 18:17:42 +0900
Message-ID: <20261015091747.4184349-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This supersedes

  [PATCH v2 0/5] scsi: aic94xx: validate the indices the sequencer supplies
  <20261015081935.4168771-1-yhlee@isslab.korea.ac.kr>

which should be dropped.  Patches 1 to 4 are the same commits; only patch 5
changed.

Review of v2 5/5 asked whether reading escb->scb->header.opcode outside
tc_index_lock races with a concurrent free of the aSCB the index landed on.
It does, so v3 moves the check inside the critical section the lookup
already takes, and clears escb on a mismatch so the existing "no escb for
this dl" bail handles it.  That is sound for a specific reason:
asd_ascb_free() clears the array slot under tc_index_lock and only then
frees ascb->scb and the aSCB, so a slot seen non-NULL while the lock is
held belongs to an aSCB whose free has not started.  It also makes the
patch smaller -- two lines per file instead of a separate bail block in
each, because the NULL path was already there.

Worth saying, since the review framed it as introduced by the patch: the
driver already uses that pointer after the unlock.  Base reads
escb->edb_index and calls asd_invalidate_edb(), which dereferences
escb->scb and writes eb->flags and escb->num_valid, all outside the lock.
v2's opcode read sat in the same window, and in the case it is about it
bailed before those, so it narrowed the lockless use rather than widening
it.  That older and wider window is still there after this series; closing
it means either holding the lock across asd_invalidate_edb(), which reaches
MMIO through asd_post_escb_list(), or giving aSCBs a refcount.  Neither
belongs in this series, and I did not want to bundle it silently.

The series as a whole: aic94xx takes two numbers out of the done list the
sequencer writes and uses both without looking at them.

 1  escb_tasklet_complete() already noticed a bad EDB index and printed
    about it, then fell through and used it anyway.  Add the missing
    return.
 2  asd_get_response_tasklet() never looked.  Bound it, and report
    SAS_INTERRUPTED on the way out rather than leaving the command looking
    successful.
 3  asd_get_tmf_resp_tasklet() never looked either.
 4  asd_tc_index_find() indexes tc_index_array[] with the number the
    sequencer echoes back, in all three of its callers, without a bound.
 5  the pointer that comes back is used as an Empty SCB without checking
    that it is one, and struct scb is a union.

I have not reproduced any of this on a controller.  Injecting the bad
values through a KUnit test on a KASAN kernel does reach seq->edb_arr[-1]
and tc_index_array[] past its end, and does leave a non-Empty SCB
modified, which shows the arithmetic and the missing checks are real; it
does not show that the sequencer emits those values, and nothing in the
tree answers that, since it is firmware loaded with request_firmware() and
there is no Documentation/ file or MAINTAINERS entry for this driver.  The
commit messages are written on that basis and claim no reachable memory
error.

Patches 1, 4 and 5 carry Cc: stable.  Patches 2 and 3 do not, and I would
rather a maintainer decide.

Yehyeong Lee (5):
  scsi: aic94xx: bail out of escb_tasklet_complete() on a bad EDB index
  scsi: aic94xx: validate the EDB index in asd_get_response_tasklet()
  scsi: aic94xx: validate the EDB index in asd_get_tmf_resp_tasklet()
  scsi: aic94xx: bound the transaction context index from the sequencer
  scsi: aic94xx: check that an ESCB lookup returned an ESCB

 drivers/scsi/aic94xx/aic94xx_hwi.h  |  2 ++
 drivers/scsi/aic94xx/aic94xx_scb.c  |  1 +
 drivers/scsi/aic94xx/aic94xx_task.c | 10 ++++++++++
 drivers/scsi/aic94xx/aic94xx_tmf.c  |  8 ++++++++
 4 files changed, 21 insertions(+)


base-commit: 2c3418fffa9d037b2038a6db48be63f9e2291806
-- 
2.43.0

