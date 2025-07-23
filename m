Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C286F1F418F
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 18:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753295781; cv=none; b=q77KSmD6GqF227Yv2G4hDTTmKmglkaq5ndjkqbJtXa1UJ+EMjIQ9sNeWuEa9FCgH2maR+GVw41GhbD2FjNdRijVgUKDj2ti6XsxStpu7+kGARoKMwpwf9w0RhjLLvpzbkXPfIIbU7g5u4RqtDrIB4DcdhJ2IEC8RJsS3K7BONuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753295781; c=relaxed/simple;
	bh=lX51zGb+VJsCyNbWa8Cuzj2F/YOaIzElMv/srpf58lM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=PQqsrJXJDK72HIl7efjwfd/TpaywmTJjUEyHUXBDrZvNy6rwuvN4CqIVnMno0Xal76J8Mz3Ku/WS05ymmsxtuWeqCBvG+85nkIWJ/bU6Uqh1N8UIMn982xNtdJCuuw2tCvXK44x2FIGom8Y3bUOwaBQOcMPb3oX0pBs/kBamWLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--frankramirez.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3IBEwQbV; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--frankramirez.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3IBEwQbV"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-756bb07b029so162608b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 11:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753295778; x=1753900578; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1ROnGstNEDPomrBgu9yV+iiwAQHhTAuFM1UBn/eyKB8=;
        b=3IBEwQbV41YnBTMT4VO9FFRiTpV+PYB9ncgRDtxvmI3u1mRbBRe9eJv5naKKNg1809
         yGVyjyU5ai8Aqmhf9hiX9UQgHW2L3i9hsaCB3OTOKofLrMfZcd1JJPe2/ArGM+USwVx8
         o/T3TjUzw+iuXgVAFXM7OojhaTUv2S39kC+M6PT66tdYX+8J8fWPj5G2R7Hva2QYy9iO
         L0d234iCK9qFIN0i28klCjf996rzXWWNyvfGMxd5SMdFCgtmGgWKL63/ysc4S4aWiCuD
         hEewH+r+VJcIQbCx/iPV+2f2tXZuM6s8yYYyio4x50iluBXI466C5k11/02Ry+GLmWlJ
         WDqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753295778; x=1753900578;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1ROnGstNEDPomrBgu9yV+iiwAQHhTAuFM1UBn/eyKB8=;
        b=tJ3IzOjnDFZ3H2i1tcgS/i9hP1aAZ/BeBKvc406qvpbexTCVBErmbptOb/3RibVYlc
         n9Wun6fYjfGYNDiyACekNpcaCUgrB7iGB08EvVXZcK/8BRVPvBmc3gYh8jAs/IuSq/q+
         X/XXzsblpN4vWLy6CMXKNK4e/h9tGdVrBUGcubvXtVpyuY2c7kjN0mBmY3HdSK4PKTMt
         EMI018ehfcJVc0I9YzR1RBS3tGLuZOTKGcclHbObtantRIKnqbs0Mw8c6yQrj1r3L8cZ
         qFVQhoRvTTScY0OPDlTxgmqkvtaI5BJFyJgTZy5vEbrdAZVDkbKdOnKScTWQRo2USL2K
         f2Bg==
X-Gm-Message-State: AOJu0YxMlY++l3VEFdDwubs374zC/tZ68xeHNrjfTlryiU9kfeEh2R6v
	MZhOtpyxvwfxeC+udkTNhzFRFsKR3eQesH3L+zATfxPvULTXgo/HjGLHagGC4qeKVdwDvOmRQxp
	2DpbBTUPhXcmrKAQwBeurtsL3dHx7KQ==
