Received: from mail-il1-f227.google.com (mail-il1-f227.google.com [209.85.166.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D6B2857C1
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 18:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761761828; cv=none; b=Mkdd78K+rw/A+LTbRLddHLqMCI1gCgMUz/shl7d5bS2wFdzzc3TC/kFTJ2jHE0RJmClW9BrYqk1g+yILnIqL2+Pb4W8uBwui2fXt6Dk8jQdgfsqgVwtauLiRpfV0FzO+GrFUu5oK4gUqyJt7NIQoIFpMuH3dxwhL17sdHA1n4hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761761828; c=relaxed/simple;
	bh=fL/mzDaaraR2tiRizHZoK11nWzleuEmmK6cNUP0DUWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=olntYmeb7CP9sXUmj7FPiOa+aTyC+qHCvjgKzoRZprAUG3fyrggzM1FHPNnUHzN3RdWkX3f7uvYWGBx0o0W2UctqXyDjNZf1F+IEtRDWPG7xuJOn/Y+Ji239KZQM3dBGNoRDqG1WvUgQa6RQ8/kjFkHEyRyWlx5Ry3N0m7cT/Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=J52sOLIb; arc=none smtp.client-ip=209.85.166.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="J52sOLIb"
Received: by mail-il1-f227.google.com with SMTP id e9e14a558f8ab-430da72d67bso6319565ab.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 11:17:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761761826; x=1762366626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qfGrlrjOH9lWS4fohkIh1eKP1Pxj/5gPbF+k+vRwwao=;
        b=b/8nSNuEoPHI6gr/6bRm3TbUZ8aHqttiR5gtAuNJGgFFbe6ujDUCXr9JWLNuWVSnwv
         6m5Emy6giYbHm8iImADiSHxJ/ILYtpIKwgJtxC3L+yEBrwJu9hr5G+ncydUmX/wbQtLz
         3ltNcr2YsSdUtswBRCk3sCUWW5pmwYtXvu2LI7RCT/g8p46dJ5C13J3HKffuafi6AQZ/
         nvVAZ+p+aizqoYKY90SPVkouy1cMVSD5dUy06ZwqrGMV2rfxT4UsotDi8C3N8Eadq9Js
         Hv7pLSYf9ie30CJt/DVqaFnNbx1+2nnU1igjkMA8E1jDp84rv6VySnoDzDnA9L2wd55l
         LNvg==
X-Gm-Message-State: AOJu0YyoZ5c43E8kjWmoCKX5h0i3xJ+55PxyRMCadD0H0Opz8NBrMFBC
	tuRnqgEmKswV1bVFKKppw0VqIsedHGC1lD0GOyT5wKRXaIUeAewNa9i6kwtO5WtVTJ+HJDtVGOq
	cqM0To3NllWskULN/WzHY9gLsVCQ0ffPFJ8Lyx+CfMyuTQm7pn1CJUBEJookWpWgFPY0E+uXkMS
	KHl1aNLBgON8PPKh5Z58cNXRMQMl8ByPRVhWSjU6DFz56T2Hp0uKXVGX17+EHm54BbTKZjTjeUT
	4tycAOUqh1Hetky
X-Gm-Gg: ASbGncsI+43DEVhfDxW7N7fthDTrlQmk8Um2pWmm78wWBWxAZN7ecUKlt56AiXhjPCo
	WzdGjRPJxjowWKiVRB//INvAu+w/tUhn0g5DxDgX8/vmWi+21NoWIftSlJH+WAG26EeCRiUqfAx
	80z/pR2DdsTAVHdYO/a8YtlWyirrzGzuRjw38q0HQ9Jlkp3OwbdTRMlydKuOZo+Oai7Txu6qExr
	uGesn/O/K0k7vhw9YUnGwWWM2kY8P4rZuSO+cXh1QZb+YqP0eQ29cOX5wc/onw2PZ+fyKkrTGh4
	HQbErZDNAMdrxDSdCkFUC87UG/vcFprh9w34of4S1FxIBwV7vKrMOzQ1Xb9Y27E2+XvYhlBI6um
	IxTfq0VhTyYfRxVtPF43/EkZcaP5SduZ/XgLEx1pr3S8k7ja7oeZ4wTyy/KIHSGG4dI9TeacJsD
	PHHRtbk9ZPseDsjj2RHrWLsKaU2gnYBNU806PF
X-Google-Smtp-Source: AGHT+IHlUX1GxWHrqTkwlvoH2Os98YtbP+1XOPAL7Pq7TubEFhXAto6m645NZpzAtgJb+MU3vPUHydnoHrvX
X-Received: by 2002:a05:6e02:1f84:b0:431:d3d3:4771 with SMTP id e9e14a558f8ab-433011fed3cmr9140085ab.7.1761761826214;
        Wed, 29 Oct 2025 11:17:06 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-117.dlp.protect.broadcom.com. [144.49.247.117])
        by smtp-relay.gmail.com with ESMTPS id e9e14a558f8ab-431f67ea775sm14523135ab.2.2025.10.29.11.17.05
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Oct 2025 11:17:06 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2909daa65f2so13882095ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 11:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1761761824; x=1762366624; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qfGrlrjOH9lWS4fohkIh1eKP1Pxj/5gPbF+k+vRwwao=;
        b=J52sOLIbVQsHPCc7pHAhiI/JHnRpC6ZL35nKRosrjsB4WRgJKOuXSkOQHekCfNZOa2
         prQW1lXU0XuvUgqcl9JOd8EDgZobvishW925LSYhNzPqbjshQhyxSbRW5mMZYSqlukPc
         /Lp6cIsXp77WaBpmpt1WsQb0v9GPjl2Bsol6s=
X-Received: by 2002:a17:902:ecc9:b0:292:b0d0:2ef1 with SMTP id d9443c01a7336-294ed26debbmr6434435ad.18.1761761824282;
        Wed, 29 Oct 2025 11:17:04 -0700 (PDT)
X-Received: by 2002:a17:902:ecc9:b0:292:b0d0:2ef1 with SMTP id d9443c01a7336-294ed26debbmr6433845ad.18.1761761823521;
        Wed, 29 Oct 2025 11:17:03 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498cf341bsm157284565ad.14.2025.10.29.11.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 11:17:03 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 2/5] mpt3sas: Added issue_scsi_cmd_to_bringup_drive module parameter part-1
