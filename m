Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D96946C
	for <linux-scsi@vger.kernel.org>; Sat, 20 Jul 2024 15:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721487654; cv=none; b=RR+JKGl4o3/ow1xwQvJDCSpO1kYC2rWA8PkLPSj1BgTQA9mBnX2qSYsavl2zGP4HOLsRd3ROd1smQeqOpE1V8cVhTXJ1JTlp4Yh40TkTzY6hwdx+vFe0DpxspIO4EulJF7wM5NYsg5hQ+p21z7ZY/+x4j+f25ysQ/dzgkC+rjUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721487654; c=relaxed/simple;
	bh=1CnA9uDJPSm34qFC4nKUXRRJlh17sdDfAbGV/pzqwqo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hdg/x+It98yQoRocjIEEd4DHzXfQSMrLl+66y7tlKWyH+nTUQjzZqdP52hPjYICWhpdvJDtMCW04dMSvpeXHELM8pq8s0UEXddEwOafDY6Vwkto1NqV831L1rQIzZ58nIu4ywIw2xPVdFhKA4ABW2LCucedSSzkbFeMZp7FcmXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QijMk3Qn; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QijMk3Qn"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-70af8128081so1320471b3a.1
        for <linux-scsi@vger.kernel.org>; Sat, 20 Jul 2024 08:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721487652; x=1722092452; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Bw2AJOf38nrdkWRGo+4GSQisL6yU/GhZFbkNB/h1Wr4=;
        b=QijMk3QnNF5V1yJUDG+Y4ywLYCCc38uYdHelhGVc0vjXVzW3+zxk0fHj0FSH8pDqRO
         yqckVDCPh+HtjA66cSNCqjKpZpmeWeoEbC7AZHJrH1hcPytxXkjUivwze7p/dtPKVBNp
         yueimLRTNZ3Bqg5XumGj4LmwTz6p9w6U5S37rKYUVeKQIah+23H66qht9qi1FKluIOJa
         fr8W3sM1ITkzV8slsFEtVz3iV60EALLFQ+JzppKoQf+9FbQ8hZTonxhYtruFEsW4OHqQ
         yquAV7rJkQ16Av6fIhUa/XCsPyVlrRnzomHmgWbO2FDImsF3eYgsPxyuCsFpEGHDhCZb
         lWJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721487652; x=1722092452;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bw2AJOf38nrdkWRGo+4GSQisL6yU/GhZFbkNB/h1Wr4=;
        b=S1RH60HPoaOFeIGm1slxUHWnjKcdrB5qQP5XXjXS18Nb7170Keyab/bQI6jLfG9sqj
         9bWkHstFqjj/QoGVRp6Tloc3jV+16qxTNUOtUxIKRc9xktJ2U8tT1N2ZzY32RgUUCE5j
         jln2JGBrwsDFO/r6/L/+l2tDRDBhk16AdWq8TcNhKqWEtHg4Xk7uXHpp9Pf68IsEWolQ
         t3X9FlxmY62EEFxzRmeJsXarjDuUWIz8dq3xj4+85qU6X+KbP/tCTVfzQXfTWEFAWE2m
         MFIoo+7i06FLH146kXJAg3EJGohxvAvvPxJIFnNCZNMwsw791KdiCdQEEpPvX/3xs3/e
         0JeA==
X-Gm-Message-State: AOJu0Yx3eQyg652/uHeh5NZwzHk9oNHFJNc9E0y7fpbQhEGQzQx1HStz
	pxMmgODxIWamKuDHo1d65GwvVFI4u/iGU2PnwK9FovcvdEL1zLnU
X-Google-Smtp-Source: AGHT+IHcdlNFqEQcTU5VC3c3drEntRHt3cUK7b1aqGz+rTmJ2YqbVZ+ZeoDzKoyn5rDQ9S8aY1Zqug==
X-Received: by 2002:a05:6a20:6a23:b0:1c4:214e:93fa with SMTP id adf61e73a8af0-1c428643ae1mr1519102637.46.1721487652023;
        Sat, 20 Jul 2024 08:00:52 -0700 (PDT)
Received: from DESKTOP-B5TBVBT.localdomain ([175.117.51.71])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ccf80a8275sm3615178a91.47.2024.07.20.08.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jul 2024 08:00:51 -0700 (PDT)
From: Yohan Joung <jyh429@gmail.com>
X-Google-Original-From: Yohan Joung <yohan.joung@sk.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	Yohan Joung <yohan.joung@sk.com>
Subject: [PATCH v1] scsi: Check the SPC version in sd_read_cpr
Date: Sun, 21 Jul 2024 00:00:39 +0900
Message-Id: <20240720150039.843-1-yohan.joung@sk.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add SPC version verification to avoid unnecessary inquiry command

Signed-off-by: Yohan Joung <yohan.joung@sk.com>
---
 drivers/scsi/sd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6203915945a4..9d71ad24d8e3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3413,11 +3413,16 @@ static inline sector_t sd64_to_sectors(struct scsi_disk *sdkp, u8 *buf)
 static void sd_read_cpr(struct scsi_disk *sdkp)
 {
 	struct blk_independent_access_ranges *iars = NULL;
+	struct scsi_device *sdev = sdkp->device;
 	unsigned char *buffer = NULL;
 	unsigned int nr_cpr = 0;
 	int i, vpd_len, buf_len = SD_BUF_SIZE;
 	u8 *desc;
 
+	/* Support for CPR was defined in SPC-5. */
+	if (sdev->scsi_level < SCSI_SPC_5)
+		return;
+
 	/*
 	 * We need to have the capacity set first for the block layer to be
 	 * able to check the ranges.
-- 
2.25.1

