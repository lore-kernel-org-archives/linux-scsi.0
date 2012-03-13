From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] tcm_qla2xxx: checking for NULL instead of IS_ERR()
Date: Tue, 13 Mar 2012 20:21:19 +0300
Message-ID: <20120313172119.GE31808@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:19639 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758545Ab2CMRVe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Mar 2012 13:21:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-driver@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

target_fabric_configfs_init() never returns NULLs, only ERR_PTRs.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index dcbcedc..08cf507 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1885,9 +1885,9 @@ static int tcm_qla2xxx_register_configfs(void)
 	 * Register the top level struct config_item_type for NPIV with TCM core
 	 */
 	npiv_fabric = target_fabric_configfs_init(THIS_MODULE, "qla2xxx_npiv");
-	if (!npiv_fabric) {
+	if (IS_ERR(npiv_fabric)) {
 		pr_err("target_fabric_configfs_init() failed\n");
-		ret = -ENOMEM;
+		ret = PTR_ERR(npiv_fabric);
 		goto out_fabric;
 	}
 	/*
