From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [scsi 1/2] scsi device: add setters and getters for hostadat
Date: Sun,  1 Mar 2015 12:22:06 +0200
Message-ID: <1425205327-27639-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:22417 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbbCAKXE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Mar 2015 05:23:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley\"" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>, Christoph Hellwig <hch@lst.de>, Douglas Gilbert <dgilbert@interlog.com>

Add setters and getters for host data of scsi_device
and scsi_target in spirit of  dev_set/get_drvdata

Cc: Christoph Hellwig <hch@lst.de>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 include/scsi/scsi_device.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index a4c9336811d1..fdf407e8bbed 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -532,6 +532,27 @@ static inline int scsi_device_tpgs(struct scsi_device *sdev)
 	return sdev->inquiry ? (sdev->inquiry[5] >> 4) & 0x3 : 0;
 }
 
+static inline void *scsi_device_get_hdata(struct scsi_device *sdev)
+{
+	return sdev->hostdata;
+}
+
+static inline void scsi_device_set_hdata(struct scsi_device *sdev, void *hdata)
+{
+	sdev->hostdata = hdata;
+}
+
+static inline void *scsi_target_get_hdata(struct scsi_target *starget)
+{
+	return starget->hostdata;
+}
+
+static inline void scsi_target_set_hdata(struct scsi_target *starget,
+					  void *hdata)
+{
+	starget->hostdata = hdata;
+}
+
 #define MODULE_ALIAS_SCSI_DEVICE(type) \
 	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
 #define SCSI_DEVICE_MODALIAS_FMT "scsi:t-0x%02x"
-- 
1.9.3

