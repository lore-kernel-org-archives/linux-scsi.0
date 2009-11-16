From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/9] libosd: osd_dev_is_ver1 - Minor API cleanup
Date: Mon, 16 Nov 2009 20:39:25 +0200
Message-ID: <1258396765-32586-1-git-send-email-bharrosh@panasas.com>
References: <4B019BEC.3080909@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:35512 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750995AbZKPSwr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2009 13:52:47 -0500
In-Reply-To: <4B019BEC.3080909@panasas.com>
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
1.6.5.2

