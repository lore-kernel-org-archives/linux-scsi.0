From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 08/23] qla2xxx: Do MPI reset only for ISP81xx.
Date: Fri,  8 Feb 2013 01:57:49 -0500
Message-ID: <1360306684-8286-9-git-send-email-saurav.kashyap@qlogic.com>
References: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:46856 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1759968Ab3BHHTK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Feb 2013 02:19:10 -0500
In-Reply-To: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 5b49766..525c339 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -796,10 +796,12 @@ qla2x00_process_loopback(struct fc_bsg_job *bsg_job)
 				qla2xxx_wake_dpc(vha);
 				qla2x00_wait_for_chip_reset(vha);
 				/* Also reset the MPI */
-				if (qla81xx_restart_mpi_firmware(vha) !=
-				    QLA_SUCCESS) {
-					ql_log(ql_log_warn, vha, 0x702a,
-					    "MPI reset failed.\n");
+				if (IS_QLA81XX(ha)) {
+					if (qla81xx_restart_mpi_firmware(vha) !=
+					    QLA_SUCCESS) {
+						ql_log(ql_log_warn, vha, 0x702a,
+						    "MPI reset failed.\n");
+					}
 				}
 
 				rval = -EIO;
-- 
1.7.7

