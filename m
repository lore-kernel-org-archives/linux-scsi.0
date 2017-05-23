From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH 03/15] qedf: Honor qed_ops->common->set_fp_int() return code.
Date: Tue, 23 May 2017 06:19:19 -0700
Message-ID: <20170523131931.1777-4-chad.dupuis@cavium.com>
References: <20170523131931.1777-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0053.outbound.protection.outlook.com ([104.47.41.53]:55856
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S937113AbdEWNTx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 May 2017 09:19:53 -0400
In-Reply-To: <20170523131931.1777-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

We need to check the return code the set_fp_int() callback in case we were
not allocated any fastpath interrupts or there was an error setting up the
fastpath interrupts from the qed perspective.

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/qedf/qedf_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index c8d1688..f703801 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2036,6 +2036,8 @@ static int qedf_setup_int(struct qedf_ctx *qedf)
 	 * Learn interrupt configuration
 	 */
 	rc = qed_ops->common->set_fp_int(qedf->cdev, num_online_cpus());
+	if (rc <= 0)
+		return 0;
 
 	rc  = qed_ops->common->get_fp_int(qedf->cdev, &qedf->int_info);
 	if (rc)
-- 
1.8.5.6
