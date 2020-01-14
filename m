Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0224AC33CB1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 11:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9CA92467C
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 11:22:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="RkGZFdWl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgANLWY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 06:22:24 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53614 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgANLWY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jan 2020 06:22:24 -0500
Received: by mail-wm1-f66.google.com with SMTP id m24so13295768wmc.3
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jan 2020 03:22:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=z6sVpfHB0MDg8NyfZfTVituXAI9osDrx/fsG2PvjF6s=;
        b=RkGZFdWl4HcS2fcMKIW6CzsuNMDtyJIq8ccf+C42lGZX6RvK0qpsAcH3BUjy4zzxSO
         W8/TqRcq+pJKnIQI25zEE0dx1oWwkAj+AFJ0vZ57B2WLbdcFsYS2viFipKK80BZ1wXkN
         jjDpWxU0sfyUckRgbJJD3btSaTxck53Ai5Sio=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=z6sVpfHB0MDg8NyfZfTVituXAI9osDrx/fsG2PvjF6s=;
        b=J+hErA8JOnipeLd3BEiLmtrFvxzHab7VfjkjMRI/Phmdy+8LCYxJRAUXtfMKg3MnhC
         VAMC2idjBL2m3ydc3CtDfbaGiUNc9bwnTAigscLKGe5i8LsHbQxDDmqHhlkIFsvAoAf7
         MDPfpNH8UxSuBNTmBepXE34QsKKnkJNq0Mff3Zoez4kIan7UcfmqX6xUUCb55T3uduvb
         KddBY3+NnAj6anLn6Nx7tDba7WePL7BVHDWFsBZAyhA4jZrptLMlzlSwLTkeml3aStKO
         8hz8KZmDewuiz1H+3axAus7DdzpGkuRrYyGIjEyGPe5Q1I7aaoOyuUCRsLxDjTnAlNHw
         /lrw==
X-Gm-Message-State: APjAAAWPIxUKm2qxeHcoSER64U3+swZi8t0SwVfUrQqBF6pVsX4kD5Xr
        GGnaMpJsWCcskH3WvY6/a3ARN4GoprWylxbvZ9QhBymxFfvKKkCL7xW0p1kg4gCw3+eRXr+IQez
        aqsrsi8ZDJYxzHm9eg5ic0c+NSJX8w+vHXWElISzfZ/bhU7acBXSe/yIv1lhzSnIJ3JwBoVdEE8
        wHPq/JxQ==
X-Google-Smtp-Source: APXvYqxr78nRzShyrfpfgBPkmUSexg+pjwmO5ovJ9QeK2aKvlaM/Z0FjPb33okUjEEgwoyGUMq7Jmw==
X-Received: by 2002:a1c:964f:: with SMTP id y76mr26056739wmd.62.1579000941991;
        Tue, 14 Jan 2020 03:22:21 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z21sm17638160wml.5.2020.01.14.03.22.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2020 03:22:21 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>
Subject: [PATCH v2 02/11] megaraid_sas: Set no_write_same only for Virtual Disk
Date:   Tue, 14 Jan 2020 16:51:13 +0530
Message-Id: <1579000882-20246-3-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
References: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Disable WRITE_SAME (no_write_same) for Virtual Disks only.
For System PDs and EPDs (Enhanced PDs), WRITE_SAME need not be disabled by
default.

Signed-off-by: Anand Lodnoor <anand.lodnoor@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   |  5 ++++-
 drivers/scsi/megaraid/megaraid_sas_fusion.h | 17 ++++++++++++++---
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 96b893f..8b9ecee 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1887,6 +1887,10 @@ void megasas_set_dynamic_target_properties(struct scsi_device *sdev,
 
 		mr_device_priv_data->is_tm_capable =
 			raid->capability.tmCapable;
+
+		if (!raid->flags.isEPD)
+			sdev->no_write_same = 1;
+
 	} else if (instance->use_seqnum_jbod_fp) {
 		pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
 			sdev->id;
@@ -3416,7 +3420,6 @@ static int megasas_reset_target(struct scsi_cmnd *scmd)
 	.bios_param = megasas_bios_param,
 	.change_queue_depth = scsi_change_queue_depth,
 	.max_segment_size = 0xffffffff,
-	.no_write_same = 1,
 };
 
 /**
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index c013c80..8358b68 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -864,9 +864,20 @@ struct MR_LD_RAID {
 	u8	regTypeReqOnRead;
 	__le16     seqNum;
 
-	struct {
-		u32 ldSyncRequired:1;
-		u32 reserved:31;
+struct {
+#ifndef MFI_BIG_ENDIAN
+	u32 ldSyncRequired:1;
+	u32 regTypeReqOnReadIsValid:1;
+	u32 isEPD:1;
+	u32 enableSLDOnAllRWIOs:1;
+	u32 reserved:28;
+#else
+	u32 reserved:28;
+	u32 enableSLDOnAllRWIOs:1;
+	u32 isEPD:1;
+	u32 regTypeReqOnReadIsValid:1;
+	u32 ldSyncRequired:1;
+#endif
 	} flags;
 
 	u8	LUN[8]; /* 0x24 8 byte LUN field used for SCSI IO's */
-- 
1.8.3.1

