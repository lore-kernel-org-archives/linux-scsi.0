Return-Path: <SRS0=TSrQ=WF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D56F0C433FF
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3941216C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Aug 2019 03:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405371AbfHIDDv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 23:03:51 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36594 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405025AbfHIDDv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 23:03:51 -0400
Received: by mail-pf1-f195.google.com with SMTP id r7so45225973pfl.3
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 20:03:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ipeJOWkxrK+tBF98JIPpJKIdb2fuHVHAsHzi+h4qhYQ=;
        b=TBCySRvTGNCZ9aTKD4bXxpMXaiB7czOsf0cuVczMSirSUOFaaAPu0OB/uUlcHr2PSg
         kGvgJtwDih9TmcoB1iwSa+//OZ05yh1hPsEFA878X547hrhUhq1WgLYrI7LHFXgSQ68E
         F1rR6Dhmz9xIWI0iDDLhCVXnuLT8dog33J52pekkXhyF2XJqvO0tKc/vvHnftjVTwhfn
         A/60Q7KUu59P5Uoru8HgO14941g3Wn/Gr56eS9DyNaxFA/15L9Wn+Tntn4lOIQwX3+G0
         NaEqnqp0nmjTvAKpJLl2Ahm4qS54z1DWulZHMcQ2Pw+xkBnZ6i5EdFEsfp3o4A8pgCbw
         z6uA==
X-Gm-Message-State: APjAAAXSq9lzjv/+29mg5sVJml2+sTI+YoERxDtkQm+5MjvoQvHfAeI6
        P173Sir3U9potyhXRmtkq3o=
X-Google-Smtp-Source: APXvYqxYx95lsn6RbtU/vfTpjeWe3WZykt/BhKCe8D6rMQkDGCUJTQWWcQ2/Mo8aPtysplsEQ0cNTA==
X-Received: by 2002:a65:47c1:: with SMTP id f1mr15397369pgs.169.1565319830360;
        Thu, 08 Aug 2019 20:03:50 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4001:6530:8f02:649d:771a:4703])
        by smtp.gmail.com with ESMTPSA id g2sm111787580pfi.26.2019.08.08.20.03.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 20:03:49 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: [PATCH v2 55/58] qla2xxx: Introduce qla2x00_els_dcmd2_free()
Date:   Thu,  8 Aug 2019 20:02:16 -0700
Message-Id: <20190809030219.11296-56-bvanassche@acm.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809030219.11296-1-bvanassche@acm.org>
References: <20190809030219.11296-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch reduces code duplication.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/qla2xxx/qla_def.h  |  2 +-
 drivers/scsi/qla2xxx/qla_gbl.h  |  2 ++
 drivers/scsi/qla2xxx/qla_gs.c   | 12 +---------
 drivers/scsi/qla2xxx/qla_iocb.c | 40 ++++++++++++++-------------------
 4 files changed, 21 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index a971d4245d89..873a6aef1c5c 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -455,7 +455,7 @@ struct srb_iocb {
 			struct els_logo_payload *els_logo_pyld;
 			dma_addr_t els_logo_pyld_dma;
 		} els_logo;
