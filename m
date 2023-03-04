Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3DA8C61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 00:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjCDAfh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 19:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjCDAfC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 19:35:02 -0500
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19DE6A9E0
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 16:34:22 -0800 (PST)
Received: by mail-pl1-f173.google.com with SMTP id i10so4517131plr.9
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2023 16:34:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677890062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/WqFD86zUzJs6zLt9AM/l5JR+jpNAEFoAzakplIzR8E=;
        b=fLkDGC7zf459ElrE09rIRZ5fqaQ/MOKp+Di76NPX4+DacjsbKrwFiHNvSYXywjiapS
         oFnc3CJlzKz0YG6t0T9lEG6OPzC8Ud23er56azhUJaT6xEv9TcGnIncnGYJ/CtoQvwUU
         W4BOi8RrSsM7RfuON//cTS4tSGA7KpzMDwL+t+ziVTImHWpTAWTiJ/HPNLrCLFei16pg
         LTlIItKCNZGoL6qNPe2ULhHiGYfDDwQdyTkgecMbVWCA6FikuD+ZkKQSbioWfe0lstL4
         BpBVvPYbsDxF3JLxSxXk1m+J0iYxFoE5xoSxLbWuLCN6LzXYW3/sstbSTTu+WC25VF6t
         7pVw==
X-Gm-Message-State: AO0yUKV9jB/AULJBhec9rEgyKEvpdAFR8XKq/ljF89MQqm0WKAC0ze3k
        1H8TaHDrSsq4y1LvbEW1t7w=
X-Google-Smtp-Source: AK7set9aWufv2+hjDzzMmqaFVkBKgxC2o25U1MysF2KXcny9bfKTM4bd4SC7CjH01FrJC/H1di0w2Q==
X-Received: by 2002:a17:903:120b:b0:19a:b092:b31a with SMTP id l11-20020a170903120b00b0019ab092b31amr4085203plh.8.1677890062565;
        Fri, 03 Mar 2023 16:34:22 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:efb8:1cdc:a06f:1b53])
        by smtp.gmail.com with ESMTPSA id kk15-20020a170903070f00b00189743ed3b6sm2071078plb.64.2023.03.03.16.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:34:21 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 67/81] scsi: qla2xxx: Declare SCSI host template const
Date:   Fri,  3 Mar 2023 16:30:49 -0800
Message-Id: <20230304003103.2572793-68-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230304003103.2572793-1-bvanassche@acm.org>
References: <20230304003103.2572793-1-bvanassche@acm.org>
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
