Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85CFCC433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61F3864E62
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351766AbhCDAc4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:32:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237996AbhCCOxX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:53:23 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17BFC061760
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:48:16 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id u187so5394230wmg.4
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nA9wVETTE+l5uPS+DZDdIXSJ2iBKhK6p+7XSOzWKHSU=;
        b=hlS4E2IDwIa1PMDMgxwXk7gU4hEHRXkOuLGlqiLu4q8Vnuj6pH7JtS/qQLVXpnKl90
         jnGBdcO/Gr4aSLGNkDEUBG8KLMfkXL2zN6cOZp73fWqZ0o+YTbhOcJE8ED7cHKeemwqw
         w3cBksK1PxnCZnTJgzjSLZ5+B/h5Rn4kOFnHn3XDR4h9TnP80XIoIoxZ/hrQM2RU6z3r
         faXhSuWnEe89E/lKDVJYBfI6yXz5XWNzg4EDOrlv7ubnqClNVacBehfpGyFoJ4uG13KW
         iWEvpR4Xp21nuOsQnDaCMSp+CAIFQiWhrj2uw/U1x+Z5ddWrHb+z3Cyb8CNWnm5JU0wH
         UDxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nA9wVETTE+l5uPS+DZDdIXSJ2iBKhK6p+7XSOzWKHSU=;
        b=sGa23fH+uHJQIspNuizspXebT1HGhmlfdPSFLuOjRWr9w7m/rym53fCZTOkPWZ4ydJ
         H8y2m2NnKFoBBpGPY4acNQ/S81AHNS2xVpb8ajRrIUZ9OKjhi+QeOtYFHoQIWF/A2nIJ
         qhmo2mmLiOb6yjxs1NQXzOgc+1ubb4W9Xhe3cPkFbioP/eAtFpFZZAJ6QO+9wVHFG1KQ
         0gq0fK8LvtPJRu/WyjzQgr4n3Tehp0DOnP5D41EmK4AZCP4YDQATHGNMSXRhm8GcHUlu
         /SJvb8Tr7GrtWLuEONOlsqB+QnU63E7v3YWlt2gDmvCap9b1NQyRgrnZp/YieVZRZxgw
         kiOQ==
X-Gm-Message-State: AOAM530Isu0iqT71yPdynbjAp8R1lthd/wYzuiHTNfdRmIYhEnNsnSIl
        QceNNC0tNTIeAPuk3LwRgj79UQ==
X-Google-Smtp-Source: ABdhPJxDDcx0g9CaC/EPknkMQfkF94FQ1DT/mhH9ELNTWFxUSu+zitclXAEe8hBFA3H3IpwbEltmTQ==
X-Received: by 2002:a1c:8005:: with SMTP id b5mr9580831wmd.130.1614782878600;
        Wed, 03 Mar 2021 06:47:58 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:47:50 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@avagotech.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH 30/30] scsi: mpt3sas: mpt3sas_scs: Move a little data from the stack onto the heap
Date:   Wed,  3 Mar 2021 14:46:31 +0000
Message-Id: <20210303144631.3175331-31-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/mpt3sas/mpt3sas_scsih.c: In function ‘_scsih_scan_for_devices_after_reset’:
 drivers/scsi/mpt3sas/mpt3sas_scsih.c:10473:1: warning: the frame size of 1064 bytes is larger than 1024 bytes [-Wframe-larger-than=]

Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: MPT-FusionLinux.pdl@avagotech.com
Cc: MPT-FusionLinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 38 +++++++++++++++++++---------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 7bd0a57e5b928..945531e94d7e4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -10219,8 +10219,8 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 	Mpi2ExpanderPage0_t expander_pg0;
 	Mpi2SasDevicePage0_t sas_device_pg0;
 	Mpi26PCIeDevicePage0_t pcie_device_pg0;
-	Mpi2RaidVolPage1_t volume_pg1;
-	Mpi2RaidVolPage0_t volume_pg0;
+	Mpi2RaidVolPage1_t *volume_pg1;
+	Mpi2RaidVolPage0_t *volume_pg0;
 	Mpi2RaidPhysDiskPage0_t pd_pg0;
 	Mpi2EventIrConfigElement_t element;
 	Mpi2ConfigReply_t mpi_reply;
@@ -10235,6 +10235,16 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 	u8 retry_count;
 	unsigned long flags;
 
