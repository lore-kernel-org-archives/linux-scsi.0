Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF035C433EB
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98D49207BB
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:42:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="O2l5tyTF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730590AbgGUQmX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730621AbgGUQmW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:22 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC84C0619DD
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:21 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 9so78089wmj.5
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QpSky1nZVCCoj3FVUN3IPvDQxFs9+66v982LYbHXGlE=;
        b=O2l5tyTFf8QN1OFejiCjzuA1whaci+9EGQCGRgXvFA6Bi7TOstc12V71olVaIzGkhb
         amSANK+rRLcdFOZzDbsonL/kBQPE5l3oH66IWWldNClrp1RGEiyx3K7YxAK051BnpMRb
         3AapT2sg7GzdHdrZTk0zw4B9NFuFin24QUkOpq6JMOqBH1I0wQ3qd7QQPBLzvrgBOSF0
         pdWwHLlenEmqo5cFXu2tZEg/Ntkslik7VTy3fHhxy6XlHhNBuQV5ZuiEVfBFyLMye5fE
         FiOgYsRV3GL2N5xlFOyW1z0VgSnnhQIDcxsdzj6ze+B73MqwAwmvaxOTLNNKFqU/d/yE
         xKNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QpSky1nZVCCoj3FVUN3IPvDQxFs9+66v982LYbHXGlE=;
        b=lpPIHQOjnPcq/SoMY3xPpIcp0CHNAHJCEkDXIvmnos0sOoGwoEN3UsrCuotCezQhX8
         rY+VZw3Z4JhC1hxJRxcrFg0uV3kfeor/o7uNdH1QSNk+ZlwsntCIJymnhfuaYd9/2F2N
         UTri82mKt/t4OjDl9rdxyHyPKhWaP2GYoKygV/tXTcZ/Fl/wjd2vtNASZy9SSj3LvdN6
         g9rQWX5mE13ca1oxC/pwBEAz7HmcGIKsJX45WPXjXffqQpwHi7xlTcDE++vkMMwdhRYE
         uIOdoToldw8bWLTSZ9op2fsrphZUjm5yeJhuZYHsXuZlJRkYlvzCvwcs3HXCVJ1TpV+a
         tOLw==
X-Gm-Message-State: AOAM532sC9fEqf7mqcE19ea0rnuk/aETHiDNQ8fylW+Pu81DvcccvyPj
        uy8dxXXGN7G8+qEyYkuoa1/vFw==
X-Google-Smtp-Source: ABdhPJzRaV8at3zqw6Sp4CiMjpng4Yufm7zfg4W5tELUKUKxZBGkyKzOSxKueu+XpRLkqKoWII/NUQ==
X-Received: by 2002:a1c:7f0e:: with SMTP id a14mr5045750wmd.21.1595349740640;
        Tue, 21 Jul 2020 09:42:20 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:20 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 16/40] scsi: pm8001: pm8001_hwi: Fix a bunch of kerneldoc issues
