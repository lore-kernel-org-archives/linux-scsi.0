From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] libata: 'done' related SCSI cleanups
Date: Wed, 17 Nov 2010 23:04:12 -0500
Message-ID: <20101118040412.GA20168@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-ide@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, tj@kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Checked this into #upstream...

We cannot easily remove 'scsidone' pointer from struct ata_queued_cmd,
because of the following code in __ata_eh_qc_complete():

	static void ata_eh_scsidone(struct scsi_cmnd *scmd)
	{
	        /* nada */
	}

	...

	spin_lock_irqsave(ap->lock, flags);
        qc->scsidone = ata_eh_scsidone;
	__ata_qc_complete(qc);
	spin_unlock_irqrestore(ap->lock, flags);

	scsi_eh_finish_cmd(scmd, &ap->eh_done_q);

I guess we're avoiding scsi_eh_done() here, Tejun?



commit 4b1b362af0fe0b9b9b4f6475ff94b534d6a8035c
Author: Jeff Garzik <jeff@garzik.org>
Date:   Wed Nov 17 22:56:48 2010 -0500

    [libata] avoid needlessly passing around ptr to SCSI completion func
    
    It's stored in struct scsi_cmnd->scsi_done, making several 'done'
    parameters to functions redundant.
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 drivers/ata/libata-scsi.c           |   60 +++++++++++++++---------------------
 drivers/scsi/ipr.c                  |    2 -
 drivers/scsi/libsas/sas_scsi_host.c |    3 -
 include/linux/libata.h              |    6 +--
 4 files changed, 29 insertions(+), 42 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 66aa4be..5defc74 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -346,12 +346,11 @@ struct device_attribute *ata_common_sdev_attrs[] = {
 };
 EXPORT_SYMBOL_GPL(ata_common_sdev_attrs);
 
-static void ata_scsi_invalid_field(struct scsi_cmnd *cmd,
-				   void (*done)(struct scsi_cmnd *))
+static void ata_scsi_invalid_field(struct scsi_cmnd *cmd)
 {
 	ata_scsi_set_sense(cmd, ILLEGAL_REQUEST, 0x24, 0x0);
 	/* "Invalid field in cbd" */
-	done(cmd);
+	cmd->scsi_done(cmd);
 }
 
 /**
@@ -719,7 +718,6 @@ EXPORT_SYMBOL_GPL(ata_scsi_ioctl);
  *	ata_scsi_qc_new - acquire new ata_queued_cmd reference
  *	@dev: ATA device to which the new command is attached
  *	@cmd: SCSI command that originated this ATA command
- *	@done: SCSI command completion function
  *
  *	Obtain a reference to an unused ata_queued_cmd structure,
  *	which is the basic libata structure representing a single
@@ -736,21 +734,20 @@ EXPORT_SYMBOL_GPL(ata_scsi_ioctl);
  *	Command allocated, or %NULL if none available.
  */
 static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
