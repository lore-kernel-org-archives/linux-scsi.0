Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B241156968
	for <linux-scsi@vger.kernel.org>; Wed, 20 Nov 2024 06:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732083927; cv=none; b=LzZy1l13WI4jNyfAfG+a8gEUdEaD91zFBnaPG1ZEWv/ZOOKmB1xI4ga2u31l4gNQtDVBQOy5pPyNDTJ3Hy0sD9m5mn6874Zz3gEKArLqMEHBTUOiUiQ9GwM/S9VWWuAVc4JdOdFc9EDEzmC/NHB1Qacwu9PyB402d/LEbtCnhVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732083927; c=relaxed/simple;
	bh=R017cpge8ees2gqYK6x3gZ7yFo6Pw6vwX/ZyOP/0MNE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oRxBrdOB8JPLW+7mhebggsoxBJVSJa/crkzgevHn95ECp9hkdc3bV5LIZLBtCYS0eust0XoRGV5DTdt++3pdNSSCri0IJqEdWfeDYkCNWhsYCoEkoMHeROvg10cXpR4Ty+6ZxMFSZDa5e9WYhhdrVax4mDIu5pfqGbrOeVKKgXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ZVk6w30w; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ZVk6w30w"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-7f43259d220so2814804a12.3
        for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2024 22:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1732083925; x=1732688725; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QTmi6jByBjzNktXwXkJRmpSHct0ei4O8K+9JqDiETss=;
        b=ZVk6w30warozuAQ2/pcqEIk89tr70uN+ln/CTbVyNnJXIfkaN57k0AYZLdLp0g2KOM
         36jjY98wdCSkbP9fkoiOCy6xV4oeFVjH3jB01jBa+q/ZUERW+aw10sBujP0AzTCN4vbZ
         OC9HdfvTOvhhOmCfJbey3hn/0o/ZPzXZS09mY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732083925; x=1732688725;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QTmi6jByBjzNktXwXkJRmpSHct0ei4O8K+9JqDiETss=;
        b=DvzD3frcojf8jqretiq3O07LAuCu5CFyXAzB+78dYRryZ87xNIvsR6tri7os1T2XiB
         9q+I7baRT6C6Ss62Lxzc2vNiCdTVTYHyw8weZ0CxDZoidVmqs+t46X1JaZoIGZ8YjNUw
         Ludt+z+hwZ2U10aDEfSNLyo+nRcWWel+4mm178J6NOa5eyyO1RkKTdix9HdjBJPIMYtk
         vPWaVWvhf50eSczJZHtchZOcY41lEMnHvguIv9JsD8uh4nP1iYB95BlJZCUiz2mRwClD
         L3Y7OxEJMG3j4qlyRTUgxLzQVyi9+Fh6y7iL0BQOIXKCIm1iG6oftxo0MTgChbW1LBpR
         LhuA==
X-Gm-Message-State: AOJu0Yz900NoGp3JTgP9/dxBmJ+ufAzJZhjfAUQYvjOlg8YRG+ZALhAF
	M3tz9v6qhoc+MZqAXWHpz7Mvc4rSSItC/XoOye1sP2NbjcBnzcEoPxz57SyPrA==
X-Google-Smtp-Source: AGHT+IGiwmdc/aUVbve0b+8Rm2RprkONKeB9ZnpHILarTBjNfALPsI6VOgfIsP96w9G1VB+vrxirUQ==
X-Received: by 2002:a05:6a20:244a:b0:1d9:c615:944e with SMTP id adf61e73a8af0-1ddadff9cdcmr2873506637.4.1732083925669;
        Tue, 19 Nov 2024 22:25:25 -0800 (PST)
Received: from localhost ([100.107.238.250])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-2ead03c939csm488386a91.52.2024.11.19.22.25.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2024 22:25:25 -0800 (PST)
From: Gwendal Grignou <gwendal@chromium.org>
To: alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	quic_cang@quicinc.com,
	daejun7.park@samsung.com
Cc: linux-scsi@vger.kernel.org,
	Gwendal Grignou <gwendal@chromium.org>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: ufs: core: sysfs: Prevent div by zero
Date: Tue, 19 Nov 2024 22:25:22 -0800
Message-ID: <20241120062522.917157-1-gwendal@chromium.org>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Prevent a division by 0 when monitoring is not enabled.

Fixes: 1d8613a23f3c ("scsi: ufs: core: Introduce HBA performance monitor sysfs nodes")

Cc: stable@vger.kernel.org
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
---
 drivers/ufs/core/ufs-sysfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index c95906443d5f9..3692b39b35e78 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -485,6 +485,9 @@ static ssize_t read_req_latency_avg_show(struct device *dev,
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 	struct ufs_hba_monitor *m = &hba->monitor;
 
+	if (!m->nr_req[READ])
+		return sysfs_emit(buf, "0\n");
+
 	return sysfs_emit(buf, "%llu\n", div_u64(ktime_to_us(m->lat_sum[READ]),
 						 m->nr_req[READ]));
 }
@@ -552,6 +555,9 @@ static ssize_t write_req_latency_avg_show(struct device *dev,
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 	struct ufs_hba_monitor *m = &hba->monitor;
 
+	if (!m->nr_req[WRITE])
+		return sysfs_emit(buf, "0\n");
+
 	return sysfs_emit(buf, "%llu\n", div_u64(ktime_to_us(m->lat_sum[WRITE]),
 						 m->nr_req[WRITE]));
 }
-- 
2.47.0.338.g60cca15819-goog

