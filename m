Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9987B289823
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2025 18:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750100032; cv=none; b=uVleTvjYK9M1UomII0DjvEMlmRpc0XPlNFy50jI8QXFQmlhMNwK6UiyuxG/jiTFH5ewR3con0vwovEzVptLtPOpJwpxmSAXqfRngJa8yajYwFuw9NmCo3dk2KWrG17uWCGPEIQ0HqbSYNjqso7rI2ZsagT7O31RQ5ZYj5Bp039E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750100032; c=relaxed/simple;
	bh=zUxltSsWVNVt8bYevgiEv/NHVTrfuATi/zj9pH/LRUY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NRCZ1b5vHI4NI93ZOy/ys7O4XDCD/Pi3ZbyP3M8iRYVR0EelKWtAMzX9dozLZyq3DTBFCi7B4HDD+TSp2nwntWUe+QRtKVbuZhGIMHRMLqOq4WoFquQXY3X6Stdhzih4VBMW4+4TyOeP3onmgDF+7dS5sLEIFxA3rSqev5BXFQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--salomondush.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MHiwZUAi; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--salomondush.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MHiwZUAi"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2eeff19115so6188214a12.0
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2025 11:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750100030; x=1750704830; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OLAr2ewOlT6jsnw3XYqY4XngPcCJbvRfNpPnxqDqFR8=;
        b=MHiwZUAirjFiY8zWd6t+4hQ4DOIYJUHk9U7OuzdK7Uu5ohbZZXfI2wBz/6H0YePXiG
         UFiFq9RbxgCqKP3+qniuLKAT5mRuVoWxZEXoCh5kWbxFbSwRwkH+lOk7k0v9YeUxr05F
         N07wK53lLtyyeNAWGdz7Er6ZBKE2nC5SoIPxGBSiIr564/LRWOeLJUbHX7nZx/aSfJTx
         MomLyu73R8iGlvq6l3vfs/z9dr+RwNkCvV86CIwSGMx4DBYEdLbWWJQlpMtGM8dL8iJ0
         HkE8dez5Y+C6J6GEl8Voscij3sqbwVDkj1plBc0pHiCnCCkSQ4i9dQytC9rW/eddPd42
         Icyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750100030; x=1750704830;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OLAr2ewOlT6jsnw3XYqY4XngPcCJbvRfNpPnxqDqFR8=;
        b=wDFoWyYBxL649jewvbK4PNYsuzLjKsCuBPDCIBZpUCMvKSdt3KTw2G+2hzOfjKDdxb
         w8jiJpGOrnuvmuBsSqyu9J02jxef0I9p6zKO3l4deqrHrAEP0HGrGJLAuvz/PrGtFguC
         kc0+kSysmVPsDIryZwtsZSYcKSfxTtNlHFEf4kWAlhEanZjRAoWgq2b8gNZzu3g9vwK1
         ckCP+uBnAbf8SFSR7SHbmigVHAkxZQqpfjfJcJAmTzANXuoVfBhGGmUdfS1oOFFao2Zk
         6Z2sCg4CEMcLmnkT5hPlFtnyP4QX4GWToPqr9L68ODhcrJCRBok9Hep+RpABCriOedF/
         ai7w==
X-Gm-Message-State: AOJu0YxKs8esAEGYB2lCNoQ1NwsPOUN6FXrQea8KMpKso2bjKRlt8Mtt
	/kI7mb9sukAFHuyhsi15PTEccoqDnqlWhBdH9U1+dEvX7Y3wZbhAVk9Z2/XDAKW7+AAcx94eXA7
	04HsoGOYBzMN+Lsu7IJuVGLfsSA==
