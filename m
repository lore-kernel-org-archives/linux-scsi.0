Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F401322B6C
	for <linux-scsi@vger.kernel.org>; Tue, 20 Jan 2026 03:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768879188; cv=none; b=qZadvhNHFG61xllbQoA7b2TP6Km4c2pM15HhsKpcnF2oMOh+ZwizdWlAY3nt6LVpsMDp0TB6RezOlNIi/bBn18jwYG6OdHEfAd97JVpqtJdroVN6pdleFR12TbOM5SUiLWIHck4HqJemcTqt2CkO5ugYDphrnUuI/5mMRB07VFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768879188; c=relaxed/simple;
	bh=uij0KN5FGYZqSIsR8p7toWwEIkqJUz3ny8m9h26hNWQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WeeqzVS3xCRWhb4TSRYlPcl/H0Kzp15YoPtbpnYlSX5CYRTbhmstQ2Za5ZQr+ZYe0f8VrMf7q8LCI+tgd/PKr/UOdmKwt+9x00r+/VFuDzVhYrk80hdlmmo+xm2PdIAWNxtKynHWjjoDXaZbLuazSB2J83a1WTEu7taa+wcpXYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fGL+tema; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fGL+tema"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47ee66dab14so3842335e9.3
        for <linux-scsi@vger.kernel.org>; Mon, 19 Jan 2026 19:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768879185; x=1769483985; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kDwHwfelgnuqMlLe+3UV/JtqzPKh28ncR9YWuP7/5MQ=;
        b=fGL+temaqD7jhjQEaijDWZzDe+oCTTgMW1HcgMdo4viXAElJh+oKiIGiuCvb5ACvzC
         LCfgVmsFoxm5r7kkgPbZTXwKS99cM7NiiwtSacpoh/XgPPro10vG+N+L9fBUNIlAWn/T
         H1ZPkb5cntMlEI0+XYoJY+gOaeFyuQUhgmAdtKwu8JFLUg0QjZX8BuDwUQAZJsQbKO4a
         pdqLA/JHIAmgCFS0QzfOcFp7Pu3T9fr5QpawxYj3ngTXU+lgkctd/4WRUcoafjRtuzAA
         rrY4GcrEwH382ig5Vq7QDu9S75C73mlHx1niCPaFOcWk0NMHr65iMYxzKXZWKBAQIQL3
         sUbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768879185; x=1769483985;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kDwHwfelgnuqMlLe+3UV/JtqzPKh28ncR9YWuP7/5MQ=;
        b=hA9BpYNSvLLSq1nOgHYgdyUvDR2vTXGbAOcfUhAHQZazBltYgd4nnZoc2d4t/fvMNx
         RKxqewOVVaqeLqsmwWwg5R//JJ9u2X6+966Nq17VtV8acdSvbREFeE8uEEHvFnJRe3BQ
         sObNG9vLgH8EN9SnMaSlCmIpqsfFwYav+pQ79Z+VhqZ2OXSEi89GQHc2SZnsmXTphUC4
         XfLKWENUDdAfb3MH8YZWTt2710xMb44uYbrgQvv8TN9BAK+WZqDH+y2QL1ZzCNtnSS17
         QKwsKz/WqXF5NCIsjZhk+GcPW0VEtNaLS0V2HrVGkpAa//Tp7VCO9AQJK/CzBFuIZA4b
         /bbw==
X-Gm-Message-State: AOJu0YwqMiPNKjDP1OS/tTdJUcNJXT2Rbh27x+9ThgpjiAxm8pdt22og
	em4RgsVwln5eweBy1cumrHIJ46KrrDnz7vh60Pn2vd5B3dmXIEi/1zgv
X-Gm-Gg: AY/fxX5wDriDozA+CsoLwBhoCMIbQItR/0/w8Gq6ZuQwhWFMm7GY4RhJsZdD2FUk8MV
	fhn8s2CKSil9B3WTPYaX8liNOw9gu/Eu8XOB4HjHlighu24bzMhsOWpFcqBZe7QKOFZqshUnA5L
	EENsK5f6NUcTWG/sMVQGuesYrUFnzYRsMfWsmUUIBXu6ar7cDjh+L5ZLjvhDCXeHq66n6ERviUx
	izcPlh3gnXFLLaCyTXrrz0ZmV5MFeqZk2+MVcRfbFBLkmklYvzYaHjNUfSe4yQ192QqtGcMfo5y
	lz3kiOKLQV1gFNZ2XU8w1ALMjlSzM1M2YyuktvVEeURmoC92l5xR+bVk/9oecGEJMs8Kd42sBF3
	zfcEywnGAJyWp+PPDhg3BZ26RkFgxmxKnrxjsF2iadtOpreT0cy16PQtYjgGzVZLIjjsWlEZAgt
	LZ/ve0rwOzEtYyX2ezQlpgyxSThs/kKSqFs5VpFypgZoSaIsC+aqXB4W8E5aIrbOmFQjwMUw==
