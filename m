Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8BFEC433E2
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88024207F9
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:47:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ea0ucSY+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728750AbgGIRrB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728597AbgGIRqR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 13:46:17 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4918EC08E6DC
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 10:46:17 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id l2so2758323wmf.0
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 10:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SJ5riagb5ylGMgLFLpVaPq4YYsW+h0AJ68wtr1RKdm4=;
        b=ea0ucSY+Vq0Zi7i16gO1xXUSw5rmujrM3nKQwkbbgB1jWlmJTMsPaXxxXncGKdpbAq
         FQ0Vb8hL5vW8RID+GfNhv0fnKloeI8fPNECt6mDR95xCWli44zx2o/RS37NilezG4lA9
         yHp/X74DcN2N1+Iz//f8diYi4caEx9zFkkkVGKFiOY9vUxM2jpK9lnIf0KYcbrx7fVS/
         v1EqlkUK08P9e0YR7VT6Ucrkr93tGgta2Oqtqi7rTgeqUOfd73eNt9Ep83wKFB0S0lp5
         sgq4MZVUuIpeVPqIxK/AQ98tTIYK/RasFP3EvtPZjY/YODbbU83hbl+PErH1nHEN9H4N
         RECg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SJ5riagb5ylGMgLFLpVaPq4YYsW+h0AJ68wtr1RKdm4=;
        b=fBIamp3CU425NM1hZC7sZS6kn2tTTYyfXExVB/Uw/6k6xWuVPf+KPOJMaOSv4+puYr
         LOzcOqEL/3Mgl5SGYyaWncbjyiEPv7hgXI+RJwm7YTjSSh9qUehoTous1RNZJg3Rh7AQ
         8utVc+kPk7lwMR4UGBr8HuIUf6NNTqXZf9WYG8dg1guVlRgMz8kj3GwGNxkKo90lTsrc
         DWEUsjQkdqa/j78+Gr+1ni0WtZz8pQkqUx1lQrsDw583OfvipJDfrRpZ7Z/Xew6Noery
         XKnGNTcNafq8+t22EEy3p3wa7SWzbmS4NjYaw1pt14vs95U0X6MI2Hnn0Re7dB09jWiz
         IlTw==
X-Gm-Message-State: AOAM5315IQJ8oiDfmhwYo1O/93UTFueDwJKzK8ZJHs1atutrEWQRkV4j
        49b5DNlWbwVJu0ig8aSO1cjp5A==
X-Google-Smtp-Source: ABdhPJz2C0PWGGgOBLpKDtOyIt3mWW9jH0LlQzF8TiMNreEzFo79gBy4+hnAO5A337QoQLn4fUvtmA==
X-Received: by 2002:a05:600c:2241:: with SMTP id a1mr1100629wmm.168.1594316775933;
        Thu, 09 Jul 2020 10:46:15 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id f15sm6063854wrx.91.2020.07.09.10.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 10:46:15 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Hannes Reinecke <hare@kernel.org>, Linux GmbH <hare@suse.com>,
        "Leonard N. Zubkoff" <lnz@dandelion.com>
Subject: [PATCH 15/24] scsi: myrs: Demote obvious misuse of kerneldoc to standard comment blocks
Date:   Thu,  9 Jul 2020 18:45:47 +0100
Message-Id: <20200709174556.7651-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709174556.7651-1-lee.jones@linaro.org>
References: <20200709174556.7651-1-lee.jones@linaro.org>
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

