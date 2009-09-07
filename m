From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/3] libosd: osd_dev_is_ver1 - Minor API cleanup
Date: Mon,  7 Sep 2009 14:26:55 +0300
Message-ID: <1252322815-19415-1-git-send-email-bharrosh@panasas.com>
References: <4AA4ED94.2050805@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:44663 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752923AbZIGL0z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2009 07:26:55 -0400
In-Reply-To: <4AA4ED94.2050805@panasas.com>
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
index 0d29cc3..7bda109 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -113,6 +113,15 @@ static inline void osd_dev_set_ver(struct osd_dev *od, enum osd_std_version v)
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
 
@@ -149,14 +158,9 @@ struct osd_request {
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
1.6.2.1

