From: Matthew Wilcox <matthew@wil.cx>
Subject: [RFC 2/2] sym53c8xx: alloc_cmnd
Date: Fri, 19 Oct 2007 12:34:04 -0600
Message-ID: <20071019183404.GD30807@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33603 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764959AbXJSSeF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2007 14:34:05 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This demonstration patch converts the sym53c8xx driver to use alloc_cmnd
/ destroy_cmnd.  It's on top of mainline, not the latest version
posted a couple of weeks ago.  I've tried to keep it simple, but a
few cleanups were necessary to make it compile.  Speaking of which,
it's only compile-tested; I'm travelling and don't feel like possibly
crashing my test machine at home that doesn't have remote power.

The observant will notice that there's one slab per driver, rather than
one per host.  A more thorough conversion would perhaps use a dma_pool
specialised for each host, but that would require ripping out sym_malloc.c
and isn't really suitable for a demonstration patch.  I hope that the
actively maintained drivers will receive that level of care and attention.

Vehement-opposition-to-merge-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/scsi/sym53c8xx_2/sym53c8xx.h b/drivers/scsi/sym53c8xx_2/sym53c8xx.h
index 7519728..773ada4 100644
--- a/drivers/scsi/sym53c8xx_2/sym53c8xx.h
+++ b/drivers/scsi/sym53c8xx_2/sym53c8xx.h
@@ -213,4 +213,16 @@ extern unsigned int sym_debug_flags;
  */
 #define SYM_SETUP_RESIDUAL_SUPPORT 1
 
+struct sym_cmnd {
+	struct scsi_cmnd cmnd;
+	dma_addr_t	data_mapping;
+	unsigned char	data_mapped;
+	unsigned char	to_do;			/* For error handling */
+	void (*old_done)(struct scsi_cmnd *);	/* For error handling */
+	struct completion *eh_done;		/* For error handling */
+	struct sym_ccb *cp;
+};
+
+#define sym_cmd(cmd)	container_of(cmd, struct sym_cmnd, cmnd)
+
 #endif /* SYM53C8XX_H */
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 3db2232..0dbc50c 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -42,6 +42,7 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_tcq.h>
@@ -130,26 +131,14 @@ static void sym2_setup_params(void)
 
 static struct scsi_transport_template *sym2_transport_template = NULL;
 
-/*
- *  Driver private area in the SCSI command structure.
- */
-struct sym_ucmd {		/* Override the SCSI pointer structure */
-	dma_addr_t	data_mapping;
-	unsigned char	data_mapped;
-	unsigned char	to_do;			/* For error handling */
-	void (*old_done)(struct scsi_cmnd *);	/* For error handling */
-	struct completion *eh_done;		/* For error handling */
-};
-
-#define SYM_UCMD_PTR(cmd)  ((struct sym_ucmd *)(&(cmd)->SCp))
 #define SYM_SOFTC_PTR(cmd) sym_get_hcb(cmd->device->host)
 
 static void __unmap_scsi_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
 {
-	if (SYM_UCMD_PTR(cmd)->data_mapped)
+	if (sym_cmd(cmd)->data_mapped)
 		scsi_dma_unmap(cmd);
 
-	SYM_UCMD_PTR(cmd)->data_mapped = 0;
+	sym_cmd(cmd)->data_mapped = 0;
 }
 
 static int __map_scsi_sg_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
@@ -158,8 +147,8 @@ static int __map_scsi_sg_data(struct pci_dev *pdev, struct scsi_cmnd *cmd)
 
 	use_sg = scsi_dma_map(cmd);
 	if (use_sg > 0) {
-		SYM_UCMD_PTR(cmd)->data_mapped  = 2;
-		SYM_UCMD_PTR(cmd)->data_mapping = use_sg;
+		sym_cmd(cmd)->data_mapped  = 2;
+		sym_cmd(cmd)->data_mapping = use_sg;
 	}
 
 	return use_sg;
