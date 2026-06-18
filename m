Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A23433DEC2
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 23:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781825742; cv=none; b=H80JNGUCj98B6gIJpQ8jif9DnlwQQa/X2GZeRsUaDYSRC7TXd+Xsqpz901s3svBDrTgUbmJQrzZhLfO+QP2ueUWZeAZFdlmx+h4iZ4406xKYiZMMsr/zHrilizkd6NyVOKtZ9s743GRbGeAxNmxhFmO/ITKYt2LsXbzh5DVm8d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781825742; c=relaxed/simple;
	bh=nWhqdsxoCemBVZtsWA+LXhrND4pj97xn7KtYAA87gQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2/7G+yT6ulAkpSfvbe37q1Pjm2pZidz7TGhKO6oZqeN3a2/iJpl7qAmzM70g88kJOMSMIXORa17HCdeyxlQPRUm9054EXhyXeZTmhzOOrfkg+haiRtv9i+S2k5kYPUG2GJ/q5p1lbbxSotfClmYVETVrDvu+41p+iamTlaKPSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=OWS3RAfB; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="OWS3RAfB"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4633193af19so1142621f8f.2
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 16:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1781825740; x=1782430540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d/ML5gYSIv+jIIO24ijRUAqvz/OmoJ4QNHuCcMKsptM=;
        b=OWS3RAfBeLWNEqVxfvvQZNpjfdfWlDmj5Mk4mCKmA1nzE8V+OKXlUmc2Hk9B/yLOqF
         QKfamV90EHP8Bjo9N+Bm+2ajgTiTbUDmqZch9tMSSzFYzTelm3W/NU5da5ZJxZhgLhVu
         ChQ6SC3anppC5dL/2PWTpj3BI/PQUdrvVp8jmhEsq0oCYtt9yHFWnHMBTXUVV3FNvou3
         83axFmOLFJ43fBgHpNGBqvhy2pcXl9Khud82CsEGm5MxKJf9wiEcQcMKXT6mUv2fv2pt
         pTxvruhT2zpmxRs2KLTQZlrbonQygAUt3GU/mAW0Se/CHw/Dh+SWLwUDpykJh1WRCwfS
         82MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781825740; x=1782430540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d/ML5gYSIv+jIIO24ijRUAqvz/OmoJ4QNHuCcMKsptM=;
        b=mBCSEPJrJKbr7Mj4/dhaz9m6vvsZPvdIn65wrjFNlD3XLXLYkII097pVy2Cq6H8uHH
         INOFmqRaoaU+2gCDxUYTRVTW2pNYhoIEI5l5L1VZtbD0UU1Ecukl2xL4Rst9X0vzLFGE
         YcMW52IuWM6Y2prAbLHSz9ENfH0oZ57fmlU04LHaEn3cwYwOyalHUhPP0pATVFFv6wJn
         hvBgVv7SHXmr3Ji0k2joXSmG3d4o2ne3/ltqjmIDmoVHi6zug3B2QypJKOa4ni7yfRMi
         XiZlqwtLAmi+4KJbKu4XNSh/IPvkH66JrQzXgju+gEEjX8PUFSqBm2F6FCRvmdSk+fcy
         ydpA==
X-Gm-Message-State: AOJu0YycnTb2hVfAx9JP6ZmtjwzrATBO6rMuhA+F0vS/0iIwcBs4UFdG
	xfosd9rAkeMeLCuj4485YV6la1F9rOKd6SUJjR/lOdIDHLIRYPTNiA11W/MtGvP16fo5ox0TWud
	MQyi7IBin8h17L4dECDFLluJG+xRg6Mg1k9mgLxRKnNCFs91B0fvdYIJjLDFb2z9yUiWk4r/OCL
	OmZdyS0yW/LQw1oOq9+jO9sR0yS7v9+b2fGecghqbrILHhxfV2jg==
X-Gm-Gg: AfdE7ck4SWHis8Lgn7ywb2ZHAAbhB9GfZzzo0/UVfX/euZ7B1JgQpsR78B7YoEBLMmt
	jhcSpT45jZVkZtmybqSnD+BCuDDkud+cio1DExH33LjyyZJZIzeDg2OBk19sO0h9PNfExU3QJK6
	GZidB1nBpUWyRIsTv/VbhNYK5uXVhTDwkWJSjv8RMrgpmuwdW5OcToZKilPO8yPUIQ+g4wYOYpE
	apKFa1SkCyPYGsxcP0C38AKGINXUtamqGiJ6twYdsvaTGiWcj+3jFVJqNZVp3krh9PqWXNfAlJK
	s+ysmEyPuX+hjo/UCXYZ1PPOMeeo7XUXtaQFwbfk7xzdSJw8mNzn3O9Y+GcSCLkTYulDbCPgA+f
	d1sFRo4ZfeLCeSIjcQkZAX8VVb8tTj3ulQ9QgfBR163/dNo13FEd39nU0UqPcCU/xizwS4xo1jI
	kBirLrViq/ONCME8JW6Z4p75xR816nn8XUDHRRsXOqocyy+wLnFm+RycuXXpu7CzcjIev6SNCF0
	D4eWfVhN0LWO+Vf4ikOItF0/CnEIVUW2fyn7BUr97v5ZBkEgrg6tl7/gnzVbgYl9g1pvG0pmSRz
	io4yHEdlPZ5S
