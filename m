From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 12/20] [SCSI] pm80xx: remove unnecessary pci_set_drvdata()
Date: Mon, 23 Sep 2013 10:08:49 +0900
Message-ID: <001001ceb7f9$75c7a140$6156e3c0$%han@samsung.com>
References: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:33107 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3IWBIu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Sep 2013 21:08:50 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MTK0034B0IJD9B0@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 23 Sep 2013 10:08:49 +0900 (KST)
In-reply-to: <000401ceb7f7$6af17fe0$40d47fa0$%han@samsung.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>, 'Lindar Liu' <lindar_liu@usish.com>, 'Jack Wang' <xjtuwjp@gmail.com>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/pm8001/pm8001_init.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index f7c1896..0dba7c7 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -873,7 +873,6 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 	struct pm8001_hba_info *pm8001_ha;
 	int i;
 	pm8001_ha = sha->lldd_ha;
-	pci_set_drvdata(pdev, NULL);
 	sas_unregister_ha(sha);
 	sas_remove_host(pm8001_ha->shost);
 	list_del(&pm8001_ha->list);
-- 
1.7.10.4


