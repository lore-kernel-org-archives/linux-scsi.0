Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F71C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 12:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237522AbiEXM6A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 08:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiEXM57 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 08:57:59 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2C05468A
        for <linux-scsi@vger.kernel.org>; Tue, 24 May 2022 05:57:57 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id dm17so14169434qvb.2
        for <linux-scsi@vger.kernel.org>; Tue, 24 May 2022 05:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kb1mLsnEPg9LHB/dpaTnZQ5qNTHichW7Na/vRvpx7U0=;
        b=PhzfTjgh5dAOyOdPeCGUbHHP58wNBvmG7Hx4ubA9A4YcXincVF41Q9wzo14zA5lQwL
         +OvGrDHXXH2znojBEF2hvjmgpWhDv3KiK0k5tvZv12hkfp79znFv4dA4HDlJcJuw67D/
         2woWVymCLJOOcCELbDn0Zm+SdQsomtnb/TDPvCk9Zu0dVdBA9scIsZOo3Imaj1wgvxnl
         8pNo9bJrQvpDFPpIQXVZWeO0rXLRmmDMZffSMEeskqsjoSO6ah6GPzprEv10UE30I8bB
         k+1KilGd3U51psLoNZTnom5m2cYzYA7j/XbT2V5vfW4WtNJMfAyH/3f8o3Pb8VYvNTWX
         +byQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kb1mLsnEPg9LHB/dpaTnZQ5qNTHichW7Na/vRvpx7U0=;
        b=atmxWdcW9SLpUamZlip3eOJjCoEVXBG6XZjCe9eMKqlxf3Xddb/M6zVc0T954m8jhw
         paSWH9lPf2Y7kpFKywqqqXMRc/yYkdTx8wZwF8wRq9VBZ/Wk7LBjwqf3OZUCKNIsAXcb
         fk2uZkmSKKF3icStOVznUnoOno6kZABdTqKZ1wsBTejQK8FKxjpSMF8jtqFz7n5ZMhXl
         7TBqQ7jnbFMb8XiwFUQMrqzazDStX9z9s0leT+gfNuxrYpVHxwlHzWi+OEpa9zHKPbBF
         4flddfVwDrfMuLH1cdtDjXCdQJaaUpnFxrxFPVwyJQziyQUp08LePre3TNbqmqEIH2SZ
         qRRw==
X-Gm-Message-State: AOAM532NzQbgWRVKrR8h1vKtVlN0NnBryM/Kco67Z6/JdCn0kwzNqekM
        iEW/UwqcPyHSUQPo3CutxUvUquQ8IpYCVQ==
X-Google-Smtp-Source: ABdhPJwAMHJS7MtMxsUT+rcsHt9l3CGLinVjOYeaz4NTmc7l2ljA++33zKUZuVSuXAZ3/AWZ50RPjg==
X-Received: by 2002:a05:6214:f26:b0:462:844:b06e with SMTP id iw6-20020a0562140f2600b004620844b06emr17694260qvb.34.1653397076889;
        Tue, 24 May 2022 05:57:56 -0700 (PDT)
Received: from centos7-test-jenkins.localdomain (sw.attotech.com. [208.69.85.34])
        by smtp.googlemail.com with ESMTPSA id br11-20020a05622a1e0b00b002f39b99f6acsm6025969qtb.70.2022.05.24.05.57.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 May 2022 05:57:56 -0700 (PDT)
From:   Bradley Grove <bradley.grove@gmail.com>
X-Google-Original-From: Bradley Grove <bgrove@attotech.com>
To:     linux-scsi@vger.kernel.org
Cc:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        Bradley Grove <bgrove@attotech.com>,
        Jason Seba <jseba@attotech.com>
Subject: [PATCH REPOST] scsi: lpfc: Add support for ATTO Fibre Channel devices
Date:   Tue, 24 May 2022 08:56:21 -0400
Message-Id: <20220524125621.47102-1-bgrove@attotech.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update pci_device_id table and generate reporting strings for ATTO
Celerity and ThunderLink Fibre Channel devices.

