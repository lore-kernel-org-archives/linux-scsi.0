From: Peter Jones <pjones@redhat.com>
Subject: [PATCH] Use a better comparitor for scsi vendor/model table matching.
Date: Wed,  5 Jan 2011 10:39:55 -0500
Message-ID: <1294241995-14270-1-git-send-email-pjones@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab1AEPka (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2011 10:40:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Tejun Heo <tj@kernel.org>, Linux SCSI <linux-scsi@vger.kernel.org>, Peter Jones <pjones@redhat.com>

Previously we were using strncmp in order to avoid having to include
whitespace in the devlist, but this means "HSV1000" matches a device
list entry that says "HSV100", which is wrong.  This patch adds
scsi_dh_strcmp(), which checks that any trailing characters in string 2
are the pad character 0x20.
---
 drivers/scsi/device_handler/scsi_dh.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 6fae3d2..ec2eafb 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -71,16 +71,31 @@ scsi_dh_cache_lookup(struct scsi_device *sdev)
 	return found_dh;
 }
 
+static int scsi_dh_strcmp(const char *a, const char *b)
+{
+	int blen = strlen(b);
+	int rc = strncmp(a, b, blen);
+	int i;
+
+	if (rc != 0)
+		return rc;
+
+	for (i = blen; a[i] != '\0'; i++) {
+		if (a[i] != ' ') {
+			return a[blen] < b[blen] ? -1 : 1;
+		}
+	}
+	return 0;
+}
+
 static int scsi_dh_handler_lookup(struct scsi_device_handler *scsi_dh,
 				  struct scsi_device *sdev)
 {
 	int i, found = 0;
 
 	for(i = 0; scsi_dh->devlist[i].vendor; i++) {
-		if (!strncmp(sdev->vendor, scsi_dh->devlist[i].vendor,
-			     strlen(scsi_dh->devlist[i].vendor)) &&
-		    !strncmp(sdev->model, scsi_dh->devlist[i].model,
-			     strlen(scsi_dh->devlist[i].model))) {
+		if (!scsi_dh_strcmp(sdev->vendor, scsi_dh->devlist[i].vendor) &&
+		    !scsi_dh_strcmp(sdev->model, scsi_dh->devlist[i].model)) {
 			found = 1;
 			break;
 		}
-- 
1.7.3.1

