From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [9/18]  qla2xxx: Tape command handling fixes
Date: Mon, 21 Jun 2004 22:55:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622055502.GA8446@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:50816 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266601AbUFVFvS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 01:51:18 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1845 04/06/04 08:58:01 andrew.vasquez@apc.qlogic.com +2 -0
  Address several outstanding problem within the various
  eh_*() functions:
  
  	o Fixup nested spinlock usage in error-hanlding
  	  functions.
  
  	o Set the Loop down timer during abort isp if loop
  	  was already down for the driver to detect cable
  	  is unplugged at min time.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_init.c |    4 ++
 drivers/scsi/qla2xxx/qla_os.c   |   72 ++++++++++++++++------------------------
 2 files changed, 34 insertions(+), 42 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
--- a/drivers/scsi/qla2xxx/qla_init.c	2004-06-21 15:38:28 -07:00
+++ b/drivers/scsi/qla2xxx/qla_init.c	2004-06-21 15:38:28 -07:00
@@ -4116,6 +4116,10 @@
 			atomic_set(&ha->loop_state, LOOP_DOWN);
 			atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
 			qla2x00_mark_all_devices_lost(ha);
+		} else {
+			if (!atomic_read(&ha->loop_down_timer))
+				atomic_set(&ha->loop_down_timer,
+				    LOOP_DOWN_TIME);
 		}
 
 		spin_lock_irqsave(&ha->hardware_lock, flags);
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:38:28 -07:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:38:28 -07:00
@@ -882,13 +882,12 @@
 	int		done = 0;
 	srb_t		*rp;
 	struct list_head *list, *temp;
-	u_long		cpu_flags = 0;
 	u_long		max_wait_time = ABORT_WAIT_TIME;
 
 	do {
 		/* Check on done queue */
 		if (!found) {
-			spin_lock_irqsave(&ha->list_lock, cpu_flags);
+			spin_lock(&ha->list_lock);
 			list_for_each_safe(list, temp, &ha->done_queue) {
 				rp = list_entry(list, srb_t, list);
 
@@ -903,7 +902,7 @@
 					break;
 				}
 			}
-			spin_unlock_irqrestore(&ha->list_lock, cpu_flags);
+			spin_unlock(&ha->list_lock);
 		}
 
 		/* Checking to see if its returned to OS */
@@ -951,7 +950,7 @@
  *    Success (Adapter is online) : 0
  *    Failed  (Adapter is offline/disabled) : 1
  */
