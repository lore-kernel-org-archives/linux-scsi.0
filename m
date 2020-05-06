Return-Path: <SRS0=GN0H=6U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC225C28CBC
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 06:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C6C3206DD
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 06:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgEFGSo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 May 2020 02:18:44 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3809 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726863AbgEFGSo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 6 May 2020 02:18:44 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6C699DADA646ACB44E7B;
        Wed,  6 May 2020 14:18:41 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Wed, 6 May 2020
 14:18:35 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <hmadhani@marvell.com>, <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] scsi: qla2xxx: make qlafx00_process_aen() return void
Date:   Wed, 6 May 2020 14:17:57 +0800
Message-ID: <20200506061757.19536-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

No other functions use the return value of qlafx00_process_aen() and the
return value is always 0 now. Make it return void. This fixes the
following coccicheck warning:

drivers/scsi/qla2xxx/qla_mr.c:1716:5-9: Unneeded variable: "rval".
Return "0" on line 1768

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h | 2 +-
 drivers/scsi/qla2xxx/qla_mr.c  | 5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index b20c5fa122fb..f62b71e47581 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -771,7 +771,7 @@ extern int qlafx00_fw_ready(scsi_qla_host_t *);
 extern int qlafx00_configure_devices(scsi_qla_host_t *);
 extern int qlafx00_reset_initialize(scsi_qla_host_t *);
 extern int qlafx00_fx_disc(scsi_qla_host_t *, fc_port_t *, uint16_t);
-extern int qlafx00_process_aen(struct scsi_qla_host *, struct qla_work_evt *);
+extern void qlafx00_process_aen(struct scsi_qla_host *, struct qla_work_evt *);
 extern int qlafx00_post_aenfx_work(struct scsi_qla_host *,  uint32_t,
 				   uint32_t *, int);
 extern uint32_t qlafx00_fw_state_show(struct device *,
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index df99911b8bb9..ce98189c7872 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1710,10 +1710,9 @@ qlafx00_tgt_detach(struct scsi_qla_host *vha, int tgt_id)
 	return;
 }
 
-int
+void
 qlafx00_process_aen(struct scsi_qla_host *vha, struct qla_work_evt *evt)
 {
-	int rval = 0;
 	uint32_t aen_code, aen_data;
 
 	aen_code = FCH_EVT_VENDOR_UNIQUE;
@@ -1764,8 +1763,6 @@ qlafx00_process_aen(struct scsi_qla_host *vha, struct qla_work_evt *evt)
 
 	fc_host_post_event(vha->host, fc_get_event_number(),
 	    aen_code, aen_data);
-
-	return rval;
 }
 
 static void
-- 
2.21.1

