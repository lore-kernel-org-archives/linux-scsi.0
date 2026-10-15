Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA686309EEB
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 02:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792031263; cv=none; b=hxXR0CPjWIuzHxfiTLdMAHUC5R+2StQ1Xi4GQP/hAqaZBlI9YACk5cyQNGQpgaA/MyOyOa3mTQqMkg0RiLEF+DE6kz+f2/oiSzMIqViJrRVLJBUNooZ22DdgoVJzoEzV07SPyozS2qazZnxLGDyZ1vyHFDA9kC72K5xfhCHjC0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792031263; c=relaxed/simple;
	bh=nYxGoAzwf5nT6TeGpoE+Q9Un5MQml7BuZqbPMzMIAPw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EPNGU4vqCrHF7sJhdvCFve/vY5lCH+CFN0V9pMRBX6KOKWeO5xb9kjRiIPQoESQurq8TTE7Hmq2fyyKo9OE9WdgD5+cUr/5VnuWE0zrFnK/51V34w2DA7jei/9qXL14bHKa7tOKX35tRkiid/NWJKtC//n7XwEOOA+rVbSD53qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=PEMq8JiA; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="PEMq8JiA"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cc1bc88a20eso1096409a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 19:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792031261; x=1792636061; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NINcKwru8oEwnBpCOfnCTBGzpeAiP00C28R/M43CONo=;
        b=PEMq8JiA+qqNdiVqeb3hI4q9XUu/8ZFd6imOsv2IhvIDL6qynVOmsSlJeclWYA4HiZ
         1H9cf3HQtwDDhOYcwxPpqBiyYEJHnM0ieSqGEn6NUoJ3FBtcD/05a2mCmuCd8Mva2P0Z
         VBV4GId5VbzPGYikK49bLCmdGnWDQvaPZ1zvidvZvjoitoW8mGwTNVT21kK+j2ZQ9Fy7
         lFQxJ9KW85lr3ydT69E5GmAMfyJY/nsCnHbE0P07YWWhW/j036EmBFCFwO8MlTaaNczo
         ogWVo5gOVg8rEbzt4lDdrSW0yXpxCkiVwDbXmGp1zn89czACx04MBqEkVDFuWY0SrLMC
         E/Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792031261; x=1792636061;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NINcKwru8oEwnBpCOfnCTBGzpeAiP00C28R/M43CONo=;
        b=2RD3ICqygEHNHfvd2RIvuTeqTFvy5FeE41ibtiNJYDozZgdm2EJHo/RE1UNJx0ZYSL
         fzAIigAszFqXLjlsR/ZcZ+cbMb3ER4lzehEG1WIX1yjnIb5oD9u+mqhbF7V8KZSpLDon
         w1UPFZS4UAa1akj+N2gyjLbethOffEPVhliK43ed+ES3TMnWyq2taPp3WjiUQrKqn7Wr
         fZDffdsuMxi8aZk+RfitahpiEnjQqM/03zs895JkqgGQuAjvDpcE300yBQTl2k8nq71R
         uRwmRZ59UhlYC2xqQx9lBXkgoip6L+G4QTz2963IbqZOJQqfNSmbViRomJv7faElXJ7W
         mzdQ==
X-Gm-Message-State: AFq9FYKeI9bnLARZwcqtFUd3TgXoZTPS1hnI2V1JFNvTjaaAma4QROvv
	P6a9iK3tJq7bi3904WO+wWI1ogLcfk+/EMr4V6Jx9d5ImNbNmRXcMDVnwUbcgHS1FkgmuYbTGPC
	SDFHK
X-Gm-Gg: AYBFou2daEyCv1wSCGipRpln4dT6bNGBCTOvs8PbovwvPB/SkZc5dk38/w54KiQcKX/
	8XHFXF/nEgMA0zEh2CZA3Fi5J48xS8Q/ewXWqDEM58BDiBUudHo7kEej9786PBSwJcE1HzIhIgo
	1joGaNQCuhIVOAC9O2vSUuwRrj9iMB4iRcqUXRWqWEj+l3d2/gfo79pjfXZSfqRlVWsjquHgKzu
	V8RInKJrcQHDyDtjQyvTeRfAVgKXXtsCbEmLBX2Ey7uK30I8ux2iloLHi8ZOc82/7MAsX2Znez7
	0KDWkZQJFZ7OnmXgxufbH2g84MsHweFhwne5JxqMB/HMFGf1TMeKLxAspwuvjKTt73tcu/GsjV0
	B/5HbGWT+FC4syAYGpRREsj8JgqFpy/byrCC+0WTARVOm/opJA83tyFSq9szwG/zDKvykaXRRgF
	X+gg5Jm8zF35vgMr3YkE5V8uKPIiLMjQ/vlq9xSp7eNQV5hONbejEvgw3+483oOJFYkMnmr3dVh
	kuBxqc=
