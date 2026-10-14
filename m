Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E3C4EDCC3
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 16:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791995071; cv=none; b=udaCiWQE8mPOCkVrrkpAkrazcGup4Tf7KF5Kr5MBczE1Tr11uPPCWlBXfFQutvBHcB46zBEq/bM+7QFKNmLd5zbGsApU2DPYBzpzUw8zKLpIyW2gYokTdCN2TUJ8lg6gwr7otlPNwBq9QdFuDcglrTIV2ZspCIyo5lspcKDGaws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791995071; c=relaxed/simple;
	bh=8n4C8mBosLA48FlF6AMIfimvRE0ynBaCkwx0/o7tJAE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=guu0NdDyKoriFNCobhZ91JiclH08IhqpZJE4AEQU83aVOeTbS884n9OBA/n6863eUSpDmPgKFcRsFBZ5CGzghwis8t2Ih0W8jhvxksrTr28YPj0dkqKxyXVNTWKyZRH8QF6S6pEICFYSp6nyTx2J0V/EQCs/0TteSJoky+93jJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=Im0Z+n0a; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="Im0Z+n0a"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1419d3416ceso2001249c88.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 09:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791995066; x=1792599866; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7fArNqMcPnfGqJ3AJ98+N2PF0HJ2l/WUFDVFpep1nyk=;
        b=Im0Z+n0ak4tnR3BZtPFUowZT13dL1VkVYpxHrRYVKFugh34SKhLtBf8NJVB3mAt8UE
         4Hz10fmTIwXnznM0Tv9wCpaDvV5dR8TAcizQtCFhygc++eq22J0pEwcPBxc3LmtMSV5w
         pP9JAg0SIDW35nvilHzjcbDMxcImhgj2fR2ws8yZrScxbLE5n8oVV5j5WzhuXbO2qLUj
         T+HJ2E+OfWbucF+bJrzif2LhS4l8UQFm6Fa8CU+VN7SFJBFfz65dVjPMS9hPwpKmenlp
         axlF+NX8f13UV/qOQtyVrqtzbW/svdMi+EVOyonJKZNBbNKMf102/jh7jQgzPLuz9sd6
         /9Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791995066; x=1792599866;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7fArNqMcPnfGqJ3AJ98+N2PF0HJ2l/WUFDVFpep1nyk=;
        b=X99oZdh0scsaN5aaJ45fqQzoiekDywYtPcrktZ/MZXTiaZyu1sNjAvCI16ojZQYy2Y
         Veis/XvjEIgl+VgiD6Jx5seJFXVu8PSFeDucf9UfAV5eQ4ym0MU3ZrJyx4ys0G7Jenog
         +P3XTRYJHC/XcGqsK0YcZaqPbylXEIPgJuDNtol88bBlSFPz/bKoZVU0NelXemiXvKSz
         YuFsq/wnUiCeSYTKJ12FqSN7fRQMQSt7RrPLhNJJzUckCFr9njLtRmC86aHOa7ww7ZJp
         basWw6bxwrWoT1zVAcyFf+KRVZFGR9R66E4imEIDL5xJgi1v+5+rxkz3COjsoh3PS3Eb
         cI/Q==
X-Gm-Message-State: AFq9FYKEFcb55ZZVhkM5f1to3dx2YIT3usi5e3wtNMjxH9pLlnCIUHsD
	ZoR5vwRbP7znS9NXvGWq3JI8snt8q5ViuyNTEvwOpFAKeOzLBhGmjAy5JeGAhfPKdqn64pLiLzT
	Z5wrv
X-Gm-Gg: AYBFou1LydliFZyNTtuvQiFGwrhC85+TQDlhRBBgD1Tjk09xyIZwOTolVLcIZlixmi1
	LNZUQWd6qjKxxEWFZpZBD6ESdQ7Z8rDtc5HLcsWZC+dhGZMMZflrwsx+lUAS8Q0E6B/Gnb91fWG
	/gTQDJcKzDWobctIWdU9XqqXrDfSRo0Mj9cSD96EsVZjTTnEW9m5MiOlwa21mI/miuOwUBUfuSq
	+z/X6xXj5tQDAdMV9uBdel5ndom8zOwoQNiApVDDc6U5DEpi841CJJG3y3eNwZWq1BX+0ThhvqF
	BuGEtq4nJbwtcrOX4RF+/VcB8DT/aInojzDDkaNT5pvcXNBkn+B57M58jnwpASGKGguAKnQhdrN
	BWw8TxtybtNUEWR7OIKqAa/cTipjUjl6qtFbyCiyZY5ENrCdpn2q3R98HD8Ep4tfjggRZBm0Xse
	9TJwG5MO3e4+YEJYq9WEi31Tzk/hIMUWbGaZr8n0fT5nsqhkkKdskK3KwfJQmDfl0VAuMvhPF7Y
	J/WFavYaEKe2v27EZ8M
