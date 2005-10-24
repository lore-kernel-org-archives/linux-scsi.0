From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH RFC 8/n] HCIL drivers update
Date: Sun, 23 Oct 2005 23:52:25 -0400
Message-ID: <20051024035225.GB28581@havoc.gtf.org>
References: <20051023024104.GA20128@havoc.gtf.org> <20051023195128.GA12102@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:51692 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1750959AbVJXDw0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 23:52:26 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id EE30E1C092BD
	for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2005 23:52:25 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9O3qPUR028798
	for linux-scsi@vger.kernel.org; Sun, 23 Oct 2005 23:52:25 -0400
Content-Disposition: inline
In-Reply-To: <20051023195128.GA12102@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


more sdev->{command,id,lun} work.  'make allmodconfig' succeeds now.

stuff remaining:
* drivers that aren't built anywhere (why are the they in the tree??)
* drivers not built on x86
* debug code that's disabled at compile time by default


 drivers/scsi/3w-9xxx.c     |   16 ++++++++++------
 drivers/scsi/3w-xxxx.c     |   32 +++++++++++++++++++-------------
 drivers/scsi/aic7xxx_old.c |   20 +++++++++++---------
 drivers/scsi/ch.c          |   30 ++++++++++++++++--------------
 drivers/scsi/imm.c         |    2 +-
 drivers/scsi/ipr.c         |   29 +++++++++++++++++++++--------
 drivers/scsi/ipr.h         |    5 ++---
 drivers/scsi/nsp32.c       |   22 +++++++++++-----------
 drivers/scsi/osst.c        |    6 +++---
 drivers/scsi/ppa.c         |    2 +-
 drivers/scsi/scsi_debug.c  |   32 +++++++++++++++-----------------
 drivers/scsi/st.c          |   11 +++++------
 12 files changed, 115 insertions(+), 92 deletions(-)

