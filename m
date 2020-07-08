Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD73FC433E1
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:03:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88D04207DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:03:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yzdKPR8L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729234AbgGHMDL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729230AbgGHMDK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:03:10 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81F8C08C5DC
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:03:09 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id g75so2705851wme.5
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d7D7AfDQQG73fSw4f21gOz4vhVntWScnapCoKvjgVSM=;
        b=yzdKPR8LmjXafIM30grkb0E+LW79z46rqDXm9mEWI86cQMpo85admAyJckDe32ioy3
         Y+/tQzNQW+VY1amhzFzVpMR7XyOYzzrKFTG/xS8UjMQ8crFfdCVlaTGUxw9Fbx9khpTW
         Cu6D4FUjxcj0ovqqy9n8v+274LaGFqN8iWjbMBXYsUgBAZ4otDdZ0gCGJFsFiItATOvW
         bvoCE4xtS+DO82Pzz15fBgxnG+wqQE3nlWVnhvSGdHLafONqrnn4pxfqv1LZHT84O/lp
         So9qQYGVA5Xf8pRvRF/gUz3BJxNWSi9GQFPbyzIhhC/X5X8AWUIuwGC7Vz+sWOcK0y4o
         qy1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d7D7AfDQQG73fSw4f21gOz4vhVntWScnapCoKvjgVSM=;
        b=K8Q46ASOuVpE76GjJ9y/4xiTICWIBbFOkGOoeK8sRaKTDvkXOZQVjT/PW21+w1+ScM
         nRvejsVGo3ZMsEuynXWuRHheD1J7w1k2r/lqirXsEhiK0YLOKZ7P3nOy8aLeAvj7eTAa
         n50hH9W0wk6qL6qkP9l9WdHLlh2lEM3KXa7Wltd0lJ88j9y57DbMVHhEY5tXolUImc0x
         gpb6oVWCdLlzp4nE7vuw2JGHe/sCXav1fmHmr5bn0GEQRfZSBESPrUTRbQcKPqty8x8n
         itA4pBVzqcnd6XfpHhoOybOvRvt/GkrRhFnJHKZ8Q8Xygc5DzQrGSlAZaYULKbyPvZTB
         D4DA==
X-Gm-Message-State: AOAM532RhBLRtQdW+cno2+fQzotfLZSyubfJisDf574fCViqDh4BUV7F
        Lpnk7ZU8Yph3AMQFCBk3ngU9XA==
X-Google-Smtp-Source: ABdhPJzdvUY503n425HeR/FqzogV0LWtQyotNCGukbYwNiIlFSv32ZgKGIiJMG2t9LP/0bHWyzltXg==
X-Received: by 2002:a1c:7d56:: with SMTP id y83mr9527216wmc.154.1594209788425;
        Wed, 08 Jul 2020 05:03:08 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:03:07 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Subject: [PATCH 29/30] scsi: aacraid: aachba: Fix a bunch of function doc formatting errors
Date:   Wed,  8 Jul 2020 13:02:20 +0100
Message-Id: <20200708120221.3386672-30-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708120221.3386672-1-lee.jones@linaro.org>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

