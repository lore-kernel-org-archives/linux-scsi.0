Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C46AFC433E5
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:44:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A01E620720
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:44:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mjULXsS+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730905AbgGUQn5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730684AbgGUQm2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:28 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48298C0619DF
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:28 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z15so21825011wrl.8
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XGTsDAIvYg7OoXRgnP3n/W6+fXiTQfVQsRFU0wHYrcE=;
        b=mjULXsS+2dTrdCLkuMlJ2woTYq6hqIau2y6VEUHF8aT9eWMLiH4W//CdsBJRoCQvP3
         xHUdpwQ8WlRgcf6LuuTjIPBJTAECVhXmWla3NRyPtEHp/uPxm13MgH5fJFzygR73Dnac
         4WV4CevyfD8n3Vwt0PSVfnHWEKfit4Pml3BZRVDv0LxRK1JAnxw4Ng4FFSB/SAZCfg+c
         L44fbzar46IgCbXiXXZJsG50oMsh2LeqIAMyK0a6vrnKQtdrYcuOnvHetsmBhUw81fCo
         c7ilCsxZBvGaNY0H2o+kvNlGIAm35wFuRgbP1fGCcPrgU4QTM0qaZbRuZYQJP5zQeV+6
         metg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XGTsDAIvYg7OoXRgnP3n/W6+fXiTQfVQsRFU0wHYrcE=;
        b=dYVsXDykEBmzwFzKCcdsoPD7IPVddF6hFQE20BFd3CNba9pV/zitW4ceaRJp1+nI3n
         eWGrkxXbnJqXeGxkIT4D9/R0j2OuhRhESqphm1yMcEYwnk4MKAMFT1X3klAdHbs3Me4Q
         fuXBepmA4J+khIq9VsvPvju+IONBRPZ7B/mAB+CO9kMeAVgT6Lh6Q/8rc/y00K45wwKz
         6dHl+dfztzDPJucAV4mU8PGbIjbQ+5QTGOw0wXJlkEJp18wALlAtJjDVh6Y1Qlwze/MI
         ReuJGbAG8v2GpNNBU5uOBXfpmTu8Mg6gMN+5PwDaKX4jBbM2sfZI3ZMuu3tuyffvbU8T
         XjoA==
X-Gm-Message-State: AOAM533FTdwz3rI8uZrfS+OVEbuupIh5Q1uMlh5pLe+Plue01dJsRey+
        lHaNKcUHfPjsyqv3AD5Y2SDTiQ==
X-Google-Smtp-Source: ABdhPJwG1OE906l5grFbQNBoCjJKAoJlImEF+s33J6yAwy5+NJjSpIyLKLC+omAwKoTc1S+6F5ikrA==
X-Received: by 2002:adf:f10a:: with SMTP id r10mr26815356wro.406.1595349747035;
        Tue, 21 Jul 2020 09:42:27 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:26 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@qlogic.com
Subject: [PATCH 21/40] scsi: qla4xxx: ql4_mbx: Fix-up incorrectly documented parameter
Date:   Tue, 21 Jul 2020 17:41:29 +0100
Message-Id: <20200721164148.2617584-22-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Also demote incomplete header from kerneldoc.

Fixes the following W=1 kernel build warning(s):

from  drivers/scsi/qla4xxx/ql4_mbx.c:9:
 drivers/scsi/qla4xxx/ql4_mbx.c:53: warning: Excess function parameter 'ret' description in 'qla4xxx_is_intr_poll_mode'
 drivers/scsi/qla4xxx/ql4_mbx.c:832: warning: Function parameter or member 'fw_ddb_entry_dma' not described in 'qla4xxx_get_fwddb_entry'
 drivers/scsi/qla4xxx/ql4_mbx.c:832: warning: Function parameter or member 'conn_err_detail' not described in 'qla4xxx_get_fwddb_entry'
 drivers/scsi/qla4xxx/ql4_mbx.c:832: warning: Function parameter or member 'tcp_source_port_num' not described in 'qla4xxx_get_fwddb_entry'
 drivers/scsi/qla4xxx/ql4_mbx.c:832: warning: Function parameter or member 'connection_id' not described in 'qla4xxx_get_fwddb_entry'
 drivers/scsi/qla4xxx/ql4_mbx.c:1271: warning: Function parameter or member 'ddb_entry' not described in 'qla4xxx_reset_target'
 drivers/scsi/qla4xxx/ql4_mbx.c:1271: warning: Excess function parameter 'db_entry' description in 'qla4xxx_reset_target'
 drivers/scsi/qla4xxx/ql4_mbx.c:1271: warning: Excess function parameter 'un_entry' description in 'qla4xxx_reset_target'

Cc: QLogic-Storage-Upstream@qlogic.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qla4xxx/ql4_mbx.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 02636b4785c58..bc8de7d402d58 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -47,7 +47,7 @@ void qla4xxx_process_mbox_intr(struct scsi_qla_host *ha, int out_count)
 /**
  * qla4xxx_is_intr_poll_mode – Are we allowed to poll for interrupts?
  * @ha: Pointer to host adapter structure.
- * @ret: 1=polling mode, 0=non-polling mode
+ * returns: 1=polling mode, 0=non-polling mode
  **/
 static int qla4xxx_is_intr_poll_mode(struct scsi_qla_host *ha)
 {
@@ -810,7 +810,7 @@ int qla4xxx_get_firmware_status(struct scsi_qla_host * ha)
 	return QLA_SUCCESS;
 }
 
-/**
+/*
  * qla4xxx_get_fwddb_entry - retrieves firmware ddb entry
  * @ha: Pointer to host adapter structure.
  * @fw_ddb_index: Firmware's device database index
@@ -1259,8 +1259,7 @@ int qla4xxx_reset_lun(struct scsi_qla_host * ha, struct ddb_entry * ddb_entry,
 /**
  * qla4xxx_reset_target - issues target Reset
  * @ha: Pointer to host adapter structure.
- * @db_entry: Pointer to device database entry
- * @un_entry: Pointer to lun entry structure
+ * @ddb_entry: Pointer to device database entry
  *
  * This routine performs a TARGET RESET on the specified target.
  * The caller must ensure that the ddb_entry pointers
-- 
2.25.1

