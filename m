Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C35DC4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Oct 2023 18:59:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbjJaS7K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Oct 2023 14:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbjJaS7J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Oct 2023 14:59:09 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763B6E6
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2023 11:59:07 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1ca85ff26afso11041475ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2023 11:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698778747; x=1699383547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dQtbotzg2x+a6R9yFCDaJO3CuC1xbKUS9GOGH5x4dw8=;
        b=W5kMEgc2BNSN41+eVHReiejjwqAGrb5BZ3YIeykcj+DNuzy4/99tZDVrE9W/k0/mIP
         MFGhTUCj+f4IQp3vCPmWvcwQ0Xx0S7nj4SB7pDrvv0n28HHuuqF8LSDOrEKRrPdmVt1m
         Ac+Ci6d0kjxFK8TZahAtAvCg5UBcYW78I7gpsKKSR1bdkBSI42VBRMQtVzmUEndxvCmG
         deccz9d3xbpiweTxJU4SCx8OQ4dgOh48MNiZ6Fgj729G9yfl3n8mmfmy8bJ/qA0wcshJ
         oHKHJjWT6bP3C0GcwpwwYKv/PW3gYgi9SPS2NpmUjfEK2ZF9eNamAEhHbXaZNelbPT+W
         Rzng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698778747; x=1699383547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dQtbotzg2x+a6R9yFCDaJO3CuC1xbKUS9GOGH5x4dw8=;
        b=qbZTAfHegr0JD+Pz2CeUcJLHN4aimYJe7HmsIiXAJXziTQpmCZhPEtITv6/Sjr+u66
         nBspfLSu4l3UanydWeGEKk36x3O/0WlceCD7doFRDip9pym+6LKvQuIlIU5tjkG2lmlA
         xMicn7rPcp5Vr+udp7RSc7OhWzO6U2IGOHSa0duz+dZmySCUi3MxBQBNyIbH9BeayHiC
         W2fZEE3/wcZ5wiT23ilKHYQa4iht2zjm/IwVU/DwMQQZN9bXI6/O95IHsD5mYyUoQ0vd
         vM+R58lXoPd0PBr07MH+paQTW3fFbpg0+PzulA6tudNJuUy3lHSvOT80uDRH87Q3BIvJ
         O5Zw==
X-Gm-Message-State: AOJu0Ywg9RtcV+8dj5x0ECRenKW0iLeWwf4A/m368CV+w1gyaNlbMbzv
        rA2aWcrLeMxAjvnRxeUDer1km0MgpcM=
X-Google-Smtp-Source: AGHT+IEHmlTUkOh074CIL+ZWYXqkqVgOYLFXmHTeX5u6OIR3KofnxL4RDZIC7z24p3QUpp2hhwW6IQ==
X-Received: by 2002:a17:902:f214:b0:1cc:27fa:1fb7 with SMTP id m20-20020a170902f21400b001cc27fa1fb7mr11602594plc.5.1698778746692;
        Tue, 31 Oct 2023 11:59:06 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bh6-20020a170902a98600b001c9d6923e7dsm1628657plb.222.2023.10.31.11.59.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Oct 2023 11:59:06 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 2/9] lpfc: Fix possible file string name overflow when updating firmware
Date:   Tue, 31 Oct 2023 12:12:17 -0700
Message-Id: <20231031191224.150862-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20231031191224.150862-1-justintee8345@gmail.com>
References: <20231031191224.150862-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Because file_name and phba->ModelName are both declared a size 80 bytes,
the extra ".grp" file extension could cause an overflow into file_name.

Define a ELX_FW_NAME_SIZE macro with value 84.  84 incorporates the 4 extra
characters from ".grp".  file_name is changed to be declared as a char and
initialized to zeros i.e. null chars.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h      | 1 +
 drivers/scsi/lpfc/lpfc_init.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index af15f7a22d25..04d608ea9106 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -33,6 +33,7 @@
 struct lpfc_sli2_slim;
 
 #define ELX_MODEL_NAME_SIZE	80
+#define ELX_FW_NAME_SIZE	84
 
 #define LPFC_PCI_DEV_LP		0x1
 #define LPFC_PCI_DEV_OC		0x2
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 9e59c050103d..2c336953e56c 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -14725,7 +14725,7 @@ lpfc_write_firmware(const struct firmware *fw, void *context)
 int
 lpfc_sli4_request_firmware_update(struct lpfc_hba *phba, uint8_t fw_upgrade)
 {
-	uint8_t file_name[ELX_MODEL_NAME_SIZE];
+	char file_name[ELX_FW_NAME_SIZE] = {0};
 	int ret;
 	const struct firmware *fw;
 
@@ -14734,7 +14734,7 @@ lpfc_sli4_request_firmware_update(struct lpfc_hba *phba, uint8_t fw_upgrade)
 	    LPFC_SLI_INTF_IF_TYPE_2)
 		return -EPERM;
 
-	snprintf(file_name, ELX_MODEL_NAME_SIZE, "%s.grp", phba->ModelName);
+	scnprintf(file_name, sizeof(file_name), "%s.grp", phba->ModelName);
 
 	if (fw_upgrade == INT_FW_UPGRADE) {
 		ret = request_firmware_nowait(THIS_MODULE, FW_ACTION_UEVENT,
-- 
2.38.0