X-Received: by 2002:a05:600c:3483:b0:471:3b6:e24 with SMTP id 5b1f17b1804b1-4801e34fabfmr89913465e9.8.1768879184596;
        Mon, 19 Jan 2026 19:19:44 -0800 (PST)
Received: from 3ce1e5d2d1b2.cse.ust.hk (191host009.mobilenet.cse.ust.hk. [143.89.191.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f428acae8sm280541095e9.4.2026.01.19.19.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 19:19:44 -0800 (PST)
From: Chengfeng Ye <dg573847474@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <dg573847474@gmail.com>
Subject: [PATCH v2] scsi: pm8001: Fix potential TOCTOU race in pm8001_find_tag
Date: Tue, 20 Jan 2026 03:17:38 +0000
Message-Id: <20260120031738.331225-1-dg573847474@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A potential time-of-check-time-of-use (TOCTOU) race condition in
pm8001_find_tag() where task->lldd_task is checked for non-NULL
and then dereferenced without synchronization to ensure atomicity.

Since the check of NULL and dereference in pm8001_find_tag() is not
executed atomically, a race could occur if the callback is executed in
response to an error or timeout on a SAS task issued from the SCSI
midlayer, while the SAS command is completed and calls
pm8001_ccb_task_free(), which sets task->lldd_task to NULL, resulting
in a null pointer being dereferenced in pm8001_find_tag().

Possible race scenario:
 CPU0 (Error Handler)           CPU1 (Interrupt Handler)
  --------------------           ------------------------
  [SCSI command timeout/error]
  sas_scsi_recover_host()
    sas_scsi_find_task()
      lldd_abort_task()
        pm8001_abort_task()
          pm8001_find_tag()
            if (task->lldd_task)
                                   [Hardware interrupt]
                                     mpi_ssp_completion()
                                       pm8001_ccb_task_free()
                                         task->lldd_task = NULL
            ccb = task->lldd_task
            *tag = ccb->ccb_tag
            <- NULL dereference

Fix this by using READ_ONCE() to read task->lldd_task exactly once,
eliminating the TOCTOU window. Also use WRITE_ONCE() in
pm8001_ccb_task_free() for proper memory ordering.

Signed-off-by: Chengfeng Ye <dg573847474@gmail.com>
---
v2: 
- Correctify commit message to focus on abort_task() path
- Check return value of find_tag() to handle race with pm8001_ccb_free()

 drivers/scsi/pm8001/pm8001_sas.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 6a8d35aea93a..314945c89977 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -49,9 +49,10 @@
  */
 static int pm8001_find_tag(struct sas_task *task, u32 *tag)
 {
-	if (task->lldd_task) {
-		struct pm8001_ccb_info *ccb;
-		ccb = task->lldd_task;
+	struct pm8001_ccb_info *ccb;
+
+	ccb = READ_ONCE(task->lldd_task);
+	if (ccb) {
 		*tag = ccb->ccb_tag;
 		return 1;
 	}
@@ -617,7 +618,7 @@ void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
 			pm8001_dev ? atomic_read(&pm8001_dev->running_req) : -1);
 	}
 
-	task->lldd_task = NULL;
+	WRITE_ONCE(task->lldd_task, NULL);
 	pm8001_ccb_free(pm8001_ha, ccb);
 }
 
@@ -1083,7 +1084,7 @@ int pm8001_abort_task(struct sas_task *task)
 	}
 
 	ret = pm8001_find_tag(task, &tag);
-	if (ret == 0) {
+	if (ret == 0 || tag == PM8001_INVALID_TAG) {
 		pm8001_info(pm8001_ha, "no tag for task:%p\n", task);
 		return TMF_RESP_FUNC_FAILED;
 	}
-- 
2.25.1