-					      struct scsi_cmnd *cmd,
-					      void (*done)(struct scsi_cmnd *))
+					      struct scsi_cmnd *cmd)
 {
 	struct ata_queued_cmd *qc;
 
 	qc = ata_qc_new_init(dev);
 	if (qc) {
 		qc->scsicmd = cmd;
-		qc->scsidone = done;
+		qc->scsidone = cmd->scsi_done;
 
 		qc->sg = scsi_sglist(cmd);
 		qc->n_elem = scsi_sg_count(cmd);
 	} else {
 		cmd->result = (DID_OK << 16) | (QUEUE_FULL << 1);
-		done(cmd);
+		cmd->scsi_done(cmd);
 	}
 
 	return qc;
@@ -1735,7 +1732,6 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
  *	ata_scsi_translate - Translate then issue SCSI command to ATA device
  *	@dev: ATA device to which the command is addressed
  *	@cmd: SCSI command to execute
- *	@done: SCSI command completion function
  *	@xlat_func: Actor which translates @cmd to an ATA taskfile
  *
  *	Our ->queuecommand() function has decided that the SCSI
@@ -1759,7 +1755,6 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
  *	needs to be deferred.
  */
 static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
-			      void (*done)(struct scsi_cmnd *),
 			      ata_xlat_func_t xlat_func)
 {
 	struct ata_port *ap = dev->link->ap;
@@ -1768,7 +1763,7 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 
 	VPRINTK("ENTER\n");
 
-	qc = ata_scsi_qc_new(dev, cmd, done);
+	qc = ata_scsi_qc_new(dev, cmd);
 	if (!qc)
 		goto err_mem;
 
@@ -1804,14 +1799,14 @@ static int ata_scsi_translate(struct ata_device *dev, struct scsi_cmnd *cmd,
 
 early_finish:
 	ata_qc_free(qc);
-	qc->scsidone(cmd);
+	cmd->scsi_done(cmd);
 	DPRINTK("EXIT - early finish (good or error)\n");
 	return 0;
 
 err_did:
 	ata_qc_free(qc);
 	cmd->result = (DID_ERROR << 16);
-	qc->scsidone(cmd);
+	cmd->scsi_done(cmd);
 err_mem:
 	DPRINTK("EXIT - internal\n");
 	return 0;
@@ -3116,7 +3111,6 @@ static inline void ata_scsi_dump_cdb(struct ata_port *ap,
 }
 
 static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
-				      void (*done)(struct scsi_cmnd *),
 				      struct ata_device *dev)
 {
 	u8 scsi_op = scmd->cmnd[0];
@@ -3150,9 +3144,9 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
 	}
 
 	if (xlat_func)
-		rc = ata_scsi_translate(dev, scmd, done, xlat_func);
+		rc = ata_scsi_translate(dev, scmd, xlat_func);
 	else
-		ata_scsi_simulate(dev, scmd, done);
+		ata_scsi_simulate(dev, scmd);
 
 	return rc;
 
@@ -3160,7 +3154,7 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
 	DPRINTK("bad CDB len=%u, scsi_op=0x%02x, max=%u\n",
 		scmd->cmd_len, scsi_op, dev->cdb_len);
 	scmd->result = DID_ERROR << 16;
-	done(scmd);
+	scmd->scsi_done(scmd);
 	return 0;
 }
 
@@ -3199,7 +3193,7 @@ int ata_scsi_queuecmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 
 	dev = ata_scsi_find_dev(ap, scsidev);
 	if (likely(dev))
-		rc = __ata_scsi_queuecmd(cmd, cmd->scsi_done, dev);
+		rc = __ata_scsi_queuecmd(cmd, dev);
 	else {
 		cmd->result = (DID_BAD_TARGET << 16);
 		cmd->scsi_done(cmd);
@@ -3214,7 +3208,6 @@ int ata_scsi_queuecmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
  *	ata_scsi_simulate - simulate SCSI command on ATA device
  *	@dev: the target device
  *	@cmd: SCSI command being sent to device.
- *	@done: SCSI command completion function.
  *
  *	Interprets and directly executes a select list of SCSI commands
  *	that can be handled internally.
@@ -3223,8 +3216,7 @@ int ata_scsi_queuecmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
  *	spin_lock_irqsave(host lock)
  */
 
-void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
-		      void (*done)(struct scsi_cmnd *))
+void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 {
 	struct ata_scsi_args args;
 	const u8 *scsicmd = cmd->cmnd;
@@ -3233,17 +3225,17 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 	args.dev = dev;
 	args.id = dev->id;
 	args.cmd = cmd;
-	args.done = done;
+	args.done = cmd->scsi_done;
 
 	switch(scsicmd[0]) {
 	/* TODO: worth improving? */
 	case FORMAT_UNIT:
-		ata_scsi_invalid_field(cmd, done);
+		ata_scsi_invalid_field(cmd);
 		break;
 
 	case INQUIRY:
 		if (scsicmd[1] & 2)	           /* is CmdDt set?  */
-			ata_scsi_invalid_field(cmd, done);
+			ata_scsi_invalid_field(cmd);
 		else if ((scsicmd[1] & 1) == 0)    /* is EVPD clear? */
 			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_std);
 		else switch (scsicmd[2]) {
@@ -3269,7 +3261,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b2);
 			break;
 		default:
-			ata_scsi_invalid_field(cmd, done);
+			ata_scsi_invalid_field(cmd);
 			break;
 		}
 		break;
@@ -3281,7 +3273,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 
 	case MODE_SELECT:	/* unconditionally return */
 	case MODE_SELECT_10:	/* bad-field-in-cdb */
-		ata_scsi_invalid_field(cmd, done);
+		ata_scsi_invalid_field(cmd);
 		break;
 
 	case READ_CAPACITY:
@@ -3292,7 +3284,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 		if ((scsicmd[1] & 0x1f) == SAI_READ_CAPACITY_16)
 			ata_scsi_rbuf_fill(&args, ata_scsiop_read_cap);
 		else
-			ata_scsi_invalid_field(cmd, done);
+			ata_scsi_invalid_field(cmd);
 		break;
 
 	case REPORT_LUNS:
