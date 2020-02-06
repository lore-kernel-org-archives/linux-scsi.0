Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92429C2D0B1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 13:54:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69D7121775
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 13:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbgBFNyr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 08:54:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:41608 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726765AbgBFNyr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 6 Feb 2020 08:54:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6AE50AC91
        for <linux-scsi@vger.kernel.org>; Thu,  6 Feb 2020 13:54:45 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     Daniel Wagner <dwagner@suse.de>
Subject: [PATCH] qla2xxx: Remove non functional code
Date:   Thu,  6 Feb 2020 14:54:43 +0100
Message-Id: <20200206135443.110701-1-dwagner@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove code which has no functional use anymore since
3c75ad1d87c7 ("scsi: qla2xxx: Remove defer flag to indicate immeadiate
port loss").

While at it remove also the stale function documentation.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/qla2xxx/qla_os.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 79387ac8936f..27a5d0c7e246 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3909,19 +3909,6 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
 	set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 }
 
-/*
- * qla2x00_mark_all_devices_lost
- *	Updates fcport state when device goes offline.
- *
- * Input:
- *	ha = adapter block pointer.
- *	fcport = port structure pointer.
- *
- * Return:
- *	None.
- *
- * Context:
- */
 void
 qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha)
 {
@@ -3933,16 +3920,6 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha)
 	list_for_each_entry(fcport, &vha->vp_fcports, list) {
 		fcport->scan_state = 0;
 		qlt_schedule_sess_for_deletion(fcport);
-
-		if (vha->vp_idx != 0 && vha->vp_idx != fcport->vha->vp_idx)
-			continue;
-
-		/*
-		 * No point in marking the device as lost, if the device is
-		 * already DEAD.
-		 */
-		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD)
-			continue;
 	}
 }
 
-- 
2.16.4