X-Google-Smtp-Source: AGHT+IE2AWKNPZ1t4GemCJp1QnuBKKKx7SOle0neRH59DSwqc4KrS5fcylkfUgAqGzMmFDP8CmCTJkqpDqLcNdM8mEM=
X-Received: from pfks17.prod.google.com ([2002:a05:6a00:1951:b0:748:e72f:1148])
 (user=frankramirez job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1a91:b0:730:75b1:7219 with SMTP id d2e1a72fcca58-76035de6683mr5868506b3a.12.1753295778047;
 Wed, 23 Jul 2025 11:36:18 -0700 (PDT)
Date: Wed, 23 Jul 2025 18:35:43 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723183543.1443301-1-frankramirez@google.com>
Subject: [PATCH] scsi: pm80xx: Fix race condition caused by static variables
From: Francisco Gutierrez <frankramirez@google.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jerry.Wong@microchip.com, vishakhavc@google.com, 
	Francisco Gutierrez <frankramirez@google.com>
Content-Type: text/plain; charset="UTF-8"

Eliminate the use of static variables within the log pull implementation
to resolve a race condition and prevent data gaps when pulling logs
from multiple controllers in parallel, ensuring each operation
is properly isolated.

Signed-off-by: Francisco Gutierrez <frankramirez@google.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c  | 22 ++++++++++++----------
 drivers/scsi/pm8001/pm8001_init.c |  1 +
 drivers/scsi/pm8001/pm8001_sas.h  |  4 ++++
 3 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 7618f9cc9986d..0c96875cf8fd1 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -534,23 +534,25 @@ static ssize_t pm8001_ctl_iop_log_show(struct device *cdev,
 	char *str = buf;
 	u32 read_size =
 		pm8001_ha->main_cfg_tbl.pm80xx_tbl.event_log_size / 1024;
-	static u32 start, end, count;
 	u32 max_read_times = 32;
 	u32 max_count = (read_size * 1024) / (max_read_times * 4);
 	u32 *temp = (u32 *)pm8001_ha->memoryMap.region[IOP].virt_ptr;
 
-	if ((count % max_count) == 0) {
-		start = 0;
-		end = max_read_times;
-		count = 0;
+	mutex_lock(&pm8001_ha->iop_log_lock);
+
+	if ((pm8001_ha->iop_log_count % max_count) == 0) {
+		pm8001_ha->iop_log_start = 0;
+		pm8001_ha->iop_log_end = max_read_times;
+		pm8001_ha->iop_log_count = 0;
 	} else {
-		start = end;
-		end = end + max_read_times;
+		pm8001_ha->iop_log_start = pm8001_ha->iop_log_end;
+		pm8001_ha->iop_log_end = pm8001_ha->iop_log_end + max_read_times;
 	}
 
-	for (; start < end; start++)
-		str += sprintf(str, "%08x ", *(temp+start));
-	count++;
+	for (; pm8001_ha->iop_log_start < pm8001_ha->iop_log_end; pm8001_ha->iop_log_start++)
+		str += sprintf(str, "%08x ", *(temp+pm8001_ha->iop_log_start));
+	pm8001_ha->iop_log_count++;
+	mutex_unlock(&pm8001_ha->iop_log_lock);
 	return str - buf;
 }
 static DEVICE_ATTR(iop_log, S_IRUGO, pm8001_ctl_iop_log_show, NULL);
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 599410bcdfea5..8ff4b89ff81e2 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -552,6 +552,7 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
 	pm8001_ha->id = pm8001_id++;
 	pm8001_ha->logging_level = logging_level;
 	pm8001_ha->non_fatal_count = 0;
+	mutex_init(&pm8001_ha->iop_log_lock);
 	if (link_rate >= 1 && link_rate <= 15)
 		pm8001_ha->link_rate = (link_rate << 8);
 	else {
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 315f6a7523f09..cfb3bbe04b78c 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -539,6 +539,10 @@ struct pm8001_hba_info {
 	u32 ci_offset;
 	u32 pi_offset;
 	u32 max_memcnt;
+	u32 iop_log_start;
+	u32 iop_log_end;
+	u32 iop_log_count;
+	struct mutex iop_log_lock;
 };
 
 struct pm8001_work {
-- 
2.50.1.470.g6ba607880d-goog

