From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 1/5] bnx2fc: Enable cached tasks to improve performance
Date: Fri, 8 Mar 2013 13:28:50 -0800
Message-ID: <1362778134-21045-2-git-send-email-bprakash@broadcom.com>
References: <1362778134-21045-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1629 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216Ab3CHV3C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Mar 2013 16:29:02 -0500
In-Reply-To: <1362778134-21045-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Set perf_config to 3 during firmware initialization to enable both
cached connections as well as cached tasks.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 85ea98a..c1fa69e 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -126,7 +126,11 @@ int bnx2fc_send_fw_fcoe_init_msg(struct bnx2fc_hba *hba)
 	fcoe_init3.error_bit_map_lo = 0xffffffff;
 	fcoe_init3.error_bit_map_hi = 0xffffffff;
 
-	fcoe_init3.perf_config = 1;
+	/*
+	 * enable both cached connection and cached tasks
+	 * 0 = none, 1 = cached connection, 2 = cached tasks, 3 = both
+	 */
+	fcoe_init3.perf_config = 3;
 
 	kwqe_arr[0] = (struct kwqe *) &fcoe_init1;
 	kwqe_arr[1] = (struct kwqe *) &fcoe_init2;
-- 
1.7.1


