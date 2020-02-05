Return-Path: <SRS0=gsTh=3Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7185C352A1
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 21:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 767532072B
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Feb 2020 21:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbgBEVnZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Feb 2020 16:43:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:52404 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727033AbgBEVnY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 5 Feb 2020 16:43:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DB6DAACAE;
        Wed,  5 Feb 2020 21:43:22 +0000 (UTC)
From:   mwilck@suse.com
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v2 1/3] scsi: qla2xxx: avoid sending mailbox commands if firmware is stopped
Date:   Wed,  5 Feb 2020 22:44:20 +0100
Message-Id: <20200205214422.3657-2-mwilck@suse.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200205214422.3657-1-mwilck@suse.com>
References: <20200205214422.3657-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

Since commit 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip"),
it is possible that FC commands are scheduled after the adapter firmware
has been shut down. IO sent to the firmware in this situation hangs
indefinitely. Avoid this for the LOGO code path that is typically taken
when adapters are shut down.

Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip")
Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 3 +++
 drivers/scsi/qla2xxx/qla_os.c  | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9e09964..53129f2 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2644,6 +2644,9 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x106d,
 	    "Entered %s.\n", __func__);
 
+	if (!ha->flags.fw_started)
+		return QLA_FUNCTION_FAILED;
+
 	lg = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
 	if (lg == NULL) {
 		ql_log(ql_log_warn, vha, 0x106e,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b520a98..2dafb46 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4878,6 +4878,9 @@ qla2x00_post_work(struct scsi_qla_host *vha, struct qla_work_evt *e)
 	unsigned long flags;
 	bool q = false;
 
+	if (!vha->hw->flags.fw_started)
+		return QLA_FUNCTION_FAILED;
+
 	spin_lock_irqsave(&vha->work_lock, flags);
 	list_add_tail(&e->list, &vha->work_list);
 
-- 
2.25.0

