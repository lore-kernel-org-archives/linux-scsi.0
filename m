From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] update cciss in 2.5 to use modern scsi APIs
Date: Mon, 24 Feb 2003 21:43:00 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030224214300.B20662@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Charles White <arrays@compaq.com>
Cc: linux-scsi@vger.kernel.org

Using scsi_add_host/scsi_Remove_host gets rid of lots of cruft.
The driver would still benefit from passing around objects instead of
indices..


--- 1.10/drivers/block/cciss_scsi.c	Tue Feb 18 02:02:24 2003
+++ edited/drivers/block/cciss_scsi.c	Mon Feb 24 20:36:06 2003
@@ -20,7 +20,6 @@
  *    
  *    Author: Stephen M. Cameron
  */
-#ifdef CONFIG_CISS_SCSI_TAPE
 
 /* Here we have code to present the driver as a scsi driver 
    as it is simultaneously presented as a block driver.  The 
@@ -50,8 +49,6 @@
 	unsigned char *scsi3addr );
 
 
-int __init cciss_scsi_detect(Scsi_Host_Template *tpnt);
-int cciss_scsi_release(struct Scsi_Host *sh);
 const char *cciss_scsi_info(struct Scsi_Host *sa);
 
 int cciss_scsi_proc_info(
@@ -83,22 +80,17 @@
 	{ .name = "cciss7", .ndevices = 0 },
 };
 
-/* We need one Scsi_Host_Template *per controller* instead of 
-   the usual one Scsi_Host_Template per controller *type*. This 
-   is so PCI hot plug could have a remote possibility of still
-   working even with the SCSI system.  It's so 
-   scsi_unregister_host will differentiate the controllers. 
-   When register_scsi_module is called, each host template is 
-   customized (name change) in cciss_register_scsi() (that's
-   called from cciss_engage_scsi, called from
-   cciss.c:cciss_proc_write(), on "engage scsi" being received
-   from user space.) */
-
-static 
-Scsi_Host_Template driver_template[MAX_CTLR] =
-{
-	CCISS_SCSI, CCISS_SCSI, CCISS_SCSI, CCISS_SCSI,
-	CCISS_SCSI, CCISS_SCSI, CCISS_SCSI, CCISS_SCSI,
+static Scsi_Host_Template cciss_driver_template = {
+	.module			= THIS_MODULE,
+	.name			= "cciss",
+	.proc_name		= "cciss",
+	.proc_info		= cciss_scsi_proc_info,
+	.queuecommand		= cciss_scsi_queue_command,
+	.can_queue		= SCSI_CCISS_CAN_QUEUE,
+	.this_id		= 7,
+	.sg_tablesize		= MAXSGENTRIES,
+	.cmd_per_lun		= 1,
+	.use_clustering		= DISABLE_CLUSTERING,
 };
 
 #pragma pack(1)
@@ -699,60 +691,31 @@
 	scsi_cmd_free(ctlr, cp);
 }
 
-/* cciss_scsi_detect is called from the scsi mid layer.  
-   The scsi mid layer (scsi_register_host) is
-   called from cciss.c:cciss_init_one().  */
-
-int __init 
-cciss_scsi_detect(Scsi_Host_Template *tpnt)
+static int __init 
+cciss_scsi_detect(int ctlr)
 {
-	int i;
 	struct Scsi_Host *sh;
 
-	/* Tell the kernel we want to be a SCSI driver... */
-	sh = scsi_register(tpnt, sizeof(struct ctlr_info *));
-	if (sh == NULL) return 0;
+	sh = scsi_register(&cciss_driver_template, sizeof(struct ctlr_info *));
+	if (sh == NULL)
+		return 0;
 
 	sh->io_port = 0;	// good enough?  FIXME, 
 	sh->n_io_port = 0;	// I don't think we use these two...
 
 	sh->this_id = SELF_SCSI_ID;  
 
-	/* This is a bit kludgey, using the adapter name to figure out */
-	/* which scsi host template we've got, won't scale beyond 9 ctlrs. */
-	i = tpnt->name[5] - '0';
-
-#	if MAX_CTLR > 9
-#		error "cciss_scsi.c: MAX_CTLR > 9, code maintenance needed."
-#	endif	
-
-	if (i<0 || i>=MAX_CTLR || hba[i] == NULL) {
-		/* we didn't find ourself... we shouldn't get here. */
-		printk("cciss_scsi_detect: could not find ourself in hba[]\n");
-		return 0;
-	}
-
 	((struct cciss_scsi_adapter_data_t *) 
-		hba[i]->scsi_ctlr)->scsi_host = (void *) sh;
-	sh->hostdata[0] = (unsigned long) hba[i];
-	sh->irq = hba[i]->intr;
+		hba[ctlr]->scsi_ctlr)->scsi_host = (void *) sh;
+	sh->hostdata[0] = (unsigned long) hba[ctlr];
+	sh->irq = hba[ctlr]->intr;
 	sh->unique_id = sh->irq;
-	scsi_set_device(sh, &hba[i]->pdev->dev);
+	scsi_add_host(sh, &hba[ctlr]->pdev->dev);
 
-	return 1;	/* Say we have 1 scsi adapter, this will be */
-			/* called multiple times, once for each adapter */
-			/* from cciss.c:cciss_init_one().  We do it this */
-			/* way for PCI-hot plug reasons. (we don't know how */
-			/* many adapters we have total, so we say we have */
-			/* 1, each of a unique type.) */
+	return 1;
 }
 
 static void __exit cleanup_cciss_module(void);
