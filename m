Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 480D4C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 16:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356115AbiELQle (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 12:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356685AbiELQlY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 12:41:24 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4264A3AA4F
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 09:41:23 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id x22so4895641qto.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 09:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kb1mLsnEPg9LHB/dpaTnZQ5qNTHichW7Na/vRvpx7U0=;
        b=aUi2sq3YHzq+s+N1ugHMNzcB8S+klH+HeJtSHRhYQrEbFgoiOz+So8xzYFEYyUWD5k
         /uf2HvBYsfd1B8YzWtWSglqDloUfZaGQrrG7zrK1x917jIinm4oNEx5QDV5ik0EGcuJW
         Lp0UJzjdmVaCR82gIPf3PPZqzK6XKt+GXpr/572KBlD3uIQkF2DcckVMoqbDlKm/uJ5q
         /pArUGWAE5QtQ4ORb1J/kgQWIARlfNat0FVp42lcbMr1qgM8bwt26UUv3go7q/ANqwf8
         X/ZuqbcIp+moZNeAG2dr/74mhHZP9sQptNX1ftBJXwPYM75f5ARD0eiG1UOsgdAS7ZkH
         1Xog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kb1mLsnEPg9LHB/dpaTnZQ5qNTHichW7Na/vRvpx7U0=;
        b=RKvbD7b/2fcuagDkUelDgMlKX/H5+HZ/BVWS1J4g27Phi/TtGx7CZlAL9swMVxwP62
         HBJyiNG/OhUaGJtX+vTzHqPyEFFScSsU0ora0MUoBGTw3N+XrAr9FNyCydSwD2Oz00os
         SE841c8+QWd38ItTvU0Vs7nZGVJFDgZlphCJ4w2Q1MUuhk4fDs0m/zO7g8ysblKtp7xJ
         VpAFKNVcdJTZUDj2pGiTauCcfHcizGBSB5vIUNotSXow4HaFmeK2ZkMgesgJVk2GqyhP
         l8NAw3CuqcDEUDapl7JC4waJ9PzWu2ZQWob7+C6KiQqG7zZ6SMrzTMh0+iCflGXhMIWS
         vRgg==
X-Gm-Message-State: AOAM532i9zc7Kn3Z7FkfQTSOVFmsWklrDJedjYDhg9WstaSCn1RLYaVE
        Sz6wUp8n93TLQq0aI+IvY3oiW9tzduwNpw==
X-Google-Smtp-Source: ABdhPJyqXeWloROcf8QAZcmJRZ5zXnkrOg5q4x1XQ/WlOOu6B/ya3qpAnJxEAWHaGgdt514XReTwWQ==
X-Received: by 2002:ac8:7fd1:0:b0:2f3:dddb:4206 with SMTP id b17-20020ac87fd1000000b002f3dddb4206mr628862qtk.11.1652373681716;
        Thu, 12 May 2022 09:41:21 -0700 (PDT)
Received: from centos7-test-jenkins.localdomain (sw.attotech.com. [208.69.85.34])
        by smtp.googlemail.com with ESMTPSA id d12-20020ac847cc000000b002f39b99f66dsm31522qtr.7.2022.05.12.09.41.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 May 2022 09:41:20 -0700 (PDT)
From:   Bradley Grove <bradley.grove@gmail.com>
X-Google-Original-From: Bradley Grove <bgrove@attotech.com>
To:     linux-scsi@vger.kernel.org
Cc:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        Bradley Grove <bgrove@attotech.com>,
        Jason Seba <jseba@attotech.com>
Subject: [PATCH] scsi: lpfc: Add support for ATTO Fibre Channel devices
Date:   Thu, 12 May 2022 12:40:32 -0400
Message-Id: <20220512164032.47943-1-bgrove@attotech.com>
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

