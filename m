From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 13/18] qla2xxx: Process marker IOCB request on request queue 0.
Date: Fri, 18 Nov 2011 09:03:17 -0800
Message-ID: <1321635802-16491-14-git-send-email-chad.dupuis@qlogic.com>
References: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-va3.bigfish.com ([216.32.180.10]:48815 "EHLO
	VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758262Ab1KRRQb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:16:31 -0500
In-Reply-To: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

When multiple request queues are created process the marker IOCB request
on request queue 0.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index d631325..64a3075 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -489,6 +489,7 @@ __qla2x00_marker(struct scsi_qla_host *vha, struct req_que *req,
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
 	mrk24 = NULL;
+	req = ha->req_q_map[0];
 	mrk = (mrk_entry_t *)qla2x00_alloc_iocbs(vha, 0);
 	if (mrk == NULL) {
 		ql_log(ql_log_warn, base_vha, 0x3026,
-- 
1.6.0.2