Co-developed-by: Jason Seba <jseba@attotech.com>
Signed-off-by: Jason Seba <jseba@attotech.com>
Signed-off-by: Bradley Grove <bgrove@attotech.com>
---
 drivers/scsi/lpfc/lpfc_hw.h   | 22 +++++++++
 drivers/scsi/lpfc/lpfc_ids.h  | 30 ++++++++++++
 drivers/scsi/lpfc/lpfc_init.c | 89 +++++++++++++++++++++++++++++++++++
 3 files changed, 141 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index d6050f3c9efe..74a02586fe55 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1738,6 +1738,28 @@ struct lpfc_fdmi_reg_portattr {
 #define PCI_DEVICE_ID_TOMCAT        0x0714
 #define PCI_DEVICE_ID_SKYHAWK       0x0724
 #define PCI_DEVICE_ID_SKYHAWK_VF    0x072c
+#define PCI_VENDOR_ID_ATTO          0x117c
+#define PCI_DEVICE_ID_CLRY_16XE     0x0064
+#define PCI_DEVICE_ID_CLRY_161E     0x0063
+#define PCI_DEVICE_ID_CLRY_162E     0x0064
+#define PCI_DEVICE_ID_CLRY_164E     0x0065
+#define PCI_DEVICE_ID_CLRY_16XP     0x0094
+#define PCI_DEVICE_ID_CLRY_161P     0x00a0
+#define PCI_DEVICE_ID_CLRY_162P     0x0094
+#define PCI_DEVICE_ID_CLRY_164P     0x00a1
+#define PCI_DEVICE_ID_CLRY_32XE     0x0094
+#define PCI_DEVICE_ID_CLRY_321E     0x00a2
+#define PCI_DEVICE_ID_CLRY_322E     0x00a3
+#define PCI_DEVICE_ID_CLRY_324E     0x00ac
+#define PCI_DEVICE_ID_CLRY_32XP     0x00bb
+#define PCI_DEVICE_ID_CLRY_321P     0x00bc
+#define PCI_DEVICE_ID_CLRY_322P     0x00bd
+#define PCI_DEVICE_ID_CLRY_324P     0x00be
+#define PCI_DEVICE_ID_TLFC_2        0x0064
+#define PCI_DEVICE_ID_TLFC_2XX2     0x4064
+#define PCI_DEVICE_ID_TLFC_3        0x0094
+#define PCI_DEVICE_ID_TLFC_3162     0x40a6
+#define PCI_DEVICE_ID_TLFC_3322     0x40a7
 
 #define JEDEC_ID_ADDRESS            0x0080001c
 #define FIREFLY_JEDEC_ID            0x1ACC
diff --git a/drivers/scsi/lpfc/lpfc_ids.h b/drivers/scsi/lpfc/lpfc_ids.h
index 6a90e6e53d09..a1b9be245560 100644
--- a/drivers/scsi/lpfc/lpfc_ids.h
+++ b/drivers/scsi/lpfc/lpfc_ids.h
@@ -124,5 +124,35 @@ const struct pci_device_id lpfc_id_table[] = {
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SKYHAWK_VF,
 		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_16XE,
+		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_161E, },
+	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_16XE,
+		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_162E, },
+	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_16XE,
+		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_164E, },
+	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_16XP,
+		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_161P, },
+	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_16XP,
+		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_162P, },
+	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_16XP,
+		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_164P, },
+	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_32XE,
+		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_321E, },
+	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_32XE,
+		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_322E, },
+	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_32XE,
+		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_324E, },
+	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_32XP,
+		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_321P, },
+	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_32XP,
+		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_322P, },
+	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_32XP,
+		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_CLRY_324P, },
+	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_TLFC_2,
+		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_TLFC_2XX2, },
+	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_TLFC_3,
+		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_TLFC_3162, },
+	{PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_TLFC_3,
+		PCI_VENDOR_ID_ATTO, PCI_DEVICE_ID_TLFC_3322, },
 	{ 0 }
 };
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 461d333b1b3a..45a71ab55be8 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2408,6 +2408,90 @@ lpfc_parse_vpd(struct lpfc_hba *phba, uint8_t *vpd, int len)
 	return(1);
 }
 
