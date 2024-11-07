Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842B71F8EFF;
	Thu,  7 Nov 2024 14:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730989037; cv=none; b=GEW40s6IgaBjZWd4e/Lmsm07XHIwOS+lMpIKSexQc13bQJWNpy5rUKFr/2VuTTtXlxE1YHM3N5dej7nSi1ldeuA06Osh3diR04mC2Ub7qAtvZvTZ8COIOEkA68B6XPxVzPsYzrzCaksNGqgunZ7cWvzbCAUESEswSRL6eJ4hSdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730989037; c=relaxed/simple;
	bh=AbmFMtl9U8DcZFAscKp5jFiwJO8pTrHTpV+fFaFS43A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=bgOaBQj89r+AQH7FYQaLpwYwM8Imx64ALvkOkwSQE5EaVuJJ9K4pthmMw/9K2iJzDCfO87bdh3cZEfRYIRANw8vwsz3RzHbLqnzdiIRHADoCXO22hfCQcXhJ2qS7xJtt0g58d1ifnnCTb0jebdArs2q3HXTwNgUnO+xCe6yQ/Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SXPMJnM5; arc=none smtp.client-ip=209.85.214.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SXPMJnM5"
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-2110a622d76so8477555ad.3;
        Thu, 07 Nov 2024 06:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730989034; x=1731593834; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tagTAJcz/ArVtot8xIbu51QF5b0nyMdocMmMIlwB2x0=;
        b=SXPMJnM51Z8/1lVVmjR8+yVMjrO6xFDIH4yNqdPdKcoqn6ty5WtETS2l+6qct5PjeU
         v02NvwLWNoNE+m0Rq09PfPh3m98dC4wWU6hAq4w6YOWnABVDHGGLshqES4lc9yldSftA
         EUCCrT6Q0fozrrVR7FNBiTJ2RCaUWgtd4Vt04vqSYlBxnkVqLlYsgaeyTrOCp63XPGro
         SM38UxFquTrk7J+PSq9wgnIE/+KeHnpq6PlzMzGb/jHLSyj9wTkSH4FpQiaeBhyrPuYH
         hE07fGXxBatGhTPz7eZSR4GlmpjPhD6NWJzNmWn7TLa8AZ8OyTZOJ4AQqXHhlFOba0dv
         AGTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730989034; x=1731593834;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tagTAJcz/ArVtot8xIbu51QF5b0nyMdocMmMIlwB2x0=;
        b=lcrIaKHAF2X3kekblbn7CEyZoXcEd7XUUtlpDBZ/hs2vksrWjnC30iqJ+0xqSZvzTS
         Ki7wlHvny4ALCs3usZj+w8SJXlD4kS4/j1nooL3sLi1Ly8bLjINrsV5MC6GPrHYidwG6
         hgewl5LeQ/N6O+EphSGTcirvgoWuEHhdjBY3ZtvtoGwFqHBxXmJB94WP3uhywxXtI/Du
         ARgt70SbKjb84KJtTZ3ScBFEjJ4sA1zphDrxWbG1HPAAum2hOSRm0OuNokkfzXhkB96n
         8aU3rNQXX2e9l1rIswBVtd5k0BUWOnlZS8GRp+oczSRIzYKO/bgXtSN9JRz1FNCu/NHI
         HCEg==
X-Forwarded-Encrypted: i=1; AJvYcCU8NDbfrxvHTaJsLaRqUYKqz27eAR5HKd/BWAgJ6F1Cju5TCPn7peqUwwwGbgko1kZ3864730KmB51w6pQ=@vger.kernel.org, AJvYcCVdDmypfWGlzRmbPweZiH3n6Bl2HvTBSxAiXJ9qt/akcVELOMAFrdfFqqtFAFdi8/3xrVNFV67d@vger.kernel.org
X-Gm-Message-State: AOJu0YwphPwJWDIO96xEisHr4dWEkj4LGmXTmMWQG1w1YZnB8Nep6ECF
	AOumnYEOX4RYFx41kfjjPpgx/nppffKXraAtzw0E2AwF0shGZo35
