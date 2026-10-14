Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A122552F291
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 15:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791991172; cv=none; b=K8xl+BRZR42WAZA11B7Rf7tyWEGE0Lj21JAf+l9ZKWFcm7iuQnr2ioTnKwrE2OVZwaVDWwJEnF7Mq8i+F1Bzp+OTgfepDpjQRqFzpD8KOEOIc3V0eAXD0EF6XmWka+18jti9eeBo5lCU83Z0mM1NspwHdF8w2sNYYQpyWhgw+EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791991172; c=relaxed/simple;
	bh=IFyaKeG8PqcZmLWzpXkqwho5yu30vxmgLPrGWSAnX+s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oF8QnGCLL8nwYu37wWxHsGEvbxiIi+ba4bccFIi4TTV0dlZXnyRzrpyHPGFr09urIN7CL4KYX6Ju6Rw37EvzNFOrcQBFPSKksWNH/62mfNa4AAWRgQ9bR1gMMsl0ahwZFenoSiPgmpm7Lk5tHm/XBHogLItEM68SVYlcmbGBh6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=QQEf+RdE; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="QQEf+RdE"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3ab60ff4273so3548858a91.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 08:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791991169; x=1792595969; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=srFWpE+TVCETelKCcIQxO8OekNsEmjBOESyjztjbwL0=;
        b=QQEf+RdEyeOZ39t8l7ub8jwhe/seu1fPHTnXH7NSaazUSTElQC7ErzsJz9uYchSKeD
         9o2pctw9prhtviu2ZFUL5pyqKS7Ve//Tt/pfg56pW5mGJTxB6YbYD/58X3ZZCgDCWsgQ
         99DXuz1APdPiyXjxX665vpdWJOfX+YkGWIWVFH1XqJ23poL21pDb0hHbRM5eEM5Aq6X8
         635UuRa+exUDQxNG0wtfO0CbIAy2yAy8kr15KyHbomQf6ym5otZlIXHyC15217i72iOq
         R7nDqMICimvb71VvZJD6X/5TIXd7F4jAOSDswaH75dLQvSkqTEpR6usMj6m0BUZ+quTG
         Hfaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791991169; x=1792595969;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=srFWpE+TVCETelKCcIQxO8OekNsEmjBOESyjztjbwL0=;
        b=d7gL7ULqZK5DE+ezzrT4NAa2rb43J600VTVc2iCLK96LBnvXR2YjaMDH3o9V4rmIlY
         zIkHhEtMSXbVkR4Sb8m81ZGgm3LT98wI3C42h+TpW3nUNC8aEydvJCYziCTCFm8+XQEO
         dWPSzelC+Nv0IQF+GPY37FD3AiPm0gwrnyD/JoybMbWQscq6w+XCrn9NHndDpLrqszAA
         hyYS9vbYFAS2LDoVjacQgnMcgHjPn3jWhe4LC/EQ2KH7yD9oO1OM4ChJD3B+KmIG3cmQ
         x+E8nxoxtPj+pP2tDsGbHsPdhQDraQ3gm4X2MoVDg3wH8nGXPNei6mRW0txLRq5kqKrk
         H1IQ==
X-Gm-Message-State: AFq9FYLX6yP75hud9eYV9RdKt48HEwe+IR//eGVcUJoZvtVen4F+VObu
	KGWhvRtXem5huF5J+qPoRh3OaoMoSZPduc6tgU5eHz0ozUR4pZRGCLQV+ITb9bFIVNA=
