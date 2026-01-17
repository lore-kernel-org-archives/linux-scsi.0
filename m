Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D491122259A
	for <linux-scsi@vger.kernel.org>; Sat, 17 Jan 2026 10:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768645202; cv=none; b=UkH/2V8pE1wNMBRJOd7gGSyqPP/2p8ijmTGkJYA2JKDtxHcU5MBJy3ZdYoU7dYkUzP18IdRzlvPDNqDo142RB4xTNFfaGCmdpDg43lirRaQWomEndAsX8WBaH12NlxxSwabeOCiG948TUqwzXa6kLtRhaGXWTsuBn3ih25QsmlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768645202; c=relaxed/simple;
	bh=SgRySSIaJ7uxXomF0kuxxtEg+GQkRKe14Ludft80NUM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dQ89eg5IShaeTPnKwEhSvVR4goMoVVFsQpJZ5JIEJDQeH1pRTGAQcRJ4LXAsyc6tUhMGETnn+JTUOq67zsmDKp8zJ3lUeKN5S+VC5L0XIyUPnE59QfnR3AniwIxzkwggA1sTpwZTIDfHRrBFzZzLFH9nZy9uYq8PIDhImyHz3uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IPm6tq8G; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IPm6tq8G"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-430f38c7d4eso135016f8f.3
        for <linux-scsi@vger.kernel.org>; Sat, 17 Jan 2026 02:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768645199; x=1769249999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QRSQb7cGrtgfOhLkWk2KQRl7frQVEvtr+QRGRO51K5s=;
        b=IPm6tq8G2GAgbCmD8RBxmoVD1UcYICaXZO+Xp4KSeUlROrFB2c/TrPkPAVQQGcYTRz
         oqkcANBwOn+bD8owJjjKehBmftIlL16rbe6S35+4Qf4sY+S52ZflT6+mCTjvuZdXUIul
         eJDDNPUlvM5K+o865QBy18DAYKQqqkXRv2btBy45wLclRPxnV/I+NxFUJo0foYdVdrqT
         dax9afMzUh9s2EqxCIoyK1GgSMCBAhVAOZWntcRd86FWB0YfYpigPdjoodLwQ036pWll
         0eHmp74ilWO2wtQ/xUDHRVixyMHNDWysdPAt2wy17CRWfYWnaGGstln9T3IpSwNE6NhD
         4p5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768645199; x=1769249999;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QRSQb7cGrtgfOhLkWk2KQRl7frQVEvtr+QRGRO51K5s=;
        b=Ex3NQOOZvnFlJdgn/rhKkgNmKffQerwNWpAk5nME7u1SEFvA6mOVduq9Ddh3L6ep3Q
         G5tSBAmeRzhqNE4xw76llwSCdSmK+HVLjNnkkkIco5S+LIMGsVTneWwEFdR6tL0QKoP4
         YOHK9Jcz/fT/yZe+uEEWu02eKui64vglrTbwyrBSvK1Xv8DFSqJzA5FsOqJRSAXFHLqe
         X/n6fv2odZ5ovU0no7CNfxkeKimewfmIEKoJnr+GOYDyxR8c6DFd+HVYYm/UEodSYS9z
         7ZLJrXPGCrx9NGTEhVmhP18+8k+22EtB3YJXvo/2/5ECIAjbR8oCiGo38/Fr9lWCgJbs
         HSLw==
X-Gm-Message-State: AOJu0YwUOAJoEPMbOytieCXEsdQep1IXNi9Ga6Y+7LY35To7N8k5BsOE
	j4kDPC1zpuqTRxDffNFHjoJX3vuMR5zFBSaga8JxuKNW/4jGkwnPvlUZ
X-Gm-Gg: AY/fxX52dLCN7ygIAOsG8IQMudWetzXAGrfpawCrKz76wjRFNxHvvpGri7MYkV/oUUI
	ISkrIWgAHqWYCGPWNo9Ln5I5vwIqRjcF/ZvWBVwo2Dw8JuD4JE1TbUqEU2eKGEouut9SoJv+EaX
	GgHsMhxzi6z/PGlcETX0qNef10o6fE2sTfSCZUzLsoGAMW4ILggtrBz7RDN2UzdANuqkkZOsDaS
	cwZRi7Xu2i+ea7GPKhVohQL4uy2QtZ/POK3JxdUSajApRjNHQ1VqQ7KGrjTrQylS2RoP6hlr7FZ
	+o+AZvGviNI6Qd/TV0A392XmmsGw+hOIPhuakZEaIpELL40VovsgLSdRmgep9VdgqsJP9ZKSpJM
	uQoAAPtFeQD7LW7fH52YJEAGxZLahpSSNuSgg8ssTjCBsD2o74Iku7lO9+uK6+y766vSenWa9/k
	eOnCuLjHM1ByZgohTa89dVgHDGjpwZ1JKQ9oWAvww7800hxuJ9VxK/A2xWGCw=
X-Received: by 2002:a05:600c:3483:b0:471:3b6:e24 with SMTP id 5b1f17b1804b1-4801e34fabfmr37473175e9.8.1768645198911;
        Sat, 17 Jan 2026 02:19:58 -0800 (PST)
Received: from 3ce1e5d2d1b2.cse.ust.hk (191host009.mobilenet.cse.ust.hk. [143.89.191.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f429071a2sm140368405e9.11.2026.01.17.02.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jan 2026 02:19:58 -0800 (PST)
From: Chengfeng Ye <dg573847474@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <dg573847474@gmail.com>
Subject: [PATCH] scsi: pm8001: Fix potential TOCTOU race in pm8001_find_tag
Date: Sat, 17 Jan 2026 10:19:48 +0000
Message-Id: <20260117101948.297411-1-dg573847474@gmail.com>
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
      lldd_query_task()
        pm8001_query_task()
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
 drivers/scsi/pm8001/pm8001_sas.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 6a8d35aea93a..2d73e65db4c0 100644
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
 
-- 
2.25.1

