From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/5] libosd: osd_dev_is_ver1 - Minor API cleanup
Date: Mon, 26 Oct 2009 18:56:45 +0200
Message-ID: <1256576205-10351-1-git-send-email-bharrosh@panasas.com>
References: <4AE5D374.80400@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:26286 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753373AbZJZQ4n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2009 12:56:43 -0400
In-Reply-To: <4AE5D374.80400@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

define a new osd_dev_is_ver1 that operates on devices
and the old osd_req_is_ver1 uses that new API.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 include/scsi/osd_initiator.h |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index 02bd9f7..f787d24 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -84,6 +84,15 @@ static inline void osd_dev_set_ver(struct osd_dev *od, enum osd_std_version v)
 #endif
 }
 
+static inline bool osd_dev_is_ver1(struct osd_dev *od)
+{
+#ifdef OSD_VER1_SUPPORT
+	return od->version == OSD_VER1;
+#else
+	return false;
+#endif
+}
+
 struct osd_request;
 typedef void (osd_req_done_fn)(struct osd_request *or, void *private);
 
@@ -120,14 +129,9 @@ struct osd_request {
 	int async_error;
 };
 
-/* OSD Version control */
 static inline bool osd_req_is_ver1(struct osd_request *or)
 {
-#ifdef OSD_VER1_SUPPORT
-	return or->osd_dev->version == OSD_VER1;
-#else
-	return false;
-#endif
+	return osd_dev_is_ver1(or->osd_dev);
 }
 
 /*
-- 
1.6.5.1

