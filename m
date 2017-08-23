From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 26/31] qla2xxx: Increase ql2xmaxqdepth to 64
Date: Wed, 23 Aug 2017 15:05:20 -0700
Message-ID: <20170823220525.3115-27-himanshu.madhani@cavium.com>
References: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0085.outbound.protection.outlook.com ([104.47.33.85]:1870
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751076AbdHWWkg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 18:40:36 -0400
In-Reply-To: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Michael Hernandez <michael.hernandez@cavium.com>

ql2xmaxqdepth is the module parameter that seeds the per target
queue depth in the Scsi midlayer (sdev->queue_depth). Performance
testing revealed that increasing this value would improve IOPS
numbers under certain workloads.

Signed-off-by: Michael Hernandez <michael.hernandez@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0814ff4fa2c0..715427f8e732 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -113,12 +113,12 @@ MODULE_PARM_DESC(ql2xfdmienable,
 		"Enables FDMI registrations. "
 		"0 - no FDMI. Default is 1 - perform FDMI.");
 
-#define MAX_Q_DEPTH	32
+#define MAX_Q_DEPTH	64
 static int ql2xmaxqdepth = MAX_Q_DEPTH;
 module_param(ql2xmaxqdepth, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xmaxqdepth,
 		"Maximum queue depth to set for each LUN. "
-		"Default is 32.");
+		"Default is 64.");
 
 #if (IS_ENABLED(CONFIG_NVME_FC))
 int ql2xenabledif;
-- 
2.12.0
