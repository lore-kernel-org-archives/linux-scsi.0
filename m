From: akpm@linux-foundation.org
Subject: [patch 28/30] cleanup variable usage in mesh interrupt handler
Date: Fri, 16 Feb 2007 01:46:46 -0800
Message-ID: <200702160946.l1G9klAb026706@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36891 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423516AbXBPJq7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Feb 2007 04:46:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, olaf@aepfle.de

From: Olaf Hering <olaf@aepfle.de>

_ convert void* to struct mesh_state*

- remove unused irq argument from mesh_interrupt()

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mesh.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/mesh.c~cleanup-variable-usage-in-mesh-interrupt-handler drivers/scsi/mesh.c
--- a/drivers/scsi/mesh.c~cleanup-variable-usage-in-mesh-interrupt-handler
+++ a/drivers/scsi/mesh.c
@@ -185,7 +185,7 @@ struct mesh_state {
  * Driver is too messy, we need a few prototypes...
  */
 static void mesh_done(struct mesh_state *ms, int start_next);
-static void mesh_interrupt(int irq, void *dev_id);
+static void mesh_interrupt(struct mesh_state *ms);
 static void cmd_complete(struct mesh_state *ms);
 static void set_dma_cmds(struct mesh_state *ms, struct scsi_cmnd *cmd);
 static void halt_dma(struct mesh_state *ms);
@@ -466,7 +466,7 @@ static void mesh_start_cmd(struct mesh_s
 				dlog(ms, "intr b4 arb, intr/exc/err/fc=%.8x",
 				     MKWORD(mr->interrupt, mr->exception,
 					    mr->error, mr->fifo_count));
-				mesh_interrupt(0, (void *)ms);
+				mesh_interrupt(ms);
 				if (ms->phase != arbitrating)
 					return;
 			}
@@ -504,7 +504,7 @@ static void mesh_start_cmd(struct mesh_s
 		dlog(ms, "intr after disresel, intr/exc/err/fc=%.8x",
 		     MKWORD(mr->interrupt, mr->exception,
 			    mr->error, mr->fifo_count));
-		mesh_interrupt(0, (void *)ms);
+		mesh_interrupt(ms);
 		if (ms->phase != arbitrating)
 			return;
 		dlog(ms, "after intr after disresel, intr/exc/err/fc=%.8x",
@@ -1018,10 +1018,11 @@ static void handle_reset(struct mesh_sta
 static irqreturn_t do_mesh_interrupt(int irq, void *dev_id)
 {
 	unsigned long flags;
-	struct Scsi_Host *dev = ((struct mesh_state *)dev_id)->host;
+	struct mesh_state *ms = dev_id;
+	struct Scsi_Host *dev = ms->host;
 	
 	spin_lock_irqsave(dev->host_lock, flags);
-	mesh_interrupt(irq, dev_id);
+	mesh_interrupt(ms);
 	spin_unlock_irqrestore(dev->host_lock, flags);
 	return IRQ_HANDLED;
 }
@@ -1661,9 +1662,8 @@ static int mesh_queue(struct scsi_cmnd *
  * handler (do_mesh_interrupt) or by other functions in
  * exceptional circumstances
  */
-static void mesh_interrupt(int irq, void *dev_id)
+static void mesh_interrupt(struct mesh_state *ms)
 {
-	struct mesh_state *ms = (struct mesh_state *) dev_id;
 	volatile struct mesh_regs __iomem *mr = ms->mesh;
 	int intr;
 
_
