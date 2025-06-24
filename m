Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4B015B971
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2025 06:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750746131; cv=none; b=dfLTQyJBJxMfT48MNh18/CfSPrJo9sjsmhpGM+ZkuFCEHe0JjF+KmPjSy8gJ2NO6EPTH+1o4uPHlzaBVwEojbqcGsd1CG3b937dQOniWRGJ1ivOeoo9gfEtW/Juh8gnFmmcbbJZ4SvQPUjSUKow18HSSPLKiSgsAO6T45nDZRgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750746131; c=relaxed/simple;
	bh=Bl3xKRIiLlxBkZnmvdL34eVgXg+GXRlp+2dGlDOqWls=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OQZnjB1CZ5BRkJyPCBSiwk1HSU3A1h+29JOLUKWGpKvKp2l7fLsn9bNeM/jCksezWeEuqde3ESrYVtY8dYVI8EUUpZMaDFhm4Tonni7CA6Sz2D5acNcJgi/HBu7N+V/pjR3eDf/7E+vCJc7crtGkiD142LHu+mJgDeYLeWSBHqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=ZnlYjFCQ; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ZnlYjFCQ"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-23636167b30so46096025ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jun 2025 23:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1750746129; x=1751350929; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kypKoS3rUHkv7CiblGJGOjWca0U7U3413yBwpsbP/AE=;
        b=ZnlYjFCQlr3FzGG1nWsV/KwF5bfWchgdrsK4ucOaIatKV9umbqS+lzQpD5HNHRsYMX
         382PAbIGkgSOWhCzYlrRS2x3Xf4NnKI5IUeQwejL2vJbEQW2yuSydoyIv5fCqKeM0kpO
         3PH4NhJsDh5ZsMNRvGROIBy7ztnwjMy0VLVZM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750746129; x=1751350929;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kypKoS3rUHkv7CiblGJGOjWca0U7U3413yBwpsbP/AE=;
        b=GecbKMrRiFUkBCtvE9xbcmk6nd8ErArPAfRbQrNVZR/mRpE9iqjPbFh7qQIN1JYDN1
         sfgHgZIyd7prij+ljO+CD3gUKzu5PcNM7l6S1V6Gy3Rj7oDGZgjub67iT/+X0l/XKvQv
         o6NeeqjFDQcmPmOEW3jcEc55yokkQC5MT2DYCtrcVFxfs/3AscQWmd44NrDv3ezSBYK8
         yWK3tEE5lOyh+QbcOx21WmfLQCKachbKDeoah3PNqCPQBz7htT1QWABOkOXDbGgq+l2T
         YkZVSZJNNqwaW6BtwN/8p6rCgc0yJreTq6vyZdQvipc+qE0Nod6MCSV+wpwXhyZVrPCz
         GqPg==
X-Gm-Message-State: AOJu0YxhqT/Zw5BSJHgV/hzQaNJIc3uvEqgez4ntU6sRHHDaptOWDQ8k
	sSU+ndYf0N2G/OTzgiUqDOhMCvvAbyBLVSVktzBcz0fbBGhaTxStGBkq1JSrQr1wiUfg2fmK5Px
	T85PRK65Cdme1gW5JvwPNPW0Aq510Z5hb9dsjQWETuhIpDeHaZXzabPGNqrztBS6C+PFSjEKe/b
	vayybOmsbNsth6eBU4jvq3n3sGF2i1MRlGGCOCT3CIztdDLdMRXw==
X-Gm-Gg: ASbGncvPker1XsrRUNre8cA1/oFc6wdQtQsb6Xz0Mabm3amigw+7c28P1QZhVVDDShz
	/VdT/9AwV4CxnGP/i4J95mQyAqQFb9dyb4uUbbBhZ5jNO9v25vuTfxvCjkexfSzDC4s48NWPeOX
	+mfJcLyqS1ZOoiJwIGkRDSUL1vglxD2bifzPMK6JiSF0kX2HMQg+9bYq3KVDdxWzoqToajrwySt
	tdMMA87zeFhsG5GCxRmEeuTNt4j4FhVkPwK4tvFckhIgCVVxig0ugQ9xxzYQGobjqiVkQSQf3q1
	OGxn6mccc7aROebxblgxq5CINnb/gbIhN/ye8NHPTmizr1KNG23Hiqq9uBjMF+733QJj/i3efWi
	EN5aXYfaLs3SFJ+ldJXmxVI+Ye1TftA==
