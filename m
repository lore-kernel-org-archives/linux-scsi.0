Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36B5EC433E7
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 110962072D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:01:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="I7D/FMa6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgGMIBK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729307AbgGMIAZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 04:00:25 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7163BC08C5DD
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:25 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f18so12209919wml.3
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SJ5riagb5ylGMgLFLpVaPq4YYsW+h0AJ68wtr1RKdm4=;
        b=I7D/FMa6LFLgK70CbtOGV38nxcM7oGYUXV8zIYRuOU7EGDK5/LDS29iHNrhXTITdmk
         8R2W7+2d5Cq4geX3W52cAO9WBjauR7t2POg/t7DzPKpuLXoTI0Uqy5syGeOd0ShQDR8L
         h0R9fycIJe+lJG014nzzzlD7E9SFI1/fYpYUSfrc9L34A3JrugmyyDMNXaaJDSo6QfEz
         7FnDKEFkDiVB4ulKJBsTfEa8YL2Nd3jbHoFuIUjqJnyHFdQCzy81ljMAMYrNu43+qfW8
         JLRtNfkDRSdS0N2ETb2iApzGv/lOkpS+kEdwOIWSr/WAITkKstnZbhGbUS0kLZAP5er6
         hZJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SJ5riagb5ylGMgLFLpVaPq4YYsW+h0AJ68wtr1RKdm4=;
        b=dcU8Keig4QzqoJ3+Ia80O+TpLM1VKldhqggfzc/dSWtaM2Vl70elB1BmFC+6Mz35UQ
         Qh3Gbd0/doceIsL0Q07f7kR9VBHgjfUyseoacrMlm2Kri9lwdb+T9MksMwet1nWIX4bL
         zd3Vq+ZPSOEjcb3BottJ4F8QIzTbA9NYVkxLeYhscIaRr9wT+kZ730snvSACJO6sfJPk
         hOxHxBqihE9c2lzhm0ltv6YWGOTDlobKL8fgGwslzIM8MBSzDOc4ERzSeGzwV9YqlmKm
         riJ7IJS9KrOte1M5/y6qDoYFUMaSMA1jU85WvHqiiV2jnONPJyR35kyyPTcb+omPfcw6
         8xkQ==
X-Gm-Message-State: AOAM530eAQpAVGY330/Xa1MiEXlJh7HAsj5O9LUW5uNWdD8Ysm8JFNo+
        KqGwauB9Z7GKSCMpnk2irC3/xg==
X-Google-Smtp-Source: ABdhPJxARuNXSMJsyjWyd39e8lh2N3H2K2RJqoy63HYCBTCKIMMHAOZ3AEd41aJOw/5fYhuISbWhiA==
X-Received: by 2002:a05:600c:204d:: with SMTP id p13mr17571223wmg.88.1594627224155;
        Mon, 13 Jul 2020 01:00:24 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id 33sm24383549wri.16.2020.07.13.01.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 01:00:23 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@kernel.org>, Linux GmbH <hare@suse.com>,
        "Leonard N. Zubkoff" <lnz@dandelion.com>
Subject: [PATCH v2 15/24] scsi: myrs: Demote obvious misuse of kerneldoc to standard comment blocks
Date:   Mon, 13 Jul 2020 08:59:52 +0100
Message-Id: <20200713080001.128044-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713080001.128044-1-lee.jones@linaro.org>
References: <20200713080001.128044-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

