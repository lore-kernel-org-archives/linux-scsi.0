Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4F11487C4
	for <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2024 16:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719334621; cv=none; b=T7TLX77TGFnwKpTTnm8b4XV+YpuO5xWoRnQHLkVwzDjCtV+J0bqlaKfes2RkHHVlq7BrA6ZohdcY6bN0acfYR44ZFE3HIxLOTKzhy3JmmdqbachChwF0uLMoJiaxr/5dnsX3w/SR7cSFGyJvbpRwUUcBkdSyBzYTVJXZNbfijzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719334621; c=relaxed/simple;
	bh=ClowWHBMGpSGY7isC+FuQxeSWONXSEuYFGpYtOT0qjI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a3dLuLkyP/BU+VAAqZJx7fg/0+f5QjG9FWi87bqVaWCPnzrLHv0iZSOiQh8yw6Jq7zkmJh7AVW404m5hJNQEMf9tM+w+Gtt7qjpwnTfdsxyHyeBQ8agimRQP6LFJL4FzN+3j4XhWdSH8aHH5P3TinnB1iJYECoNGAC57Dv9KaWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=flPAz0Oo; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="flPAz0Oo"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-6f8d0a1e500so4522286a34.3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2024 09:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719334619; x=1719939419; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SDXFCf0M7P1AFDaWlATqHNCyuUXGnLUZ09WM2hR5gac=;
        b=flPAz0OoXT2j2icufJhQ/bL3EhTGDr7vPr6s3YS9MQJlTBT+SmSFxkCZLYvFXAPrvv
         3I63yhaVX4CAXz/iz4smPgctIj7Eztm5YvKqZA77BGDLuwRmg4/s+wzBTphR3l8nsw7F
         CRlxRwWo5+2qs2YmSRq0eUvmBcdueJmqVJoGdMAVb2/dv0d7bHgsnEnPiyJ538HYAnJ3
         OVBDauOu5vvBfqnMjb/AIgDAAbpUfaduxCWCF6nQCIHH3G9Nv9ww85Kdo4Iv2tP0+VHH
         Oz0W1TvuurDtVAdaKSxmUoTQmrgo5KatkhYyf/BTzS5BJkQ4sPcBAayZa6u5igD8W7pV
         NIRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719334619; x=1719939419;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SDXFCf0M7P1AFDaWlATqHNCyuUXGnLUZ09WM2hR5gac=;
        b=lSE5XquCzV004XRk3HB8T7LDQ4dskFMilL5y5S4pva3Ah4oVyabmi2cDQsTswSd0Rr
         oTxGv6HZNVy1ExkMTE/yfZd8N5jG5U5m7zHoMDr5E12INnOqielZyoP+d49itM6Aq1Nm
         MlRnhqVFPrXjBV/zxv0c7lUl/Yek49jG9nJZKeN2Mr3+/ZgWAbe17ol+U8p6SKprVoQ0
         BJc2X5c6qLTtZepLxbi9anLEd8jY09H6GeMIMnRG5LjvD8/byJQjsuKwB9aNidrs4wAM
         4N49Y5Zq2uM/pdmY8kKqI+G2enoGar8I2iXezcEvWzBvaUFJGy4I9nQLkh+CLwZ3Peg1
         tCNg==
X-Gm-Message-State: AOJu0YyCDsG1w46J16o5h4hEAP4cxjI7YfRBL9fOjbkYFikwkvE59I68
	qRJTeeDwdRCaLwVeJkj5l0Ny/wECVA02jXjerKlY4bo8/P0HduVIbi8jOg==
X-Google-Smtp-Source: AGHT+IHOS8YGMPPszdUQTHYVe+5s4OMymBFs8wDzuLjHyWxYe4qEMKvyey0L77JkV4aGCx2GldP5OA==
X-Received: by 2002:a05:6870:2198:b0:254:a881:cec5 with SMTP id 586e51a60fabf-25d06eb8255mr8653025fac.53.1719334618698;
        Tue, 25 Jun 2024 09:56:58 -0700 (PDT)
Received: from localhost.localdomain.oslab.amer.dell.com ([139.167.223.130])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-716bb3229c6sm6176874a12.93.2024.06.25.09.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jun 2024 09:56:58 -0700 (PDT)
From: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: prabhakar.pujeri@gmail.com
Subject: [PATCH] scsi: lpfc: Simplify minimum value calculations in lpfc_init and lpfc_nvme
Date: Tue, 25 Jun 2024 12:56:43 -0400
Message-ID: <20240625165643.1310399-1-prabhakar.pujeri@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


This patch simplifies the calculation of minimum values in the lpfc_sli4_driver_resource_setup and lpfc_nvme_prep_io_cmd functions by using the min macro. This change improves code readability and maintainability.


Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 5 +----
 drivers/scsi/lpfc/lpfc_nvme.c | 8 ++------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index e1dfa96c2a55..663ce30621aa 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8301,10 +8301,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 			phba->cfg_total_seg_cnt,  phba->cfg_scsi_seg_cnt,
 			phba->cfg_nvme_seg_cnt);
 
-	if (phba->cfg_sg_dma_buf_size < SLI4_PAGE_SIZE)
-		i = phba->cfg_sg_dma_buf_size;
-	else
-		i = SLI4_PAGE_SIZE;
+	i = min(phba->cfg_sg_dma_buf_size, SLI4_PAGE_SIZE);
 
 	phba->lpfc_sg_dma_buf_pool =
 			dma_pool_create("lpfc_sg_dma_buf_pool",
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index d70da2736c94..d22347318b4d 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1234,12 +1234,8 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 			if ((phba->cfg_nvme_enable_fb) &&
 			    (pnode->nlp_flag & NLP_FIRSTBURST)) {
 				req_len = lpfc_ncmd->nvmeCmd->payload_length;
-				if (req_len < pnode->nvme_fb_size)
-					wqe->fcp_iwrite.initial_xfer_len =
-						req_len;
-				else
-					wqe->fcp_iwrite.initial_xfer_len =
-						pnode->nvme_fb_size;
+				wqe->fcp_iwrite.initial_xfer_len = min(req_len,
+						pnode->nvme_fb_size);
 			} else {
 				wqe->fcp_iwrite.initial_xfer_len = 0;
 			}
-- 
2.45.2