X-Received: by 2002:a05:701b:2914:b0:174:7d98:fe9b with SMTP id a92af1059eb24-1747d99019bmr11401780c88.22.1791995065997;
        Wed, 14 Oct 2026 09:24:25 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:1c49:61ee:8c8:3f4c])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a1dd57d0sm48816685c88.8.2026.10.14.09.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 09:24:25 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v6 0/5] scsi: mvumi: bound the values the firmware supplies
Date: Thu, 15 Oct 2026 01:24:08 +0900
Message-ID: <20261014162413.3649841-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This supersedes

  [PATCH v5 0/6] scsi: mvumi: bound the values the firmware supplies
  <20261014151914.3632701-1-yhlee@isslab.korea.ac.kr>

which can be dropped, and with it the two threads v5 already replaced:

  [PATCH v2 0/2] scsi: mvumi: bound two firmware-supplied lengths
  <20261013173145.3412863-1-yhlee@isslab.korea.ac.kr>

  [PATCH v4] scsi: mvumi: reject handshake sizes that overflow the list
  allocations
  <20261014134104.3528958-1-yhlee@isslab.korea.ac.kr>

Five patches instead of six: the widening of the mvumi_flush_cache() loop
counter is gone, replaced by a bound on the device count in the handshake
patch, and I owe a correction on v5 4/6 (below).

Everything the firmware writes reaches the driver either through the
handshake page, through the event buffer, or through a response frame in
the outbound list.  The patches follow that split:

 1  event buffer: param_count and sense_data_length index fixed arrays in
    mvumi_show_event().
 2  handshake page: frame_length drives the checksum walk, whose counter is
    an unsigned char, so 256 or more never terminates.
 3  event buffer: the hotplug bitmap size drives two find_next_zero_bit()
    scans with nothing holding it inside what the firmware was asked for.
 4  handshake page: the entry sizes and max_io size three allocations, the
    list depth drives the ring index, the device count has to fit the byte
    mvumi_build_frame() gives it, and a reset reports all of them again
    without reallocating anything.
 5  response frame: the tag indexes tag_cmd[], and the value that is
    checked and the value that is used are separate fetches of
    firmware-writable memory.

I have no mvumi hardware, so none of this is tested on a controller.  Each
patch's reasoning is from the source, and I modelled the arithmetic, the
loop bounds and the index ranges of every case in userspace, including the
values that should still be accepted.

A correction on v5 4/6: its commit message said it rejected an entry size
too small to hold the frames the driver puts in the entry.  The code did
not -- I lost that hunk before posting and did not catch it.  Patch 4 here
carries both the check and that wording.

v6:
- 4/6 "widen the flush cache loop counter" is dropped.  Patch 4 instead
  rejects a device count above 255, which is what mvumi_build_frame() can
  address: it packs the target id into the low byte of device_id and the
  LUN into the high byte, so a target of 256 or more aliases another
  device's LUN.  The same bound is what keeps the unsigned char counter in
  mvumi_flush_cache() terminating, so that loop needs no change.  This
  replaces what I wrote in reply to the v4 review, that rejecting such a
  count would turn away a working configuration -- it would not, the frame
  layout cannot address those targets at all.
- patch 4 regains the entry-size minimum described above.
- patch 3 bounds the bitmap by sizeof(struct mvumi_event_req), the length
  the driver puts in data_transfer_length, instead of by the 512-byte
  buffer.  dma_alloc_coherent() returns zeroed memory and a zero bit means
  a device is present, so the bytes past what the firmware wrote would be
  read as devices that do not exist.
- patch 5 uses READ_ONCE() for the tag and request_id it takes out of the
  outbound list, and patch 4 does the same for the three shift counts it
  takes out of the handshake page, matching patches 2 and 3.  Checking one
  fetch of a shift count and shifting by another is how a device gets past
  the bound those checks exist for.
- patches 1 and 2 are unchanged.

Yehyeong Lee (5):
  scsi: mvumi: bound the per-event parameter and sense dumps
  scsi: mvumi: reject an out-of-range handshake frame length
  scsi: mvumi: bound the hotplug event bitmap
  scsi: mvumi: reject handshake sizes that overflow the list allocations
  scsi: mvumi: validate the response frame tag before using it

 drivers/scsi/mvumi.c | 187 ++++++++++++++++++++++++++++++++++++-------
 drivers/scsi/mvumi.h |   9 +++
 2 files changed, 168 insertions(+), 28 deletions(-)


base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.43.0

