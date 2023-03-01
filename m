Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08466C7EE23
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Mar 2023 23:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjCAXHX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Mar 2023 18:07:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbjCAXHU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2023 18:07:20 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E853C679
        for <linux-scsi@vger.kernel.org>; Wed,  1 Mar 2023 15:07:19 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id c3so11966319qtc.8
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2023 15:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677712038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AI2fawHrIFIsmBLK6Y4XhK0A9vo7XAxtFMc3BM1lWn0=;
        b=XTYz7iHRxvN+8Wzm9snDSiG7ZLj2Ezpm82ViOu3AsI7iSuD7V+lavQ3BHP7QHupuCa
         DOLIigX1crDB2zL36aztfXXX2NmIYP8+mmmEXvD6SNNfz0UaGJsWmnsOa5OoB4FPFdhf
         wkXUUL4PctyxkC52RLMNKDPTOOolU5YsOtB/2PvTBWAWpgKVKoqD3oBiGRi2Ph1tWjn/
         ThC+f6UwYwGhSKJ0i2c37M2+OSFzZpoX+fkNfRX6PHXBz5zRCed/f7c4qmdlQOtxE1/4
         XxYIePVVkvbzqYBLuv1N4nMpyTzp709xnWhDSYc2aoptTTp5mdcHmVHg/Si5X3/BsUz+
         iBMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677712038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AI2fawHrIFIsmBLK6Y4XhK0A9vo7XAxtFMc3BM1lWn0=;
        b=OcP57nfNNgKINdFmCr1eDUbrEwsLpSlbh+IW+Lq+Ea9Dxfb9m4W/t7u1WUaS4la0kN
         FgNubI2QUeVCT0Dh/9lhq8T92HUPcee0FzU8K97t/v7xOb6IgwvwnHKSuxXPvMje4LOT
         I4uZ0Nbv8HdwBwmCyT5y7V0yQC9mJOb4YlP60Gs4snW25U0BVismyQb51E09dy0HBl7e
         v/ptWi2YpzkxQk56n1C6fJwsbmk7fAXlUo6wG3eUsll8PKHzW3H4RQHEElyvK8rKv3Vm
         EWaiFuWwx45DOMrmBvTxp2hAvZTiSu98Yn3bP5zRsQ/GHrEASapgtM7JGLVWLBvYYwN6
         oh3Q==
X-Gm-Message-State: AO0yUKUnXF2+mu4Ucj0jwvx66TK8Jn/RbPu4D0sYeKERyuTbd+LkIof+
        bBYF5F36c3eQuSgKkABbfK9O7oAb0SM=
X-Google-Smtp-Source: AK7set89soqW6SCSn+NEh0MYIe7rVgsb2Yy+NiclJdbVudF8KIyNq9T+kTD9rSkkGKbjqzkuQqtceQ==
X-Received: by 2002:a05:622a:18a1:b0:3bf:a3d0:9023 with SMTP id v33-20020a05622a18a100b003bfa3d09023mr14468192qtc.5.1677712038629;
        Wed, 01 Mar 2023 15:07:18 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j9-20020ac85509000000b003b86b99690fsm9047572qtq.62.2023.03.01.15.07.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Mar 2023 15:07:18 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 03/10] lpfc: Fix lockdep warning for rx_monitor lock when unloading driver
Date:   Wed,  1 Mar 2023 15:16:19 -0800
Message-Id: <20230301231626.9621-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230301231626.9621-1-justintee8345@gmail.com>
References: <20230301231626.9621-1-justintee8345@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Lockdep enabled kernels report a theoretical deadlock state where the
cmf_timer interrupt occurs while the rx_monitor ring is being destroyed.

During rmmod, the cmf_timer is cancelled prior to the
lpfc_rx_monitor_destroy_ring call.  This actually eliminates the need to
take the rx_monitor ring lock in lpfc_rx_monitor_destroy_ring.  Thus, just
remove lock/unlock of rx_monitor in lpfc_rx_monitor_destroy_ring.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index bfab1f0fb3f0..c8b4632e3dd4 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8080,16 +8080,16 @@ int lpfc_rx_monitor_create_ring(struct lpfc_rx_info_monitor *rx_monitor,
 /**
  * lpfc_rx_monitor_destroy_ring - Free ring buffer for rx_monitor
  * @rx_monitor: Pointer to lpfc_rx_info_monitor object
+ *
+ * Called after cancellation of cmf_timer.
  **/
 void lpfc_rx_monitor_destroy_ring(struct lpfc_rx_info_monitor *rx_monitor)
 {
-	spin_lock(&rx_monitor->lock);
 	kfree(rx_monitor->ring);
 	rx_monitor->ring = NULL;
 	rx_monitor->entries = 0;
 	rx_monitor->head_idx = 0;
 	rx_monitor->tail_idx = 0;
-	spin_unlock(&rx_monitor->lock);
 }
 
 /**
-- 
2.38.0

