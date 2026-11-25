Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795606479;
	b=OLpAME3tBToIJ0IbTsD0NK9klu6Z9vPIgeOfvkACak9M4MDmyGucVTK2pjkYqWX3zYgC
	 M1suZ+UxPemrLsYBy2N2JPgY29hBW92qMrE7OoMqBnlSD/wtBWFJzG7pr+pxGZteDexij
	 TlTtQHfzX6v3yBB0URP/fr6nQr3bNSdOn6DYv+bcvdum76R3aVlURqF6KAV3wgxz40K90
	 VJzzh8VoGAYdW+OcczKwt7dAIQNml70q0Gcl7qkqiFxlb6axim7zI8Fb02p5itZYNHX5U
	 NFLDK3rV6lPLQoAD/MNcf7LG47mdBZZ6Il321OhiRp19YXDAkVT51dLFkMJd40TnlVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795606479;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=61AAU+vu7fdoI9/33C3yVl5TzGMNl01fQ5U7CEh62QE=;
	b=u5Zh6qnIpcYgJiQuKZC+X8sSC5Gy0HXFZvP5taLhrgBHIszl90zHApNGQTlHutWqDXTt
	 cUOoclNGkzZcFgrsGRJfMzOOvGirmYtIHjh6DSn2LntpkdG7IXIFBol8tlMBm6btrsFMV
	 UZ/stBNsffLMjQITSHhypLK7P+L0Vsmwuu6I8PNAGVRtkJp0prnYuwBkPTbZFk12T2Ghv
	 02ZN20lKttlcyeZSAKHLrbfJNodRiLZt/l/09Szglsa/DocuEX8IMQy0+X4yAiKKhVqYT
	 WtHZf4owZyxnc0w9X9Qe6jba7TFe1MAlScSkd0xZTumNVlj+UMvg+kFHM338Wak3S1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="EOyauq/5";
	arc=none smtp.remote-ip=209.85.215.198
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EB0606A327
	for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 11:34:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 43EB0606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=EOyauq/5
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cdd9fa2a558so4498263a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 25 Nov 2026 03:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795606478; x=1796211278; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=61AAU+vu7fdoI9/33C3yVl5TzGMNl01fQ5U7CEh62QE=;
        b=EOyauq/5Z9V3fRPTUvrk4T2ff+my56KA+lTB9XWquEQZSAkhnODJZn5gf3KYkBAZjP
         Es0qaV8tAbj1eFRn4034orG4NoMcJ1VUvxUuSU8Xi4LokF4w3zKeuq5LsFXONi6n1qCk
         /NZlkPOANbKXr2TOFCcXmLOVCaEGqAK4ry8RKxAQ8peUJ71tFUt7uSS3Bmyo1RFif3+k
         bcVgJxbeS114yjBsK/GmriuoK+cieDMipuqzYsJUJDSZ0LdFFimqLD8YNfak4PuS41Ye
         7VawVXRXrESocVwPaLXJvuZVZuAZEnp9cGuHbCzj/+USWKoW41rFnPeGJOUyv3qqWPGX
         7KWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795606478; x=1796211278;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=61AAU+vu7fdoI9/33C3yVl5TzGMNl01fQ5U7CEh62QE=;
        b=tiPc9OVhwUFbuD14WWpPnS5/ElXi5axttqGHVEwW1+sYZFvP+y/9Sbstwj2rzOnseI
         IrfcQW49uCDzclGz3EBZZZ7A0J2JRnI35hkf842jeajq7QsXhPTkAu9G4uHSnMDSaT6G
         gv+PuSJOZ/COoKnMmS5WaRqerj0YZBO7fEriefo5cFlWYueEzB6Jg9nyW5HjimPJRrp3
         R163UGRKl8vrFAUsmpoCywap3VpCitXFg9vsMTR+ADqLtxkwrN0mjVenQkyHITkIwfl9
         bQyU+BMosX6001FjQn2a/ef5k9/4Ac28VLU6bSI3aaKjR2Z10erVveAWtatuvDf63Hgn
         Zn1w==
