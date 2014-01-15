From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 25/41] hpsa: teach hpsa_device_reset to do either target or
	lun reset
Date: Wed, 15 Jan 2014 16:38:26 -0600
Message-ID: <20140115223826.5061.13848.stgit@beardog.cce.hp.com>
References: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:45578 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbaAOVi1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jan 2014 16:38:27 -0500
In-Reply-To: <20140115223354.5061.50276.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Scott Teel <scott.teel@hp.com>

Signed-off-by: Scott Teel <scott.teel@hp.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9628e12..7cab95f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1858,7 +1858,8 @@ out:
 	return rc;
 }
 
-static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3addr)
+static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3addr,
+	u8 reset_type)
 {
 	int rc = IO_OK;
 	struct CommandList *c;
@@ -1872,8 +1873,8 @@ static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3addr)
 	}
 
 	/* fill_cmd can't fail here, no data buffer to map. */
-	(void) fill_cmd(c, HPSA_DEVICE_RESET_MSG, h,
-			NULL, 0, 0, scsi3addr, TYPE_MSG);
+	(void) fill_cmd(c, HPSA_DEVICE_RESET_MSG, h, NULL, 0, 0, scsi3addr, TYPE_MSG);
+	c->Request.CDB[1] = reset_type; /* fill_cmd defaults to LUN reset type */
 	hpsa_scsi_do_simple_cmd_core(h, c);
 	/* no unmap needed here because no data xfer. */
 
@@ -3397,7 +3398,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	dev_warn(&h->pdev->dev, "resetting device %d:%d:%d:%d\n",
 		h->scsi_host->host_no, dev->bus, dev->target, dev->lun);
 	/* send a reset to the SCSI LUN which the command was sent to */
-	rc = hpsa_send_reset(h, dev->scsi3addr);
+	rc = hpsa_send_reset(h, dev->scsi3addr, HPSA_RESET_TYPE_LUN);
 	if (rc == 0 && wait_for_device_to_become_ready(h, dev->scsi3addr) == 0)
 		return SUCCESS;
 

