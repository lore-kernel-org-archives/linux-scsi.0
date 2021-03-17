Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBACFC433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EE6A64F37
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhCQI5S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbhCQI5J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 04:57:09 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DDAC061760
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:09 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id o16so969826wrn.0
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nA9wVETTE+l5uPS+DZDdIXSJ2iBKhK6p+7XSOzWKHSU=;
        b=IpdBPhyKk00RIO/U1dBVMIyjhNggRxNiKxQ1Ne9aLwjQov2ko42z2b8zf+M/92BgHo
         N5pApE/eK+0PFoBnBqxtgT6un/LSFXhA/iRRslyBIqR29bg0esYI2FXihV/fXvXUN30I
         43XxadPKXofRgd9zY/tiTjp0k2UHCD0iFkMhyRlBn0p4MAHe+d8pkPfUKKIVuM6KybBc
         A1nSNpEiXGPu/50pqUkBoTAf7NRMuHDu2iwAE6lFShqzy8FtJAsS/3XXPmtZZQF6qf/c
         suOCldk6SO6n1k2Cjbb4P4EzRLMJR5TxXtz98N+rg83PMBujGKfYpD9GUBNAlFqE8nL+
         oZLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nA9wVETTE+l5uPS+DZDdIXSJ2iBKhK6p+7XSOzWKHSU=;
        b=P5v4UqtWoJBQgGnM4G+7RMq8g4AoHGCrPvNf9EuMUEnhnNcSgQatI12AnyN/RiF+zW
         IReV9wv7DktW2RKZC6pZ0Vpfr3DgaNAmKVyMGc+HzvbSlgJ9jgRXCiPviw46OmQiEb/z
         vAUz2X9tiDapyMFlp4e7nH9Cr8ykP6VGzanqWcJHsJ0Wh+aHuJpWt7t9bCJohwrWHAEa
         vn2sDW6dK2MQt+2KPS1JIWLjE6x/iMljNFQnSQsAJWYVwQQGQyYMbWxVeyiP89FdOT17
         HOqb1+tUCmx/M5iJKZ8wb8eA+Bt/Ju1j/OFov5iQkxvhDjFCT82sXDQGcVlknnhOx/MZ
         oBSA==
X-Gm-Message-State: AOAM53272xNLZ347sOdGdYKFyDg3gkjQbdD6it5078FRH4GoIk3A8dt9
        iSsL4cY3XTR0zyvdVy/Z9TObEQ==
X-Google-Smtp-Source: ABdhPJzcfW5vsBPQIw18Etx1koK5A46+8gpgVbmzPhoOyR9LddKs/Y713OCbzU6GInd9sSgZFBiXWA==
X-Received: by 2002:adf:ecca:: with SMTP id s10mr3123127wro.324.1615971427969;
        Wed, 17 Mar 2021 01:57:07 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id j123sm1807243wmb.1.2021.03.17.01.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 01:57:07 -0700 (PDT)
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
Subject: [PATCH 02/18] scsi: mpt3sas: mpt3sas_scs: Move a little data from the stack onto the heap
Date:   Wed, 17 Mar 2021 08:56:45 +0000
Message-Id: <20210317085701.2891231-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317085701.2891231-1-lee.jones@linaro.org>
References: <20210317085701.2891231-1-lee.jones@linaro.org>
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

