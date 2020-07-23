Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D0EDC43445
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D931620792
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:27:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gPiSTZgQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbgGWMZH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728928AbgGWMZG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:06 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8615EC0619E2
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:06 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 184so5021851wmb.0
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h63LOgt+Dy9g/r9ZLeRwkVpd9spngRolp7BRUfjs04E=;
        b=gPiSTZgQ6RVOnxc4T+m87zsgevXZ4/vwi6Yf3OWh3UnlrG/cYxRyuV8MqeTtANSA7V
         nTPngr5LxGg1E9sY/xI/ULZ0VKbIHJqPl5mtUSEdz9tqIzywwy61U5+ShcSBPALBQL5z
         lGWbxgDDdHb1OdvVc9Tya9fpObNJ4Bs/kP/DKylzQksw8IQqHt8g/g2sNQDmV+sLERNj
         n0yXuZfidePc2w2gaZ4gdwasSMoIt0Me7VTOHm+E4enkBrVAlHvplwxLABQFbAEycqVq
         bRxxmtcJewIv1+idmOiIFaeIv7CXcDrC6kVgs9bRTRdA/cR4wQMO7lq/AOYldXtTBHtV
         ribg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h63LOgt+Dy9g/r9ZLeRwkVpd9spngRolp7BRUfjs04E=;
        b=tA2TfnWelbrtwd39jDF/vzV3uf11Uyf/Q8uGNiwEruh1qqE8BCXDKU5pzDhKKI3LTA
         JqiG7shd08yks4AkYwnlqqDQ/zZvWBh7SY0Ya5gE3Ndh+9EP3qM80lPlKJlgpDQe9VSl
         yDFpLOaspMuCtRoZwSTGWLPP1RAupemDSh4BOpLOgDLlgwqocHw1YJLgoGdStU4DV1dm
         3sEjjz23R2+T9KggXa/Xf5Zp7LpptBb34X5/kv4YiBkAz2IdEaAOtvD9indS80/a8SqU
         kmn/wP8e2zdxwlzuIDWyRHLLStEGuQtJ/Ta6xlDZX2Nz+TOy3Jcf3ZrhBrjT8B4UmbBn
         ePmw==
X-Gm-Message-State: AOAM531o+wZeLKQ9rOYsY1v1jfLY3j3C9rhpZvd3FH9vh+QPm0WXFjUz
        OVVhaLiuHuIjzBI83wsqywY3+g==
X-Google-Smtp-Source: ABdhPJwsIcwNe8dwuwe2OJqfzn2ZQ57y3/4mQvClR7t7daFL5f+jr6Jc5OuDYirzpKLdZtUGoAfWyw==
X-Received: by 2002:a1c:7719:: with SMTP id t25mr4164947wmi.144.1595507105238;
        Thu, 23 Jul 2020 05:25:05 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:04 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        ipslinux@adaptec.com, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 13/40] scsi: ips: Convert strnlen() to memcpy() since result should not be NUL terminated
Date:   Thu, 23 Jul 2020 13:24:19 +0100
Message-Id: <20200723122446.1329773-14-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 In file included from arch/arm/include/asm/io.h:23,
 from drivers/scsi/ips.c:164:
 In function ‘strncpy’,
 inlined from ‘ips_send_cmd’ at drivers/scsi/ips.c:3522:6:
 include/linux/string.h:297:30: warning: ‘__builtin_strncpy’ output
 truncated before terminating nul cop ying 4 bytes from a string of the same length [-Wstringop-truncation]
 297 | #define __underlying_strncpy __builtin_strncpy
 | ^
 include/linux/string.h:307:9: note: in expansion of macro ‘__underlying_strncpy’
 307 | return __underlying_strncpy(p, q, size);
 | ^~~~~~~~~~~~~~~~~~~~
 NB: Lots of these - snipping for brevity

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: ipslinux@adaptec.com
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/ips.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index ec85ccce96647..2e6077c502fc7 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -2239,7 +2239,7 @@ ips_get_bios_version(ips_ha_t * ha, int intr)
 	major = 0;
 	minor = 0;
 
-	strncpy(ha->bios_version, "       ?", 8);
+	memcpy(ha->bios_version, "       ?", 8);
 
 	if (ha->pcidev->device == IPS_DEVICEID_COPPERHEAD) {
 		if (IPS_USE_MEMIO(ha)) {
@@ -3515,11 +3515,11 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 					inquiry.Flags[1] =
 					    IPS_SCSI_INQ_WBus16 |
 					    IPS_SCSI_INQ_Sync;
-					strncpy(inquiry.VendorId, "IBM     ",
+					memcpy(inquiry.VendorId, "IBM     ",
 						8);
-					strncpy(inquiry.ProductId,
+					memcpy(inquiry.ProductId,
 						"SERVERAID       ", 16);
-					strncpy(inquiry.ProductRevisionLevel,
+					memcpy(inquiry.ProductRevisionLevel,
 						"1.00", 4);
 
 					ips_scmd_buf_write(scb->scsi_cmd,
@@ -4036,9 +4036,9 @@ ips_inquiry(ips_ha_t * ha, ips_scb_t * scb)
 	inquiry.Flags[0] = IPS_SCSI_INQ_Address16;
 	inquiry.Flags[1] =
 	    IPS_SCSI_INQ_WBus16 | IPS_SCSI_INQ_Sync | IPS_SCSI_INQ_CmdQue;
-	strncpy(inquiry.VendorId, "IBM     ", 8);
-	strncpy(inquiry.ProductId, "SERVERAID       ", 16);
-	strncpy(inquiry.ProductRevisionLevel, "1.00", 4);
+	memcpy(inquiry.VendorId, "IBM     ", 8);
+	memcpy(inquiry.ProductId, "SERVERAID       ", 16);
+	memcpy(inquiry.ProductRevisionLevel, "1.00", 4);
 
 	ips_scmd_buf_write(scb->scsi_cmd, &inquiry, sizeof (inquiry));
 
@@ -5620,10 +5620,10 @@ ips_write_driver_status(ips_ha_t * ha, int intr)
 	/* change values (as needed) */
 	ha->nvram->operating_system = IPS_OS_LINUX;
 	ha->nvram->adapter_type = ha->ad_type;
-	strncpy((char *) ha->nvram->driver_high, IPS_VERSION_HIGH, 4);
-	strncpy((char *) ha->nvram->driver_low, IPS_VERSION_LOW, 4);
-	strncpy((char *) ha->nvram->bios_high, ha->bios_version, 4);
-	strncpy((char *) ha->nvram->bios_low, ha->bios_version + 4, 4);
+	memcpy((char *) ha->nvram->driver_high, IPS_VERSION_HIGH, 4);
+	memcpy((char *) ha->nvram->driver_low, IPS_VERSION_LOW, 4);
+	memcpy((char *) ha->nvram->bios_high, ha->bios_version, 4);
+	memcpy((char *) ha->nvram->bios_low, ha->bios_version + 4, 4);
 
 	ha->nvram->versioning = 0;	/* Indicate the Driver Does Not Support Versioning */
 
-- 
2.25.1

