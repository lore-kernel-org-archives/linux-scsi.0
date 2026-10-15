Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A3B4AC14A
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 08:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792052390; cv=none; b=UVaE9Re4o/ZqmROECamyBhx8EsGs4ij2nEPf5A5a9qWmRdNoNUAVqsm+nhlbjcF5y6E8O3KShI8rbdSnUcfRBWxHOsMtKXt6VAUWS7JVjESoapw0t/ZWk61m+G67kMrl5SBcTTkygh77bU61OaxvqcC1oqvA+SarRwy4PM5d9Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792052390; c=relaxed/simple;
	bh=6DHO4Va2w8tFmmBGFpjKQ98+TYZ/Yg9DyQqg582/Cdw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PIYxyIfk4w6q970/UhdndA8bEoOMVJQXB2/z/pRP9Z2nkqCsz5z8jm5K3BPsFPwtpMe/31vXTsAIk9tk3mLa2ZTx6WhUfe6657FbH//SryUdIkadKyf7vusG7R89Qk0YDyYW1QAQI2kTjA7AbfrAYbqGNbp1fV329kKmAT8si3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=sIRrvJ7p; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="sIRrvJ7p"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3ac9f49b984so223660a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 01:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792052387; x=1792657187; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cdMIhumT/Dh09O4oOrTO+0XHCJ1oiMJHbsxrI+Sf4R0=;
        b=sIRrvJ7pSESoBeSW+WiqlVSGXSWo++zPek/Yapzdq9kyGeH6BRbOqbUCg/DqqQ2Jpn
         7XmCCTNqaP6K+FEPQR06pYZ4LD6kb8spJ2JGDego9Pjz1Fuxi7I4m/xeuY5aNTMQTzKN
         XGZz7AH1KKVG+M+dNXDZKyxjE9ZimGdXBRNTMoq1RWTFd9RX3y4RNuHxeIEL2fadYDOo
         HpkElZRQebsnzBgIUigkkfTWUUzrU2PpnxX+j4YU96Uvb+sp1rTx6dtCYXDmwtOmihjN
         hvDRCilyXdS6U2avpMEVyIyQAoMes12Ay9aYJ9EW7L89CUCu4Yy3EmjZtvv8S6WPeIIc
         Rorg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792052387; x=1792657187;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cdMIhumT/Dh09O4oOrTO+0XHCJ1oiMJHbsxrI+Sf4R0=;
        b=ObxOC8ipF7A8O15cd6UQ798yVsIOiRbh8+fyOAce9mE87ZehpHTWTU/E+pYXsPP2om
         q+dfjB0rRtSH7tWBHaxVxWVRyrEt8/FEIGISB9DC410pMFrufv6qo27gJBuIwejRvZ6Q
         VpbT1iFTRfXqojvTf3mkrfdKnnrNN7MgSBvprIxXTvSt/MY0AV+/mdkEdp1w/35ZUDsp
         0cx3M8e9CzCIH98KhmTcZAuYIchsM4SCXUYtMWID3n4kMufI7Uyxh1JH7fcVuM1jqp5n
         pow6Als4qd2iqnFdlA+dVvFx2f4B/lE1vvQlfUK9GgafKdPdoyg3z7TRlNbdjcYQveVY
         5l3A==
X-Gm-Message-State: AFq9FYLF76GykNZ144rkLLOr31bi+jZwE8M/r6DseT6YHagts3IELQCu
	3WTlAESStYYqiX6OC7Yua++A2iFO9QLXSBiRYZJeBwlytEEDhm0nI36RdeFdhQitUOU=
X-Gm-Gg: AYBFou1bZuWqB6R8NPzPjCxKwXGLt5Fls4MiU7gI+IGBCUuO7vjV+tA00a0cF+gMwBp
	P/lTGscnodP57hA84fHOTbN3fcF5A//i/O2grcIX6oll8X46l3mPJbSP3mYZFOSp/pQP69aUd9d
	+rDX4M7N4p0ueXc0isZf6oMSyCBEzDAeHfF1G26+S6YkKsT6fIgrYn1L2iZEFuniP7vr9Y7GT1P
	h77B8BVG5CVnzc1b9MbJU4epQPTgSI2r9tTgygOj3h4tNbNEONuX/p5lG+5n+luqi6UejX6RDPl
	1yc0xgZbv8r6LLOL62M+/6l6lqcFiOAZGYLLn+s37BuseACW9ZMghSLOTFonCX0nLXn+h2dfg/f
	G8HxN/kefBPfYIauPKO43Vf10Iy5pA1cM+yKepVsX8dXjnFbJm3bdV5cT/t0SDlmtyA7wIeAgIE
	awLd+pE4NlLgwkvm8RJU7WmbFRfz7DHabfhVOzqbLhoKRXgKYoyLeJ9Vkz23mYY1Ja0gOcFQqB6
	dxrng==
