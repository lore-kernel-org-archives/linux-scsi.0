From: Pan Bian <bianpan2016@163.com>
Subject: scsi: mvsas: replace kfree with scsi_host_put
Date: Tue,  8 Aug 2017 20:02:51 +0800
Message-ID: <1502193771-20271-1-git-send-email-bianpan2016@163.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:48768 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752050AbdHHMDz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Aug 2017 08:03:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jthumshirn@suse.de>, Jinpu Wang <jinpu.wang@profitbricks.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>

The return value of scsi_host_alloc() should be released by
scsi_host_put(). However, in function mvs_pci_init(), kfree()
is used. This patch replaces kfree() with scsi_host_put() to avoid
possible memory leaks.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/scsi/mvsas/mv_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 4e047b5..75bdb38 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -557,14 +557,14 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 	SHOST_TO_SAS_HA(shost) =
 		kcalloc(1, sizeof(struct sas_ha_struct), GFP_KERNEL);
 	if (!SHOST_TO_SAS_HA(shost)) {
-		kfree(shost);
+		scsi_host_put(shost);
 		rc = -ENOMEM;
 		goto err_out_regions;
 	}
 
 	rc = mvs_prep_sas_ha_init(shost, chip);
 	if (rc) {
-		kfree(shost);
+		scsi_host_put(shost);
 		rc = -ENOMEM;
 		goto err_out_regions;
 	}
-- 
1.9.1