+	volume_pg0 = kzalloc(sizeof(*volume_pg0), GFP_KERNEL);
+	if (!volume_pg0)
+		return;
+
+	volume_pg1 = kzalloc(sizeof(*volume_pg1), GFP_KERNEL);
+	if (!volume_pg1) {
+		kfree(volume_pg0);
+		return;
+	}
+
 	ioc_info(ioc, "scan devices: start\n");
 
 	_scsih_sas_host_refresh(ioc);
@@ -10344,7 +10354,7 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 	/* volumes */
 	handle = 0xFFFF;
 	while (!(mpt3sas_config_get_raid_volume_pg1(ioc, &mpi_reply,
-	    &volume_pg1, MPI2_RAID_VOLUME_PGAD_FORM_GET_NEXT_HANDLE, handle))) {
+	    volume_pg1, MPI2_RAID_VOLUME_PGAD_FORM_GET_NEXT_HANDLE, handle))) {
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
 		    MPI2_IOCSTATUS_MASK;
 		if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
@@ -10352,15 +10362,15 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 				 ioc_status, le32_to_cpu(mpi_reply.IOCLogInfo));
 			break;
 		}
-		handle = le16_to_cpu(volume_pg1.DevHandle);
+		handle = le16_to_cpu(volume_pg1->DevHandle);
 		spin_lock_irqsave(&ioc->raid_device_lock, flags);
 		raid_device = _scsih_raid_device_find_by_wwid(ioc,
-		    le64_to_cpu(volume_pg1.WWID));
+		    le64_to_cpu(volume_pg1->WWID));
 		spin_unlock_irqrestore(&ioc->raid_device_lock, flags);
 		if (raid_device)
 			continue;
 		if (mpt3sas_config_get_raid_volume_pg0(ioc, &mpi_reply,
-		    &volume_pg0, MPI2_RAID_VOLUME_PGAD_FORM_HANDLE, handle,
+		    volume_pg0, MPI2_RAID_VOLUME_PGAD_FORM_HANDLE, handle,
 		     sizeof(Mpi2RaidVolPage0_t)))
 			continue;
 		ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
@@ -10370,17 +10380,17 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 				 ioc_status, le32_to_cpu(mpi_reply.IOCLogInfo));
 			break;
 		}
-		if (volume_pg0.VolumeState == MPI2_RAID_VOL_STATE_OPTIMAL ||
-		    volume_pg0.VolumeState == MPI2_RAID_VOL_STATE_ONLINE ||
-		    volume_pg0.VolumeState == MPI2_RAID_VOL_STATE_DEGRADED) {
+		if (volume_pg0->VolumeState == MPI2_RAID_VOL_STATE_OPTIMAL ||
+		    volume_pg0->VolumeState == MPI2_RAID_VOL_STATE_ONLINE ||
+		    volume_pg0->VolumeState == MPI2_RAID_VOL_STATE_DEGRADED) {
 			memset(&element, 0, sizeof(Mpi2EventIrConfigElement_t));
 			element.ReasonCode = MPI2_EVENT_IR_CHANGE_RC_ADDED;
-			element.VolDevHandle = volume_pg1.DevHandle;
+			element.VolDevHandle = volume_pg1->DevHandle;
 			ioc_info(ioc, "\tBEFORE adding volume: handle (0x%04x)\n",
-				 volume_pg1.DevHandle);
+				 volume_pg1->DevHandle);
 			_scsih_sas_volume_add(ioc, &element);
 			ioc_info(ioc, "\tAFTER adding volume: handle (0x%04x)\n",
-				 volume_pg1.DevHandle);
+				 volume_pg1->DevHandle);
 		}
 	}
 
@@ -10468,6 +10478,10 @@ _scsih_scan_for_devices_after_reset(struct MPT3SAS_ADAPTER *ioc)
 		ioc_info(ioc, "\tAFTER adding pcie end device: handle (0x%04x), wwid(0x%016llx)\n",
 			 handle, (u64)le64_to_cpu(pcie_device_pg0.WWID));
 	}
+
+	kfree(volume_pg0);
+	kfree(volume_pg1);
+
 	ioc_info(ioc, "\tpcie devices: pcie end devices complete\n");
 	ioc_info(ioc, "scan devices: complete\n");
 }
-- 
2.27.0

