From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 06/12] hpsa: change timeout for internal cmds
Date: Fri, 20 Oct 2017 16:51:38 -0500
Message-ID: <150853629874.28275.9150965234203060853.stgit@brunhilda>
References: <150853443786.28275.17878578984391668998.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0073.outbound.protection.outlook.com ([104.47.38.73]:28183
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753147AbdJTVw0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Oct 2017 17:52:26 -0400
In-Reply-To: <150853443786.28275.17878578984391668998.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

There are times when the DEFAULT_TIMEOUT (30 seconds)
is not enough.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 6056bbd..4ab53df 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2929,7 +2929,7 @@ static int hpsa_scsi_do_inquiry(struct ctlr_info *h, unsigned char *scsi3addr,
 		goto out;
 	}
 	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
-					PCI_DMA_FROMDEVICE, DEFAULT_TIMEOUT);
+					PCI_DMA_FROMDEVICE, NO_TIMEOUT);
 	if (rc)
 		goto out;
 	ei = c->err_info;
@@ -3213,7 +3213,7 @@ static int hpsa_get_raid_map(struct ctlr_info *h,
 		return -1;
 	}
 	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
-					PCI_DMA_FROMDEVICE, DEFAULT_TIMEOUT);
+					PCI_DMA_FROMDEVICE, NO_TIMEOUT);
 	if (rc)
 		goto out;
 	ei = c->err_info;
@@ -3256,7 +3256,7 @@ static int hpsa_bmic_sense_subsystem_information(struct ctlr_info *h,
 	c->Request.CDB[9] = (bmic_device_index >> 8) & 0xff;
 
 	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
-				PCI_DMA_FROMDEVICE, DEFAULT_TIMEOUT);
+				PCI_DMA_FROMDEVICE, NO_TIMEOUT);
 	if (rc)
 		goto out;
 	ei = c->err_info;
@@ -3284,7 +3284,7 @@ static int hpsa_bmic_id_controller(struct ctlr_info *h,
 		goto out;
 
 	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
-		PCI_DMA_FROMDEVICE, DEFAULT_TIMEOUT);
+		PCI_DMA_FROMDEVICE, NO_TIMEOUT);
 	if (rc)
 		goto out;
 	ei = c->err_info;
@@ -3315,7 +3315,7 @@ static int hpsa_bmic_id_physical_device(struct ctlr_info *h,
 	c->Request.CDB[9] = (bmic_device_index >> 8) & 0xff;
 
 	hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE,
-						DEFAULT_TIMEOUT);
+						NO_TIMEOUT);
 	ei = c->err_info;
 	if (ei->CommandStatus != 0 && ei->CommandStatus != CMD_DATA_UNDERRUN) {
 		hpsa_scsi_interpret_error(h, c);
@@ -3388,7 +3388,7 @@ static void hpsa_get_enclosure_info(struct ctlr_info *h,
 		c->Request.CDB[5] = 0;
 
 	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c, PCI_DMA_FROMDEVICE,
-						DEFAULT_TIMEOUT);
+						NO_TIMEOUT);
 	if (rc)
 		goto out;
 
@@ -3628,7 +3628,7 @@ static int hpsa_scsi_do_report_luns(struct ctlr_info *h, int logical,
 	if (extended_response)
 		c->Request.CDB[1] = extended_response;
 	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
-					PCI_DMA_FROMDEVICE, DEFAULT_TIMEOUT);
+					PCI_DMA_FROMDEVICE, NO_TIMEOUT);
 	if (rc)
 		goto out;
 	ei = c->err_info;
@@ -3763,7 +3763,7 @@ static unsigned char hpsa_volume_offline(struct ctlr_info *h,
 
 	(void) fill_cmd(c, TEST_UNIT_READY, h, NULL, 0, 0, scsi3addr, TYPE_CMD);
 	rc = hpsa_scsi_do_simple_cmd(h, c, DEFAULT_REPLY_QUEUE,
-					DEFAULT_TIMEOUT);
+					NO_TIMEOUT);
 	if (rc) {
 		cmd_free(h, c);
 		return HPSA_VPD_LV_STATUS_UNSUPPORTED;
@@ -8620,7 +8620,7 @@ static void hpsa_disable_rld_caching(struct ctlr_info *h)
 		goto errout;
 
 	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
-		PCI_DMA_FROMDEVICE, DEFAULT_TIMEOUT);
+		PCI_DMA_FROMDEVICE, NO_TIMEOUT);
 	if ((rc != 0) || (c->err_info->CommandStatus != 0))
 		goto errout;
 
@@ -8632,7 +8632,7 @@ static void hpsa_disable_rld_caching(struct ctlr_info *h)
 		goto errout;
 
 	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
-		PCI_DMA_TODEVICE, DEFAULT_TIMEOUT);
+		PCI_DMA_TODEVICE, NO_TIMEOUT);
 	if ((rc != 0)  || (c->err_info->CommandStatus != 0))
 		goto errout;
 
@@ -8642,7 +8642,7 @@ static void hpsa_disable_rld_caching(struct ctlr_info *h)
 		goto errout;
 
 	rc = hpsa_scsi_do_simple_cmd_with_retry(h, c,
-		PCI_DMA_FROMDEVICE, DEFAULT_TIMEOUT);
+		PCI_DMA_FROMDEVICE, NO_TIMEOUT);
 	if ((rc != 0)  || (c->err_info->CommandStatus != 0))
 		goto errout;
 
