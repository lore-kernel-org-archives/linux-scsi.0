Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADFE3BE174
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 09:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791279264; cv=none; b=S4M8KK5lic8g9sNvAjv2EPoTctzyOqJP7zsw/hdAMDnsi/LK3rzZyn4Q8Kb/BeL3QRGC/rPrgmBYbx96F+S80ExqsbLW/TrbaWqD2FkmyRMuewC/Qk2BHDRtsas0K2VSlvM6OvdYXqhm4aXXEfM2X2O/PkzswYu8ajhwkvVuwRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791279264; c=relaxed/simple;
	bh=sRXARn7rltoKuuBkviV7Rzg2hh6wE9w+qedmvZuYEgE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hFEs49bwso42RqaHxlOYPuI5aG606i5Gtp8wjqdJQGdcZCHoqCMMajF4VEp3s5kkU5lX5NrWEwJOj1B8os17UAcsgRTl5VkAqAF5QqdZtqSwhQL2VC6R3HWhlQftuWJEm6WNl6TlfhKJD+Vt4iHtoRkkiyOAxPuXsNn2fqtF2n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Sp7oTk3q; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sp7oTk3q"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso1883334a91.3
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 02:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791279260; x=1791884060; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FfGw4pZW0aV8/Q7fkT5ZBmOHgIkxnICvN7ym0WNBWHU=;
        b=Sp7oTk3qnC/OLANEJH9A17lWUqR5AH8nokqP7i7qKpv5YfDvsiO+qgakWOamLVSKxH
         IHk2DEJ6NExHsD10EK0Ytyr2yBpNWQNVS2uXPxwoSGSUjHlC4L42rWFnb8JByZX7XIzc
         DVuboT198j1uvXvUNG2+nRPeqjC2FVhXu+B+qXkJAGuQRm8wTJvZgQ8NkmytOBo9656D
         uAQ2A9tZ9ThM7pH9A9NU0OyO0nLPeiHK9kJhW6V/nD3U0Wum/4T0WUIJ4l9KJM8ZtfLW
         Ug/j8Gss42kuDW4Ds4AqkIpP/s6bne6Un85XcrGWLNkmHJ6Qq0pL0lw9hrnsmImH2Z7k
         jc/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791279260; x=1791884060;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FfGw4pZW0aV8/Q7fkT5ZBmOHgIkxnICvN7ym0WNBWHU=;
        b=BGW8MMO2j8XzXBJlgrrmRIn78ySXVp40n39m2VGMt6WWMyG0bKd8dn16iDQ3hScrVS
         OApWKUwEpKBAKINguORg7NmhqG5uekYdVRuSlXpl0TefIC5wFh814PVh/teMpi09u7LA
         giCjwRdFM5Ry5rkc1AQnA1R6IxBQ0/92nNDxJAyVFp1sGmGpkgpppdW2VnCZzvlv4+uP
         xtLgSsiKIKghuubIl2gvhMaxjGv8+kFRsEj1Ffb3lno418fwRrouZ7QfYl2rNlUCx+56
         Bn2MyI1TTu0NuIHMkbNhVdQNb2LgH3ShB/QoH8XP4f/5km6jDfVVa4q1wvHVBePGXZpB
         fDCw==
X-Forwarded-Encrypted: i=1; AKwUvBzSvHSZu+woPVLSgF14hfPpLv7EywYCprhvGJqggnOm91cRZ7YSVytE/jzLkS4B9XWdy3vOKvaxJUQn@vger.kernel.org
X-Gm-Message-State: AFq9FYJfv/CXbf0NC0luh13A6Z9betGjjjmLZnL4sTulWbZrRJTAzKUW
	lgYRim4SDa7nRx+BBKssxxbz7JIvEdBxzIub4VLZVD3oedaSFLq3yEv5
