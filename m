From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 22/48] hpsa: reserve some commands for use by driver
Date: Fri, 23 Jan 2015 16:42:59 -0600
Message-ID: <20150123224259.14919.3837.stgit@brunhilda>
References: <20150123224020.14919.29458.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:30586 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbbAWWnx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 17:43:53 -0500
In-Reply-To: <20150123224020.14919.29458.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

We need to reserve some commands for device rescans,
aborts, and the pass through ioctls, etc. so we cannot
give them all to the scsi mid layer.

This is in preparation for removing cmd_special_alloc and
cmd_special_free so that we can stop queuing commands internally
in the driver so that we can remove the locks thta protect the
queue that we will no longer have.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    7 +++++--
 drivers/scsi/hpsa.h |    2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index bee24b2..99c32a0 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4064,11 +4064,14 @@ static int hpsa_register_scsi(struct ctlr_info *h)
 	sh->max_cmd_len = MAX_COMMAND_SIZE;
 	sh->max_lun = HPSA_MAX_LUN;
 	sh->max_id = HPSA_MAX_LUN;
-	sh->can_queue = h->nr_cmds;
+	sh->can_queue = h->nr_cmds -
+			HPSA_CMDS_RESERVED_FOR_ABORTS -
+			HPSA_CMDS_RESERVED_FOR_DRIVER -
+			HPSA_MAX_CONCURRENT_PASSTHRUS;
 	if (h->hba_mode_enabled)
 		sh->cmd_per_lun = 7;
 	else
-		sh->cmd_per_lun = h->nr_cmds;
+		sh->cmd_per_lun = sh->can_queue;
 	sh->sg_tablesize = h->maxsgentries;
 	h->scsi_host = sh;
 	sh->hostdata[0] = (unsigned long) h;
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 8e06d9e..5ee6c6a 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -115,6 +115,8 @@ struct ctlr_info {
 	void __iomem *vaddr;
 	unsigned long paddr;
 	int 	nr_cmds; /* Number of commands allowed on this controller */
+#define HPSA_CMDS_RESERVED_FOR_ABORTS 2
+#define HPSA_CMDS_RESERVED_FOR_DRIVER 1
 	struct CfgTable __iomem *cfgtable;
 	int	interrupts_enabled;
 	int 	max_commands;

