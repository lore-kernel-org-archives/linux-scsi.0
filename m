From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi_devinfo: fixup string compare
Date: Fri,  4 Aug 2017 11:40:25 +0200
Message-ID: <1501839625-93492-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43407 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751963AbdHDJk2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 4 Aug 2017 05:40:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When checking the model and vendor string we need to use the
minimum value of either string, otherwise we'll miss out on
wildcard matches.
Without this patch certain Hitachi arrays will not be presenting
VPD pages correctly.

Fixes: 5e7ff2c ("SCSI: fix new bug in scsi_dev_info_list string matching")
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_devinfo.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 28fea83..f8a302f 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -456,11 +456,13 @@ static struct scsi_dev_info_list *scsi_dev_info_list_find(const char *vendor,
 			/*
 			 * Behave like the older version of get_device_flags.
 			 */
-			if (memcmp(devinfo->vendor, vskip, vmax) ||
+			if (memcmp(devinfo->vendor, vskip,
+				   min(vmax, strlen(devinfo->vendor))) ||
 					(vmax < sizeof(devinfo->vendor) &&
 						devinfo->vendor[vmax]))
 				continue;
-			if (memcmp(devinfo->model, mskip, mmax) ||
+			if (memcmp(devinfo->model, mskip,
+				   min(mmax, strlen(devinfo->model))) ||
 					(mmax < sizeof(devinfo->model) &&
 						devinfo->model[mmax]))
 				continue;
-- 
1.8.5.6
