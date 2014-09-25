From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 32/35] qla2xxx: Fail adapter initialization on load ram failure.
Date: Thu, 25 Sep 2014 05:17:03 -0400
Message-ID: <1411636626-7566-33-git-send-email-saurav.kashyap@qlogic.com>
References: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:33800 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753119AbaIYJv3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 05:51:29 -0400
In-Reply-To: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

If we fail to load one of the segments of firmware fail the operation
instead of trying to continue which will lead to a system crash since
the pointers to the next segment will not be updated correctly.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 23f12dd..1d66f2f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5236,7 +5236,7 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
 				ql_log(ql_log_fatal, vha, 0x008f,
 				    "Failed to load segment %d of firmware.\n",
 				    fragment);
-				break;
+				return QLA_FUNCTION_FAILED;
 			}
 
 			faddr += dlen;
@@ -5539,7 +5539,7 @@ qla24xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 				ql_log(ql_log_fatal, vha, 0x0098,
 				    "Failed to load segment %d of firmware.\n",
 				    fragment);
-				break;
+				return QLA_FUNCTION_FAILED;
 			}
 
 			fwcode += dlen;
-- 
1.7.7