Date:   Tue, 21 Jul 2020 17:41:24 +0100
Message-Id: <20200721164148.2617584-17-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Provide lots of missing descriptions, remove some superfluous ones
(probably due to docroc) and demote one header which does not provide
many descriptions, and the ones it does provide are incorrect.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/pm8001/pm8001_hwi.c:339: warning: Function parameter or member 'number' not described in 'update_inbnd_queue_table'
 drivers/scsi/pm8001/pm8001_hwi.c:360: warning: Function parameter or member 'number' not described in 'update_outbnd_queue_table'
 drivers/scsi/pm8001/pm8001_hwi.c:480: warning: Function parameter or member 'interval' not described in 'mpi_set_open_retry_interval_reg'
 drivers/scsi/pm8001/pm8001_hwi.c:1238: warning: Function parameter or member 'int_vec_idx' not described in 'pm8001_chip_msix_interrupt_enable'
 drivers/scsi/pm8001/pm8001_hwi.c:1256: warning: Function parameter or member 'int_vec_idx' not described in 'pm8001_chip_msix_interrupt_disable'
 drivers/scsi/pm8001/pm8001_hwi.c:1270: warning: Function parameter or member 'vec' not described in 'pm8001_chip_interrupt_enable'
 drivers/scsi/pm8001/pm8001_hwi.c:1284: warning: Function parameter or member 'vec' not described in 'pm8001_chip_interrupt_disable'
 drivers/scsi/pm8001/pm8001_hwi.c:4508: warning: Excess function parameter 'num' description in 'pm8001_chip_phy_start_req'
 drivers/scsi/pm8001/pm8001_hwi.c:4544: warning: Excess function parameter 'num' description in 'pm8001_chip_phy_stop_req'
 drivers/scsi/pm8001/pm8001_hwi.c:4564: warning: Function parameter or member 'pm8001_ha' not described in 'pm8001_chip_reg_dev_req'
 drivers/scsi/pm8001/pm8001_hwi.c:4564: warning: Function parameter or member 'pm8001_dev' not described in 'pm8001_chip_reg_dev_req'
 drivers/scsi/pm8001/pm8001_hwi.c:4564: warning: Function parameter or member 'flag' not described in 'pm8001_chip_reg_dev_req'
 drivers/scsi/pm8001/pm8001_hwi.c:4624: warning: Function parameter or member 'pm8001_ha' not described in 'pm8001_chip_dereg_dev_req'
 drivers/scsi/pm8001/pm8001_hwi.c:4624: warning: Function parameter or member 'device_id' not described in 'pm8001_chip_dereg_dev_req'
 drivers/scsi/pm8001/pm8001_hwi.c:4650: warning: Function parameter or member 'phyId' not described in 'pm8001_chip_phy_ctl_req'
 drivers/scsi/pm8001/pm8001_hwi.c:4650: warning: Function parameter or member 'phy_op' not described in 'pm8001_chip_phy_ctl_req'
 drivers/scsi/pm8001/pm8001_hwi.c:4650: warning: Excess function parameter 'num' description in 'pm8001_chip_phy_ctl_req'
 drivers/scsi/pm8001/pm8001_hwi.c:4650: warning: Excess function parameter 'phy_id' description in 'pm8001_chip_phy_ctl_req'
 drivers/scsi/pm8001/pm8001_hwi.c:4687: warning: Function parameter or member 'vec' not described in 'pm8001_chip_isr'
 drivers/scsi/pm8001/pm8001_hwi.c:4687: warning: Excess function parameter 'irq' description in 'pm8001_chip_isr'
 drivers/scsi/pm8001/pm8001_hwi.c:4687: warning: Excess function parameter 'stat' description in 'pm8001_chip_isr'
 drivers/scsi/pm8001/pm8001_hwi.c:4727: warning: Function parameter or member 'pm8001_ha' not described in 'pm8001_chip_abort_task'
 drivers/scsi/pm8001/pm8001_hwi.c:4727: warning: Function parameter or member 'pm8001_dev' not described in 'pm8001_chip_abort_task'
 drivers/scsi/pm8001/pm8001_hwi.c:4727: warning: Function parameter or member 'task_tag' not described in 'pm8001_chip_abort_task'
 drivers/scsi/pm8001/pm8001_hwi.c:4727: warning: Function parameter or member 'cmd_tag' not described in 'pm8001_chip_abort_task'
 drivers/scsi/pm8001/pm8001_hwi.c:4727: warning: Excess function parameter 'task' description in 'pm8001_chip_abort_task'
 drivers/scsi/pm8001/pm8001_hwi.c:4966: warning: Function parameter or member 'tag' not described in 'pm8001_chip_fw_flash_update_build'

Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 0b4499210b955..6323016e1304e 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -333,6 +333,7 @@ static void update_main_config_table(struct pm8001_hba_info *pm8001_ha)
 /**
  * update_inbnd_queue_table - update the inbound queue table to the HBA.
  * @pm8001_ha: our hba card information
+ * @number: entry in the queue
  */
 static void update_inbnd_queue_table(struct pm8001_hba_info *pm8001_ha,
 				     int number)
