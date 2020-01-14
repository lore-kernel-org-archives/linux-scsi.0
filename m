Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 738DFC33CB3
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 11:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AFF72467C
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 11:22:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cBD7sQJf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgANLWn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 06:22:43 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41690 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729074AbgANLWn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jan 2020 06:22:43 -0500
Received: by mail-wr1-f67.google.com with SMTP id c9so11770102wrw.8
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jan 2020 03:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4eFQzp+JCtokfUtlUrLMsNLWBUK6VmafjlDVoiVD5uw=;
        b=cBD7sQJfbsiqM/XZCqi7cEMBmLY8aSoGbiGb3pXp6VlfwoF4go7sYVvJ3PHYLfxFyJ
         SQJjJ92isR56DHE/4P9UYUzK8xcgxndfkVfrRUr1sLPoOxuqgl3OdviWzxAxKhlaombB
         guxxOIz5y2jMlRJESwPDys/86miOXwHestDI4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4eFQzp+JCtokfUtlUrLMsNLWBUK6VmafjlDVoiVD5uw=;
        b=kWJ4iHrnPW5wUULk3EVQf6pe/eqsMauLnNcqHxwHDpyIkNxKbgImBc6dzXTMKbw5nl
         ic2AAOzX/Cl8BWw8cn/y8cVL4cfHhbHXPWzElAKx96cB5AI8EpB1dDmOcUSA3pkZ6d0e
         keH1vpg8pJKngUopWgjd6O7eb2fvAG7+7iNoWjxHA2sYnd8Wif3cqyRLz+wRI+lx96vT
         p8NaRgmonqnySFsSBIYi+BAbKUSbIgLgB37LpxGPq93zYLazfboDrnwhTPu2//5d97IR
         HUfrBQfxIUZSFC36RVo0aS8d6PstZJ31nnGaQuRSJgxdXVr0eGDhbdpQxV6Z/rMnoegG
         1P6w==
X-Gm-Message-State: APjAAAXEo2tB+ziKa3WobYff9GoRFQGhxy0gRFaM5bBgB2yc8UWuO/k7
        4IIdFkV9wThf3KZ8w8iD45bXm2I2GQHSVZiMgv2EU0Vp94NutUm1Tg7WidItrog8sG0YiMmkmG0
        3azBU0QLiT3At2UGafCtfg7vwqzZCAqD20GUfjM6CGlIurawtEGx+3yT0uzabpXRkkpgqYG7Nv2
        PxkvkZew==
X-Google-Smtp-Source: APXvYqyQdhmnuZgenSsWwnf7oos0rbXP8CK5d9b/AK9laFdydqfzKQu33rMd9r7b3r/O6pJwKamoGg==
X-Received: by 2002:adf:e5ce:: with SMTP id a14mr23809519wrn.214.1579000961174;
        Tue, 14 Jan 2020 03:22:41 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id z21sm17638160wml.5.2020.01.14.03.22.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2020 03:22:40 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        chandrakanth.patil@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>
Subject: [PATCH v2 05/11] megaraid_sas: Do not kill HBA if JBOD Seqence map or RAID map is disabled
Date:   Tue, 14 Jan 2020 16:51:16 +0530
Message-Id: <1579000882-20246-6-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
References: <1579000882-20246-1-git-send-email-anand.lodnoor@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

At the time of firmware initialization, if JBOD map or RAID map is not available,
driver can function without these features in a limited functionality mode.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Anand Lodnoor <anand.lodnoor@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index e301458..ef20234 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1312,7 +1312,9 @@ static int megasas_create_sg_sense_fusion(struct megasas_instance *instance)
 	}
 
 	if (ret == DCMD_TIMEOUT)
-		megaraid_sas_kill_hba(instance);
+		dev_warn(&instance->pdev->dev,
+			 "%s DCMD timed out, continue without JBOD sequence map\n",
+			 __func__);
 
 	if (ret == DCMD_SUCCESS)
 		instance->pd_seq_map_id++;
@@ -1394,7 +1396,9 @@ static int megasas_create_sg_sense_fusion(struct megasas_instance *instance)
 		ret = megasas_issue_polled(instance, cmd);
 
 	if (ret == DCMD_TIMEOUT)
-		megaraid_sas_kill_hba(instance);
+		dev_warn(&instance->pdev->dev,
+			 "%s DCMD timed out, RAID map is disabled\n",
+			 __func__);
 
 	megasas_return_cmd(instance, cmd);
 
-- 
1.8.3.1

