Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4786C433F8
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:42:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A37BE22C9C
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:42:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RZwvzdBb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730654AbgGUQmZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730642AbgGUQmX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:23 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF47C061794
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:23 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 184so3567907wmb.0
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s8AbQxq9r0ZdFRsalDWfW9DgMg5mPoOf6FNctnZmLIQ=;
        b=RZwvzdBbdW5QHi1/paT/IBoA+Y3oHSI5BvtohjiKg6ncaMUaNQq7Ak/zwfKT5RS9YV
         aIWj38Sq8eko6vbtBgPDU+oqHtusCtYqeaBHf72WMhULh1O2ZR9Bk0KLx9Vf6f+JI2x+
         rjak/buhkfHMwKJxIlUXrVwTVBTmdztO18znyWZo3mE2hIuSJKt0lghQp/I49rfONzxh
         Vvrd0G/dw/H2CVTkGDKhDpXL+IbTAHGS3E0gzmfBaZjqrkZh/4o4q8a9Eep5ZSs/apkh
         ZqYRHVosDmTDF460D75yioHXLczNF35kf5zyBavHC1fjDeyEp3VEEgRpou6py81uK9+X
         keJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s8AbQxq9r0ZdFRsalDWfW9DgMg5mPoOf6FNctnZmLIQ=;
        b=mW/cVcnRbJChG9fT7RfliYf7GaA/68LcaRUkPA3tfABEakn52SfQoLOUoVMEZN7C4B
         acCJH78bSdZksLRAYE2PJqNISrXCxHVsIiaLFucJiVDTXuE8vP27DcLBJTIvF8npAhg9
         A7hy9SPi6025x3hpCQgp1qXS1wgsSZ0gbH7VnYmuBS10so64emMJHAwu8utREYJyJf1M
         OvqnILsd+VKv+bQ2lohk3jwZOsP0ApSJZf1NrmkUKNEX9geS2vmLnFeLZlM+llMJEFCY
         6MvHyoAgmKGSVY4+jAZ6kasHLGXGm/2Tmg0lx42pDMkVLhqn7jcGx8Z8/lsIO+2VoTv6
         RtSw==
X-Gm-Message-State: AOAM53095oq54m4Q/1uIF8/3WpZ/Lhy8bxDNn8B6Cu+Q9OzJxGg5tV0Z
        uH3a+U9q5cAPXVFVVmNuhpRNVQ==
X-Google-Smtp-Source: ABdhPJycricuOIiBnEAC/VX0ROrq2rRaZA/9GvXgB2BBlFdjg/5ZcMgT9Bsqm6WBQGXg06bkBGFmCA==
X-Received: by 2002:a1c:3504:: with SMTP id c4mr4796690wma.177.1595349742030;
        Tue, 21 Jul 2020 09:42:22 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:21 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 17/40] scsi: pm8001: pm80xx_hwi: Fix some function documentation issues
Date:   Tue, 21 Jul 2020 17:41:25 +0100
Message-Id: <20200721164148.2617584-18-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/pm8001/pm80xx_hwi.c:918: warning: Function parameter or member 'number' not described in 'update_inbnd_queue_table'
 drivers/scsi/pm8001/pm80xx_hwi.c:954: warning: Function parameter or member 'number' not described in 'update_outbnd_queue_table'
 drivers/scsi/pm8001/pm80xx_hwi.c:1717: warning: Function parameter or member 'vec' not described in 'pm80xx_chip_interrupt_enable'
 drivers/scsi/pm8001/pm80xx_hwi.c:1735: warning: Function parameter or member 'vec' not described in 'pm80xx_chip_interrupt_disable'
 drivers/scsi/pm8001/pm80xx_hwi.c:4830: warning: Excess function parameter 'num' description in 'pm80xx_chip_phy_start_req'
 drivers/scsi/pm8001/pm80xx_hwi.c:4872: warning: Excess function parameter 'num' description in 'pm80xx_chip_phy_stop_req'
 drivers/scsi/pm8001/pm80xx_hwi.c:4892: warning: Function parameter or member 'pm8001_ha' not described in 'pm80xx_chip_reg_dev_req'
 drivers/scsi/pm8001/pm80xx_hwi.c:4892: warning: Function parameter or member 'pm8001_dev' not described in 'pm80xx_chip_reg_dev_req'
 drivers/scsi/pm8001/pm80xx_hwi.c:4892: warning: Function parameter or member 'flag' not described in 'pm80xx_chip_reg_dev_req'
 drivers/scsi/pm8001/pm80xx_hwi.c:4966: warning: Function parameter or member 'phyId' not described in 'pm80xx_chip_phy_ctl_req'
 drivers/scsi/pm8001/pm80xx_hwi.c:4966: warning: Function parameter or member 'phy_op' not described in 'pm80xx_chip_phy_ctl_req'
 drivers/scsi/pm8001/pm80xx_hwi.c:4966: warning: Excess function parameter 'num' description in 'pm80xx_chip_phy_ctl_req'
 drivers/scsi/pm8001/pm80xx_hwi.c:4966: warning: Excess function parameter 'phy_id' description in 'pm80xx_chip_phy_ctl_req'
 drivers/scsi/pm8001/pm80xx_hwi.c:5006: warning: Function parameter or member 'vec' not described in 'pm80xx_chip_isr'
 drivers/scsi/pm8001/pm80xx_hwi.c:5006: warning: Excess function parameter 'irq' description in 'pm80xx_chip_isr'
 drivers/scsi/pm8001/pm80xx_hwi.c:5006: warning: Excess function parameter 'stat' description in 'pm80xx_chip_isr'

Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 05c944a3bdca0..abcbd47162d64 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -912,6 +912,7 @@ static void update_main_config_table(struct pm8001_hba_info *pm8001_ha)
 /**
  * update_inbnd_queue_table - update the inbound queue table to the HBA.
  * @pm8001_ha: our hba card information
+ * @number: entry in the queue
  */
 static void update_inbnd_queue_table(struct pm8001_hba_info *pm8001_ha,
 					 int number)
