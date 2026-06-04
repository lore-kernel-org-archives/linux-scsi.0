Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D910127732
	for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2026 23:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780616850; cv=none; b=QRyZW4vBDKAkArNU5fcXebAxpx2COYpMlAi/s+s7m69rRNAJLbGtTu1pUMBTumKa3L1GIr7o7PPL27hRAtkrb64soGeTP6zDvOEo3VKQJptu5zNjRxStMzY5pgxQ3aXUy4JGltDTDFz5LAFnlUzcQAdzcPWvQ6MvyBE4SQOe+3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780616850; c=relaxed/simple;
	bh=jj/ikHmykGQz64SAjkwMrbkSbr6d3VssuLkwrKzhwfI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tya0YIbEvoJWaVXBWoijAZLpGxLrGGberIhEsIQx/v+uZ/AUskNGUaAF+oJXbnQt5sSlMDZzIjH7NOmnidiBpyszTtpLVoKH5zviTFV1uh8QWnWId8ogSuE7g3rLMFQZDjr9hNMZgzgFUOI0NrHbrcA2Efrpv1ijQMae29PRlpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=AD7GyzSG; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="AD7GyzSG"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-9159f631656so148180985a.1
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2026 16:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780616848; x=1781221648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+ER1e63u4SB1f1fdhBGU/vKtYoHgpqUszESl9YWHkEU=;
        b=AD7GyzSGy5bfJpTK80aeig08HfmP5AzlTSm1ocmfAGwy39SEoZOK/pSdp2N0TOqScE
         4D2vE3PmLjieb4uax+v7fJk3f95ybl7QC4vxeW9tte5Q67PJl3FD2aOMP5kUOc/V0wpP
         2/FxvSzfRaZi4w8E4cGgwze84FiPicJ5KTaKadNeG4oajTkG8rnxUlfs8+M0EfPtdnuO
         bwt9BNbm2J6sIMCJBtI+jV8l9NYEp8ANsbcEq4QduDO7pH64/j+FLQFnjto6OujYvWwt
         alCmAylILjt/xq3GYrOirxJ+7BxFsgU9J1Q68fSDkerm018XCJaDMFQxOvGjtYfpIxEk
         FMhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780616848; x=1781221648;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ER1e63u4SB1f1fdhBGU/vKtYoHgpqUszESl9YWHkEU=;
        b=kPr8Og6C0OvkbTUfgCydYpuo77clminPcUTAy0cPMyMslXsnh/e6Y4Tp41uFzIU2rb
         p6wtBh7ujwxR1Z9leaNrhMgDxWQIaK97vtedRJ61ibKC9tHJv4mp2gWn6e0pLXRxOXLv
         F/6X74NfAmBKqwVXAIhreI0OQ4ggQazHB1vnw5+XPBXMNfLFO3AqpMC6qEC0rpHXsFzW
         lvfCZyndYDPCdpg1C6feIrTM4w92TxjiwP6Jf6ov7EDvJKSk8ndkmnXaHUa09Ti6GVBz
         Lq1q/JZa5GkyemXaterqvAyCB2SYaqmBCMQ/CpEXRAyDAE+X3BZQc1dAWBFEV5N5rLEE
         ZcbA==
X-Forwarded-Encrypted: i=1; AFNElJ+VDWgByX9mw9wwmdF1ObE+dWrjQILmkSUbhJXMA0fyHRn/HJvQB12VyUP7SIyIKTIHDb9hYmVRjqy3@vger.kernel.org
X-Gm-Message-State: AOJu0Yx25HRlQTFWIxLn9E4SnnYnL5+6DisTBBez81k5lks2Ivq8ZJqW
	ddXqO5jqELsr66gpKoc8+XwoFucGgJQiwR6AIZPS0m0An47SmPpr0JasbG3p2FS6xRQ=
X-Gm-Gg: Acq92OFCUoOc2CQx8BjVu6qaZey6xETURkebK9LofMjvNuwC3LTFpr+t0GUpmGpDzj6
	d1aJwGAR9rPlISK46HSD9CFag3Lpu12yBBxwVdV/vUaQDsT72/JhOWdnG4BkFjoRDZMxAkaeMip
	rRQYRRx3Hp9DL01gZGyE3h/+sDTmSA+JsTrBS5Rjr5BxNZOAKkdrjPYEeCYtFwqKFIdTv8ZBjBN
	4LEs8fKoEWXWbcRDEKj5/BkheaWMW878u/cZfAHQV+El2wcbl+YlmKdZnmSXuGsxzFDW3ro9wqT
	6O6VOvOQf/dlVV0rmCO5MhvA7INhxQ/39Cq/5B1RD0tm/wQ9B9y4j6TgPTbB5QpJmDa1hNssA7V
	5FrDfO7iTsEptQVot3aRg5bHxjFL1RZAAF366CNFOGI4DHl488iAK8Qzsx0GJ9L6/Wa6oSq7d8l
	oNWeMGbBLxuV44Q9IkqwAkaYG4Lpr0Uil3XhtCqyPSXddd8XVX
X-Received: by 2002:a05:620a:4625:b0:913:dcd2:f117 with SMTP id af79cd13be357-915ad2f40aamr30188785a.24.1780616847865;
        Thu, 04 Jun 2026 16:47:27 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-9158a37cae4sm721753685a.29.2026.06.04.16.47.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 16:47:27 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3] scsi: scsi_debug: fix one-partition tape setup bounds
Date: Thu,  4 Jun 2026 23:43:56 +0000
Message-ID: <20260604234724.1936118-1-sam.moelius@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The tape setup path uses one tape_block entry as the end-of-data marker
after the usable tape blocks. For the one-partition layout, partition 0
uses all TAPE_UNITS data slots and partition 1's marker is written at
tape_blocks[0] + TAPE_UNITS.

Only TAPE_UNITS entries are allocated, so that marker write is one
element past the allocation during device initialization before any
command is issued.

Allocate one extra tape_block entry for the marker. This keeps the
existing partitioning paths unchanged while providing backing storage for
the sentinel.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
Changes in v3
  - Use TAPE_UNITS + 1 approach
Changes in v2
  - Fixed handling of part_1_size == 0 case

 drivers/scsi/scsi_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1515495fd9ea..38fedfa3cefe 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6648,7 +6648,7 @@ static int scsi_debug_sdev_configure(struct scsi_device *sdp,
 	if (sdebug_ptype == TYPE_TAPE) {
 		if (!devip->tape_blocks[0]) {
 			devip->tape_blocks[0] =
-				kzalloc_objs(struct tape_block, TAPE_UNITS);
+				kzalloc_objs(struct tape_block, TAPE_UNITS + 1);
 			if (!devip->tape_blocks[0])
 				return 1;
 		}
-- 
2.43.0

