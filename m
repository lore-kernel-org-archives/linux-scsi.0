From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH 1/3] cciss: Fix checkpatch TRAILING_WHITESPACE
Date: Wed, 22 Feb 2017 16:49:09 +1100
Message-ID: <1487742551-10839-2-git-send-email-me@tobin.cc>
References: <1487742551-10839-1-git-send-email-me@tobin.cc>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38749 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751192AbdBVFtZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 00:49:25 -0500
In-Reply-To: <1487742551-10839-1-git-send-email-me@tobin.cc>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, "Tobin C. Harding" <me@tobin.cc>

Checkpatch emits 85 trailing whitespace warnings.

Remove trailing whitespace.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 drivers/block/cciss_scsi.c | 170 ++++++++++++++++++++++-----------------------
 1 file changed, 85 insertions(+), 85 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index a18de9d..2b8cfd4 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -17,15 +17,15 @@
  *    02111-1307, USA.
  *
  *    Questions/Comments/Bugfixes to iss_storagedev@hp.com
- *    
+ *
  *    Author: Stephen M. Cameron
  */
 #ifdef CONFIG_CISS_SCSI_TAPE
 
-/* Here we have code to present the driver as a scsi driver 
-   as it is simultaneously presented as a block driver.  The 
+/* Here we have code to present the driver as a scsi driver
+   as it is simultaneously presented as a block driver.  The
    reason for doing this is to allow access to SCSI tape drives
-   through the array controller.  Note in particular, neither 
+   through the array controller.  Note in particular, neither
    physical nor logical disks are presented through the scsi layer. */
 
 #include <linux/timer.h>
@@ -37,7 +37,7 @@
 
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
-#include <scsi/scsi_host.h> 
+#include <scsi/scsi_host.h>
 
 #include "cciss_scsi.h"
 
@@ -120,7 +120,7 @@ struct cciss_scsi_adapter_data_t {
 	struct cciss_scsi_cmd_stack_t cmd_stack;
 	SGDescriptor_struct **cmd_sg_list;
 	int registered;
-	spinlock_t lock; // to protect ccissscsi[ctlr]; 
+	spinlock_t lock; // to protect ccissscsi[ctlr];
 };
 
 #define CPQ_TAPE_LOCK(h, flags) spin_lock_irqsave( \
@@ -143,36 +143,36 @@ scsi_cmd_alloc(ctlr_info_t *h)
 	u64bit temp64;
 
 	sa = h->scsi_ctlr;
-	stk = &sa->cmd_stack; 
+	stk = &sa->cmd_stack;
 
-	if (stk->top < 0) 
+	if (stk->top < 0)
 		return NULL;
-	c = stk->elem[stk->top]; 	
+	c = stk->elem[stk->top];
 	/* memset(c, 0, sizeof(*c)); */
 	memset(&c->cmd, 0, sizeof(c->cmd));
 	memset(&c->Err, 0, sizeof(c->Err));
 	/* set physical addr of cmd and addr of scsi parameters */
-	c->cmd.busaddr = c->busaddr; 
+	c->cmd.busaddr = c->busaddr;
 	c->cmd.cmdindex = c->cmdindex;
-	/* (__u32) (stk->cmd_pool_handle + 
+	/* (__u32) (stk->cmd_pool_handle +
 		(sizeof(struct cciss_scsi_cmd_stack_elem_t)*stk->top)); */
 
 	temp64.val = (__u64) (c->busaddr + sizeof(CommandList_struct));
-	/* (__u64) (stk->cmd_pool_handle + 
+	/* (__u64) (stk->cmd_pool_handle +
 		(sizeof(struct cciss_scsi_cmd_stack_elem_t)*stk->top) +
 		 sizeof(CommandList_struct)); */
 	stk->top--;
 	c->cmd.ErrDesc.Addr.lower = temp64.val32.lower;
 	c->cmd.ErrDesc.Addr.upper = temp64.val32.upper;
 	c->cmd.ErrDesc.Len = sizeof(ErrorInfo_struct);
