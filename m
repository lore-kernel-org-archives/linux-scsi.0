Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0019B3EB7F0
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 08:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792139314; cv=none; b=j9drvhYFKrlYO4/WFvF/UVG7PIE/mK5Kk57CFQMiangp5n9YDaW7M8Pfr9pfyzrYzqR99YwOqar2w/dKeSESVwGSqh/SmFV0pnTxzWTBFcRRWXLdKxYzH15uaScp0Nkj06NAUmMgGN+R6ihv4/Kdp07nqBP+HYs5BZ3+Mvms/LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792139314; c=relaxed/simple;
	bh=vUD/VtXc8LvpGGNYrkLmiyoc+tB0xhGq5Xw/a49h3Kk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZytZHqhZst+I3Uk4ThYunT24dX+l2EWDjNfVEJ20gKVCRDEYzaAwSBVtlGIkgV6ZrLB2N3iH4byMA7jtgDuVQ+2WM05xO8G2mHewWyIXlNV8qzLbtkCBs1qpEEwPRExLPIioBl/YaDvMLxW1KaoLyPKBqUv9LmQaAp6pBIjOvFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=LBOTHCSu; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="LBOTHCSu"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3acc96a256dso323623a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 01:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792139309; x=1792744109; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rkLQQcE2uJE3UhEZB2zlpp3KdaEDgDInSe3fSPmJbzs=;
        b=LBOTHCSuEWrtqhydmFmJjtV1vWrswCmUgkypiZ2pPgeZAGAIp2+PwAXyHdarhkNpAm
         NG7O3tzpXrnCpfr87K5oos0ra9Jck3rS6Wmp3I5jAGOVfYbHPAPFZlKEjS0PXFn1xIhT
         M2AwSgl84N61tCcTQrTrt5SF2ms23omi536gYbzGfNAC3NDkhDn/8+IA1U97XQz/fR3v
         4jBW65kMlsBupxtzVe+leowomLjMwDynfitbvosXpu9lDjmffzDAz76payLxzbMOQhCg
         RnVp65Ho/oVvCq6egx8qWNVZDZCTCxvFIKvhLLLdDCXrqovw98Ot5F7OZzNeLO376pY9
         JTzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792139309; x=1792744109;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rkLQQcE2uJE3UhEZB2zlpp3KdaEDgDInSe3fSPmJbzs=;
        b=Htc7bOeGNXDWS5Q8BJVN8S4B+xlX3te+nSUBombgu9MeG2qAnQ6iUcyvgs7IkYZfkD
         xuCtZko1xbMonilDnvTEx89Crk/lcz9NiVT0aLrpi0zxd/rMHh/vZEN9QgC2rv8lX8yn
         8tBLED/tQoOtjkBvyz7W/s093g3zLXbn4cpaR22lUrr+pt9Vizt0adPa0La/klVmOqoU
         iwhaBE7mjF5ydO+y9gyNFASJWTmzTXUV1l5jziD6q0iy7/R6upPwAn8JH6De+Ysd7mo0
         +EqnXHbeiSlyreTh/hNuW8QzYnAfRQtjbDs0tjlRLkugkFTBqnzibrJz3Suq5Zw7LdQL
         voig==
X-Gm-Message-State: AFq9FYJhM+RHJ9y76r/0Pri6dfysyPcUC0JxaVCf9TjXOwDv36XhJD0W
	1vIvn2Yj8N2BrjfzKvbJPUmVaA3nhtpss9HzczQvOFTvffxEiX0qZ/z3GlMETLT9wBs=
X-Gm-Gg: AYBFou3sh88g48GL75E2AafSgVyymQlygh2WBjMwDrV0/rW9qXpuXS0Vs2Ioc65jbOs
	8O0hkM9V3iDVcsHq+vhroyCxkQlbftyoWmNKqfxnyV56ykDJ3Ma9dgp0Bn/AmkOD8xE7Mz9A26a
	3PV5akuHK7mOgjqYvi9Dq9+YYFVemqGDB4fY8yiR8IIrdfTKdzCkNhD6YjXv1L3zsZmb/tfQvxO
	ni/NI4skYhFLIzeGvxHpPa8hFdCSi921+DQI61isAUwoJS5m7mnSdvdw5tZRw0UCe6uXcw29+Rn
	TDbykW1V6nofXIIhStGDfr9he5Ibd4FwtPp9njSVR8DewM0R0eFuHEHxXTj++melzAvo24PLtbN
	G0xUHAr7TPggM2cy5HUFBI9yde0nSuILELsEdWTX/Wfkkpq2dLN7deiscVD1m+MaCPoAkMhsYkM
	d+JMWlSHH5AvHcV9xJmc61gC1h6bO7N02ym1BYPgxS6I7yeJp7hf9BS9YZc/Bkx78VEleAtdwcS
	6HJeJoPvrnsH6NG
