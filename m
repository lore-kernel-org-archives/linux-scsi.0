From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi_sysfs: Fix typo in is_bin_visible()
Date: Thu, 10 Mar 2016 11:25:26 +0100
Message-ID: <1457605526-112163-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932660AbcCJKZk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Mar 2016 05:25:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The test for the existence vpd_pg83 is inverted.

Fixes: 7e47976bcff ("scsi_sysfs: add 'is_bin_visible' callback")
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 58ac9c1..d805d55 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1105,7 +1105,7 @@ static umode_t scsi_sdev_bin_attr_is_visible(struct kobject *kobj,
 	if (attr == &dev_attr_vpd_pg80 && !sdev->vpd_pg80)
 		return 0;
 
-	if (attr == &dev_attr_vpd_pg83 && sdev->vpd_pg83)
+	if (attr == &dev_attr_vpd_pg83 && !sdev->vpd_pg83)
 		return 0;
 
 	return S_IRUGO;
-- 
1.8.5.6

