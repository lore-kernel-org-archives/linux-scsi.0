From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 1/3] device information: Do not interpret error codes as flags
Date: Tue, 14 Nov 2017 18:33:15 -0800
Message-ID: <20171115023317.3595-2-bart.vanassche@wdc.com>
References: <20171115023317.3595-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:42762 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752552AbdKOCf2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Nov 2017 21:35:28 -0500
In-Reply-To: <20171115023317.3595-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

Since commit 28a0bc4120d3 ("scsi: sd: Implement blacklist option for
WRITE SAME w/ UNMAP") bit 31 is a valid device information flag.
Separate device information flags and return codes such that it
becomes possible to check whether or not scsi_get_device_flags_keyed().
succeeded. This patch also avoids that error codes returned by
scsi_get_device_flags_keyed() are interpret as device flags.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_devinfo.c       | 27 +++++++++++++++------------
 drivers/scsi/scsi_priv.h          |  6 ++++--
 drivers/scsi/scsi_scan.c          | 13 +++++++------
 drivers/scsi/scsi_transport_spi.c |  7 ++++---
 4 files changed, 30 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index fe5a9ea27b5e..e63873537139 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -564,6 +564,7 @@ static int scsi_dev_info_list_add_str(char *dev_list)
  * @sdev:       &scsi_device to get flags for
  * @vendor:	vendor name
  * @model:	model name
+ * @flags:      (output) device specific flags
  *
  * Description:
  *     Search the global scsi_dev_info_list (specified by list zero)
@@ -571,12 +572,11 @@ static int scsi_dev_info_list_add_str(char *dev_list)
  *     matching flags value, else return the host or global default
  *     settings.  Called during scan time.
  **/
-int scsi_get_device_flags(struct scsi_device *sdev,
-			  const unsigned char *vendor,
-			  const unsigned char *model)
+int scsi_get_device_flags(struct scsi_device *sdev, const unsigned char *vendor,
+			  const unsigned char *model, unsigned int *flags)
 {
 	return scsi_get_device_flags_keyed(sdev, vendor, model,
-					   SCSI_DEVINFO_GLOBAL);
+					   SCSI_DEVINFO_GLOBAL, flags);
 }
 
 
@@ -586,6 +586,7 @@ int scsi_get_device_flags(struct scsi_device *sdev,
  * @vendor:	vendor name
  * @model:	model name
  * @key:	list to look up
+ * @flags:      (output) device specific flags
  *
  * Description:
  *     Search the scsi_dev_info_list specified by @key for an entry
@@ -596,28 +597,30 @@ int scsi_get_device_flags(struct scsi_device *sdev,
 int scsi_get_device_flags_keyed(struct scsi_device *sdev,
 				const unsigned char *vendor,
 				const unsigned char *model,
-				int key)
+				int key, unsigned int *flags)
 {
 	struct scsi_dev_info_list *devinfo;
 	int err;
 
 	devinfo = scsi_dev_info_list_find(vendor, model, key);
-	if (!IS_ERR(devinfo))
-		return devinfo->flags;
+	if (!IS_ERR(devinfo)) {
+		*flags = devinfo->flags;
+		return 0;
+	}
 
 	err = PTR_ERR(devinfo);
 	if (err != -ENOENT)
 		return err;
 
 	/* nothing found, return nothing */
-	if (key != SCSI_DEVINFO_GLOBAL)
+	if (key != SCSI_DEVINFO_GLOBAL) {
+		*flags = 0;
 		return 0;
+	}
 
 	/* except for the global list, where we have an exception */
-	if (sdev->sdev_bflags)
-		return sdev->sdev_bflags;
-
-	return scsi_default_dev_flags;
+	*flags = sdev->sdev_bflags ? : scsi_default_dev_flags;
+	return 0;
 }
 EXPORT_SYMBOL(scsi_get_device_flags_keyed);
 
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 320318487bd4..d79759271fe3 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -52,10 +52,12 @@ enum {
 
 extern int scsi_get_device_flags(struct scsi_device *sdev,
 				 const unsigned char *vendor,
-				 const unsigned char *model);
+				 const unsigned char *model,
+				 unsigned int *flags);
 extern int scsi_get_device_flags_keyed(struct scsi_device *sdev,
 				       const unsigned char *vendor,
-				       const unsigned char *model, int key);
+				       const unsigned char *model, int key,
+				       unsigned int *flags);
 extern int scsi_dev_info_list_add_keyed(int compatible, char *vendor,
 					char *model, char *strflags,
 					int flags, int key);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index a0f2a20ea9e9..5b9571f30d82 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -650,8 +650,8 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		 * corresponding bit fields in scsi_device, so bflags
 		 * need not be passed as an argument.
 		 */
-		*bflags = scsi_get_device_flags(sdev, &inq_result[8],
-				&inq_result[16]);
+		scsi_get_device_flags(sdev, &inq_result[8], &inq_result[16],
+				      bflags);
 
 		/* When the first pass succeeds we gain information about
 		 * what larger transfer lengths might work. */
@@ -1074,10 +1074,11 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 			else
 				scsi_device_put(sdev);
 
-			if (bflagsp)
-				*bflagsp = scsi_get_device_flags(sdev,
-								 sdev->vendor,
-								 sdev->model);
+			if (bflagsp) {
+				*bflagsp = 0;
+				scsi_get_device_flags(sdev, sdev->vendor,
+						      sdev->model, bflagsp);
+			}
 			return SCSI_SCAN_LUN_PRESENT;
 		}
 		scsi_device_put(sdev);
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index d0219e36080c..5f4cea2d07c8 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -221,9 +221,10 @@ static int spi_device_configure(struct transport_container *tc,
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct scsi_target *starget = sdev->sdev_target;
-	unsigned bflags = scsi_get_device_flags_keyed(sdev, &sdev->inquiry[8],
-						      &sdev->inquiry[16],
-						      SCSI_DEVINFO_SPI);
+	unsigned int bflags = 0;
+
+	scsi_get_device_flags_keyed(sdev, &sdev->inquiry[8], &sdev->inquiry[16],
+				    SCSI_DEVINFO_SPI, &bflags);
 
 	/* Populate the target capability fields with the values
 	 * gleaned from the device inquiry */
-- 
2.15.0
