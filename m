From: Luben Tuikov <luben@splentec.com>
Subject: [PATCH] SCSI Core cmd->host ==> cmd->device->host 2/3
Date: Mon, 06 Jan 2003 19:16:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E1A1C78.8050104@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id h070Guf21588
	for <linux-scsi@vger.kernel.org>; Mon, 6 Jan 2003 19:16:56 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch makes the conversion from scsi cmd->host to
scsi cmd->device->host for drivers/scsi/*, drivers/usb/storage/*,
drivers/ieee1394/*, drivers/message/fusion/* .

-- 
Luben

diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/ieee1394/sbp2.c linux-2.5.54-2/drivers/ieee1394/sbp2.c
--- linux-2.5.54-1/drivers/ieee1394/sbp2.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/ieee1394/sbp2.c	2003-01-03 13:58:49.000000000 -0500
@@ -829,7 +829,7 @@
  {
  	struct sbp2scsi_host_info *hi;
  	
-	hi = (struct sbp2scsi_host_info *) command->Current_SCpnt->host->hostdata[0];
+	hi = (struct sbp2scsi_host_info *) command->Current_SCpnt->device->host->hostdata[0];

  	if (hi == NULL) {
  		printk(KERN_ERR "%s: hi == NULL\n", __FUNCTION__);
@@ -2659,7 +2659,7 @@
  	/*
  	 * Pull our host info and scsi id instance data from the scsi command
  	 */
