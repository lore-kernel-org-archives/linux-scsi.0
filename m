From: James Bottomley <James.Bottomley@steeleye.com>
Subject: error handling completely broken in 2.5.59-BK latest
Date: 08 Feb 2003 18:09:20 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1044749361.1986.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-y8LFwzqbxNx/BuusRENm"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id QAA31476
	for <linux-scsi@vger.kernel.org>; Sat, 8 Feb 2003 16:09:24 -0800
Received: from mulgrave-w.il.steeleye.com (sshppp-200.mtv1.steeleye.com [172.16.1.200])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id QAA31337
	for <linux-scsi@vger.kernel.org>; Sat, 8 Feb 2003 16:09:21 -0800
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-y8LFwzqbxNx/BuusRENm
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



The slab allocator altered the way we allocate and track commands. 
Unfortunately, the eh mechanism for finding failed commands was still
using the old method, thus whenever the eh is activated you see messages
like:

scsi_eh_get_failed: host_failed: 1 != found: 0

and eventually the whole thing hits a BUG().

The attached patch adds the tracking of outstanding commands to a
cmd_list in the scsi_device, and makes all the previous users of
device_queue use this instead.  I've protected it with
scsi_device.list_lock, since I think we are not guaranteed to be holding
the queue lock when certain users come along (proofs to the contrary
would be welcome).

James


--=-y8LFwzqbxNx/BuusRENm
Content-Disposition: attachment; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

=3D=3D=3D=3D=3D dpt_i2o.c 1.23 vs edited =3D=3D=3D=3D=3D
--- 1.23/drivers/scsi/dpt_i2o.c	Tue Jan 28 10:15:51 2003
+++ edited/dpt_i2o.c	Sat Feb  8 17:50:40 2003
@@ -2510,13 +2510,16 @@
 	Scsi_Device* 	d =3D NULL;
=20
 	list_for_each_entry(d, &pHba->host->my_devices, siblings) {
-		for(cmd =3D d->device_queue; cmd ; cmd =3D cmd->next){
+		unsigned long flags;
+		spin_lock_irqsave(&d->list_lock, flags);
+		list_for_each_entry(cmd, &d->cmd_list, list) {
 			if(cmd->serial_number =3D=3D 0){
 				continue;
 			}
 			cmd->result =3D (DID_OK << 16) | (QUEUE_FULL <<1);
 			cmd->scsi_done(cmd);
 		}
+		spin_unlock_irqrestore(&d->list_lock, flags);
 	}
 }
