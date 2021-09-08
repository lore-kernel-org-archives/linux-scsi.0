Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898D4C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 05:09:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63E7461152
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 05:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbhIHFKm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 01:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232089AbhIHFKm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 01:10:42 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B2DC061575
        for <linux-scsi@vger.kernel.org>; Tue,  7 Sep 2021 22:09:35 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id n18so1292263pgm.12
        for <linux-scsi@vger.kernel.org>; Tue, 07 Sep 2021 22:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rj6WJ28u/IzY41n9ZqbPduncpmh/Om6n6FUKbjCQYpY=;
        b=Dl8cUeU5ofL7N52aB/1u9gBT9jqagIrnRQqdwCtpAxYckMkLyMwwP2X/NLFsxzPAvb
         Hb+olvii90Xg+IikTcwUXJXjhHJWq7Ejc3lm9zqrhZoR3GDam1I3CDCanqbBCzkIR/4x
         qE2gNQdJXyDVHISr43Ey8AX9MHcMIV+fEnW6rTuHvsh92RFa1kPNuQ6piDgr3y2s5CB/
         sOQNJKo4EHIVlgdRh6GUxkfjwItNOfb+X/06YjLYGaYSi1xBkpLV4G8FV0GmVo3ZmsRB
         to1vMBj83ilTT4O3sXB5DclN3+vSOD+inuU9XgPqI+TAhzR5AL/vgbmTqaYQN61WQv+n
         Oj5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rj6WJ28u/IzY41n9ZqbPduncpmh/Om6n6FUKbjCQYpY=;
        b=KgYBZ0YdFKyr0m28IJRWIlK7mTst2qUfxUxp+RNSmqfOfi+O6RtQ0+inNftw5KRhSm
         p37XAWY3YG0JAQKopBRZ8JtWW1s4dVp0IhOkhCbotJHbUSZkrTCqscTjZSuGYk2Xs1sT
         WWRXr6JUY4j4zAntUFGaN4P6v5MOseFN7/ixw62UouJl86fWL+C0FgIOJBkoxA89KHfh
         uwpJvjDg2rQ0fQa9esmKIjfhGiwI0OK/eN66C9njq2WBj4qm/M0pBV8iJb2Q/Eb3Fki5
         HWJRjPxHrFvWxrJ7fgc42L5cdXL8faiGhWHLwGrHDRmDfDbXqFZbj1VZdnSNuylv1LTT
         Jl6Q==
X-Gm-Message-State: AOAM531Qq6c9/APfaGLeqiUb15fgbzjOXWhYLVqxEef1wKLt4lDk2gtQ
        QStCHP+5QHu3Mifm62q2SB53WrVBMUPR1g==
X-Google-Smtp-Source: ABdhPJzoHMG6i+CiLJ1q6kGz5fTQm0d+tQD1l/+O1vEFmN7QKMsgxU+o62YJRidzEbY0K++8E4ggcQ==
X-Received: by 2002:a63:e909:: with SMTP id i9mr1945882pgh.162.1631077774771;
        Tue, 07 Sep 2021 22:09:34 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id g16sm749711pfj.19.2021.09.07.22.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 22:09:34 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     nathan@kernel.org, James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v2] lpfc: Fix compilation errors on kernels with no CONFIG_DEBUG_FS
Date:   Tue,  7 Sep 2021 22:09:27 -0700
Message-Id: <20210908050927.37275-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The Kernel test robot flagged the following warning:
".../lpfc_init.c:7788:35: error: 'struct lpfc_sli4_hba' has no member
named 'c_stat'"

Reviewing this issue highlighted that one of the recent patches caused
the driver to no longer compile cleanly if CONFIG_DEBUG_FS is not set.

Correct the different areas that are failing to compile.

Fixes: 02243836ad6f ("scsi: lpfc: Add support for the CM framework")
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

---
v2:
 Address review comments:
 ifdef order in lpfc_sli4_driver_resource_setup()
 Initialization of 0L in lpfc_queuecommand()
---
 drivers/scsi/lpfc/lpfc_init.c | 4 ++--
 drivers/scsi/lpfc/lpfc_nvme.c | 2 --
 drivers/scsi/lpfc/lpfc_scsi.c | 6 +-----
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index d3f1fa38269f..d2c16e4410a9 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8277,11 +8277,11 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	return 0;
 
 out_free_hba_hdwq_info:
-	free_percpu(phba->sli4_hba.c_stat);
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+	free_percpu(phba->sli4_hba.c_stat);
 out_free_hba_idle_stat:
-	kfree(phba->sli4_hba.idle_stat);
 #endif
+	kfree(phba->sli4_hba.idle_stat);
 out_free_hba_eq_info:
 	free_percpu(phba->sli4_hba.eq_info);
 out_free_hba_cpu_map:
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 73a3568ff17e..479b3eed6208 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1489,9 +1489,7 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 	struct lpfc_nvme_qhandle *lpfc_queue_info;
 	struct lpfc_nvme_fcpreq_priv *freqpriv;
 	struct nvme_common_command *sqe;
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint64_t start = 0;
-#endif
 
 	/* Validate pointers. LLDD fault handling with transport does
 	 * have timing races.
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 0fde1e874c7a..63d8ac9f68a7 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5578,12 +5578,8 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	int err, idx;
 	u8 *uuid = NULL;
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
-	uint64_t start = 0L;
+	uint64_t start;
 
-	if (phba->ktime_on)
-		start = ktime_get_ns();
-#endif
 	start = ktime_get_ns();
 	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
 
-- 
2.26.2