X-Google-Smtp-Source: AGHT+IET7z9u2/hgTm5vndqG54MifGSmury/J3t5MlQaWyCOVjZGzk0mnDTcEwEQvUvJ3VNrnbLs36h+M+HrUqO/rQ==
X-Received: from pfbha10.prod.google.com ([2002:a05:6a00:850a:b0:746:1cdd:faa3])
 (user=salomondush job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:4612:b0:1ee:e33d:f477 with SMTP id adf61e73a8af0-21fbd4cd6f3mr16856910637.15.1750100029982;
 Mon, 16 Jun 2025 11:53:49 -0700 (PDT)
Date: Mon, 16 Jun 2025 18:53:45 +0000
In-Reply-To: <20250612212504.512786-1-salomondush@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250612212504.512786-1-salomondush@google.com>
X-Mailer: git-send-email 2.50.0.rc2.701.gf1e915cc24-goog
Message-ID: <20250616185345.2133349-1-salomondush@google.com>
Subject: [PATCH v2] scsi: pm80xx: add controller scsi host fatal error uevents
From: Salomon Dushimirimana <salomondush@google.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Salomon Dushimirimana <salomondush@google.com>
Content-Type: text/plain; charset="UTF-8"

Adds pm80xx_fatal_error_uevent_emit(), called when the pm80xx driver
encouters a fatal error. The uevent has the following additional custom
key/value pair sets:

- DRIVER: driver name, pm80xx in this case
- HBA_NUM: the scsi host id of the device
- EVENT_TYPE: to indicate a fatal error
- REPORTED_BY: either driver or firmware

The uevent is anchored to the kernel object that represents the scsi
controller, which includes other useful core variables, such as, ACTION,
DEVPATH, SUBSYSTEM, and more.

The fatal_error_uevent_emit() function is called when the controller
fatal error state changes. Since this doesn't happen often for a
specific scsi host, there is no worries of a uevent storm.

Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
---
Changelog since v2:
- Fix kernel test robot build warnings.

 drivers/scsi/pm8001/pm8001_sas.h | 10 +++++++
 drivers/scsi/pm8001/pm80xx_hwi.c | 48 ++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 315f6a7523f0..334485bb2c12 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -170,6 +170,14 @@ struct forensic_data {
 #define SPCV_MSGU_CFG_TABLE_TRANSFER_DEBUG_INFO  0x80
 #define MAIN_MERRDCTO_MERRDCES		         0xA0/* DWORD 0x28) */
 
+/**
+ * enum fatal_error_reporter: Indicates the originator of the fatal error
+ */
+enum fatal_error_reporter {
+	REPORTER_DRIVER,
+	REPORTER_FIRMWARE,
+};
+
 struct pm8001_dispatch {
 	char *name;
 	int (*chip_init)(struct pm8001_hba_info *pm8001_ha);
@@ -715,6 +723,8 @@ ssize_t pm80xx_get_non_fatal_dump(struct device *cdev,
 		struct device_attribute *attr, char *buf);
 ssize_t pm8001_get_gsm_dump(struct device *cdev, u32, char *buf);
 int pm80xx_fatal_errors(struct pm8001_hba_info *pm8001_ha);
+void pm80xx_fatal_error_uevent_emit(struct pm8001_hba_info *pm8001_ha,
+	enum fatal_error_reporter error_reporter);
 void pm8001_free_dev(struct pm8001_device *pm8001_dev);
 /* ctl shared API */
 extern const struct attribute_group *pm8001_host_groups[];
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 5b373c53c036..dfa9494fa659 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1551,6 +1551,52 @@ static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)
 	return 0;
 }
 
+/**
+ * pm80xx_fatal_error_uevent_emit - emits a single fatal error uevent
+ * @pm8001_ha: our hba card information
+ * @error_type: fatal error type to emit
+ */
+void pm80xx_fatal_error_uevent_emit(struct pm8001_hba_info *pm8001_ha,
+	enum fatal_error_reporter error_reporter)
+{
+	struct kobj_uevent_env *env;
+
+	pm8001_dbg(pm8001_ha, FAIL, "emitting fatal error uevent");
+
+	env = kzalloc(sizeof(struct kobj_uevent_env), GFP_KERNEL);
+	if (!env)
+		return;
+
+	if (add_uevent_var(env, "DRIVER=%s", DRV_NAME))
+		goto exit;
+
+	if (add_uevent_var(env, "HBA_NUM=%u", pm8001_ha->id))
+		goto exit;
+
+	if (add_uevent_var(env, "EVENT_TYPE=FATAL_ERROR"))
+		goto exit;
+
+	switch (error_reporter) {
+	case REPORTER_DRIVER:
+		if (add_uevent_var(env, "REPORTED_BY=DRIVER"))
+			goto exit;
+		break;
+	case REPORTER_FIRMWARE:
+		if (add_uevent_var(env, "REPORTED_BY=FIRMWARE"))
+			goto exit;
+		break;
+	default:
+		if (add_uevent_var(env, "REPORTED_BY=OTHER"))
+			goto exit;
+		break;
+	}
+
+	kobject_uevent_env(&pm8001_ha->shost->shost_dev.kobj, KOBJ_CHANGE, env->envp);
+
+exit:
+	kfree(env);
+}
+
 /**
  * pm80xx_fatal_errors - returns non-zero *ONLY* when fatal errors
  * @pm8001_ha: our hba card information
@@ -1580,6 +1626,7 @@ pm80xx_fatal_errors(struct pm8001_hba_info *pm8001_ha)
 			"Fatal error SCRATCHPAD1 = 0x%x SCRATCHPAD2 = 0x%x SCRATCHPAD3 = 0x%x SCRATCHPAD_RSVD0 = 0x%x SCRATCHPAD_RSVD1 = 0x%x\n",
 				scratch_pad1, scratch_pad2, scratch_pad3,
 				scratch_pad_rsvd0, scratch_pad_rsvd1);
+		pm80xx_fatal_error_uevent_emit(pm8001_ha, REPORTER_DRIVER);
 		ret = 1;
 	}
 
@@ -4039,6 +4086,7 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
 			pm8001_dbg(pm8001_ha, FAIL,
 				   "Firmware Fatal error! Regval:0x%x\n",
 				   regval);
+			pm80xx_fatal_error_uevent_emit(pm8001_ha, REPORTER_FIRMWARE);
 			pm8001_handle_event(pm8001_ha, NULL, IO_FATAL_ERROR);
 			print_scratchpad_registers(pm8001_ha);
 			return ret;
-- 
2.50.0.rc2.701.gf1e915cc24-goog