X-Gm-Gg: AYBFou02UctW06SFWPn9Rlin4kz75ri8nB2ZxWa1sFd6f6mQoHNXUSOYE8jk6TRIwtI
	dVqf+xXo07alQQiJEQquxP70DMa0kcmLQfyNpc+mhfQiibnirpp4Gn3DShKnTS8jKEqH1wtbvfM
	v9Hg42Gsl8Hgw1d4HTbBLZBxdeY3BqWnq1IljFdM/70TZXDa/iQ3kE4C5oMOlgvWAHQTldd5s4F
	i6nirIYHpxb6Jd3VyhCQ+Wxu/fiNtYQLbNdFvL330nP4VIeD/jeUWfB1TC0ouoYbM9e/5ZIDJQ5
	7rUkRba6yasBJsxiv+jUmmAf9sxx1VA2lk523eLTbR963hXrmmG9F26aQGxGcvY8+PdJCT5tChE
	PdjsVhhFywTdpFj+gxQhOanE9yo2pibqzSlzAy5n+abGqoJ89FBJijY58zE0Np0FhYbN6M49DP5
	mAIlJRvE+tDH6rqpjEC3tHGR4N0qnC22vunHeAlnwwnMLEQGdOdxcP3zGdeW3Eael07UYUAA==
X-Received: by 2002:a17:90b:164b:b0:3a4:d338:4136 with SMTP id 98e67ed59e1d1-3a78779e4e0mr8312336a91.66.1791279259449;
        Tue, 06 Oct 2026 02:34:19 -0700 (PDT)
Received: from gmail.com ([188.253.12.30])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8543ab76bsm3905277a91.13.2026.10.06.02.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 02:34:19 -0700 (PDT)
From: Jia Jia <physicalmtea@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: Jan Engelhardt <jengelh@inai.de>,
	Hannes Reinecke <hare@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	James Bottomley <James.Bottomley@suse.de>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jia Jia <physicalmtea@gmail.com>
Subject: [PATCH 0/8] scsi: target: keep command bytes inside the sg
Date: Tue,  6 Oct 2026 17:33:30 +0800
Message-Id: <20261006093338.27342-1-physicalmtea@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Eight fixes for target core reading or writing past an sg.  Patches 4
through 6 and patch 8 share the DIF sg walk and apply in order.  The
others stand alone.  vhost-scsi keeps one sg inside one page, so those
bytes land on the next physical page.  The commands reach the host
through a guest virtqueue.

Patch 1 takes the COMPARE AND WRITE write half from its own sg entries.
Adding the compare length to the first entry's offset loses the sg
boundary when the two halves are split across pages.  The replacement
table is released with sg_free_table().

Patch 2 keeps each REPORT REFERRALS LBA store inside the data-in
buffer.  The existing data_length checks cover one-byte fields, not the
eight-byte LBA.

Patch 3 rejects a SET TARGET PORT GROUPS list that ends on a partial
four-byte descriptor.

Patch 4 copies an 8 byte protection tuple across sg entries in
sbc_dif_generate().  A tuple that starts at the end of one entry is
written into the next entry as well.

Patch 5 does the same read in sbc_dif_verify().  A tuple that runs off
the end of the protection list fails the command.  The generate change
does not cover this function.

Patch 6 limits the block CRC in both functions to the bytes each data
sg actually holds.

Patch 7 reads the pscsi MODE SENSE write-protect byte and the tape
MODE SELECT block descriptor from the whole data buffer.  A short
buffer is left unchanged.

Patch 8 makes sbc_dif_verify() advance the data cursor across every sg
entry of a logical block whose application tag is 0xffff.  The cursor
uses the same kmap_local_page() calls as the CRC walk.

Jia Jia (8):
  scsi: target: take COMPARE AND WRITE data from the write half
  scsi: target: keep REPORT REFERRALS stores inside the buffer
  scsi: target: reject a short SET TARGET PORT GROUPS list
  scsi: target: copy a DIF insert tuple across prot sgs
  scsi: target: copy a DIF verify tuple across prot sgs
  scsi: target: limit DIF block CRC to each data sg
  scsi: target: keep pscsi mode bytes inside the data sgs
  scsi: target: skip an escaped DIF block inside the data sg

 drivers/target/target_core_alua.c      |  29 +++++++---
 drivers/target/target_core_pscsi.c     |  98 +++++++++++++++++++++++---------
 drivers/target/target_core_sbc.c       | 474 ++++++++++++++++++++++++++++---------
 drivers/target/target_core_transport.c |  11 +++-
 4 files changed, 439 insertions(+), 173 deletions(-)

-- 
2.43.0
