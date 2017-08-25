From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 11/26] scsi: drop bus reset for wd33c93-compatible boards
Date: Fri, 25 Aug 2017 13:57:06 +0200
Message-ID: <1503662241-127788-12-git-send-email-hare@suse.de>
References: <1503662241-127788-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49608 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756501AbdHYL6B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 07:58:01 -0400
In-Reply-To: <1503662241-127788-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The bus reset function is just a wrapper calling host reset
under the host lock. So move taking of the host lock into
the host reset function and drop bus reset.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/a2091.c   | 17 -----------------
 drivers/scsi/a3000.c   | 17 -----------------
 drivers/scsi/gvp11.c   | 18 ------------------
 drivers/scsi/mvme147.c | 16 ----------------
 drivers/scsi/sgiwd93.c | 15 ---------------
 drivers/scsi/wd33c93.c |  2 ++
 6 files changed, 2 insertions(+), 83 deletions(-)

diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index 9176bfb..61aadc7 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -147,22 +147,6 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	}
 }
 
-static int a2091_bus_reset(struct scsi_cmnd *cmd)
-{
-	struct Scsi_Host *instance = cmd->device->host;
-
-	/* FIXME perform bus-specific reset */
-
-	/* FIXME 2: kill this function, and let midlayer fall back
-	   to the same action, calling wd33c93_host_reset() */
-
-	spin_lock_irq(instance->host_lock);
-	wd33c93_host_reset(cmd);
-	spin_unlock_irq(instance->host_lock);
-
-	return SUCCESS;
-}
-
 static struct scsi_host_template a2091_scsi_template = {
 	.module			= THIS_MODULE,
 	.name			= "Commodore A2091/A590 SCSI",
@@ -171,7 +155,6 @@ static int a2091_bus_reset(struct scsi_cmnd *cmd)
 	.proc_name		= "A2901",
 	.queuecommand		= wd33c93_queuecommand,
 	.eh_abort_handler	= wd33c93_abort,
-	.eh_bus_reset_handler	= a2091_bus_reset,
 	.eh_host_reset_handler	= wd33c93_host_reset,
 	.can_queue		= CAN_QUEUE,
 	.this_id		= 7,
diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index e6375b4..2427a85 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -162,22 +162,6 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	}
 }
 
-static int a3000_bus_reset(struct scsi_cmnd *cmd)
-{
-	struct Scsi_Host *instance = cmd->device->host;
-
-	/* FIXME perform bus-specific reset */
-
-	/* FIXME 2: kill this entire function, which should
-	   cause mid-layer to call wd33c93_host_reset anyway? */
-
-	spin_lock_irq(instance->host_lock);
-	wd33c93_host_reset(cmd);
-	spin_unlock_irq(instance->host_lock);
-
-	return SUCCESS;
-}
-
 static struct scsi_host_template amiga_a3000_scsi_template = {
 	.module			= THIS_MODULE,
 	.name			= "Amiga 3000 built-in SCSI",
@@ -186,7 +170,6 @@ static int a3000_bus_reset(struct scsi_cmnd *cmd)
 	.proc_name		= "A3000",
 	.queuecommand		= wd33c93_queuecommand,
 	.eh_abort_handler	= wd33c93_abort,
-	.eh_bus_reset_handler	= a3000_bus_reset,
 	.eh_host_reset_handler	= wd33c93_host_reset,
 	.can_queue		= CAN_QUEUE,
 	.this_id		= 7,
diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 3b6f83f..a27fc49 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -171,23 +171,6 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	}
 }
 