@@ -342,9 +331,9 @@ static int sym_scatter(struct sym_hcb *np, struct sym_ccb *cp, struct scsi_cmnd
 /*
  *  Queue a SCSI command.
  */
-static int sym_queue_command(struct sym_hcb *np, struct scsi_cmnd *cmd)
+static int sym_queue_command(struct sym_hcb *np, struct sym_cmnd *cmd)
 {
-	struct scsi_device *sdev = cmd->device;
+	struct scsi_device *sdev = cmd->cmnd.device;
 	struct sym_tcb *tp;
 	struct sym_lcb *lp;
 	struct sym_ccb *cp;
@@ -355,7 +344,7 @@ static int sym_queue_command(struct sym_hcb *np, struct scsi_cmnd *cmd)
 	 *  go outside our tables.
 	 */
 	if (sdev->id == np->myaddr) {
-		sym_xpt_done2(np, cmd, DID_NO_CONNECT);
+		sym_xpt_done2(np, &cmd->cmnd, DID_NO_CONNECT);
 		return 0;
 	}
 
@@ -376,10 +365,44 @@ static int sym_queue_command(struct sym_hcb *np, struct scsi_cmnd *cmd)
 	cp = sym_get_ccb(np, cmd, order);
 	if (!cp)
 		return 1;	/* Means resource shortage */
-	sym_queue_scsiio(np, cmd, cp);
+	sym_queue_scsiio(np, &cmd->cmnd, cp);
 	return 0;
 }
 
+static struct kmem_cache *sym_cmnd_slab;
+
+static struct scsi_cmnd *
+sym53c8xx_alloc_cmnd(struct Scsi_Host *shost, gfp_t gfp)
+{
+	struct sym_hcb *np = sym_get_hcb(shost);
+	SYM_QUEHEAD *qp;
+	struct sym_ccb *cp;
+	struct sym_cmnd *cmd = kmem_cache_alloc(sym_cmnd_slab, gfp);
+	if (!cmd)
+		return NULL;
+	memset(cmd, 0, sizeof(*cmd));
+
+	if (sym_que_empty(&np->free_ccbq))
+		sym_alloc_ccb(np);
+	qp = sym_remque_head(&np->free_ccbq);
+	if (!qp)
+		goto out;
+	cp = sym_que_entry(qp, struct sym_ccb, link_ccbq);
+	cp->cmd = &cmd->cmnd;
+	cmd->cp = cp;
+	return &cmd->cmnd;
+
+ out:
+	kmem_cache_free(sym_cmnd_slab, cmd);
+	return NULL;
+}
+
+static void sym53c8xx_destroy_cmnd(struct scsi_cmnd *cmnd)
+{
+	/* The ccb was already freed, but freeing it could be moved to here */
+	kmem_cache_free(sym_cmnd_slab, sym_cmd(cmnd));
+}
+
 /*
  *  Setup buffers and pointers that address the CDB.
  */
@@ -561,11 +584,9 @@ static int sym53c8xx_queue_command(struct scsi_cmnd *cmd,
 					void (*done)(struct scsi_cmnd *))
 {
 	struct sym_hcb *np = SYM_SOFTC_PTR(cmd);
-	struct sym_ucmd *ucp = SYM_UCMD_PTR(cmd);
 	int sts = 0;
 
 	cmd->scsi_done     = done;
-	memset(ucp, 0, sizeof(*ucp));
 
 	/*
 	 *  Shorten our settle_time if needed for 
@@ -582,7 +603,7 @@ static int sym53c8xx_queue_command(struct scsi_cmnd *cmd,
 	if (np->s.settle_time_valid)
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-	sts = sym_queue_command(np, cmd);
+	sts = sym_queue_command(np, sym_cmd(cmd));
 	if (sts)
 		return SCSI_MLQUEUE_HOST_BUSY;
 	return 0;
@@ -640,11 +661,8 @@ static void sym53c8xx_timer(unsigned long npref)
  */
 static void sym_eh_done(struct scsi_cmnd *cmd)
 {
-	struct sym_ucmd *ucmd = SYM_UCMD_PTR(cmd);
-	BUILD_BUG_ON(sizeof(struct scsi_pointer) < sizeof(struct sym_ucmd));
-
+	struct sym_cmnd *ucmd = sym_cmd(cmd);
 	cmd->scsi_done = ucmd->old_done;
-
 	if (ucmd->to_do == SYM_EH_DO_WAIT)
 		complete(ucmd->eh_done);
 }
@@ -656,7 +674,7 @@ static void sym_eh_done(struct scsi_cmnd *cmd)
 static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 {
 	struct sym_hcb *np = SYM_SOFTC_PTR(cmd);
-	struct sym_ucmd *ucmd = SYM_UCMD_PTR(cmd);
+	struct sym_cmnd *ucmd = sym_cmd(cmd);
 	struct Scsi_Host *host = cmd->device->host;
 	SYM_QUEHEAD *qp;
 	int to_do = SYM_EH_DO_IGNORE;
@@ -1802,6 +1820,8 @@ static struct scsi_host_template sym2_template = {
 	.slave_alloc		= sym53c8xx_slave_alloc,
 	.slave_configure	= sym53c8xx_slave_configure,
 	.slave_destroy		= sym53c8xx_slave_destroy,
+	.alloc_cmnd		= sym53c8xx_alloc_cmnd,
+	.destroy_cmnd		= sym53c8xx_destroy_cmnd,
 	.eh_abort_handler	= sym53c8xx_eh_abort_handler,
 	.eh_device_reset_handler = sym53c8xx_eh_device_reset_handler,
 	.eh_bus_reset_handler	= sym53c8xx_eh_bus_reset_handler,
@@ -2065,9 +2085,21 @@ static int __init sym2_init(void)
 	if (!sym2_transport_template)
 		return -ENODEV;
 
+	sym_cmnd_slab = kmem_cache_create("sym_scsi_cmnd",
+						sizeof(struct sym_cmnd), 0,
+						SLAB_HWCACHE_ALIGN, NULL);
+	error = -ENOMEM;
+	if (!sym_cmnd_slab)
+		goto release_transport;
+
 	error = pci_register_driver(&sym2_driver);
-	if (error)
-		spi_release_transport(sym2_transport_template);
+	if (!error)
+		return 0;
+
+	kmem_cache_destroy(sym_cmnd_slab);
+ release_transport:
+	spi_release_transport(sym2_transport_template);
+
 	return error;
 }
 
@@ -2075,6 +2107,7 @@ static void __exit sym2_exit(void)
 {
 	pci_unregister_driver(&sym2_driver);
 	spi_release_transport(sym2_transport_template);
+	kmem_cache_destroy(sym_cmnd_slab);
 }
 
 module_init(sym2_init);
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.h b/drivers/scsi/sym53c8xx_2/sym_glue.h
index 0f097ba..69837a2 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.h
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.h
@@ -261,7 +261,7 @@ static __inline void sym_set_cam_result_ok(struct sym_ccb *cp, struct scsi_cmnd
 void sym_set_cam_result_error(struct sym_hcb *np, struct sym_ccb *cp, int resid);
 
 void sym_xpt_done(struct sym_hcb *np, struct scsi_cmnd *ccb);
-#define sym_print_addr(cmd, arg...) dev_info(&cmd->device->sdev_gendev , ## arg)
+#define sym_print_addr(cmd, arg...) dev_info(&(cmd)->device->sdev_gendev , ## arg)
 void sym_xpt_async_bus_reset(struct sym_hcb *np);
 void sym_xpt_async_sent_bdr(struct sym_hcb *np, int target);
 int  sym_setup_data_and_start (struct sym_hcb *np, struct scsi_cmnd *csio, struct sym_ccb *cp);
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 21cd4c7..6ef7e0a 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -53,7 +53,6 @@
  */
 static void sym_int_ma (struct sym_hcb *np);
 static void sym_int_sir (struct sym_hcb *np);
-static struct sym_ccb *sym_alloc_ccb(struct sym_hcb *np);
 static struct sym_ccb *sym_ccb_from_dsa(struct sym_hcb *np, u32 dsa);
 static void sym_alloc_lcb_tags (struct sym_hcb *np, u_char tn, u_char ln);
 static void sym_complete_error (struct sym_hcb *np, struct sym_ccb *cp);
@@ -4578,25 +4577,14 @@ out_stuck:
 /*
  *  Acquire a control block
  */
-struct sym_ccb *sym_get_ccb (struct sym_hcb *np, struct scsi_cmnd *cmd, u_char tag_order)
+struct sym_ccb *sym_get_ccb (struct sym_hcb *np, struct sym_cmnd *cmd, u_char tag_order)
 {
-	u_char tn = cmd->device->id;
-	u_char ln = cmd->device->lun;
+	u_char tn = cmd->cmnd.device->id;
+	u_char ln = cmd->cmnd.device->lun;
 	struct sym_tcb *tp = &np->target[tn];
 	struct sym_lcb *lp = sym_lp(tp, ln);
 	u_short tag = NO_TAG;
-	SYM_QUEHEAD *qp;
-	struct sym_ccb *cp = NULL;
-
-	/*
-	 *  Look for a free CCB
-	 */
-	if (sym_que_empty(&np->free_ccbq))
-		sym_alloc_ccb(np);
-	qp = sym_remque_head(&np->free_ccbq);
-	if (!qp)
-		goto out;
-	cp = sym_que_entry(qp, struct sym_ccb, link_ccbq);
+	struct sym_ccb *cp = cmd->cp;
 
 	{
 		/*
@@ -4692,10 +4680,9 @@ struct sym_ccb *sym_get_ccb (struct sym_hcb *np, struct scsi_cmnd *cmd, u_char t
 	cp->lun    = ln;
 
 	if (DEBUG_FLAGS & DEBUG_TAGS) {
-		sym_print_addr(cmd, "ccb @%p using tag %d.\n", cp, tag);
+		sym_print_addr(&cmd->cmnd, "ccb @%p using tag %d.\n", cp, tag);
 	}
 
-out:
 	return cp;
 out_free:
 	sym_insque_head(&cp->link_ccbq, &np->free_ccbq);
@@ -4797,7 +4784,7 @@ void sym_free_ccb (struct sym_hcb *np, struct sym_ccb *cp)
 /*
  *  Allocate a CCB from memory and initialize its fixed part.
  */
-static struct sym_ccb *sym_alloc_ccb(struct sym_hcb *np)
+struct sym_ccb *sym_alloc_ccb(struct sym_hcb *np)
 {
 	struct sym_ccb *cp = NULL;
 	int hcode;
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index 79ab6a1..b9300b5 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -1055,7 +1055,8 @@ void sym_put_start_queue(struct sym_hcb *np, struct sym_ccb *cp);
 void sym_start_up(struct sym_hcb *np, int reason);
 void sym_interrupt(struct sym_hcb *np);
 int sym_clear_tasks(struct sym_hcb *np, int cam_status, int target, int lun, int task);
-struct sym_ccb *sym_get_ccb(struct sym_hcb *np, struct scsi_cmnd *cmd, u_char tag_order);
+struct sym_ccb *sym_get_ccb(struct sym_hcb *np, struct sym_cmnd *cmd, u_char tag_order);
+struct sym_ccb *sym_alloc_ccb(struct sym_hcb *np);
 void sym_free_ccb(struct sym_hcb *np, struct sym_ccb *cp);
 struct sym_lcb *sym_alloc_lcb(struct sym_hcb *np, u_char tn, u_char ln);
 int sym_queue_scsiio(struct sym_hcb *np, struct scsi_cmnd *csio, struct sym_ccb *cp);

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