X-Received: by 2002:a17:90b:2f4b:b0:3ac:a7ee:6772 with SMTP id 98e67ed59e1d1-3aca7ef2df5mr3692992a91.63.1792139308776;
        Fri, 16 Oct 2026 01:28:28 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc48f19d9sm3088933a91.11.2026.10.16.01.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 01:28:28 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v4 0/3] scsi: bfa: bound the unsolicited frame receive path
Date: Fri, 16 Oct 2026 17:28:15 +0900
Message-ID: <20261016082818.1237059-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Three fixes in the bfa unsolicited frame receive path. Together they close
the length the path trusts, from where it enters to where it is used.

 1  uf_recv() takes the received length straight from the firmware's
    completion message and only warns if it is below sizeof(struct
    fchs_s). It is a 16-bit field and nothing caps it at the buffer that
    was posted, so every consumer below can be handed a length larger
    than the frame. The worst of them is bfa_fcs_lport_echo(), which uses
    it as a memcpy size into the fcxp request payload buffer, so that one
    is an out-of-bounds write and not just a read. Cap the length at the
    buffer that was posted.
 2  bfa_fcs_uf_recv() steps over a virtual fabric tagging header without
    checking that the frame is long enough to hold it. The length is a
    u16, so a frame too short for its own VFT header wraps it. Drop such
    a frame, the way the block above it drops a frame with an unknown
    virtual fabric id.
 3  bfa_fcs_lport_scn_process_rscn() is handed that length and ignores it,
    taking the number of RSCN events to walk from the peer's payload
    length field alone. Bound the walk by the received frame length, and
    reject a payload length below the RSCN header it is measured from.

Patch 1 is the source and patches 2 and 3 are two of the sinks; each
stands on its own, and 1 is first because it is the one that makes the
length the others use meaningful.

None of this is tested on hardware; I have no Brocade adapter. All three
were driven through a KUnit harness on a KASAN kernel that injects a frame
completion into uf_recv(), a frame into bfa_fcs_uf_recv(), and frames into
the RSCN and ECHO handlers directly. Without patch 1 a reported length of
2400 reaches bfa_fcs_lport_echo() and its memcpy runs 72 bytes past the
2304-byte request buffer; with it the length is capped at the posted
buffer and a normal frame of FC_MAX_PDUSZ passes through untouched.
Without patch 2 a six-byte VFT-tagged frame hands the FCS a length of
65534. Without patch 3 an RSCN whose payload length exceeds the frame
reads past the frame buffer. With all three, a legitimate RSCN, including
one that fills the frame exactly, parses unchanged.

v4: adds the missing cap on the frame length itself in uf_recv(); v3
    bounded the RSCN walk and the VFT underflow but still trusted a
    firmware-reported length that bfa_fcs_lport_echo() uses to drive an
    out-of-bounds memcpy.
v3: added the VFT-header length underflow guard.
v2: bound the RSCN walk by the received frame length only (dropped a
    buffer-capacity term that did not account for the VFT header offset);
    reject payloads shorter than the RSCN header.

Yehyeong Lee (3):
  scsi: bfa: clamp the received unsolicited frame length to the buffer
  scsi: bfa: drop unsolicited frames shorter than their VFT header
  scsi: bfa: bound the RSCN event list by the received frame length

 drivers/scsi/bfa/bfa_fcs.c       |  5 +++++
 drivers/scsi/bfa/bfa_fcs_lport.c | 19 +++++++++++++++----
 drivers/scsi/bfa/bfa_svc.c       |  2 +-
 3 files changed, 21 insertions(+), 5 deletions(-)


base-commit: 2f2f7eeef8b0a1a9b9ca998231419873ccae8d4e
-- 
2.43.0

