From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/2] libosd: osd_dev_is_ver1 - Minor API cleanup
Date: Tue, 30 Jun 2009 20:10:58 +0300
Message-ID: <4A4A4722.6090009@panasas.com>
References: <4A4A467A.7020600@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:21120
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752495AbZF3RK5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Jun 2009 13:10:57 -0400
In-Reply-To: <4A4A467A.7020600@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benny Halevy <bhalevy@panasas.com>, open-osd mailing-list <osd-dev@open-osd.org>, pNFS Mailing List <pnfs@linux-nfs.org>, linux-scsi <linux-scsi@vger.kernel.org>


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