X-Gm-Message-State: APuU4Z/mOouexKZ9WV+O/DEZmMVgmRdHbtX871tNqLX0Lw2KP7VgO9+f
	H6LQYDIkkkdXu4c07hxvvfV4TXfvDO4O5gniVzyIy3H2HcklrEa1lsx0F2jRAqnqNjgPH1ImrTa
	6sNL/3fxRNvZOQ5HiRwp0rcFHsDQzCiGVy7GjEtvLaauPT5maGAjzH4qqbPcwFCQ37S0Kqwfazd
	+3F/gOAc7XXooS7y6LZOh4OUg5DHZ7uwzp+Ir/K/B5mEmmXIMCmz/s
X-Received: from pfbig16.prod.google.com ([2002:a05:6a00:8b90:b0:8c5:614:d2c8])
 (user=powenkao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:734f:b0:3e2:6f90:b54c with SMTP id adf61e73a8af0-4014c350660mr19069811637.47.1795606478059;
 Wed, 25 Nov 2026 03:34:38 -0800 (PST)
Date: Wed, 25 Nov 2026 19:33:58 +0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261125113435.1426680-1-powenkao@google.com>
Subject: [PATCH v3 0/3] scsi: ufs: core: Add debugfs for PA TFS/FEC error counters
From: Po-Wen Kao <powenkao@google.com>
To: linux-scsi@vger.kernel.org
Cc: Konstantin Vyshetsky <vkon@google.com>, Randall Huang <huangrandall@google.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <mkp@kernel.org>, Peter Wang <peter.wang@mediatek.com>, 
	Can Guo <can.guo@oss.qualcomm.com>, linux-kernel@vger.kernel.org, 
	Brian Kao <powenkao@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Brian Kao <powenkao@google.com>

This series exposes the MIPI UniPro v3.0 PA layer TFS/FEC error
counters (0x15C3-0x15C7) under debugfs:

  /sys/kernel/debug/ufshcd/<dev>/pa_err_stats/{host,device}/

Patch 1 fixes an existing teardown race by removing debugfs and
disabling debugfs_ee_work before scsi_remove_host() removes the WLUN.
Patch 2 defers debugfs creation until after device init while keeping
debugfs_ee_work initialization before IRQs are enabled. Patch 3 adds
the PA_TFS_* and UniPro 2.0/3.0 definitions and creates
pa_err_stats/{host,device}/ based on PA_LOCALVERINFO / PA_REMOTEVERINFO.

Changes in v3 (suggested by Bart Van Assche):
- Split the ufshcd_remove() teardown fix into patch 1 with Fixes and
  stable tags.
- Patch 2: Initialize debugfs_ee_work and debugfs_ee_rate_limit_ms
  before IRQs are enabled via ufs_debugfs_ee_init(), and document the
  later fault-injection attribute initialization.
- Patch 3: Gate host/ and device/ on UniPro version (PA_LOCALVERINFO /
  PA_REMOTEVERINFO >= UFS_UNIPRO_VER_3_0), merge the duplicated host
  and device attribute arrays into one via debugfs_create_file_aux_num(),
  update the hba_from_file() comment, and clarify the 64-bit read/reset
  comments.

Changes in v2:
- Defer ufs_debugfs_hba_init() until after device init (suggested by
  Peter Wang).
- Create pa_err_stats/host/ and device/ only when supported instead of
  returning -EOPNOTSUPP on read/write.

Link: https://lore.kernel.org/linux-scsi/20261124012951.3143833-1-powenkao@google.com/
Link: https://lore.kernel.org/linux-scsi/20261123025745.1743640-1-powenkao@google.com/

Brian Kao (3):
  scsi: ufs: core: Remove debugfs before removing SCSI host
  scsi: ufs: core: Defer debugfs init until after device init
  scsi: ufs: core: Add debugfs for PA TFS/FEC error counters

 drivers/ufs/core/ufs-debugfs.c | 244 ++++++++++++++++++++++++++++++++-
 drivers/ufs/core/ufs-debugfs.h |   2 +
 drivers/ufs/core/ufshcd.c      |   8 +-
 include/ufs/unipro.h           |   9 +-
 4 files changed, 252 insertions(+), 11 deletions(-)


base-commit: 08fec21faae44fe002467976befd68e6e62969b5
-- 
2.56.1.839.g22a8290db9-goog