+/**
+ * lpfc_get_atto_model_desc - Retrieve ATTO HBA device model name and description
+ * @phba: pointer to lpfc hba data structure.
+ * @mdp: pointer to the data structure to hold the derived model name.
+ * @descp: pointer to the data structure to hold the derived description.
+ *
+ * This routine retrieves HBA's description based on its registered PCI device
+ * ID. The @descp passed into this function points to an array of 256 chars. It
+ * shall be returned with the model name, maximum speed, and the host bus type.
+ * The @mdp passed into this function points to an array of 80 chars. When the
+ * function returns, the @mdp will be filled with the model name.
+ **/
+static void
+lpfc_get_atto_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
+{
+	uint16_t sub_dev_id = phba->pcidev->subsystem_device;
+	char *model = "<Unknown>";
+	int tbolt = 0;
+
+	switch (sub_dev_id) {
+	case PCI_DEVICE_ID_CLRY_161E:
+		model = "161E";
+		break;
+	case PCI_DEVICE_ID_CLRY_162E:
+		model = "162E";
+		break;
+	case PCI_DEVICE_ID_CLRY_164E:
+		model = "164E";
+		break;
+	case PCI_DEVICE_ID_CLRY_161P:
+		model = "161P";
+		break;
+	case PCI_DEVICE_ID_CLRY_162P:
+		model = "162P";
+		break;
+	case PCI_DEVICE_ID_CLRY_164P:
+		model = "164P";
+		break;
+	case PCI_DEVICE_ID_CLRY_321E:
+		model = "321E";
+		break;
+	case PCI_DEVICE_ID_CLRY_322E:
+		model = "322E";
+		break;
+	case PCI_DEVICE_ID_CLRY_324E:
+		model = "324E";
+		break;
+	case PCI_DEVICE_ID_CLRY_321P:
+		model = "321P";
+		break;
+	case PCI_DEVICE_ID_CLRY_322P:
+		model = "322P";
+		break;
+	case PCI_DEVICE_ID_CLRY_324P:
+		model = "324P";
+		break;
+	case PCI_DEVICE_ID_TLFC_2XX2:
+		model = "2XX2";
+		tbolt = 1;
+		break;
+	case PCI_DEVICE_ID_TLFC_3162:
+		model = "3162";
+		tbolt = 1;
+		break;
+	case PCI_DEVICE_ID_TLFC_3322:
+		model = "3322";
+		tbolt = 1;
+		break;
+	default:
+		model = "Unknown";
+		break;
+	}
+
+	if (mdp && mdp[0] == '\0')
+		snprintf(mdp, 79, "%s", model);
+
+	if (descp && descp[0] == '\0')
+		snprintf(descp, 255,
+			 "ATTO %s%s, Fibre Channel Adapter Initiator, Port %s",
+			 (tbolt) ? "ThunderLink FC " : "Celerity FC-",
+			 model,
+			 phba->Port);
+}
+
 /**
  * lpfc_get_hba_model_desc - Retrieve HBA device model name and description
  * @phba: pointer to lpfc hba data structure.
@@ -2438,6 +2522,11 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 		&& descp && descp[0] != '\0')
 		return;
 
+	if (phba->pcidev->vendor == PCI_VENDOR_ID_ATTO) {
+		lpfc_get_atto_model_desc(phba, mdp, descp);
+		return;
+	}
+
 	if (phba->lmt & LMT_64Gb)
 		max_speed = 64;
 	else if (phba->lmt & LMT_32Gb)
-- 
2.36.0