And a few missing/excessive parameter descriptions.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/aacraid/aachba.c:358: warning: Function parameter or member 'dev' not described in 'aac_get_config_status'
 drivers/scsi/aacraid/aachba.c:358: warning: Function parameter or member 'commit_flag' not described in 'aac_get_config_status'
 drivers/scsi/aacraid/aachba.c:358: warning: Excess function parameter 'common' description in 'aac_get_config_status'
 drivers/scsi/aacraid/aachba.c:450: warning: Function parameter or member 'dev' not described in 'aac_get_containers'
 drivers/scsi/aacraid/aachba.c:450: warning: Excess function parameter 'common' description in 'aac_get_containers'
 drivers/scsi/aacraid/aachba.c:568: warning: Function parameter or member 'scsicmd' not described in 'aac_get_container_name'
 drivers/scsi/aacraid/aachba.c:796: warning: Function parameter or member 'scsicmd' not described in 'aac_probe_container_callback1'
 drivers/scsi/aacraid/aachba.c:796: warning: Excess function parameter 'dev' description in 'aac_probe_container_callback1'
 drivers/scsi/aacraid/aachba.c:796: warning: Excess function parameter 'cid' description in 'aac_probe_container_callback1'
 drivers/scsi/aacraid/aachba.c:1105: warning: Function parameter or member 'scsicmd' not described in 'aac_get_container_serial'
 drivers/scsi/aacraid/aachba.c:1961: warning: Excess function parameter 'phys_luns' description in 'aac_set_safw_attr_all_targets'
 drivers/scsi/aacraid/aachba.c:1961: warning: Excess function parameter 'rescan' description in 'aac_set_safw_attr_all_targets'
 drivers/scsi/aacraid/aachba.c:3394: warning: Cannot understand  *
 on line 3394 - I thought it was a doc line
 drivers/scsi/aacraid/aachba.c:3687: warning: Cannot understand  *
 on line 3687 - I thought it was a doc line
 drivers/scsi/aacraid/aachba.c:3752: warning: Cannot understand  *
 on line 3752 - I thought it was a doc line
 drivers/scsi/aacraid/aachba.c:3795: warning: Cannot understand  *
 on line 3795 - I thought it was a doc line

Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Cc: "PMC-Sierra, Inc" <aacraid@pmc-sierra.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/aacraid/aachba.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 2b868f8db8ffe..7ae1e545a255c 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -561,7 +561,7 @@ static void get_container_name_callback(void *context, struct fib * fibptr)
 	scsicmd->scsi_done(scsicmd);
 }
 
-/**
+/*
  *	aac_get_container_name	-	get container name, none blocking.
  */
 static int aac_get_container_name(struct scsi_cmnd * scsicmd)
@@ -786,8 +786,7 @@ static int _aac_probe_container(struct scsi_cmnd * scsicmd, int (*callback)(stru
 
 /**
  *	aac_probe_container		-	query a logical volume
- *	@dev: device to query
- *	@cid: container identifier
+ * @scsicmd: the scsi command block
  *
  *	Queries the controller about the given volume. The volume information
  *	is updated in the struct fsa_dev_info structure rather than returned.
@@ -1098,7 +1097,7 @@ static void get_container_serial_callback(void *context, struct fib * fibptr)
 	scsicmd->scsi_done(scsicmd);
 }
 
-/**
+/*
  *	aac_get_container_serial - get container serial, none blocking.
  */
 static int aac_get_container_serial(struct scsi_cmnd * scsicmd)
@@ -1952,8 +1951,6 @@ static int aac_get_safw_attr_all_targets(struct aac_dev *dev)
 /**
  *	aac_set_safw_attr_all_targets-	update current hba map with data from FW
  *	@dev:	aac_dev structure
- *	@phys_luns: FW information from report phys luns
- *	@rescan: Indicates scan type
  *
  *	Update our hba map with the information gathered from the FW
  */
@@ -3391,15 +3388,12 @@ int aac_dev_ioctl(struct aac_dev *dev, unsigned int cmd, void __user *arg)
 }
 
 /**
- *
  * aac_srb_callback
  * @context: the context set in the fib - here it is scsi cmd
  * @fibptr: pointer to the fib
  *
  * Handles the completion of a scsi command to a non dasd device
- *
  */
-
 static void aac_srb_callback(void *context, struct fib * fibptr)
 {
 	struct aac_srb_reply *srbreply;
@@ -3684,13 +3678,11 @@ static void hba_resp_task_failure(struct aac_dev *dev,
 }
 
 /**
- *
  * aac_hba_callback
  * @context: the context set in the fib - here it is scsi cmd
  * @fibptr: pointer to the fib
  *
  * Handles the completion of a native HBA scsi command
- *
  */
 void aac_hba_callback(void *context, struct fib *fibptr)
 {
@@ -3749,14 +3741,12 @@ void aac_hba_callback(void *context, struct fib *fibptr)
 }
 
 /**
- *
  * aac_send_srb_fib
  * @scsicmd: the scsi command block
  *
  * This routine will form a FIB and fill in the aac_srb from the
  * scsicmd passed in.
  */
-
 static int aac_send_srb_fib(struct scsi_cmnd* scsicmd)
 {
 	struct fib* cmd_fibcontext;
@@ -3792,7 +3782,6 @@ static int aac_send_srb_fib(struct scsi_cmnd* scsicmd)
 }
 
 /**
- *
  * aac_send_hba_fib
  * @scsicmd: the scsi command block
  *
-- 
2.25.1