=20
=3D=3D=3D=3D=3D hosts.c 1.50 vs edited =3D=3D=3D=3D=3D
--- 1.50/drivers/scsi/hosts.c	Thu Feb  6 09:20:37 2003
+++ edited/hosts.c	Sat Feb  8 17:51:51 2003
@@ -205,13 +205,15 @@
 {
 	struct Scsi_Host *shost =3D sdev->host;
 	struct scsi_cmnd *scmd;
+	unsigned long flags;
=20
 	/*
 	 * Loop over all of the commands associated with the
 	 * device.  If any of them are busy, then set the state
 	 * back to inactive and bail.
 	 */
-	for (scmd =3D sdev->device_queue; scmd; scmd =3D scmd->next) {
+	spin_lock_irqsave(&sdev->list_lock, flags);
+	list_for_each_entry(scmd, &sdev->cmd_list, list) {
 		if (scmd->request && scmd->request->rq_status !=3D RQ_INACTIVE)
 			goto active;
=20
@@ -223,6 +225,7 @@
 		if (scmd->request)
 			scmd->request->rq_status =3D RQ_SCSI_DISCONNECTING;
 	}
+	spin_unlock_irqrestore(&sdev->list_lock, flags);
=20
 	return 0;
=20
@@ -233,12 +236,13 @@
 			scmd->pid, scmd->state, scmd->owner);
=20
 	list_for_each_entry(sdev, &shost->my_devices, siblings) {
-		for (scmd =3D sdev->device_queue; scmd; scmd =3D scmd->next) {
+		list_for_each_entry(scmd, &sdev->cmd_list, list) {
 			if (scmd->request->rq_status =3D=3D RQ_SCSI_DISCONNECTING)
 				scmd->request->rq_status =3D RQ_INACTIVE;
 		}
 	}
=20
+	spin_unlock_irqrestore(&sdev->list_lock, flags);
 	printk(KERN_ERR "Device busy???\n");
 	return 1;
 }
=3D=3D=3D=3D=3D scsi.c 1.88 vs edited =3D=3D=3D=3D=3D
--- 1.88/drivers/scsi/scsi.c	Thu Feb  6 09:20:37 2003
+++ edited/scsi.c	Sat Feb  8 17:55:56 2003
@@ -403,12 +403,17 @@
 	struct scsi_cmnd *cmd =3D __scsi_get_command(dev->host, gfp_mask);
=20
 	if (likely(cmd !=3D NULL)) {
+		unsigned long flags;
+
 		memset(cmd, 0, sizeof(*cmd));
 		cmd->device =3D dev;
 		cmd->state =3D SCSI_STATE_UNUSED;
 		cmd->owner =3D SCSI_OWNER_NOBODY;
 		init_timer(&cmd->eh_timeout);
 		INIT_LIST_HEAD(&cmd->list);
+		spin_lock_irqsave(&dev->list_lock, flags);
+		list_add(&dev->cmd_list, &cmd->list);
+		spin_unlock_irqrestore(&dev->list_lock, flags);
 	}
=20
 	return cmd;
@@ -430,7 +435,13 @@
 	struct Scsi_Host *shost =3D cmd->device->host;
 	unsigned long flags;
 =09
-	spin_lock_irqsave(&shost->free_list_lock, flags);
+	/* serious error if the command hasn't come from a device list */
+	spin_lock_irqsave(&cmd->device->list_lock, flags);
+	BUG_ON(list_empty(&cmd->list));
+	list_del_init(&cmd->list);
+	spin_unlock(&cmd->device->list_lock);
+	/* changing locks here, don't need to restore the irq state */
+	spin_lock(&shost->free_list_lock);
 	if (unlikely(list_empty(&shost->free_list))) {
 		list_add(&cmd->list, &shost->free_list);
 		cmd =3D NULL;
=3D=3D=3D=3D=3D scsi.h 1.59 vs edited =3D=3D=3D=3D=3D
--- 1.59/drivers/scsi/scsi.h	Wed Feb  5 11:36:00 2003
+++ edited/scsi.h	Sat Feb  8 15:49:54 2003
@@ -571,9 +571,8 @@
 	struct Scsi_Host *host;
 	request_queue_t *request_queue;
 	volatile unsigned short device_busy;	/* commands actually active on low-l=
evel */
-	struct list_head free_cmnds;    /* list of available Scsi_Cmnd structs */
-	struct list_head busy_cmnds;    /* list of Scsi_Cmnd structs in use */
-	Scsi_Cmnd *device_queue;	/* queue of SCSI Command structures */
+	spinlock_t list_lock;
+	struct list_head cmd_list;	/* queue of in use SCSI Command structures */
         Scsi_Cmnd *current_cmnd;	/* currently active command */
 	unsigned short queue_depth;	/* How deep of a queue we want */
 	unsigned short last_queue_full_depth; /* These two are used by */
@@ -724,7 +723,6 @@
 	unsigned short state;
 	unsigned short owner;
 	Scsi_Request *sc_request;
-	struct scsi_cmnd *next;
 	struct scsi_cmnd *reset_chain;
=20
 	struct list_head list;  /* scsi_cmnd participates in queue lists */
=3D=3D=3D=3D=3D scsi_error.c 1.32 vs edited =3D=3D=3D=3D=3D
--- 1.32/drivers/scsi/scsi_error.c	Fri Feb  7 14:25:20 2003
+++ edited/scsi_error.c	Sat Feb  8 17:54:26 2003
@@ -233,7 +233,10 @@
=20
 	found =3D 0;
 	list_for_each_entry(sdev, &shost->my_devices, siblings) {
-		for (scmd =3D sdev->device_queue; scmd; scmd =3D scmd->next) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&sdev->list_lock, flags);
+		list_for_each_entry(scmd, &sdev->cmd_list, list) {
 			if (scsi_eh_eflags_chk(scmd, SCSI_EH_CMD_ERR)) {
 				scmd->bh_next =3D *sc_list;
 				*sc_list =3D scmd;
@@ -266,6 +269,7 @@
 				}
 			}
 		}
+		spin_unlock_irqrestore(&sdev->list_lock, flags);
 	}
