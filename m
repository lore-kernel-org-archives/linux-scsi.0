Return-Path: <SRS0=yTIb=2Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B11AEC32767
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 11:35:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8759921835
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 11:35:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UxiOBejy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbgACLfT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jan 2020 06:35:19 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37113 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbgACLfS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2020 06:35:18 -0500
Received: by mail-pl1-f196.google.com with SMTP id c23so18975214plz.4
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jan 2020 03:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9bxekxxmVEWH+n0Pf9RmdTLqWDxkj4tNTKvqGNTMKug=;
        b=UxiOBejyG9k+ofEygWYV3Xl/WmINb1uaMm5Dfcn5I6NWv7u8TKIbeu2XrmvMXCsfuc
         25FtCdayhX4ULJSB49tuhtgtMEfW/kZeAqbWtDoLIHpaW10LJ8DyH0iXMK6zliy2/kKA
         sgnBq56H6u/qW9rLG7Dv9AYCp1/sfRyBsgx/U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9bxekxxmVEWH+n0Pf9RmdTLqWDxkj4tNTKvqGNTMKug=;
        b=RrqqcCFWdcDkGoEAtl7fyWmI83NHaub8VZiyDYZhptadEknxBC7M+mXEDojtZLVFQp
         oiL5nD//6y0NisOvy5W5cD24ePYCeI5ZPo86j/Xw9c8Pf0iHUvTuT2IKMam5546k3Odw
         VPR0vfVQXyUchRlAGT4HPw4PQi3to2WipHjWaf9Nx40JkTQQ0q6V52+fLX1YhfBTL7La
         KTfSMjSbglaVoVld/v/ZFV1ji7Mq7MesZzE4kIXzk0xgpGTvJjFknW4HXFurCdLqr+PI
         TmPH6nvzEGRvnaR8MwPojhDbPgo4LvwBaunXZymBSpbrZ7uj9WaVXvLa/rkSfJkipj9n
         3Hyw==
X-Gm-Message-State: APjAAAXsgnCb79mylvHAKPQMoVByWYSTt9fH2KhWwQ+fZ3Ee7aW3k1eg
        jATCD/PU19oLn099ViIZk/gKhc7+bGKHEoS0ksaZt+T++tszgCCYylvb3pdy0SWnzja+LDTz7I/
        c0ixWnvnK09dkxrL86LXJeEvlzlCV1b4dPc1YFR0HkpKgPqa7mSAwKOa3gvmZsJP8HFDy+rQIdr
        8+rRGaSQ==
X-Google-Smtp-Source: APXvYqz27IvEY/WIIBZHUJf9K5RDrG+2LVoAkWJKDE04UgyoIkvpFV6xjuIIHtylL2gturWIoJ4tCA==
X-Received: by 2002:a17:90a:2a06:: with SMTP id i6mr26525546pjd.97.1578051318158;
        Fri, 03 Jan 2020 03:35:18 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id h128sm70302144pfe.172.2020.01.03.03.35.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 03:35:17 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        stable@vger.kernel.org,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 08/11] megaraid_sas: Do not initiate OCR if controller is not in ready state
Date:   Fri,  3 Jan 2020 17:02:32 +0530
Message-Id: <1578051155-14716-9-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1578051155-14716-1-git-send-email-anand.lodnoor@broadcom.com>
References: <1578051155-14716-1-git-send-email-anand.lodnoor@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Driver can initiate OCR if DCMD command is timeout, but there is a
deadlock if the driver attempts to invoke another OCR  before the
mutex lock is released from the previous session of OCR.

This patch takes care of the above scenario using new flag
MEGASAS_FUSION_OCR_NOT_POSSIBLE to indicate if OCR is possible or not.

Cc: stable@vger.kernel.org
Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Anand Lodnoor <anand.lodnoor@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 3 ++-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 3 ++-
 drivers/scsi/megaraid/megaraid_sas_fusion.h | 1 +
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 8bc4076..da47c8b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4404,7 +4404,8 @@ int megasas_alloc_cmds(struct megasas_instance *instance)
 	if (instance->adapter_type == MFI_SERIES)
 		return KILL_ADAPTER;
 	else if (instance->unload ||
-			test_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags))
+			test_bit(MEGASAS_FUSION_OCR_NOT_POSSIBLE,
+				 &instance->reset_flags))
 		return IGNORE_TIMEOUT;
 	else
 		return INITIATE_OCR;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 6860fd2..8b6cc1b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4851,6 +4851,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 	if (instance->requestorId && !instance->skip_heartbeat_timer_del)
 		del_timer_sync(&instance->sriov_heartbeat_timer);
 	set_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
+	set_bit(MEGASAS_FUSION_OCR_NOT_POSSIBLE, &instance->reset_flags);
 	atomic_set(&instance->adprecovery, MEGASAS_ADPRESET_SM_POLLING);
 	instance->instancet->disable_intr(instance);
 	megasas_sync_irqs((unsigned long)instance);
@@ -5059,7 +5060,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 	instance->skip_heartbeat_timer_del = 1;
 	retval = FAILED;
 out:
-	clear_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
+	clear_bit(MEGASAS_FUSION_OCR_NOT_POSSIBLE, &instance->reset_flags);
 	mutex_unlock(&instance->reset_mutex);
 	return retval;
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 8358b68..d57ecc7 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -89,6 +89,7 @@ enum MR_RAID_FLAGS_IO_SUB_TYPE {
 
 #define MEGASAS_FP_CMD_LEN	16
 #define MEGASAS_FUSION_IN_RESET 0
+#define MEGASAS_FUSION_OCR_NOT_POSSIBLE 1
 #define RAID_1_PEER_CMDS 2
 #define JBOD_MAPS_COUNT	2
 #define MEGASAS_REDUCE_QD_COUNT 64
-- 
1.8.3.1

