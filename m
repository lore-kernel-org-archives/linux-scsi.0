From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V2 12/15] aacraid: Reorder Adapter status check
Date: Thu, 16 Feb 2017 12:51:21 -0800
Message-ID: <20170216205124.20271-13-RaghavaAditya.Renukunta@microsemi.com>
References: <20170216205124.20271-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0083.outbound.protection.outlook.com ([104.47.34.83]:20583
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755206AbdBQD2S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 22:28:18 -0500
In-Reply-To: <20170216205124.20271-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de, dan.carpenter@oracle.com

The driver currently checks the SELF_TEST_FAILED first and then
KERNEL_PANIC next. Under error conditions(boot code failure) both
SELF_TEST_FAILED and KERNEL_PANIC can be set at the same time.

The driver has the capability to reset the controller on an KERNEL_PANIC,
but not on SELF_TEST_FAILED.

Fixed by first checking KERNEL_PANIC and then the others.

Cc: stable@vger.kernel.org
Fixes: e8b12f0fb835223752 ([SCSI] aacraid: Add new code for PMC-Sierra's SRC base controller family)
Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Reviewed-by: David Carroll <David.Carroll@microsemi.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

---
Changes in V2:
Corrected stray , in commit message

 drivers/scsi/aacraid/src.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 9b11e1a..71aaabd 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -437,16 +437,23 @@ static int aac_src_check_health(struct aac_dev *dev)
 	u32 status = src_readl(dev, MUnit.OMR);
 
 	/*
+	 *	Check to see if the board panic'd.
+	 */
+	if (unlikely(status & KERNEL_PANIC))
+		goto err_blink;
+
+	/*
 	 *	Check to see if the board failed any self tests.
 	 */
 	if (unlikely(status & SELF_TEST_FAILED))
-		return -1;
+		goto err_out;
 
 	/*
-	 *	Check to see if the board panic'd.
+	 *	Check to see if the board failed any self tests.
 	 */
-	if (unlikely(status & KERNEL_PANIC))
-		return (status >> 16) & 0xFF;
+	if (unlikely(status & MONITOR_PANIC))
+		goto err_out;
+
 	/*
 	 *	Wait for the adapter to be up and running.
 	 */
@@ -456,6 +463,12 @@ static int aac_src_check_health(struct aac_dev *dev)
 	 *	Everything is OK
 	 */
 	return 0;
+
+err_out:
+	return -1;
+
+err_blink:
+	return (status > 16) & 0xFF;
 }
 
 static inline u32 aac_get_vector(struct aac_dev *dev)
-- 
2.7.4
