Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F3E4DDB5D
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 15:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792166102; cv=none; b=V9Sy7yabpTgAK+mTt3OKdMDL53bk+3c9arKS6tzJTFL+lQtYVO7P5/v4If28TgiXl8SQSCwvNPTJ3eTuXr902fuOWkh7SeaoE6ZjjAbkayzX6da1PIjsXUhjffd6X2nEevYl0CCBuNJ56xWnHCDwIYQvJRUoheCmReVLjzatoAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792166102; c=relaxed/simple;
	bh=gRgnv/IQevsZYfLRzxg/t0DGc8i+gZbRxYZVCMqrshM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JxVCMoo9VbQ8XfAZsVZSr22cmn5mp39uv2iR30h8IvOS6tVHfKZIPLqGzZHfJ4F6ZYSYFlB6h535Ey29da4mhm2DO24Lrildkar6gQ+Yr21Zm6aptexXH87JvXYdLZwUQhwcYxmg7e1TL+b7leMScwxG8apJJkvDEa7fhou4sgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=Sclj/08e; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="Sclj/08e"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cc502d509c0so65623a12.2
        for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 08:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792166099; x=1792770899; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=57L18zSrRFWSsLpFFSYCwnP86s5rXFtM+UU5HcWFB08=;
        b=Sclj/08eUXYS9Hyr6GXzjS5KN+ssTfEzFeNA44weFUQhWlulBiCtGpeacHwotq3BG+
         H0gCmDusZHZcZUzazoYbzcsfz5tnpPJQvGvTkFEPQ0dXVEVxILai6pY/76EIe0WmBc7E
         ZVO+X99dDmhzn/P5E+aFXYjI0QedSNmHHTR7SLKSFO9aOAbJ+wBAaZPwppRPk+F4a5M5
         2PN7dIspPzJIxq5/lzCEJ7vYLnj2LvtTgW51A+kkPBdA2QN6qRKNrv5VZLf4oWypaxZr
         aEaErrgkCfhMQl0vMJbVuXTVyMFE7DKWitmSqZB7fm3R8CdYNVqB5+tIKJ31gosu8KQp
         ZifQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792166099; x=1792770899;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=57L18zSrRFWSsLpFFSYCwnP86s5rXFtM+UU5HcWFB08=;
        b=1TWVtjWg3wmDFjeKzim6eAGx91mczaG7X8cSR2Hev2beb54sklK9VlSCCFlH54LYuX
         vSrxKICEPgWOsnKzhgx2e13afWOHM3oHi7D/ziqlCEg3Zq8+SlRjRoDeRKkIsr+uWegy
         voQf2A3uOoluCxXgQuUg6htY+vEvFLow/ViulN29aAB01v2iTHGCnGEKiwCBd3KwhlUp
         pRUy7kTVZ2BMglcnfQbD440tfoS1Brse+OxbBlbJ/fntkEV8FcpQO9Tvx/g7JXdBJvjK
         afQBGy6ROeAC8bZs2XgNaGl7DkKhG5LXGIy1ADPyXpo4rPpYKscFlxcm/iL4DiaF4H4h
         rlKA==
X-Gm-Message-State: AFq9FYIVBLywznjmdwiAqt4Jonm+uvAJna+z3xqMTGDBTLs4hUDmSMw7
	9IqnixYGgR/YtQbSvJM3OfrJYTWs+xwQyjGZJ1781T8itCM/iNcxRX74v5nbPEM+Pt+gQxnnm9T
	BXUfj
X-Gm-Gg: AYBFou27B5oVw6o4pBbPoXZgupDDMXbDzRCH0ROS/uvE1Zl3vdRiWceKV1T7lBDjKpu
	T8GErLxUbdtP8I2wHGwrcKDDXSJ9fCJd3H6myndXcPMh/Z1vlRiBKADxmf1tP/4xPYoADxobFmm
	F2mzDyHCWd45ibjPnig9svGelp9mxDd1LllMTdzlzoCbFCyn4dO++GOu7ZWvHtFFtVesMaju0LR
	qeVSaCjg8qrhWfFgTvMvo8Xp9vEQc8tZhoATZOIIEFNnmmu+6e+8EMtm3aJcMMfFvva5j24xNKr
	FvP/yAaX6UBS018pH2F+/oFBTKiuyiAddnHaRZenT/kkwGEZOm09JSZ07cj4HqK9E8pbU2GqL9+
	TtVuW6yVXE2mN6iBzdqsJrzVZvvr40oM0TmQBTUhJEcyFIoGwLSHRuR6DmH56PJ/Z5uyhgEGFCg
	auDEeF/Y9c4CfVQ0/N70fQFVMXPWFTkixFHd+W+0rqGEw+Cvuc67KVQ5ZkG5vKxXg+9Xe5NQ84X
	BVpN3jS2+bVqqskEBzvng==