e3f9d8729c63bd05ec9c342dcb357b1097791912
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index a748fbf..f80becd 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1732,7 +1732,9 @@ static int twa_scsi_eh_reset(struct scsi
 
 	tw_dev->num_resets++;
 
-	printk(KERN_WARNING "3w-9xxx: scsi%d: WARNING: (0x%02X:0x%04X): Unit #%d: Command (0x%x) timed out, resetting card.\n", tw_dev->host->host_no, TW_DRIVER, 0x2c, SCpnt->device->id, SCpnt->cmnd[0]);
+	sdev_printk(KERN_WARNING, SCpnt->device,
+		"WARNING: (0x%02X:0x%04X): Command (0x%x) timed out, resetting card.\n",
+		TW_DRIVER, 0x2c, SCpnt->cmnd[0]);
 
 	/* Now reset the card and some of the device extension data */
 	if (twa_reset_device_extension(tw_dev, 0)) {
@@ -1752,7 +1754,7 @@ static int twa_scsi_queue(struct scsi_cm
 	TW_Device_Extension *tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
 
 	/* Check if this FW supports luns */
-	if ((SCpnt->device->lun != 0) && (tw_dev->working_srl < TW_FW_SRL_LUNS_SUPPORTED)) {
+	if ((!scsilun_zero(&SCpnt->device->lun)) && (tw_dev->working_srl < TW_FW_SRL_LUNS_SUPPORTED)) {
 		SCpnt->result = (DID_BAD_TARGET << 16);
 		done(SCpnt);
 		retval = 0;
@@ -1823,9 +1825,9 @@ static int twa_scsiop_execute_scsi(TW_De
 		memcpy(command_packet->cdb, cdb, TW_MAX_CDB_LEN);
 
 	if (srb) {
-		command_packet->unit = srb->device->id;
+		command_packet->unit = sdev_id(srb->device);
 		command_packet->request_id__lunl =
-			TW_REQ_LUN_IN(srb->device->lun, request_id);
+			TW_REQ_LUN_IN(scsilun_to_int(&srb->device->lun), request_id);
 	} else {
 		command_packet->request_id__lunl =
 			TW_REQ_LUN_IN(0, request_id);
@@ -1850,7 +1852,8 @@ static int twa_scsiop_execute_scsi(TW_De
 				command_packet->sg_list[0].address = buffaddr;
 				command_packet->sg_list[0].length = tw_dev->srb[request_id]->request_bufflen;
 			}
-			command_packet->sgl_entries__lunh = TW_REQ_LUN_IN((srb->device->lun >> 4), 1);
+			command_packet->sgl_entries__lunh =
+				TW_REQ_LUN_IN((scsilun_to_int(&srb->device->lun) >> 4), 1);
 
 			if (command_packet->sg_list[0].address & TW_ALIGNMENT_9000_SGL) {
 				TW_PRINTK(tw_dev->host, TW_DRIVER, 0x2d, "Found unaligned address during execute scsi");
@@ -1882,7 +1885,8 @@ static int twa_scsiop_execute_scsi(TW_De
 					}
 				}
 			}
-			command_packet->sgl_entries__lunh = TW_REQ_LUN_IN((srb->device->lun >> 4), tw_dev->srb[request_id]->use_sg);
+			command_packet->sgl_entries__lunh =
+				TW_REQ_LUN_IN((scsilun_to_int(&srb->device->lun) >> 4), tw_dev->srb[request_id]->use_sg);
 		}
 	} else {
 		/* Internal cdb post */
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index ae9e020..ba78f75 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1432,7 +1432,9 @@ static int tw_scsi_eh_reset(struct scsi_
 
 	tw_dev->num_resets++;
 
-	printk(KERN_WARNING "3w-xxxx: scsi%d: WARNING: Unit #%d: Command (0x%x) timed out, resetting card.\n", tw_dev->host->host_no, SCpnt->device->id, SCpnt->cmnd[0]);
+	sdev_printk(KERN_WARNING, SCpnt->device,
+		"WARNING: Command (0x%x) timed out, resetting card.\n",
+		SCpnt->cmnd[0]);
 
 	/* Now reset the card and some of the device extension data */
 	if (tw_reset_device_extension(tw_dev, 0)) {
@@ -1541,7 +1543,8 @@ static int tw_scsiop_inquiry_complete(TW
 	request_buffer[2] = 0;	       /* No ansi/iso compliance */
 	request_buffer[4] = 31;	       /* Additional length */
 	memcpy(&request_buffer[8], "3ware   ", 8);	 /* Vendor ID */
-	sprintf(&request_buffer[16], "Logical Disk %-2d ", tw_dev->srb[request_id]->device->id);
+	sprintf(&request_buffer[16], "Logical Disk %-2d ",
+		sdev_id(tw_dev->srb[request_id]->device));
 	memcpy(&request_buffer[32], TW_DRIVER_VERSION, 3);
 	tw_transfer_internal(tw_dev, request_id, request_buffer,
 			     sizeof(request_buffer));
@@ -1553,10 +1556,10 @@ static int tw_scsiop_inquiry_complete(TW
 	}
 	is_unit_present = &(param->data[0]);
 
-	if (is_unit_present[tw_dev->srb[request_id]->device->id] & TW_UNIT_ONLINE) {
-		tw_dev->is_unit_present[tw_dev->srb[request_id]->device->id] = 1;
+	if (is_unit_present[sdev_id(tw_dev->srb[request_id]->device)] & TW_UNIT_ONLINE) {
+		tw_dev->is_unit_present[sdev_id(tw_dev->srb[request_id]->device)] = 1;
 	} else {
-		tw_dev->is_unit_present[tw_dev->srb[request_id]->device->id] = 0;
+		tw_dev->is_unit_present[sdev_id(tw_dev->srb[request_id]->device)] = 0;
 		tw_dev->srb[request_id]->result = (DID_BAD_TARGET << 16);
 		return TW_ISR_DONT_RESULT;
 	}
@@ -1607,7 +1610,8 @@ static int tw_scsiop_mode_sense(TW_Devic
 
 	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
 	memset(param, 0, sizeof(TW_Sector));
-	param->table_id = TW_UNIT_INFORMATION_TABLE_BASE + tw_dev->srb[request_id]->device->id;
+	param->table_id = TW_UNIT_INFORMATION_TABLE_BASE +
+		sdev_id(tw_dev->srb[request_id]->device);
 	param->parameter_id = 7; /* unit flags */
 	param->parameter_size_bytes = 1;
 	param_value = tw_dev->alignment_physical_address[request_id];
@@ -1684,7 +1688,8 @@ static int tw_scsiop_read_capacity(TW_De
 	command_packet->opcode__sgloffset = TW_OPSGL_IN(2, TW_OP_GET_PARAM);
 	command_packet->size = 4;
 	command_packet->request_id = request_id;
-	command_packet->unit__hostid = TW_UNITHOST_IN(0, tw_dev->srb[request_id]->device->id);
+	command_packet->unit__hostid =
+		TW_UNITHOST_IN(0, sdev_id(tw_dev->srb[request_id]->device));
 	command_packet->status = 0;
 	command_packet->flags = 0;
 	command_packet->byte6.block_count = 1;
@@ -1697,7 +1702,7 @@ static int tw_scsiop_read_capacity(TW_De
 	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
 	memset(param, 0, sizeof(TW_Sector));
 	param->table_id = TW_UNIT_INFORMATION_TABLE_BASE + 
-	tw_dev->srb[request_id]->device->id;
+		sdev_id(tw_dev->srb[request_id]->device);
 	param->parameter_id = 4;	/* unitcapacity parameter */
 	param->parameter_size_bytes = 4;
 	param_value = tw_dev->alignment_physical_address[request_id];
@@ -1797,7 +1802,7 @@ static int tw_scsiop_read_write(TW_Devic
 
 	command_packet->size = 3;
 	command_packet->request_id = request_id;
-	command_packet->unit__hostid = TW_UNITHOST_IN(0, srb->device->id);
+	command_packet->unit__hostid = TW_UNITHOST_IN(0, sdev_id(srb->device));
 	command_packet->status = 0;
 	command_packet->flags = 0;
 
@@ -1902,7 +1907,8 @@ static int tw_scsiop_synchronize_cache(T
 	command_packet->opcode__sgloffset = TW_OPSGL_IN(0, TW_OP_FLUSH_CACHE);
 	command_packet->size = 2;
 	command_packet->request_id = request_id;
-	command_packet->unit__hostid = TW_UNITHOST_IN(0, tw_dev->srb[request_id]->device->id);
+	command_packet->unit__hostid =
+		TW_UNITHOST_IN(0, sdev_id(tw_dev->srb[request_id]->device));
 	command_packet->status = 0;
 	command_packet->flags = 0;
 	command_packet->byte6.parameter_count = 1;
@@ -1987,10 +1993,10 @@ static int tw_scsiop_test_unit_ready_com
 	}
 	is_unit_present = &(param->data[0]);
 
-	if (is_unit_present[tw_dev->srb[request_id]->device->id] & TW_UNIT_ONLINE) {
-		tw_dev->is_unit_present[tw_dev->srb[request_id]->device->id] = 1;
+	if (is_unit_present[sdev_id(tw_dev->srb[request_id]->device)] & TW_UNIT_ONLINE) {
+		tw_dev->is_unit_present[sdev_id(tw_dev->srb[request_id]->device)] = 1;
 	} else {
-		tw_dev->is_unit_present[tw_dev->srb[request_id]->device->id] = 0;
+		tw_dev->is_unit_present[sdev_id(tw_dev->srb[request_id]->device)] = 0;
 		tw_dev->srb[request_id]->result = (DID_BAD_TARGET << 16);
 		return TW_ISR_DONT_RESULT;
 	}
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 694a557..19240d1 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -3934,10 +3934,11 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
   struct aic_dev_data *aic_dev;
   unsigned short target_mask;
   unsigned char target, tindex;
-  const struct scsi_lun *lun;
+  struct scsi_lun slun;
   unsigned char queue_flag = FALSE;
   char channel;
   int result;
+  unsigned int tmp_lun;
   struct scsi_device *sd = NULL; /* FIXME: initializer very wrong!!! */
 
   target = ((aic_inb(p, SAVED_TCL) >> 4) & 0x0f);
@@ -3946,7 +3947,8 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
   else
     channel = 0;
   tindex = target + (channel << 3);
-  lun = aic_inb(p, SAVED_TCL) & 0x07;
+  tmp_lun = aic_inb(p, SAVED_TCL) & 0x07;
+  int_to_scsilun(tmp_lun, &slun);
   target_mask = (0x01 << tindex);
 
   /*
@@ -4112,9 +4114,9 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
               scbp = p->scb_data->scb_array[i];
               if ((scbp->flags & SCB_ACTIVE) && (scbp != scb))
               {
-                if (aic7xxx_match_scb(p, scbp, target, channel, lun, i))
+                if (aic7xxx_match_scb(p, scbp, target, channel, &slun, i))
                 {
-                  aic7xxx_reset_device(p, target, channel, lun, i);
+                  aic7xxx_reset_device(p, target, channel, &slun, i);
                 }
               }
             }
@@ -4143,7 +4145,7 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
            * like our settings.
            */
           aic_dev->needppr = aic_dev->needppr_copy = 0;
-          aic7xxx_set_width(p, target, channel, lun, MSG_EXT_WDTR_BUS_8_BIT,
+          aic7xxx_set_width(p, target, channel, &slun, MSG_EXT_WDTR_BUS_8_BIT,
             (AHC_TRANS_ACTIVE|AHC_TRANS_CUR|AHC_TRANS_QUITE), aic_dev);
           aic7xxx_set_syncrate(p, NULL, target, channel, 0, 0, 0,
                                AHC_TRANS_ACTIVE|AHC_TRANS_CUR|AHC_TRANS_QUITE,
@@ -4183,7 +4185,7 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
            */
           aic_dev->needwdtr = aic_dev->needwdtr_copy = 0;
           scb->flags &= ~SCB_MSGOUT_BITS;
-          aic7xxx_set_width(p, target, channel, lun, MSG_EXT_WDTR_BUS_8_BIT,
+          aic7xxx_set_width(p, target, channel, &slun, MSG_EXT_WDTR_BUS_8_BIT,
             (AHC_TRANS_ACTIVE|AHC_TRANS_GOAL|AHC_TRANS_CUR), aic_dev);
           aic7xxx_set_syncrate(p, NULL, target, channel, 0, 0, 0,
                                AHC_TRANS_ACTIVE|AHC_TRANS_CUR|AHC_TRANS_QUITE,
@@ -4366,7 +4368,7 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
               {
                 prev_scbp = next_scbp;
                 next_scbp = next_scbp->q_next;
-                if ( aic7xxx_match_scb(p, prev_scbp, target, channel, lun,
+                if ( aic7xxx_match_scb(p, prev_scbp, target, channel, &slun,
                      SCB_LIST_NULL) )
                 {
                   scbq_remove(&p->waiting_scbs, prev_scbp);
@@ -4375,7 +4377,7 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
 		  aic_dev->active_cmds++;
                 }
               }
-              aic7xxx_search_qinfifo(p, target, channel, lun,
+              aic7xxx_search_qinfifo(p, target, channel, &slun,
                 SCB_LIST_NULL, SCB_QUEUED_FOR_DONE | SCB_QUEUE_FULL,
 	       	FALSE, NULL);
               next_scbp = NULL;
@@ -4389,7 +4391,7 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
                 if (scb_index < p->scb_data->numscbs)
                 {
                   next_scbp = p->scb_data->scb_array[scb_index];
-                  if (aic7xxx_match_scb(p, next_scbp, target, channel, lun,
+                  if (aic7xxx_match_scb(p, next_scbp, target, channel, &slun,
                       SCB_LIST_NULL) )
                   {
 		    next_scbp->flags = SCB_QUEUED_FOR_DONE | SCB_QUEUE_FULL;
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index da6e51c..4a9618a 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -270,7 +270,7 @@ ch_read_element_status(scsi_changer *ch,
  retry:
 	memset(cmd,0,sizeof(cmd));
 	cmd[0] = READ_ELEMENT_STATUS;
-	cmd[1] = (ch->device->lun << 5) | 
+	cmd[1] = (scsilun_to_int(&ch->device->lun) << 5) | 
 		(ch->voltags ? 0x10 : 0) |
 		ch_elem_to_typecode(ch,elem);
 	cmd[2] = (elem >> 8) & 0xff;
@@ -306,7 +306,7 @@ ch_init_elem(scsi_changer *ch)
 	vprintk("INITIALIZE ELEMENT STATUS, may take some time ...\n");
 	memset(cmd,0,sizeof(cmd));
 	cmd[0] = INITIALIZE_ELEMENT_STATUS;
-	cmd[1] = ch->device->lun << 5;
+	cmd[1] = scsilun_to_int(&ch->device->lun) << 5;
 	err = ch_do_scsi(ch, cmd, NULL, 0, DMA_NONE);
 	vprintk("... finished\n");
 	return err;
@@ -327,7 +327,7 @@ ch_readconfig(scsi_changer *ch)
 	
 	memset(cmd,0,sizeof(cmd));
 	cmd[0] = MODE_SENSE;
-	cmd[1] = ch->device->lun << 5;
+	cmd[1] = scsilun_to_int(&ch->device->lun) << 5;
 	cmd[2] = 0x1d;
 	cmd[4] = 255;
 	result = ch_do_scsi(ch, cmd, buffer, 255, DMA_FROM_DEVICE);
@@ -407,19 +407,23 @@ ch_readconfig(scsi_changer *ch)
 					printk("ID/LUN unknown\n");
 				ch->dt[elem] = NULL;
 			} else {
-				id  = ch->device->id;
+				id  = sdev_id(ch->device);
 				lun = 0;
 				if (data[6] & 0x20) id  = data[7];
 				if (data[6] & 0x10) lun = data[6] & 7;
 			}
 		}
 		if (-1 != id) {
+			struct scsi_lun slun;
+
+			int_to_scsilun(lun, &slun);
+
 			if (verbose)
 				printk("ID %i, LUN %i, ",id,lun);
 			ch->dt[elem] =
 				scsi_device_lookup(ch->device->host,
-						   ch->device->channel,
-						   id,lun);
+						   sdev_channel(ch->device),
+						   id, &slun);
 			if (!ch->dt[elem]) {
 				/* should not happen */
 				if (verbose)
@@ -451,7 +455,7 @@ ch_position(scsi_changer *ch, u_int tran
 		trans = ch->firsts[CHET_MT];
 	memset(cmd,0,sizeof(cmd));
 	cmd[0]  = POSITION_TO_ELEMENT;
-	cmd[1]  = ch->device->lun << 5;
+	cmd[1]  = scsilun_to_int(&ch->device->lun) << 5;
 	cmd[2]  = (trans >> 8) & 0xff;
 	cmd[3]  =  trans       & 0xff;
 	cmd[4]  = (elem  >> 8) & 0xff;
@@ -470,7 +474,7 @@ ch_move(scsi_changer *ch, u_int trans, u
 		trans = ch->firsts[CHET_MT];
 	memset(cmd,0,sizeof(cmd));
 	cmd[0]  = MOVE_MEDIUM;
-	cmd[1]  = ch->device->lun << 5;
+	cmd[1]  = scsilun_to_int(&ch->device->lun) << 5;
 	cmd[2]  = (trans >> 8) & 0xff;
 	cmd[3]  =  trans       & 0xff;
 	cmd[4]  = (src   >> 8) & 0xff;
@@ -493,7 +497,7 @@ ch_exchange(scsi_changer *ch, u_int tran
 		trans = ch->firsts[CHET_MT];
 	memset(cmd,0,sizeof(cmd));
 	cmd[0]  = EXCHANGE_MEDIUM;
-	cmd[1]  = ch->device->lun << 5;
+	cmd[1]  = scsilun_to_int(&ch->device->lun) << 5;
 	cmd[2]  = (trans >> 8) & 0xff;
 	cmd[3]  =  trans       & 0xff;
 	cmd[4]  = (src   >> 8) & 0xff;
@@ -542,7 +546,7 @@ ch_set_voltag(scsi_changer *ch, u_int el
 		elem, tag);
 	memset(cmd,0,sizeof(cmd));
 	cmd[0]  = SEND_VOLUME_TAG;
-	cmd[1] = (ch->device->lun << 5) | 
+	cmd[1] = (scsilun_to_int(&ch->device->lun) << 5) | 
 		ch_elem_to_typecode(ch,elem);
 	cmd[2] = (elem >> 8) & 0xff;
 	cmd[3] = elem        & 0xff;
@@ -778,7 +782,7 @@ static int ch_ioctl(struct inode * inode
 	voltag_retry:
 		memset(cmd,0,sizeof(cmd));
 		cmd[0] = READ_ELEMENT_STATUS;
-		cmd[1] = (ch->device->lun << 5) |
+		cmd[1] = (scsilun_to_int(&ch->device->lun) << 5) |
 			(ch->voltags ? 0x10 : 0) |
 			ch_elem_to_typecode(ch,elem);
 		cmd[2] = (elem >> 8) & 0xff;
@@ -940,9 +944,7 @@ static int ch_probe(struct device *dev)
 			    MKDEV(SCSI_CHANGER_MAJOR,ch->minor),
 			    dev, "s%s", ch->name);
 
-	printk(KERN_INFO "Attached scsi changer %s "
-	       "at scsi%d, channel %d, id %d, lun %d\n", 
-	       ch->name, sd->host->host_no, sd->channel, sd->id, sd->lun);
+	sdev_printk(KERN_INFO, sd, "Attached scsi changer %s\n", ch->name);
 	
 	spin_lock(&ch_devlist_lock);
 	list_add_tail(&ch->list,&ch_devlist);
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 65e8456..8b3f1ae 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -830,7 +830,7 @@ static int imm_engine(imm_struct *dev, s
 
 		/* Phase 2 - We are now talking to the scsi bus */
 	case 2:
-		if (!imm_select(dev, cmd->device->id)) {
+		if (!imm_select(dev, sdev_id(cmd->device))) {
 			imm_fail(dev, DID_NO_CONNECT);
 			return 0;
 		}
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index babd483..fdfbbeb 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -1913,11 +1913,14 @@ restart:
 
 	list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
 		if (res->add_to_ml) {
+			struct scsi_lun __lun;
 			bus = res->cfgte.res_addr.bus;
 			target = res->cfgte.res_addr.target;
 			lun = res->cfgte.res_addr.lun;
+			int_to_scsilun(lun, &__lun);
+
 			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
-			scsi_add_device(ioa_cfg->host, bus, target, lun);
+			scsi_add_device(ioa_cfg->host, bus, target, &__lun);
 			spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 			goto restart;
 		}
@@ -2861,9 +2864,9 @@ static int ipr_slave_alloc(struct scsi_d
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 
 	list_for_each_entry(res, &ioa_cfg->used_res_q, queue) {
-		if ((res->cfgte.res_addr.bus == sdev->channel) &&
-		    (res->cfgte.res_addr.target == sdev->id) &&
-		    (res->cfgte.res_addr.lun == sdev->lun)) {
+		if ((res->cfgte.res_addr.bus == sdev_channel(sdev)) &&
+		    (res->cfgte.res_addr.target == sdev_id(sdev)) &&
+		    (res->cfgte.res_addr.lun == scsilun_to_int(&sdev->lun))) {
 			res->sdev = sdev;
 			res->add_to_ml = 0;
 			res->in_erp = 0;
@@ -3758,7 +3761,8 @@ static void ipr_erp_start(struct ipr_ioa
 		 * will give CC/UA the next command.
 		 */
 		if (!res->resetting_device)
-			scsi_report_bus_reset(ioa_cfg->host, scsi_cmd->device->channel);
+			scsi_report_bus_reset(ioa_cfg->host,
+					      sdev_channel(scsi_cmd->device));
 		scsi_cmd->result |= (DID_ERROR << 16);
 		res->needs_sync_complete = 1;
 		break;
@@ -5856,10 +5860,15 @@ out_disable:
 static void ipr_scan_vsets(struct ipr_ioa_cfg *ioa_cfg)
 {
 	int target, lun;
+	struct scsi_lun __lun;
 
 	for (target = 0; target < IPR_MAX_NUM_TARGETS_PER_BUS; target++)
-		for (lun = 0; lun < IPR_MAX_NUM_VSET_LUNS_PER_TARGET; lun++ )
-			scsi_add_device(ioa_cfg->host, IPR_VSET_BUS, target, lun);
+		for (lun = 0; lun < IPR_MAX_NUM_VSET_LUNS_PER_TARGET; lun++) {
+			int_to_scsilun(lun, &__lun);
+
+			scsi_add_device(ioa_cfg->host, IPR_VSET_BUS,
+					target, &__lun);
+		}
 }
 
 /**
@@ -5961,6 +5970,7 @@ static int __devinit ipr_probe(struct pc
 {
 	struct ipr_ioa_cfg *ioa_cfg;
 	int rc;
+	struct scsi_lun lun;
 
 	rc = ipr_probe_ioa(pdev, dev_id);
 
@@ -6004,7 +6014,10 @@ static int __devinit ipr_probe(struct pc
 
 	scsi_scan_host(ioa_cfg->host);
 	ipr_scan_vsets(ioa_cfg);
-	scsi_add_device(ioa_cfg->host, IPR_IOA_BUS, IPR_IOA_TARGET, IPR_IOA_LUN);
+
+	int_to_scsilun(IPR_IOA_LUN, &lun);
+	scsi_add_device(ioa_cfg->host, IPR_IOA_BUS, IPR_IOA_TARGET, &lun);
+
 	ioa_cfg->allow_ml_add_del = 1;
 	schedule_work(&ioa_cfg->work_q);
 	return 0;
diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index cbff3ea..8cf9671 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1114,9 +1114,8 @@ struct ipr_ucode_image_header {
 #define ipr_warn(...) printk(KERN_WARNING IPR_NAME": "__VA_ARGS__)
 #define ipr_dbg(...) IPR_DBG_CMD(printk(KERN_INFO IPR_NAME ": "__VA_ARGS__))
 
-#define ipr_sdev_printk(level, sdev, fmt, ...) \
-	printk(level IPR_NAME ": %d:%d:%d:%d: " fmt, sdev->host->host_no, \
-		sdev->channel, sdev->id, sdev->lun, ##__VA_ARGS__)
+#define ipr_sdev_printk(level, sdev, fmt, args...) \
+	sdev_printk(level, sdev, fmt, ## args)
 
 #define ipr_sdev_err(sdev, fmt, ...) \
 	ipr_sdev_printk(KERN_ERR, sdev, fmt, ##__VA_ARGS__)
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 6367f00..c359882 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -400,7 +400,7 @@ static void nsp32_build_identify(struct 
 		/* mode = TRUE; */
 	}
 
-	data->msgoutbuf[pos] = IDENTIFY(mode, SCpnt->device->lun); pos++;
+	data->msgoutbuf[pos] = IDENTIFY(mode, &SCpnt->device->lun); pos++;
 
 	data->msgout_len = pos;
 }
@@ -481,7 +481,7 @@ static int nsp32_selection_autopara(stru
 	nsp32_hw_data  *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	unsigned int	base    = SCpnt->device->host->io_port;
 	unsigned int	host_id = SCpnt->device->host->this_id;
-	unsigned char	target  = SCpnt->device->id;
+	unsigned char	target  = sdev_id(SCpnt->device);
 	nsp32_autoparam *param  = data->autoparam;
 	unsigned char	phase;
 	int		i, ret;
@@ -612,7 +612,7 @@ static int nsp32_selection_autoscsi(stru
 	nsp32_hw_data  *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	unsigned int	base    = SCpnt->device->host->io_port;
 	unsigned int	host_id = SCpnt->device->host->this_id;
-	unsigned char	target  = SCpnt->device->id;
+	unsigned char	target  = sdev_id(SCpnt->device);
 	unsigned char	phase;
 	int		status;
 	unsigned short	command	= 0;
@@ -961,7 +961,7 @@ static int nsp32_queuecommand(struct scs
 	nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND,
 		  "enter. target: 0x%x LUN: 0x%x cmnd: 0x%x cmndlen: 0x%x "
 		  "use_sg: 0x%x reqbuf: 0x%lx reqlen: 0x%x",
-		  SCpnt->device->id, SCpnt->device->lun, SCpnt->cmnd[0], SCpnt->cmd_len,
+		  sdev_id(SCpnt->device), SCpnt->device->lun, SCpnt->cmnd[0], SCpnt->cmd_len,
 		  SCpnt->use_sg, SCpnt->request_buffer, SCpnt->request_bufflen);
 
 	if (data->CurrentSC != NULL) {
@@ -973,7 +973,7 @@ static int nsp32_queuecommand(struct scs
 	}
 
 	/* check target ID is not same as this initiator ID */
-	if (SCpnt->device->id == SCpnt->device->host->this_id) {
+	if (sdev_id(SCpnt->device) == SCpnt->device->host->this_id) {
 		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "terget==host???");
 		SCpnt->result = DID_BAD_TARGET << 16;
 		done(SCpnt);
@@ -981,7 +981,7 @@ static int nsp32_queuecommand(struct scs
 	}
 
 	/* check target LUN is allowable value */
-	if (SCpnt->device->lun >= MAX_LUN) {
+	if (scsilun_to_int(&SCpnt->device->lun) >= MAX_LUN) {
 		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "no more lun");
 		SCpnt->result = DID_BAD_TARGET << 16;
 		done(SCpnt);
@@ -1004,13 +1004,13 @@ static int nsp32_queuecommand(struct scs
 	/* initialize data */
 	data->msgout_len	= 0;
 	data->msgin_len		= 0;
-	cur_lunt		= &(data->lunt[SCpnt->device->id][SCpnt->device->lun]);
+	cur_lunt		= &(data->lunt[sdev_id(SCpnt->device)][scsilun_to_int(&SCpnt->device->lun)]);
 	cur_lunt->SCpnt		= SCpnt;
 	cur_lunt->save_datp	= 0;
 	cur_lunt->msgin03	= FALSE;
 	data->cur_lunt		= cur_lunt;
-	data->cur_id		= SCpnt->device->id;
-	data->cur_lun		= SCpnt->device->lun;
+	data->cur_id		= sdev_id(SCpnt->device);
+	data->cur_lun		= scsilun_to_int(&SCpnt->device->lun);
 
 	ret = nsp32_setup_sg_table(SCpnt);
 	if (ret == FALSE) {
@@ -1028,7 +1028,7 @@ static int nsp32_queuecommand(struct scs
 	 * (target don't have SDTR_DONE and SDTR_INITIATOR), sync
 	 * message SDTR is needed to do synchronous transfer.
 	 */
-	target = &data->target[SCpnt->device->id];
+	target = &data->target[sdev_id(SCpnt->device)];
 	data->cur_target = target;
 
 	if (!(target->sync_flag & (SDTR_DONE | SDTR_INITIATOR | SDTR_TARGET))) {
@@ -1074,7 +1074,7 @@ static int nsp32_queuecommand(struct scs
 
 	nsp32_dbg(NSP32_DEBUG_TARGETFLAG,
 		  "target: %d sync_flag: 0x%x syncreg: 0x%x ackwidth: 0x%x",
-		  SCpnt->device->id, target->sync_flag, target->syncreg,
+		  sdev_id(SCpnt->device), target->sync_flag, target->syncreg,
 		  target->ackwidth);
 
 	/* Selection */
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 3f2f246..1f73d67 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -5817,9 +5817,9 @@ static int osst_probe(struct device *dev
 	}
 	drive->number = devfs_register_tape(SDp->devfs_name);
 
-	printk(KERN_INFO
-		"osst :I: Attached OnStream %.5s tape at scsi%d, channel %d, id %d, lun %d as %s\n",
-		SDp->model, SDp->host->host_no, SDp->channel, SDp->id, SDp->lun, tape_name(tpnt));
+	sdev_printk(KERN_INFO, SDp,
+		"osst :I: Attached OnStream %.5s tape as %s\n",
+		SDp->model, tape_name(tpnt));
 
 	return 0;
 
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index fafcf5d..8dc3344 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -740,7 +740,7 @@ static int ppa_engine(ppa_struct *dev, s
 		}
 
 	case 2:		/* Phase 2 - We are now talking to the scsi bus */
-		if (!ppa_select(dev, cmd->device->id)) {
+		if (!ppa_select(dev, sdev_id(cmd->device))) {
 			ppa_fail(dev, DID_NO_CONNECT);
 			return 0;
 		}
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 322b5a4..2e1dc43 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -283,7 +283,7 @@ int scsi_debug_queuecommand(struct scsi_
 	unsigned char *cmd = (unsigned char *) SCpnt->cmnd;
 	int block, upper_blk, num, k;
 	int errsts = 0;
-	int target = SCpnt->device->id;
+	int target = sdev_id(SCpnt->device);
 	struct sdebug_dev_info * devip = NULL;
 	int inj_recovered = 0;
 
@@ -303,7 +303,7 @@ int scsi_debug_queuecommand(struct scsi_
 				     DID_NO_CONNECT << 16, 0);
         }
 
-	if (SCpnt->device->lun >= scsi_debug_max_luns)
+	if (scsilun_to_int(&SCpnt->device->lun) >= scsi_debug_max_luns)
 		return schedule_resp(SCpnt, NULL, done,
 				     DID_NO_CONNECT << 16, 0);
 	devip = devInfoReg(SCpnt->device);
@@ -1008,8 +1008,7 @@ static void timer_intr_handler(unsigned 
 static int scsi_debug_slave_alloc(struct scsi_device * sdp)
 {
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: slave_alloc <%u %u %u %u>\n",
-		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
+		sdev_printk(KERN_INFO, sdp, "scsi_debug: slave_alloc\n");
 	return 0;
 }
 
@@ -1018,8 +1017,7 @@ static int scsi_debug_slave_configure(st
 	struct sdebug_dev_info * devip;
 
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: slave_configure <%u %u %u %u>\n",
-		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
+		sdev_printk(KERN_INFO, sdp, "scsi_debug: slave_configure\n");
 	if (sdp->host->max_cmd_len != SCSI_DEBUG_MAX_CMD_LEN)
 		sdp->host->max_cmd_len = SCSI_DEBUG_MAX_CMD_LEN;
 	devip = devInfoReg(sdp);
@@ -1036,8 +1034,7 @@ static void scsi_debug_slave_destroy(str
 				(struct sdebug_dev_info *)sdp->hostdata;
 
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: slave_destroy <%u %u %u %u>\n",
-		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
+		sdev_printk(KERN_INFO, sdp, "scsi_debug: slave_destroy\n");
 	if (devip) {
 		/* make this slot avaliable for re-use */
 		devip->used = 0;
@@ -1060,9 +1057,10 @@ static struct sdebug_dev_info * devInfoR
 		return NULL;
         }
 	list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
-		if ((devip->used) && (devip->channel == sdev->channel) &&
-                    (devip->target == sdev->id) &&
-                    (devip->lun == sdev->lun))
+		if ((devip->used) &&
+		    (devip->channel == sdev_channel(sdev)) &&
+                    (devip->target == sdev_id(sdev)) &&
+                    (devip->lun == scsilun_to_int(&sdev->lun)))
                         return devip;
 		else {
 			if ((!devip->used) && (!open_devip))
@@ -1082,9 +1080,9 @@ static struct sdebug_dev_info * devInfoR
 		&sdbg_host->dev_info_list);
 	}
         if (open_devip) {
-		open_devip->channel = sdev->channel;
-		open_devip->target = sdev->id;
-		open_devip->lun = sdev->lun;
+		open_devip->channel = sdev_channel(sdev);
+		open_devip->target = sdev_id(sdev);
+		open_devip->lun = scsilun_to_int(&sdev->lun);
 		open_devip->sdbg_host = sdbg_host;
 		open_devip->reset = 1;
 		open_devip->used = 1;
@@ -1326,9 +1324,9 @@ static int schedule_resp(struct scsi_cmn
 		if (scsi_result) {
 			struct scsi_device * sdp = cmnd->device;
 
-			printk(KERN_INFO "scsi_debug:    <%u %u %u %u> "
-			       "non-zero result=0x%x\n", sdp->host->host_no,
-			       sdp->channel, sdp->id, sdp->lun, scsi_result);
+			sdev_printk(KERN_INFO, sdp,
+				"non-zero result=0x%x\n",
+			       	scsi_result);
 		}
 	}
 	if (cmnd && devip) {
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index d001c04..f2807cc 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3885,9 +3885,8 @@ static int st_probe(struct device *dev)
 	if (SDp->type != TYPE_TAPE)
 		return -ENODEV;
 	if ((stp = st_incompatible(SDp))) {
-		printk(KERN_INFO
-		       "st: Found incompatible tape at scsi%d, channel %d, id %d, lun %d\n",
-		       SDp->host->host_no, SDp->channel, SDp->id, SDp->lun);
+		sdev_printk(KERN_INFO, SDp,
+		       "st: Found incompatible tape\n");
 		printk(KERN_INFO "st: The suggested driver is %s.\n", stp);
 		return -ENODEV;
 	}
@@ -4075,9 +4074,9 @@ static int st_probe(struct device *dev)
 	}
 	disk->number = devfs_register_tape(SDp->devfs_name);
 
-	printk(KERN_WARNING
-	"Attached scsi tape %s at scsi%d, channel %d, id %d, lun %d\n",
-	       tape_name(tpnt), SDp->host->host_no, SDp->channel, SDp->id, SDp->lun);
+	sdev_printk(KERN_WARNING, SDp, "Attached scsi tape %s\n",
+		tape_name(tpnt));
+
 	printk(KERN_WARNING "%s: try direct i/o: %s (alignment %d B), max page reachable by HBA %lu\n",
 	       tape_name(tpnt), tpnt->try_dio ? "yes" : "no",
 	       queue_dma_alignment(SDp->request_queue) + 1, tpnt->max_pfn);
