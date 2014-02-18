From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 24/35] hpsa: allow VPD page zero to be queried
Date: Tue, 18 Feb 2014 13:57:11 -0600
Message-ID: <20140218195710.15787.15155.stgit@beardog.cce.hp.com>
References: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:43822 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbaBRT7H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 14:59:07 -0500
Received: from g4t3426.houston.hp.com (g4t3426.houston.hp.com [15.201.208.54])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id B570E60365
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 19:58:49 +0000 (UTC)
In-Reply-To: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Code was confused and assumed that page zero was not
VPD page and all non-zero pages were VPD pages.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 76e7ae9..ea77a4f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -183,8 +183,9 @@ static void cmd_special_free(struct ctlr_info *h, struct CommandList *c);
 static struct CommandList *cmd_alloc(struct ctlr_info *h);
 static struct CommandList *cmd_special_alloc(struct ctlr_info *h);
 static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
-	void *buff, size_t size, u8 page_code, unsigned char *scsi3addr,
+	void *buff, size_t size, u16 page_code, unsigned char *scsi3addr,
 	int cmd_type);
+#define VPD_PAGE (1 << 8)
 
 static int hpsa_scsi_queue_command(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static void hpsa_scan_start(struct Scsi_Host *);
@@ -1878,7 +1879,7 @@ static void hpsa_scsi_interpret_error(struct CommandList *cp)
 }
 
 static int hpsa_scsi_do_inquiry(struct ctlr_info *h, unsigned char *scsi3addr,
-			unsigned char page, unsigned char *buf,
+			u16 page, unsigned char *buf,
 			unsigned char bufsize)
 {
 	int rc = IO_OK;
@@ -1948,7 +1949,7 @@ static void hpsa_get_raid_level(struct ctlr_info *h,
 	buf = kzalloc(64, GFP_KERNEL);
 	if (!buf)
 		return;
-	rc = hpsa_scsi_do_inquiry(h, scsi3addr, 0xC1, buf, 64);
+	rc = hpsa_scsi_do_inquiry(h, scsi3addr, VPD_PAGE | 0xC1, buf, 64);
 	if (rc == 0)
 		*raid_level = buf[8];
 	if (*raid_level > RAID_UNKNOWN)
@@ -2077,7 +2078,7 @@ static void hpsa_get_ioaccel_status(struct ctlr_info *h,
 	if (!buf)
 		return;
 	rc = hpsa_scsi_do_inquiry(h, scsi3addr,
-			HPSA_VPD_LV_IOACCEL_STATUS, buf, 64);
+			VPD_PAGE | HPSA_VPD_LV_IOACCEL_STATUS, buf, 64);
 	if (rc != 0)
 		goto out;
 
@@ -2110,7 +2111,7 @@ static int hpsa_get_device_id(struct ctlr_info *h, unsigned char *scsi3addr,
 	buf = kzalloc(64, GFP_KERNEL);
 	if (!buf)
 		return -1;
-	rc = hpsa_scsi_do_inquiry(h, scsi3addr, 0x83, buf, 64);
+	rc = hpsa_scsi_do_inquiry(h, scsi3addr, VPD_PAGE | 0x83, buf, 64);
 	if (rc == 0)
 		memcpy(device_id, &buf[8], buflen);
 	kfree(buf);
@@ -4629,7 +4630,7 @@ static int hpsa_send_host_reset(struct ctlr_info *h, unsigned char *scsi3addr,
 }
 
 static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
-	void *buff, size_t size, u8 page_code, unsigned char *scsi3addr,
+	void *buff, size_t size, u16 page_code, unsigned char *scsi3addr,
 	int cmd_type)
 {
 	int pci_dir = XFER_NONE;
@@ -4652,9 +4653,9 @@ static int fill_cmd(struct CommandList *c, u8 cmd, struct ctlr_info *h,
 		switch (cmd) {
 		case HPSA_INQUIRY:
 			/* are we trying to read a vital product page */
-			if (page_code != 0) {
+			if (page_code & VPD_PAGE) {
 				c->Request.CDB[1] = 0x01;
-				c->Request.CDB[2] = page_code;
+				c->Request.CDB[2] = (page_code & 0xff);
 			}
 			c->Request.CDBLen = 6;
 			c->Request.Type.Attribute = ATTR_SIMPLE;