Date: Wed, 29 Oct 2025 23:40:46 +0530
Message-ID: <20251029181058.39157-3-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251029181058.39157-1-ranjan.kumar@broadcom.com>
References: <20251029181058.39157-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Introduced a new module parameter "issue_scsi_cmd_to_bringup_drive"
(default=1) which allows overriding the driver's behavior of issuing
SCSI TEST_UNIT_READY/START_UNIT commands to bring devices to READY
state during unblock.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index ecef13de3bba..af8020fc7b65 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -159,6 +159,15 @@ module_param(enable_sdev_max_qd, bool, 0444);
 MODULE_PARM_DESC(enable_sdev_max_qd,
 	"Enable sdev max qd as can_queue, def=disabled(0)");
 
+/*
+ * permit overriding the SCSI command issuing capability of
+ * the driver to bring the drive to READY state
+ */
+static int issue_scsi_cmd_to_bringup_drive = 1;
+module_param(issue_scsi_cmd_to_bringup_drive, int, 0444);
+MODULE_PARM_DESC(issue_scsi_cmd_to_bringup_drive, "allow host driver to\n"
+	"issue SCSI commands to bring the drive to READY state, default=1 ");
+
 static int multipath_on_hba = -1;
 module_param(multipath_on_hba, int, 0);
 MODULE_PARM_DESC(multipath_on_hba,
-- 
2.47.3

