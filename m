Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC2223D7DC
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792025857; cv=none; b=Ly/rHscBoDvjl9pgPMEUGUaW98XZ6/zoetjxSmI8e4i+c02+NRTcRc+np/rqtF3jJIYunLLfZnI8XyT/iAny3PNhden596frZOsU7F4rIBaoJibm2EDXLra4nwa+YiRoLI9Max1gO0fcGVxNjNS9tQuQquZy04iFz7GuBFjlwuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792025857; c=relaxed/simple;
	bh=+3i7Wp7Gn/4DZGvC1EVgE1GhLA3S8VEmkTXIlU2Cf/U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hU3iJYNhHhvnsfrQUpYyFtGlLLJi6Q9DSwJXFqPdnR6QmsJFhwEyqt9akwOpkuqjkXAGYJJClZ94XSupKAMhy6hDZCY8SxuJ4U7aBEcFf2ZcUoLQDT/FzTR3iAd9g+XcK8EfA1iF/sKKxVpvi6oOcSHhb4Ep6RfWKph0IWU29Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=NRJxcOOp; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="NRJxcOOp"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc4aa0246b7so2161359a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 17:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792025853; x=1792630653; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zt7nr09wwJI5ybhKtyoQzAr8Sit4cQO0NLg28SvC2Y4=;
        b=NRJxcOOpuogDdeeZmosRTOvDihxDEgGXD0dkWSNcPVASYUGnB0V1mcd6k7HRKuEJH7
         AvCTiJR4Bm97Gm4S4r538vqPzL7AwA72qULTAauA0eUDJwsj88KkE0cuWpjP9VBfJWux
         kq2lfzvYv8uy0UBWFQDZdNzp/mlEG6QJs1eX3p/0wyCoNclm57bdYKUNM+wuajJrfSh8
         bjlxRaUe8MrO+WXTNiuhY9hZaBQI2zLNKVoY188YT9TCDR6tTUQx5SfgK0tvCI5iLKhN
         aEWG2SfZJDlRNv8wpNHGt4TqElE7U2PWobr5/VMZ2SAF1ICExiq4tFVRxJ+iUHvonqUn
         O6Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792025853; x=1792630653;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zt7nr09wwJI5ybhKtyoQzAr8Sit4cQO0NLg28SvC2Y4=;
        b=HMCv4LR0EqoGY4ibUw/vmjQg2xEZH0zyRzKdnvBwlGlflkmBYLWI1/Z31XkX1JGkcT
         c6c4aByyJM0b5eJhP88aq55mv+mRW0uQDJsZ5Y+hBQhNBNDjdLgQJcerVU7RAsLN+ec9
         9ldJ4axrADUn3uDovTqpavd0a2LAJhf372VBj1GnQDpJhtZdlSw54XI9aRQp+TncSwsY
         L/zOGycU9Y+fFYReXvxRjfP5u/rnphKAkyNIHya+lwyExSmFKaEwINHoKALP6LIAJuRl
         UEbFDeTIOg7uArLLQcDneoAnHb3XAS8MbcONTe+m9ji4HnF5en7B7xXgQbUcdjVkeVDM
         W7OA==
X-Gm-Message-State: AFq9FYI2drGa5d+wMWmEmHrvdz3G/RvJm4NkT/J2cWLtO/707Xvttj8C
	TEPXcWDamlonS/GNgh67B22b5RtU9B9rk281Hp0tvfP2lfDAjEMWh+7vOnT/Gc1CSJ8=
X-Gm-Gg: AYBFou0JamMbGr1U73sNPMNdZDVhqW6hlJftp9qxreMbsXu2yqCLylZqafGnVp5rYBb
	HknmaZlneaFC8eZxTrvqmMNTiMEfERlt204GjK4jzJDMirl6WUsoCyyM3l8ZB1GqmrGbCNaEuC1
	Kfjk5KYdKL1MiFAc7cXw79GYxY/0pFlzUw8Ruzs9wwFOjxRUU3KXKXWTdDyl/mycqKqOg8cBFJA
	P7uzoJ/Xx2iR8uf815R6QPPu3It23D7N6BrvP8TUzlLSpfApHL/yupcrfaBMeGvvmTDTlIGXES/
	tPO4PH8DpNCZfCj1mFbaVMlzOH0aDcFiGVcahaO++hILwuo0TIAYjlCC/XRpbDpXNufWtAA0RBG
	uI0wJHdAdKU0ZZScmbqnqNMUzSL7YnL8TyonOZhho8dOeovyrvZgNkbnjZxy8SdCovFiffLUf9W
	EDqBnmtlrGUyvw9HRxCogplQuyHCXpPR8K4XX7lItt2s6xzr+92Ym0g1o6KiSqPdhBhK+C3KkzH
	LEH7A==
