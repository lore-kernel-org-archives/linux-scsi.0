From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: Add 'AIX VDASD' to blacklist
Date: Tue, 17 Oct 2017 09:10:26 +0200
Message-ID: <1508224226-129927-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60333 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933759AbdJQHKa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Oct 2017 03:10:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The AIX VDASD devices do support VPD pages, but implement
only SPC. So set BLIST_TRY_VPD_PAGS to correctly display
the VPD information in sysfs.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_devinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index d39b27c..ae2ad84 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -134,6 +134,7 @@ struct scsi_dev_info_list_table {
 	{"3PARdata", "VV", NULL, BLIST_REPORTLUN2},
 	{"ADAPTEC", "AACRAID", NULL, BLIST_FORCELUN},
 	{"ADAPTEC", "Adaptec 5400S", NULL, BLIST_FORCELUN},
+	{"AIX", "VDASD", NULL, BLIST_TRY_VPD_PAGES},
 	{"AFT PRO", "-IX CF", "0.0>", BLIST_FORCELUN},
 	{"BELKIN", "USB 2 HS-CF", "1.95",  BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"BROWNIE", "1200U3P", NULL, BLIST_NOREPORTLUN},
-- 
1.8.5.6