X-Google-Smtp-Source: AGHT+IHaTHEzNzYHu12hZmqojizi2fqHBb4LaNAplV6a4+4AQ4eT4D6xNSV0J7yqmuAgYxkr7MFp7g==
X-Received: by 2002:a17:902:ea06:b0:234:d2fb:2d13 with SMTP id d9443c01a7336-237d97f9aa0mr192181555ad.18.1750746128559;
        Mon, 23 Jun 2025 23:22:08 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d83937bcsm98135715ad.43.2025.06.23.23.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 23:22:07 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1] scsi: Fix sas_user_scan() to handle wildcard and multi-channel  scans
Date: Tue, 24 Jun 2025 11:46:49 +0530
Message-Id: <20250624061649.17990-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sas_user_scan() did not fully process wildcard channel
scans (SCAN_WILD_CARD).When a transport-specific user_scan()
callback was present.Only channel 0 would be scanned via user_scan(),
while the remaining channels were skipped, potentially missing devices.

user_scan() invoke updated sas_user_scan() for channel 0,
and if successful,iteratively scan remaining
channels (1 to shost->max_channel) via scsi_scan_host_selected().
This ensures complete wildcard scanning without afftecting
transport-specific scanning behavior.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/scsi_scan.c          |  2 +-
 drivers/scsi/scsi_transport_sas.c | 61 +++++++++++++++++++++++++------
 2 files changed, 50 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 4833b8fe251b..396fcf194b6b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1899,7 +1899,7 @@ int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
 
 	return 0;
 }
-
+EXPORT_SYMBOL(scsi_scan_host_selected);
 static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 351b028ef893..42e79eccf05f 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -40,6 +40,8 @@
 #include <scsi/scsi_transport_sas.h>
 
 #include "scsi_sas_internal.h"
+#include "scsi_priv.h"
+
 struct sas_host_attrs {
 	struct list_head rphy_list;
 	struct mutex lock;
@@ -1683,32 +1685,67 @@ int scsi_is_sas_rphy(const struct device *dev)
 }
 EXPORT_SYMBOL(scsi_is_sas_rphy);
 
-
-/*
- * SCSI scan helper
- */
-
-static int sas_user_scan(struct Scsi_Host *shost, uint channel,
-		uint id, u64 lun)
+static void scan_channel_zero(struct Scsi_Host *shost, uint id, u64 lun)
 {
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
 	struct sas_rphy *rphy;
 
-	mutex_lock(&sas_host->lock);
 	list_for_each_entry(rphy, &sas_host->rphy_list, list) {
 		if (rphy->identify.device_type != SAS_END_DEVICE ||
 		    rphy->scsi_target_id == -1)
 			continue;
 
-		if ((channel == SCAN_WILD_CARD || channel == 0) &&
-		    (id == SCAN_WILD_CARD || id == rphy->scsi_target_id)) {
+		if (id == SCAN_WILD_CARD || id == rphy->scsi_target_id) {
 			scsi_scan_target(&rphy->dev, 0, rphy->scsi_target_id,
 					 lun, SCSI_SCAN_MANUAL);
 		}
 	}
-	mutex_unlock(&sas_host->lock);
+}
 
-	return 0;
+/*
+ * SCSI scan helper
+ */
+
+static int sas_user_scan(struct Scsi_Host *shost, uint channel,
+		uint id, u64 lun)
+{
+	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
+	int res = 0;
+	int i;
+
+	switch (channel) {
+	case 0:
+		mutex_lock(&sas_host->lock);
+		scan_channel_zero(shost, id, lun);
+		mutex_unlock(&sas_host->lock);
+		break;
+
+	case SCAN_WILD_CARD:
+
+		mutex_lock(&sas_host->lock);
+		scan_channel_zero(shost, id, lun);
+		mutex_unlock(&sas_host->lock);
+
+		for (i = 1; i <= shost->max_channel; i++) {
+			res = scsi_scan_host_selected(shost, i, id, lun,
+						      SCSI_SCAN_MANUAL);
+			if (res)
+				goto exit_scan;
+		}
+		break;
+
+	default:
+		if (channel < shost->max_channel) {
+			res = scsi_scan_host_selected(shost, channel, id, lun,
+						      SCSI_SCAN_MANUAL);
+		} else {
+			res = -EINVAL;
+		}
+		break;
+	}
+
+exit_scan:
+	return res;
 }
 
 
-- 
2.31.1