-	hi = (struct sbp2scsi_host_info *) SCpnt->host->hostdata[0];
+	hi = (struct sbp2scsi_host_info *) SCpnt->device->host->hostdata[0];

  	if (!hi) {
  		SBP2_ERR("sbp2scsi_host_info is NULL - this is bad!");
@@ -2882,7 +2882,7 @@
   */
  static int sbp2scsi_abort (Scsi_Cmnd *SCpnt)
  {
-	struct sbp2scsi_host_info *hi = (struct sbp2scsi_host_info *) SCpnt->host->hostdata[0];
+	struct sbp2scsi_host_info *hi = (struct sbp2scsi_host_info *) SCpnt->device->host->hostdata[0];
  	struct scsi_id_instance_data *scsi_id = hi->scsi_id[SCpnt->device->id];
  	struct sbp2_command_info *command;
  	unsigned long flags;
@@ -2932,7 +2932,7 @@
   */
  static int sbp2scsi_reset (Scsi_Cmnd *SCpnt)
  {
-	struct sbp2scsi_host_info *hi = (struct sbp2scsi_host_info *) SCpnt->host->hostdata[0];
+	struct sbp2scsi_host_info *hi = (struct sbp2scsi_host_info *) SCpnt->device->host->hostdata[0];
  	struct scsi_id_instance_data *scsi_id = hi->scsi_id[SCpnt->device->id];

  	SBP2_ERR("reset requested");
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/message/fusion/mptscsih.c linux-2.5.54-2/drivers/message/fusion/mptscsih.c
--- linux-2.5.54-1/drivers/message/fusion/mptscsih.c	2003-01-03 13:08:50.000000000 -0500
+++ linux-2.5.54-2/drivers/message/fusion/mptscsih.c	2003-01-03 13:58:49.000000000 -0500
@@ -1594,8 +1594,8 @@
  	if (time - last_queue_full > 10 * HZ) {
  		char *ioc_str = "ioc?";

-		if (sc->host != NULL && sc->host->hostdata != NULL)
-			ioc_str = ((MPT_SCSI_HOST *)sc->host->hostdata)->ioc->name;
+		if (sc->device && sc->device->host != NULL && sc->device->host->hostdata != NULL)
+			ioc_str = ((MPT_SCSI_HOST *)sc->device->host->hostdata)->ioc->name;
  		printk(MYIOC_s_WARN_FMT "Device (%d:%d:%d) reported QUEUE_FULL!\n",
  				ioc_str, 0, sc->device->id, sc->device->lun);
  		last_queue_full = time;
@@ -2576,7 +2576,7 @@
  	int	 issueCmd;

  	did_errcode = 0;
-	hd = (MPT_SCSI_HOST *) SCpnt->host->hostdata;
+	hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata;
  	target = SCpnt->device->id;
  	lun = SCpnt->device->lun;
  	SCpnt->scsi_done = done;
@@ -3159,7 +3159,7 @@

  	/* If we can't locate our host adapter structure, return FAILED status.
  	 */
-	if ((hd = (MPT_SCSI_HOST *) SCpnt->host->hostdata) == NULL) {
+	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL) {
  		SCpnt->result = DID_RESET << 16;
  		SCpnt->scsi_done(SCpnt);
  		nehprintk((KERN_WARNING MYNAM ": mptscsih_abort: "
@@ -3263,7 +3263,7 @@

  	/* If we can't locate our host adapter structure, return FAILED status.
  	 */
-	if ((hd = (MPT_SCSI_HOST *) SCpnt->host->hostdata) == NULL){
+	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL){
  		nehprintk((KERN_WARNING MYNAM ": mptscsih_dev_reset: "
  			   "Can't locate host! (sc=%p)\n",
  			   SCpnt));
@@ -3323,7 +3323,7 @@

  	/* If we can't locate our host adapter structure, return FAILED status.
  	 */
-	if ((hd = (MPT_SCSI_HOST *) SCpnt->host->hostdata) == NULL){
+	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL){
  		nehprintk((KERN_WARNING MYNAM ": mptscsih_bus_reset: "
  			   "Can't locate host! (sc=%p)\n",
  			   SCpnt ) );
@@ -3385,7 +3385,7 @@
  	int              status = SUCCESS;

  	/*  If we can't locate the host to reset, then we failed. */
-	if ((hd = (MPT_SCSI_HOST *) SCpnt->host->hostdata) == NULL){
+	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL){
  		nehprintk( ( KERN_WARNING MYNAM ": mptscsih_host_reset: "
  			     "Can't locate host! (sc=%p)\n",
  			     SCpnt ) );
@@ -4261,7 +4261,7 @@
  	MPT_SCSI_HOST *hd;
  	int i;

-	hd = (MPT_SCSI_HOST *) sc->host->hostdata;
+	hd = (MPT_SCSI_HOST *) sc->device->host->hostdata;

  	for (i = 0; i < hd->ioc->req_depth; i++) {
  		if (hd->ScsiLookup[i] == sc) {
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/3w-xxxx.c linux-2.5.54-2/drivers/scsi/3w-xxxx.c
--- linux-2.5.54-1/drivers/scsi/3w-xxxx.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/3w-xxxx.c	2003-01-03 13:58:49.000000000 -0500
@@ -2187,7 +2187,7 @@
  		return (FAILED);
  	}

-	tw_dev = (TW_Device_Extension *)SCpnt->host->hostdata;
+	tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
  	if (tw_dev == NULL) {
  		printk(KERN_WARNING "3w-xxxx: tw_scsi_eh_abort(): Invalid device extension.\n");
  		return (FAILED);
@@ -2254,7 +2254,7 @@
  		return (FAILED);
  	}

-	tw_dev = (TW_Device_Extension *)SCpnt->host->hostdata;
+	tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
  	if (tw_dev == NULL) {
  		printk(KERN_WARNING "3w-xxxx: tw_scsi_eh_reset(): Invalid device extension.\n");
  		return (FAILED);
@@ -2356,7 +2356,7 @@
  	int request_id = 0;
  	int error = 0;
  	unsigned long flags = 0;
-	TW_Device_Extension *tw_dev = (TW_Device_Extension *)SCpnt->host->hostdata;
+	TW_Device_Extension *tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;

  	if (tw_dev == NULL) {
  		printk(KERN_WARNING "3w-xxxx: tw_scsi_queue(): Invalid device extension.\n");
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/53c7,8xx.c linux-2.5.54-2/drivers/scsi/53c7,8xx.c
--- linux-2.5.54-1/drivers/scsi/53c7,8xx.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/53c7,8xx.c	2003-01-03 13:58:49.000000000 -0500
@@ -1996,7 +1996,7 @@
  static void
  NCR53c8xx_dsa_fixup (struct NCR53c7x0_cmd *cmd) {
      Scsi_Cmnd *c = cmd->cmd;
-    struct Scsi_Host *host = c->host;
+    struct Scsi_Host *host = c->device->host;
      struct NCR53c7x0_hostdata *hostdata = (struct NCR53c7x0_hostdata *)
      	host->hostdata;
      int i;
@@ -2113,7 +2113,7 @@
  static void
  abnormal_finished (struct NCR53c7x0_cmd *cmd, int result) {
      Scsi_Cmnd *c = cmd->cmd;
-    struct Scsi_Host *host = c->host;
+    struct Scsi_Host *host = c->device->host;
      struct NCR53c7x0_hostdata *hostdata = (struct NCR53c7x0_hostdata *)
      	host->hostdata;
      unsigned long flags;
@@ -3430,7 +3430,7 @@

  static struct NCR53c7x0_cmd *
  allocate_cmd (Scsi_Cmnd *cmd) {
-    struct Scsi_Host *host = cmd->host;
+    struct Scsi_Host *host = cmd->device->host;
      struct NCR53c7x0_hostdata *hostdata =
  	(struct NCR53c7x0_hostdata *) host->hostdata;
      void *real;			/* Real address */
@@ -3512,7 +3512,7 @@
  static struct NCR53c7x0_cmd *
  create_cmd (Scsi_Cmnd *cmd) {
      NCR53c7x0_local_declare();
-    struct Scsi_Host *host = cmd->host;
+    struct Scsi_Host *host = cmd->device->host;
      struct NCR53c7x0_hostdata *hostdata = (struct NCR53c7x0_hostdata *)
          host->hostdata;	
      struct NCR53c7x0_cmd *tmp; 	/* NCR53c7x0_cmd structure for this command */
@@ -3527,7 +3527,7 @@
      int msglen;			/* Length of whole select message */
  #endif
      unsigned long flags;
-    NCR53c7x0_local_setup(cmd->host);
+    NCR53c7x0_local_setup(cmd->device->host);

      if (!(tmp = allocate_cmd (cmd)))
  	return NULL;
@@ -3879,7 +3879,7 @@

  int
  NCR53c7xx_queue_command (Scsi_Cmnd *cmd, void (* done)(Scsi_Cmnd *)) {
-    struct Scsi_Host *host = cmd->host;
+    struct Scsi_Host *host = cmd->device->host;
      struct NCR53c7x0_hostdata *hostdata =
  	(struct NCR53c7x0_hostdata *) host->hostdata;
      unsigned long flags;
@@ -5465,7 +5465,7 @@
  int
  NCR53c7xx_abort (Scsi_Cmnd *cmd) {
      NCR53c7x0_local_declare();
-    struct Scsi_Host *host = cmd->host;
+    struct Scsi_Host *host = cmd->device->host;
      struct NCR53c7x0_hostdata *hostdata = host ? (struct NCR53c7x0_hostdata *)
  	host->hostdata : NULL;
      unsigned long flags;
@@ -5575,7 +5575,7 @@
  	    return SCSI_ABORT_NOT_RUNNING;
  	} else {
  	    printk ("scsi%d : DANGER : command running, can not abort.\n",
-		cmd->host->host_no);
+		cmd->device->host->host_no);
  	    restore_flags(flags);
  	    return SCSI_ABORT_BUSY;
  	}
@@ -5651,7 +5651,7 @@
       * each command.
       */
      Scsi_Cmnd *nuke_list = NULL;
-    struct Scsi_Host *host = cmd->host;
+    struct Scsi_Host *host = cmd->device->host;
      struct NCR53c7x0_hostdata *hostdata =
      	(struct NCR53c7x0_hostdata *) host->hostdata;

@@ -5722,7 +5722,7 @@
  static int
  insn_to_offset (Scsi_Cmnd *cmd, u32 *insn) {
      struct NCR53c7x0_hostdata *hostdata =
-	(struct NCR53c7x0_hostdata *) cmd->host->hostdata;
+	(struct NCR53c7x0_hostdata *) cmd->device->host->hostdata;
      struct NCR53c7x0_cmd *ncmd =
  	(struct NCR53c7x0_cmd *) cmd->host_scribble;
      int offset = 0, buffers;
@@ -5790,7 +5790,7 @@
      int offset, i;
      char *where;
      u32 *ptr;
-    NCR53c7x0_local_setup (cmd->host);
+    NCR53c7x0_local_setup (cmd->device->host);
      for (i = 0; i < 2; ++i) {
  	if (check_address ((unsigned long) ncmd,
  	    sizeof (struct NCR53c7x0_cmd)) == -1)
@@ -5808,15 +5808,15 @@

  	if (offset != -1)
  	    printk ("scsi%d : %s data pointer at offset %d\n",
-		cmd->host->host_no, where, offset);
+		cmd->device->host->host_no, where, offset);
  	else {
  	    int size;
  	    printk ("scsi%d : can't determine %s data pointer offset\n",
-		cmd->host->host_no, where);
+		cmd->device->host->host_no, where);
  	    if (ncmd) {
-		size = print_insn (cmd->host,
+		size = print_insn (cmd->device->host,
  		    bus_to_virt(le32_to_cpu(ncmd->saved_data_pointer)), "", 1);
-		print_insn (cmd->host,
+		print_insn (cmd->device->host,
  		    bus_to_virt(le32_to_cpu(ncmd->saved_data_pointer)) + size * sizeof(u32),
  		    "", 1);
  	    }
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/aacraid/aachba.c linux-2.5.54-2/drivers/scsi/aacraid/aachba.c
--- linux-2.5.54-1/drivers/scsi/aacraid/aachba.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/aacraid/aachba.c	2003-01-03 13:58:49.000000000 -0500
@@ -463,9 +463,9 @@
  static void aac_io_done(Scsi_Cmnd * scsicmd)
  {
  	unsigned long cpu_flags;
-	spin_lock_irqsave(scsicmd->host->host_lock, cpu_flags);
+	spin_lock_irqsave(scsicmd->device->host->host_lock, cpu_flags);
  	scsicmd->scsi_done(scsicmd);
-	spin_unlock_irqrestore(scsicmd->host->host_lock, cpu_flags);
+	spin_unlock_irqrestore(scsicmd->device->host->host_lock, cpu_flags);
  }

  static void __aac_io_done(Scsi_Cmnd * scsicmd)
@@ -546,7 +546,7 @@

  	scsicmd = (Scsi_Cmnd *) context;

-	dev = (struct aac_dev *)scsicmd->host->hostdata;
+	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
  	cid =TARGET_LUN_TO_CONTAINER(scsicmd->device->id, scsicmd->device->lun);

  	lba = ((scsicmd->cmnd[1] & 0x1F) << 16) | (scsicmd->cmnd[2] << 8) | scsicmd->cmnd[3];
@@ -591,7 +591,7 @@
  	u32 cid;

  	scsicmd = (Scsi_Cmnd *) context;
-	dev = (struct aac_dev *)scsicmd->host->hostdata;
+	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
  	cid = TARGET_LUN_TO_CONTAINER(scsicmd->device->id, scsicmd->device->lun);

  	lba = ((scsicmd->cmnd[1] & 0x1F) << 16) | (scsicmd->cmnd[2] << 8) | scsicmd->cmnd[3];
@@ -637,7 +637,7 @@
  	struct aac_dev *dev;
  	struct fib * cmd_fibcontext;

-	dev = (struct aac_dev *)scsicmd->host->hostdata;
+	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
  	/*
  	 *	Get block address and transfer length
  	 */
@@ -746,7 +746,7 @@
  	struct aac_dev *dev;
  	struct fib * cmd_fibcontext;

-	dev = (struct aac_dev *)scsicmd->host->hostdata;
+	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
  	/*
  	 *	Get block address and transfer length
  	 */
@@ -861,18 +861,18 @@
  	struct fsa_scsi_hba *fsa_dev_ptr;
  	int cardtype;
  	int ret;
-	struct aac_dev *dev = (struct aac_dev *)scsicmd->host->hostdata;
+	struct aac_dev *dev = (struct aac_dev *)scsicmd->device->host->hostdata;
  	
  	cardtype = dev->cardtype;

-	fsa_dev_ptr = fsa_dev[scsicmd->host->unique_id];
+	fsa_dev_ptr = fsa_dev[scsicmd->device->host->unique_id];

  	/*
  	 *	If the bus, target or lun is out of range, return fail
  	 *	Test does not apply to ID 16, the pseudo id for the controller
  	 *	itself.
  	 */
-	if (scsicmd->device->id != scsicmd->host->this_id) {
+	if (scsicmd->device->id != scsicmd->device->host->this_id) {
  		if ((scsicmd->device->channel == 0) ){
  			if( (scsicmd->device->id >= AAC_MAX_TARGET) || (scsicmd->device->lun != 0)){
  				scsicmd->result = DID_NO_CONNECT << 16;
@@ -890,9 +890,9 @@
  				case SS_INQUIR:
  				case SS_RDCAP:
  				case SS_TEST:
-					spin_unlock_irq(scsicmd->host->host_lock);
+					spin_unlock_irq(scsicmd->device->host->host_lock);
  					probe_container(dev, cid);
-					spin_lock_irq(scsicmd->host->host_lock);
+					spin_lock_irq(scsicmd->device->host->host_lock);
  					if (fsa_dev_ptr->valid[cid] == 0) {
  						scsicmd->result = DID_NO_CONNECT << 16;
  						__aac_io_done(scsicmd);
@@ -959,7 +959,7 @@
  		 *	see: <vendor>.c i.e. aac.c
  		 */
  		setinqstr(cardtype, (void *) (inq_data_ptr->inqd_vid), fsa_dev_ptr->type[cid]);
-		if (scsicmd->device->id == scsicmd->host->this_id)
+		if (scsicmd->device->id == scsicmd->device->host->this_id)
  			inq_data_ptr->inqd_pdt = INQD_PDT_PROC;	/* Processor device */
  		else
  			inq_data_ptr->inqd_pdt = INQD_PDT_DA;	/* Direct/random access device */
@@ -1053,20 +1053,20 @@
  			 *	containers to /dev/sd device names
  			 */
  			
-			spin_unlock_irq(scsicmd->host->host_lock);
+			spin_unlock_irq(scsicmd->device->host->host_lock);
  			if  (scsicmd->request->rq_disk)
  				memcpy(fsa_dev_ptr->devname[cid],
  					scsicmd->request->rq_disk->disk_name,
  					8);
  			ret = aac_read(scsicmd, cid);
-			spin_lock_irq(scsicmd->host->host_lock);
+			spin_lock_irq(scsicmd->device->host->host_lock);
  			return ret;

  		case SS_WRITE:
  		case SM_WRITE:
-			spin_unlock_irq(scsicmd->host->host_lock);
+			spin_unlock_irq(scsicmd->device->host->host_lock);
  			ret = aac_write(scsicmd, cid);
-			spin_lock_irq(scsicmd->host->host_lock);
+			spin_lock_irq(scsicmd->device->host->host_lock);
  			return ret;
  		default:
  			/*
@@ -1202,7 +1202,7 @@
  	Scsi_Cmnd *scsicmd;

  	scsicmd = (Scsi_Cmnd *) context;
-	dev = (struct aac_dev *)scsicmd->host->hostdata;
+	dev = (struct aac_dev *)scsicmd->device->host->hostdata;

  	if (fibptr == NULL)
  		BUG();
@@ -1372,7 +1372,7 @@
  		return 0;
  	}

-	dev = (struct aac_dev *)scsicmd->host->hostdata;
+	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
  	switch(scsicmd->sc_data_direction){
  	case SCSI_DATA_WRITE:
  		flag = SRB_DataOut;
@@ -1468,7 +1468,7 @@
  	struct aac_dev *dev;
  	unsigned long byte_count = 0;

-	dev = (struct aac_dev *)scsicmd->host->hostdata;
+	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
  	// Get rid of old data
  	psg->count = cpu_to_le32(0);
  	psg->sg[0].addr = cpu_to_le32(NULL);
@@ -1524,7 +1524,7 @@
  	unsigned long byte_count = 0;
  	u64 le_addr;

-	dev = (struct aac_dev *)scsicmd->host->hostdata;
+	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
  	// Get rid of old data
  	psg->count = cpu_to_le32(0);
  	psg->sg[0].addr[0] = cpu_to_le32(NULL);
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/advansys.c linux-2.5.54-2/drivers/scsi/advansys.c
--- linux-2.5.54-1/drivers/scsi/advansys.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/advansys.c	2003-01-03 13:58:49.000000000 -0500
@@ -5845,7 +5845,7 @@
      ulong               flags;
      Scsi_Cmnd           *done_scp;

-    shp = scp->host;
+    shp = scp->device->host;
      boardp = ASC_BOARDP(shp);
      ASC_STATS(shp, queuecommand);

@@ -5941,12 +5941,12 @@
      ASC_DBG1(1, "advansys_reset: 0x%lx\n", (ulong) scp);

  #ifdef ADVANSYS_STATS
-    if (scp->host != NULL) {
-        ASC_STATS(scp->host, reset);
+    if (scp->device->host != NULL) {
+        ASC_STATS(scp->device->host, reset);
      }
  #endif /* ADVANSYS_STATS */

-    if ((shp = scp->host) == NULL) {
+    if ((shp = scp->device->host) == NULL) {
          scp->result = HOST_BYTE(DID_ERROR);
          return FAILED;
      }
@@ -6390,13 +6390,13 @@
          ASC_DBG1(3, "asc_scsi_done_list: scp 0x%lx\n", (ulong) scp);
          tscp = REQPNEXT(scp);
          REQPNEXT(scp) = NULL;
-        ASC_STATS(scp->host, done);
+        ASC_STATS(scp->device->host, done);
          ASC_ASSERT(scp->scsi_done != NULL);
  	if (from_isr)
-	    spin_lock_irqsave(scp->host->host_lock, flags);
+	    spin_lock_irqsave(scp->device->host->host_lock, flags);
          scp->scsi_done(scp);
  	if (from_isr)
-	    spin_unlock_irqrestore(scp->host->host_lock, flags);
+	    spin_unlock_irqrestore(scp->device->host->host_lock, flags);
          scp = tscp;
      }
      ASC_DBG(2, "asc_scsi_done_list: done\n");
@@ -6462,7 +6462,7 @@
      ASC_DBG2(1, "asc_execute_scsi_cmnd: scp 0x%lx, done 0x%lx\n",
          (ulong) scp, (ulong) scp->scsi_done);

-    boardp = ASC_BOARDP(scp->host);
+    boardp = ASC_BOARDP(scp->device->host);
      device = boardp->device[scp->device->id];

      if (ASC_NARROW_BOARD(boardp)) {
@@ -6483,7 +6483,7 @@
           * asc_build_req() can not return ASC_BUSY.
           */
          if (asc_build_req(boardp, scp) == ASC_ERROR) {
-            ASC_STATS(scp->host, build_error);
+            ASC_STATS(scp->device->host, build_error);
              return ASC_ERROR;
          }

@@ -6493,7 +6493,7 @@
           */
          switch (ret = AscExeScsiQueue(asc_dvc_varp, &asc_scsi_q)) {
          case ASC_NOERROR:
-            ASC_STATS(scp->host, exe_noerror);
+            ASC_STATS(scp->device->host, exe_noerror);
              /*
               * Increment monotonically increasing per device successful
               * request counter. Wrapping doesn't matter.
@@ -6508,13 +6508,13 @@
               * Caller will enqueue request on the target's waiting queue
               * and retry later.
               */
-            ASC_STATS(scp->host, exe_busy);
+            ASC_STATS(scp->device->host, exe_busy);
              break;
          case ASC_ERROR:
              ASC_PRINT2(
  "asc_execute_scsi_cmnd: board %d: AscExeScsiQueue() ASC_ERROR, err_code 0x%x\n",
                  boardp->id, asc_dvc_varp->err_code);
-            ASC_STATS(scp->host, exe_error);
+            ASC_STATS(scp->device->host, exe_error);
              scp->result = HOST_BYTE(DID_ERROR);
              asc_enqueue(&boardp->done, scp, ASC_BACK);
              break;
@@ -6522,7 +6522,7 @@
              ASC_PRINT2(
  "asc_execute_scsi_cmnd: board %d: AscExeScsiQueue() unknown, err_code 0x%x\n",
                  boardp->id, asc_dvc_varp->err_code);
-            ASC_STATS(scp->host, exe_unknown);
+            ASC_STATS(scp->device->host, exe_unknown);
              scp->result = HOST_BYTE(DID_ERROR);
              asc_enqueue(&boardp->done, scp, ASC_BACK);
              break;
@@ -6563,7 +6563,7 @@
                */
          default:
              ASC_DBG(1, "asc_execute_scsi_cmnd: adv_build_req ASC_ERROR\n");
-            ASC_STATS(scp->host, build_error);
+            ASC_STATS(scp->device->host, build_error);
              return ASC_ERROR;
          }

@@ -6573,7 +6573,7 @@
           */
          switch (ret = AdvExeScsiQueue(adv_dvc_varp, adv_scsiqp)) {
          case ASC_NOERROR:
-            ASC_STATS(scp->host, exe_noerror);
+            ASC_STATS(scp->device->host, exe_noerror);
              /*
               * Increment monotonically increasing per device successful
               * request counter. Wrapping doesn't matter.
@@ -6588,13 +6588,13 @@
               * Caller will enqueue request on the target's waiting queue
               * and retry later.
               */
-            ASC_STATS(scp->host, exe_busy);
+            ASC_STATS(scp->device->host, exe_busy);
              break;
          case ASC_ERROR:
              ASC_PRINT2(
  "asc_execute_scsi_cmnd: board %d: AdvExeScsiQueue() ASC_ERROR, err_code 0x%x\n",
                  boardp->id, adv_dvc_varp->err_code);
-            ASC_STATS(scp->host, exe_error);
+            ASC_STATS(scp->device->host, exe_error);
              scp->result = HOST_BYTE(DID_ERROR);
              asc_enqueue(&boardp->done, scp, ASC_BACK);
              break;
@@ -6602,7 +6602,7 @@
              ASC_PRINT2(
  "asc_execute_scsi_cmnd: board %d: AdvExeScsiQueue() unknown, err_code 0x%x\n",
                  boardp->id, adv_dvc_varp->err_code);
-            ASC_STATS(scp->host, exe_unknown);
+            ASC_STATS(scp->device->host, exe_unknown);
              scp->result = HOST_BYTE(DID_ERROR);
              asc_enqueue(&boardp->done, scp, ASC_BACK);
              break;
@@ -6684,11 +6684,11 @@
          /*
           * CDB request of single contiguous buffer.
           */
-        ASC_STATS(scp->host, cont_cnt);
+        ASC_STATS(scp->device->host, cont_cnt);
          asc_scsi_q.q1.data_addr =
              cpu_to_le32(virt_to_bus(scp->request_buffer));
          asc_scsi_q.q1.data_cnt = cpu_to_le32(scp->request_bufflen);
-        ASC_STATS_ADD(scp->host, cont_xfer,
+        ASC_STATS_ADD(scp->device->host, cont_xfer,
                        ASC_CEILING(scp->request_bufflen, 512));
          asc_scsi_q.q1.sg_queue_cnt = 0;
          asc_scsi_q.sg_head = NULL;
@@ -6699,16 +6699,16 @@
          int                     sgcnt;
          struct scatterlist      *slp;

-        if (scp->use_sg > scp->host->sg_tablesize) {
+        if (scp->use_sg > scp->device->host->sg_tablesize) {
              ASC_PRINT3(
  "asc_build_req: board %d: use_sg %d > sg_tablesize %d\n",
-                boardp->id, scp->use_sg, scp->host->sg_tablesize);
+                boardp->id, scp->use_sg, scp->device->host->sg_tablesize);
              scp->result = HOST_BYTE(DID_ERROR);
              asc_enqueue(&boardp->done, scp, ASC_BACK);
              return ASC_ERROR;
          }

-        ASC_STATS(scp->host, sg_cnt);
+        ASC_STATS(scp->device->host, sg_cnt);

          /*
           * Use global ASC_SG_HEAD structure and set the ASC_SCSI_Q
@@ -6722,7 +6722,7 @@
          asc_scsi_q.q1.data_addr = 0;
          /* This is a byte value, otherwise it would need to be swapped. */
          asc_sg_head.entry_cnt = asc_scsi_q.q1.sg_queue_cnt = scp->use_sg;
-        ASC_STATS_ADD(scp->host, sg_elem, asc_sg_head.entry_cnt);
+        ASC_STATS_ADD(scp->device->host, sg_elem, asc_sg_head.entry_cnt);

          /*
           * Convert scatter-gather list into ASC_SG_HEAD list.
@@ -6733,7 +6733,7 @@
                  cpu_to_le32(virt_to_bus(
  		(unsigned char *)page_address(slp->page) + slp->offset));
              asc_sg_head.sg_list[sgcnt].bytes = cpu_to_le32(slp->length);
-            ASC_STATS_ADD(scp->host, sg_xfer, ASC_CEILING(slp->length, 512));
+            ASC_STATS_ADD(scp->device->host, sg_xfer, ASC_CEILING(slp->length, 512));
          }
      }

@@ -6768,7 +6768,7 @@
       */
      if (boardp->adv_reqp == NULL) {
          ASC_DBG(1, "adv_build_req: no free adv_req_t\n");
-        ASC_STATS(scp->host, adv_build_noreq);
+        ASC_STATS(scp->device->host, adv_build_noreq);
          return ASC_BUSY;
      } else {
          reqp = boardp->adv_reqp;
@@ -6844,8 +6844,8 @@
          reqp->sgblkp = NULL;
          scsiqp->sg_list_ptr = NULL;
          scsiqp->sg_real_addr = 0;
-        ASC_STATS(scp->host, cont_cnt);
-        ASC_STATS_ADD(scp->host, cont_xfer,
+        ASC_STATS(scp->device->host, cont_cnt);
+        ASC_STATS_ADD(scp->device->host, cont_xfer,
                        ASC_CEILING(scp->request_bufflen, 512));
      } else {
          /*
@@ -6854,7 +6854,7 @@
          if (scp->use_sg > ADV_MAX_SG_LIST) {
              ASC_PRINT3(
  "adv_build_req: board %d: use_sg %d > ADV_MAX_SG_LIST %d\n",
-                boardp->id, scp->use_sg, scp->host->sg_tablesize);
+                boardp->id, scp->use_sg, scp->device->host->sg_tablesize);
              scp->result = HOST_BYTE(DID_ERROR);
              asc_enqueue(&boardp->done, scp, ASC_BACK);

@@ -6879,8 +6879,8 @@
              return ret;
          }

-        ASC_STATS(scp->host, sg_cnt);
-        ASC_STATS_ADD(scp->host, sg_elem, scp->use_sg);
+        ASC_STATS(scp->device->host, sg_cnt);
+        ASC_STATS_ADD(scp->device->host, sg_elem, scp->use_sg);
      }

      ASC_DBG_PRT_ADV_SCSI_REQ_Q(2, scsiqp);
@@ -6929,7 +6929,7 @@
           */
          if ((sgblkp = boardp->adv_sgblkp) == NULL) {
              ASC_DBG(1, "adv_get_sglist: no free adv_sgblk_t\n");
-            ASC_STATS(scp->host, adv_build_nosg);
+            ASC_STATS(scp->device->host, adv_build_nosg);

              /*
               * Allocation failed. Free 'adv_sgblk_t' structures already
@@ -6992,7 +6992,7 @@
                  cpu_to_le32(virt_to_bus(
                     (unsigned char *)page_address(slp->page) + slp->offset));
              sg_block->sg_list[i].sg_count = cpu_to_le32(slp->length);
-            ASC_STATS_ADD(scp->host, sg_xfer, ASC_CEILING(slp->length, 512));
+            ASC_STATS_ADD(scp->device->host, sg_xfer, ASC_CEILING(slp->length, 512));

              if (--sg_elem_cnt == 0)
              {   /* Last ADV_SG_BLOCK and scatter-gather entry. */
@@ -7043,7 +7043,7 @@
       * If the request's host pointer is not valid, display a
       * message and return.
       */
-    shp = scp->host;
+    shp = scp->device->host;
      for (i = 0; i < asc_board_count; i++) {
          if (asc_host[i] == shp) {
              break;
@@ -7232,7 +7232,7 @@
       * If the request's host pointer is not valid, display a message
       * and return.
       */
-    shp = scp->host;
+    shp = scp->device->host;
      for (i = 0; i < asc_board_count; i++) {
          if (asc_host[i] == shp) {
              break;
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/aic7xxx_old.c linux-2.5.54-2/drivers/scsi/aic7xxx_old.c
--- linux-2.5.54-1/drivers/scsi/aic7xxx_old.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/aic7xxx_old.c	2003-01-03 13:58:49.000000000 -0500
@@ -10298,7 +10298,7 @@
    struct aic7xxx_scb *scb;
    struct aic_dev_data *aic_dev;

-  p = (struct aic7xxx_host *) cmd->host->hostdata;
+  p = (struct aic7xxx_host *) cmd->device->host->hostdata;

    aic_dev = cmd->device->hostdata;
  #ifdef AIC7XXX_VERBOSE_DEBUGGING
@@ -10379,7 +10379,7 @@
      printk(KERN_ERR "aic7xxx_bus_device_reset: called with NULL cmd!\n");
      return FAILED;
    }
-  p = (struct aic7xxx_host *)cmd->host->hostdata;
+  p = (struct aic7xxx_host *)cmd->device->host->hostdata;
    aic_dev = AIC_DEV(cmd);
    if(aic7xxx_position(cmd) < p->scb_data->numscbs)
      scb = (p->scb_data->scb_array[aic7xxx_position(cmd)]);
@@ -10604,7 +10604,7 @@
      printk(KERN_ERR "aic7xxx_abort: called with NULL cmd!\n");
      return FAILED;
    }
-  p = (struct aic7xxx_host *)cmd->host->hostdata;
+  p = (struct aic7xxx_host *)cmd->device->host->hostdata;
    aic_dev = AIC_DEV(cmd);
    if(aic7xxx_position(cmd) < p->scb_data->numscbs)
      scb = (p->scb_data->scb_array[aic7xxx_position(cmd)]);
@@ -10825,7 +10825,7 @@
    struct aic7xxx_host *p;
    struct aic_dev_data *aic_dev;

-  p = (struct aic7xxx_host *) cmd->host->hostdata;
+  p = (struct aic7xxx_host *) cmd->device->host->hostdata;
    aic_dev = AIC_DEV(cmd);
    if(aic7xxx_position(cmd) < p->scb_data->numscbs)
    {
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/AM53C974.c linux-2.5.54-2/drivers/scsi/AM53C974.c
--- linux-2.5.54-1/drivers/scsi/AM53C974.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/AM53C974.c	2003-01-03 13:58:49.000000000 -0500
@@ -897,7 +897,7 @@
  static int AM53C974_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
  {
  	unsigned long flags;
-	struct Scsi_Host *instance = cmd->host;
+	struct Scsi_Host *instance = cmd->device->host;
  	struct AM53C974_hostdata *hostdata = (struct AM53C974_hostdata *) instance->hostdata;
  	Scsi_Cmnd *tmp;

@@ -2279,7 +2279,7 @@
  {
  	AM53C974_local_declare();
  	unsigned long flags;
-	struct Scsi_Host *instance = cmd->host;
+	struct Scsi_Host *instance = cmd->device->host;
  	struct AM53C974_hostdata *hostdata = (struct AM53C974_hostdata *) instance->hostdata;
  	Scsi_Cmnd *tmp, **prev;

@@ -2388,7 +2388,7 @@
  	AM53C974_local_declare();
  	unsigned long flags;
  	int i;
-	struct Scsi_Host *instance = cmd->host;
+	struct Scsi_Host *instance = cmd->device->host;
  	struct AM53C974_hostdata *hostdata = (struct AM53C974_hostdata *) instance->hostdata;
  	AM53C974_setio(instance);

diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/atp870u.c linux-2.5.54-2/drivers/scsi/atp870u.c
--- linux-2.5.54-1/drivers/scsi/atp870u.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/atp870u.c	2003-01-03 13:58:49.000000000 -0500
@@ -498,7 +498,7 @@
  		return 0;
  	};

-	host = req_p->host;
+	host = req_p->device->host;
  	dev = (struct atp_unit *)&host->hostdata;
  	
  	m = 1;
@@ -2606,7 +2606,7 @@
  	unsigned char j, k;
  	Scsi_Cmnd *workrequ;
  	unsigned int tmport;
-	struct atp_unit *dev = (struct atp_unit *)&SCpnt->host->hostdata;
+	struct atp_unit *dev = (struct atp_unit *)&SCpnt->device->host->hostdata;

  	printk(KERN_DEBUG "working=%x last_cmd=%x ", dev->working, dev->last_cmd);
  	printk(" quhdu=%x quendu=%x ", dev->quhdu, dev->quendu);
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/BusLogic.c linux-2.5.54-2/drivers/scsi/BusLogic.c
--- linux-2.5.54-1/drivers/scsi/BusLogic.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/BusLogic.c	2003-01-03 13:58:49.000000000 -0500
@@ -3471,7 +3471,7 @@
  			  void (*CompletionRoutine)(SCSI_Command_T *))
  {
    BusLogic_HostAdapter_T *HostAdapter =
-    (BusLogic_HostAdapter_T *) Command->host->hostdata;
+    (BusLogic_HostAdapter_T *) Command->device->host->hostdata;
    BusLogic_TargetFlags_T *TargetFlags =
      &HostAdapter->TargetFlags[Command->device->id];
    BusLogic_TargetStatistics_T *TargetStatistics =
@@ -3708,7 +3708,7 @@
  int BusLogic_AbortCommand(SCSI_Command_T *Command)
  {
    BusLogic_HostAdapter_T *HostAdapter =
-    (BusLogic_HostAdapter_T *) Command->host->hostdata;
+    (BusLogic_HostAdapter_T *) Command->device->host->hostdata;

    int TargetID = Command->device->id;
    BusLogic_CCB_T *CCB;
@@ -4153,7 +4153,7 @@
  int BusLogic_ResetCommand(SCSI_Command_T *Command, unsigned int ResetFlags)
  {
    BusLogic_HostAdapter_T *HostAdapter =
-    (BusLogic_HostAdapter_T *) Command->host->hostdata;
+    (BusLogic_HostAdapter_T *) Command->device->host->hostdata;
    int TargetID = Command->device->id;
    BusLogic_ErrorRecoveryStrategy_T
      ErrorRecoveryStrategy = HostAdapter->ErrorRecoveryStrategy[TargetID];
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/constants.c linux-2.5.54-2/drivers/scsi/constants.c
--- linux-2.5.54-1/drivers/scsi/constants.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/constants.c	2003-01-03 13:58:49.000000000 -0500
@@ -1118,7 +1118,7 @@

  void print_Scsi_Cmnd (Scsi_Cmnd *cmd) {
      printk("scsi%d : destination target %d, lun %d\n",
-	   cmd->host->host_no,
+	   cmd->device->host->host_no,
  	   cmd->device->id,
  	   cmd->device->lun);
      printk("        command = ");
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/cpqfcTSinit.c linux-2.5.54-2/drivers/scsi/cpqfcTSinit.c
--- linux-2.5.54-1/drivers/scsi/cpqfcTSinit.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/cpqfcTSinit.c	2003-01-03 13:58:49.000000000 -0500
@@ -1299,7 +1299,7 @@

  int cpqfcTS_queuecommand(Scsi_Cmnd *Cmnd, void (* done)(Scsi_Cmnd *))
  {
-  struct Scsi_Host *HostAdapter = Cmnd->host;
+  struct Scsi_Host *HostAdapter = Cmnd->device->host;
    CPQFCHBA *cpqfcHBAdata = (CPQFCHBA *)HostAdapter->hostdata;
    PTACHYON fcChip = &cpqfcHBAdata->fcChip;
    TachFCHDR_GCMND fchs;  // only use for FC destination id field
@@ -1477,7 +1477,7 @@
  int cpqfcTS_eh_abort(Scsi_Cmnd *Cmnd)
  {

-  struct Scsi_Host *HostAdapter = Cmnd->host;
+  struct Scsi_Host *HostAdapter = Cmnd->device->host;
    // get the pointer to our Scsi layer HBA buffer
    CPQFCHBA *cpqfcHBAdata = (CPQFCHBA *)HostAdapter->hostdata;
    PTACHYON fcChip = &cpqfcHBAdata->fcChip;
@@ -1670,9 +1670,9 @@
    int retval;
    Scsi_Device *SDpnt = Cmnd->device;
    // printk("   ENTERING cpqfcTS_eh_device_reset() \n");
-  spin_unlock_irq(Cmnd->host->host_lock);
+  spin_unlock_irq(Cmnd->device->host->host_lock);
    retval = cpqfcTS_TargetDeviceReset( SDpnt, 0);
-  spin_lock_irq(Cmnd->host->host_lock);
+  spin_lock_irq(Cmnd->device->host->host_lock);
    return retval;
  }

diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/dpt_i2o.c linux-2.5.54-2/drivers/scsi/dpt_i2o.c
--- linux-2.5.54-1/drivers/scsi/dpt_i2o.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/dpt_i2o.c	2003-01-03 13:58:49.000000000 -0500
@@ -391,7 +391,7 @@
  		return 0;
  	}

-	pHba = (adpt_hba*)cmd->host->hostdata[0];
+	pHba = (adpt_hba*)cmd->device->host->hostdata[0];
  	if (!pHba) {
  		return FAILED;
  	}
@@ -647,7 +647,7 @@
  	if(cmd->serial_number == 0){
  		return FAILED;
  	}
-	pHba = (adpt_hba*) cmd->host->hostdata[0];
+	pHba = (adpt_hba*) cmd->device->host->hostdata[0];
  	printk(KERN_INFO"%s: Trying to Abort cmd=%ld\n",pHba->name, cmd->serial_number);
  	if ((dptdevice = (void*) (cmd->device->hostdata)) == NULL) {
  		printk(KERN_ERR "%s: Unable to abort: No device in cmnd\n",pHba->name);
@@ -685,7 +685,7 @@
  	int old_state;
  	struct adpt_device* d = (void*) cmd->device->hostdata;

-	pHba = (void*) cmd->host->hostdata[0];
+	pHba = (void*) cmd->device->host->hostdata[0];
  	printk(KERN_INFO"%s: Trying to reset device\n",pHba->name);
  	if (!d) {
  		printk(KERN_INFO"%s: Reset Device: Device Not found\n",pHba->name);
@@ -722,7 +722,7 @@
  	adpt_hba* pHba;
  	u32 msg[4];

-	pHba = (adpt_hba*)cmd->host->hostdata[0];
+	pHba = (adpt_hba*)cmd->device->host->hostdata[0];
  	memset(msg, 0, sizeof(msg));
  	printk(KERN_WARNING"%s: Bus reset: SCSI Bus %d: tid: %d\n",pHba->name, cmd->device->channel,pHba->channel[cmd->device->channel].tid );
  	msg[0] = FOUR_WORD_MSG_SIZE|SGL_OFFSET_0;
@@ -743,7 +743,7 @@
  {
  	adpt_hba* pHba;
  	int rcode;
-	pHba = (adpt_hba*)cmd->host->hostdata[0];
+	pHba = (adpt_hba*)cmd->device->host->hostdata[0];
  	printk(KERN_WARNING"%s: Hba Reset: scsi id %d: tid: %d\n",pHba->name,cmd->device->channel,pHba->channel[cmd->device->channel].tid );
  	rcode =  adpt_hba_reset(pHba);
  	if(rcode == 0){
@@ -2216,7 +2216,7 @@
  	// calculate resid for sg
  	cmd->resid = cmd->request_bufflen - readl(reply+5);

-	pHba = (adpt_hba*) cmd->host->hostdata[0];
+	pHba = (adpt_hba*) cmd->device->host->hostdata[0];

  	cmd->sense_buffer[0] = '\0';  // initialize sense valid flag to false

diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/eata.c linux-2.5.54-2/drivers/scsi/eata.c
--- linux-2.5.54-1/drivers/scsi/eata.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/eata.c	2003-01-03 13:58:49.000000000 -0500
@@ -1640,7 +1640,7 @@
     struct mscp *cpp;

     /* j is the board number */
-   j = ((struct hostdata *) SCpnt->host->hostdata)->board_number;
+   j = ((struct hostdata *) SCpnt->device->host->hostdata)->board_number;

     if (SCpnt->host_scribble)
        panic("%s: qcomm, pid %ld, SCpnt %p already active.\n",
@@ -1722,7 +1722,7 @@
  static int eata2x_eh_abort(Scsi_Cmnd *SCarg) {
     unsigned int i, j;

-   j = ((struct hostdata *) SCarg->host->hostdata)->board_number;
+   j = ((struct hostdata *) SCarg->device->host->hostdata)->board_number;

     if (SCarg->host_scribble == NULL) {
        printk("%s: abort, target %d.%d:%d, pid %ld inactive.\n",
@@ -1798,7 +1798,7 @@
     int arg_done = FALSE;
     Scsi_Cmnd *SCpnt;

-   j = ((struct hostdata *) SCarg->host->hostdata)->board_number;
+   j = ((struct hostdata *) SCarg->device->host->hostdata)->board_number;
     printk("%s: reset, enter, target %d.%d:%d, pid %ld.\n",
            BN(j), SCarg->device->channel, SCarg->device->id, SCarg->device->lun, SCarg->pid);

diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/eata_dma.c linux-2.5.54-2/drivers/scsi/eata_dma.c
--- linux-2.5.54-1/drivers/scsi/eata_dma.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/eata_dma.c	2003-01-03 13:58:49.000000000 -0500
@@ -270,7 +270,7 @@
  	    }

  	    cmd = ccb->cmd;
-	    base = (uint) cmd->host->base;
+	    base = (uint) cmd->device->host->base;
         	    hba_stat = sp->hba_stat;
  	
  	    scsi_stat = (sp->scsi_stat >> 1) & 0x1f;
@@ -478,7 +478,7 @@
      queue_counter++;

      hd = HD(cmd);
-    sh = cmd->host;
+    sh = cmd->device->host;

      if (cmd->cmnd[0] == REQUEST_SENSE && cmd->sense_buffer[0] != 0) {
          DBG(DBG_REQSENSE, printk(KERN_DEBUG "Tried to REQUEST SENSE\n"));
@@ -642,7 +642,7 @@
  	}
      }

-    while (inb((u32)(cmd->host->base) + HA_RAUXSTAT) & HA_ABUSY) {
+    while (inb((u32)(cmd->device->host->base) + HA_RAUXSTAT) & HA_ABUSY) {
  	if (--loop == 0) {
  	    printk("eata_dma: abort, timeout error.\n");
  	    DBG(DBG_ABNORM && DBG_DELAY, DELAY(1));
@@ -708,7 +708,7 @@
  	return (SCSI_RESET_ERROR);
      }

-    while (inb((u32)(cmd->host->base) + HA_RAUXSTAT) & HA_ABUSY)
+    while (inb((u32)(cmd->device->host->base) + HA_RAUXSTAT) & HA_ABUSY)
  	if (--loop == 0) {
  	    printk("eata_reset: exit, timeout error.\n");
  	    restore_flags(flags);
@@ -716,7 +716,7 @@
  	    return (SCSI_RESET_ERROR);
  	}

-    for (x = 0; x < cmd->host->can_queue; x++) {
+    for (x = 0; x < cmd->device->host->can_queue; x++) {
  	if (HD(cmd)->ccb[x].status == FREE)
  	    continue;

@@ -743,8 +743,8 @@
      }

      /* hard reset the HBA  */
-    inb((u32) (cmd->host->base) + HA_RSTATUS);	/* This might cause trouble */
-    eata_send_command(0, (u32) cmd->host->base, EATA_CMD_RESET);
+    inb((u32) (cmd->device->host->base) + HA_RSTATUS);	/* This might cause trouble */
+    eata_send_command(0, (u32) cmd->device->host->base, EATA_CMD_RESET);

      HD(cmd)->state = RESET;

@@ -757,7 +757,7 @@
      DBG(DBG_ABNORM, printk("eata_reset: interrupts disabled again.\n"));
      DBG(DBG_ABNORM && DBG_DELAY, DELAY(1));

-    for (x = 0; x < cmd->host->can_queue; x++) {
+    for (x = 0; x < cmd->device->host->can_queue; x++) {
  	
  	/* Skip slots already set free by interrupt and those that
           * are still LOCKED from the last reset */
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/eata_generic.h linux-2.5.54-2/drivers/scsi/eata_generic.h
--- linux-2.5.54-1/drivers/scsi/eata_generic.h	2002-12-15 21:08:09.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/eata_generic.h	2003-01-03 13:58:49.000000000 -0500
@@ -90,7 +90,7 @@
  #define WRITE            1
  #define OTHER            2

-#define HD(cmd)	 ((hostdata *)&(cmd->host->hostdata))
+#define HD(cmd)	 ((hostdata *)&(cmd->device->host->hostdata))
  #define CD(cmd)	 ((struct eata_ccb *)(cmd->host_scribble))
  #define SD(host) ((hostdata *)&(host->hostdata))

diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/eata_pio.c linux-2.5.54-2/drivers/scsi/eata_pio.c
--- linux-2.5.54-1/drivers/scsi/eata_pio.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/eata_pio.c	2003-01-03 13:58:49.000000000 -0500
@@ -157,7 +157,7 @@

  		cp = &hd->ccb[0];
  		cmd = cp->cmd;
-		base = (uint) cmd->host->base;
+		base = (uint) cmd->device->host->base;

  		do {
  			stat = inb(base + HA_RSTATUS);
@@ -286,7 +286,7 @@
  	queue_counter++;

  	hd = HD(cmd);
-	sh = cmd->host;
+	sh = cmd->device->host;
  	base = (uint) sh->base;

  	/* use only slot 0, as 2001 can handle only one cmd at a time */
@@ -378,7 +378,7 @@
  	DBG(DBG_ABNORM, printk(KERN_WARNING "eata_pio_abort called pid: %ld " "target: %x lun: %x reason %x\n", cmd->pid, cmd->device->id, cmd->device->lun, cmd->abort_reason));


-	while (inb(cmd->host->base + HA_RAUXSTAT) & HA_ABUSY)
+	while (inb(cmd->device->host->base + HA_RAUXSTAT) & HA_ABUSY)
  		if (--loop == 0) {
  			printk(KERN_WARNING "eata_pio: abort, timeout error.\n");
  			return FAILED;
@@ -408,7 +408,7 @@
  	uint x, limit = 0;
  	unsigned char success = FALSE;
  	Scsi_Cmnd *sp;
-	struct Scsi_Host *host = cmd->host;
+	struct Scsi_Host *host = cmd->device->host;

  	DBG(DBG_ABNORM, printk(KERN_WARNING "eata_pio_reset called pid:%ld target:" " %x lun: %x reason %x\n", cmd->pid, cmd->device->id, cmd->device->lun, cmd->abort_reason));

@@ -419,7 +419,7 @@

  	/* force all slots to be free */

-	for (x = 0; x < cmd->host->can_queue; x++) {
+	for (x = 0; x < cmd->device->host->can_queue; x++) {

  		if (HD(cmd)->ccb[x].status == FREE)
  			continue;
@@ -433,7 +433,7 @@
  	}

  	/* hard reset the HBA  */
-	outb(EATA_CMD_RESET, (uint) cmd->host->base + HA_WCOMMAND);
+	outb(EATA_CMD_RESET, (uint) cmd->device->host->base + HA_WCOMMAND);

  	DBG(DBG_ABNORM, printk(KERN_WARNING "eata_pio_reset: board reset done.\n"));
  	HD(cmd)->state = RESET;
@@ -445,7 +445,7 @@

  	DBG(DBG_ABNORM, printk(KERN_WARNING "eata_pio_reset: interrupts disabled, " "loops %d.\n", limit));

-	for (x = 0; x < cmd->host->can_queue; x++) {
+	for (x = 0; x < cmd->device->host->can_queue; x++) {

  		/* Skip slots already set free by interrupt */
  		if (HD(cmd)->ccb[x].status != RESET)
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/fdomain.c linux-2.5.54-2/drivers/scsi/fdomain.c
--- linux-2.5.54-1/drivers/scsi/fdomain.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/fdomain.c	2003-01-03 13:58:49.000000000 -0500
@@ -1252,9 +1252,9 @@
  #if EVERY_ACCESS
  	 printk( " AFAIL " );
  #endif
-         spin_lock_irqsave(current_SC->host->host_lock, flags);
+         spin_lock_irqsave(current_SC->device->host->host_lock, flags);
  	 my_done( DID_BUS_BUSY << 16 );
-         spin_unlock_irqrestore(current_SC->host->host_lock, flags);
+         spin_unlock_irqrestore(current_SC->device->host->host_lock, flags);
  	 return;
        }
        current_SC->SCp.phase = in_selection;
@@ -1278,9 +1278,9 @@
  #if EVERY_ACCESS
  	    printk( " SFAIL " );
  #endif
-            spin_lock_irqsave(current_SC->host->host_lock, flags);
+            spin_lock_irqsave(current_SC->device->host->host_lock, flags);
  	    my_done( DID_NO_CONNECT << 16 );
-            spin_unlock_irqrestore(current_SC->host->host_lock, flags);
+            spin_unlock_irqrestore(current_SC->device->host->host_lock, flags);
  	    return;
  	 } else {
  #if EVERY_ACCESS
@@ -1476,10 +1476,10 @@
  #if EVERY_ACCESS
        printk( "BEFORE MY_DONE. . ." );
  #endif
-      spin_lock_irqsave(current_SC->host->host_lock, flags);
+      spin_lock_irqsave(current_SC->device->host->host_lock, flags);
        my_done( (current_SC->SCp.Status & 0xff)
  	       | ((current_SC->SCp.Message & 0xff) << 8) | (DID_OK << 16) );
-      spin_unlock_irqrestore(current_SC->host->host_lock, flags);
+      spin_unlock_irqrestore(current_SC->device->host->host_lock, flags);
  #if EVERY_ACCESS
        printk( "RETURNING.\n" );
  #endif
@@ -1580,13 +1580,13 @@
     unsigned int irr;
     unsigned int isr;

-   if (!SCpnt || !SCpnt->host) {
+   if (!SCpnt || !SCpnt->device || !SCpnt->device->host) {
        printk(KERN_WARNING "scsi: <fdomain> Cannot provide detailed information\n");
        return;
     }

-   printk(KERN_INFO "%s\n", fdomain_16x0_info( SCpnt->host ) );
-   print_banner(SCpnt->host);
+   printk(KERN_INFO "%s\n", fdomain_16x0_info( SCpnt->device->host ) );
+   print_banner(SCpnt->device->host);
     switch (SCpnt->SCp.phase) {
     case in_arbitration: printk("arbitration"); break;
     case in_selection:   printk("selection");   break;
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/gdth.c linux-2.5.54-2/drivers/scsi/gdth.c
--- linux-2.5.54-1/drivers/scsi/gdth.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/gdth.c	2003-01-03 13:58:49.000000000 -0500
@@ -2297,7 +2297,7 @@
      GDTH_LOCK_HA(ha, flags);

      scp->SCp.this_residual = (int)priority;
-    b = virt_ctr ? NUMDATA(scp->host)->busnum : scp->device->channel;
+    b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
      t = scp->device->id;
  #if LINUX_VERSION_CODE >= 0x010300
      if (priority >= DEFAULT_PRI) {
@@ -2358,7 +2358,7 @@
      for (nscp = pscp = ha->req_first; nscp; nscp = (Scsi_Cmnd *)nscp->SCp.ptr) {
          if (nscp != pscp && nscp != (Scsi_Cmnd *)pscp->SCp.ptr)
              pscp = (Scsi_Cmnd *)pscp->SCp.ptr;
-        b = virt_ctr ? NUMDATA(nscp->host)->busnum : nscp->device->channel;
+        b = virt_ctr ? NUMDATA(nscp->device->host)->busnum : nscp->device->channel;
          t = nscp->device->id;
          if (nscp->SCp.this_residual >= DEFAULT_PRI) {
              if ((b != ha->virt_bus && ha->raw[BUS_L2P(ha,b)].lock) ||
@@ -3340,7 +3340,7 @@
      if (rval == 2) {
          gdth_putq(hanum,scp,scp->SCp.this_residual);
      } else if (rval == 1) {
-        GDTH_LOCK_SCSI_DONE(scp->host, flags);
+        GDTH_LOCK_SCSI_DONE(scp->device->host, flags);
          scp->scsi_done(scp);
          GDTH_UNLOCK_SCSI_DONE(scp->host,flags);
      }
@@ -3429,7 +3429,7 @@
          printk("\n");

      } else {
-        b = virt_ctr ? NUMDATA(scp->host)->busnum : scp->device->channel;
+        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
          if (scp->SCp.sent_command == -1 && b != ha->virt_bus) {
              ha->raw[BUS_L2P(ha,b)].io_cnt[scp->device->id]--;
          }
@@ -4469,8 +4469,8 @@
      unchar b;

      TRACE2(("gdth_eh_bus_reset()\n"));
-    hanum = NUMDATA(scp->host)->hanum;
-    b = virt_ctr ? NUMDATA(scp->host)->busnum : scp->device->channel;
+    hanum = NUMDATA(scp->device->host)->hanum;
+    b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
      ha    = HADATA(gdth_ctr_tab[hanum]);

      /* clear command tab */
@@ -4561,7 +4561,7 @@
      scp->SCp.have_data_in = 1;
      scp->SCp.phase = -1;
      scp->SCp.sent_command = -1;
-    hanum = NUMDATA(scp->host)->hanum;
+    hanum = NUMDATA(scp->device->host)->hanum;
  #ifdef GDTH_STATISTICS
      ++act_ios;
  #endif
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/gdth_proc.c linux-2.5.54-2/drivers/scsi/gdth_proc.c
--- linux-2.5.54-1/drivers/scsi/gdth_proc.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/gdth_proc.c	2003-01-03 13:58:49.000000000 -0500
@@ -1383,7 +1383,7 @@

      for (i = 0; i < GDTH_MAXCMDS; ++i) {
          scp = ha->cmd_tab[i].cmnd;
-        b = virt_ctr ? NUMDATA(scp->host)->busnum : scp->device->channel;
+        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
          if (!SPECIAL_SCP(scp) && scp->device->id == (unchar)id &&
              b == (unchar)busnum) {
              scp->SCp.have_data_in = 0;
@@ -1410,7 +1410,7 @@
      GDTH_LOCK_HA(ha, flags);

      for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
-        b = virt_ctr ? NUMDATA(scp->host)->busnum : scp->device->channel;
+        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
          if (scp->device->id == (unchar)id && b == (unchar)busnum) {
              TRACE2(("gdth_stop_timeout(): update_timeout()\n"));
              scp->SCp.buffers_residual = gdth_update_timeout(hanum, scp, 0);
@@ -1430,7 +1430,7 @@
      GDTH_LOCK_HA(ha, flags);

      for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
-        b = virt_ctr ? NUMDATA(scp->host)->busnum : scp->device->channel;
+        b = virt_ctr ? NUMDATA(scp->device->host)->busnum : scp->device->channel;
          if (scp->device->id == (unchar)id && b == (unchar)busnum) {
              TRACE2(("gdth_start_timeout(): update_timeout()\n"));
              gdth_update_timeout(hanum, scp, scp->SCp.buffers_residual);
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/g_NCR5380.c linux-2.5.54-2/drivers/scsi/g_NCR5380.c
--- linux-2.5.54-1/drivers/scsi/g_NCR5380.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/g_NCR5380.c	2003-01-03 13:58:49.000000000 -0500
@@ -742,7 +742,7 @@
  static int sprint_Scsi_Cmnd(char *buffer, int len, Scsi_Cmnd * cmd)
  {
  	int start = len;
-	PRINTP("host number %d destination target %d, lun %d\n" ANDP cmd->host->host_no ANDP cmd->device->id ANDP cmd->device->lun);
+	PRINTP("host number %d destination target %d, lun %d\n" ANDP cmd->device->host->host_no ANDP cmd->device->id ANDP cmd->device->lun);
  	PRINTP("        command = ");
  	len += sprint_command(buffer, len, cmd->cmnd);
  	return len - start;
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/ide-scsi.c linux-2.5.54-2/drivers/scsi/ide-scsi.c
--- linux-2.5.54-1/drivers/scsi/ide-scsi.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/ide-scsi.c	2003-01-03 13:58:49.000000000 -0500
@@ -347,7 +347,7 @@
  			} else printk("\n");
  		}
  	}
-	host = pc->scsi_cmd->host;
+	host = pc->scsi_cmd->device->host;
  	spin_lock_irqsave(host->host_lock, flags);
  	pc->done(pc->scsi_cmd);
  	spin_unlock_irqrestore(host->host_lock, flags);
@@ -851,9 +851,9 @@
  	rq->special = (char *) pc;
  	rq->bio = idescsi_dma_bio (drive, pc);
  	rq->flags = REQ_SPECIAL;
-	spin_unlock_irq(cmd->host->host_lock);
+	spin_unlock_irq(cmd->device->host->host_lock);
  	(void) ide_do_drive_cmd (drive, rq, ide_end);
-	spin_lock_irq(cmd->host->host_lock);
+	spin_lock_irq(cmd->device->host->host_lock);
  	return 0;
  abort:
  	if (pc) kfree (pc);
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/in2000.c linux-2.5.54-2/drivers/scsi/in2000.c
--- linux-2.5.54-1/drivers/scsi/in2000.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/in2000.c	2003-01-03 13:58:49.000000000 -0500
@@ -343,7 +343,7 @@
  	struct IN2000_hostdata *hostdata;
  	Scsi_Cmnd *tmp;

-	instance = cmd->host;
+	instance = cmd->device->host;
  	hostdata = (struct IN2000_hostdata *) instance->hostdata;

  	DB(DB_QUEUE_COMMAND, printk("Q-%d-%02x-%ld(", cmd->device->id, cmd->cmnd[0], cmd->pid))
@@ -428,7 +428,7 @@
   * Go see if any of them are runnable!
   */

-	in2000_execute(cmd->host);
+	in2000_execute(cmd->device->host);

  	DB(DB_QUEUE_COMMAND, printk(")Q-%ld ", cmd->pid))
  	    return 0;
@@ -753,7 +753,7 @@
  	unsigned short f;
  	int i;

-	hostdata = (struct IN2000_hostdata *) cmd->host->hostdata;
+	hostdata = (struct IN2000_hostdata *) cmd->device->host->hostdata;

  /* Normally, you'd expect 'this_residual' to be non-zero here.
   * In a series of scatter-gather transfers, however, this
@@ -1648,7 +1648,7 @@
  	struct IN2000_hostdata *hostdata;
  	int x;

-	instance = cmd->host;
+	instance = cmd->device->host;
  	hostdata = (struct IN2000_hostdata *) instance->hostdata;

  	printk(KERN_WARNING "scsi%d: Reset. ", instance->host_no);
@@ -1693,7 +1693,7 @@
  	uchar sr, asr;
  	unsigned long timeout;

-	instance = cmd->host;
+	instance = cmd->device->host;
  	hostdata = (struct IN2000_hostdata *) instance->hostdata;

  	printk(KERN_DEBUG "scsi%d: Abort-", instance->host_no);
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/ini9100u.c linux-2.5.54-2/drivers/scsi/ini9100u.c
--- linux-2.5.54-1/drivers/scsi/ini9100u.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/ini9100u.c	2003-01-03 13:58:49.000000000 -0500
@@ -528,7 +528,7 @@
  		done(SCpnt);	/* Notify system DONE           */
  		return (0);
  	}
-	pHCB = (HCS *) SCpnt->host->base;
+	pHCB = (HCS *) SCpnt->device->host->base;

  	SCpnt->scsi_done = done;
  	/* Get free SCSI control block  */
@@ -558,7 +558,7 @@
  {
  	HCS *pHCB;

-	pHCB = (HCS *) SCpnt->host->base;
+	pHCB = (HCS *) SCpnt->device->host->base;
  	return tul_abort_srb(pHCB, SCpnt);
  }

@@ -570,7 +570,7 @@
  {				/* I need Host Control Block Information */
  	HCS *pHCB;

-	pHCB = (HCS *) SCpnt->host->base;
+	pHCB = (HCS *) SCpnt->device->host->base;

  	if (reset_flags & (SCSI_RESET_SUGGEST_BUS_RESET | SCSI_RESET_SUGGEST_HOST_RESET))
  		return tul_reset_scsi_bus(pHCB);
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/inia100.c linux-2.5.54-2/drivers/scsi/inia100.c
--- linux-2.5.54-1/drivers/scsi/inia100.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/inia100.c	2003-01-03 13:58:49.000000000 -0500
@@ -523,7 +523,7 @@
  	register ORC_SCB *pSCB;
  	ORC_HCS *pHCB;		/* Point to Host adapter control block */

-	pHCB = (ORC_HCS *) SCpnt->host->hostdata;
+	pHCB = (ORC_HCS *) SCpnt->device->host->hostdata;
  	SCpnt->scsi_done = done;
  	/* Get free SCSI control block  */
  	if ((pSCB = orc_alloc_scb(pHCB)) == NULL) {
@@ -549,7 +549,7 @@
  {
  	ORC_HCS *hcsp;

-	hcsp = (ORC_HCS *) SCpnt->host->hostdata;
+	hcsp = (ORC_HCS *) SCpnt->device->host->hostdata;
  	return orc_abort_srb(hcsp, SCpnt);
  }

@@ -564,7 +564,7 @@
  static int inia100_bus_reset(Scsi_Cmnd * SCpnt)
  {				/* I need Host Control Block Information */
  	ORC_HCS *pHCB;
-	pHCB = (ORC_HCS *) SCpnt->host->hostdata;
+	pHCB = (ORC_HCS *) SCpnt->device->host->hostdata;
  	return orc_reset_scsi_bus(pHCB);
  }

@@ -578,7 +578,7 @@
  static int inia100_device_reset(Scsi_Cmnd * SCpnt)
  {				/* I need Host Control Block Information */
  	ORC_HCS *pHCB;
-	pHCB = (ORC_HCS *) SCpnt->host->hostdata;
+	pHCB = (ORC_HCS *) SCpnt->device->host->hostdata;
  	return orc_device_reset(pHCB, SCpnt, SCpnt->device->id);

  }
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/ips.c linux-2.5.54-2/drivers/scsi/ips.c
--- linux-2.5.54-1/drivers/scsi/ips.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/ips.c	2003-01-03 13:58:49.000000000 -0500
@@ -1417,7 +1417,7 @@
     if (!SC)
        return (FAILED);

-   ha = (ips_ha_t *) SC->host->hostdata;
+   ha = (ips_ha_t *) SC->device->host->hostdata;

     if (!ha)
        return (FAILED);
@@ -1484,7 +1484,7 @@
        return (FAILED);
     }

-   ha = (ips_ha_t *) SC->host->hostdata;
+   ha = (ips_ha_t *) SC->device->host->hostdata;

     if (!ha) {
        DEBUG(1, "Reset called with NULL ha struct");
@@ -1672,7 +1672,7 @@

     METHOD_TRACE("ips_queue", 1);

-   ha = (ips_ha_t *) SC->host->hostdata;
+   ha = (ips_ha_t *) SC->device->host->hostdata;

     if (!ha)
        return (1);
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/megaraid.c linux-2.5.54-2/drivers/scsi/megaraid.c
--- linux-2.5.54-1/drivers/scsi/megaraid.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/megaraid.c	2003-01-03 13:58:49.000000000 -0500
@@ -3535,7 +3535,7 @@
  	mega_scb *pScb;
  	char *user_area = NULL;

-	megaCfg = (mega_host_config *) SCpnt->host->hostdata;
+	megaCfg = (mega_host_config *) SCpnt->device->host->hostdata;
  	DRIVER_LOCK (megaCfg);

  	if (!(megaCfg->flag & (1L << SCpnt->device->channel))) {
@@ -3698,7 +3698,7 @@

  	rc = SCSI_ABORT_NOT_RUNNING;

-	megaCfg = (mega_host_config *) SCpnt->host->hostdata;
+	megaCfg = (mega_host_config *) SCpnt->device->host->hostdata;

  	megaCfg->flag |= IN_ABORT;

@@ -3796,7 +3796,7 @@
  	mega_scb *pScb;

  	rc = SCSI_RESET_NOT_RUNNING;
-	megaCfg = (mega_host_config *) SCpnt->host->hostdata;
+	megaCfg = (mega_host_config *) SCpnt->device->host->hostdata;

  	megaCfg->flag |= IN_RESET;

diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/NCR5380.c linux-2.5.54-2/drivers/scsi/NCR5380.c
--- linux-2.5.54-1/drivers/scsi/NCR5380.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/NCR5380.c	2003-01-03 13:58:49.000000000 -0500
@@ -929,7 +929,7 @@

  static char *lprint_Scsi_Cmnd(Scsi_Cmnd * cmd, char *pos, char *buffer, int length)
  {
-	SPRINTF("scsi%d : destination target %d, lun %d\n", cmd->host->host_no, cmd->device->id, cmd->device->lun);
+	SPRINTF("scsi%d : destination target %d, lun %d\n", cmd->device->host->host_no, cmd->device->id, cmd->device->lun);
  	SPRINTF("        command = ");
  	pos = lprint_command(cmd->cmnd, pos, buffer, length);
  	return (pos);
@@ -1106,7 +1106,7 @@

  static int NCR5380_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
  {
-	struct Scsi_Host *instance = cmd->host;
+	struct Scsi_Host *instance = cmd->device->host;
  	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
  	Scsi_Cmnd *tmp;

@@ -2872,7 +2872,7 @@

  static int NCR5380_abort(Scsi_Cmnd * cmd) {
  	NCR5380_local_declare();
-	struct Scsi_Host *instance = cmd->host;
+	struct Scsi_Host *instance = cmd->device->host;
  	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
  	Scsi_Cmnd *tmp, **prev;
  	
@@ -3031,10 +3031,10 @@

  static int NCR5380_bus_reset(Scsi_Cmnd * cmd) {
  	NCR5380_local_declare();
-	NCR5380_setup(cmd->host);
+	NCR5380_setup(cmd->device->host);

-	NCR5380_print_status(cmd->host);
-	do_reset(cmd->host);
+	NCR5380_print_status(cmd->device->host);
+	do_reset(cmd->device->host);
  	return SUCCESS;
  }

diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/ncr53c8xx.c linux-2.5.54-2/drivers/scsi/ncr53c8xx.c
--- linux-2.5.54-1/drivers/scsi/ncr53c8xx.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/ncr53c8xx.c	2003-01-03 13:58:49.000000000 -0500
@@ -3091,7 +3091,7 @@

  static void PRINT_ADDR(Scsi_Cmnd *cmd)
  {
-	struct host_data *host_data = (struct host_data *) cmd->host->hostdata;
+	struct host_data *host_data = (struct host_data *) cmd->device->host->hostdata;
  	PRINT_LUN(host_data->ncb, cmd->device->id, cmd->device->lun);
  }

@@ -8555,7 +8555,7 @@

  int ncr53c8xx_queue_command (Scsi_Cmnd *cmd, void (* done)(Scsi_Cmnd *))
  {
-     ncb_p np = ((struct host_data *) cmd->host->hostdata)->ncb;
+     ncb_p np = ((struct host_data *) cmd->device->host->hostdata)->ncb;
       unsigned long flags;
       int sts;

@@ -8622,9 +8622,9 @@
       if (DEBUG_FLAGS & DEBUG_TINY) printk ("]\n");

       if (done_list) {
-          NCR_LOCK_SCSI_DONE(done_list->host, flags);
+          NCR_LOCK_SCSI_DONE(done_list->device->host, flags);
            ncr_flush_done_cmds(done_list);
-          NCR_UNLOCK_SCSI_DONE(done_list->host, flags);
+          NCR_UNLOCK_SCSI_DONE(done_list->device->host, flags);
       }
  }

@@ -8645,9 +8645,9 @@
       NCR_UNLOCK_NCB(np, flags);

       if (done_list) {
-          NCR_LOCK_SCSI_DONE(done_list->host, flags);
+          NCR_LOCK_SCSI_DONE(done_list->device->host, flags);
            ncr_flush_done_cmds(done_list);
-          NCR_UNLOCK_SCSI_DONE(done_list->host, flags);
+          NCR_UNLOCK_SCSI_DONE(done_list->device->host, flags);
       }
  }

@@ -8661,7 +8661,7 @@
  int ncr53c8xx_reset(Scsi_Cmnd *cmd)
  #endif
  {
-	ncb_p np = ((struct host_data *) cmd->host->hostdata)->ncb;
+	ncb_p np = ((struct host_data *) cmd->device->host->hostdata)->ncb;
  	int sts;
  	unsigned long flags;
  	Scsi_Cmnd *done_list;
@@ -8723,7 +8723,7 @@

  int ncr53c8xx_abort(Scsi_Cmnd *cmd)
  {
-	ncb_p np = ((struct host_data *) cmd->host->hostdata)->ncb;
+	ncb_p np = ((struct host_data *) cmd->device->host->hostdata)->ncb;
  	int sts;
  	unsigned long flags;
  	Scsi_Cmnd *done_list;
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/nsp32.c linux-2.5.54-2/drivers/scsi/nsp32.c
--- linux-2.5.54-1/drivers/scsi/nsp32.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/nsp32.c	2003-01-03 13:58:49.000000000 -0500
@@ -532,8 +532,8 @@
   */
  static int nsp32hw_start_selection(Scsi_Cmnd *SCpnt, nsp32_hw_data *data)
  {
-	unsigned int   host_id = SCpnt->host->this_id;
-	unsigned int   base    = SCpnt->host->io_port;
+	unsigned int   host_id = SCpnt->device->host->this_id;
+	unsigned int   base    = SCpnt->device->host->io_port;
  	unsigned char  target  = SCpnt->device->id;
  	unsigned char  *param  = data->autoparam;
  	unsigned char  phase, arbit;
@@ -1021,7 +1021,7 @@

  static int nsp32_queuecommand(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
  {
-	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->host->hostdata;
+	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
  	struct nsp32_target *target;
  	struct nsp32_lunt *curlunt;
  	int ret;
@@ -1920,7 +1920,7 @@

  static int nsp32_eh_abort(Scsi_Cmnd *SCpnt)
  {
-	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->host->hostdata;
+	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
  	unsigned int base = data->BaseAddress;

  	nsp32_msg(KERN_WARNING, "abort");
@@ -1942,7 +1942,7 @@

  static int nsp32_eh_bus_reset(Scsi_Cmnd *SCpnt)
  {
-	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->host->hostdata;
+	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
  	unsigned int base = data->BaseAddress;

  	nsp32_msg(KERN_INFO, "Bus Reset");	
@@ -1997,7 +1997,7 @@

  static int nsp32_eh_host_reset(Scsi_Cmnd *SCpnt)
  {
-	struct Scsi_Host *host = SCpnt->host;
+	struct Scsi_Host *host = SCpnt->device->host;
  	nsp32_hw_data *data = (nsp32_hw_data *)host->hostdata;
  	unsigned int base = data->BaseAddress;

diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/pci2000.c linux-2.5.54-2/drivers/scsi/pci2000.c
--- linux-2.5.54-1/drivers/scsi/pci2000.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/pci2000.c	2003-01-03 13:58:49.000000000 -0500
@@ -407,7 +407,7 @@
  int Pci2000_QueueCommand (Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
  	{
  	UCHAR		   *cdb = (UCHAR *)SCpnt->cmnd;					// Pointer to SCSI CDB
-	PADAPTER2000	padapter = HOSTDATA(SCpnt->host);			// Pointer to adapter control structure
+	PADAPTER2000	padapter = HOSTDATA(SCpnt->device->host);			// Pointer to adapter control structure
  	int				rc		 = -1;								// command return code
  	UCHAR			bus		 = SCpnt->device->channel;
  	UCHAR			pun		 = SCpnt->device->id;
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/pci2220i.c linux-2.5.54-2/drivers/scsi/pci2220i.c
--- linux-2.5.54-1/drivers/scsi/pci2220i.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/pci2220i.c	2003-01-03 13:58:49.000000000 -0500
@@ -1156,7 +1156,7 @@
  static void TimerExpiry (unsigned long data)
  	{
  	PADAPTER2220I	padapter = (PADAPTER2220I)data;
-	struct Scsi_Host *host = padapter->SCpnt->host;
+	struct Scsi_Host *host = padapter->SCpnt->device->host;
  	POUR_DEVICE		pdev = padapter->pdev;
  	UCHAR			status = IDE_STATUS_BUSY;
  	UCHAR			temp, temp1;
@@ -1334,7 +1334,7 @@
  static void ReconTimerExpiry (unsigned long data)
  	{
  	PADAPTER2220I	padapter = (PADAPTER2220I)data;
-	struct Scsi_Host *host = padapter->SCpnt->host;
+	struct Scsi_Host *host = padapter->SCpnt->device->host;
  	POUR_DEVICE		pdev;
  	ULONG			testsize = 0;
  	PIDENTIFY_DATA	pid;
@@ -2041,7 +2041,7 @@
  int Pci2220i_QueueCommand (Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
  	{
  	UCHAR		   *cdb = (UCHAR *)SCpnt->cmnd;					// Pointer to SCSI CDB
-	PADAPTER2220I	padapter = HOSTDATA(SCpnt->host);			// Pointer to adapter control structure
+	PADAPTER2220I	padapter = HOSTDATA(SCpnt->device->host);			// Pointer to adapter control structure
  	POUR_DEVICE		pdev	 = &padapter->device[SCpnt->device->id];// Pointer to device information
  	UCHAR			rc;											// command return code
  	int				z;
@@ -2791,7 +2791,7 @@
   ****************************************************************/
  int Pci2220i_Abort (Scsi_Cmnd *SCpnt)
  	{
-	PADAPTER2220I	padapter = HOSTDATA(SCpnt->host);			// Pointer to adapter control structure
+	PADAPTER2220I	padapter = HOSTDATA(SCpnt->device->host);			// Pointer to adapter control structure
  	POUR_DEVICE		pdev	 = &padapter->device[SCpnt->device->id];// Pointer to device information

  	if ( !padapter->SCpnt )
@@ -2823,7 +2823,7 @@
   ****************************************************************/
  int Pci2220i_Reset (Scsi_Cmnd *SCpnt, unsigned int reset_flags)
  	{
-	PADAPTER2220I	padapter = HOSTDATA(SCpnt->host);			// Pointer to adapter control structure
+	PADAPTER2220I	padapter = HOSTDATA(SCpnt->device->host);			// Pointer to adapter control structure
  	POUR_DEVICE		pdev	 = &padapter->device[SCpnt->device->id];// Pointer to device information

  	if ( padapter->atapi )
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/qla1280.c linux-2.5.54-2/drivers/scsi/qla1280.c
--- linux-2.5.54-1/drivers/scsi/qla1280.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/qla1280.c	2003-01-03 13:58:49.000000000 -0500
@@ -1157,7 +1157,7 @@
  	/*ENTER("qla1280_queuecommand");
  	 */

-	host = cmd->host;
+	host = cmd->device->host;
  	ha = (struct scsi_qla_host *)host->hostdata;

  	/* send command to adapter */
@@ -1232,8 +1232,8 @@
  	u16 data;

  	ENTER("qla1280_abort");
-	ha = (struct scsi_qla_host *)cmd->host->hostdata;
-	host = cmd->host;
+	ha = (struct scsi_qla_host *)cmd->device->host->hostdata;
+	host = cmd->device->host;

  	/* Get the SCSI request ptr */
  	sp = (srb_t *)CMD_SP(cmd);
@@ -1365,7 +1365,7 @@
  	u16 data;

  	ENTER("qla1280_abort");
-	host = cmd->host;
+	host = cmd->device->host;
  	ha = (struct scsi_qla_host *)host->hostdata;

  	/* Get the SCSI request ptr */
@@ -1523,7 +1523,7 @@
  		       "pointer, failing.\n");
  		return SCSI_RESET_SNOOZE;
  	}
-	ha = (struct scsi_qla_host *)cmd->host->hostdata;
+	ha = (struct scsi_qla_host *)cmd->device->host->hostdata;
  	sp = (srb_t *)CMD_SP(cmd);

  #if STOP_ON_RESET
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/qlogicfc.c linux-2.5.54-2/drivers/scsi/qlogicfc.c
--- linux-2.5.54-1/drivers/scsi/qlogicfc.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/qlogicfc.c	2003-01-03 13:58:49.000000000 -0500
@@ -1148,7 +1148,7 @@

  	ENTER("isp2x00_queuecommand");

-	host = Cmnd->host;
+	host = Cmnd->device->host;
  	hostdata = (struct isp2x00_hostdata *) host->hostdata;
  	Cmnd->scsi_done = done;

@@ -1709,7 +1709,7 @@

  	ENTER("isp2x00_abort");

-	host = Cmnd->host;
+	host = Cmnd->device->host;
  	hostdata = (struct isp2x00_hostdata *) host->hostdata;

  	for (i = 0; i < QLOGICFC_REQ_QUEUE_LEN; i++)
@@ -1766,7 +1766,7 @@

  	ENTER("isp2x00_reset");

-	host = Cmnd->host;
+	host = Cmnd->device->host;
  	hostdata = (struct isp2x00_hostdata *) host->hostdata;
  	param[0] = MBOX_BUS_RESET;
  	param[1] = 3;
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/qlogicisp.c linux-2.5.54-2/drivers/scsi/qlogicisp.c
--- linux-2.5.54-1/drivers/scsi/qlogicisp.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/qlogicisp.c	2003-01-03 13:58:49.000000000 -0500
@@ -802,7 +802,7 @@

  	ENTER("isp1020_queuecommand");

-	host = Cmnd->host;
+	host = Cmnd->device->host;
  	hostdata = (struct isp1020_hostdata *) host->hostdata;
  	Cmnd->scsi_done = done;

@@ -1175,7 +1175,7 @@

  	ENTER("isp1020_abort");

-	host = Cmnd->host;
+	host = Cmnd->device->host;
  	hostdata = (struct isp1020_hostdata *) host->hostdata;

  	for (i = 0; i < QLOGICISP_REQ_QUEUE_LEN + 1; i++)
@@ -1214,7 +1214,7 @@

  	ENTER("isp1020_reset");

-	host = Cmnd->host;
+	host = Cmnd->device->host;
  	hostdata = (struct isp1020_hostdata *) host->hostdata;

  	param[0] = MBOX_BUS_RESET;
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/scsi.c linux-2.5.54-2/drivers/scsi/scsi.c
--- linux-2.5.54-1/drivers/scsi/scsi.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/scsi.c	2003-01-03 13:58:50.000000000 -0500
@@ -371,7 +371,7 @@

  found:
  	scmnd->request = NULL;
-	atomic_inc(&scmnd->host->host_active);
+	atomic_inc(&scmnd->device->host->host_active);
  	atomic_inc(&scmnd->device->device_active);

  	scmnd->buffer  = NULL;
@@ -399,7 +399,7 @@

  	SCSI_LOG_MLQUEUE(5, printk("Activating command for device %d (%d)\n",
  				scmnd->device->id,
-				atomic_read(&scmnd->host->host_active)));
+				atomic_read(&scmnd->device->host->host_active)));

  	return scmnd;

@@ -421,13 +421,13 @@
  	SCpnt->request = NULL;
  	SCpnt->state = SCSI_STATE_UNUSED;
  	SCpnt->owner = SCSI_OWNER_NOBODY;
-	atomic_dec(&SCpnt->host->host_active);
+	atomic_dec(&SCpnt->device->host->host_active);
  	atomic_dec(&SDpnt->device_active);

  	SCSI_LOG_MLQUEUE(5, printk("Deactivating command for device %d (active=%d, failed=%d)\n",
  				   SCpnt->device->id,
-				   atomic_read(&SCpnt->host->host_active),
-				   SCpnt->host->host_failed));
+				   atomic_read(&SCpnt->device->host->host_active),
+				   SCpnt->device->host->host_failed));

  	if(SDpnt->current_queue_depth > SDpnt->new_queue_depth) {
  		Scsi_Cmnd *prev, *next;
@@ -471,7 +471,6 @@
  		if(newSCpnt) {
  			memset(newSCpnt, 0, sizeof(Scsi_Cmnd));
  			init_timer(&newSCpnt->eh_timeout);
-			newSCpnt->host = SDpnt->host;
  			newSCpnt->device = SDpnt;
  			newSCpnt->request = NULL;
  			newSCpnt->use_sg = 0;
@@ -519,7 +518,7 @@
   */
  int scsi_mlqueue_insert(Scsi_Cmnd * cmd, int reason)
  {
-	struct Scsi_Host *host = cmd->host;
+	struct Scsi_Host *host = cmd->device->host;
  	struct scsi_device *device = cmd->device;

  	SCSI_LOG_MLQUEUE(1,
@@ -646,7 +645,7 @@
  #endif
  #endif

-	host = SCpnt->host;
+	host = SCpnt->device->host;

  	ASSERT_LOCK(host->host_lock, 0);

@@ -692,7 +691,7 @@
  	 */
  	SCSI_LOG_MLQUEUE(3, printk("scsi_dispatch_cmnd (host = %d, channel = %d, target = %d, "
  	       "command = %p, buffer = %p, \nbufflen = %d, done = %p)\n",
-	SCpnt->host->host_no, SCpnt->device->channel, SCpnt->device->id, SCpnt->cmnd,
+	SCpnt->device->host->host_no, SCpnt->device->channel, SCpnt->device->id, SCpnt->cmnd,
  			    SCpnt->buffer, SCpnt->bufflen, SCpnt->done));

  	SCpnt->state = SCSI_STATE_QUEUED;
@@ -704,7 +703,7 @@
  		 * Before we queue this command, check if the command
  		 * length exceeds what the host adapter can handle.
  		 */
-		if (CDB_SIZE(SCpnt) <= SCpnt->host->max_cmd_len) {
+		if (CDB_SIZE(SCpnt) <= SCpnt->device->host->max_cmd_len) {
  			spin_lock_irqsave(host->host_lock, flags);
  			rtn = host->hostt->queuecommand(SCpnt, scsi_done);
  			spin_unlock_irqrestore(host->host_lock, flags);
@@ -902,7 +901,7 @@
   */
  void scsi_init_cmd_from_req(Scsi_Cmnd * SCpnt, Scsi_Request * SRpnt)
  {
-	struct Scsi_Host *host = SCpnt->host;
+	struct Scsi_Host *host = SCpnt->device->host;

  	ASSERT_LOCK(host->host_lock, 0);

@@ -991,7 +990,7 @@
  	      void *buffer, unsigned bufflen, void (*done) (Scsi_Cmnd *),
  		 int timeout, int retries)
  {
-	struct Scsi_Host *host = SCpnt->host;
+	struct Scsi_Host *host = SCpnt->device->host;

  	ASSERT_LOCK(host->host_lock, 0);

@@ -1176,8 +1175,8 @@
  				/*
  				 * Add to BH queue.
  				 */
-				SCSI_LOG_MLCOMPLETE(3, printk("Command finished %d %d 0x%x\n", SCpnt->host->host_busy,
-						SCpnt->host->host_failed,
+				SCSI_LOG_MLCOMPLETE(3, printk("Command finished %d %d 0x%x\n", SCpnt->device->host->host_busy,
+						SCpnt->device->host->host_failed,
  							 SCpnt->result));

  				scsi_finish_command(SCpnt);
@@ -1190,8 +1189,8 @@
  				 * track of the number of tries, so we don't
  				 * end up looping, of course.
  				 */
-				SCSI_LOG_MLCOMPLETE(3, printk("Command needs retry %d %d 0x%x\n", SCpnt->host->host_busy,
-				SCpnt->host->host_failed, SCpnt->result));
+				SCSI_LOG_MLCOMPLETE(3, printk("Command needs retry %d %d 0x%x\n", SCpnt->device->host->host_busy,
+				SCpnt->device->host->host_failed, SCpnt->result));

  				scsi_retry_command(SCpnt);
  				break;
@@ -1217,9 +1216,9 @@
  				 */
  				SCSI_LOG_MLCOMPLETE(3, printk("Command failed %p %x active=%d busy=%d failed=%d\n",
  						    SCpnt, SCpnt->result,
-				  atomic_read(&SCpnt->host->host_active),
-						  SCpnt->host->host_busy,
-					      SCpnt->host->host_failed));
+				  atomic_read(&SCpnt->device->host->host_active),
+						  SCpnt->device->host->host_busy,
+					      SCpnt->device->host->host_failed));

  				/*
  				 * Dump the sense information too.
@@ -1227,12 +1226,12 @@
  				if ((status_byte(SCpnt->result) & CHECK_CONDITION) != 0) {
  					SCSI_LOG_MLCOMPLETE(3, print_sense("bh", SCpnt));
  				}
-				if (SCpnt->host->eh_wait != NULL) {
+				if (SCpnt->device->host->eh_wait != NULL) {
  					scsi_eh_eflags_set(SCpnt, SCSI_EH_CMD_FAILED | SCSI_EH_CMD_ERR);
  					SCpnt->owner = SCSI_OWNER_ERROR_HANDLER;
  					SCpnt->state = SCSI_STATE_FAILED;

-					scsi_host_failed_inc_and_test(SCpnt->host);
+					scsi_host_failed_inc_and_test(SCpnt->device->host);
  				} else {
  					/*
  					 * We only get here if the error
@@ -1284,7 +1283,7 @@
  	Scsi_Device *device;
  	Scsi_Request * SRpnt;

-	host = SCpnt->host;
+	host = SCpnt->device->host;
  	device = SCpnt->device;

  	ASSERT_LOCK(host->host_lock, 0);
@@ -1405,7 +1404,6 @@

  	memset(SCpnt, 0, sizeof(Scsi_Cmnd));
  	init_timer(&SCpnt->eh_timeout);
-	SCpnt->host = SDpnt->host;
  	SCpnt->device = SDpnt;
  	SCpnt->request = NULL;
  	SCpnt->use_sg = 0;
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/scsi_debug.c linux-2.5.54-2/drivers/scsi/scsi_debug.c
--- linux-2.5.54-1/drivers/scsi/scsi_debug.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/scsi_debug.c	2003-01-03 13:58:50.000000000 -0500
@@ -871,7 +871,7 @@
  		if ((devip->channel == scmd->device->channel) &&
  		    (devip->target == scmd->device->id) &&
  		    (devip->lun == scmd->device->lun) &&
-		    (devip->host == scmd->host))
+		    (devip->host == scmd->device->host))
  			return devip;
  	}
  	for (k = 0; k < scsi_debug_num_devs; ++k) {
@@ -880,7 +880,7 @@
  			devip->channel = scmd->device->channel;
  			devip->target = scmd->device->id;
  			devip->lun = scmd->device->lun;
-			devip->host = scmd->host;
+			devip->host = scmd->device->host;
  			devip->reset = 1;
  			devip->used = 1;
  			memset(devip->sense_buff, 0, SDEBUG_SENSE_LEN);
@@ -962,7 +962,7 @@
  	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
  		printk(KERN_INFO "scsi_debug: bus_reset\n");
  	++num_bus_resets;
-	if (SCpnt && ((sdp = SCpnt->device)) && ((hp = SCpnt->host))) {
+	if (SCpnt && ((sdp = SCpnt->device)) && ((hp = SCpnt->device->host))) {
  		for (k = 0; k < scsi_debug_num_devs; ++k) {
  			if (hp == devInfop[k].host)
  				devInfop[k].reset = 1;
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/scsi_error.c linux-2.5.54-2/drivers/scsi/scsi_error.c
--- linux-2.5.54-1/drivers/scsi/scsi_error.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/scsi_error.c	2003-01-03 13:58:50.000000000 -0500
@@ -149,18 +149,18 @@

  	scsi_eh_eflags_set(scmd, SCSI_EH_CMD_TIMEOUT | SCSI_EH_CMD_ERR);

-	if( scmd->host->eh_wait == NULL ) {
+	if( scmd->device->host->eh_wait == NULL ) {
  		panic("Error handler thread not present at %p %p %s %d",
-		      scmd, scmd->host, __FILE__, __LINE__);
+		      scmd, scmd->device->host, __FILE__, __LINE__);
  	}

-	scsi_host_failed_inc_and_test(scmd->host);
+	scsi_host_failed_inc_and_test(scmd->device->host);

  	SCSI_LOG_TIMEOUT(3, printk("Command timed out active=%d busy=%d "
  				   " failed=%d\n",
-				   atomic_read(&scmd->host->host_active),
-				   scmd->host->host_busy,
-				   scmd->host->host_failed));
+				   atomic_read(&scmd->device->host->host_active),
+				   scmd->device->host->host_busy,
+				   scmd->device->host->host_failed));
  }

  /**
@@ -439,8 +439,8 @@
  	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: scmd:%p\n", __FUNCTION__,
  					  scmd));

-	if (scmd->host->eh_action != NULL)
-		up(scmd->host->eh_action);
+	if (scmd->device->host->eh_action != NULL)
+		up(scmd->device->host->eh_action);
  	else
  		printk("%s: eh_action NULL\n", __FUNCTION__);
  }
@@ -471,8 +471,8 @@
  	SCSI_LOG_ERROR_RECOVERY(3, printk("%s scmd: %p result: %x\n",
  					  __FUNCTION__, scmd, scmd->result));

-	if (scmd->host->eh_action != NULL)
-		up(scmd->host->eh_action);
+	if (scmd->device->host->eh_action != NULL)
+		up(scmd->device->host->eh_action);
  }

  /**
@@ -490,7 +490,7 @@
  static int scsi_send_eh_cmnd(Scsi_Cmnd *scmd, int timeout)
  {
  	unsigned long flags;
-	struct Scsi_Host *host = scmd->host;
+	struct Scsi_Host *host = scmd->device->host;
  	int rtn = SUCCESS;

  	ASSERT_LOCK(host->host_lock, 0);
@@ -513,16 +513,16 @@
  		/*
  		 * set up the semaphore so we wait for the command to complete.
  		 */
-		scmd->host->eh_action = &sem;
+		scmd->device->host->eh_action = &sem;
  		scmd->request->rq_status = RQ_SCSI_BUSY;

-		spin_lock_irqsave(scmd->host->host_lock, flags);
+		spin_lock_irqsave(scmd->device->host->host_lock, flags);
  		host->hostt->queuecommand(scmd, scsi_eh_done);
-		spin_unlock_irqrestore(scmd->host->host_lock, flags);
+		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);

  		down(&sem);

-		scmd->host->eh_action = NULL;
+		scmd->device->host->eh_action = NULL;

  		/*
  		 * see if timeout.  if so, tell the host to forget about it.
@@ -542,10 +542,10 @@
  			 * abort a timed out command or not.  not sure how
  			 * we should treat them differently anyways.
  			 */
-			spin_lock_irqsave(scmd->host->host_lock, flags);
-			if (scmd->host->hostt->eh_abort_handler)
-				scmd->host->hostt->eh_abort_handler(scmd);
-			spin_unlock_irqrestore(scmd->host->host_lock, flags);
+			spin_lock_irqsave(scmd->device->host->host_lock, flags);
+			if (scmd->device->host->hostt->eh_abort_handler)
+				scmd->device->host->hostt->eh_abort_handler(scmd);
+			spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
  			
  			scmd->request->rq_status = RQ_SCSI_DONE;
  			scmd->owner = SCSI_OWNER_ERROR_HANDLER;
@@ -613,7 +613,7 @@
  	memcpy((void *) scmd->cmnd, (void *) generic_sense,
  	       sizeof(generic_sense));

-	scsi_result = (!scmd->host->hostt->unchecked_isa_dma)
+	scsi_result = (!scmd->device->host->hostt->unchecked_isa_dma)
  	    ? &scsi_result0[0] : kmalloc(512, GFP_ATOMIC | GFP_DMA);

  	if (scsi_result == NULL) {
@@ -803,7 +803,7 @@
  	int rtn = FAILED;
  	unsigned long flags;

-	if (scmd->host->hostt->eh_abort_handler == NULL) {
+	if (scmd->device->host->hostt->eh_abort_handler == NULL) {
  		return rtn;
  	}
  	/*
@@ -815,9 +815,9 @@

  	scmd->owner = SCSI_OWNER_LOWLEVEL;

-	spin_lock_irqsave(scmd->host->host_lock, flags);
-	rtn = scmd->host->hostt->eh_abort_handler(scmd);
-	spin_unlock_irqrestore(scmd->host->host_lock, flags);
+	spin_lock_irqsave(scmd->device->host->host_lock, flags);
+	rtn = scmd->device->host->hostt->eh_abort_handler(scmd);
+	spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
  	return rtn;
  }

@@ -925,14 +925,14 @@
  	unsigned long flags;
  	int rtn = FAILED;

-	if (scmd->host->hostt->eh_device_reset_handler == NULL) {
+	if (scmd->device->host->hostt->eh_device_reset_handler == NULL) {
  		return rtn;
  	}
  	scmd->owner = SCSI_OWNER_LOWLEVEL;

-	spin_lock_irqsave(scmd->host->host_lock, flags);
-	rtn = scmd->host->hostt->eh_device_reset_handler(scmd);
-	spin_unlock_irqrestore(scmd->host->host_lock, flags);
+	spin_lock_irqsave(scmd->device->host->host_lock, flags);
+	rtn = scmd->device->host->hostt->eh_device_reset_handler(scmd);
+	spin_unlock_irqrestore(scmd->device->host->host_lock, flags);

  	if (rtn == SUCCESS) {
  		scmd->device->was_reset = 1;
@@ -1003,19 +1003,19 @@
  	scmd->owner = SCSI_OWNER_LOWLEVEL;
  	scmd->serial_number_at_timeout = scmd->serial_number;

-	if (scmd->host->hostt->eh_bus_reset_handler == NULL)
+	if (scmd->device->host->hostt->eh_bus_reset_handler == NULL)
  		return FAILED;

-	spin_lock_irqsave(scmd->host->host_lock, flags);
-	rtn = scmd->host->hostt->eh_bus_reset_handler(scmd);
-	spin_unlock_irqrestore(scmd->host->host_lock, flags);
+	spin_lock_irqsave(scmd->device->host->host_lock, flags);
+	rtn = scmd->device->host->hostt->eh_bus_reset_handler(scmd);
+	spin_unlock_irqrestore(scmd->device->host->host_lock, flags);

  	if (rtn == SUCCESS) {
  		scsi_sleep(BUS_RESET_SETTLE_TIME);
  		/*
  		 * Mark all affected devices to expect a unit attention.
  		 */
-		list_for_each_entry(sdev, &scmd->host->my_devices, siblings)
+		list_for_each_entry(sdev, &scmd->device->host->my_devices, siblings)
  			if (scmd->device->channel == sdev->channel) {
  				sdev->was_reset = 1;
  				sdev->expecting_cc_ua = 1;
@@ -1039,19 +1039,19 @@
  	scmd->owner = SCSI_OWNER_LOWLEVEL;
  	scmd->serial_number_at_timeout = scmd->serial_number;

-	if (scmd->host->hostt->eh_host_reset_handler == NULL)
+	if (scmd->device->host->hostt->eh_host_reset_handler == NULL)
  		return FAILED;

-	spin_lock_irqsave(scmd->host->host_lock, flags);
-	rtn = scmd->host->hostt->eh_host_reset_handler(scmd);
-	spin_unlock_irqrestore(scmd->host->host_lock, flags);
+	spin_lock_irqsave(scmd->device->host->host_lock, flags);
+	rtn = scmd->device->host->hostt->eh_host_reset_handler(scmd);
+	spin_unlock_irqrestore(scmd->device->host->host_lock, flags);

  	if (rtn == SUCCESS) {
  		scsi_sleep(HOST_RESET_SETTLE_TIME);
  		/*
  		 * Mark all affected devices to expect a unit attention.
  		 */
-		list_for_each_entry(sdev, &scmd->host->my_devices, siblings)
+		list_for_each_entry(sdev, &scmd->device->host->my_devices, siblings)
  			if (scmd->device->channel == sdev->channel) {
  				sdev->was_reset = 1;
  				sdev->expecting_cc_ua = 1;
@@ -1348,7 +1348,7 @@

  	case RESERVATION_CONFLICT:
  		printk("scsi%d (%d,%d,%d) : reservation conflict\n",
-		       scmd->host->host_no, scmd->device->channel,
+		       scmd->device->host->host_no, scmd->device->channel,
  		       scmd->device->id, scmd->device->lun);
  		return SUCCESS; /* causes immediate i/o error */
  	default:
@@ -1764,7 +1764,6 @@

  	SCpnt->request = &req;
  	memset(&SCpnt->eh_timeout, 0, sizeof(SCpnt->eh_timeout));
-	SCpnt->host                    	= dev->host;
  	SCpnt->device                  	= dev;
  	SCpnt->request->rq_status      	= RQ_SCSI_BUSY;
  	SCpnt->request->waiting        	= NULL;
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/scsi.h linux-2.5.54-2/drivers/scsi/scsi.h
--- linux-2.5.54-1/drivers/scsi/scsi.h	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/scsi.h	2003-01-03 13:58:50.000000000 -0500
@@ -728,7 +728,6 @@
  struct scsi_cmnd {
  	int     sc_magic;

-	struct Scsi_Host   *host;
  	struct scsi_device *device;
  	unsigned short state;
  	unsigned short owner;
@@ -776,6 +775,8 @@
  /* 	unsigned int target; */
  /* 	unsigned int lun; */
  /* 	unsigned int channel; */
+/* OBSOLETE, use cmd->device->host instead */	
+/* 	struct Scsi_Host   *host; */

  	unsigned char cmd_len;
  	unsigned char old_cmd_len;
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/scsi_lib.c linux-2.5.54-2/drivers/scsi/scsi_lib.c
--- linux-2.5.54-1/drivers/scsi/scsi_lib.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/scsi_lib.c	2003-01-03 13:58:50.000000000 -0500
@@ -428,7 +428,7 @@
  {
  	struct request *req = SCpnt->request;

-	ASSERT_LOCK(SCpnt->host->host_lock, 0);
+	ASSERT_LOCK(SCpnt->device->host->host_lock, 0);

  	/*
  	 * Free up any indirection buffers we allocated for DMA purposes.
@@ -653,7 +653,7 @@
  		case MEDIUM_ERROR:
  		case VOLUME_OVERFLOW:
  			printk("scsi%d: ERROR on channel %d, id %d, lun %d, CDB: ",
-			       SCpnt->host->host_no, (int) SCpnt->device->channel,
+			       SCpnt->device->host->host_no, (int) SCpnt->device->channel,
  			       (int) SCpnt->device->id, (int) SCpnt->device->lun);
  			print_command(SCpnt->data_cmnd);
  			print_sense("sd", SCpnt);
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/scsi_proc.c linux-2.5.54-2/drivers/scsi/scsi_proc.c
--- linux-2.5.54-1/drivers/scsi/scsi_proc.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/scsi_proc.c	2003-01-03 13:58:50.000000000 -0500
@@ -365,7 +365,7 @@
  				printk(KERN_INFO "(%3d) %2d:%1d:%2d:%2d (%6s %4llu %4ld %4ld %4x %1d) (%1d %1d 0x%2x) (%4d %4d %4d) 0x%2.2x 0x%2.2x 0x%8.8x\n",
  				       i++,

-				       SCpnt->host->host_no,
+				       SCpnt->device->host->host_no,
  				       SCpnt->device->channel,
                                         SCpnt->device->id,
                                         SCpnt->device->lun,
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/sym53c8xx_2/sym_glue.c linux-2.5.54-2/drivers/scsi/sym53c8xx_2/sym_glue.c
--- linux-2.5.54-1/drivers/scsi/sym53c8xx_2/sym_glue.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/sym53c8xx_2/sym_glue.c	2003-01-03 13:58:50.000000000 -0500
@@ -330,7 +330,7 @@

  #define SYM_UCMD_PTR(cmd)  ((ucmd_p)(&(cmd)->SCp))
  #define SYM_SCMD_PTR(ucmd) sym_que_entry(ucmd, Scsi_Cmnd, SCp)
-#define SYM_SOFTC_PTR(cmd) (((struct host_data *)cmd->host->hostdata)->ncb)
+#define SYM_SOFTC_PTR(cmd) (((struct host_data *)cmd->device->host->hostdata)->ncb)

  /*
   *  Deal with DMA mapping/unmapping.
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/sym53c8xx.c linux-2.5.54-2/drivers/scsi/sym53c8xx.c
--- linux-2.5.54-1/drivers/scsi/sym53c8xx.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/sym53c8xx.c	2003-01-03 13:58:50.000000000 -0500
@@ -4735,7 +4735,7 @@

  static void PRINT_ADDR(Scsi_Cmnd *cmd)
  {
-	struct host_data *host_data = (struct host_data *) cmd->host->hostdata;
+	struct host_data *host_data = (struct host_data *) cmd->device->host->hostdata;
  	PRINT_LUN(host_data->ncb, cmd->device->id, cmd->device->lun);
  }

@@ -13592,7 +13592,7 @@

  int sym53c8xx_queue_command (Scsi_Cmnd *cmd, void (* done)(Scsi_Cmnd *))
  {
-     ncb_p np = ((struct host_data *) cmd->host->hostdata)->ncb;
+     ncb_p np = ((struct host_data *) cmd->device->host->hostdata)->ncb;
       unsigned long flags;
       int sts;

@@ -13661,9 +13661,9 @@
       if (DEBUG_FLAGS & DEBUG_TINY) printk ("]\n");

       if (done_list) {
-          NCR_LOCK_SCSI_DONE(done_list->host, flags);
+          NCR_LOCK_SCSI_DONE(done_list->device->host, flags);
            ncr_flush_done_cmds(done_list);
-          NCR_UNLOCK_SCSI_DONE(done_list->host, flags);
+          NCR_UNLOCK_SCSI_DONE(done_list->device->host, flags);
       }
  }

@@ -13684,9 +13684,9 @@
       NCR_UNLOCK_NCB(np, flags);

       if (done_list) {
-          NCR_LOCK_SCSI_DONE(done_list->host, flags);
+          NCR_LOCK_SCSI_DONE(done_list->device->host, flags);
            ncr_flush_done_cmds(done_list);
-          NCR_UNLOCK_SCSI_DONE(done_list->host, flags);
+          NCR_UNLOCK_SCSI_DONE(done_list->device->host, flags);
       }
  }

@@ -13700,7 +13700,7 @@
  int sym53c8xx_reset(Scsi_Cmnd *cmd)
  #endif
  {
-	ncb_p np = ((struct host_data *) cmd->host->hostdata)->ncb;
+	ncb_p np = ((struct host_data *) cmd->device->host->hostdata)->ncb;
  	int sts;
  	unsigned long flags;
  	Scsi_Cmnd *done_list;
@@ -13762,7 +13762,7 @@

  int sym53c8xx_abort(Scsi_Cmnd *cmd)
  {
-	ncb_p np = ((struct host_data *) cmd->host->hostdata)->ncb;
+	ncb_p np = ((struct host_data *) cmd->device->host->hostdata)->ncb;
  	int sts;
  	unsigned long flags;
  	Scsi_Cmnd *done_list;
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/tmscsim.c linux-2.5.54-2/drivers/scsi/tmscsim.c
--- linux-2.5.54-1/drivers/scsi/tmscsim.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/tmscsim.c	2003-01-03 13:58:50.000000000 -0500
@@ -1223,7 +1223,7 @@
      PDCB   pDCB;
      PSRB   pSRB;
      DC390_AFLAGS
-    PACB   pACB = (PACB) cmd->host->hostdata;
+    PACB   pACB = (PACB) cmd->device->host->hostdata;


      DEBUG0(/*  if(pACB->scan_devices) */	\
@@ -1547,7 +1547,7 @@
      int   status;
      //ULONG sbac;
      DC390_AFLAGS
-    PACB  pACB = (PACB) cmd->host->hostdata;
+    PACB  pACB = (PACB) cmd->device->host->hostdata;

      DC390_LOCK_ACB;

@@ -1785,7 +1785,7 @@
  {
      UCHAR   bval;
      DC390_AFLAGS
-    PACB    pACB = (PACB) cmd->host->hostdata;
+    PACB    pACB = (PACB) cmd->device->host->hostdata;

      printk(KERN_INFO "DC390: RESET ... ");

@@ -2361,7 +2361,7 @@
  	   cmd->device->id, cmd->device->lun, cmd->result);
     if (cmd->result)
     {
-	PACB pACB = (PACB)cmd->host->hostdata;
+	PACB pACB = (PACB)cmd->device->host->hostdata;
  	PDCB pDCB = dc390_findDCB (pACB, cmd->device->id, cmd->device->lun);
  	printk ("DC390: Unsetting DsCn, Sync and TagQ!\n");
  	if (pDCB)
@@ -2387,7 +2387,8 @@
     cmd->cmnd[4] = 0xff;

     cmd->cmd_len = 6; cmd->old_cmd_len = 6;
-   cmd->host = pACB->pScsiHost;
+/* TODO FIXME */
+/*    cmd->host = pACB->pScsiHost; */
     cmd->device->id = pDCB->TargetID;
     cmd->device->lun = pDCB->TargetLUN;
     cmd->serial_number = 1;
@@ -2437,7 +2438,8 @@
     cmd->cmnd[4] = 0x01; /* START */

     cmd->cmd_len = 6; cmd->old_cmd_len = 6;
-   cmd->host = pACB->pScsiHost;
+/* TODO FIXME */
+/*    cmd->host = pACB->pScsiHost; */
     cmd->device->id = pDCB->TargetID;
     cmd->device->lun = pDCB->TargetLUN;
     cmd->serial_number = 1;
@@ -2734,7 +2736,9 @@

   reset:
       {
-	Scsi_Cmnd cmd; cmd.host = pACB->pScsiHost;
+	Scsi_Cmnd cmd;
+	/* TODO FIXME */
+	/* cmd.host = pACB->pScsiHost; */
  	printk (KERN_WARNING "DC390: Driver reset requested!\n");
  	DC390_UNLOCK_ACB;
  	DC390_reset (&cmd, 0);
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/scsi/u14-34f.c linux-2.5.54-2/drivers/scsi/u14-34f.c
--- linux-2.5.54-1/drivers/scsi/u14-34f.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/scsi/u14-34f.c	2003-01-03 13:58:50.000000000 -0500
@@ -1213,7 +1213,7 @@
     struct mscp *cpp;

     /* j is the board number */
-   j = ((struct hostdata *) SCpnt->host->hostdata)->board_number;
+   j = ((struct hostdata *) SCpnt->device->host->hostdata)->board_number;

     if (SCpnt->host_scribble)
        panic("%s: qcomm, pid %ld, SCpnt %p already active.\n",
@@ -1292,7 +1292,7 @@
  static int u14_34f_eh_abort(Scsi_Cmnd *SCarg) {
     unsigned int i, j;

-   j = ((struct hostdata *) SCarg->host->hostdata)->board_number;
+   j = ((struct hostdata *) SCarg->device->host->hostdata)->board_number;

     if (SCarg->host_scribble == NULL) {
        printk("%s: abort, target %d.%d:%d, pid %ld inactive.\n",
@@ -1368,7 +1368,7 @@
     int arg_done = FALSE;
     Scsi_Cmnd *SCpnt;

-   j = ((struct hostdata *) SCarg->host->hostdata)->board_number;
+   j = ((struct hostdata *) SCarg->device->host->hostdata)->board_number;
     printk("%s: reset, enter, target %d.%d:%d, pid %ld.\n",
            BN(j), SCarg->device->channel, SCarg->device->id, SCarg->device->lun, SCarg->pid);

diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/usb/storage/scsiglue.c linux-2.5.54-2/drivers/usb/storage/scsiglue.c
--- linux-2.5.54-1/drivers/usb/storage/scsiglue.c	2002-12-15 21:07:58.000000000 -0500
+++ linux-2.5.54-2/drivers/usb/storage/scsiglue.c	2003-01-03 13:58:50.000000000 -0500
@@ -141,7 +141,7 @@
  /* This is always called with scsi_lock(srb->host) held */
  static int queuecommand( Scsi_Cmnd *srb , void (*done)(Scsi_Cmnd *))
  {
-	struct us_data *us = (struct us_data *)srb->host->hostdata[0];
+	struct us_data *us = (struct us_data *)srb->device->host->hostdata[0];

  	US_DEBUGP("queuecommand() called\n");
  	srb->host_scribble = (unsigned char *)us;
@@ -166,7 +166,7 @@
  /* This is always called with scsi_lock(srb->host) held */
  static int command_abort( Scsi_Cmnd *srb )
  {
-	struct us_data *us = (struct us_data *)srb->host->hostdata[0];
+	struct us_data *us = (struct us_data *)srb->device->host->hostdata[0];

  	US_DEBUGP("command_abort() called\n");

@@ -185,7 +185,7 @@
  /* This is always called with scsi_lock(srb->host) held */
  static int device_reset( Scsi_Cmnd *srb )
  {
-	struct us_data *us = (struct us_data *)srb->host->hostdata[0];
+	struct us_data *us = (struct us_data *)srb->device->host->hostdata[0];
  	int result;

  	US_DEBUGP("device_reset() called\n" );
@@ -193,7 +193,7 @@

  	/* set the state and release the lock */
  	atomic_set(&us->sm_state, US_STATE_RESETTING);
-	scsi_unlock(srb->host);
+	scsi_unlock(srb->device->host);

  	/* lock the device pointers */
  	down(&(us->dev_semaphore));
@@ -206,7 +206,7 @@
  	up(&(us->dev_semaphore));

  	/* lock access to the state and clear it */
-	scsi_lock(srb->host);
+	scsi_lock(srb->device->host);
  	atomic_set(&us->sm_state, US_STATE_IDLE);
  	return result;
  }
@@ -217,7 +217,7 @@
  /* This is always called with scsi_lock(srb->host) held */
  static int bus_reset( Scsi_Cmnd *srb )
  {
-	struct us_data *us = (struct us_data *)srb->host->hostdata[0];
+	struct us_data *us = (struct us_data *)srb->device->host->hostdata[0];
  	int i;
  	int result;
  	struct usb_device *pusb_dev_save;
@@ -225,14 +225,14 @@
  	/* we use the usb_reset_device() function to handle this for us */
  	US_DEBUGP("bus_reset() called\n");

-	scsi_unlock(srb->host);
+	scsi_unlock(srb->device->host);

  	/* if the device has been removed, this worked */
  	down(&us->dev_semaphore);
  	if (!(us->flags & US_FL_DEV_ATTACHED)) {
  		US_DEBUGP("-- device removed already\n");
  		up(&us->dev_semaphore);
-		scsi_lock(srb->host);
+		scsi_lock(srb->device->host);
  		return SUCCESS;
  	}
  	pusb_dev_save = us->pusb_dev;
@@ -242,7 +242,7 @@
  	result = usb_reset_device(pusb_dev_save);
  	US_DEBUGP("usb_reset_device returns %d\n", result);
  	if (result < 0) {
-		scsi_lock(srb->host);
+		scsi_lock(srb->device->host);
  		return FAILED;
  	}

@@ -266,7 +266,7 @@
  		usb_device_probe (&intf->dev);
  	}
  	US_DEBUGP("bus_reset() complete\n");
-	scsi_lock(srb->host);
+	scsi_lock(srb->device->host);
  	return SUCCESS;
  }

diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/usb/storage/transport.c linux-2.5.54-2/drivers/usb/storage/transport.c
--- linux-2.5.54-1/drivers/usb/storage/transport.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/usb/storage/transport.c	2003-01-03 13:58:50.000000000 -0500
@@ -998,7 +998,7 @@

  	/* set state to abort and release the lock */
  	atomic_set(&us->sm_state, US_STATE_ABORTING);
-	host = us->srb->host;
+	host = us->srb->device->host;
  	scsi_unlock(host);

  	/* If the state machine is blocked waiting for an URB,
diff -Naur -X /usr/src/dontdiff linux-2.5.54-1/drivers/usb/storage/usb.c linux-2.5.54-2/drivers/usb/storage/usb.c
--- linux-2.5.54-1/drivers/usb/storage/usb.c	2003-01-03 12:19:16.000000000 -0500
+++ linux-2.5.54-2/drivers/usb/storage/usb.c	2003-01-03 13:58:50.000000000 -0500
@@ -342,7 +342,7 @@
  			US_DEBUGP("-- exit command received\n");
  			break;
  		}
-		host = us->srb->host;
+		host = us->srb->device->host;

  		/* lock access to the state */
  		scsi_lock(host);

