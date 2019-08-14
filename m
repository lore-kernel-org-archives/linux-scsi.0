Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 422ACC433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 14:25:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F6902083B
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 14:25:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfHNOZr convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 10:25:47 -0400
Received: from us-smtp-delivery-131.mimecast.com ([63.128.21.131]:25397 "EHLO
        us-smtp-delivery-131.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725800AbfHNOZr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Aug 2019 10:25:47 -0400
Received: from mailhub5.stratus.com (134.111.1.18 [134.111.1.18]) by
 relay.mimecast.com with ESMTP id us-mta-317-jsLfh46_Mp23jKyJVjTRXA-1; Wed,
 14 Aug 2019 10:24:42 -0400
Received: from EXHQ1.corp.stratus.com (exhq1.corp.stratus.com [134.111.200.125])
        by mailhub5.stratus.com (8.12.11/8.12.11) with ESMTP id x7EEOfRq029309;
        Wed, 14 Aug 2019 10:24:42 -0400
Received: from linuxdev.lnx.eng.stratus.com (134.111.220.63) by
 EXHQ1.corp.stratus.com (134.111.200.125) with Microsoft SMTP Server (TLS) id
 14.3.279.2; Wed, 14 Aug 2019 10:24:27 -0400
From:   Bill Kuzeja <William.Kuzeja@stratus.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <qla2xxx-upstream@qlogic.com>, <William.Kuzeja@stratus.com>
Subject: [PATCH RESEND] qla2xxx: Fix gnl.l memory leak on adapter init failure
Date:   Wed, 14 Aug 2019 10:24:41 -0400
Message-ID: <1565792681-9641-1-git-send-email-William.Kuzeja@stratus.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
X-MC-Unique: jsLfh46_Mp23jKyJVjTRXA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If HBA initialization fails unexpectedly (exiting via probe_failed:), we 
may fail to free vha->gnl.l. So that we don't attempt to double free,
set this pointer to NULL after a free and check for NULL at probe_failed:
so we know whether or not to call dma_free_coherent. 

Signed-off-by: Bill Kuzeja <william.kuzeja@stratus.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |  2 ++
 drivers/scsi/qla2xxx/qla_os.c   | 11 ++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 8d560c5..6b7b390 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2956,6 +2956,8 @@ void qla_insert_tgt_attrs(void)
 	dma_free_coherent(&ha->pdev->dev, vha->gnl.size, vha->gnl.l,
 	    vha->gnl.ldma);
 
+	vha->gnl.l = NULL;
+
 	vfree(vha->scan.l);
 
 	if (vha->qpair && vha->qpair->vp_idx == vha->vp_idx) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2e58cff..98e60a3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3440,6 +3440,12 @@ static void qla2x00_iocb_work_fn(struct work_struct *work)
 	return 0;
 
 probe_failed:
+	if (base_vha->gnl.l) {
+		dma_free_coherent(&ha->pdev->dev, base_vha->gnl.size,
+				base_vha->gnl.l, base_vha->gnl.ldma);
+		base_vha->gnl.l = NULL;
+	}
+
 	if (base_vha->timer_active)
 		qla2x00_stop_timer(base_vha);
 	base_vha->flags.online = 0;
@@ -3673,7 +3679,7 @@ static void qla2x00_iocb_work_fn(struct work_struct *work)
 	if (!atomic_read(&pdev->enable_cnt)) {
 		dma_free_coherent(&ha->pdev->dev, base_vha->gnl.size,
 		    base_vha->gnl.l, base_vha->gnl.ldma);
-
+		base_vha->gnl.l = NULL;
 		scsi_host_put(base_vha->host);
 		kfree(ha);
 		pci_set_drvdata(pdev, NULL);
@@ -3713,6 +3719,8 @@ static void qla2x00_iocb_work_fn(struct work_struct *work)
 	dma_free_coherent(&ha->pdev->dev,
 		base_vha->gnl.size, base_vha->gnl.l, base_vha->gnl.ldma);
 
+	base_vha->gnl.l = NULL;
+
 	vfree(base_vha->scan.l);
 
 	if (IS_QLAFX00(ha))
@@ -4816,6 +4824,7 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 		    "Alloc failed for scan database.\n");
 		dma_free_coherent(&ha->pdev->dev, vha->gnl.size,
 		    vha->gnl.l, vha->gnl.ldma);
+		vha->gnl.l = NULL;
 		scsi_remove_host(vha->host);
 		return NULL;
 	}
-- 
1.8.3.1