-		struct {
+		struct els_plogi {
 #define ELS_DCMD_PLOGI 0x3
 			uint32_t flags;
 			uint32_t els_cmd;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 3f313eaf854b..d11416dcee4e 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -45,6 +45,8 @@ extern int qla2x00_local_device_login(scsi_qla_host_t *, fc_port_t *);
 
 extern int qla24xx_els_dcmd_iocb(scsi_qla_host_t *, int, port_id_t);
 extern int qla24xx_els_dcmd2_iocb(scsi_qla_host_t *, int, fc_port_t *, bool);
+extern void qla2x00_els_dcmd2_free(scsi_qla_host_t *vha,
+				   struct els_plogi *els_plogi);
 
 extern void qla2x00_update_fcports(scsi_qla_host_t *);
 
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 0e1df8232c75..bf8b30c4827c 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3119,17 +3119,7 @@ void qla24xx_sp_unmap(scsi_qla_host_t *vha, srb_t *sp)
 
 	switch (sp->type) {
 	case SRB_ELS_DCMD:
-		if (c->u.els_plogi.els_plogi_pyld)
-			dma_free_coherent(&vha->hw->pdev->dev,
-			    c->u.els_plogi.tx_size,
-			    c->u.els_plogi.els_plogi_pyld,
-			    c->u.els_plogi.els_plogi_pyld_dma);
-
-		if (c->u.els_plogi.els_resp_pyld)
-			dma_free_coherent(&vha->hw->pdev->dev,
-			    c->u.els_plogi.rx_size,
-			    c->u.els_plogi.els_resp_pyld,
-			    c->u.els_plogi.els_resp_pyld_dma);
+		qla2x00_els_dcmd2_free(vha, &c->u.els_plogi);
 		break;
 	case SRB_CT_PTHRU_CMD:
 	default:
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 39c7738c0a55..7021fbeb6d23 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2717,6 +2717,21 @@ qla2x00_els_dcmd2_iocb_timeout(void *data)
 	sp->done(sp, QLA_FUNCTION_TIMEOUT);
 }
 
+void qla2x00_els_dcmd2_free(scsi_qla_host_t *vha, struct els_plogi *els_plogi)
+{
+	if (els_plogi->els_plogi_pyld)
+		dma_free_coherent(&vha->hw->pdev->dev,
+				  els_plogi->tx_size,
+				  els_plogi->els_plogi_pyld,
+				  els_plogi->els_plogi_pyld_dma);
+
+	if (els_plogi->els_resp_pyld)
+		dma_free_coherent(&vha->hw->pdev->dev,
+				  els_plogi->rx_size,
+				  els_plogi->els_resp_pyld,
+				  els_plogi->els_resp_pyld_dma);
+}
+
 static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 {
 	fc_port_t *fcport = sp->fcport;
@@ -2748,17 +2763,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 		if (!e) {
 			struct srb_iocb *elsio = &sp->u.iocb_cmd;
 
-			if (elsio->u.els_plogi.els_plogi_pyld)
-				dma_free_coherent(&sp->vha->hw->pdev->dev,
-				    elsio->u.els_plogi.tx_size,
-				    elsio->u.els_plogi.els_plogi_pyld,
-				    elsio->u.els_plogi.els_plogi_pyld_dma);
-
-			if (elsio->u.els_plogi.els_resp_pyld)
-				dma_free_coherent(&sp->vha->hw->pdev->dev,
-				    elsio->u.els_plogi.rx_size,
-				    elsio->u.els_plogi.els_resp_pyld,
-				    elsio->u.els_plogi.els_resp_pyld_dma);
+			qla2x00_els_dcmd2_free(vha, &elsio->u.els_plogi);
 			sp->free(sp);
 			return;
 		}
@@ -2858,18 +2863,7 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 
 out:
 	fcport->flags &= ~(FCF_ASYNC_SENT);
-	if (elsio->u.els_plogi.els_plogi_pyld)
-		dma_free_coherent(&sp->vha->hw->pdev->dev,
-		    elsio->u.els_plogi.tx_size,
-		    elsio->u.els_plogi.els_plogi_pyld,
-		    elsio->u.els_plogi.els_plogi_pyld_dma);
-
-	if (elsio->u.els_plogi.els_resp_pyld)
-		dma_free_coherent(&sp->vha->hw->pdev->dev,
-		    elsio->u.els_plogi.rx_size,
-		    elsio->u.els_plogi.els_resp_pyld,
-		    elsio->u.els_plogi.els_resp_pyld_dma);
-
+	qla2x00_els_dcmd2_free(vha, &elsio->u.els_plogi);
 	sp->free(sp);
 done:
 	return rval;
-- 
2.22.0

