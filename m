Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC76DC433E5
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAC6E20792
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:42:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AO7GkYO/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730718AbgGUQmh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730705AbgGUQmg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:36 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819B7C0619E1
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:35 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id o11so21854313wrv.9
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uWGcoDbdOCeXSfDJ7sgMSwsNsITB0wPLhyaeMZZYPL8=;
        b=AO7GkYO/QQsdC0xfeZ3GEeVEaaNo4oCAOSqLpw/zWEIM1iU4vY1XjvExkH6B5Dxb7Q
         i1I5VsxZM49xY4c8B1pTBUjceeX8JHT2iWZDWZ3bbQmnLplZx6cY1AMmJUXag7SNMTT6
         XkNVU97d9RuUawfFky0h3mF6O+Vdnu/8nMAu7GYmVTPDx5b/XPQm2YKPvLNOqcZs7oCB
         09GCfnWt/M032NtEpUih8zRz2SqH54FckHH/973upwKV98o1cZuz+kc+gQX+8N8qNWHC
         Qj8KFYug1JGafwlD6ViLcmHup8wPnMp9I147H90/JC6IU1eI5qWuWWbmn5AjpoFKohdw
         5Ngg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uWGcoDbdOCeXSfDJ7sgMSwsNsITB0wPLhyaeMZZYPL8=;
        b=nmR2sPHo8N09RTCt6zBp5OfFysEStTeWMfh61MWAi64LElwdAbqg/VLV72iHH5cLnS
         VGskbNEE9FdsHJUI5vVKSOUXY7s5weRI4zzE+63MXjFryax3qCLRcXDo4DVOHXcEUIi/
         k15P0QXXozuwZyYpjC4Oa6k1ZEq7unT/6mTzr6qHsvC5k7n39peTumKo9+PQNyu872Mc
         hTGpTNJesmFPIu8PFf6CBydylIscGu0xJ7llwWQa5ZBEh3bBCcICTA9+3KgsbxFur7i5
         ohQztCy24ekqgi2rdb6u1CwunnOeK8hfJ/OkKsPqVw5117Fj2rWjBWxVY/DxyQiipVtl
         Buyg==
X-Gm-Message-State: AOAM5307Qdh0d0WhvUjPuegK8yfy1UHZnS/2dG83K52rrvBDHQFiHlRL
        Wf1/NY9VHe+14H5lWwQrlo/EHg==
X-Google-Smtp-Source: ABdhPJyK56jbkP7sZ+D1Eqs3NuLuowXuh4B7ZUXY980g6x4X71fDp1nF2xoPdBZea9tNyPRzAwhfgA==
X-Received: by 2002:adf:97c1:: with SMTP id t1mr1259084wrb.294.1595349754215;
        Tue, 21 Jul 2020 09:42:34 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:33 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@qlogic.com
Subject: [PATCH 26/40] scsi: qla4xxx: ql4_os: Fix some kerneldoc parameter documentation issues
Date:   Tue, 21 Jul 2020 17:41:34 +0100
Message-Id: <20200721164148.2617584-27-lee.jones@linaro.org>
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

 drivers/scsi/qla4xxx/ql4_os.c:4551: warning: Function parameter or member 't' not described in 'qla4xxx_timer'
 drivers/scsi/qla4xxx/ql4_os.c:4551: warning: Excess function parameter 'ha' description in 'qla4xxx_timer'
 drivers/scsi/qla4xxx/ql4_os.c:5312: warning: Function parameter or member 'work' not described in 'qla4xxx_do_dpc'
 drivers/scsi/qla4xxx/ql4_os.c:5312: warning: Excess function parameter 'data' description in 'qla4xxx_do_dpc'
 drivers/scsi/qla4xxx/ql4_os.c:8627: warning: Function parameter or member 'ent' not described in 'qla4xxx_probe_adapter'
 drivers/scsi/qla4xxx/ql4_os.c:8627: warning: Excess function parameter 'pci_device_id' description in 'qla4xxx_probe_adapter'
 drivers/scsi/qla4xxx/ql4_os.c:9008: warning: Function parameter or member 'pdev' not described in 'qla4xxx_remove_adapter'
 drivers/scsi/qla4xxx/ql4_os.c:9008: warning: Excess function parameter 'pci_dev' description in 'qla4xxx_remove_adapter'
 drivers/scsi/qla4xxx/ql4_os.c:9181: warning: Function parameter or member 'stgt' not described in 'qla4xxx_eh_wait_for_commands'
 drivers/scsi/qla4xxx/ql4_os.c:9181: warning: Function parameter or member 'sdev' not described in 'qla4xxx_eh_wait_for_commands'
 drivers/scsi/qla4xxx/ql4_os.c:9181: warning: Excess function parameter 't' description in 'qla4xxx_eh_wait_for_commands'
 drivers/scsi/qla4xxx/ql4_os.c:9181: warning: Excess function parameter 'l' description in 'qla4xxx_eh_wait_for_commands'
 drivers/scsi/qla4xxx/ql4_os.c:9646: warning: Function parameter or member 'pdev' not described in 'qla4xxx_pci_mmio_enabled'

