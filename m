Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D003144D03B
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jun 2026 17:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780506673; cv=none; b=BOS6dAs6uk6awP5WmF76aUDgDCBSJJ96Cbk/PjZoWkCmwQtEvfsnzhKri8FHNfbBg0Gq/Id1SYwBZz3gLxfTp+npYQc5y0+NmOofv8gvI62cmy82EdymOMYYFt/QjfA+0l16EFNhrobt98bdl5bqCOjWtoG170O8+b9gg0McYPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780506673; c=relaxed/simple;
	bh=gggVixvNIe8eojfgqAyRfMfpRR02zkhLBeCRqDiKDcs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NS3ynrt1IkUDEXtVRjZMkxxZj0HVVTB0NNp9fln3ZI61/sCmlWMTRkN3dvHk1aLE3PgDflzsdb+nSAkc5AWgIfLqmpmWRqnREnkZ8ZpDc2MnTQGNfQjY+qcdFKKVV9uyI4ct+2ehp3eCunoDLzlW1v0nOqnfPKcQQ6iBjNw5pFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=YPjnIqLG; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="YPjnIqLG"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8ce3876a50cso42048646d6.0
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jun 2026 10:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780506670; x=1781111470; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Tt2E3V9JRbSP5TlXePw68cT+MzmoIbGHI39TQOv7QTs=;
        b=YPjnIqLGm1a1+7+5YruqmqcmrM/Akq0iVFMWmGpRxMy2edj6UQ9sVF2AYTEM8oHO54
         osilFLdDSNVYSLBgSpxLQ9nuVtgGIMlGLdcXB2u81yMFUvljwVU/mfg73x3aVsXllTrZ
         FfPg5FdIpbb6aMiSnR12Y/XDE1X972DmsMgoqRZELbRqyocbdWpEyWYQMLtawXuBZL40
         NRxYSI4ezZnm8mZWxfAymmN4BVpxe3+Nxo8sX2c0RGxYfuhibHuzDVTtq5ytbgK+bf21
         QIF+ciPAskzEaSA2YJ4HpD8tUp+zjlFwLGPk/j4TEZmTCOBcA2qFS8LlfsEnSCPxy5yq
         ZrfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780506670; x=1781111470;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tt2E3V9JRbSP5TlXePw68cT+MzmoIbGHI39TQOv7QTs=;
        b=R4SbqkykDDI/6gp4IW6ofiTF7grPq5pYkXyF60najQAq/lD9n3mzKUvztDi5jnlwCJ
         GWfGySsfaj8+c2D5bMtxQx7Pj9/sRtVdCnPlM8PDdP3hkOySsV48mHYo6+ZpNoHVec12
         ZhqWlokrT6tlzdxJ7yWTsZ6PtgASm8IsXlTcG+SpfJDB0p0ayBVG9HLcuytJUmgO8wWQ
         /2CUzcDm48SyH90g/APGLVrFSpFlPLk1yghN51vXh6BtAg8e7oKXss04h6O7kRq9NFGj
         RgBFnv9U2nIQQ8Kgt5fswii8DHydho5Jdk88ZGlY2fdJEQ6KH7e3uRqlnxNQeQiiBJIQ
         lOXg==
X-Forwarded-Encrypted: i=1; AFNElJ+Cgqv4xSah6ltNNAflbU0TW5WdMKMslQQbJPKyixJaqo5UrqJvxW+MYqJOokuP8arxxHpByXo75+5V@vger.kernel.org
X-Gm-Message-State: AOJu0YwBnvouC3x4G9/M4AOntTod7ekI4u0NClxxdqquJ4Gn2rXFiTuL
	JqPZxXxErrYX42PcIOtE/xVXLmmvYd/6pjrhsQM+ERbAfDu7rkXYJpFiNMgr0MRoggA=
X-Gm-Gg: Acq92OGRiUDKMvLLzW8jWfD6/Ph3heMOO2V0cAFZkdmtx34j+SwW3Tf5DCvuF6SXL+r
	rkMMI9F0YjVZtJC/0E2kPf6cBBALgTQbTiOeaTI7YKkp9QJw3TLbVEB0PeNixBZ92Jsis5332sy
	jGHxjKglTCZ8Bwtnonlz7xC3+meJZJw5NZUpNBn9vH1s70FGHRmVL354vBS9RbEvY5soHuiod5Y
	r8X90P4hEFPXVti7+jeDEEFqILGw6BoXYcvVCiAkedtq1JSGeQDVMMz0WIExDUdV94gQvW8fnn0
	w6Sfuw6w2AA962Zp0x453NgWjQqNRCVL2w+cxFpVFmlwg1Y7s+Jz75IK/Qfeu1q2at1tmAKFzsp
	0ROKRIHiOagEUZlorpY/vOR7675d24C+eoSOVYzOr1zLc/WIGPGGKLcyzInqveYK9uRKZsVnU+h
	xBV2fePkPW4nTldTzrk1vzLfDV28nFJ7WQvmkgng==
X-Received: by 2002:ad4:5ae7:0:b0:8ce:a9be:bc65 with SMTP id 6a1803df08f44-8cecdd20168mr62523276d6.41.1780506669831;
        Wed, 03 Jun 2026 10:11:09 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id 6a1803df08f44-8ceccdb93d8sm26240696d6.16.2026.06.03.10.11.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 10:11:09 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] scsi: scsi_debug: reject too-small REPORT ZONES buffers
Date: Wed,  3 Jun 2026 17:11:04 +0000
Message-ID: <20260603171104.18464-1-sam.moelius@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

REPORT ZONES subtracts the response header size from the allocation
length before ensuring that the allocation is large enough.  A short
allocation can underflow and make the remaining length look huge.

The handler can then write zone descriptors past the caller-provided
response buffer.

Validate the allocation length before subtracting the header size.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
 drivers/scsi/scsi_debug.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1515495fd9ea..f17e59482cfc 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5911,6 +5911,10 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 	alloc_len = get_unaligned_be32(cmd + 10);
 	if (alloc_len == 0)
 		return 0;	/* not an error */
+	if (alloc_len < RZONES_DESC_HD) {
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);
+		return check_condition_result;
+	}
 	rep_opts = cmd[14] & 0x3f;
 	partial = cmd[14] & 0x80;
 
-- 
2.43.0