X-Received: by 2002:a17:90b:2b48:b0:3a0:4146:295b with SMTP id 98e67ed59e1d1-3ab3a90e8c1mr12250770a91.17.1792025853163;
        Wed, 14 Oct 2026 17:57:33 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac92a43d98sm999198a91.0.2026.10.14.17.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 17:57:32 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v7 0/7] scsi: mvumi: bound the values the firmware supplies
Date: Thu, 15 Oct 2026 09:57:10 +0900
Message-ID: <20261015005717.3719956-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This supersedes

  [PATCH v6 0/5] scsi: mvumi: bound the values the firmware supplies
  <20261014162413.3649841-1-yhlee@isslab.korea.ac.kr>

which can be dropped.

Everything the firmware writes reaches the driver either through the
handshake page, through the event buffer, or through a response frame in
the outbound list.  The patches follow that split, with one at the end that
is unrelated:

 1  event buffer: param_count and sense_data_length index fixed arrays in
    mvumi_show_event().
 2  handshake page: frame_length drives the checksum walk, whose counter is
    an unsigned char, so 256 or more never terminates.
 3  event buffer: the hotplug bitmap size drives two walks with nothing
    holding it inside what the firmware was asked for.
 4  event buffer: those walks cast a four-byte-aligned bitmap to
    unsigned long *.
 5  handshake page: the entry sizes and max_io size three allocations, the
    list depth drives the ring index, the device count has to fit the byte
    mvumi_build_frame() gives it, a reset reports all of them again without
    reallocating anything, and every field is read once.
 6  response frame: the tag indexes tag_cmd[], and the value that is
    checked and the value that is used are separate fetches of
    firmware-writable memory.
 7  unrelated to the above: mvumi_delete_internal_cmd() rebuilds a DMA
    address with a shift that evaluates to zero.

I have no mvumi hardware, so none of this is tested on a controller.  Each
patch's reasoning is from the source, and I modelled the arithmetic, the
loop bounds, the index ranges and the bit numbering of every case in
userspace, including the values that should still be accepted.

One thing in mvumi_proc_msg() I could not settle and did not touch: the
second bitmap starts at param->bitmap[size >> 3].  If the firmware packs
the two bitmaps back to back with no padding, bit 0 of the second one is at
bit size % 8 of that byte, and the code reads it as bit 0.  If instead each
bitmap starts on a byte boundary, the second one starts at
DIV_ROUND_UP(size, 8) and the code is a byte early.  Either way the code is
only self-consistent when size is a multiple of 8, and I found nothing in
the tree that says which layout the firmware uses -- no documentation, no
MAINTAINERS entry, and this is the only place in the kernel with this
shape.  Rather than guess I left it, and patch 4 keeps the existing
numbering exactly.

v7:
- patch 5 reads every field of the handshake page with READ_ONCE(), not
  just the three shift counts, so a rematerialized load cannot slip a
  device count above 255 past the bound that rejects it.
- patch 6 re-checks request_id against the command the copied tag selects,
  where the controller provides one.  A tag changed between the check and
  the copy can land on a different live command, and then only request_id
  tells the two apart.
- new patch 4: walk the hotplug bitmap a byte at a time instead of casting
  it to unsigned long *, which the four-byte bitmap offset does not align.
- new patch 7: mvumi_delete_internal_cmd() shifted a u32 by 16 twice, so
  the upper half of the buffer address was dropped before
  dma_free_coherent() saw it.
- patches 1, 2 and 3 are unchanged.

Yehyeong Lee (7):
  scsi: mvumi: bound the per-event parameter and sense dumps
  scsi: mvumi: reject an out-of-range handshake frame length
  scsi: mvumi: bound the hotplug event bitmap
  scsi: mvumi: walk the hotplug event bitmap a byte at a time
  scsi: mvumi: reject handshake sizes that overflow the list allocations
  scsi: mvumi: validate the response frame tag before using it
  scsi: mvumi: fix the DMA address rebuilt in
    mvumi_delete_internal_cmd()

 drivers/scsi/mvumi.c | 238 ++++++++++++++++++++++++++++++++++---------
 drivers/scsi/mvumi.h |   9 ++
 2 files changed, 197 insertions(+), 50 deletions(-)


base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.43.0