-static inline int 
+int 
 qla2x00_wait_for_hba_online(scsi_qla_host_t *ha)
 {
 	int 	 return_status;
@@ -960,8 +959,8 @@
 	wait_online = jiffies + (MAX_LOOP_TIMEOUT * HZ); 
 	while (((test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags)) ||
 	    test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags) ||
-	    test_bit(ISP_ABORT_RETRY, &ha->dpc_flags)) &&
-		time_before(jiffies, wait_online)) {
+	    test_bit(ISP_ABORT_RETRY, &ha->dpc_flags) ||
+	    ha->dpc_active) && time_before(jiffies, wait_online)) {
 
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule_timeout(HZ);
@@ -969,7 +968,6 @@
 	if (ha->flags.online == TRUE) 
 		return_status = QLA_SUCCESS; 
 	else
-		/* Adapter is disabled/offline */
 		return_status = QLA_FUNCTION_FAILED;
 
 	DEBUG2(printk("%s return_status=%d\n",__func__,return_status));
@@ -1044,7 +1042,6 @@
 	struct Scsi_Host *host;
 	uint8_t		found = 0;
 	unsigned int	b, t, l;
-	unsigned long	flags;
 
 	/* Get the SCSI request ptr */
 	sp = (srb_t *) CMD_SP(cmd);
@@ -1059,7 +1056,7 @@
 		qla_printk(KERN_INFO, to_qla_host(cmd->device->host),
 		    "qla2xxx_eh_abort: cmd already done sp=%p\n", sp);
 		DEBUG(printk("qla2xxx_eh_abort: cmd already done sp=%p\n", sp);)
-		return(SUCCESS);
+		return SUCCESS;
 	}
 	if (sp) {
 		DEBUG(printk("qla2xxx_eh_abort: refcount %i \n",
@@ -1090,7 +1087,7 @@
 			"qla2x00: (%x:%x:%x) No LUN queue.\n", b, t, l);
 
 		/* no action - we don't have command */
-		return(FAILED);
+		return FAILED;
 	}
 
 	DEBUG2(printk("scsi(%ld): ABORTing cmd=%p sp=%p jiffies = 0x%lx, "
@@ -1100,16 +1097,15 @@
 	DEBUG2(qla2x00_print_scsi_cmd(cmd));
 
 	spin_unlock_irq(ha->host->host_lock);
-	/* Blocking call-Does context switching if abort isp is active etc */  
 	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS) {
 		DEBUG2(printk("%s failed:board disabled\n", __func__);)
 		spin_lock_irq(ha->host->host_lock);
-		return (FAILED);
+		return FAILED;
 	}
 	spin_lock_irq(ha->host->host_lock);
 
 	/* Search done queue */
-	spin_lock_irqsave(&ha->list_lock,flags);
+	spin_lock(&ha->list_lock);
 	list_for_each_safe(list, temp, &ha->done_queue) {
 		rp = list_entry(list, srb_t, list);
 
@@ -1126,7 +1122,7 @@
 
 		break;
 	} /* list_for_each_safe() */
-	spin_unlock_irqrestore(&ha->list_lock, flags);
+	spin_unlock(&ha->list_lock);
 
 	/*
 	 * Return immediately if the aborted command was already in the done
@@ -1147,7 +1143,7 @@
 	DEBUG3(printk("qla2xxx_eh_abort: searching sp %p in retry "
 		    "queue.\n", sp);)
 
-	spin_lock_irqsave(&ha->list_lock, flags);
+	spin_lock(&ha->list_lock);
 	list_for_each_safe(list, temp, &ha->retry_queue) {
 		rp = list_entry(list, srb_t, list);
 
@@ -1168,7 +1164,7 @@
 		break;
 
 	} 
-	spin_unlock_irqrestore(&ha->list_lock, flags);
+	spin_unlock(&ha->list_lock);
 
 
 	/*
@@ -1179,7 +1175,7 @@
 		DEBUG3(printk("qla2xxx_eh_abort: searching sp %p "
 		    "in pending queue.\n", sp);)
 
-		spin_lock_irqsave(&vis_ha->list_lock, flags);
+		spin_lock(&vis_ha->list_lock);
 		list_for_each_safe(list, temp, &vis_ha->pending_queue) {
 			rp = list_entry(list, srb_t, list);
 
@@ -1203,14 +1199,14 @@
 			found++;
 			break;
 		} /* list_for_each_safe() */
-		spin_unlock_irqrestore(&vis_ha->list_lock, flags);
+		spin_unlock(&vis_ha->list_lock);
 	} /*End of if !found */
 
 	if (!found) {  /* find the command in our active list */
 		DEBUG3(printk("qla2xxx_eh_abort: searching sp %p "
 		    "in outstanding queue.\n", sp);)
 
-		spin_lock_irqsave(&ha->hardware_lock, flags);
+		spin_lock(&ha->hardware_lock);
 		for (i = 1; i < MAX_OUTSTANDING_COMMANDS; i++) {
 			sp = ha->outstanding_cmds[i];
 
@@ -1229,8 +1225,8 @@
 			/* Get a reference to the sp and drop the lock.*/
 			sp_get(ha, sp);
 
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-			spin_unlock(ha->host->host_lock);
+			spin_unlock(&ha->hardware_lock);
+			spin_unlock_irq(ha->host->host_lock);
 
 			if (qla2x00_abort_command(ha, sp)) {
 				DEBUG2(printk("qla2xxx_eh_abort: abort_command "
@@ -1245,7 +1241,7 @@
 			sp_put(ha,sp);
 
 			spin_lock_irq(ha->host->host_lock);
-			spin_lock_irqsave(&ha->hardware_lock, flags);
+			spin_lock(&ha->hardware_lock);
 
 			/*
 			 * Regardless of mailbox command status, go check on
@@ -1254,11 +1250,11 @@
 			break;
 
 		}/*End of for loop */
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		spin_unlock(&ha->hardware_lock);
 
 	} /*End of if !found */
 
-	  /*Waiting for our command in done_queue to be returned to OS.*/
+	/* Waiting for our command in done_queue to be returned to OS.*/
 	if (qla2x00_eh_wait_on_command(ha, cmd) != 0) {
 		DEBUG2(printk("qla2xxx_eh_abort: cmd returned back to OS.\n");)
 		return_status = SUCCESS;
@@ -1273,7 +1269,7 @@
 	DEBUG2(printk("qla2xxx_eh_abort: Exiting. return_status=0x%x.\n",
 	    return_status));
 
-	return(return_status);
+	return return_status;
 }
 
 /**************************************************************************
@@ -1295,7 +1291,6 @@
 {
 	int	cnt;
 	int	status;
-	unsigned long	flags;
 	srb_t		*sp;
 	struct scsi_cmnd *cmd;
 
@@ -1306,11 +1301,11 @@
 	 * array
 	 */
 	for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
-		spin_lock_irqsave(&ha->hardware_lock, flags);
+		spin_lock(&ha->hardware_lock);
 		sp = ha->outstanding_cmds[cnt];
 		if (sp) {
 			cmd = sp->cmd;
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+			spin_unlock(&ha->hardware_lock);
 			if (cmd->device->id == t) {
 				if (!qla2x00_eh_wait_on_command(ha, cmd)) {
 					status = 1;
@@ -1319,7 +1314,7 @@
 			}
 		}
 		else {
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+			spin_unlock(&ha->hardware_lock);
 		}
 	}
 	return (status);
@@ -1354,7 +1349,6 @@
 	os_tgt_t	*tq;
 	os_lun_t	*lq;
 	fc_port_t	*fcport_to_reset;
-	unsigned long	flags;
 	srb_t		*rp;
 	struct list_head *list, *temp;
 
@@ -1402,7 +1396,7 @@
 	    ha->dpc_flags, cmd->result, cmd->allowed, cmd->state));
 
  	/* Clear commands from the retry queue. */
- 	spin_lock_irqsave(&ha->list_lock, flags);
+ 	spin_lock(&ha->list_lock);
  	list_for_each_safe(list, temp, &ha->retry_queue) {
  		rp = list_entry(list, srb_t, list);
  
@@ -1416,11 +1410,10 @@
  		rp->cmd->result = DID_RESET << 16;
  		__add_to_done_queue(ha, rp);
  	}
- 	spin_unlock_irqrestore(&ha->list_lock, flags);
+ 	spin_unlock(&ha->list_lock);
 
 	spin_unlock_irq(ha->host->host_lock);
 
-	/* Blocking call-Does context switching if abort isp is active etc */  
 	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS) {
 		DEBUG2(printk(KERN_INFO
 		    "%s failed:board disabled\n",__func__));
@@ -1429,7 +1422,6 @@
 		goto eh_dev_reset_done;
 	}
 
-	/* Blocking call-Does context switching if loop is Not Ready */
 	if (qla2x00_wait_for_loop_ready(ha) == QLA_SUCCESS) {
 		if (qla2x00_device_reset(ha, fcport_to_reset) == 0) {
 			return_status = SUCCESS;
@@ -1453,7 +1445,7 @@
 
 	if (return_status == FAILED) {
 		DEBUG3(printk("%s(%ld): device reset failed\n",
-		    __func__,ha->host_no));
+		    __func__, ha->host_no));
 		qla_printk(KERN_INFO, ha, "%s: device reset failed\n",
 		    __func__);
 
@@ -1511,7 +1503,6 @@
 {
 	int	cnt;
 	int	status;
-	unsigned long	flags;
 	srb_t		*sp;
 	struct scsi_cmnd *cmd;
 
@@ -1522,17 +1513,17 @@
 	 * array
 	 */
 	for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
-		spin_lock_irqsave(&ha->hardware_lock, flags);
+		spin_lock(&ha->hardware_lock);
 		sp = ha->outstanding_cmds[cnt];
 		if (sp) {
 			cmd = sp->cmd;
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+			spin_unlock(&ha->hardware_lock);
 			status = qla2x00_eh_wait_on_command(ha, cmd);
 			if (status == 0)
 				break;
 		}
 		else {
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+			spin_unlock(&ha->hardware_lock);
 		}
 	}
 	return (status);
@@ -1570,14 +1561,12 @@
 
 	spin_unlock_irq(ha->host->host_lock);
 
-	/* Blocking call-Does context switching if abort isp is active etc*/  
 	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS) {
 		DEBUG2(printk("%s failed:board disabled\n",__func__));
 		spin_lock_irq(ha->host->host_lock);
 		return FAILED;
 	}
 
-	/* Blocking call-Does context switching if loop is Not Ready */ 
 	if (qla2x00_wait_for_loop_ready(ha) == QLA_SUCCESS) {
 		if (qla2x00_loop_reset(ha)) 
 			rval = SUCCESS;
@@ -1637,7 +1626,6 @@
 
 	spin_unlock_irq(ha->host->host_lock);
 
-	/* Blocking call-Does context switching if abort isp is active etc*/  
 	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS)
 		goto board_disabled;
 