@@ -3302,7 +3294,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 	case REQUEST_SENSE:
 		ata_scsi_set_sense(cmd, 0, 0, 0);
 		cmd->result = (DRIVER_SENSE << 24);
-		done(cmd);
+		cmd->scsi_done(cmd);
 		break;
 
 	/* if we reach this, then writeback caching is disabled,
@@ -3324,14 +3316,14 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 		if ((tmp8 == 0x4) && (!scsicmd[3]) && (!scsicmd[4]))
 			ata_scsi_rbuf_fill(&args, ata_scsiop_noop);
 		else
-			ata_scsi_invalid_field(cmd, done);
+			ata_scsi_invalid_field(cmd);
 		break;
 
 	/* all other commands */
 	default:
 		ata_scsi_set_sense(cmd, ILLEGAL_REQUEST, 0x20, 0x0);
 		/* "Invalid command operation code" */
-		done(cmd);
+		cmd->scsi_done(cmd);
 		break;
 	}
 }
@@ -3858,7 +3850,6 @@ EXPORT_SYMBOL_GPL(ata_sas_slave_configure);
 /**
  *	ata_sas_queuecmd - Issue SCSI cdb to libata-managed device
  *	@cmd: SCSI command to be sent
- *	@done: Completion function, called when command is complete
  *	@ap:	ATA port to which the command is being sent
  *
  *	RETURNS:
@@ -3866,18 +3857,17 @@ EXPORT_SYMBOL_GPL(ata_sas_slave_configure);
  *	0 otherwise.
  */
 
-int ata_sas_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *),
-		     struct ata_port *ap)
+int ata_sas_queuecmd(struct scsi_cmnd *cmd, struct ata_port *ap)
 {
 	int rc = 0;
 
 	ata_scsi_dump_cdb(ap, cmd);
 
 	if (likely(ata_dev_enabled(ap->link.device)))
-		rc = __ata_scsi_queuecmd(cmd, done, ap->link.device);
+		rc = __ata_scsi_queuecmd(cmd, ap->link.device);
 	else {
 		cmd->result = (DID_BAD_TARGET << 16);
-		done(cmd);
+		cmd->scsi_done(cmd);
 	}
 	return rc;
 }
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 5bbaee5..2c71927 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5743,7 +5743,7 @@ static int ipr_queuecommand_lck(struct scsi_cmnd *scsi_cmd,
 	}
 
 	if (ipr_is_gata(res) && res->sata_port)
-		return ata_sas_queuecmd(scsi_cmd, done, res->sata_port->ap);
+		return ata_sas_queuecmd(scsi_cmd, res->sata_port->ap);
 
 	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
 	ioarcb = &ipr_cmd->ioarcb;
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 29251fa..5815cbe 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -211,8 +211,7 @@ static int sas_queuecommand_lck(struct scsi_cmnd *cmd,
 			unsigned long flags;
 
 			spin_lock_irqsave(dev->sata_dev.ap->lock, flags);
-			res = ata_sas_queuecmd(cmd, scsi_done,
-					       dev->sata_dev.ap);
+			res = ata_sas_queuecmd(cmd, dev->sata_dev.ap);
 			spin_unlock_irqrestore(dev->sata_dev.ap->lock, flags);
 			goto out;
 		}
diff --git a/include/linux/libata.h b/include/linux/libata.h
index d947b12..c9c5d7a 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -996,8 +996,7 @@ extern int ata_sas_port_init(struct ata_port *);
 extern int ata_sas_port_start(struct ata_port *ap);
 extern void ata_sas_port_stop(struct ata_port *ap);
 extern int ata_sas_slave_configure(struct scsi_device *, struct ata_port *);
-extern int ata_sas_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *),
-			    struct ata_port *ap);
+extern int ata_sas_queuecmd(struct scsi_cmnd *cmd, struct ata_port *ap);
 extern int sata_scr_valid(struct ata_link *link);
 extern int sata_scr_read(struct ata_link *link, int reg, u32 *val);
 extern int sata_scr_write(struct ata_link *link, int reg, u32 val);
@@ -1040,8 +1039,7 @@ extern unsigned int ata_do_dev_read_id(struct ata_device *dev,
 					struct ata_taskfile *tf, u16 *id);
 extern void ata_qc_complete(struct ata_queued_cmd *qc);
 extern int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active);
-extern void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
-			      void (*done)(struct scsi_cmnd *));
+extern void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd);
 extern int ata_std_bios_param(struct scsi_device *sdev,
 			      struct block_device *bdev,
 			      sector_t capacity, int geom[]);
