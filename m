Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA13C43217
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Feb 2022 18:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238673AbiBGSL5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Feb 2022 13:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359509AbiBGSEv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2022 13:04:51 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6E0C0401D9
        for <linux-scsi@vger.kernel.org>; Mon,  7 Feb 2022 10:04:50 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id x3so11758605pll.3
        for <linux-scsi@vger.kernel.org>; Mon, 07 Feb 2022 10:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7jOlrkmFksmIUoLnO7HTHXzvifplPAJeu6XnC9sZz30=;
        b=Ya2qtFfHgg78B9g4waHxnpPRF+OFW6nknT8eSx0hM8FUdObqNpFIJka9vLloAleIMx
         bpDZwwNS42gigExFNM9jdPyAfHbrn31qJpbk1rSvN7aTL4VDOlyg0sTffqzlqZYbkhFI
         ervZ1AxkRY6nXUjNUpKPU9+eHz08TrIeLrLjU+0PlnL+KZOP/lW4Jov05RHGCobTmAhO
         pgCZ/vjsK9h0dKTaCSz4fpl4yVmb07t7YfmhBvA/shVzQy7T+H1A6PFXPqCZy+Bv/hqN
         y6O7AHqzWmSy2r9WWE08uJcPAVFsYsSnRTE8gWurG9Ib9akOlhJdZK6Z4/GuC/bL/ZzZ
         MrMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7jOlrkmFksmIUoLnO7HTHXzvifplPAJeu6XnC9sZz30=;
        b=sqxm5rcBe2bipiZHjuwG6m64L7BU7W+mdgEHzD5ed+ZQdvq1uDZIBxJCXRi3vJ68Pe
         xi7HRsPcMXgVXHsJz5/RztZOZqzJOF+ttCgLgm+oRoMHxnv9Dr1coMiyhfkw9DfR16K/
         E/XTQBPhOAsyz4h4V5ObrZiSue2X7agFY24vV/y06GE3VqGwV57XsvVRb6mnux8pklpp
         xUgomb5vIOnU98pM3TxqzrgL8NPIX9Gk5bxzdyYCJfPztGVY7rlXro/E8FTOnCUflrr4
         /IIX2IbcHRjMIVqh2c0Kv7/HB5LxZJXj/yvZTnsHCdh+0/YbqovWCfeNtXqInz6YRHgY
         NFCQ==
X-Gm-Message-State: AOAM531KMXEm5oZk7ginehT/LlyGDxk0oLGM0z1GZ31WPD3xG6IPtwgx
        QhGrhk2Iipfn3CvNgFYkri6/SU7R/0Y=
X-Google-Smtp-Source: ABdhPJwk84NBVpeAxJT23i3kO4R8j9mtI2UB4Z1br3EUMqHPc3yOwl3D6HSN2RGtYmf1Fk8vAS/t+A==
X-Received: by 2002:a17:902:d3c6:: with SMTP id w6mr536846plb.4.1644257089650;
        Mon, 07 Feb 2022 10:04:49 -0800 (PST)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e20sm12284612pfn.4.2022.02.07.10.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 10:04:49 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH] lpfc: Reduce log messages see after successful firmware download
Date:   Mon,  7 Feb 2022 10:04:42 -0800
Message-Id: <20220207180442.72836-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Messages around fw download were incorrectly tagged as being related to
discovery trace events. Thus, fw download status ended up dumping the
trace log as well as the fw update message. As there were a couple of
log messages in this state, the trace log was dumped multiple times.

Resolved by converting from trace events to sli events.

Cut against 5.18/scsi-queue

Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 drivers/scsi/lpfc/lpfc_sli.c  | 8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a56f01f659f8..558f7d2559c4 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2104,7 +2104,7 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
 		}
 		if (reg_err1 == SLIPORT_ERR1_REG_ERR_CODE_2 &&
 		    reg_err2 == SLIPORT_ERR2_REG_FW_RESTART) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 					"3143 Port Down: Firmware Update "
 					"Detected\n");
 			en_rn_msg = false;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 1bc0db572d9e..430abebf99f1 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -13363,6 +13363,7 @@ lpfc_sli4_eratt_read(struct lpfc_hba *phba)
 	uint32_t uerr_sta_hi, uerr_sta_lo;
 	uint32_t if_type, portsmphr;
 	struct lpfc_register portstat_reg;
+	u32 logmask;
 
 	/*
 	 * For now, use the SLI4 device internal unrecoverable error
@@ -13413,7 +13414,12 @@ lpfc_sli4_eratt_read(struct lpfc_hba *phba)
 				readl(phba->sli4_hba.u.if_type2.ERR1regaddr);
 			phba->work_status[1] =
 				readl(phba->sli4_hba.u.if_type2.ERR2regaddr);
-			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+			logmask = LOG_TRACE_EVENT;
+			if (phba->work_status[0] ==
+				SLIPORT_ERR1_REG_ERR_CODE_2 &&
+			    phba->work_status[1] == SLIPORT_ERR2_REG_FW_RESTART)
+				logmask = LOG_SLI;
+			lpfc_printf_log(phba, KERN_ERR, logmask,
 					"2885 Port Status Event: "
 					"port status reg 0x%x, "
 					"port smphr reg 0x%x, "
-- 
2.26.2

