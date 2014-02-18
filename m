From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 18/35] hpsa: teach hpsa_device_reset to do either target or
	lun reset
Date: Tue, 18 Feb 2014 13:56:39 -0600
Message-ID: <20140218195639.15787.28786.stgit@beardog.cce.hp.com>
References: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:57079 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbaBRT6b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 14:58:31 -0500
Received: from g4t3426.houston.hp.com (g4t3426.houston.hp.com [15.201.208.54])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id DA23A1246
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 19:58:23 +0000 (UTC)
In-Reply-To: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Scott Teel <scott.teel@hp.com>

Signed-off-by: Scott Teel <scott.teel@hp.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e40d94d..021d077 100644
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
@@ -1872,8 +1873,9 @@ static int hpsa_send_reset(struct ctlr_info *h, unsigned char *scsi3addr)
 	}
 
 	/* fill_cmd can't fail here, no data buffer to map. */
-	(void) fill_cmd(c, HPSA_DEVICE_RESET_MSG, h,
-			NULL, 0, 0, scsi3addr, TYPE_MSG);
+	(void) fill_cmd(c, HPSA_DEVICE_RESET_MSG, h, NULL, 0, 0,
+			scsi3addr, TYPE_MSG);
+	c->Request.CDB[1] = reset_type; /* fill_cmd defaults to LUN reset */
 	hpsa_scsi_do_simple_cmd_core(h, c);
 	/* no unmap needed here because no data xfer. */
 
@@ -3390,7 +3392,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	dev_warn(&h->pdev->dev, "resetting device %d:%d:%d:%d\n",
 		h->scsi_host->host_no, dev->bus, dev->target, dev->lun);
 	/* send a reset to the SCSI LUN which the command was sent to */
-	rc = hpsa_send_reset(h, dev->scsi3addr);
+	rc = hpsa_send_reset(h, dev->scsi3addr, HPSA_RESET_TYPE_LUN);
 	if (rc == 0 && wait_for_device_to_become_ready(h, dev->scsi3addr) == 0)
 		return SUCCESS;
 

