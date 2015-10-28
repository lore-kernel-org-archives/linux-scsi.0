From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 1 15/25] hpsa: enhance hpsa_get_device_id
Date: Wed, 28 Oct 2015 17:06:01 -0500
Message-ID: <20151028220601.5323.62936.stgit@brunhilda>
References: <20151028215206.5323.84194.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:49105 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756270AbbJ1WJr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Oct 2015 18:09:47 -0400
In-Reply-To: <20151028215206.5323.84194.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

use an index into vpd data for SAS/SATA drives

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c1b053f..1361414 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3137,7 +3137,7 @@ out:
 
 /* Get the device id from inquiry page 0x83 */
 static int hpsa_get_device_id(struct ctlr_info *h, unsigned char *scsi3addr,
-	unsigned char *device_id, int buflen)
+	unsigned char *device_id, int index, int buflen)
 {
 	int rc;
 	unsigned char *buf;
@@ -3149,8 +3149,10 @@ static int hpsa_get_device_id(struct ctlr_info *h, unsigned char *scsi3addr,
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
 
@@ -3379,6 +3381,18 @@ static int hpsa_device_supports_aborts(struct ctlr_info *h,
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
@@ -3409,6 +3423,9 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		goto bail_out;
 	}
 
+	sanitize_inquiry_string(&inq_buff[8], 8);
+	sanitize_inquiry_string(&inq_buff[16], 16);
+
 	this_device->devtype = (inq_buff[0] & 0x1f);
 	memcpy(this_device->scsi3addr, scsi3addr, 8);
 	memcpy(this_device->vendor, &inq_buff[8],
@@ -3417,7 +3434,7 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 		sizeof(this_device->model));
 	memset(this_device->device_id, 0,
 		sizeof(this_device->device_id));
-	hpsa_get_device_id(h, scsi3addr, this_device->device_id,
+	hpsa_get_device_id(h, scsi3addr, this_device->device_id, 8,
 		sizeof(this_device->device_id));
 
 	if (this_device->devtype == TYPE_DISK &&

