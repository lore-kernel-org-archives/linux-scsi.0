From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 17/27] hpsa: enhance hpsa_get_device_id
Date: Wed, 04 Nov 2015 15:51:39 -0600
Message-ID: <20151104215139.15472.48831.stgit@brunhilda>
References: <20151104214910.15472.23179.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:53604 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030199AbbKDVzc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 16:55:32 -0500
In-Reply-To: <20151104214910.15472.23179.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

use an index into vpd data for SAS/SATA drives

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 21892c1..80d64ac 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3128,7 +3128,7 @@ out:
 
 /* Get the device id from inquiry page 0x83 */
 static int hpsa_get_device_id(struct ctlr_info *h, unsigned char *scsi3addr,
-	unsigned char *device_id, int buflen)
+	unsigned char *device_id, int index, int buflen)
 {
 	int rc;
 	unsigned char *buf;
@@ -3140,8 +3140,10 @@ static int hpsa_get_device_id(struct ctlr_info *h, unsigned char *scsi3addr,
 		return -ENOMEM;
 	rc = hpsa_scsi_do_inquiry(h, scsi3addr, VPD_PAGE | 0x83, buf, 64);
 	if (rc == 0)
-		memcpy(device_id, &buf[8], buflen);
+		memcpy(device_id, &buf[index], buflen);
+
 	kfree(buf);
+
 	return rc != 0;
 }
 
@@ -3370,6 +3372,18 @@ static int hpsa_device_supports_aborts(struct ctlr_info *h,
 	return rc;
 }
 
+static void sanitize_inquiry_string(unsigned char *s, int len)
+{
+	bool terminated = false;
+
+	for (; len > 0; (--len, ++s)) {
+		if (*s == 0)
+			terminated = true;
+		if (terminated || *s < 0x20 || *s > 0x7e)
+			*s = ' ';
+	}
+}
+
 static int hpsa_update_device_info(struct ctlr_info *h,
 	unsigned char scsi3addr[], struct hpsa_scsi_dev_t *this_device,
 	unsigned char *is_OBDR_device)
@@ -3400,6 +3414,9 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		goto bail_out;
 	}
 
+	sanitize_inquiry_string(&inq_buff[8], 8);
+	sanitize_inquiry_string(&inq_buff[16], 16);
+
 	this_device->devtype = (inq_buff[0] & 0x1f);
 	memcpy(this_device->scsi3addr, scsi3addr, 8);
 	memcpy(this_device->vendor, &inq_buff[8],
@@ -3408,7 +3425,7 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		sizeof(this_device->model));
 	memset(this_device->device_id, 0,
 		sizeof(this_device->device_id));
-	hpsa_get_device_id(h, scsi3addr, this_device->device_id,
+	hpsa_get_device_id(h, scsi3addr, this_device->device_id, 8,
 		sizeof(this_device->device_id));
 
 	if (this_device->devtype == TYPE_DISK &&

