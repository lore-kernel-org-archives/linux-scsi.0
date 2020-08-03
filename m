Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E637C433EA
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 21:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CA2922BED
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 21:02:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mcsWAKSq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729476AbgHCVCn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 17:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729146AbgHCVCm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 17:02:42 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 873F7C061756
        for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2020 14:02:42 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id x5so800005wmi.2
        for <linux-scsi@vger.kernel.org>; Mon, 03 Aug 2020 14:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uiJ8hbbvoWIZLtDuMURdnNyi1mA+H8kk9tt2C8ROgFM=;
        b=mcsWAKSq6EnuQjzEobSeDRI97F6ZxDo67E/TbnjV1DSXcBb/MFtDcEt9aZaUesoBo2
         I37akjuMlRQ3gYTV2kyjPdBti5dpcYrFXAQt1bINMcam/cFHfGzxNBzA9WNHGN+rI4vM
         xtvH7MHpbMxBpaoRwlR1APuupATZ5sEhddqCey+HVjh46uQqXlWT9QmyW4sXHM/9G7r9
         PYNgtSRtwGoNkE0zvxzLI/oJ0uTHozCoF1c/tpIIyaFmeGJl3G/PWu9oFh2zon4oDZn2
         kDTNMu1dvyEow5Q6m9hPxMSol6E5/fiIiXDbaGVR8qoSXB4LPfAOoNGv/m7kY9zKkM6K
         TdpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uiJ8hbbvoWIZLtDuMURdnNyi1mA+H8kk9tt2C8ROgFM=;
        b=ralJGk00nHSw0RUx5YjxpUz1aTURw3phx3fAamgHOfEnAGCud/dELhtmM5/kmA4NIs
         7FRE1x/RytjknXXRqtx6NIRA2amD7KQqfSTStpcVpYudXIZd6+yrAdBp8dmpyzp9pIOA
         MZOkWBK396ygNtU6cBQo98yQGuUWgSf2voPlIq2zhb6jmkQ17yafv5/EP4uJ8tTXtNsN
         Czo77rvKaGSVF87LDNxj3qwBXG5QwLCF/TuDvaYsjW60if80Acy2mWlNPUMyo3c2yNDC
         CC7Mds/sKoe4KvZRescJkmLaNWZ2cjNHrMZWkAOIUHyI+gAODovX5fvUxVrrHKhjkgjP
         wYSQ==
X-Gm-Message-State: AOAM533FbzUcibVfgFKTWZ4R+u08GNbcUFZh2hNAaAcjnFjdt9QEv8Hj
        xfwx7YfYxlnQ+iHC/BD9CcYbyOHI
X-Google-Smtp-Source: ABdhPJzDN9hoVVAFLO3RKe+IhKv5ugccm8/Ck12A25kNeysdaDetZy9Icef4nDhvGFetUD/YWEk72w==
X-Received: by 2002:a1c:7315:: with SMTP id d21mr887175wmb.108.1596488561030;
        Mon, 03 Aug 2020 14:02:41 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v15sm26649040wrm.23.2020.08.03.14.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 14:02:40 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 2/8] lpfc: Fix no message shown for lpfc_hdw_queue out of range value
Date:   Mon,  3 Aug 2020 14:02:23 -0700
Message-Id: <20200803210229.23063-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200803210229.23063-1-jsmart2021@gmail.com>
References: <20200803210229.23063-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If module parameters override the default configuration settings for
hardware queues or irqs, the driver was not notifying the change from
defaults.

Revise such that any changes will result in a kernel log message.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 20 +++++++++++++++++---
 drivers/scsi/lpfc/lpfc_init.c |  3 ++-
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index cc2c907777d2..ece6c250ebaf 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -7412,12 +7412,26 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 void
 lpfc_nvme_mod_param_dep(struct lpfc_hba *phba)
 {
-	if (phba->cfg_hdw_queue > phba->sli4_hba.num_present_cpu)
+	int  logit = 0;
+
+	if (phba->cfg_hdw_queue > phba->sli4_hba.num_present_cpu) {
 		phba->cfg_hdw_queue = phba->sli4_hba.num_present_cpu;
-	if (phba->cfg_irq_chann > phba->sli4_hba.num_present_cpu)
+		logit = 1;
+	}
+	if (phba->cfg_irq_chann > phba->sli4_hba.num_present_cpu) {
 		phba->cfg_irq_chann = phba->sli4_hba.num_present_cpu;
-	if (phba->cfg_irq_chann > phba->cfg_hdw_queue)
+		logit = 1;
+	}
+	if (phba->cfg_irq_chann > phba->cfg_hdw_queue) {
 		phba->cfg_irq_chann = phba->cfg_hdw_queue;
+		logit = 1;
+	}
+	if (logit)
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"2006 Reducing Queues - CPU limitation: "
+				"IRQ %d HDWQ %d\n",
+				phba->cfg_irq_chann,
+				phba->cfg_hdw_queue);
 
 	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME &&
 	    phba->nvmet_support) {
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 159afadaea2b..265f2dfa7fb0 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8637,7 +8637,8 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 		if ((phba->cfg_irq_chann > qmin) ||
 		    (phba->cfg_hdw_queue > qmin)) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-					"2005 Reducing Queues: "
+					"2005 Reducing Queues - "
+					"FW resource limitation: "
 					"WQ %d CQ %d EQ %d: min %d: "
 					"IRQ %d HDWQ %d\n",
 					phba->sli4_hba.max_cfg_param.max_wq,
-- 
2.26.2

