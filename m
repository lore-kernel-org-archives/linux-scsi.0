Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A996C432BE
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 23:13:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F41A60FD9
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Aug 2021 23:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239011AbhH3XOI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Aug 2021 19:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238898AbhH3XOI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Aug 2021 19:14:08 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EAEC061575
        for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2021 16:13:13 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id mw10-20020a17090b4d0a00b0017b59213831so638409pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2021 16:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wyj6XKPljZVqhugQMEQYCqrxeQ7nRHG6mFDbTbyEyx0=;
        b=R7hgfUyBJfUAifwjtEKJinqhrX5+r2C9/7wIex18uJeK7VtUX4YgxzhleVNkWlNqav
         b4qLagaQGiEX35O9XLCk6ITxDWBRbh0PP8tiJ5PxN5Vp6l5EP1R3jETOOI0nqqPr+x+i
         1v2f3i7hEg0S+gevIkaqgmAAXLED3/83uEhgaR1HE3/EcCIDuTgFzbZHc14Tljs1JsEQ
         pR8PBR2fREiXw4UMc5LbIzHMf3xsRO5DvYPjrD9IDUKrhHLrXrsN3CjHctFqJIexdaBS
         VS4Qs+T/CWl5eAXJlMsEJmxne5NugAGohnSCcXE+qbfcAND22HgzpwxY8EM3O/yA/H24
         H0Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wyj6XKPljZVqhugQMEQYCqrxeQ7nRHG6mFDbTbyEyx0=;
        b=OMv6+3xrqDu23MeFmTgeGLoZPvMFrZ1VZDF60clEuZXoZqR1aM2aBSYyRnxadOcypu
         /ZYyer5wtBT/3ipl8+HzeIfI+7xcQ0xTovD2YhP9BBekO+lG88rtjg1s/WwsnZIBX6l1
         qzytBrOEDL4RWLPigNslsfS+np8dhISiQ3T7HxdS/nMWPbELgro+DKxQ3tTiQuwxUUjq
         bUpeIO1e7SVsndBgwrIelzoANohy9B9Kyu3aU8dvRg3rDyNJGKMdykEM+tWKZeyairaL
         rjoVNX1eEAMeiare08YtWZbVCmhhbVXw6FBBUte/wiI08qZ3Ji80LVLLgGtKoKghzeXg
         zKxw==
X-Gm-Message-State: AOAM533yU6oqRhSsU+hUO0bHhzMIUg2S1DpLvIMCMaI3zXFwfPhZb9mT
        iq2qkGven7mveT5ufEfw9dOvrBNq0WK73A==
X-Google-Smtp-Source: ABdhPJzCSqz3/VSLGYYhot0CHjT0/B6YGCeEU/f6w7eQZmyBQhIqZrqRGPRtD8cduq7cp6H1Ep3NNg==
X-Received: by 2002:a17:903:22d0:b0:137:630b:5d7e with SMTP id y16-20020a17090322d000b00137630b5d7emr1787237plg.51.1630365193364;
        Mon, 30 Aug 2021 16:13:13 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a23sm10723813pfo.120.2021.08.30.16.13.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 16:13:13 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH] lpfc: Fix compilation errors on kernels with no CONFIG_DEBUG_FS
Date:   Mon, 30 Aug 2021 16:13:05 -0700
Message-Id: <20210830231305.6334-1-jsmart2021@gmail.com>
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
 drivers/scsi/lpfc/lpfc_init.c | 12 ++++++++----
 drivers/scsi/lpfc/lpfc_nvme.c |  2 --
 drivers/scsi/lpfc/lpfc_scsi.c |  4 ----
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index d3f1fa38269f..a6127a51b4fe 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8254,7 +8254,11 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"3331 Failed allocating per cpu cgn stats\n");
 		rc = -ENOMEM;
-		goto out_free_hba_hdwq_info;
+#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+		goto out_free_hba_hdwq_stat;
+#else
+		goto out_free_hba_idle_stat;
+#endif
 	}
 
 	/*
@@ -8276,12 +8280,12 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 
 	return 0;
 
-out_free_hba_hdwq_info:
-	free_percpu(phba->sli4_hba.c_stat);
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+out_free_hba_hdwq_stat:
+	free_percpu(phba->sli4_hba.c_stat);
+#endif
 out_free_hba_idle_stat:
 	kfree(phba->sli4_hba.idle_stat);
-#endif
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
index 0fde1e874c7a..dae5cc03e8c2 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5578,12 +5578,8 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	int err, idx;
 	u8 *uuid = NULL;
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint64_t start = 0L;
 
-	if (phba->ktime_on)
-		start = ktime_get_ns();
-#endif
 	start = ktime_get_ns();
 	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
 
-- 
2.26.2