@@ -354,6 +355,7 @@ static void update_inbnd_queue_table(struct pm8001_hba_info *pm8001_ha,
 /**
  * update_outbnd_queue_table - update the outbound queue table to the HBA.
  * @pm8001_ha: our hba card information
+ * @number: entry in the queue
  */
 static void update_outbnd_queue_table(struct pm8001_hba_info *pm8001_ha,
 				      int number)
@@ -473,7 +475,7 @@ static void mpi_set_phys_g3_with_ssc(struct pm8001_hba_info *pm8001_ha,
 /**
  * mpi_set_open_retry_interval_reg
  * @pm8001_ha: our hba card information
- * @interval - interval time for each OPEN_REJECT (RETRY). The units are in 1us.
+ * @interval: interval time for each OPEN_REJECT (RETRY). The units are in 1us.
  */
 static void mpi_set_open_retry_interval_reg(struct pm8001_hba_info *pm8001_ha,
 					    u32 interval)
@@ -1231,6 +1233,7 @@ pm8001_chip_intx_interrupt_disable(struct pm8001_hba_info *pm8001_ha)
 /**
  * pm8001_chip_msix_interrupt_enable - enable PM8001 chip interrupt
  * @pm8001_ha: our hba card information
+ * @int_vec_idx: interrupt number to enable
  */
 static void
 pm8001_chip_msix_interrupt_enable(struct pm8001_hba_info *pm8001_ha,
@@ -1249,6 +1252,7 @@ pm8001_chip_msix_interrupt_enable(struct pm8001_hba_info *pm8001_ha,
 /**
  * pm8001_chip_msix_interrupt_disable - disable PM8001 chip interrupt
  * @pm8001_ha: our hba card information
+ * @int_vec_idx: interrupt number to disable
  */
 static void
 pm8001_chip_msix_interrupt_disable(struct pm8001_hba_info *pm8001_ha,
@@ -1264,6 +1268,7 @@ pm8001_chip_msix_interrupt_disable(struct pm8001_hba_info *pm8001_ha,
 /**
  * pm8001_chip_interrupt_enable - enable PM8001 chip interrupt
  * @pm8001_ha: our hba card information
+ * @vec: unused
  */
 static void
 pm8001_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
@@ -1278,6 +1283,7 @@ pm8001_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
 /**
  * pm8001_chip_intx_interrupt_disable- disable PM8001 chip interrupt
  * @pm8001_ha: our hba card information
+ * @vec: unused
  */
 static void
 pm8001_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha, u8 vec)
@@ -4500,7 +4506,6 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 /**
  * pm8001_chip_phy_start_req - start phy via PHY_START COMMAND
  * @pm8001_ha: our hba card information.
- * @num: the inbound queue number
  * @phy_id: the phy id which we wanted to start up.
  */
 static int
@@ -4536,7 +4541,6 @@ pm8001_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
 /**
  * pm8001_chip_phy_stop_req - start phy via PHY_STOP COMMAND
  * @pm8001_ha: our hba card information.
- * @num: the inbound queue number
  * @phy_id: the phy id which we wanted to start up.
  */
 static int pm8001_chip_phy_stop_req(struct pm8001_hba_info *pm8001_ha,
@@ -4556,7 +4560,7 @@ static int pm8001_chip_phy_stop_req(struct pm8001_hba_info *pm8001_ha,
 	return ret;
 }
 
-/**
+/*
  * see comments on pm8001_mpi_reg_resp.
  */
 static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
@@ -4616,7 +4620,7 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 	return rc;
 }
 
-/**
+/*
  * see comments on pm8001_mpi_reg_resp.
  */
 int pm8001_chip_dereg_dev_req(struct pm8001_hba_info *pm8001_ha,
@@ -4641,7 +4645,6 @@ int pm8001_chip_dereg_dev_req(struct pm8001_hba_info *pm8001_ha,
 /**
  * pm8001_chip_phy_ctl_req - support the local phy operation
  * @pm8001_ha: our hba card information.
- * @num: the inbound queue number
  * @phy_id: the phy id which we wanted to operate
  * @phy_op:
  */
@@ -4679,7 +4682,6 @@ static u32 pm8001_chip_is_our_interrupt(struct pm8001_hba_info *pm8001_ha)
 /**
  * pm8001_chip_isr - PM8001 isr handler.
  * @pm8001_ha: our hba card information.
- * @irq: irq number.
  * @stat: stat.
  */
 static irqreturn_t
@@ -4717,10 +4719,8 @@ static int send_task_abort(struct pm8001_hba_info *pm8001_ha, u32 opc,
 	return ret;
 }
 
-/**
+/*
  * pm8001_chip_abort_task - SAS abort task when error or exception happened.
- * @task: the task we wanted to aborted.
- * @flag: the abort flag.
  */
 int pm8001_chip_abort_task(struct pm8001_hba_info *pm8001_ha,
 	struct pm8001_device *pm8001_dev, u8 flag, u32 task_tag, u32 cmd_tag)
@@ -4959,6 +4959,7 @@ int pm8001_chip_set_nvmd_req(struct pm8001_hba_info *pm8001_ha,
  * pm8001_chip_fw_flash_update_build - support the firmware update operation
  * @pm8001_ha: our hba card information.
  * @fw_flash_updata_info: firmware flash update param
+ * @tag: Tag to apply to the payload
  */
 int
 pm8001_chip_fw_flash_update_build(struct pm8001_hba_info *pm8001_ha,
-- 
2.25.1

