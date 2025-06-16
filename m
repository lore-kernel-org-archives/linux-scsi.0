Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711C11CAA62
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2025 19:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750100431; cv=none; b=aMlPH4CGXp/kJj0+7slKa8S6AIpwouxyiUXRR15ez9TTSkuhH9Cg5KhW0WpreXVm9VElCUgE4QBzWCbCMLnYh35QGzs6f01qGHeCHLAg/23hVpQu7l2WqgRvKdKuEn0+tEvxg5JholssGFjXXve128pnLGV3LFp7n9LFOJ4MaYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750100431; c=relaxed/simple;
	bh=9besGwIU/81/CaB70eqYGxX6VSKamtzwWGExgc/F3XE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cUHG5aEZ3i89z5aYhCl4NELwF8fVApczmUAsdAD6tNEiqXToEA7hxvn/pqn0KuAk7DVzejBeWCty0Y9Qzw89L4+Onj65o5jhc/RSmK5VjMdAvyRD5Y+RhmwKd8s+r3I9Uuv3JO7omwM6crDwoAeD4oFIA6MeMFUGC7sSmI7U4fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--salomondush.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vAI8SHBx; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--salomondush.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vAI8SHBx"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-236725af87fso26553645ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2025 12:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750100422; x=1750705222; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jFNCP/Zfjf0zOYYsP29CukZPsGtgXo87gr1Y7z6mt20=;
        b=vAI8SHBxRlToldnVS8rSMkh4trf+nWk+GEtyW9HLfnFBZY2cZX+uOcyc/eUH8Bxgb5
         yIM1LdSrq8t/j7vkJNaPkQ3AYERZx9FcLD4k2r2qwN7zmq/mqP3xCPwvD1fMNq+bY5H0
         juPQ1nEDxfygJTuDzY7Yd77tqN6u0ovz4jq0zt9KbaPs3Zx3zCy9NVwzPOHYmD8FWx2e
         1tmyge1QHZWljLoR2ArNOZ4EJFABP4VSVFz7zAbcMeqV1EjA/m8XNZhw1pRzQb+g5X/Q
         k6MTYI5JdyHe/e4hfN6s51T/NkKRD9qVC+ig3mARZtulqMxxMHi26mJ0mVuMaZ7lE/hT
         8hvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750100422; x=1750705222;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jFNCP/Zfjf0zOYYsP29CukZPsGtgXo87gr1Y7z6mt20=;
        b=b3Z4vKgSMu1CPSiIw27nyz8pMca6qwkE/0qy/C6lAS7QyMmtFa715qeJe8CnyaXEyr
         QZ1/nAzwACsw2lq3pRFRS+NS9/rzqIG8PwJTeJ9sKyUk0HrbFzxkgI36z6ijqKmYI8vr
         XSnpO6gcxnPC1c6TLeinabaHoWZ+xo3x7qDCzx3BcuUZZF5MMYuuXv9Wj0NEEiRLczGB
         lOPlYY8ljDU64ax4BYWJ50nT5YQRdkhftz4p7Acn3+oFMJdkivp4+Wmg5jzaK5nPki3G
         hDfGKVLh5P9sx2l9py3IB9GoPGuSL+ZHNtKgAfQWgcdDN8KoSqy7Kif/zRXA86FQlPkS
         JBuQ==
X-Gm-Message-State: AOJu0Yw9A1LLXaT0HnQSiwTQKa2gvFffOiy/XOD3qwZXak63CA5L1HyB
	zJuIVOMSWFIXCxAgyPc5b9t8RPsa1+fcyvJoMxONE/TFWX+EVH+jxM4zc5Zg7xlTbhiwxk+42pk
	cBB7LhvvrNHAjroIY3sBOPn2kSg==
X-Google-Smtp-Source: AGHT+IGSEuQN3aX5jJ+hJ9qbwRUdVZknufgr0wwISVat/2IXLjOni3lc/rfWow0P9ZS5mdJZ7txhZ0mkCZ6P5oOqvA==
X-Received: from plap10.prod.google.com ([2002:a17:902:f08a:b0:220:ca3c:96bc])
 (user=salomondush job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ce89:b0:220:c164:6ee1 with SMTP id d9443c01a7336-2366b3dd319mr170509295ad.32.1750100421812;
 Mon, 16 Jun 2025 12:00:21 -0700 (PDT)
Date: Mon, 16 Jun 2025 19:00:18 +0000
In-Reply-To: <20250612212504.512786-1-salomondush@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250612212504.512786-1-salomondush@google.com>
X-Mailer: git-send-email 2.50.0.rc2.701.gf1e915cc24-goog
Message-ID: <20250616190018.2136260-1-salomondush@google.com>
Subject: [PATCH v3] scsi: pm80xx: add controller scsi host fatal error uevents
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
- Same intention as v2 but actually includes the changes to fix build
  warnings

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
index 5b373c53c036..d1741a2ea07c 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1551,6 +1551,52 @@ static int mpi_uninit_check(struct pm8001_hba_info *pm8001_ha)
 	return 0;
 }
 
+/**
+ * pm80xx_fatal_error_uevent_emit - emits a single fatal error uevent
+ * @pm8001_ha: our hba card information
+ * @error_reporter: reporter of fatal error
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

