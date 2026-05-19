Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABDA20C461
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 00:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779151871; cv=none; b=H8TDaeKruOZMZ7yOBlHy5N2OkMaWgIRojASRowbXuNKOKjDdMssOLPDOe+yPGlpKOFwk0NkOi5yt/bkA/zjvFZr3/fIRCxBW6WwsST8WB/aq28ta+yulAbSD8TNjBj0CglmMVQwTexNOjzgttGYT4oY0xCeBAhwKkYmSAPpA15k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779151871; c=relaxed/simple;
	bh=zrbqW5qZ2/PrHRg2tdBFNqFHr7UVkVZdqxEzk/0Ztn8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M+qgNj5MBvxBk3QU9njuwBYyM5UrNaBPSmQV0ze61VZpMtsOiOTSMviaTCwcEyJNyTQJtGgx+Ewi8kDw+36FXNUSFVgnp/m8WMCHt/lqGPrx+arnb0BKW3zEZcylUI68GncDiTovgdxs67n7u/pP8NS+Quup5g68kzPmsVN0BHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UVZO8MTb; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UVZO8MTb"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-9118b952e2bso510813285a.0
        for <linux-scsi@vger.kernel.org>; Mon, 18 May 2026 17:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779151869; x=1779756669; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HnqrgYL3NmUNTzmNXdPdscQGE6zaGHL6C9Nt0N58KNM=;
        b=UVZO8MTbTYLoCi+BrJ/UyYC8FzI5Ks6g8NZhO39QApCnibKcOULunCNbQljHqyRmqM
         8eV55j0mBoCKGoOMBUi1Ck2fu0/vl5QNrJDu02E12XIGyP9Zd7CRQ2FImvo+vp+Yp1cg
         DVP6T3ydqBOiUIbN0qs3WTgpsZgZNiYsbC5nHVbXLr5FmilfxKeiEz6TaTufupScZKDO
         A8aG3rk4EQoMHqhcRQpckVnOj89tkjc50NrdV5W9u1O3AF/Sw5CnKu1z9txNRFj0hhwv
         jrp/vcA9DoU1ozZlRQ1X696CuC5yoXEPpA3poicdQ8VTf5V781wrq+Nz8R4+dWvMUHcm
         vPjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779151869; x=1779756669;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HnqrgYL3NmUNTzmNXdPdscQGE6zaGHL6C9Nt0N58KNM=;
        b=BUx7fXHLNs1nVj/2Sq/pTtXVtlpxryAC3ACQVecIqeIKNATDdQWyzRgRLy4BHDFV+w
         SF91+KAzOTO6+tbrugsgSk89e4i5Pa+r47mE2/BygaoKWsoq6ljmRpm49gsKxG0kkt85
         8C3C9KVO0it35Zsd+QbArVkyVCzeQbApuzhwriH1WG/fQWznr3ebsW0XOaZSzAwg1q6M
         z9X3RH7HgkdO1zl+oWya3c6qNuPOe47RwqE1xoqZUBz08QqNZQv8UMvxUcS7/DwCW8oq
         r8W3czuxB00B62Q69pPQkV1vtJA8BmCwNKlvIrJQ8Nc9UXDUdV9nl20b2I2mMPo/h8SG
         cRkA==
X-Gm-Message-State: AOJu0Yyn/3QVGpV7Tvlyxu5rpUAADQojrixlJVWN6sIkV4M/USgl+jhS
	qPK583SzmG4PrJVMXZd9AL9gIAD6XZLG2+MotVNDBg8swbPAd+tm0BYUgSOn2966
X-Gm-Gg: Acq92OHPFdM9tx41nu0I/kz7cKET3Am4FHbx+OKRXvtB76wEOGv4c2zsJbNwXBO0nIC
	YpzNp2S6oSyOTimKNHEzcYQZHwmrmC6THZ6hIqeY7LwEgKU2o6RTxlm9bcJU6RvJ3iDgPvplc52
	G9uUKl7CUukm+/WIsRPR4KN1aYBAxwQe3MnyjMs/kb1qpuvjxR1pBy2zBtZ2B3+oabarXJEcvuT
	22y3fTNm1dPotPuVFfrfyfbT1epQy7u3MDseWxjSlTbJE5Ovx19hC5/ula8p7neGHVQqMtt9/6e
	zafamOLy9lRTws0ycMqIfhvjdGLBmU+HNURsONd10s06GA28Qtp4oA4344/Pc8qf/BrZrPDk9Fd
	eJ3vydlftmsxJO1AqsP+U2NB1O2VZYSoQJ0aDXbhPh20byddLcgxx2asOl3TvED2Bs8WWU8JYOX
	etAQ9cNnk+uiVASOCK+15n3fHgVzmdM9BtFkOe/IgGwAymekKL7bfeST/yCKysRzBqnb2d0subB
	F9oSU0iAds3Fcfi9CSBrwKMFxdkV8XnyeA=
X-Received: by 2002:a05:622a:aa08:10b0:509:44c3:5fe7 with SMTP id d75a77b69052e-5165a1e652emr183515141cf.46.1779151868643;
        Mon, 18 May 2026 17:51:08 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d:7285:c2ff:fe45:8a32])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516457da48dsm147102541cf.17.2026.05.18.17.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 17:51:08 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	target-devel@vger.kernel.org (open list:SCSI TARGET SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] target: iblock: Use flexible array for per-CPU plugs
Date: Mon, 18 May 2026 17:50:50 -0700
Message-ID: <20260519005050.627926-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Store the per-CPU iblock plug array in the iblock_dev allocation
instead of allocating it separately.

This keeps the plug storage tied to the iblock device lifetime and
simplifies the allocation and RCU cleanup paths.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/target/target_core_iblock.c | 11 +----------
 drivers/target/target_core_iblock.h |  2 +-
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 1087d1d17c36..985197f0df26 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -59,24 +59,16 @@ static struct se_device *iblock_alloc_device(struct se_hba *hba, const char *nam
 {
 	struct iblock_dev *ib_dev = NULL;
 
-	ib_dev = kzalloc_obj(struct iblock_dev);
+	ib_dev = kzalloc_flex(*ib_dev, ibd_plug, nr_cpu_ids);
 	if (!ib_dev) {
 		pr_err("Unable to allocate struct iblock_dev\n");
 		return NULL;
 	}
 	ib_dev->ibd_exclusive = true;
 
-	ib_dev->ibd_plug = kzalloc_objs(*ib_dev->ibd_plug, nr_cpu_ids);
-	if (!ib_dev->ibd_plug)
-		goto free_dev;
-
 	pr_debug( "IBLOCK: Allocated ib_dev for %s\n", name);
 
 	return &ib_dev->dev;
-
-free_dev:
-	kfree(ib_dev);
-	return NULL;
 }
 
 static bool iblock_configure_unmap(struct se_device *dev)
@@ -189,7 +181,6 @@ static void iblock_dev_call_rcu(struct rcu_head *p)
 	struct se_device *dev = container_of(p, struct se_device, rcu_head);
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
 
-	kfree(ib_dev->ibd_plug);
 	kfree(ib_dev);
 }
 
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index e2f28a69a11c..849c948368bc 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -35,7 +35,7 @@ struct iblock_dev {
 	struct file *ibd_bdev_file;
 	bool ibd_readonly;
 	bool ibd_exclusive;
-	struct iblock_dev_plug *ibd_plug;
+	struct iblock_dev_plug ibd_plug[];
 } ____cacheline_aligned;
 
 #endif /* TARGET_CORE_IBLOCK_H */
-- 
2.54.0

