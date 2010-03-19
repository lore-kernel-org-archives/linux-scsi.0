From: giridhar.malavali@qlogic.com
Subject: [PATCH 3/6] qla2xxx: Check to make sure multique and CPU affinity support is not enabled at the same time.
Date: Fri, 19 Mar 2010 16:59:18 -0700
Message-ID: <1269043161-2265-4-git-send-email-giridhar.malavali@qlogic.com>
References: <1269043161-2265-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:46298 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752230Ab0CSX7Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Mar 2010 19:59:24 -0400
In-Reply-To: <1269043161-2265-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Michael Hernandez <michael.hernandez@qlogic.com>

From: Michael Hernandez <michael.hernandez@qlogic.com>

The logic is changed to detect this condition based on following
1) both module parameters are off (ql2xmaxqueues and ql2xmultique_tag).
2) both module parameters are on (ql2xmaxqueues and ql2xmultique_tag).
3) The HBA does not support multi queue.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 46720b2..be3f1d3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1676,9 +1676,11 @@ skip_pio:
 
 	/* Determine queue resources */
 	ha->max_req_queues = ha->max_rsp_queues = 1;
-	if ((ql2xmaxqueues <= 1 || ql2xmultique_tag < 1) &&
+	if ((ql2xmaxqueues <= 1 && !ql2xmultique_tag) ||
+		(ql2xmaxqueues > 1 && ql2xmultique_tag) ||
 		(!IS_QLA25XX(ha) && !IS_QLA81XX(ha)))
 		goto mqiobase_exit;
+
 	ha->mqiobase = ioremap(pci_resource_start(ha->pdev, 3),
 			pci_resource_len(ha->pdev, 3));
 	if (ha->mqiobase) {
-- 
1.6.2.rc1.30.gd43c

