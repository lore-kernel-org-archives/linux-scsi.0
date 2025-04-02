Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810611EE7CB
	for <linux-scsi@vger.kernel.org>; Wed,  2 Apr 2025 19:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743622936; cv=none; b=YFWeRfQIMS5Lx55alH0lj3GnGRMm3ngOzsUQ4hMoafFIVXVqbpzY4SDbaWRa6JFzr5QfKKzeqthQstIcgVMnBBHrPVRbkAJrMKAJfHvanOAf+VPPa/Keit3cIWlkBJg46h4EihYqq+K5f8dSJsR+joMiB1fkt92r+U8fsB1xjz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743622936; c=relaxed/simple;
	bh=0B1varXF3zRREs2WTDB9tiKYpA6KG4nGKtDXZE75VzM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lojUWSQ36d7+oPX+TOm03nVf12xTUDiNVX6KHgvWNuCsfDvcft9EqsHokTSugZ82KaB2ByCYGJPq14edjA9voUf0yotLU0FclqyxxxQx8XALaqGHEl2B0NxgsWnvgIuvvXs0R/+KpSCh1gi9ztA2/cN7Aox3gOCRa4023FUqV8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=BU5aV4nI; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BU5aV4nI"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-227b650504fso2003595ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 02 Apr 2025 12:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1743622933; x=1744227733; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wVsMm8NEl4VBpbG4Kvoxkxy1A+UQLlEf3tQEh4oFQV0=;
        b=BU5aV4nI67GwltXaAve4MLFbQAli3Av4yXQUo5yNYgnGbU6DX/ABqmYKOLOj9xPq1B
         RcSe/gd4wKyeEpxefAXSMDI1KNh21MVbEengKOtnPJfVupzWISFQt4rX19OOWijYaaHg
         INCIE6g1JILqYt+Ve869Gcl0zTA3rKOLhB75A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743622933; x=1744227733;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wVsMm8NEl4VBpbG4Kvoxkxy1A+UQLlEf3tQEh4oFQV0=;
        b=Syb74aPsQMv3+huvsaS4pQm/zMRVUlXblFukaPq8bsuCocjtvcp7xYtYuSqxoRp0wY
         4BCznlilTGfLFK+8TUPjy0sT5hJkap7Vl0ONdnkecMiDdD8zYbDcavSoxSxPn6LTS+0W
         fiQ4UxSIVKrUZwzMscKa+mLxJ8FYIIUdFM9jkF/TAtbOU89IBVKVrFeOC2ilXxkqeVTf
         yAVZjqKoR00kiDrHJ1+Z22z4WEIacgnrGuECNc1t81xo+tfloAelSHpFMYMAPYtlO6bJ
         7U8franAM0sy9o/bvqc0xPPNlQnbGGA5zPNKltrQv1FBMBDLPsUc+dzWjkZAe8585uFY
         JZkA==
X-Gm-Message-State: AOJu0YwKzMq5SZ/q1EyTAqfNQOgF0BdINEZAFH9+usQITQzSZqMDOBxk
	ndjFxGXj/TtIPhSHqs53Dx3lExAUqdPdVweS1Jo5S2dV+gWJxAVlZRFpQNkM9WH8NmFxUfocY6O
	9ew86J7JrH3EjzJkQHIqY/wY+1tUncT2lOsGFHnP5La4Mvyph7/G8g89uzxxda9WJyDnqxLfDyP
	gOPUqurAAMy9n1BXyI5SMSoAi9RnGQhRz3WoB59J1p9X/ONg==
