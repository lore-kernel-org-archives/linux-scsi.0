From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] cleanup fc_fcp_pkt_abort() to be clearer
Date: Fri, 3 Dec 2010 22:22:16 +0800
Message-ID: <AANLkTinvt2B4HAxcLSCDb+vt3WKxg6_B8-XToX4bamJz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44411 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758070Ab0LCOWR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2010 09:22:17 -0500
Received: by wwa36 with SMTP id 36so10100156wwa.1
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2010 06:22:16 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org

Here ticks_left is added to record the result of wait_for_completion_timeout().

The advantage looks that it is not only clearer but necessary also to
remove any chaos in what is returned.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/libfc/fc_fcp.c	2010-11-01 19:54:12.000000000 +0800
+++ b/drivers/scsi/libfc/fc_fcp.c	2010-12-03 21:57:12.000000000 +0800
@@ -1165,6 +1165,7 @@ unlock:
 static int fc_fcp_pkt_abort(struct fc_fcp_pkt *fsp)
 {
 	int rc = FAILED;
+	unsigned long ticks_left;

 	if (fc_fcp_send_abort(fsp))
 		return FAILED;
@@ -1173,13 +1174,13 @@ static int fc_fcp_pkt_abort(struct fc_fc
 	fsp->wait_for_comp = 1;

 	spin_unlock_bh(&fsp->scsi_pkt_lock);
-	rc = wait_for_completion_timeout(&fsp->tm_done, FC_SCSI_TM_TOV);
+	ticks_left = wait_for_completion_timeout(&fsp->tm_done,
+							FC_SCSI_TM_TOV);
 	spin_lock_bh(&fsp->scsi_pkt_lock);
 	fsp->wait_for_comp = 0;

-	if (!rc) {
+	if (! ticks_left) {
 		FC_FCP_DBG(fsp, "target abort cmd  failed\n");
-		rc = FAILED;
 	} else if (fsp->state & FC_SRB_ABORTED) {
 		FC_FCP_DBG(fsp, "target abort cmd  passed\n");
 		rc = SUCCESS;