X-Google-Smtp-Source: AGHT+IEJ9TdPa0tslTfQmDUClfXx/7fOzwh/EY/bogBQb60wI4sHoiTCAgaM9SBfqrWaiB4x7VnO+A==
X-Received: by 2002:a17:902:d501:b0:20c:a7d8:e428 with SMTP id d9443c01a7336-210c68aa356mr639874695ad.7.1730989033779;
        Thu, 07 Nov 2024 06:17:13 -0800 (PST)
Received: from tom-QiTianM540-A739.. ([106.39.42.118])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21177e5a040sm12256345ad.209.2024.11.07.06.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 06:17:13 -0800 (PST)
From: Qiu-ji Chen <chenqiuji666@gmail.com>
To: linuxdrivers@attotech.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] [SCSI] esas2r: fix possible array out-of-bounds caused by bad DMA value in esas2r_process_vda_ioctl()
Date: Thu,  7 Nov 2024 22:16:47 +0800
Message-Id: <20241107141647.760771-1-chenqiuji666@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In line 1854 of the file esas2r_ioctl.c, the function 
esas2r_process_vda_ioctl() is called with the parameter vi being assigned 
the value of a->vda_buffer. On line 1892, a->vda_buffer is stored in DMA 
memory with the statement 
a->vda_buffer = dma_alloc_coherent(&a->pcid->dev, ..., indicating that the 
parameter vi passed to the function is also stored in DMA memory. This 
suggests that the parameter vi could be altered at any time by malicious 
hardware. If vi’s value is changed after the first conditional check 
if (vi->function >= vercnt), it is likely that an array out-of-bounds 
access could occur in the subsequent check 
if (vi->version > esas2r_vdaioctl_versions[vi_function]), leading to 
serious issues.

To fix this issue, we will store the value of vi->function in a local 
variable to ensure that the subsequent checks remain valid.

Signed-off-by: Qiu-ji Chen <chenqiuji666@gmail.com>
Cc: stable@vger.kernel.org
Fixes: 26780d9e12ed ("[SCSI] esas2r: ATTO Technology ExpressSAS 6G SAS/SATA RAID Adapter Driver")
---
V2:
Changed the incorrect patch title
---
 drivers/scsi/esas2r/esas2r_vda.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_vda.c b/drivers/scsi/esas2r/esas2r_vda.c
index 30028e56df63..48af8c05b01d 100644
--- a/drivers/scsi/esas2r/esas2r_vda.c
+++ b/drivers/scsi/esas2r/esas2r_vda.c
@@ -70,16 +70,17 @@ bool esas2r_process_vda_ioctl(struct esas2r_adapter *a,
 	u32 datalen = 0;
 	struct atto_vda_sge *firstsg = NULL;
 	u8 vercnt = (u8)ARRAY_SIZE(esas2r_vdaioctl_versions);
+	u8 vi_function = vi->function;
 
 	vi->status = ATTO_STS_SUCCESS;
 	vi->vda_status = RS_PENDING;
 
-	if (vi->function >= vercnt) {
+	if (vi_function >= vercnt) {
 		vi->status = ATTO_STS_INV_FUNC;
 		return false;
 	}
 
-	if (vi->version > esas2r_vdaioctl_versions[vi->function]) {
+	if (vi->version > esas2r_vdaioctl_versions[vi_function]) {
 		vi->status = ATTO_STS_INV_VERSION;
 		return false;
 	}
@@ -89,14 +90,14 @@ bool esas2r_process_vda_ioctl(struct esas2r_adapter *a,
 		return false;
 	}
 
-	if (vi->function != VDA_FUNC_SCSI)
+	if (vi_function != VDA_FUNC_SCSI)
 		clear_vda_request(rq);
 
-	rq->vrq->scsi.function = vi->function;
+	rq->vrq->scsi.function = vi_function;
 	rq->interrupt_cb = esas2r_complete_vda_ioctl;
 	rq->interrupt_cx = vi;
 
-	switch (vi->function) {
+	switch (vi_function) {
 	case VDA_FUNC_FLASH:
 
 		if (vi->cmd.flash.sub_func != VDA_FLASH_FREAD
-- 
2.34.1

