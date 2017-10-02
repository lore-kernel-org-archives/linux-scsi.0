From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv6 5/5] scsi_devinfo: fixup string compare
Date: Mon,  2 Oct 2017 16:26:37 +0200
Message-ID: <1506954397-2237-6-git-send-email-hare@suse.de>
References: <1506954397-2237-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59156 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751084AbdJBOix (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Oct 2017 10:38:53 -0400
In-Reply-To: <1506954397-2237-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

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
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 drivers/scsi/scsi_devinfo.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 6858ad8..d39b27c 100644
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
@@ -415,7 +415,7 @@ static struct scsi_dev_info_list *scsi_dev_info_list_find(const char *vendor,
 	struct scsi_dev_info_list *devinfo;
 	struct scsi_dev_info_list_table *devinfo_table =
 		scsi_devinfo_lookup_by_key(key);
-	size_t vmax, mmax;
+	size_t vmax, mmax, mlen;
 	const char *vskip, *mskip;
 
 	if (IS_ERR(devinfo_table))
@@ -454,15 +454,18 @@ static struct scsi_dev_info_list *scsi_dev_info_list_find(const char *vendor,
 			    dev_info_list) {
 		if (devinfo->compatible) {
 			/*
-			 * Behave like the older version of get_device_flags.
+			 * vendor strings must be an exact match
 			 */
-			if (memcmp(devinfo->vendor, vskip, vmax) ||
-					(vmax < sizeof(devinfo->vendor) &&
-						devinfo->vendor[vmax]))
+			if (vmax != strlen(devinfo->vendor) ||
+			    memcmp(devinfo->vendor, vskip, vmax))
 				continue;
-			if (memcmp(devinfo->model, mskip, mmax) ||
-					(mmax < sizeof(devinfo->model) &&
-						devinfo->model[mmax]))
+
+			/*
+			 * @model specifies the full string, and
+			 * must be larger or equal to devinfo->model
+			 */
+			mlen = strlen(devinfo->model);
+			if (mmax < mlen || memcmp(devinfo->model, mskip, mlen))
 				continue;
 			return devinfo;
 		} else {
-- 
1.8.5.6