=20
 	SCSI_LOG_ERROR_RECOVERY(1, scsi_eh_prt_fail_stats(*sc_list, shost));
@@ -1739,25 +1743,13 @@
 int
 scsi_reset_provider(Scsi_Device *dev, int flag)
 {
-	struct scsi_cmnd SC, *SCpnt =3D &SC;
+	struct scsi_cmnd *SCpnt =3D scsi_get_command(dev, GFP_KERNEL);
 	struct request req;
 	int rtn;
=20
 	SCpnt->request =3D &req;
 	memset(&SCpnt->eh_timeout, 0, sizeof(SCpnt->eh_timeout));
-	SCpnt->device                  	=3D dev;
 	SCpnt->request->rq_status      	=3D RQ_SCSI_BUSY;
-	SCpnt->request->waiting        	=3D NULL;
-	SCpnt->use_sg                  	=3D 0;
-	SCpnt->old_use_sg              	=3D 0;
-	SCpnt->old_cmd_len             	=3D 0;
-	SCpnt->underflow               	=3D 0;
-	SCpnt->transfersize            	=3D 0;
-	SCpnt->resid			=3D 0;
-	SCpnt->serial_number           	=3D 0;
-	SCpnt->serial_number_at_timeout	=3D 0;
-	SCpnt->host_scribble           	=3D NULL;
-	SCpnt->next                    	=3D NULL;
 	SCpnt->state                   	=3D SCSI_STATE_INITIALIZING;
 	SCpnt->owner	     		=3D SCSI_OWNER_MIDLEVEL;
    =20
@@ -1790,5 +1782,6 @@
 	rtn =3D scsi_new_reset(SCpnt, flag);
=20
 	scsi_delete_timer(SCpnt);
+	scsi_put_command(SCpnt);
 	return rtn;
 }
=3D=3D=3D=3D=3D scsi_proc.c 1.15 vs edited =3D=3D=3D=3D=3D
--- 1.15/drivers/scsi/scsi_proc.c	Thu Feb  6 09:20:38 2003
+++ edited/scsi_proc.c	Sat Feb  8 17:56:50 2003
@@ -359,7 +359,10 @@
 		printk(KERN_INFO "h:c:t:l (dev sect nsect cnumsec sg) "
 			"(ret all flg) (to/cmd to ito) cmd snse result\n");
 		list_for_each_entry(SDpnt, &shpnt->my_devices, siblings) {
-			for (SCpnt =3D SDpnt->device_queue; SCpnt; SCpnt =3D SCpnt->next) {
+			unsigned long flags;
+
+			spin_lock_irqsave(&SDpnt->list_lock, flags);
+			list_for_each_entry(SCpnt, &SDpnt->cmd_list, list) {
 				/*  (0) h:c:t:l (dev sect nsect cnumsec sg) (ret all flg) (to/cmd to i=
to) cmd snse result %d %x      */
 				printk(KERN_INFO "(%3d) %2d:%1d:%2d:%2d (%6s %4llu %4ld %4ld %4x %1d) =
(%1d %1d 0x%2x) (%4d %4d %4d) 0x%2.2x 0x%2.2x 0x%8.8x\n",
 				       i++,
@@ -389,6 +392,7 @@
 				       SCpnt->sense_buffer[2],
 				       SCpnt->result);
 			}
+			spin_unlock_irqrestore(&SDpnt->list_lock, flags);
 		}
 	}
 }
=3D=3D=3D=3D=3D scsi_scan.c 1.56 vs edited =3D=3D=3D=3D=3D
--- 1.56/drivers/scsi/scsi_scan.c	Tue Feb  4 10:27:21 2003
+++ edited/scsi_scan.c	Sat Feb  8 15:58:39 2003
@@ -449,6 +449,7 @@
 		sdev->online =3D TRUE;
 		INIT_LIST_HEAD(&sdev->siblings);
 		INIT_LIST_HEAD(&sdev->same_target_siblings);
+		spin_lock_init(&sdev->list_lock);
 		/*
 		 * Some low level driver could use device->type
 		 */

--=-y8LFwzqbxNx/BuusRENm--