-	
+
 	c->cmd.ctlr = h->ctlr;
 	c->cmd.err_info = &c->Err;
 
 	return (CommandList_struct *) c;
 }
 
-static void 
+static void
 scsi_cmd_free(ctlr_info_t *h, CommandList_struct *c)
 {
 	/* assume only one process in here at a time, locking done by caller. */
@@ -183,7 +183,7 @@ scsi_cmd_free(ctlr_info_t *h, CommandList_struct *c)
 	struct cciss_scsi_cmd_stack_t *stk;
 
 	sa = h->scsi_ctlr;
-	stk = &sa->cmd_stack; 
+	stk = &sa->cmd_stack;
 	stk->top++;
 	if (stk->top >= stk->nelems) {
 		dev_err(&h->pdev->dev,
@@ -228,7 +228,7 @@ scsi_cmd_stack_setup(ctlr_info_t *h, struct cciss_scsi_adapter_data_t *sa)
 	}
 	for (i = 0; i < stk->nelems; i++) {
 		stk->elem[i] = &stk->pool[i];
-		stk->elem[i]->busaddr = (__u32) (stk->cmd_pool_handle + 
+		stk->elem[i]->busaddr = (__u32) (stk->cmd_pool_handle +
 			(sizeof(struct cciss_scsi_cmd_stack_elem_t) * i));
 		stk->elem[i]->cmdindex = i;
 	}
@@ -244,7 +244,7 @@ scsi_cmd_stack_free(ctlr_info_t *h)
 	size_t size;
 
 	sa = h->scsi_ctlr;
-	stk = &sa->cmd_stack; 
+	stk = &sa->cmd_stack;
 	if (stk->top != stk->nelems-1) {
 		dev_warn(&h->pdev->dev,
 			"bug: %d scsi commands are still outstanding.\n",
@@ -266,7 +266,7 @@ print_cmd(CommandList_struct *cp)
 	printk("queue:%d\n", cp->Header.ReplyQueue);
 	printk("sglist:%d\n", cp->Header.SGList);
 	printk("sgtot:%d\n", cp->Header.SGTotal);
-	printk("Tag:0x%08x/0x%08x\n", cp->Header.Tag.upper, 
+	printk("Tag:0x%08x/0x%08x\n", cp->Header.Tag.upper,
 			cp->Header.Tag.lower);
 	printk("LUN:0x%8phN\n", cp->Header.LUN.LunAddrBytes);
 	printk("CDBLen:%d\n", cp->Request.CDBLen);
@@ -275,8 +275,8 @@ print_cmd(CommandList_struct *cp)
 	printk(" Dir:%d\n",cp->Request.Type.Direction);
 	printk("Timeout:%d\n",cp->Request.Timeout);
 	printk("CDB: %16ph\n", cp->Request.CDB);
-	printk("edesc.Addr: 0x%08x/0%08x, Len  = %d\n", 
-		cp->ErrDesc.Addr.upper, cp->ErrDesc.Addr.lower, 
+	printk("edesc.Addr: 0x%08x/0%08x, Len  = %d\n",
+		cp->ErrDesc.Addr.upper, cp->ErrDesc.Addr.lower,
 			cp->ErrDesc.Len);
 	printk("sgs..........Errorinfo:\n");
 	printk("scsistatus:%d\n", cp->err_info->ScsiStatus);
@@ -289,7 +289,7 @@ print_cmd(CommandList_struct *cp)
 }
 #endif
 
-static int 
+static int
 find_bus_target_lun(ctlr_info_t *h, int *bus, int *target, int *lun)
 {
 	/* finds an unused bus, target, lun for a new device */
@@ -299,24 +299,24 @@ find_bus_target_lun(ctlr_info_t *h, int *bus, int *target, int *lun)
 
 	memset(&target_taken[0], 0, CCISS_MAX_SCSI_DEVS_PER_HBA);
 
-	target_taken[SELF_SCSI_ID] = 1;	
+	target_taken[SELF_SCSI_ID] = 1;
 	for (i = 0; i < ccissscsi[h->ctlr].ndevices; i++)
 		target_taken[ccissscsi[h->ctlr].dev[i].target] = 1;
-	
+
 	for (i = 0; i < CCISS_MAX_SCSI_DEVS_PER_HBA; i++) {
 		if (!target_taken[i]) {
 			*bus = 0; *target=i; *lun = 0; found=1;
 			break;
 		}
 	}
-	return (!found);	
+	return (!found);
 }
 struct scsi2map {
 	char scsi3addr[8];
 	int bus, target, lun;
 };
 
-static int 
+static int
 cciss_scsi_add_entry(ctlr_info_t *h, int hostno,
 		struct cciss_scsi_dev_t *device,
 		struct scsi2map *added, int *nadded)
@@ -381,8 +381,8 @@ cciss_scsi_add_entry(ctlr_info_t *h, int hostno,
 
 	ccissscsi[h->ctlr].ndevices++;
 
-	/* initially, (before registering with scsi layer) we don't 
-	   know our hostno and we don't want to print anything first 
+	/* initially, (before registering with scsi layer) we don't
+	   know our hostno and we don't want to print anything first
 	   time anyway (the scsi layer's inquiries will show that info) */
 	if (hostno != -1)
 		dev_info(&h->pdev->dev, "%s device c%db%dt%dl%d added.\n",
@@ -467,7 +467,7 @@ adjust_cciss_scsi_table(ctlr_info_t *h, int hostno,
 	/* sd contains scsi3 addresses and devtypes, but
 	   bus target and lun are not filled in.  This funciton
 	   takes what's in sd to be the current and adjusts
-	   ccissscsi[] to be in line with what's in sd. */ 
+	   ccissscsi[] to be in line with what's in sd. */
 
 	int i,j, found, changes=0;
 	struct cciss_scsi_dev_t *csd;
@@ -492,7 +492,7 @@ adjust_cciss_scsi_table(ctlr_info_t *h, int hostno,
 	if (hostno != -1)  /* if it's not the first time... */
 		sh = h->scsi_ctlr->scsi_host;
 
-	/* find any devices in ccissscsi[] that are not in 
+	/* find any devices in ccissscsi[] that are not in
 	   sd[] and remove them from ccissscsi[] */
 
 	i = 0;
@@ -512,7 +512,7 @@ adjust_cciss_scsi_table(ctlr_info_t *h, int hostno,
 			}
 		}
 
-		if (found == 0) { /* device no longer present. */ 
+		if (found == 0) { /* device no longer present. */
 			changes++;
 			cciss_scsi_remove_entry(h, hostno, i,
 				removed, &nremoved);
@@ -641,14 +641,14 @@ lookup_scsi3addr(ctlr_info_t *h, int bus, int target, int lun, char *scsi3addr)
 	return -1;
 }
 
-static void 
+static void
 cciss_scsi_setup(ctlr_info_t *h)
 {
 	struct cciss_scsi_adapter_data_t * shba;
 
 	ccissscsi[h->ctlr].ndevices = 0;
 	shba = (struct cciss_scsi_adapter_data_t *)
-		kmalloc(sizeof(*shba), GFP_KERNEL);	
+		kmalloc(sizeof(*shba), GFP_KERNEL);
 	if (shba == NULL)
 		return;
 	shba->scsi_host = NULL;
@@ -693,20 +693,20 @@ static void complete_scsi_command(CommandList_struct *c, int timeout,
 
 	/* copy the sense data whether we need to or not. */
 
-	memcpy(cmd->sense_buffer, ei->SenseInfo, 
+	memcpy(cmd->sense_buffer, ei->SenseInfo,
 		ei->SenseLen > SCSI_SENSE_BUFFERSIZE ?
-			SCSI_SENSE_BUFFERSIZE : 
+			SCSI_SENSE_BUFFERSIZE :
 			ei->SenseLen);
 	scsi_set_resid(cmd, ei->ResidualCnt);
 
-	if(ei->CommandStatus != 0) 
-	{ /* an error has occurred */ 
+	if(ei->CommandStatus != 0)
+	{ /* an error has occurred */
 		switch(ei->CommandStatus)
 		{
 			case CMD_TARGET_STATUS:
 				/* Pass it up to the upper layers... */
 				if (!ei->ScsiStatus) {
-					
+
 	/* Ordinarily, this case should never happen, but there is a bug
 	   in some released firmware revisions that allows it to happen
 	   if, for example, a 4100 backplane loses power and the tape
@@ -731,7 +731,7 @@ static void complete_scsi_command(CommandList_struct *c, int timeout,
 				print_cmd(c);
 				 */
      /* We get CMD_INVALID if you address a non-existent tape drive instead
-	of a selection timeout (no response).  You will see this if you yank 
+	of a selection timeout (no response).  You will see this if you yank
 	out a tape drive, then try to access it. This is kind of a shame
 	because it means that any other CMD_INVALID (e.g. driver bug) will
 	get interpreted as a missing target. */
@@ -780,7 +780,7 @@ static void complete_scsi_command(CommandList_struct *c, int timeout,
 				cmd->result = DID_ERROR << 16;
 				dev_warn(&h->pdev->dev,
 					"%p returned unknown status %x\n", c,
-						ei->CommandStatus); 
+						ei->CommandStatus);
 		}
 	}
 	cmd->scsi_done(cmd);
@@ -796,15 +796,15 @@ cciss_scsi_detect(ctlr_info_t *h)
 	sh = scsi_host_alloc(&cciss_driver_template, sizeof(struct ctlr_info *));
 	if (sh == NULL)
 		goto fail;
-	sh->io_port = 0;	// good enough?  FIXME, 
+	sh->io_port = 0;	// good enough?  FIXME,
 	sh->n_io_port = 0;	// I don't think we use these two...
-	sh->this_id = SELF_SCSI_ID;  
+	sh->this_id = SELF_SCSI_ID;
 	sh->can_queue = cciss_tape_cmds;
 	sh->sg_tablesize = h->maxsgentries;
 	sh->max_cmd_len = MAX_COMMAND_SIZE;
 	sh->max_sectors = h->cciss_max_sectors;
 
-	((struct cciss_scsi_adapter_data_t *) 
+	((struct cciss_scsi_adapter_data_t *)
 		h->scsi_ctlr)->scsi_host = sh;
 	sh->hostdata[0] = (unsigned long) h;
 	sh->irq = h->intr[SIMPLE_MODE_INT];
@@ -856,7 +856,7 @@ cciss_map_one(struct pci_dev *pdev,
 static int
 cciss_scsi_do_simple_cmd(ctlr_info_t *h,
 			CommandList_struct *c,
-			unsigned char *scsi3addr, 
+			unsigned char *scsi3addr,
 			unsigned char *cdb,
 			unsigned char cdblen,
 			unsigned char *buf, int bufsize,
@@ -871,7 +871,7 @@ cciss_scsi_do_simple_cmd(ctlr_info_t *h,
 	c->Header.Tag.lower = c->busaddr;  /* Use k. address of cmd as tag */
 	// Fill in the request block...
 
-	/* printk("Using scsi3addr 0x%02x%0x2%0x2%0x2%0x2%0x2%0x2%0x2\n", 
+	/* printk("Using scsi3addr 0x%02x%0x2%0x2%0x2%0x2%0x2%0x2%0x2\n",
 		scsi3addr[0], scsi3addr[1], scsi3addr[2], scsi3addr[3],
 		scsi3addr[4], scsi3addr[5], scsi3addr[6], scsi3addr[7]); */
 
@@ -885,7 +885,7 @@ cciss_scsi_do_simple_cmd(ctlr_info_t *h,
 
 	/* Fill in the SG list and do dma mapping */
 	cciss_map_one(h->pdev, c, (unsigned char *) buf,
-			bufsize, DMA_FROM_DEVICE); 
+			bufsize, DMA_FROM_DEVICE);
 
 	c->waiting = &wait;
 	enqueue_cmd_and_start_io(h, c);
@@ -896,7 +896,7 @@ cciss_scsi_do_simple_cmd(ctlr_info_t *h,
 	return(0);
 }
 
-static void 
+static void
 cciss_scsi_interpret_error(ctlr_info_t *h, CommandList_struct *c)
 {
 	ErrorInfo_struct *ei;
@@ -1005,7 +1005,7 @@ cciss_scsi_do_inquiry(ctlr_info_t *h, unsigned char *scsi3addr,
 
 	if (rc != 0) return rc; /* something went wrong */
 
-	if (ei->CommandStatus != 0 && 
+	if (ei->CommandStatus != 0 &&
 	    ei->CommandStatus != CMD_DATA_UNDERRUN) {
 		cciss_scsi_interpret_error(h, c);
 		rc = -1;
@@ -1013,7 +1013,7 @@ cciss_scsi_do_inquiry(ctlr_info_t *h, unsigned char *scsi3addr,
 	spin_lock_irqsave(&h->lock, flags);
 	scsi_cmd_free(h, c);
 	spin_unlock_irqrestore(&h->lock, flags);
-	return rc;	
+	return rc;
 }
 
 /* Get the device id from inquiry page 0x83 */
@@ -1042,7 +1042,7 @@ cciss_scsi_do_report_phys_luns(ctlr_info_t *h,
 	int rc;
 	CommandList_struct *c;
 	unsigned char cdb[12];
-	unsigned char scsi3addr[8]; 
+	unsigned char scsi3addr[8];
 	ErrorInfo_struct *ei;
 	unsigned long flags;
 
@@ -1069,14 +1069,14 @@ cciss_scsi_do_report_phys_luns(ctlr_info_t *h,
 	cdb[11] = 0;
 
 	rc = cciss_scsi_do_simple_cmd(h, c, scsi3addr,
-				cdb, 12, 
-				(unsigned char *) buf, 
+				cdb, 12,
+				(unsigned char *) buf,
 				bufsize, XFER_READ);
 
 	if (rc != 0) return rc; /* something went wrong */
 
 	ei = c->err_info;
-	if (ei->CommandStatus != 0 && 
+	if (ei->CommandStatus != 0 &&
 	    ei->CommandStatus != CMD_DATA_UNDERRUN) {
 		cciss_scsi_interpret_error(h, c);
 		rc = -1;
@@ -1084,36 +1084,36 @@ cciss_scsi_do_report_phys_luns(ctlr_info_t *h,
 	spin_lock_irqsave(&h->lock, flags);
 	scsi_cmd_free(h, c);
 	spin_unlock_irqrestore(&h->lock, flags);
-	return rc;	
+	return rc;
 }
 
 static void
 cciss_update_non_disk_devices(ctlr_info_t *h, int hostno)
 {
 	/* the idea here is we could get notified from /proc
-	   that some devices have changed, so we do a report 
-	   physical luns cmd, and adjust our list of devices 
+	   that some devices have changed, so we do a report
+	   physical luns cmd, and adjust our list of devices
 	   accordingly.  (We can't rely on the scsi-mid layer just
-	   doing inquiries, because the "busses" that the scsi 
+	   doing inquiries, because the "busses" that the scsi
 	   mid-layer probes are totally fabricated by this driver,
 	   so new devices wouldn't show up.
 
-	   the scsi3addr's of devices won't change so long as the 
-	   adapter is not reset.  That means we can rescan and 
-	   tell which devices we already know about, vs. new 
+	   the scsi3addr's of devices won't change so long as the
+	   adapter is not reset.  That means we can rescan and
+	   tell which devices we already know about, vs. new
 	   devices, vs.  disappearing devices.
 
 	   Also, if you yank out a tape drive, then put in a disk
-	   in it's place, (say, a configured volume from another 
-	   array controller for instance)  _don't_ poke this driver 
-           (so it thinks it's still a tape, but _do_ poke the scsi 
-           mid layer, so it does an inquiry... the scsi mid layer 
+	   in it's place, (say, a configured volume from another
+	   array controller for instance)  _don't_ poke this driver
+           (so it thinks it's still a tape, but _do_ poke the scsi
+           mid layer, so it does an inquiry... the scsi mid layer
            will see the physical disk.  This would be bad.  Need to
-	   think about how to prevent that.  One idea would be to 
+	   think about how to prevent that.  One idea would be to
 	   snoop all scsi responses and if an inquiry repsonse comes
 	   back that reports a disk, chuck it an return selection
 	   timeout instead and adjust our table...  Not sure i like
-	   that though.  
+	   that though.
 
 	 */
 #define OBDR_TAPE_INQ_SIZE 49
@@ -1141,9 +1141,9 @@ cciss_update_non_disk_devices(ctlr_info_t *h, int hostno)
 		ch = &ld_buff->LUNListLength[0];
 		num_luns = ((ch[0]<<24) | (ch[1]<<16) | (ch[2]<<8) | ch[3]) / 8;
 		if (num_luns > CISS_MAX_PHYS_LUN) {
-			printk(KERN_WARNING 
+			printk(KERN_WARNING
 				"cciss: Maximum physical LUNs (%d) exceeded.  "
-				"%d LUNs ignored.\n", CISS_MAX_PHYS_LUN, 
+				"%d LUNs ignored.\n", CISS_MAX_PHYS_LUN,
 				num_luns - CISS_MAX_PHYS_LUN);
 			num_luns = CISS_MAX_PHYS_LUN;
 		}
@@ -1154,7 +1154,7 @@ cciss_update_non_disk_devices(ctlr_info_t *h, int hostno)
 	}
 
 
-	/* adjust our table of devices */	
+	/* adjust our table of devices */
 	for (i = 0; i < num_luns; i++) {
 		/* for each physical lun, do an inquiry */
 		if (ld_buff->LUN[i][3] & 0xC0) continue;
@@ -1213,7 +1213,7 @@ cciss_update_non_disk_devices(ctlr_info_t *h, int hostno)
 			currentsd[ncurrent] = *this_device;
 			ncurrent++;
 			break;
-		  default: 
+		  default:
 			break;
 		}
 	}
@@ -1258,8 +1258,8 @@ cciss_scsi_write_info(struct Scsi_Host *sh,
 		return -EINVAL;
 
 	return cciss_scsi_user_command(h, sh->host_no,
-			buffer, length);	
-} 
+			buffer, length);
+}
 
 static int
 cciss_scsi_show_info(struct seq_file *m, struct Scsi_Host *sh)
@@ -1297,8 +1297,8 @@ cciss_scsi_show_info(struct seq_file *m, struct Scsi_Host *sh)
 	return 0;
 }
 
-/* cciss_scatter_gather takes a struct scsi_cmnd, (cmd), and does the pci 
-   dma mapping  and fills in the scatter gather entries of the 
+/* cciss_scatter_gather takes a struct scsi_cmnd, (cmd), and does the pci
+   dma mapping  and fills in the scatter gather entries of the
    cciss command, c. */
 
 static void cciss_scatter_gather(ctlr_info_t *h, CommandList_struct *c,
@@ -1394,7 +1394,7 @@ cciss_scsi_queue_command_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmn
 
 	// Fill in the command list header
 
-	cmd->scsi_done = done;    // save this for use by completion code 
+	cmd->scsi_done = done;    // save this for use by completion code
 
 	/* save c in case we have to abort it */
 	cmd->host_scribble = (unsigned char *) c;
@@ -1404,7 +1404,7 @@ cciss_scsi_queue_command_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmn
 	c->Header.ReplyQueue = 0;  /* unused in simple mode */
 	memcpy(&c->Header.LUN.LunAddrBytes[0], &scsi3addr[0], 8);
 	c->Header.Tag.lower = c->busaddr;  /* Use k. address of cmd as tag */
-	
+
 	// Fill in the request block...
 
 	c->Request.Timeout = 0;
@@ -1432,15 +1432,15 @@ cciss_scsi_queue_command_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmn
 
 		c->Request.Type.Direction = XFER_RSVD;
 		// This is technically wrong, and cciss controllers should
-		// reject it with CMD_INVALID, which is the most correct 
-		// response, but non-fibre backends appear to let it 
+		// reject it with CMD_INVALID, which is the most correct
+		// response, but non-fibre backends appear to let it
 		// slide by, and give the same results as if this field
 		// were set correctly.  Either way is acceptable for
 		// our purposes here.
 
 		break;
 
-	  default: 
+	  default:
 		dev_warn(&h->pdev->dev, "unknown data direction: %d\n",
 			cmd->sc_data_direction);
 		BUG();
@@ -1464,9 +1464,9 @@ static void cciss_unregister_scsi(ctlr_info_t *h)
 
 	spin_lock_irqsave(&h->lock, flags);
 	sa = h->scsi_ctlr;
-	stk = &sa->cmd_stack; 
+	stk = &sa->cmd_stack;
 
-	/* if we weren't ever actually registered, don't unregister */ 
+	/* if we weren't ever actually registered, don't unregister */
 	if (sa->registered) {
 		spin_unlock_irqrestore(&h->lock, flags);
 		scsi_remove_host(sa->scsi_host);
@@ -1474,7 +1474,7 @@ static void cciss_unregister_scsi(ctlr_info_t *h)
 		spin_lock_irqsave(&h->lock, flags);
 	}
 
-	/* set scsi_host to NULL so our detect routine will 
+	/* set scsi_host to NULL so our detect routine will
 	   find us on register */
 	sa->scsi_host = NULL;
 	spin_unlock_irqrestore(&h->lock, flags);
@@ -1490,7 +1490,7 @@ static int cciss_engage_scsi(ctlr_info_t *h)
 
 	spin_lock_irqsave(&h->lock, flags);
 	sa = h->scsi_ctlr;
-	stk = &sa->cmd_stack; 
+	stk = &sa->cmd_stack;
 
 	if (sa->registered) {
 		dev_info(&h->pdev->dev, "SCSI subsystem already engaged.\n");
@@ -1586,13 +1586,13 @@ static int wait_for_device_to_become_ready(ctlr_info_t *h,
 	return rc;
 }
 
-/* Need at least one of these error handlers to keep ../scsi/hosts.c from 
- * complaining.  Doing a host- or bus-reset can't do anything good here. 
+/* Need at least one of these error handlers to keep ../scsi/hosts.c from
+ * complaining.  Doing a host- or bus-reset can't do anything good here.
  * Despite what it might say in scsi_error.c, there may well be commands
  * on the controller, as the cciss driver registers twice, once as a block
  * device for the logical drives, and once as a scsi device, for any tape
  * drives.  So we know there are no commands out on the tape drives, but we
- * don't know there are no commands on the controller, and it is likely 
+ * don't know there are no commands on the controller, and it is likely
  * that there probably are, as the cciss block device is most commonly used
  * as a boot device (embedded controller on HP/Compaq systems.)
 */
-- 
2.7.4
