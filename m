Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD03C6FD19
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 19:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjCITbn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 14:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjCITaw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 14:30:52 -0500
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8992FCBD9
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 11:29:56 -0800 (PST)
Received: by mail-pf1-f172.google.com with SMTP id y10so2196106pfi.8
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 11:29:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678390196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/WqFD86zUzJs6zLt9AM/l5JR+jpNAEFoAzakplIzR8E=;
        b=J5C2eiu/QgoB2nZ6VI19GNimDiDQT/w50HX5u+XvDuyDJF6Tv8HkfiJ7EvRC7qDtTz
         l/twrhCR5NUjyfKwqybxAXDBjYruFcPIPiFxtTvqRKxTpJcBYfeXxr4HfT9n/lrCSRnX
         fE0k3xcHUjDOMTouvL0gWI5+/U41P3gUcFTS1mN2qqeIqD2zQIEmxbDdaYSHPSylCJkK
         RQYCcukdk1ojehtADGfERLq5eUR6KuSXA5CfSQYPGn8U6KuX5/udKwj4/UknFNUoI6D+
         7s8/dvNxkAYdntvhlZl4gWy3kjH1mnH7knIGGTebgE6iQgTyAeaH1GCMz9DC3lsyN7Eg
         WAfA==
X-Gm-Message-State: AO0yUKVHiE+anaTTBWjslcfI6V0U3i7vNOCHf/sEbOOLObEAiX9FoVT2
        jQNdW0ZsBYQzoYKxv4bvhkg=
X-Google-Smtp-Source: AK7set8xCDtnULfzpW6ZluumniCLS1gz7F1f0Hx7paB1TigGJXTvKSuhykSpASx8lD/QywFzb5kpsw==
X-Received: by 2002:a62:844d:0:b0:5ab:c004:5fc9 with SMTP id k74-20020a62844d000000b005abc0045fc9mr25572720pfd.17.1678390196107;
        Thu, 09 Mar 2023 11:29:56 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf9f:35c8:4915:cb24])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b0058d8f23af26sm11570955pff.157.2023.03.09.11.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 11:29:55 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 68/82] scsi: qla2xxx: Declare SCSI host template const
Date:   Thu,  9 Mar 2023 11:26:00 -0800
Message-Id: <20230309192614.2240602-69-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230309192614.2240602-1-bvanassche@acm.org>
References: <20230309192614.2240602-1-bvanassche@acm.org>
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
index 545167627e48..08e7873abb3d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5004,8 +5004,8 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	ha->vp_map = NULL;
 }
 
-struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
-						struct qla_hw_data *ha)
+struct scsi_qla_host *qla2x00_create_host(const struct scsi_host_template *sht,
+					  struct qla_hw_data *ha)
 {
 	struct Scsi_Host *host;
 	struct scsi_qla_host *vha = NULL;
