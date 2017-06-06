From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH] qla2xxx: Fix compile warning
Date: Tue, 6 Jun 2017 13:55:23 -0700
Message-ID: <20170606205523.23507-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0081.outbound.protection.outlook.com ([104.47.33.81]:22316
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751247AbdFFUzj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Jun 2017 16:55:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

Fixes following 0-day kernel build warnings

drivers/scsi/qla2xxx/qla_init.c:6407:50: warning: format '%lx' expects
argument of type 'long unsigned int', but argument 5 has type 'unsigned
int' [-Wformat=]
drivers/scsi/qla2xxx/qla_init.c:6709:50: warning: format '%lx'
expects argument of type 'long unsigned int', but argument 5 has
type 'unsigned int' [-Wformat=]

Fixes: b95b9452aacf ("scsi: qla2xxx: Fix crash due to mismatch mumber of Q-pair creation for Multi queue")
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 436968ad4484..730e7fe4344a 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -6404,7 +6404,7 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
 	    "-> template size %x bytes\n", dlen);
 	if (dlen > risc_size * sizeof(*dcode)) {
 		ql_log(ql_log_warn, vha, 0x0167,
-		    "Failed fwdump template exceeds array by %lx bytes\n",
+		    "Failed fwdump template exceeds array by %zx bytes\n",
 		    (size_t)(dlen - risc_size * sizeof(*dcode)));
 		goto default_template;
 	}
@@ -6706,7 +6706,7 @@ qla24xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 	    "-> template size %x bytes\n", dlen);
 	if (dlen > risc_size * sizeof(*fwcode)) {
 		ql_log(ql_log_warn, vha, 0x0177,
-		    "Failed fwdump template exceeds array by %lx bytes\n",
+		    "Failed fwdump template exceeds array by %zx bytes\n",
 		    (size_t)(dlen - risc_size * sizeof(*fwcode)));
 		goto default_template;
 	}
-- 
2.12.0
