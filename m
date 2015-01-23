From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 39/48] hpsa: do not use a void pointer for scsi_cmd field
 of struct CommandList
Date: Fri, 23 Jan 2015 16:44:30 -0600
Message-ID: <20150123224430.14919.83004.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:30996 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbbAWWpX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:45:23 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

There's no reason for it to be a void *, it should be a struct scsi_cmnd *

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c     |    6 +++---
 drivers/scsi/hpsa_cmd.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a02ea7f..8f2569c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1764,7 +1764,7 @@ static void complete_scsi_command(struct CommandList *cp)
 	unsigned long sense_data_size;
 
 	ei = cp->err_info;
-	cmd = (struct scsi_cmnd *) cp->scsi_cmd;
+	cmd = cp->scsi_cmd;
 	h = cp->h;
 	dev = cmd->device->hostdata;
 
@@ -4466,7 +4466,7 @@ static int hpsa_send_reset_as_abort_ioaccel2(struct ctlr_info *h,
 	unsigned char *psa = &phys_scsi3addr[0];
 
 	/* Get a pointer to the hpsa logical device. */
-	scmd = (struct scsi_cmnd *) abort->scsi_cmd;
+	scmd = abort->scsi_cmd;
 	dev = (struct hpsa_scsi_dev_t *)(scmd->device->hostdata);
 	if (dev == NULL) {
 		dev_warn(&h->pdev->dev,
@@ -4604,7 +4604,7 @@ static int hpsa_eh_abort_handler(struct scsi_cmnd *sc)
 	}
 	hpsa_get_tag(h, abort, &taglower, &tagupper);
 	ml += sprintf(msg+ml, "Tag:0x%08x:%08x ", tagupper, taglower);
-	as  = (struct scsi_cmnd *) abort->scsi_cmd;
+	as  = abort->scsi_cmd;
 	if (as != NULL)
 		ml += sprintf(msg+ml, "Command:0x%x SN:0x%lx ",
 			as->cmnd[0], as->serial_number);
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 071b64c..3a621c7 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -408,7 +408,7 @@ struct CommandList {
 	int			   cmd_type;
 	long			   cmdindex;
 	struct completion *waiting;
-	void   *scsi_cmd;
+	struct scsi_cmnd *scsi_cmd;
 	struct work_struct work;
 
 	/*

