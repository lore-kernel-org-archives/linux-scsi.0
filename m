From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] scsi_devinfo: fixup string compare
Date: Tue,  8 Aug 2017 16:36:55 +0200
Message-ID: <1502203017-101403-3-git-send-email-hare@suse.de>
References: <1502203017-101403-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60626 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752430AbdHHOhE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Aug 2017 10:37:04 -0400
In-Reply-To: <1502203017-101403-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When checking the model and vendor string we need to use the
minimum value of either string, otherwise we'll miss out on
wildcard matches.
And we should avoid matching anything with zero size as this
match will be incorrect.
Without this patch certain Hitachi arrays will not be presenting
VPD pages correctly.

Fixes: 5e7ff2c ("SCSI: fix new bug in scsi_dev_info_list string matching")
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_devinfo.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 776c701..712ad1f 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -415,7 +415,7 @@ static struct scsi_dev_info_list *scsi_dev_info_list_find(const char *vendor,
 	struct scsi_dev_info_list *devinfo;
 	struct scsi_dev_info_list_table *devinfo_table =
 		scsi_devinfo_lookup_by_key(key);
-	size_t vmax, mmax;
+	size_t vmax, mmax, vlen, mlen;
 	const char *vskip, *mskip;
 
 	if (IS_ERR(devinfo_table))
@@ -440,6 +440,8 @@ static struct scsi_dev_info_list *scsi_dev_info_list_find(const char *vendor,
 	/* Also skip trailing spaces */
 	while (vmax > 0 && vskip[vmax - 1] == ' ')
 		--vmax;
+	if (!vmax)
+		vskip = NULL;
 
 	mmax = sizeof(devinfo->model);
 	mskip = model;
@@ -449,6 +451,8 @@ static struct scsi_dev_info_list *scsi_dev_info_list_find(const char *vendor,
 	}
 	while (mmax > 0 && mskip[mmax - 1] == ' ')
 		--mmax;
+	if (!mmax)
+		mskip = NULL;
 
 	list_for_each_entry(devinfo, &devinfo_table->scsi_dev_info_list,
 			    dev_info_list) {
@@ -456,20 +460,24 @@ static struct scsi_dev_info_list *scsi_dev_info_list_find(const char *vendor,
 			/*
 			 * Behave like the older version of get_device_flags.
 			 */
-			if (memcmp(devinfo->vendor, vskip, vmax) ||
-					(vmax < sizeof(devinfo->vendor) &&
-						devinfo->vendor[vmax]))
+			vlen = min(vmax, strlen(devinfo->vendor));
+			if (vskip && vlen &&
+			    memcmp(devinfo->vendor, vskip, vlen))
 				continue;
-			if (memcmp(devinfo->model, mskip, mmax) ||
-					(mmax < sizeof(devinfo->model) &&
-						devinfo->model[mmax]))
+			/* Empty strings never match */
+			mlen = min(mmax, strlen(devinfo->model));
+			if (!vlen && !mlen)
 				continue;
-			return devinfo;
+			if (mskip &&
+			    memcmp(devinfo->model, mskip, mlen))
+				continue;
+			if (vskip || mskip)
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