X-Gm-Gg: ASbGncvziGSSZmnyLaTEjROiZhHCBO6DWe7Yk0w1HrvK+pKr2TSJfKr2ZZU3g31ZLIo
	bd4c0BS4sd8JzOOzqFyYoUzeKINasUOGRqo2GQU4nBvIXiOwy7c63EdDX9iLLkHTxphfq9E3yqo
	djfWZCcRRwaIFOyjWvyyWJKwgERukf0ETaMWZN+TmXhZONXaDrx9h3Y8hUglWKT3xNqIS0T7vk5
	qfq0s/yF4VfyRganSWh3qiDYL0pl/OGFAtVRaTI8TorJKpOw3Me3uD8o9CgCdzmVJeWZIWJPwMJ
	yL0XJyY9UhHcux06SVAS8zWpmAuRuOwEy7lFza0uYFhJ89pjAaBhseXB0txMYMaVozbexNnI9B1
	Gt6dcZbvcYoQE9gQMs7mxJFMSV4dc2Gs=
X-Google-Smtp-Source: AGHT+IHTfhbUoDeQBYlLRzs+K8M+V+hRCvhjI6pXcEwUzqz50YqReOb7nAuMOKMre8cNtG7RITwL3A==
X-Received: by 2002:a17:903:94c:b0:224:abb:92c with SMTP id d9443c01a7336-22977e08336mr56185ad.50.1743622933079;
        Wed, 02 Apr 2025 12:42:13 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-739710d97cbsm11797396b3a.173.2025.04.02.12.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 12:42:12 -0700 (PDT)
From: Chandrakanth Patil <ranjan.kumar@broadcom.com>
X-Google-Original-From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	ranjan.kumar@broadcom.com,
	prayas.patel@broadcom.com,
	rajsekhar.chundru@broadcom.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 1/2] megaraid_sas: Block zero-length ATA VPD inquiry due to firmware bug
Date: Thu,  3 Apr 2025 01:07:34 +0530
Message-Id: <20250402193735.5098-1-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a firmware bug where ATA VPD inquiry commands with zero data
length are not handled and fail with a non-standard return status code
0xf0.

Hence, the driver blocks zero-length ATA VPD inquiry commands by setting
the device no_vpd_size flag to 1. Additionally, if the firmware still
returns status code 0xf0 in other failure scenarios, the driver converts
it to a SCSI 'check condition' for proper OS handling.

Suggested-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 9 +++++++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 5 ++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 28c75865967a..d793924547f8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2103,6 +2103,9 @@ static int megasas_sdev_configure(struct scsi_device *sdev,
 	/* This sdev property may change post OCR */
 	megasas_set_dynamic_target_properties(sdev, lim, is_target_prop);
 
+	if (!MEGASAS_IS_LOGICAL(sdev))
+		sdev->no_vpd_size = 1;
+
 	mutex_unlock(&instance->reset_mutex);
 
 	return 0;
@@ -3662,8 +3665,10 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
 
 		case MFI_STAT_SCSI_IO_FAILED:
 		case MFI_STAT_LD_INIT_IN_PROGRESS:
-			cmd->scmd->result =
-			    (DID_ERROR << 16) | hdr->scsi_status;
+			if (hdr->scsi_status == 0xf0)
+				cmd->scmd->result = (DID_ERROR << 16) | SAM_STAT_CHECK_CONDITION;
+			else
+				cmd->scmd->result = (DID_ERROR << 16) | hdr->scsi_status;
 			break;
 
 		case MFI_STAT_SCSI_DONE_WITH_ERROR:
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 1eec23da28e2..1eea4df9e47d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2043,7 +2043,10 @@ map_cmd_status(struct fusion_context *fusion,
 
 	case MFI_STAT_SCSI_IO_FAILED:
 	case MFI_STAT_LD_INIT_IN_PROGRESS:
-		scmd->result = (DID_ERROR << 16) | ext_status;
+		if (ext_status == 0xf0)
+			scmd->result = (DID_ERROR << 16) | SAM_STAT_CHECK_CONDITION;
+		else
+			scmd->result = (DID_ERROR << 16) | ext_status;
 		break;
 
 	case MFI_STAT_SCSI_DONE_WITH_ERROR:
-- 
2.39.1

