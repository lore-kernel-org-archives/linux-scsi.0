Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC750194A64
	for <linux-scsi@vger.kernel.org>; Thu,  5 Sep 2024 10:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725532305; cv=none; b=laIXpRWEGbvCWsGe6r8m3aM3K/W0c0BxAwDBvYoHI82wg0+0+BWZt8P8arqg0tA/khbN4Q/ZyX3Xd86Ax+5IGuRw/8cGquEQBwctZiS91tRXF1z0v5iSvGzawzuepLiy8iSI1uzte/e4WDRzSRWY8DYK9i2xgd0bYR3hztT0YZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725532305; c=relaxed/simple;
	bh=agnSYWK8590hWfAhH/B5uV76+bv+SptTdki0p3nYCKw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gsIcCez1ZmnaYq0c0mg6+x9eZN3Eve1ujgUIcaseR04dG2BYVglKPNOEWUMZN0CVU2aOqMPOlp0KGmB5sw2Gdu5k9yHusOurOxW5lksF9zha6uiw1uGH8Nrwf4sSAWgGqExtxg6AvV2HZ379jHpz4Y8QU5qYbDLsTGiYNAvXMQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=WkbDYBNO; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="WkbDYBNO"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7179129a13cso265487b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Sep 2024 03:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1725532302; x=1726137102; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=achv4njG20wuSV34efpTU9+cSk1eBCa0tkJZWsiy60o=;
        b=WkbDYBNOukDuJXINakKiRIxKSn6Ug1ymAN/H69TJ0TKTfu3tyT3fDtlbaAPpVsC10K
         jKo+dAmaNNVwRhOS13UJ+1yGWteAddU36OJsqse00y6L1asFKBUialtl5p/AW13QmNNn
         um6wt9/xO+nQCoyig6U3BTIYMVESkpbubPMRQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725532302; x=1726137102;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=achv4njG20wuSV34efpTU9+cSk1eBCa0tkJZWsiy60o=;
        b=giWh8+dW1XtFoPgkns+zAucdHPfv/nl11vtI1O9kYxb9NjaENaX6U/Zz6RyTk2fTdT
         T70kQEK2wi8weOUjeff2ciwAfDq74aT9Mumlc6EbClr/rR0lC2EEu57SqI3XG4UhwSvj
         S1+VwrWKJZjmkaAu5gV7iMArip7EawyRmVsqUteGgJ3NFMvIKvCANCRUi9QVkj04+0ej
         s84WwAexuHf55KS0AacfqKgNQ/qd0t7N4UnRjBQ7Kc1WF6YEvv4NtLEyV0OO8uxkyab+
         btQ8in9EkeIufX110n0wkEdUSXhvz8yHOJj09aqbzu9Go5zpcIUYzxEllLOLXVwa4fV+
         dcqw==
X-Gm-Message-State: AOJu0Yzgr4JQ5tatanLiHTzuL2XSMe0AhwLFZjce/2uVc9xpwlRdaQRf
	BOPFBfseBXeEprcH+3IbfuMoJpsUYpa+6UhetGlIu9HX+r2Wt+nS50jKq6GRZhF9JZUWIKXUnIt
	S5BScHs085uoOBZ2Zvkk1TdyMK6PRtELRH41j4qOBiZEBe0C3Suv1iqTahKAzhal3HWrFKhrDms
	q1orGVY0b9VHZ65OOES04qWguovEdNGi9Hvi1ajZKcQANNLw==
X-Google-Smtp-Source: AGHT+IHRFx8FiOg1kd/i50+pKGRhH9U6qeeMVrQus9qmR7DiXE8Fj72Fk0xZMcyU9HkYdFHC3JZ31w==
X-Received: by 2002:a05:6a20:d48c:b0:1be:c929:e269 with SMTP id adf61e73a8af0-1cce10ab242mr29240755637.34.1725532302245;
        Thu, 05 Sep 2024 03:31:42 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-717785364f9sm2960177b3a.87.2024.09.05.03.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 03:31:41 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 4/5] mpi3mr: improve wait logic while controller transitions to READY state
Date: Thu,  5 Sep 2024 15:57:52 +0530
Message-Id: <20240905102753.105310-5-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240905102753.105310-1-ranjan.kumar@broadcom.com>
References: <20240905102753.105310-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During controller transitioning to READY state, if the controller is
found in transient states ("becoming ready" or "reset requested"),
driver waits for 510 secs even if the controller transitions out of
these states early. It causes an unnecessary delay of 510 secs in the
overall firmware initialization sequence.

Poll the controller state periodically (every 100 milliseconds) while
waiting for the controller to come out of the mentioned transient
states. Once the controller transits out of the transient states,
come out of the wait loop.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 0eaf30b6c251..ad20da90a924 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1384,26 +1384,23 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 	ioc_info(mrioc, "controller is in %s state during detection\n",
 	    mpi3mr_iocstate_name(ioc_state));
 
-	if (ioc_state == MRIOC_STATE_BECOMING_READY ||
-	    ioc_state == MRIOC_STATE_RESET_REQUESTED) {
-		timeout = mrioc->ready_timeout * 10;
-		do {
-			msleep(100);
-		} while (--timeout);
+	timeout = mrioc->ready_timeout * 10;
+
+	do {
+		ioc_state = mpi3mr_get_iocstate(mrioc);
+
+		if (ioc_state != MRIOC_STATE_BECOMING_READY &&
+		    ioc_state != MRIOC_STATE_RESET_REQUESTED)
+			break;
 
 		if (!pci_device_is_present(mrioc->pdev)) {
 			mrioc->unrecoverable = 1;
-			ioc_err(mrioc,
-			    "controller is not present while waiting to reset\n");
-			retval = -1;
+			ioc_err(mrioc, "controller is not present while waiting to reset\n");
 			goto out_device_not_present;
 		}
 
-		ioc_state = mpi3mr_get_iocstate(mrioc);
-		ioc_info(mrioc,
-		    "controller is in %s state after waiting to reset\n",
-		    mpi3mr_iocstate_name(ioc_state));
-	}
+		msleep(100);
+	} while (--timeout);
 
 	if (ioc_state == MRIOC_STATE_READY) {
 		ioc_info(mrioc, "issuing message unit reset (MUR) to bring to reset state\n");
-- 
2.31.1

