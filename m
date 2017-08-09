From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 4/4] scsi_devinfo: fixup string compare
Date: Wed,  9 Aug 2017 12:44:04 +0200
Message-ID: <1502275444-27676-5-git-send-email-hare@suse.de>
References: <1502275444-27676-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37841 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751722AbdHIKoP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Aug 2017 06:44:15 -0400
In-Reply-To: <1502275444-27676-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Doug Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When checking the model and vendor string we need to use the
minimum value of either string, otherwise we'll miss out on
wildcard matches.
And we should take card when matching with zero size strings;
results might be unpredictable.
With this patch the rules for matching devinfo strings are
as follows:
- Vendor strings must match exactly
- Empty Model strings will only match if the devinfo model
  is also empty
- Model strings shorter than the devinfo model string will
  not match

Fixes: 5e7ff2c ("SCSI: fix new bug in scsi_dev_info_list string matching")
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_devinfo.c | 46 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 776c701..f8f5cb7 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -399,8 +399,8 @@ int scsi_dev_info_list_add_keyed(int compatible, char *vendor, char *model,
 
 /**
  * scsi_dev_info_list_find - find a matching dev_info list entry.
- * @vendor:	vendor string
- * @model:	model (product) string
+ * @vendor:	full vendor string
+ * @model:	full model (product) string
  * @key:	specify list to use
  *
  * Description:
@@ -440,6 +440,8 @@ static struct scsi_dev_info_list *scsi_dev_info_list_find(const char *vendor,
 	/* Also skip trailing spaces */
 	while (vmax > 0 && vskip[vmax - 1] == ' ')
 		--vmax;
+	if (!vmax)
+		vskip = NULL;
 
 	mmax = sizeof(devinfo->model);
 	mskip = model;
@@ -449,27 +451,45 @@ static struct scsi_dev_info_list *scsi_dev_info_list_find(const char *vendor,
 	}
 	while (mmax > 0 && mskip[mmax - 1] == ' ')
 		--mmax;
+	if (!mmax)
+		mskip = NULL;
 
 	list_for_each_entry(devinfo, &devinfo_table->scsi_dev_info_list,
 			    dev_info_list) {
 		if (devinfo->compatible) {
 			/*
-			 * Behave like the older version of get_device_flags.
+			 * vendor strings must be an exact match
 			 */
-			if (memcmp(devinfo->vendor, vskip, vmax) ||
-					(vmax < sizeof(devinfo->vendor) &&
-						devinfo->vendor[vmax]))
+			if (vmax != strlen(devinfo->vendor))
 				continue;
-			if (memcmp(devinfo->model, mskip, mmax) ||
-					(mmax < sizeof(devinfo->model) &&
-						devinfo->model[mmax]))
+			if (vskip && vmax &&
+			    memcmp(devinfo->vendor, vskip, vmax))
 				continue;
-			return devinfo;
+			/*
+			 * Empty model strings only match if both strings
+			 * are empty.
+			 */
+			if (!mmax && !strlen(devinfo->model))
+				return devinfo;
+
+			/*
+			 * Empty @model never matches
+			 */
+			if (!mskip)
+				continue;
+
+			/*
+			 * @model specifies the full string, and
+			 * must be larger or equal to devinfo->model
+			 */
+			if (!memcmp(devinfo->model, mskip,
+				    strlen(devinfo->model)))
+				return devinfo;
 		} else {
 			if (!memcmp(devinfo->vendor, vendor,
-				     sizeof(devinfo->vendor)) &&
-			     !memcmp(devinfo->model, model,
-				      sizeof(devinfo->model)))
+				    sizeof(devinfo->vendor)) &&
+			    !memcmp(devinfo->model, model,
+				    sizeof(devinfo->model)))
 				return devinfo;
 		}
 	}
-- 
1.8.5.6