X-Received: by 2002:a17:90b:2792:b0:3a8:2c7e:8978 with SMTP id 98e67ed59e1d1-3ab3a9606b2mr17710288a91.16.1792031260871;
        Wed, 14 Oct 2026 19:27:40 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac94375f3fsm1997383a91.4.2026.10.14.19.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 19:27:40 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v8 0/8] scsi: mvumi: bound the values the firmware supplies
Date: Thu, 15 Oct 2026 11:27:20 +0900
Message-ID: <20261015022728.3936714-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This supersedes

  [PATCH v7 0/7] scsi: mvumi: bound the values the firmware supplies
  <20261015005717.3719956-1-yhlee@isslab.korea.ac.kr>

which can be dropped.

Patches 1-7 are unchanged from v7; patch 8 is new.

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
    checked has to be the value that is used.
 7  DMA teardown: the address mvumi_delete_internal_cmd() rebuilds from the
    SGL loses its upper 32 bits.
 8  outbound list: the 0xff the driver stamps over the tag of an entry it
    has consumed is a tag in range once the firmware asks for more than 255
    commands, so a stale entry is no longer turned away.  Stamp 0xffff,
    which is outside the u16 tag range whatever the firmware asks for.

Patch 8 is what the review of v7 6/7 pointed at.  I answered that review
saying I would send it as a follow-up once the series landed; it is small
and self-contained, so it is here instead.

Three other points from that review I am not changing, and why.

Endianness: the driver does no device-to-host endian conversion anywhere,
and these fields are plain u16 used natively throughout (host->max_id =
mhba->max_target_id, tag_pool.size = mhba->max_io).  The new checks read
the same values the driver already consumes, so they follow the existing
convention rather than change it.  Making the driver big-endian-correct
would be a driver-wide __le conversion, which is a separate change.  On a
big-endian build the base driver silently accepts a byte-swapped device
count and scans phantom targets; patch 5 turns that into an explicit probe
failure, so the behaviour there does change.

MV9580 and the per-completion udelay: the unconditional request_id
comparison in mvumi_receive_ob_list_entry() is pre-existing.  Patch 6 wraps
the reads in READ_ONCE(), corrects the > to >=, and localizes the tag; the
comparison itself is unchanged.  The re-check patch 6 adds in the
completion handler is gated by request_id_enabled, matching the gate
already in mvumi_check_ob_frame(), so a controller that leaves the flag
clear is unaffected.

dma_rmb(): the validate-then-memcpy ordering is unchanged from the base.
The ownership handshake is the MMIO copy pointer read with ioread32() in
mvumi_check_ob_list_9143()/_9580(), which already carries the
architecture's read barrier, not the tag.  The driver's own comment says an
entry can be visible "before entry has valid data", so the tag can itself
be stale; ordering the tag read ahead of the payload read would not help,
and a barrier cannot make a payload that has not been written yet arrive.

One more thing I left alone: the second hotplug bitmap starts at
bitmap[size >> 3], which is only self-consistent when size is a multiple of
eight, and nothing in the tree says whether the firmware packs the two
bitmaps bit by bit or aligns the second to a byte.  Either reading makes
the index wrong for a size that is not a multiple of eight, but correcting
it one way breaks the other, so patch 4 keeps the existing numbering
exactly.

I don't have mvumi hardware; these are reasoned from the code, not
reproduced on a controller.

Yehyeong Lee (8):
  scsi: mvumi: bound the per-event parameter and sense dumps
  scsi: mvumi: reject an out-of-range handshake frame length
  scsi: mvumi: bound the hotplug event bitmap
  scsi: mvumi: walk the hotplug event bitmap a byte at a time
  scsi: mvumi: reject handshake sizes that overflow the list allocations
  scsi: mvumi: validate the response frame tag before using it
  scsi: mvumi: fix the DMA address rebuilt in
    mvumi_delete_internal_cmd()
  scsi: mvumi: stamp a consumed outbound list entry out of range

 drivers/scsi/mvumi.c | 240 ++++++++++++++++++++++++++++++++++---------
 drivers/scsi/mvumi.h |  15 +++
 2 files changed, 204 insertions(+), 51 deletions(-)


base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.43.0

