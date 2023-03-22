Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8B1BC6FD1C
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 20:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbjCVUCX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 16:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjCVUBu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 16:01:50 -0400
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777D36BC02
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:56 -0700 (PDT)
Received: by mail-pj1-f54.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so20230380pjt.5
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 12:58:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679515121;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GFtVFboVcSjfPqmwHcJZEXr1SNf/HwV0uYa9XL6rvBg=;
        b=8EvdPr4y6vKQakz8GzkaxnSztAtAm//9bIG7tG6jzOYxtQcVVVJgona0KZOANtQHPG
         ldVbhZ8VztRPBPYq0bxiMmkon9VVg3to0S709wYtiEoxa0L93jCnv/2t8yhQYDjDFwOn
         STqT+YaGL6muRYzcx33FI5bDFvowi8aQVbCS/mvMjRkaxoYqVqqvW2RaTss9cjwjfXPB
         Gig90KIfijjKgMcF5vCLnR+jJcYBAn8TM7iANbDfnfw0dri3fFauK09wr8Ed6uhGWzXv
         59uznS4fZzccS4p05qmxUOMQMD8uAJ9D90pP8zbMfVbvhiTBYtbVjEF0l5YKJ5NEY5dt
         m4DQ==
X-Gm-Message-State: AO0yUKWmHAfD+13Wh0y2F2uv2BQ5HiZUP+vHpYsC2fg/5rkPINIuswsZ
        5nfZlbL9Eh8kwT5swh7p2Yi9o0YHCtah0Q==
X-Google-Smtp-Source: AK7set++xJB+N2RtegeFsOVno5qMJifUIgJjNi4HYnNfSsCXmDv5pfQqnvKDHBBk4z6i+/ZfJFg0aA==
X-Received: by 2002:a17:90b:164d:b0:23f:9fac:6b35 with SMTP id il13-20020a17090b164d00b0023f9fac6b35mr4720408pjb.39.1679515120746;
        Wed, 22 Mar 2023 12:58:40 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ad4e:d902:f46f:5b50])
        by smtp.gmail.com with ESMTPSA id g2-20020a17090adac200b00233cde36909sm13574815pjx.21.2023.03.22.12.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 12:58:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 67/80] scsi: qla2xxx: Declare SCSI host template const
Date:   Wed, 22 Mar 2023 12:55:02 -0700
Message-Id: <20230322195515.1267197-68-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org>
References: <20230322195515.1267197-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it explicit that the SCSI host template is not modified.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h | 2 +-
 drivers/scsi/qla2xxx/qla_mid.c | 2 +-
 drivers/scsi/qla2xxx/qla_os.c  | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 9142df876c73..7bc2f634bab9 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -213,7 +213,7 @@ extern void qla2x00_free_exchoffld_buffer(struct qla_hw_data *);
 
 extern int qla81xx_restart_mpi_firmware(scsi_qla_host_t *);
 
-extern struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *,
+extern struct scsi_qla_host *qla2x00_create_host(const struct scsi_host_template *,
 	struct qla_hw_data *);
 extern void qla2x00_free_host(struct scsi_qla_host *);
 extern void qla2x00_relogin(struct scsi_qla_host *);
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 78661b658dcd..b67416951a5f 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -496,7 +496,7 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	scsi_qla_host_t *base_vha = shost_priv(fc_vport->shost);
 	struct qla_hw_data *ha = base_vha->hw;
 	scsi_qla_host_t *vha;
-	struct scsi_host_template *sht = &qla2xxx_driver_template;
+	const struct scsi_host_template *sht = &qla2xxx_driver_template;
 	struct Scsi_Host *host;
 
 	vha = qla2x00_create_host(sht, ha);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a6c5e0d8641d..27f3e99b7818 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4999,8 +4999,8 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	ha->vp_map = NULL;
 }
 
-struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
-						struct qla_hw_data *ha)
+struct scsi_qla_host *qla2x00_create_host(const struct scsi_host_template *sht,
+					  struct qla_hw_data *ha)
 {
 	struct Scsi_Host *host;
 	struct scsi_qla_host *vha = NULL;