X-Gm-Gg: AYBFou2kXTl1E1qN+/Sz4+mBZTATdr8KaWOj7TgXCTi9Qc3ztKacmPipc0tDbm+Ni//
	4yaNvHYC5GZttr4dLebwRIl/3X8201Ls8mzQDJpDc53sgQDj3w1NkZGwEJLqvQQnDFY3iQLsMdd
	F850r9gqS2wnO+jWT1P9U2LZJ2ah3f4Vbi1GRiSserZDMvaAch1CdsEh4UizbyokN2Rmaq4HB0t
	uHFRdlpukMDBXksHOSjrPdEVag856ym0TIpY3gZ9hk1m19eq7SwC8J3dygHvpm+w36ncjGkBXOi
	UlAx/ARYTwd7Zx04u7GPOoDRKcvpA7xFxSAErH7cOhLi7l8yLEpn+BUKjsXHuLokZgVa+W8h2ki
	FzkThZmExtkKCRQQgH/Bf+hLQKcvPYMc66wI25tH6kq12WwgkGZIBPX/bS9O8CK6+jUQrPC28Xu
	g8K1sze1OJo3XW0SpvCaQqfiSyCnjGYJ8XFXiRDPRpf9oH6w6Buy1YlCDg4E2jPQIWOHQHKUAZh
	iUJV7T02552ScEC6bdnEaUjDg2IsT4=
X-Received: by 2002:a17:90b:4b:b0:3ab:1e1c:837f with SMTP id 98e67ed59e1d1-3ab3ac59383mr12662310a91.47.1791991168762;
        Wed, 14 Oct 2026 08:19:28 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:1c49:61ee:8c8:3f4c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac8d40e7f3sm622450a91.5.2026.10.14.08.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 08:19:28 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v5 0/6] scsi: mvumi: bound the values the firmware supplies
Date: Thu, 15 Oct 2026 00:19:08 +0900
Message-ID: <20261014151914.3632701-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This folds the two mvumi series I have on the list into one and adds what a
full pass over the driver's firmware-supplied values turned up.  It
supersedes

  [PATCH v2 0/2] scsi: mvumi: bound two firmware-supplied lengths
  20261013173145.3412863-1-yhlee@isslab.korea.ac.kr

  [PATCH v4] scsi: mvumi: reject handshake sizes that overflow the list
  allocations
  20261014134104.3528958-1-yhlee@isslab.korea.ac.kr

and both of those can be dropped.

Everything the firmware writes reaches the driver either through the
handshake page, through the event buffer, or through a response frame in
the outbound list.  The patches follow that split:

 1  event buffer: param_count and sense_data_length index fixed arrays in
    mvumi_show_event().
 2  handshake page: frame_length drives the checksum walk, whose counter is
    an unsigned char, so 256 or more never terminates.
 3  event buffer: the hotplug bitmap size drives two find_next_zero_bit()
    scans with nothing holding it inside the 512-byte buffer.
 4  handshake page: the entry sizes and max_io size three allocations, the
    list depth drives the ring index, and a reset reports all of them
    again without reallocating anything.
 5  response frame: the tag indexes tag_cmd[], and the value that is
    checked and the value that is used are separate fetches of
    firmware-writable memory.
 6  handshake page: max_devices_support is a u16 and the loop counter
    mvumi_flush_cache() compares it against is an unsigned char.

Patch 6 depends on patch 4 and patch 5 reads better after it, so the order
matters; 1 to 3 are independent.

I have no mvumi hardware, so none of this is tested on a controller.  Each
patch's reasoning is from the source, and I modelled the arithmetic and the
loop bounds of every case in userspace, including the values that should
still be accepted.

v5:
- one series instead of two; supersedes the two above.
- new: bound the hotplug event bitmap (patch 3).
- new: validate the response frame tag (patch 5).
- patch 4 also rejects an entry size too small to hold the frames the
  driver puts in it, which is what made the max_sg subtraction in
  mvumi_io_attach() wrap.
- new: widen the flush cache loop counter (patch 6), which answers the
  review of the v4 posting above.

Yehyeong Lee (6):
  scsi: mvumi: bound the per-event parameter and sense dumps
  scsi: mvumi: reject an out-of-range handshake frame length
  scsi: mvumi: bound the hotplug event bitmap
  scsi: mvumi: reject handshake sizes that overflow the list allocations
  scsi: mvumi: validate the response frame tag before using it
  scsi: mvumi: widen the flush cache loop counter

 drivers/scsi/mvumi.c | 156 +++++++++++++++++++++++++++++++++++--------
 drivers/scsi/mvumi.h |   3 +
 2 files changed, 132 insertions(+), 27 deletions(-)


base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.43.0

