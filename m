From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 07/19] qla2xxx: Move noisy Start scsi failed messages to verbose logging level.
Date: Wed, 21 Nov 2012 02:40:32 -0500
Message-ID: <1353483644-17262-8-git-send-email-saurav.kashyap@qlogic.com>
References: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:36132 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753341Ab2KUH6y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:54 -0500
In-Reply-To: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

This message can fill up the system logs and is not a common occurrence so move
it to the verbose logging level.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 132556b..e4fd192 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -719,7 +719,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	rval = ha->isp_ops->start_scsi(sp);
 	if (rval != QLA_SUCCESS) {
-		ql_dbg(ql_dbg_io, vha, 0x3013,
+		ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x3013,
 		    "Start scsi failed rval=%d for cmd=%p.\n", rval, cmd);
 		goto qc24_host_busy_free_sp;
 	}
-- 
1.7.7