X-Received: by 2002:a17:90b:1a82:b0:3a0:d82b:237b with SMTP id 98e67ed59e1d1-3ab3ab209f3mr9436183a91.25.1792052386864;
        Thu, 15 Oct 2026 01:19:46 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac943e755bsm3319784a91.2.2026.10.15.01.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 01:19:46 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v2 0/5] scsi: aic94xx: validate the indices the sequencer supplies
Date: Thu, 15 Oct 2026 17:19:29 +0900
Message-ID: <20261015081935.4168771-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This supersedes

  [PATCH 0/3] scsi: aic94xx: validate the sequencer-supplied EDB index
  <20261015072612.4144043-1-yhlee@isslab.korea.ac.kr>

which should be dropped: its patch 2 was wrong in a way worth stating
plainly.

aic94xx takes two numbers out of the done list the sequencer writes and
uses both without looking at them.  One is the empty data buffer index,
which v1 bounded in three places.  The other is the transaction context
index, which v1 did not touch, and which turns out to be the same class of
problem one level up.

 1  escb_tasklet_complete() already noticed a bad EDB index and printed
    about it, then fell through and used it anyway.  Add the missing
    return.  Unchanged from v1.
 2  asd_get_response_tasklet() never looked.  Bound it -- and, new in v2,
    report SAS_INTERRUPTED on the way out.
 3  asd_get_tmf_resp_tasklet() never looked either.  Unchanged from v1.
 4  asd_tc_index_find() indexes tc_index_array[] with the number the
    sequencer echoes back, in all three of its callers, without a bound.
    New in v2.
 5  the pointer that comes back is used as an Empty SCB without checking
    that it is one, and struct scb is a union.  New in v2.

On patch 2, the correction.  v1's bail returned without touching ts->stat,
and asd_task_tasklet_complete() has already set ts->resp to
SAS_TASK_COMPLETE and ts->stat to SAS_PROTO_RESPONSE by then.  That status
is a promise that this function will fill in the real one.  For SSP,
sas_end_task() starts from DID_OK and SAS_SAM_STAT_GOOD and its
SAS_PROTO_RESPONSE arm only prints a notice, so the command completes as a
success.  For STP, sas_ata_task_done() takes SAS_PROTO_RESPONSE to mean the
ending FIS holds the status and copies ATA_RESP_FIS_SIZE out of a ts->buf
that was never written.  So a hardening patch turned a bad index into a
silently successful command, which is worse than what it was fixing.  v2
reports SAS_INTERRUPTED instead, which is what this driver already uses for
a response that arrived and could not be used, and it does the same for the
lookup failure above it, which had the same hole before this series
existed.

Patches 4 and 5 finish the class rather than leaving half of it.  The index
in question is one the driver itself allocated and handed to the sequencer
in scb->header.index, so it comes back echoed; asd_tc_index_find() reads
tc_index_array[] with it, the array has hw_prof.max_scbs entries, and
max_scbs cannot exceed 5957 while the field is a __le16.  All three callers
of that helper already handle a NULL return, so the bound needs no caller
changes.  Patch 5 adds the opcode check that asd_dl_tasklet_handler()
already does.

I have not reproduced any of this on a controller.  Injecting the three bad
values through a KUnit test on a KASAN kernel does reach
seq->edb_arr[-1] and tc_index_array[] past its end, and does leave a
non-Empty SCB modified, which shows the arithmetic and the missing checks
are real; it does not show that the sequencer emits those values, and
nothing in the tree answers that, since it is firmware loaded with
request_firmware() and there is no Documentation/ file or MAINTAINERS entry
for this driver.  The commit messages are written on that basis and claim
no reachable memory error.

Patch 1 keeps Cc: stable, as in v1.  Patches 4 and 5 carry it too: unlike
the EDB bound, those two are an unchecked array index and a union
reinterpretation that the driver never guarded at all.  Patches 2 and 3
still do not, and I would rather a maintainer decide.

Yehyeong Lee (5):
  scsi: aic94xx: bail out of escb_tasklet_complete() on a bad EDB index
  scsi: aic94xx: validate the EDB index in asd_get_response_tasklet()
  scsi: aic94xx: validate the EDB index in asd_get_tmf_resp_tasklet()
  scsi: aic94xx: bound the transaction context index from the sequencer
  scsi: aic94xx: check that an ESCB lookup returned an ESCB

 drivers/scsi/aic94xx/aic94xx_hwi.h  |  2 ++
 drivers/scsi/aic94xx/aic94xx_scb.c  |  1 +
 drivers/scsi/aic94xx/aic94xx_task.c | 16 ++++++++++++++++
 drivers/scsi/aic94xx/aic94xx_tmf.c  | 13 +++++++++++++
 4 files changed, 32 insertions(+)


base-commit: 2c3418fffa9d037b2038a6db48be63f9e2291806
-- 
2.43.0

