From: Quentin Lambert <lambert.quentin@gmail.com>
Subject: [PATCH] scsi: hisi_sas: Add a missing call to kfree
Date: Sat, 19 Nov 2016 18:42:59 +0100
Message-ID: <20161119174259.20344-1-lambert.quentin@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33788 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752441AbcKSRqX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Nov 2016 12:46:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Cc: Quentin Lambert <lambert.quentin@gmail.com>

Most error branches following the call to hisi_sas_shost_alloc contain
a call to kfree. This patch add these calls where they are
missing.

This issue was found with Hector.

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>

---
 drivers/scsi/hisi_sas/hisi_sas_main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1503,8 +1503,10 @@ int hisi_sas_probe(struct platform_devic
 
 	arr_phy = devm_kcalloc(dev, phy_nr, sizeof(void *), GFP_KERNEL);
 	arr_port = devm_kcalloc(dev, port_nr, sizeof(void *), GFP_KERNEL);
-	if (!arr_phy || !arr_port)
-		return -ENOMEM;
+	if (!arr_phy || !arr_port) {
+		rc = -ENOMEM;
+		goto err_out_ha;
+	}
 
 	sha->sas_phy = arr_phy;
 	sha->sas_port = arr_port;