-static int gvp11_bus_reset(struct scsi_cmnd *cmd)
-{
-	struct Scsi_Host *instance = cmd->device->host;
-
-	/* FIXME perform bus-specific reset */
-
-	/* FIXME 2: shouldn't we no-op this function (return
-	   FAILED), and fall back to host reset function,
-	   wd33c93_host_reset ? */
-
-	spin_lock_irq(instance->host_lock);
-	wd33c93_host_reset(cmd);
-	spin_unlock_irq(instance->host_lock);
-
-	return SUCCESS;
-}
-
 static struct scsi_host_template gvp11_scsi_template = {
 	.module			= THIS_MODULE,
 	.name			= "GVP Series II SCSI",
@@ -196,7 +179,6 @@ static int gvp11_bus_reset(struct scsi_cmnd *cmd)
 	.proc_name		= "GVP11",
 	.queuecommand		= wd33c93_queuecommand,
 	.eh_abort_handler	= wd33c93_abort,
-	.eh_bus_reset_handler	= gvp11_bus_reset,
 	.eh_host_reset_handler	= wd33c93_host_reset,
 	.can_queue		= CAN_QUEUE,
 	.this_id		= 7,
diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
index e7f6661..4f51570 100644
--- a/drivers/scsi/mvme147.c
+++ b/drivers/scsi/mvme147.c
@@ -121,21 +121,6 @@ int mvme147_detect(struct scsi_host_template *tpnt)
 	return 0;
 }
 
-static int mvme147_bus_reset(struct scsi_cmnd *cmd)
-{
-	/* FIXME perform bus-specific reset */
-
-	/* FIXME 2: kill this function, and let midlayer fallback to
-	   the same result, calling wd33c93_host_reset() */
-
-	spin_lock_irq(cmd->device->host->host_lock);
-	wd33c93_host_reset(cmd);
-	spin_unlock_irq(cmd->device->host->host_lock);
-
-	return SUCCESS;
-}
-
-
 static struct scsi_host_template driver_template = {
 	.proc_name		= "MVME147",
 	.name			= "MVME147 built-in SCSI",
@@ -143,7 +128,6 @@ static int mvme147_bus_reset(struct scsi_cmnd *cmd)
 	.release		= mvme147_release,
 	.queuecommand		= wd33c93_queuecommand,
 	.eh_abort_handler	= wd33c93_abort,
-	.eh_bus_reset_handler	= mvme147_bus_reset,
 	.eh_host_reset_handler	= wd33c93_host_reset,
 	.can_queue		= CAN_QUEUE,
 	.this_id		= 7,
diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index 80cfa93..5ed696d 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -192,20 +192,6 @@ static inline void init_hpc_chain(struct ip22_hostdata *hdata)
 	hcp->desc.pnext = hdata->dma;
 }
 
-static int sgiwd93_bus_reset(struct scsi_cmnd *cmd)
-{
-	/* FIXME perform bus-specific reset */
-
-	/* FIXME 2: kill this function, and let midlayer fallback
-	   to the same result, calling wd33c93_host_reset() */
-
-	spin_lock_irq(cmd->device->host->host_lock);
-	wd33c93_host_reset(cmd);
-	spin_unlock_irq(cmd->device->host->host_lock);
-
-	return SUCCESS;
-}
-
 /*
  * Kludge alert - the SCSI code calls the abort and reset method with int
  * arguments not with pointers.  So this is going to blow up beautyfully
@@ -217,7 +203,6 @@ static int sgiwd93_bus_reset(struct scsi_cmnd *cmd)
 	.name			= "SGI WD93",
 	.queuecommand		= wd33c93_queuecommand,
 	.eh_abort_handler	= wd33c93_abort,
-	.eh_bus_reset_handler	= sgiwd93_bus_reset,
 	.eh_host_reset_handler	= wd33c93_host_reset,
 	.can_queue		= 16,
 	.this_id		= 7,
diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index 9e09da4..74be04f 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -1578,6 +1578,7 @@
 	int i;
 
 	instance = SCpnt->device->host;
+	spin_lock_irq(instance->host_lock);
 	hostdata = (struct WD33C93_hostdata *) instance->hostdata;
 
 	printk("scsi%d: reset. ", instance->host_no);
@@ -1603,6 +1604,7 @@
 	reset_wd33c93(instance);
 	SCpnt->result = DID_RESET << 16;
 	enable_irq(instance->irq);
+	spin_unlock_irq(instance->host_lock);
 	return SUCCESS;
 }
 
-- 
1.8.5.6
