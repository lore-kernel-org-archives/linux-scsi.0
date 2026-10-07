Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839CF1419A4
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 01:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338342; cv=none; b=REX05Lc5jZaddl+8BR4x6ZO/50pgZGaZcsm1mmLzfIqlwZ3zobmS2XH2hPYkAR3IbM9gpVUF4fwmF/2coZ3KUXmDRlZhqgIo1dnWMo1ZH2g43JPJEn1NqBv1GSgtllKo7PenfeQmE5lmsmYE5gDgaCNPKTHRqit2OK0s+VgCk5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338342; c=relaxed/simple;
	bh=tIf7W/nmwCnVM6ETQa2lhEAO1QAfidKAfvPq+tKiN6s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RjZlIR7zU7h5Tudeg0ohmxGkhsqYBRvm7XbaQIYOTYwoNEqEzZ8ucBDgBzP3YEYwF0vdxovoKJ9F5DRJlQXP8DfdsPDZ81+3W1QCRKkflvNmCgDSQrWHRFT1YyCKqAQTEBPtFc5tAHvR86gozO2zNYmZfq3IyuPMcOnGwCIXlDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=TbL3ixa0; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="TbL3ixa0"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3a7fecf8440so794130a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 18:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791338339; x=1791943139; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Aape3rD0A/9PXmNWnZ4pikvp5foPOWk9ZifQ2/EdnJE=;
        b=TbL3ixa0GOzssLiUDsuHM1KjWVWWfVdn6LAZLkGPnuwofPv2+czg5p+QNterfzvTX9
         8Bxhv91I4ZLC7TPZKjjeH9dNjCWGztmu42WL3a6SBOkjpe4fRdTNMQzABe28WAmrh4g8
         +cUAvL3v5+ggYW1dO250k/o21NioXvT9QEaBWOPsgf3X1hYHvvym+VPUm+tSdhghSOA7
         VoXjQ7oh9REBKxEngS0Xbu64CYxU/sfMLu8EA9GVJnWJ3eM62m33zyw3LFQOPE8rFrZN
         ymF858rX3P/wTMHCmneo3+qw0X3I658VJuB7GlTkjI+cYklMvYNGV8a2AtiLMTtGa+VY
         LjsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791338339; x=1791943139;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Aape3rD0A/9PXmNWnZ4pikvp5foPOWk9ZifQ2/EdnJE=;
        b=hPlpgC9KX/WQBBWgUCBXBbU5/J7oI2HDmLoM8KoGOMSI7EyLjYQtw7Rgy2cFdh/x7S
         SSLvo1a0dIiAG100y4qiOVk/RWZy32/z4k5QXQZHo9zcdLhblG4ONfmsGlJlrP1KVtTJ
         NSSBPM4PgC3BS2nDt0Ii1cT0+RwSrgGsILYU1BcztV6JQjwhp3AQuaz/+9Bb2jH8QTml
         RLUMYGB5yAmC9mvfvWztXOaet9jki85x8lTs1m/GS2RaVamz2qEvfcSpbgkrLhjdhQc6
         LpCEpxuyy5GCJg9bN23SKrkCWXhT3hrKBn6rdZeGTjgotCuzaNNNuP57xpHsCfcmQY4s
         emkw==
X-Gm-Message-State: AFq9FYLqc5bjqKgJdkXRYzOJg+QKeuBKG66TbS4vwB8lznrRlg4INgQL
	WR3GOdCSu0pTxyB9tIeR4Cte7xYDdrIHgEeZqImUOcCYM+vpkbNDD/yVoLBFXwzDjVk=
X-Gm-Gg: AYBFou3ANvXESC4b/m8nWX8QCht2eTC71OCa0Emazg9sU+cBdTNA51dqxOs5D+31Ox5
	ve6Qhs1GW06/tvczyikwLGDLKiBrkraqTjuMzh8JMNC7xflhVsjlN2RCVdt6ZLdd6gqFt6YfGRZ
	TeL8dlvmt5B2X87rx42uMT/MRBAmcvTp9h3FtPx1uKChzx8vs/tTlcQ08I46PPsnC3aZ8UVAAR2
	EkwK0huNA8PM8mcG8RsDSkeXiKLImuBaVcZFw/Bj2s361IT8WkT9Ta8BLCkUcToXkJtoqVJVe1y
	Pp0J0BE3Fh8ALK6f5O+QpaUMrapeTYAWVa3VeuhAj6ZUYUcO7dx98cWKmHF2yqyQe57zTbAvah1
	oB4vPVDC9HZsfGhq+iugZLXwzYCpSHZazDV4FchsSBjqXC50wN2LmDqWsiba4ziv8eN5Ilo2XQT
	odwfIyJNSUW0Df+Ey4klZequZ1kgf1ZyNcVhqxJRkiogo92eBLCM0L49Ay/NouoXMOh95EsQwbE
	CzkXw==
X-Received: by 2002:a17:90b:4a88:b0:39e:6a7e:ee1b with SMTP id 98e67ed59e1d1-3a8a1b057famr728367a91.39.1791338338188;
        Tue, 06 Oct 2026 18:58:58 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8543e8478sm8777205a91.17.2026.10.06.18.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 18:58:57 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: michael.christie@oracle.com,
	martin.petersen@oracle.com,
	lduncan@suse.com,
	cleech@redhat.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v3 0/3] scsi: libiscsi: validate task lookups driven by target-supplied ITTs
Date: Wed,  7 Oct 2026 10:58:39 +0900
Message-ID: <20261007015842.634893-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Three places where an ITT taken from a target-supplied PDU reaches a task
without being checked. Each is reachable from the wire with one injected
PDU and each is independently useful, but they share one lookup helper so
they are sent together.

1/3 bounds the index from below. A transport that implements
parse_pdu_itt can produce a negative one; be2iscsi does, and forwards an
unsolicited NOP-In from the hardware with the target's ITT intact. I
have no be2iscsi hardware, so this one is argued from source.

2/3 is the ITT reflected in a Reject PDU.

3/3 is the same defect at the lookup that five management responses
share. An unsolicited NOP-In naming an unused index dereferences a NULL
task->conn; a Text Response with the same ITT crashes a little later in
iscsi_complete_task().

Measured on 7.2-rc5 with KASAN over a proxy that injects one PDU. Five
attack shapes oops or warn unpatched and none of them do with the
series. Normal I/O, an abort TMF, a rejected NOP-Out ping, a userspace
nop sent over netlink and an iscsid-driven session are unchanged.

v3: 2/3 - initialise task at its declaration per Mike Christie's review.
    No functional change: the .text of libiscsi.o is byte-identical
    before and after. Picked up Mike Christie's Reviewed-by on all three
    patches.
v2: https://lore.kernel.org/all/20260804040546.2264137-1-yhlee@isslab.korea.ac.kr/
v1: https://lore.kernel.org/all/20260803104149.2114414-1-yhlee@isslab.korea.ac.kr/

Yehyeong Lee (3):
  scsi: libiscsi: reject a negative task index from parse_pdu_itt
  scsi: libiscsi: validate the ITT reflected in a Reject PDU
  scsi: libiscsi: validate the task named by a management response

 drivers/scsi/libiscsi.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
2.43.0

