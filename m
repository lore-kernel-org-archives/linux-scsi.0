Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F79125B9
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 22:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729116628; cv=none; b=O8zfoiRIQeobSs7k0PWBd5J0WQCRx0NiY1grySIdK0HMUl56A0EmSzpVuEaQ2ErOgn2E+ShDjQXqXNjDTwEtYphu5IrUnA76xIyIsEVdAqRYWKut7ZLM/pKWmcv24jFAHGMCZepOZDfqnJP9ocXp3fgQejOXiKBn0rUSQIAlZVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729116628; c=relaxed/simple;
	bh=CK4VWdudhelvUqm7tQcSDksX8X/WQLaJJkyq5R5klkc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=DWOxMuT9mOl0vRVLJHP0UxpptRBy/IOm75jENyc0vBo1lgidW+/76onl+jNnBRMbCVwN0LHFQdq56n7ui8h9BDHvGKC65jIbiI1VGH0+4f0rcSGfe5bab4AUqS2iXmifWV4RXUz7K3DT/ZixTo+viUEOXiKvK1m1Ei3FNAM6RIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--salomondush.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RtWID5IZ; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--salomondush.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RtWID5IZ"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6e35199eb2bso7655717b3.3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 15:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729116626; x=1729721426; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lZiu62o/7045anfstaI8NvPpSySBajpQRHA6+l9nLho=;
        b=RtWID5IZ0DlE9TOfCCYB2GkhIn9GQmYf2Rl/qcLA/4amtTOpY0cTpHMqOU1jzHJ19v
         jtoot63ktb5wUKGzmrd2APnNLAkZnfm4n5SmJh8VqY65YlS96S6ByOtDzNT4iHJY+67Z
         CyzfNsJM2qIcrxaKPwb0f3Nbb/JxK/MGuF9uhfZOemTBH5creDmjppZQH5gZ2C3itUF2
         xCCulvoQg6aTU0n/ggY1e2Gp0Ch5TOgYjUCGOKLALorhYh/93chkYJ8o5AGKeG3ow4v9
         AM5widd+bSjlDgAE7xP0KzIB23bcZDkYgvLP9kS/Ul0Eo8cDo5n47H6S5mnzhorECzrZ
         6xdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729116626; x=1729721426;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lZiu62o/7045anfstaI8NvPpSySBajpQRHA6+l9nLho=;
        b=SEkBLV9aexvG4Vqamkq67nfNizVDPzFDs1LJNcexrtc7499yLwL7WELIJgX4MEFWUD
         HUk4RRHcMtFF7K4P1ykcJjIDUwyeLKX4/JsFsgw0xNPxmAH/jqPbuFgPypxYGpSmhur9
         fwYeXccxzHtWiUvoexOPdEioutM8kbHiZGz+BDgpF5DY5DnqwB1fG9MkjeXJjKz1JHs+
         XQTr+PtP8pxkAXV492hGgy5F0QZJPqO7E2S/aDDq3O21R0daI6wtIdIbMDzkIv2rJov4
         GeNPGP2F0amlBveoVd3a9Xes/KoIYtc6PsAHj60T8Ggw+sb9lgvEldeTOhP2C8aYCFfT
         cQbw==
X-Gm-Message-State: AOJu0YzGjp3UMo4yicf5zxmmxN5f7/w1C3PnYAGPsbK4WEUWOadPb3yW
	UomX3kRLsN2ECeBll7UR57JiyNMNdOnho9A6ft2QXQyfv9gIRCFGEXQ7fJ9ibItWDn83QFllwUO
	w1AQXDz25TZ85/iiD/J8rVQ==
X-Google-Smtp-Source: AGHT+IGg/WZICZ+4ereZN6UT2TjwtFXb6guAfrgRgmN/R8YLtp3gH1JMOCC01mgll8Igly/h9R5xKnWFqdXL9T4K6Q==
X-Received: from salomondush.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:3cf9])
 (user=salomondush job=sendgmr) by 2002:a05:690c:7207:b0:6db:afa4:75d3 with
 SMTP id 00721157ae682-6e3d41df5a9mr1412277b3.3.1729116626059; Wed, 16 Oct
 2024 15:10:26 -0700 (PDT)
Date: Wed, 16 Oct 2024 22:09:44 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241016220944.370539-1-salomondush@google.com>
Subject: [PATCH] scsi: pm80xx: Use module param to set pcs event log severity
From: Salomon Dushimirimana <salomondush@google.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Salomon Dushimirimana <salomondush@google.com>, Bhavesh Jashnani <bjashnani@google.com>
Content-Type: text/plain; charset="UTF-8"

The pm8006 driver sets pcs event log threshold very high which causes
most of the FW logs to not be captured. This adds a module parameter to
configure pcs event log severity with 3 (medium severity) as the
default.

Signed-off-by: Bhavesh Jashnani <bjashnani@google.com>
Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 4 ++++
 drivers/scsi/pm8001/pm8001_sas.h  | 2 ++
 drivers/scsi/pm8001/pm80xx_hwi.c  | 3 ++-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 1e63cb6cd8e3..355aab0c982a 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -68,6 +68,10 @@ static bool pm8001_read_wwn = true;
 module_param_named(read_wwn, pm8001_read_wwn, bool, 0444);
 MODULE_PARM_DESC(zoned, "Get WWN from the controller. Default: true");
 
+uint pcs_event_log_severity = 0x03;
+module_param(pcs_event_log_severity, int, 0644);
+MODULE_PARM_DESC(pcs_event_log_severity, "PCS event log severity level");
+
 static struct scsi_transport_template *pm8001_stt;
 static int pm8001_init_ccb_tag(struct pm8001_hba_info *);
 
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index ced6721380a8..42c7b3f7afbf 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -96,6 +96,8 @@ extern struct list_head hba_list;
 extern const struct pm8001_dispatch pm8001_8001_dispatch;
 extern const struct pm8001_dispatch pm8001_80xx_dispatch;
 
+extern uint pcs_event_log_severity;
+
 struct pm8001_hba_info;
 struct pm8001_ccb_info;
 struct pm8001_device;
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 8fe886dc5e47..9b237a764d0b 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -763,7 +763,8 @@ static void init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 		pm8001_ha->memoryMap.region[IOP].phys_addr_lo;
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.pcs_event_log_size		=
 							PM8001_EVENT_LOG_SIZE;
-	pm8001_ha->main_cfg_tbl.pm80xx_tbl.pcs_event_log_severity	= 0x01;
+	pm8001_ha->main_cfg_tbl.pm80xx_tbl.pcs_event_log_severity	=
+		pcs_event_log_severity;
 	pm8001_ha->main_cfg_tbl.pm80xx_tbl.fatal_err_interrupt		= 0x01;
 
 	/* Enable higher IQs and OQs, 32 to 63, bit 16 */
-- 
2.47.0.rc1.288.g06298d1525-goog