Cc: QLogic-Storage-Upstream@qlogic.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qla4xxx/ql4_os.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 2572f7aef8f88..bab87e47b238d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4545,7 +4545,7 @@ static void qla4xxx_check_relogin_flash_ddb(struct iscsi_cls_session *cls_sess)
 
 /**
  * qla4xxx_timer - checks every second for work to do.
- * @ha: Pointer to host adapter structure.
+ * @t: Context to obtain pointer to host adapter structure.
  **/
 static void qla4xxx_timer(struct timer_list *t)
 {
@@ -5299,7 +5299,7 @@ static void qla4xxx_do_work(struct scsi_qla_host *ha)
 
 /**
  * qla4xxx_do_dpc - dpc routine
- * @data: in our case pointer to adapter structure
+ * @work: Context to obtain pointer to host adapter structure.
  *
  * This routine is a task that is schedule by the interrupt handler
  * to perform the background processing for interrupts.  We put it
@@ -8616,7 +8616,7 @@ static void qla4xxx_wait_login_resp_boot_tgt(struct scsi_qla_host *ha)
 /**
  * qla4xxx_probe_adapter - callback function to probe HBA
  * @pdev: pointer to pci_dev structure
- * @pci_device_id: pointer to pci_device entry
+ * @ent: pointer to pci_device entry
  *
  * This routine will probe for Qlogic 4xxx iSCSI host adapters.
  * It returns zero if successful. It also initializes all data necessary for
@@ -9002,7 +9002,7 @@ static void qla4xxx_destroy_fw_ddb_session(struct scsi_qla_host *ha)
 }
 /**
  * qla4xxx_remove_adapter - callback function to remove adapter.
- * @pci_dev: PCI device pointer
+ * @pdev: PCI device pointer
  **/
 static void qla4xxx_remove_adapter(struct pci_dev *pdev)
 {
@@ -9169,8 +9169,8 @@ static int qla4xxx_wait_for_hba_online(struct scsi_qla_host *ha)
 /**
  * qla4xxx_eh_wait_for_commands - wait for active cmds to finish.
  * @ha: pointer to HBA
- * @t: target id
- * @l: lun id
+ * @stgt: pointer to SCSI target
+ * @sdev: pointer to SCSI device
  *
  * This function waits for all outstanding commands to a lun to complete. It
  * returns 0 if all pending commands are returned and 1 otherwise.
@@ -9640,6 +9640,7 @@ qla4xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
  * qla4xxx_pci_mmio_enabled() gets called if
  * qla4xxx_pci_error_detected() returns PCI_ERS_RESULT_CAN_RECOVER
  * and read/write to the device still works.
+ * @pdev: PCI device pointer
  **/
 static pci_ers_result_t
 qla4xxx_pci_mmio_enabled(struct pci_dev *pdev)
-- 
2.25.1