No attempt has been made to document any of the demoted functions here.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/myrs.c:94: warning: Function parameter or member 'cmd_blk' not described in 'myrs_reset_cmd'
 drivers/scsi/myrs.c:105: warning: Function parameter or member 'cs' not described in 'myrs_qcmd'
 drivers/scsi/myrs.c:105: warning: Function parameter or member 'cmd_blk' not described in 'myrs_qcmd'
 drivers/scsi/myrs.c:130: warning: Function parameter or member 'cs' not described in 'myrs_exec_cmd'
 drivers/scsi/myrs.c:130: warning: Function parameter or member 'cmd_blk' not described in 'myrs_exec_cmd'
 drivers/scsi/myrs.c:149: warning: Function parameter or member 'cs' not described in 'myrs_report_progress'
 drivers/scsi/myrs.c:149: warning: Function parameter or member 'ldev_num' not described in 'myrs_report_progress'
 drivers/scsi/myrs.c:149: warning: Function parameter or member 'msg' not described in 'myrs_report_progress'
 drivers/scsi/myrs.c:149: warning: Function parameter or member 'blocks' not described in 'myrs_report_progress'
 drivers/scsi/myrs.c:149: warning: Function parameter or member 'size' not described in 'myrs_report_progress'
 drivers/scsi/myrs.c:160: warning: Function parameter or member 'cs' not described in 'myrs_get_ctlr_info'
 drivers/scsi/myrs.c:222: warning: Function parameter or member 'cs' not described in 'myrs_get_ldev_info'
 drivers/scsi/myrs.c:222: warning: Function parameter or member 'ldev_num' not described in 'myrs_get_ldev_info'
 drivers/scsi/myrs.c:222: warning: Function parameter or member 'ldev_info' not described in 'myrs_get_ldev_info'
 drivers/scsi/myrs.c:310: warning: Function parameter or member 'cs' not described in 'myrs_get_pdev_info'
 drivers/scsi/myrs.c:310: warning: Function parameter or member 'channel' not described in 'myrs_get_pdev_info'
 drivers/scsi/myrs.c:310: warning: Function parameter or member 'target' not described in 'myrs_get_pdev_info'
 drivers/scsi/myrs.c:310: warning: Function parameter or member 'lun' not described in 'myrs_get_pdev_info'
 drivers/scsi/myrs.c:310: warning: Function parameter or member 'pdev_info' not described in 'myrs_get_pdev_info'
 drivers/scsi/myrs.c:353: warning: Function parameter or member 'cs' not described in 'myrs_dev_op'
 drivers/scsi/myrs.c:353: warning: Function parameter or member 'opcode' not described in 'myrs_dev_op'
 drivers/scsi/myrs.c:353: warning: Function parameter or member 'opdev' not described in 'myrs_dev_op'
 drivers/scsi/myrs.c:379: warning: Function parameter or member 'cs' not described in 'myrs_translate_pdev'
 drivers/scsi/myrs.c:379: warning: Function parameter or member 'channel' not described in 'myrs_translate_pdev'
 drivers/scsi/myrs.c:379: warning: Function parameter or member 'target' not described in 'myrs_translate_pdev'
 drivers/scsi/myrs.c:379: warning: Function parameter or member 'lun' not described in 'myrs_translate_pdev'
 drivers/scsi/myrs.c:379: warning: Function parameter or member 'devmap' not described in 'myrs_translate_pdev'
 drivers/scsi/myrs.c:422: warning: Function parameter or member 'cs' not described in 'myrs_get_event'
 drivers/scsi/myrs.c:422: warning: Function parameter or member 'event_num' not described in 'myrs_get_event'
 drivers/scsi/myrs.c:422: warning: Function parameter or member 'event_buf' not described in 'myrs_get_event'
 drivers/scsi/myrs.c:484: warning: Function parameter or member 'cs' not described in 'myrs_enable_mmio_mbox'
 drivers/scsi/myrs.c:484: warning: Function parameter or member 'enable_mbox_fn' not described in 'myrs_enable_mmio_mbox'
 drivers/scsi/myrs.c:584: warning: Function parameter or member 'cs' not described in 'myrs_get_config'
 drivers/scsi/myrs.c:688: warning: cannot understand function prototype: 'struct '
 drivers/scsi/myrs.c:1967: warning: Function parameter or member 'dev' not described in 'myrs_is_raid'
 drivers/scsi/myrs.c:1980: warning: Function parameter or member 'dev' not described in 'myrs_get_resync'
 drivers/scsi/myrs.c:2005: warning: Function parameter or member 'dev' not described in 'myrs_get_state'
 drivers/scsi/myrs.c:2343: warning: bad line:   the Error Status Register when the driver performs the BIOS handshaking.
 drivers/scsi/myrs.c:2344: warning: bad line:   It returns true for fatal errors and false otherwise.
 drivers/scsi/myrs.c:2349: warning: Function parameter or member 'cs' not described in 'myrs_err_status'
 drivers/scsi/myrs.c:2349: warning: Function parameter or member 'status' not described in 'myrs_err_status'
 drivers/scsi/myrs.c:2349: warning: Function parameter or member 'parm0' not described in 'myrs_err_status'
 drivers/scsi/myrs.c:2349: warning: Function parameter or member 'parm1' not described in 'myrs_err_status'

Cc: Hannes Reinecke <hare@kernel.org>
Cc: Linux GmbH <hare@suse.com>
Cc: "Leonard N. Zubkoff" <lnz@dandelion.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/myrs.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 5c5666491c2ee..103803e779f2d 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -87,7 +87,7 @@ static char *myrs_raid_level_name(enum myrs_raid_level level)
 	return NULL;
 }
 
-/**
+/*
  * myrs_reset_cmd - clears critical fields in struct myrs_cmdblk
  */
 static inline void myrs_reset_cmd(struct myrs_cmdblk *cmd_blk)