@@ -948,6 +949,7 @@ static void update_inbnd_queue_table(struct pm8001_hba_info *pm8001_ha,
 /**
  * update_outbnd_queue_table - update the outbound queue table to the HBA.
  * @pm8001_ha: our hba card information
+ * @number: entry in the queue
  */
 static void update_outbnd_queue_table(struct pm8001_hba_info *pm8001_ha,
 						 int number)
@@ -1711,6 +1713,7 @@ pm80xx_chip_intx_interrupt_disable(struct pm8001_hba_info *pm8001_ha)
 /**
  * pm8001_chip_interrupt_enable - enable PM8001 chip interrupt
  * @pm8001_ha: our hba card information
+ * @vec: interrupt number to enable
  */
 static void
 pm80xx_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
@@ -1729,6 +1732,7 @@ pm80xx_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 /**
  * pm8001_chip_interrupt_disable- disable PM8001 chip interrupt
  * @pm8001_ha: our hba card information
+ * @vec: interrupt number to disable
  */
 static void
 pm80xx_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha, u8 vec)
@@ -4822,7 +4826,6 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 /**
  * pm80xx_chip_phy_start_req - start phy via PHY_START COMMAND
  * @pm8001_ha: our hba card information.
- * @num: the inbound queue number
  * @phy_id: the phy id which we wanted to start up.
  */
 static int
@@ -4864,7 +4867,6 @@ pm80xx_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
 /**
  * pm8001_chip_phy_stop_req - start phy via PHY_STOP COMMAND
  * @pm8001_ha: our hba card information.
- * @num: the inbound queue number
  * @phy_id: the phy id which we wanted to start up.
  */
 static int pm80xx_chip_phy_stop_req(struct pm8001_hba_info *pm8001_ha,
@@ -4884,7 +4886,7 @@ static int pm80xx_chip_phy_stop_req(struct pm8001_hba_info *pm8001_ha,
 	return ret;
 }
 
-/**
+/*
  * see comments on pm8001_mpi_reg_resp.
  */
 static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
@@ -4957,9 +4959,8 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 /**
  * pm80xx_chip_phy_ctl_req - support the local phy operation
  * @pm8001_ha: our hba card information.
- * @num: the inbound queue number
- * @phy_id: the phy id which we wanted to operate
- * @phy_op:
+ * @phyId: the phy id which we wanted to operate
+ * @phy_op: phy operation to request
  */
 static int pm80xx_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
 	u32 phyId, u32 phy_op)
@@ -4998,8 +4999,7 @@ static u32 pm80xx_chip_is_our_interrupt(struct pm8001_hba_info *pm8001_ha)
 /**
  * pm8001_chip_isr - PM8001 isr handler.
  * @pm8001_ha: our hba card information.
- * @irq: irq number.
- * @stat: stat.
+ * @vec: irq number.
  */
 static irqreturn_t
 pm80xx_chip_isr(struct pm8001_hba_info *pm8001_ha, u8 vec)
-- 
2.25.1

