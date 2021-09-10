Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2094FC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:32:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B77C61206
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbhIJXdu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 19:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234908AbhIJXdf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2021 19:33:35 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE79C0613C1
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:20 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n4so2119927plh.9
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9hYHMJHZFH8ost3B+sxBQxA5bDUW1toQYgOsMCew8+Y=;
        b=Iw9J4Llqsf1SWzl4Tfjz++4NKSmO23J2WIsItbjuVGrL3REWp4tGIXDiVeeMrXhSua
         E7I1ScoOQJw6I/RhT7l8v1MNkeZDwzUgwjzSJyOwqjhctrh/7SRPA/uII7aQQF0eMQWw
         +YCRRS8U5S+5ZP+fdSAUJ0d6z3ugese0KVW/eejVGmC9BIOy/zz4MYtlKKr0VghWFqfD
         Eu9QESacZwu+bjvmWKoPfybVj+Fk5mIzfpY53pgoJDOy1aO2TI+JUJibba25lNzjXWaK
         bBwmNA0xXac2y/4xK04bqikWHLj74BjnxgZRT6svZS9DSU6v9bwyqY6G6O9ytUMNIZIu
         KP9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9hYHMJHZFH8ost3B+sxBQxA5bDUW1toQYgOsMCew8+Y=;
        b=Sf8ro/CVjTYOuU4l93VNln1Y1XkvVmzklgv4Bzjqtl1Op4uHhtLwp1SLe1S5c7Hnfr
         k+4J8nhNrdzjq2g/NVAed3MBdo5ppXD4bmacfCfD5S9pkbYBtt9vVJP+fhh0WlXupG7y
         M8YmVOn2i1oNb8mvXvWP8n/++LwMAFkUqokrreCOmJe3ScXMkqyxCgPCCNaQNnTyXmdX
         qjcPxRgN5m8AN17mnmFU90SBlTAFn32QLGWF+WHxQDp2sucxRwVI9bep2lOy/vEVEj4N
         dW5RHda6aLUFGA2SL3lCnT0ST0LIBtXu0vy+/J0TQGV1hb5H5UN0etRPWphssfQb7Cvf
         6XhQ==
X-Gm-Message-State: AOAM533E7GmKrYSPZe4W0uS9Gtm3gw/fyp/+saw4JRaV+1MkjU8NoW4X
        QVflBDkVi8lvcsHlzEySKGVb187cpqZpUTC1
X-Google-Smtp-Source: ABdhPJyVpuYacdUihedggnrH4DJWRc4HgmSWw2DI19r4EkBDdgqysDzyfeTmKcRML2Vax0c4G/o+CA==
X-Received: by 2002:a17:90a:ae18:: with SMTP id t24mr94695pjq.92.1631316740040;
        Fri, 10 Sep 2021 16:32:20 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o15sm11325pfk.143.2021.09.10.16.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 16:32:19 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 12/14] lpfc: Zero CGN stats only during initial driver load and stat reset
Date:   Fri, 10 Sep 2021 16:31:57 -0700
Message-Id: <20210910233159.115896-13-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210910233159.115896-1-jsmart2021@gmail.com>
References: <20210910233159.115896-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently congestion management framework results are cleared whenever
the framework settings changed (such as it being turned off then back
on). This unfortunately means prior stats, rolled up to higher time
windows lose meaning.

Change such that stats are not cleared. Thus they pause and resume with
prior values still being considered.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 --
 drivers/scsi/lpfc/lpfc_sli.c  | 6 ++++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 4637531f3b02..d0e64233d273 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -13394,8 +13394,6 @@ lpfc_init_congestion_buf(struct lpfc_hba *phba)
 	atomic_set(&phba->cgn_sync_alarm_cnt, 0);
 	atomic_set(&phba->cgn_sync_warn_cnt, 0);
 
-	atomic64_set(&phba->cgn_acqe_stat.alarm, 0);
-	atomic64_set(&phba->cgn_acqe_stat.warn, 0);
 	atomic_set(&phba->cgn_driver_evt_cnt, 0);
 	atomic_set(&phba->cgn_latency_evt_cnt, 0);
 	atomic64_set(&phba->cgn_latency_evt, 0);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 651e6ee64e88..34cf2bfcce07 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7764,8 +7764,6 @@ lpfc_mbx_cmpl_cgn_set_ftrs(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 
 	/* Zero out Congestion Signal ACQE counter */
 	phba->cgn_acqe_cnt = 0;
-	atomic64_set(&phba->cgn_acqe_stat.warn, 0);
-	atomic64_set(&phba->cgn_acqe_stat.alarm, 0);
 
 	acqe = bf_get(lpfc_mbx_set_feature_CGN_acqe_freq,
 		      &pmb->u.mqe.un.set_feature);
@@ -8017,6 +8015,10 @@ lpfc_cmf_setup(struct lpfc_hba *phba)
 			/* initialize congestion buffer info */
 			lpfc_init_congestion_buf(phba);
 			lpfc_init_congestion_stat(phba);
+
+			/* Zero out Congestion Signal counters */
+			atomic64_set(&phba->cgn_acqe_stat.alarm, 0);
+			atomic64_set(&phba->cgn_acqe_stat.warn, 0);
 		}
 
 		rc = lpfc_sli4_cgn_params_read(phba);
-- 
2.26.2