X-Received: by 2002:a5d:50d1:0:b0:460:3233:beee with SMTP id ffacd0b85a97d-465026e2381mr1604610f8f.42.1781825739615;
        Thu, 18 Jun 2026 16:35:39 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.79])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4650b67a34asm3492468f8f.22.2026.06.18.16.35.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jun 2026 16:35:38 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	hare@suse.de,
	bvanassche@acm.org,
	krishna.kant@purestorage.com
Subject: [PATCH v5 5/5] scsi: core: Handle reprobe for existing devices during SCSI scan
Date: Thu, 18 Jun 2026 16:35:04 -0700
Message-ID: <20260618233508.97960-6-brian@purestorage.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260618233508.97960-1-brian@purestorage.com>
References: <20260618233508.97960-1-brian@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Complement scsi_rescan_device() reprobe by handling the scan path.
Update INQUIRY data and reprobe existing devices when standard INQUIRY
data changed.

Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi_scan.c | 91 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 83 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e03a209b7bc2..81c12f557bba 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1207,6 +1207,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	blist_flags_t bflags;
 	int res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	bool is_reprobe = false;
 
 	/*
 	 * The rescan flag is used as an optimization, the first scan of a
@@ -1214,7 +1215,32 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	 */
 	sdev = scsi_device_lookup_by_target(starget, lun);
 	if (sdev) {
-		if (rescan != SCSI_SCAN_INITIAL || !scsi_device_created(sdev)) {
+		if (rescan == SCSI_SCAN_INITIAL && scsi_device_created(sdev)) {
+			/*
+			 * Initial scan found device in CREATED state (being probed
+			 * by another thread). Drop reference and allocate new -
+			 * the other thread will complete setup of the original.
+			 */
+			scsi_device_put(sdev);
+			sdev = scsi_alloc_sdev(starget, lun, hostdata);
+			if (!sdev)
+				goto out;
+		} else if (rescan != SCSI_SCAN_INITIAL && !scsi_device_created(sdev)) {
+			/*
+			 * Manual rescan of fully initialized device.
+			 * Reprobe to detect peripheral qualifier or device type
+			 * changes (e.g., ALUA state transitions).
+			 */
+			SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+				"scsi scan: device exists (type %d, PQ %d), reprobing\n",
+				sdev->type, sdev->inq_periph_qual));
+			is_reprobe = true;
+		} else {
+			/*
+			 * Either initial scan with fully initialized device,
+			 * or manual rescan with device still in CREATED state.
+			 * Return that device exists.
+			 */
 			SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: device exists on %s\n",
 				dev_name(&sdev->sdev_gendev)));
@@ -1229,11 +1255,11 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 								 sdev->model);
 			return SCSI_SCAN_LUN_PRESENT;
 		}
-		scsi_device_put(sdev);
-	} else
+	} else {
 		sdev = scsi_alloc_sdev(starget, lun, hostdata);
-	if (!sdev)
-		goto out;
+		if (!sdev)
+			goto out;
+	}
 
 	if (scsi_device_is_pseudo_dev(sdev)) {
 		if (bflagsp)
@@ -1248,6 +1274,40 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	if (scsi_probe_lun(sdev, result, result_len, &bflags))
 		goto out_free_result;
 
+	/*
+	 * For reprobe scenarios, update the inquiry data with fresh
+	 * INQUIRY results. The device already exists in sysfs, so we
+	 * don't call scsi_add_lun() which would try to add it again.
+	 */
+	if (is_reprobe) {
+		bool need_reprobe = false;
+		int update_ret = __scsi_reprobe_inquiry(sdev, result, result_len,
+							&need_reprobe);
+
+		if (update_ret < 0) {
+			res = SCSI_SCAN_NO_RESPONSE;
+			goto out_free_result;
+		}
+
+		if (bflagsp)
+			*bflagsp = bflags;
+
+		/*
+		 * If type or PQ changed, reprobe to update driver attachment.
+		 * Reprobe failure is not fatal - device exists, just may have
+		 * wrong driver attached.
+		 */
+		if (need_reprobe) {
+			if (device_reprobe(&sdev->sdev_gendev) < 0)
+				sdev_printk(KERN_WARNING, sdev,
+					    "device reprobe failed\n");
+		}
+
+		/* Device already exists, just return success */
+		res = SCSI_SCAN_LUN_PRESENT;
+		goto out_free_result;
+	}
+
 	if (bflagsp)
 		*bflagsp = bflags;
 	/*
@@ -1330,12 +1390,27 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 			if (scsi_device_get(sdev) == 0) {
 				*sdevp = sdev;
 			} else {
-				__scsi_remove_device(sdev);
+				if (!is_reprobe)
+					__scsi_remove_device(sdev);
 				res = SCSI_SCAN_NO_RESPONSE;
 			}
 		}
-	} else
-		__scsi_remove_device(sdev);
+		/*
+		 * For reprobe case, we held a reference from
+		 * scsi_device_lookup_by_target(), release it now.
+		 */
+		if (is_reprobe)
+			scsi_device_put(sdev);
+	} else {
+		/*
+		 * For reprobe, device already exists - don't remove it.
+		 * Just release the reference we got from lookup.
+		 */
+		if (is_reprobe)
+			scsi_device_put(sdev);
+		else
+			__scsi_remove_device(sdev);
+	}
  out:
 	return res;
 }
-- 
2.54.0