-int
-cciss_scsi_release(struct Scsi_Host *sh)
-{
-	return 0;
-}
 
 static void
 cciss_unmap_one(struct pci_dev *pdev,
@@ -1381,33 +1344,6 @@
 }
 
 static void 
-init_driver_template(int ctlr)
-{
-	memset(&driver_template[ctlr], 0, sizeof(driver_template[ctlr]));
-	driver_template[ctlr].name = ccissscsi[ctlr].name;
-	driver_template[ctlr].proc_name = ccissscsi[ctlr].name;
-	driver_template[ctlr].detect = cciss_scsi_detect;
-	driver_template[ctlr].release = cciss_scsi_release;
-	driver_template[ctlr].proc_info = cciss_scsi_proc_info;
-	driver_template[ctlr].queuecommand = cciss_scsi_queue_command;
-	driver_template[ctlr].eh_abort_handler = NULL;
-	driver_template[ctlr].eh_device_reset_handler = NULL;
-	driver_template[ctlr].can_queue = SCSI_CCISS_CAN_QUEUE;
-	driver_template[ctlr].this_id = 7;
-	driver_template[ctlr].sg_tablesize = MAXSGENTRIES;
-	driver_template[ctlr].cmd_per_lun = 1;
-	driver_template[ctlr].use_clustering = DISABLE_CLUSTERING;
-	driver_template[ctlr].module = THIS_MODULE;
-
-	/* set scsi_host to NULL so our detect routine will 
-	   find us on register */
-
-	((struct cciss_scsi_adapter_data_t *) 
-		hba[ctlr]->scsi_ctlr)->scsi_host = NULL;
-
-}
-
-static void 
 cciss_unregister_scsi(int ctlr)
 {
 	struct cciss_scsi_adapter_data_t *sa;
@@ -1421,15 +1357,18 @@
 	stk = &sa->cmd_stack; 
 
 	/* if we weren't ever actually registered, don't unregister */ 
-	if (((struct cciss_scsi_adapter_data_t *) 
-		hba[ctlr]->scsi_ctlr)->registered) {
+	if (sa->registered) {
 		spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
-		scsi_unregister_host(&driver_template[ctlr]);
+		scsi_remove_host(sa->scsi_host);
+		scsi_unregister(sa->scsi_host);
 		spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
 	}
-	init_driver_template(ctlr);
+
+	/* set scsi_host to NULL so our detect routine will 
+	   find us on register */
+	sa->scsi_host = NULL;
 	scsi_cmd_stack_free(ctlr);
-	kfree(hba[ctlr]->scsi_ctlr);
+	kfree(sa);
 	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
 }
 
@@ -1439,9 +1378,6 @@
 	unsigned long flags;
 
 	CPQ_TAPE_LOCK(ctlr, flags);
-	driver_template[ctlr].name = ccissscsi[ctlr].name;
-	driver_template[ctlr].proc_name = ccissscsi[ctlr].name;
-	driver_template[ctlr].module = THIS_MODULE;;
 
 	/* Since this is really a block driver, the SCSI core may not be 
 	   initialized at init time, in which case, calling scsi_register_host
@@ -1453,7 +1389,7 @@
 		((struct cciss_scsi_adapter_data_t *) 
 			hba[ctlr]->scsi_ctlr)->registered = 1;
 		CPQ_TAPE_UNLOCK(ctlr, flags);
-		return scsi_register_host(&driver_template[ctlr]);
+		return cciss_scsi_detect(ctlr);
 	}
 	CPQ_TAPE_UNLOCK(ctlr, flags);
 	printk(KERN_INFO 
@@ -1500,14 +1436,3 @@
 	CPQ_TAPE_UNLOCK(ctlr, flags);
 	*pos += size; *len += size;
 }
-
-#else /* no CONFIG_CISS_SCSI_TAPE */
-
-/* If no tape support, then these become defined out of existence */
-
-#define cciss_scsi_setup(cntl_num)
-#define cciss_unregister_scsi(ctlr)
-#define cciss_register_scsi(ctlr)
-#define cciss_proc_tape_report(ctlr, buffer, pos, len)
-
-#endif /* CONFIG_CISS_SCSI_TAPE */
===== drivers/block/cciss_scsi.h 1.2 vs edited =====
--- 1.2/drivers/block/cciss_scsi.h	Fri Oct 25 02:29:19 2002
+++ edited/drivers/block/cciss_scsi.h	Mon Feb 24 20:29:38 2003
@@ -38,23 +38,6 @@
 
 #define SCSI_CCISS_CAN_QUEUE 2
 
-/* this notation works fine for static initializations (as is the usual
-   case for linux scsi drivers), but not so well for dynamic settings,
-   so, if you change this, you also have to change cciss_unregister_scsi()
-   in cciss_scsi.c  */
-#define CCISS_SCSI {    \
-	name:           	"",				\
-	detect:         	cciss_scsi_detect,		\
-	release:        	cciss_scsi_release,		\
-	proc_info:           	cciss_scsi_proc_info,		\
-	queuecommand:   	cciss_scsi_queue_command,	\
-	can_queue:      	SCSI_CCISS_CAN_QUEUE,		\
-	this_id:        	7,				\
-	sg_tablesize:   	MAXSGENTRIES, 			\
-	cmd_per_lun:		1,				\
-	use_clustering:		DISABLE_CLUSTERING,\
-} 
-
 /* 
 	info:           	cciss_scsi_info,		\
 