@@ -98,7 +98,7 @@ static inline void myrs_reset_cmd(struct myrs_cmdblk *cmd_blk)
 	cmd_blk->status = 0;
 }
 
-/**
+/*
  * myrs_qcmd - queues Command for DAC960 V2 Series Controllers.
  */
 static void myrs_qcmd(struct myrs_hba *cs, struct myrs_cmdblk *cmd_blk)
@@ -122,7 +122,7 @@ static void myrs_qcmd(struct myrs_hba *cs, struct myrs_cmdblk *cmd_blk)
 	cs->next_cmd_mbox = next_mbox;
 }
 
-/**
+/*
  * myrs_exec_cmd - executes V2 Command and waits for completion.
  */
 static void myrs_exec_cmd(struct myrs_hba *cs,
@@ -140,7 +140,7 @@ static void myrs_exec_cmd(struct myrs_hba *cs,
 	wait_for_completion(&complete);
 }
 
-/**
+/*
  * myrs_report_progress - prints progress message
  */
 static void myrs_report_progress(struct myrs_hba *cs, unsigned short ldev_num,
@@ -153,7 +153,7 @@ static void myrs_report_progress(struct myrs_hba *cs, unsigned short ldev_num,
 		     (100 * (int)(blocks >> 7)) / (int)(size >> 7));
 }
 
-/**
+/*
  * myrs_get_ctlr_info - executes a Controller Information IOCTL Command
  */
 static unsigned char myrs_get_ctlr_info(struct myrs_hba *cs)
@@ -214,7 +214,7 @@ static unsigned char myrs_get_ctlr_info(struct myrs_hba *cs)
 	return status;
 }
 
-/**
+/*
  * myrs_get_ldev_info - executes a Logical Device Information IOCTL Command
  */
 static unsigned char myrs_get_ldev_info(struct myrs_hba *cs,
@@ -301,7 +301,7 @@ static unsigned char myrs_get_ldev_info(struct myrs_hba *cs,
 	return status;
 }
 
-/**
+/*
  * myrs_get_pdev_info - executes a "Read Physical Device Information" Command
  */
 static unsigned char myrs_get_pdev_info(struct myrs_hba *cs,
@@ -345,7 +345,7 @@ static unsigned char myrs_get_pdev_info(struct myrs_hba *cs,
 	return status;
 }
 
-/**
+/*
  * myrs_dev_op - executes a "Device Operation" Command
  */
 static unsigned char myrs_dev_op(struct myrs_hba *cs,
@@ -369,7 +369,7 @@ static unsigned char myrs_dev_op(struct myrs_hba *cs,
 	return status;
 }
 
-/**
+/*
  * myrs_translate_pdev - translates a Physical Device Channel and
  * TargetID into a Logical Device.
  */
@@ -414,7 +414,7 @@ static unsigned char myrs_translate_pdev(struct myrs_hba *cs,
 	return status;
 }
 
-/**
+/*
  * myrs_get_event - executes a Get Event Command
  */
 static unsigned char myrs_get_event(struct myrs_hba *cs,
@@ -476,7 +476,7 @@ static unsigned char myrs_get_fwstatus(struct myrs_hba *cs)
 	return status;
 }
 
-/**
+/*
  * myrs_enable_mmio_mbox - enables the Memory Mailbox Interface
  */
 static bool myrs_enable_mmio_mbox(struct myrs_hba *cs,
@@ -577,7 +577,7 @@ static bool myrs_enable_mmio_mbox(struct myrs_hba *cs,
 	return (status == MYRS_STATUS_SUCCESS);
 }
 
-/**
+/*
  * myrs_get_config - reads the Configuration Information
  */
 static int myrs_get_config(struct myrs_hba *cs)
@@ -682,7 +682,7 @@ static int myrs_get_config(struct myrs_hba *cs)
 	return 0;
 }
 
-/**
+/*
  * myrs_log_event - prints a Controller Event message
  */
 static struct {
@@ -2338,11 +2338,11 @@ static struct myrs_hba *myrs_detect(struct pci_dev *pdev,
 	return NULL;
 }
 
-/**
+/*
  * myrs_err_status reports Controller BIOS Messages passed through
-  the Error Status Register when the driver performs the BIOS handshaking.
-  It returns true for fatal errors and false otherwise.
-*/
+ * the Error Status Register when the driver performs the BIOS handshaking.
+ * It returns true for fatal errors and false otherwise.
+ */
 
 static bool myrs_err_status(struct myrs_hba *cs, unsigned char status,
 		unsigned char parm0, unsigned char parm1)
-- 
2.25.1