X-Received: by 2002:a05:6a21:7a8b:b0:3e0:b7c7:5289 with SMTP id adf61e73a8af0-3e16bf12fb2mr20162868637.63.1792166099216;
        Fri, 16 Oct 2026 08:54:59 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:5e7a:332f:f584:a3d8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd65ab63cadsm983076a12.4.2026.10.16.08.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 08:54:58 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v5 0/3] scsi: bfa: bound the unsolicited frame receive path
Date: Sat, 17 Oct 2026 00:54:38 +0900
Message-ID: <20261016155441.1607196-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Three fixes in the bfa unsolicited frame receive path. Together they bound
the length the path trusts, at both ends, from where it enters to where it
is used.

 1  uf_recv() takes the received length straight from the firmware's
    completion message and only warns if it is below sizeof(struct
    fchs_s). It is a 16-bit field and nothing caps it at the buffer that
    was posted, so every consumer below can be handed a length larger
    than the frame. The worst of them is bfa_fcs_lport_echo(), which uses
    it as a memcpy size into the fcxp request payload buffer, so that one
    is an out-of-bounds write and not just a read. Cap the length at the
    buffer that was posted.
 2  bfa_fcs_uf_recv() does not check the frame against the headers it has
    to hold. Below the FC header, bfa_fcs_lport_echo() computes a negative
    payload length and hands it to bfa_fcxp_send(), whose reqlen is a u32,
    so a six-byte frame asks the firmware to send about four gigabytes
    from the request payload address. Below the virtual fabric tagging
    header it advertises, stepping over that header wraps the length.
    Drop both, the way the function already drops a frame whose virtual
    fabric id is unknown.
 3  bfa_fcs_lport_scn_process_rscn() is handed that length and ignores it,
    taking the number of RSCN events to walk from the peer's payload
    length field alone. Bound the walk by the received frame length, and
    reject a payload length below the RSCN header it is measured from.

Patches 1 and 2 are the source and patch 3 is one of the sinks; each
stands on its own, and the first two come first because they are what
makes the length the third uses meaningful. With both, every consumer
sees a length between the FC header and the posted buffer.

None of this is tested on hardware; I have no Brocade adapter. All three
were driven through a KUnit harness on a KASAN kernel that injects a frame
completion into uf_recv(), a frame into bfa_fcs_uf_recv(), and frames into
the RSCN and ECHO handlers directly. Without patch 1 a reported length of
2400 reaches bfa_fcs_lport_echo() and its memcpy runs 72 bytes past the
2304-byte request buffer. Without patch 2 a six-byte frame reaches the
same handler and leaves 4294967278 in the request length it hands the
firmware, and a six-byte tagged frame hands the FCS a length of 65534.
Without patch 3 an RSCN whose payload length exceeds the frame reads past
the frame buffer. With all three, a header-only frame of 24 bytes, a frame
of FC_MAX_PDUSZ and a legitimate RSCN, including one that fills the frame
exactly, are all unaffected.

v5: also drop frames shorter than the mandatory FC header in
    bfa_fcs_uf_recv(), closing a pre-existing lower-bound underflow that
    reaches bfa_fcs_lport_echo().
v4: added the cap on the frame length itself in uf_recv(); v3 bounded the
    RSCN walk and the VFT underflow but still trusted a firmware-reported
    length that bfa_fcs_lport_echo() uses to drive an out-of-bounds
    memcpy.
v3: added the VFT-header length underflow guard.
v2: bound the RSCN walk by the received frame length only (dropped a
    buffer-capacity term that did not account for the VFT header offset);
    reject payloads shorter than the RSCN header.

Yehyeong Lee (3):
  scsi: bfa: clamp the received unsolicited frame length to the buffer
  scsi: bfa: drop unsolicited frames shorter than the headers they must
    hold
  scsi: bfa: bound the RSCN event list by the received frame length

 drivers/scsi/bfa/bfa_fcs.c       | 15 ++++++++++++++-
 drivers/scsi/bfa/bfa_fcs_lport.c | 19 +++++++++++++++----
 drivers/scsi/bfa/bfa_svc.c       |  2 +-
 3 files changed, 30 insertions(+), 6 deletions(-)


base-commit: 2f2f7eeef8b0a1a9b9ca998231419873ccae8d4e
-- 
2.43.0

