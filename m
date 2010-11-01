From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Full hostlock pushdown available
Date: Mon, 1 Nov 2010 18:57:42 +0100
Message-ID: <20101101175742.GG25817@basil.fritz.box>
References: <20101028150508.GA2385@basil.fritz.box>
 <4CCD5F7F.8020808@panasas.com>
 <tkrat.c4793af298337eff@s5r6.in-berlin.de>
 <4CCE271D.7040400@garzik.org>
 <20101101135338.GA25817@basil.fritz.box>
 <4CCEE33F.5030300@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:46708 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab0KAR5v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2010 13:57:51 -0400
Content-Disposition: inline
In-Reply-To: <4CCEE33F.5030300@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andi Kleen <andi@firstfloor.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Boaz Harrosh <bharrosh@panasas.com>, James.Bottomley@suse.de, nab@linux-iscsi.org, linux-scsi@vger.kernel.org

On Mon, Nov 01, 2010 at 11:56:47AM -0400, Jeff Garzik wrote:
> On 11/01/2010 09:53 AM, Andi Kleen wrote:
> >>> Missing drivers/ata/libata-scsi.c modification?
> 
> >Ah thanks for noticing. I missed that because it defined queuecommand
> >in a header plus a macro. Fixed in the tree. I also did another grep to make
> >sure there a no other occurrences. And fixed some documentation.
> >
> >Updated tree
> 
> You have just recreated the same bug Nicholas did:  you incorrectly
> removed the required _irqsave and _irqrestore from ap->lock.
> 

Hi Jeff,

Yes you caught me -- i had one or two non mechanical ones and that
was one of them. Here's an improved version which is truly mechanical,
but has some very redundant lock sequences. I also fixed some other
issues.

James, unless anyone else finds issues this one seems good to pull.

-Andi

Git tree with consolidated patch

The following changes since commit 39764981e772adc832d8a96e6540be346a830ca2:

  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6 (2010-10-27 20:54:34 +0200)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc-2.6 hostlock2

Andi Kleen (2):
      SCSI: The great hostlock pushdown
      SCSI: aha1740: Avoid instant deadlock

 Documentation/scsi/scsi_mid_low_api.txt |    8 ++++++--
 arch/ia64/hp/sim/simscsi.c              |    7 +++++++
 drivers/ata/libata-scsi.c               |    6 +++++-
 drivers/block/cciss_scsi.c              |    6 ++++++
 drivers/firewire/sbp2.c                 |    6 ++++++
 drivers/infiniband/ulp/srp/ib_srp.c     |    6 ++++++
 drivers/message/fusion/mptfc.c          |    7 +++++++
 drivers/message/fusion/mptsas.c         |    9 ++++++++-
 drivers/message/fusion/mptspi.c         |    6 ++++++
 drivers/message/i2o/i2o_scsi.c          |    5 +++++
 drivers/s390/scsi/zfcp_scsi.c           |    8 ++++++++
 drivers/scsi/3w-9xxx.c                  |    4 ++++
 drivers/scsi/3w-sas.c                   |    4 ++++
 drivers/scsi/3w-xxxx.c                  |    4 ++++
 drivers/scsi/53c700.c                   |    7 +++++++
 drivers/scsi/BusLogic.c                 |    7 +++++++
 drivers/scsi/NCR5380.c                  |    6 ++++++
 drivers/scsi/NCR53c406a.c               |    4 ++++
 drivers/scsi/a100u2w.c                  |    9 ++++++++-
 drivers/scsi/aacraid/linit.c            |   15 ++++++++++++---
 drivers/scsi/advansys.c                 |    4 ++++
 drivers/scsi/aha152x.c                  |   10 +++++++++-
 drivers/scsi/aha1542.c                  |   12 ++++++++++--
 drivers/scsi/aha1740.c                  |   11 +++++++++++
 drivers/scsi/aic7xxx/aic79xx_osm.c      |    4 ++++
 drivers/scsi/aic7xxx/aic7xxx_osm.c      |    4 ++++
 drivers/scsi/aic7xxx_old.c              |    5 +++++
 drivers/scsi/arcmsr/arcmsr_hba.c        |   19 ++++++++++++++++---
 drivers/scsi/arm/acornscsi.c            |    6 ++++++
 drivers/scsi/arm/fas216.c               |    8 ++++++++
 drivers/scsi/atp870u.c                  |    8 ++++++++
 drivers/scsi/bfa/bfad_im.c              |   11 ++++++++++-
 drivers/scsi/dc395x.c                   |    7 +++++++
 drivers/scsi/dpt_i2o.c                  |    9 +++++++++
 drivers/scsi/eata.c                     |    7 +++++++
 drivers/scsi/eata_pio.c                 |    5 +++++
 drivers/scsi/esp_scsi.c                 |    8 +++++++-
 drivers/scsi/fd_mcs.c                   |    4 ++++
 drivers/scsi/fdomain.c                  |    4 ++++
 drivers/scsi/fnic/fnic_scsi.c           |    9 ++++++++-
 drivers/scsi/gdth.c                     |    4 ++++
 drivers/scsi/hpsa.c                     |    7 +++++++
 drivers/scsi/hptiop.c                   |    6 ++++++
 drivers/scsi/ibmmca.c                   |   12 ++++++++++++
 drivers/scsi/ibmvscsi/ibmvfc.c          |   13 +++++++++++--
 drivers/scsi/ibmvscsi/ibmvscsi.c        |    9 ++++++++-
 drivers/scsi/imm.c                      |    5 +++++
 drivers/scsi/in2000.c                   |    4 ++++
 drivers/scsi/initio.c                   |    8 +++++++-
 drivers/scsi/ipr.c                      |   17 ++++++++++++++---
 drivers/scsi/ips.c                      |   18 ++++++++++++++++--
 drivers/scsi/libfc/fc_fcp.c             |    5 +++++
 drivers/scsi/libiscsi.c                 |    7 +++++++
 drivers/scsi/libsas/sas_scsi_host.c     |    4 ++++
 drivers/scsi/lpfc/lpfc_scsi.c           |    7 +++++++
 drivers/scsi/mac53c94.c                 |    4 ++++
 drivers/scsi/megaraid.c                 |    4 ++++
 drivers/scsi/megaraid/megaraid_mbox.c   |    5 +++++
 drivers/scsi/megaraid/megaraid_sas.c    |   14 ++++++++++++--
 drivers/scsi/mesh.c                     |    4 ++++
 drivers/scsi/mpt2sas/mpt2sas_scsih.c    |   17 +++++++++++++++--
 drivers/scsi/ncr53c8xx.c                |    4 ++++
 drivers/scsi/nsp32.c                    |    8 ++++++++
 drivers/scsi/pcmcia/nsp_cs.c            |    6 ++++++
 drivers/scsi/pcmcia/sym53c500_cs.c      |    4 ++++
 drivers/scsi/pmcraid.c                  |   11 ++++++++++-
 drivers/scsi/ppa.c                      |    5 +++++
 drivers/scsi/ps3rom.c                   |    4 ++++
 drivers/scsi/qla1280.c                  |    4 ++++
 drivers/scsi/qla2xxx/qla_os.c           |    7 +++++++
 drivers/scsi/qla4xxx/ql4_os.c           |    7 +++++++
 drivers/scsi/qlogicfas408.c             |    4 ++++
 drivers/scsi/qlogicpti.c                |    5 +++++
 drivers/scsi/scsi.c                     |   15 +++------------
 drivers/scsi/stex.c                     |   20 ++++++++++++++++++--
 drivers/scsi/sun3_NCR5380.c             |    8 ++++++++
 drivers/scsi/sym53c416.c                |    4 ++++
 drivers/scsi/sym53c8xx_2/sym_glue.c     |   12 ++++++++++--
 drivers/scsi/tmscsim.c                  |    5 +++++
 drivers/scsi/u14-34f.c                  |    7 +++++++
 drivers/scsi/ultrastor.c                |    7 +++++++
 drivers/scsi/vmw_pvscsi.c               |    5 +++++
 drivers/scsi/wd33c93.c                  |    6 +++++-
 drivers/scsi/wd7000.c                   |    4 ++++
 drivers/staging/hv/storvsc_drv.c        |    8 ++++++++
 drivers/usb/image/microtek.c            |    4 ++++
 drivers/usb/storage/scsiglue.c          |    6 ++++++
 drivers/usb/storage/uas.c               |    9 ++++++++-
 include/scsi/scsi_host.h                |    1 +
 89 files changed, 604 insertions(+), 49 deletions(-)


diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
index 570ef2b..9dabc7f 100644
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -1087,11 +1087,15 @@ Details:
  *      non-zero return, it must not execute the command's done
  *      callback at any time.
  *
- *      Locks: struct Scsi_Host::host_lock held on entry (with "irqsave")
- *             and is expected to be held on return.
+ *	Locks: No locks are hold. If host_lock is needed this function
+ *	needs to take it by itself.
  *
  *      Calling context: in interrupt (soft irq) or process context
  *
+ *	When this function needs a serial number in the SCSI command
+ *	it needs to call scsi_cmd_get_serial with the lock hold
+ *	to get it. Usually it's not needed.
+ *
  *      Notes: This function should be relatively fast. Normally it will
  *      not wait for IO to complete. Hence the 'done' callback is invoked 
  *      (often directly from an interrupt service routine) some time after
diff --git a/arch/ia64/hp/sim/simscsi.c b/arch/ia64/hp/sim/simscsi.c
index 3a078ad..ce32f2c 100644
--- a/arch/ia64/hp/sim/simscsi.c
+++ b/arch/ia64/hp/sim/simscsi.c
@@ -209,6 +209,8 @@ simscsi_queuecommand (struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 	size_t disk_size;
 	char *buf;
 	char localbuf[36];
+	unsigned long irqflags;
+
 #if DEBUG_SIMSCSI
 	register long sp asm ("sp");
 
@@ -217,6 +219,9 @@ simscsi_queuecommand (struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		       target_id, sc->cmnd[0], sc->serial_number, sp, done);
 #endif
 
+	spin_lock_irqsave(sc->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(sc->device->host);
+
 	sc->result = DID_BAD_TARGET << 16;
 	sc->scsi_done = done;
 	if (target_id <= 15 && sc->device->lun == 0) {
@@ -323,6 +328,8 @@ simscsi_queuecommand (struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 	wr = (wr + 1) % SIMSCSI_REQ_QUEUE_LEN;
 
 	tasklet_schedule(&simscsi_tasklet);
+
+	spin_unlock_irqrestore(sc->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index d050e07..3e2f3e3 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3186,11 +3186,14 @@ int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	struct ata_device *dev;
 	struct scsi_device *scsidev = cmd->device;
 	struct Scsi_Host *shost = scsidev->host;
+	unsigned long irqflags;
 	int rc = 0;
 
 	ap = ata_shost_to_port(shost);
 
-	spin_unlock(shost->host_lock);
+	spin_lock_irqsave(shost->host_lock, irqflags);
+	scsi_cmd_get_serial(shost, cmd);
+
 	spin_lock(ap->lock);
 
 	ata_scsi_dump_cdb(ap, cmd);
@@ -3205,6 +3208,7 @@ int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 
 	spin_unlock(ap->lock);
 	spin_lock(shost->host_lock);
+	spin_unlock_irqrestore(shost->host_lock, irqflags);
 	return rc;
 }
 
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 575495f..4122788 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -1413,9 +1413,12 @@ cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd
 	unsigned char scsi3addr[8];
 	CommandList_struct *c;
 	unsigned long flags;
+	unsigned long irqflags;
 
 	// Get the ptr to our adapter structure (hba[i]) out of cmd->host.
 	// We violate cmd->host privacy here.  (Is there another way?)
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	h = (ctlr_info_t *) cmd->device->host->hostdata[0];
 
 	rc = lookup_scsi3addr(h, cmd->device->channel, cmd->device->id,
@@ -1427,6 +1430,7 @@ cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd
 		done(cmd);
 		/* we might want to think about registering controller itself
 		   as a processor device on the bus so sg binds to it. */
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -1441,6 +1445,7 @@ cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd
 		/* FIXME: next 3 lines are -> BAD! <- */
 		cmd->result = DID_NO_CONNECT << 16;
 		done(cmd);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -1501,6 +1506,7 @@ cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd
 	cciss_scatter_gather(h, c, cmd);
 	enqueue_cmd_and_start_io(h, c);
 	/* the cmd'll come back via intr handler in complete_scsi_command()  */
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index bfae4b3..23266fc 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1474,21 +1474,26 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 	struct fw_device *device = target_device(lu->tgt);
 	struct sbp2_command_orb *orb;
 	int generation, retval = SCSI_MLQUEUE_HOST_BUSY;
+	unsigned long irqflags;
 
 	/*
 	 * Bidirectional commands are not yet implemented, and unknown
 	 * transfer direction not handled.
 	 */
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	if (cmd->sc_data_direction == DMA_BIDIRECTIONAL) {
 		fw_error("Can't handle DMA_BIDIRECTIONAL, rejecting command\n");
 		cmd->result = DID_ERROR << 16;
 		done(cmd);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return 0;
 	}
 
 	orb = kzalloc(sizeof(*orb), GFP_ATOMIC);
 	if (orb == NULL) {
 		fw_notify("failed to alloc orb\n");
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -1531,6 +1536,7 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 	retval = 0;
  out:
 	kref_put(&orb->base.kref, free_orb);
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return retval;
 }
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index cfc1d65..52c9d2e 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1132,7 +1132,10 @@ static int srp_queuecommand(struct scsi_cmnd *scmnd,
 	struct srp_cmd *cmd;
 	struct ib_device *dev;
 	int len;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(scmnd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(scmnd->device->host, scmnd);
 	if (target->state == SRP_TARGET_CONNECTING)
 		goto err;
 
@@ -1140,6 +1143,7 @@ static int srp_queuecommand(struct scsi_cmnd *scmnd,
 	    target->state == SRP_TARGET_REMOVED) {
 		scmnd->result = DID_BAD_TARGET << 16;
 		done(scmnd);
+		spin_unlock_irqrestore(scmnd->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -1187,12 +1191,14 @@ static int srp_queuecommand(struct scsi_cmnd *scmnd,
 
 	list_move_tail(&req->list, &target->req_queue);
 
+	spin_unlock_irqrestore(scmnd->device->host->host_lock, irqflags);
 	return 0;
 
 err_unmap:
 	srp_unmap_data(scmnd, target, req);
 
 err:
+	spin_unlock_irqrestore(scmnd->device->host->host_lock, irqflags);
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index e15220f..6e5a2b0 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -656,10 +656,14 @@ mptfc_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	struct fc_rport	*rport = starget_to_rport(scsi_target(SCpnt->device));
 	int		err;
 	VirtDevice	*vdevice = SCpnt->device->hostdata;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
 	if (!vdevice || !vdevice->vtarget) {
 		SCpnt->result = DID_NO_CONNECT << 16;
 		done(SCpnt);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -667,6 +671,7 @@ mptfc_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	if (unlikely(err)) {
 		SCpnt->result = err;
 		done(SCpnt);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -675,9 +680,11 @@ mptfc_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	if (unlikely(!ri)) {
 		SCpnt->result = DID_IMM_RETRY << 16;
 		done(SCpnt);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 		return 0;
 	}
 
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return mptscsih_qcmd(SCpnt,done);
 }
 
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 83a5115..7e9fcf5 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1894,22 +1894,29 @@ mptsas_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	MPT_SCSI_HOST	*hd;
 	MPT_ADAPTER	*ioc;
 	VirtDevice	*vdevice = SCpnt->device->hostdata;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
 	if (!vdevice || !vdevice->vtarget || vdevice->vtarget->deleted) {
 		SCpnt->result = DID_NO_CONNECT << 16;
 		done(SCpnt);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 		return 0;
 	}
 
 	hd = shost_priv(SCpnt->device->host);
 	ioc = hd->ioc;
 
-	if (ioc->sas_discovery_quiesce_io)
+	if (ioc->sas_discovery_quiesce_io) {
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	if (ioc->debug_level & MPT_DEBUG_SCSI)
 		scsi_print_command(SCpnt);
 
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return mptscsih_qcmd(SCpnt,done);
 }
 
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 0e28031..2a75e9a 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -785,10 +785,14 @@ mptspi_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	struct _MPT_SCSI_HOST *hd = shost_priv(SCpnt->device->host);
 	VirtDevice	*vdevice = SCpnt->device->hostdata;
 	MPT_ADAPTER *ioc = hd->ioc;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
 	if (!vdevice || !vdevice->vtarget) {
 		SCpnt->result = DID_NO_CONNECT << 16;
 		done(SCpnt);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -796,12 +800,14 @@ mptspi_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 		mptscsih_is_phys_disk(ioc, 0, SCpnt->device->id) == 0) {
 		SCpnt->result = DID_NO_CONNECT << 16;
 		done(SCpnt);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 		return 0;
 	}
 
 	if (spi_dv_pending(scsi_target(SCpnt->device)))
 		ddvprintk(ioc, scsi_print_command(SCpnt));
 
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return mptscsih_qcmd(SCpnt,done);
 }
 
diff --git a/drivers/message/i2o/i2o_scsi.c b/drivers/message/i2o/i2o_scsi.c
index ea6b219..21056dd 100644
--- a/drivers/message/i2o/i2o_scsi.c
+++ b/drivers/message/i2o/i2o_scsi.c
@@ -527,6 +527,9 @@ static int i2o_scsi_queuecommand(struct scsi_cmnd *SCpnt,
 	/*
 	 *      Do the incoming paperwork
 	 */
+	unsigned long irqflags;
+	spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
 	i2o_dev = SCpnt->device->hostdata;
 
 	SCpnt->scsi_done = done;
@@ -680,6 +683,7 @@ static int i2o_scsi_queuecommand(struct scsi_cmnd *SCpnt,
 
 	osm_debug("Issued %ld\n", SCpnt->serial_number);
 
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return 0;
 
       nomem:
@@ -687,6 +691,7 @@ static int i2o_scsi_queuecommand(struct scsi_cmnd *SCpnt,
 	i2o_msg_nop(c, msg);
 
       exit:
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return rc;
 };
 
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 50286d8..c28e5fe 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -83,6 +83,10 @@ static int zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
 	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
 	struct fc_rport *rport = starget_to_rport(scsi_target(scpnt->device));
 	int    status, scsi_result, ret;
+	unsigned long irqflags;
+
+	spin_lock_irqsave(scpnt->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(scpnt->device->host, scpnt);
 
 	/* reset the status for this request */
 	scpnt->result = 0;
@@ -94,6 +98,7 @@ static int zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
 		scpnt->result = scsi_result;
 		zfcp_dbf_scsi_fail_send(adapter->dbf, scpnt);
 		scpnt->scsi_done(scpnt);
+		spin_unlock_irqrestore(scpnt->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -104,6 +109,7 @@ static int zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
 		/* only LUN access denied, but port is good
 		 * not covered by FC transport, have to fail here */
 		zfcp_scsi_command_fail(scpnt, DID_ERROR);
+		spin_unlock_irqrestore(scpnt->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -115,10 +121,12 @@ static int zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
 		 * 	fc_remote_port_chkready until rport is BLOCKED
 		 */
 		zfcp_scsi_command_fail(scpnt, DID_IMM_RETRY);
+		spin_unlock_irqrestore(scpnt->device->host->host_lock, irqflags);
 		return 0;
 	}
 
 	ret = zfcp_fsf_fcp_cmnd(scpnt);
+	spin_unlock_irqrestore(scpnt->device->host->host_lock, irqflags);
 	if (unlikely(ret == -EBUSY))
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	else if (unlikely(ret < 0))
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index fcf08b3..3ad0f51 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1769,7 +1769,10 @@ static int twa_scsi_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd
 {
 	int request_id, retval;
 	TW_Device_Extension *tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
 	/* If we are resetting due to timed out ioctl, report as busy */
 	if (test_bit(TW_IN_RESET, &tw_dev->flags)) {
 		retval = SCSI_MLQUEUE_HOST_BUSY;
@@ -1809,6 +1812,7 @@ static int twa_scsi_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd
 		retval = 0;
 	}
 out:
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return retval;
 } /* End twa_scsi_queue() */
 
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 6a95d11..de5d845 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1505,7 +1505,10 @@ static int twl_scsi_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd
 {
 	int request_id, retval;
 	TW_Device_Extension *tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
 	/* If we are resetting due to timed out ioctl, report as busy */
 	if (test_bit(TW_IN_RESET, &tw_dev->flags)) {
 		retval = SCSI_MLQUEUE_HOST_BUSY;
@@ -1533,6 +1536,7 @@ static int twl_scsi_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd
 		retval = 0;
 	}
 out:
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return retval;
 } /* End twl_scsi_queue() */
 
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index b112534..6812acc 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1953,7 +1953,10 @@ static int tw_scsi_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd
 	int request_id = 0;
 	int retval = 1;
 	TW_Device_Extension *tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
 	/* If we are resetting due to timed out ioctl, report as busy */
 	if (test_bit(TW_IN_RESET, &tw_dev->flags))
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -2020,6 +2023,7 @@ static int tw_scsi_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd
 		done(SCpnt);
 		retval = 0;
 	}
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return retval;
 } /* End tw_scsi_queue() */
 
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 89fc1c8..6bd1c22 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1757,11 +1757,15 @@ NCR_700_queuecommand(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *))
 	__u32 move_ins;
 	enum dma_data_direction direction;
 	struct NCR_700_command_slot *slot;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(SCp->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(SCp->device->host, SCp);
 	if(hostdata->command_slot_count >= NCR_700_COMMAND_SLOTS_PER_HOST) {
 		/* We're over our allocation, this should never happen
 		 * since we report the max allocation to the mid layer */
 		printk(KERN_WARNING "scsi%d: Command depth has gone over queue depth\n", SCp->device->host->host_no);
+		spin_unlock_irqrestore(SCp->device->host->host_lock, irqflags);
 		return 1;
 	}
 	/* check for untagged commands.  We cannot have any outstanding
@@ -1775,11 +1779,13 @@ NCR_700_queuecommand(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *))
 	       || !blk_rq_tagged(SCp->request))) {
 		CDEBUG(KERN_ERR, SCp, "has non zero depth %d\n",
 		       NCR_700_get_depth(SCp->device));
+		spin_unlock_irqrestore(SCp->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 	if(NCR_700_get_depth(SCp->device) >= SCp->device->queue_depth) {
 		CDEBUG(KERN_ERR, SCp, "has max tag depth %d\n",
 		       NCR_700_get_depth(SCp->device));
+		spin_unlock_irqrestore(SCp->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 	NCR_700_set_depth(SCp->device, NCR_700_get_depth(SCp->device) + 1);
@@ -1901,6 +1907,7 @@ NCR_700_queuecommand(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *))
 	slot->pCmd = dma_map_single(hostdata->dev, SCp->cmnd,
 				    MAX_COMMAND_SIZE, DMA_TO_DEVICE);
 	NCR_700_start_command(SCp);
+	spin_unlock_irqrestore(SCp->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index fc0b4b8..10ce6fb 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2819,14 +2819,19 @@ static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRou
 	int BufferLength = scsi_bufflen(Command);
 	int Count;
 	struct BusLogic_CCB *CCB;
+	unsigned long irqflags;
 	/*
 	   SCSI REQUEST_SENSE commands will be executed automatically by the Host
 	   Adapter for any errors, so they should not be executed explicitly unless
 	   the Sense Data is zero indicating that no error occurred.
 	 */
+
+	spin_lock_irqsave(Command->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(Command->device->host, Command);
 	if (CDB[0] == REQUEST_SENSE && Command->sense_buffer[0] != 0) {
 		Command->result = DID_OK << 16;
 		CompletionRoutine(Command);
+		spin_unlock_irqrestore(Command->device->host->host_lock, irqflags);
 		return 0;
 	}
 	/*
@@ -2844,6 +2849,7 @@ static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRou
 		if (CCB == NULL) {
 			Command->result = DID_ERROR << 16;
 			CompletionRoutine(Command);
+			spin_unlock_irqrestore(Command->device->host->host_lock, irqflags);
 			return 0;
 		}
 	}
@@ -2991,6 +2997,7 @@ static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRou
 		if (CCB->Status == BusLogic_CCB_Completed)
 			BusLogic_ProcessCompletedCCBs(HostAdapter);
 	}
+	spin_unlock_irqrestore(Command->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 5d2f148..f4bd889 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -957,6 +957,10 @@ static int NCR5380_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 	struct Scsi_Host *instance = cmd->device->host;
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 	Scsi_Cmnd *tmp;
+	unsigned long irqflags;
+
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 
 #if (NDEBUG & NDEBUG_NO_WRITE)
 	switch (cmd->cmnd[0]) {
@@ -965,6 +969,7 @@ static int NCR5380_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 		printk("scsi%d : WRITE attempted with NO_WRITE debugging flag set\n", instance->host_no);
 		cmd->result = (DID_ERROR << 16);
 		done(cmd);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return 0;
 	}
 #endif				/* (NDEBUG & NDEBUG_NO_WRITE) */
@@ -1018,6 +1023,7 @@ static int NCR5380_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 	/* Run the coroutine if it isn't already running. */
 	/* Kick off command processing */
 	schedule_delayed_work(&hostdata->coroutine, 0);
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
index 6961f78..b84bfe6 100644
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -696,7 +696,10 @@ static void wait_intr(void)
 static int NCR53c406a_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 {
 	int i;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
 	VDEB(printk("NCR53c406a_queue called\n"));
 	DEB(printk("cmd=%02x, cmd_len=%02x, target=%02x, lun=%02x, bufflen=%d\n", SCpnt->cmnd[0], SCpnt->cmd_len, SCpnt->target, SCpnt->lun, scsi_bufflen(SCpnt)));
 
@@ -723,6 +726,7 @@ static int NCR53c406a_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 	outb(SELECT_NO_ATN, CMD_REG);
 
 	rtrc(1);
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index dbbc601..1aa33f0 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -915,18 +915,25 @@ static int inia100_queue(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd
 {
 	struct orc_scb *scb;
 	struct orc_host *host;		/* Point to Host adapter control block */
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	host = (struct orc_host *) cmd->device->host->hostdata;
 	cmd->scsi_done = done;
 	/* Get free SCSI control block  */
-	if ((scb = orc_alloc_scb(host)) == NULL)
+	if ((scb = orc_alloc_scb(host)) == NULL) {
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	if (inia100_build_scb(host, scb, cmd)) {
 		orc_release_scb(host, scb);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 	orc_exec_scb(host, scb);	/* Start execute SCB            */
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 29c0ed1..1736fa2 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -253,6 +253,11 @@ static int aac_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd
 	struct Scsi_Host *host = cmd->device->host;
 	struct aac_dev *dev = (struct aac_dev *)host->hostdata;
 	u32 count = 0;
+	unsigned long irqflags;
+	int ret;
+
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	cmd->scsi_done = done;
 	for (; count < (host->can_queue + AAC_NUM_MGT_FIB); ++count) {
 		struct fib * fib = &dev->fibs[count];
@@ -260,11 +265,15 @@ static int aac_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd
 		if (fib->hw_fib_va->header.XferState &&
 		    ((command = fib->callback_data)) &&
 		    (command == cmd) &&
-		    (cmd->SCp.phase == AAC_OWNER_FIRMWARE))
-			return 0; /* Already owned by Adapter */
+		    (cmd->SCp.phase == AAC_OWNER_FIRMWARE)) {
+		    	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
+		    	return 0;
+		    } /* Already owned by Adapter */
 	}
 	cmd->SCp.phase = AAC_OWNER_LOWLEVEL;
-	return (aac_scsi_cmd(cmd) ? FAILED : 0);
+	ret = (aac_scsi_cmd(cmd) ? FAILED : 0);
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
+	return ret;
 }
 
 /**
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 0ec3da6..cb5e7c2 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -9504,7 +9504,10 @@ advansys_queuecommand(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
 {
 	struct Scsi_Host *shost = scp->device->host;
 	int asc_res, result = 0;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(scp->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(scp->device->host, scp);
 	ASC_STATS(shost, queuecommand);
 	scp->scsi_done = done;
 
@@ -9522,6 +9525,7 @@ advansys_queuecommand(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
 		break;
 	}
 
+	spin_unlock_irqrestore(scp->device->host->host_lock, irqflags);
 	return result;
 }
 
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 8eab858..055e953 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1058,6 +1058,12 @@ static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
  */
 static int aha152x_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
 {
+	unsigned long irqflags;
+	int ret;
+
+	spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
+
 #if 0
 	if(*SCpnt->cmnd == REQUEST_SENSE) {
 		SCpnt->result = 0;
@@ -1067,7 +1073,9 @@ static int aha152x_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
 	}
 #endif
 
-	return aha152x_internal_queue(SCpnt, NULL, 0, done);
+	ret = aha152x_internal_queue(SCpnt, NULL, 0, done);
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
+	return ret;
 }
 
 
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 4f785f2..f33b417 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -570,7 +570,10 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 	int mbo;
 	struct mailbox *mb;
 	struct ccb *ccb;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
 	DEB(int i);
 
 	mb = HOSTDATA(SCpnt->device->host)->mb;
@@ -593,6 +596,7 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 #endif
 		SCpnt->result = 0;
 		done(SCpnt);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 		return 0;
 	}
 #ifdef DEBUG
@@ -611,8 +615,10 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 	for (i = 0; i < SCpnt->cmd_len; i++)
 		printk("%02x ", cmd[i]);
 	printk("\n");
-	if (*cmd == WRITE_10 || *cmd == WRITE_6)
-		return 0;	/* we are still testing, so *don't* write */
+	if (*cmd == WRITE_10 || *cmd == WRITE_6) {
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
+		return 0;
+	}	/* we are still testing, so *don't* write */
 #endif
 	/* Use the outgoing mailboxes in a round-robin fashion, because this
 	   is how the host adapter will scan for them */
@@ -671,6 +677,7 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 		if (cptr == NULL) {
 			/* free the claimed mailbox slot */
 			HOSTDATA(SCpnt->device->host)->SCint[mbo] = NULL;
+			spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 			return SCSI_MLQUEUE_HOST_BUSY;
 		}
 		scsi_for_each_sg(SCpnt, sg, sg_count, i) {
@@ -715,6 +722,7 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 	} else
 		printk("aha1542_queuecommand: done can't be NULL\n");
 
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 0107a4c..b973e15 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -331,6 +331,7 @@ static irqreturn_t aha1740_intr_handle(int irq, void *dev_id)
 	return IRQ_RETVAL(handled);
 }
 
+/* AK: Did this driver ever work? */
 static int aha1740_queuecommand(Scsi_Cmnd * SCpnt, void (*done)(Scsi_Cmnd *))
 {
 	unchar direction;
@@ -341,14 +342,21 @@ static int aha1740_queuecommand(Scsi_Cmnd * SCpnt, void (*done)(Scsi_Cmnd *))
 	dma_addr_t sg_dma;
 	struct aha1740_sg *sgptr;
 	int ecbno, nseg;
+	unsigned long irqflags;
 	DEB(int i);
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
+
 	if(*cmd == REQUEST_SENSE) {
 		SCpnt->result = 0;
 		done(SCpnt); 
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 		return 0;
 	}
 
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
+
 #ifdef DEBUG
 	if (*cmd == READ_10 || *cmd == WRITE_10)
 		i = xscsi2int(cmd+2);
@@ -406,6 +414,7 @@ static int aha1740_queuecommand(Scsi_Cmnd * SCpnt, void (*done)(Scsi_Cmnd *))
 						   &sg_dma, GFP_ATOMIC);
 	if(SCpnt->host_scribble == NULL) {
 		printk(KERN_WARNING "aha1740: out of memory in queuecommand!\n");
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 		return 1;
 	}
 	sgptr = (struct aha1740_sg *) SCpnt->host_scribble;
@@ -500,6 +509,8 @@ static int aha1740_queuecommand(Scsi_Cmnd * SCpnt, void (*done)(Scsi_Cmnd *))
 		DEB(printk("aha1740[%d] request queued.\n",ecbno));
 	} else
 		printk(KERN_ALERT "aha1740_queuecommand: done can't be NULL\n");
+
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 88ad848..93e1070 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -578,13 +578,17 @@ ahd_linux_queue(struct scsi_cmnd * cmd, void (*scsi_done) (struct scsi_cmnd *))
 	struct	 ahd_softc *ahd;
 	struct	 ahd_linux_device *dev = scsi_transport_device_data(cmd->device);
 	int rtn = SCSI_MLQUEUE_HOST_BUSY;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
 
 	cmd->scsi_done = scsi_done;
 	cmd->result = CAM_REQ_INPROG << 16;
 	rtn = ahd_linux_run_command(ahd, dev, cmd);
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return rtn;
 }
 
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index aeea7a6..198390a 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -534,7 +534,10 @@ ahc_linux_queue(struct scsi_cmnd * cmd, void (*scsi_done) (struct scsi_cmnd *))
 	struct	 ahc_linux_device *dev = scsi_transport_device_data(cmd->device);
 	int rtn = SCSI_MLQUEUE_HOST_BUSY;
 	unsigned long flags;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
 
 	ahc_lock(ahc, &flags);
@@ -545,6 +548,7 @@ ahc_linux_queue(struct scsi_cmnd * cmd, void (*scsi_done) (struct scsi_cmnd *))
 	}
 	ahc_unlock(ahc, &flags);
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return rtn;
 }
 
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index aee73fa..97c4efc 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -10239,7 +10239,10 @@ static int aic7xxx_queue(struct scsi_cmnd *cmd, void (*fn)(struct scsi_cmnd *))
   struct aic7xxx_host *p;
   struct aic7xxx_scb *scb;
   struct aic_dev_data *aic_dev;
+  unsigned long irqflags;
 
+  spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+  scsi_cmd_get_serial(cmd->device->host, cmd);
   p = (struct aic7xxx_host *) cmd->device->host->hostdata;
 
   aic_dev = cmd->device->hostdata;  
@@ -10262,6 +10265,7 @@ static int aic7xxx_queue(struct scsi_cmnd *cmd, void (*fn)(struct scsi_cmnd *))
     {
       printk(WARN_LEAD "Couldn't get a free SCB.\n", p->host_no,
              CTL_OF_CMD(cmd));
+      spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
       return 1;
     }
   }
@@ -10289,6 +10293,7 @@ static int aic7xxx_queue(struct scsi_cmnd *cmd, void (*fn)(struct scsi_cmnd *))
 
   scbq_insert_tail(&p->waiting_scbs, scb);
   aic7xxx_run_waiting_queues(p);
+  spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
   return (0);
 }
 
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 05a78e5..8cddef3 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2090,6 +2090,10 @@ static int arcmsr_queue_command(struct scsi_cmnd *cmd,
 	int target = cmd->device->id;
 	int lun = cmd->device->lun;
 	uint8_t scsicmd = cmd->cmnd[0];
+	unsigned long irqflags;
+
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	cmd->scsi_done = done;
 	cmd->host_scribble = NULL;
 	cmd->result = 0;
@@ -2098,29 +2102,38 @@ static int arcmsr_queue_command(struct scsi_cmnd *cmd,
     			cmd->result = (DID_NO_CONNECT << 16);
 		}
 		cmd->scsi_done(cmd);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return 0;
 	}
 	if (target == 16) {
 		/* virtual device for iop message transfer */
 		arcmsr_handle_virtual_command(acb, cmd);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return 0;
 	}
 	if (atomic_read(&acb->ccboutstandingcount) >=
-			ARCMSR_MAX_OUTSTANDING_CMD)
-		return SCSI_MLQUEUE_HOST_BUSY;
+			ARCMSR_MAX_OUTSTANDING_CMD) {
+				spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
+				return SCSI_MLQUEUE_HOST_BUSY;
+			}
 	if ((scsicmd == SCSI_CMD_ARECA_SPECIFIC)) {
 		printk(KERN_NOTICE "Receiveing SCSI_CMD_ARECA_SPECIFIC command..\n");
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return 0;
 	}
 	ccb = arcmsr_get_freeccb(acb);
-	if (!ccb)
+	if (!ccb) {
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 	if (arcmsr_build_ccb( acb, ccb, cmd ) == FAILED) {
 		cmd->result = (DID_ERROR << 16) | (RESERVATION_CONFLICT << 1);
 		cmd->scsi_done(cmd);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return 0;
 	}
 	arcmsr_post_ccb(acb, ccb);
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 918ccf8..6f1049e 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -2515,7 +2515,10 @@ int acornscsi_queuecmd(struct scsi_cmnd *SCpnt,
 		       void (*done)(struct scsi_cmnd *))
 {
     AS_Host *host = (AS_Host *)SCpnt->device->host->hostdata;
+    unsigned long irqflags;
 
+    spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+    scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
     if (!done) {
 	/* there should be some way of rejecting errors like this without panicing... */
 	panic("scsi%d: queuecommand called with NULL done function [cmd=%p]",
@@ -2529,6 +2532,7 @@ int acornscsi_queuecmd(struct scsi_cmnd *SCpnt,
 	    host->host->host_no, '0' + SCpnt->device->id);
 	SCpnt->result = DID_NO_CONNECT << 16;
 	done(SCpnt);
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return 0;
     }
 #endif
@@ -2551,6 +2555,7 @@ int acornscsi_queuecmd(struct scsi_cmnd *SCpnt,
 	if (!queue_add_cmd_ordered(&host->queues.issue, SCpnt)) {
 	    SCpnt->result = DID_ERROR << 16;
 	    done(SCpnt);
+	    spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	    return 0;
 	}
 	local_irq_save(flags);
@@ -2558,6 +2563,7 @@ int acornscsi_queuecmd(struct scsi_cmnd *SCpnt,
 	    acornscsi_kick(host);
 	local_irq_restore(flags);
     }
+    spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
     return 0;
 }
 
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 9e71ac6..8cd9311 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2203,7 +2203,10 @@ int fas216_queue_command(struct scsi_cmnd *SCpnt,
 {
 	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
 	int result;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
 	fas216_checkmagic(info);
 
 	fas216_log_command(info, LOG_CONNECT, SCpnt,
@@ -2237,6 +2240,7 @@ int fas216_queue_command(struct scsi_cmnd *SCpnt,
 	fas216_log_target(info, LOG_CONNECT, -1, "queue %s",
 		result ? "failure" : "success");
 
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return result;
 }
 
@@ -2267,7 +2271,10 @@ int fas216_noqueue_command(struct scsi_cmnd *SCpnt,
 			   void (*done)(struct scsi_cmnd *))
 {
 	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
 	fas216_checkmagic(info);
 
 	/*
@@ -2307,6 +2314,7 @@ int fas216_noqueue_command(struct scsi_cmnd *SCpnt,
 
 	done(SCpnt);
 
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index ab5bdda..0ec5c9d 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -612,7 +612,10 @@ static int atp870u_queuecommand(struct scsi_cmnd * req_p,
 	unsigned int tmport,m;	
 	struct atp_unit *dev;
 	struct Scsi_Host *host;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(req_p->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(req_p->device->host, req_p);
 	c = scmd_channel(req_p);
 	req_p->sense_buffer[0]=0;
 	scsi_set_resid(req_p, 0);
@@ -622,6 +625,7 @@ static int atp870u_queuecommand(struct scsi_cmnd * req_p,
 #ifdef ED_DBGP		
 		printk("atp870u_queuecommand : req_p->device->channel > 1\n");	
 #endif			
+		spin_unlock_irqrestore(req_p->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -640,6 +644,7 @@ static int atp870u_queuecommand(struct scsi_cmnd * req_p,
 	if ((m & dev->active_id[c]) == 0) {
 		req_p->result = 0x00040000;
 		done(req_p);
+		spin_unlock_irqrestore(req_p->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -651,6 +656,7 @@ static int atp870u_queuecommand(struct scsi_cmnd * req_p,
 #endif		
 		req_p->result = 0;
 		done(req_p);
+		spin_unlock_irqrestore(req_p->device->host->host_lock, irqflags);
 		return 0;
 	}
 	
@@ -675,6 +681,7 @@ static int atp870u_queuecommand(struct scsi_cmnd * req_p,
 		dev->quend[c]--;
 		req_p->result = 0x00020000;
 		done(req_p);	
+		spin_unlock_irqrestore(req_p->device->host->host_lock, irqflags);
 		return 0;
 	}
 	dev->quereq[c][dev->quend[c]] = req_p;
@@ -691,6 +698,7 @@ static int atp870u_queuecommand(struct scsi_cmnd * req_p,
 #ifdef ED_DBGP	
 	printk("atp870u_queuecommand : exit\n");
 #endif	
+	spin_unlock_irqrestore(req_p->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index d950ee4..2796f73 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -1131,17 +1131,23 @@ bfad_im_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 	int             rc;
 	int       sg_cnt = 0;
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmnd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmnd->device->host, cmnd);
 	rc = fc_remote_port_chkready(rport);
 	if (rc) {
 		cmnd->result = rc;
 		done(cmnd);
+		spin_unlock_irqrestore(cmnd->device->host->host_lock, irqflags);
 		return 0;
 	}
 
 	sg_cnt = scsi_dma_map(cmnd);
-	if (sg_cnt < 0)
+	if (sg_cnt < 0) {
+		spin_unlock_irqrestore(cmnd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	cmnd->scsi_done = done;
 
@@ -1167,6 +1173,7 @@ bfad_im_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 		printk(KERN_WARNING "hal_io failure\n");
 		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 		scsi_dma_unmap(cmnd);
+		spin_unlock_irqrestore(cmnd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -1175,6 +1182,7 @@ bfad_im_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 	bfa_ioim_start(hal_io);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
+	spin_unlock_irqrestore(cmnd->device->host->host_lock, irqflags);
 	return 0;
 
 out_fail_cmd:
@@ -1183,6 +1191,7 @@ out_fail_cmd:
 	if (done)
 		done(cmnd);
 
+	spin_unlock_irqrestore(cmnd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 54f50b0..891614a 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1086,6 +1086,10 @@ static int dc395x_queue_command(struct scsi_cmnd *cmd, void (*done)(struct scsi_
 	struct ScsiReqBlk *srb;
 	struct AdapterCtlBlk *acb =
 	    (struct AdapterCtlBlk *)cmd->device->host->hostdata;
+	unsigned long irqflags;
+
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	dprintkdbg(DBG_0, "queue_command: (pid#%li) <%02i-%i> cmnd=0x%02x\n",
 		cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 
@@ -1127,6 +1131,7 @@ static int dc395x_queue_command(struct scsi_cmnd *cmd, void (*done)(struct scsi_
 		 * point in time.
 		 */
 		dprintkdbg(DBG_0, "queue_command: No free srb's\n");
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return 1;
 	}
 
@@ -1141,6 +1146,7 @@ static int dc395x_queue_command(struct scsi_cmnd *cmd, void (*done)(struct scsi_
 		send_srb(acb, srb);
 	}
 	dprintkdbg(DBG_1, "queue_command: (pid#%li) done\n", cmd->serial_number);
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 
 complete:
@@ -1151,6 +1157,7 @@ complete:
 	 * devices.
 	 */
 	done(cmd);
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 23dec00..901f952 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -427,7 +427,10 @@ static int adpt_queue(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
 {
 	adpt_hba* pHba = NULL;
 	struct adpt_device* pDev = NULL;	/* dpt per device information */
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	cmd->scsi_done = done;
 	/*
 	 * SCSI REQUEST_SENSE commands will be executed automatically by the 
@@ -439,11 +442,13 @@ static int adpt_queue(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
 	if ((cmd->cmnd[0] == REQUEST_SENSE) && (cmd->sense_buffer[0] != 0)) {
 		cmd->result = (DID_OK << 16);
 		cmd->scsi_done(cmd);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return 0;
 	}
 
 	pHba = (adpt_hba*)cmd->device->host->hostdata[0];
 	if (!pHba) {
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return FAILED;
 	}
 
@@ -459,6 +464,7 @@ static int adpt_queue(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
 	if(((pHba->state) & DPTI_STATE_IOCTL) || ((pHba->state) & DPTI_STATE_RESET)) {
 		pHba->host->last_reset = jiffies;
 		pHba->host->resetting = 1;
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return 1;
 	}
 
@@ -475,6 +481,7 @@ static int adpt_queue(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
 			// with type 7F (for all luns less than the max for this bus,id) so the lun scan will continue.
 			cmd->result = (DID_NO_CONNECT << 16);
 			cmd->scsi_done(cmd);
+			spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 			return 0;
 		}
 		cmd->device->hostdata = pDev;
@@ -486,8 +493,10 @@ static int adpt_queue(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
 	 * delay processing of the command until later.
 	 */
 	if (pDev->state & DPTI_DEV_RESET ) {
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return FAILED;
 	}
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return adpt_scsi_to_i2o(pHba, cmd, pDev);
 }
 
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index d1c3137..6761716 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1765,7 +1765,10 @@ static int eata2x_queuecommand(struct scsi_cmnd *SCpnt,
 	struct hostdata *ha = (struct hostdata *)shost->hostdata;
 	unsigned int i, k;
 	struct mscp *cpp;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
 	if (SCpnt->host_scribble)
 		panic("%s: qcomm, pid %ld, SCpnt %p already active.\n",
 		      ha->board_name, SCpnt->serial_number, SCpnt);
@@ -1785,6 +1788,7 @@ static int eata2x_queuecommand(struct scsi_cmnd *SCpnt,
 
 	if (k == shost->can_queue) {
 		printk("%s: qcomm, no free mailbox.\n", ha->board_name);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 		return 1;
 	}
 
@@ -1827,6 +1831,7 @@ static int eata2x_queuecommand(struct scsi_cmnd *SCpnt,
 	    && TLDEV(SCpnt->device->type)) {
 		ha->cp_stat[i] = READY;
 		flush_dev(SCpnt->device, blk_rq_pos(SCpnt->request), ha, 0);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -1836,10 +1841,12 @@ static int eata2x_queuecommand(struct scsi_cmnd *SCpnt,
 		SCpnt->host_scribble = NULL;
 		scmd_printk(KERN_INFO, SCpnt,
 			"qcomm, pid %ld, adapter busy.\n", SCpnt->serial_number);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 		return 1;
 	}
 
 	ha->cp_stat[i] = IN_USE;
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index 60886c1..72de26e 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -344,7 +344,10 @@ static int eata_pio_queue(struct scsi_cmnd *cmd,
 	hostdata *hd;
 	struct Scsi_Host *sh;
 	struct eata_ccb *cp;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	queue_counter++;
 
 	hd = HD(cmd);
@@ -421,6 +424,7 @@ static int eata_pio_queue(struct scsi_cmnd *cmd,
 			"returning DID_BUS_BUSY, done.\n", cmd->serial_number);
 		done(cmd);
 		cp->status = FREE;
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return 0;
 	}
 	/* FIXME: timeout */
@@ -435,6 +439,7 @@ static int eata_pio_queue(struct scsi_cmnd *cmd,
 		"Queued base %#.4lx pid: %ld "
 		"slot %d irq %d\n", sh->base, cmd->serial_number, y, sh->irq));
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index e2bc779..c70efde 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -922,10 +922,15 @@ static int esp_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd
 	struct esp *esp = shost_priv(dev->host);
 	struct esp_cmd_priv *spriv;
 	struct esp_cmd_entry *ent;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	ent = esp_get_ent(esp);
-	if (!ent)
+	if (!ent) {
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	ent->cmd = cmd;
 
@@ -938,6 +943,7 @@ static int esp_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd
 
 	esp_maybe_execute_command(esp);
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/fd_mcs.c b/drivers/scsi/fd_mcs.c
index 2ad95aa..dc61481 100644
--- a/drivers/scsi/fd_mcs.c
+++ b/drivers/scsi/fd_mcs.c
@@ -1075,7 +1075,10 @@ static int fd_mcs_release(struct Scsi_Host *shpnt)
 static int fd_mcs_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
 	if (in_command) {
 		panic("fd_mcs: fd_mcs_queue() NOT REENTRANT!\n");
 	}
@@ -1119,6 +1122,7 @@ static int fd_mcs_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 	outb(0x20, Interrupt_Cntl_port);
 	outb(0x14 | PARITY_MASK, TMC_Cntl_port);	/* Start arbitration */
 
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index e296bcc..153bb64 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -1422,6 +1422,9 @@ static irqreturn_t do_fdomain_16x0_intr(int irq, void *dev_id)
 static int fdomain_16x0_queue(struct scsi_cmnd *SCpnt,
 		void (*done)(struct scsi_cmnd *))
 {
+   unsigned long irqflags;
+   spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+   scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
    if (in_command) {
       panic( "scsi: <fdomain> fdomain_16x0_queue() NOT REENTRANT!\n" );
    }
@@ -1466,6 +1469,7 @@ static int fdomain_16x0_queue(struct scsi_cmnd *SCpnt,
    outb(0x20, port_base + Interrupt_Cntl);
    outb(0x14 | PARITY_MASK, port_base + TMC_Cntl); /* Start arbitration */
 
+   spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
    return 0;
 }
 
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 198cbab..2e4f40b 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -360,18 +360,24 @@ int fnic_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 	int sg_count;
 	unsigned long flags;
 	unsigned long ptr;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(sc->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(sc->device->host, sc);
 	rport = starget_to_rport(scsi_target(sc->device));
 	ret = fc_remote_port_chkready(rport);
 	if (ret) {
 		sc->result = ret;
 		done(sc);
+		spin_unlock_irqrestore(sc->device->host->host_lock, irqflags);
 		return 0;
 	}
 
 	lp = shost_priv(sc->device->host);
-	if (lp->state != LPORT_ST_READY || !(lp->link_up))
+	if (lp->state != LPORT_ST_READY || !(lp->link_up)) {
+		spin_unlock_irqrestore(sc->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	/*
 	 * Release host lock, use driver resource specific locks from here.
@@ -454,6 +460,7 @@ int fnic_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 out:
 	/* acquire host lock before returning to SCSI */
 	spin_lock(lp->host->host_lock);
+	spin_unlock_irqrestore(sc->device->host->host_lock, irqflags);
 	return ret;
 }
 
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 5a3f931..e4a3ecb 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4009,7 +4009,10 @@ static int gdth_queuecommand(struct scsi_cmnd *scp,
 {
     gdth_ha_str *ha = shost_priv(scp->device->host);
     struct gdth_cmndinfo *cmndinfo;
+    unsigned long irqflags;
 
+    spin_lock_irqsave(scp->device->host->host_lock, irqflags);
+    scsi_cmd_get_serial(scp->device->host, scp);
     TRACE(("gdth_queuecommand() cmd 0x%x\n", scp->cmnd[0]));
 
     cmndinfo = gdth_get_cmndinfo(ha);
@@ -4019,6 +4022,7 @@ static int gdth_queuecommand(struct scsi_cmnd *scp,
     cmndinfo->timeout_count = 0;
     cmndinfo->priority = DEFAULT_PRI;
 
+    spin_unlock_irqrestore(scp->device->host->host_lock, irqflags);
     return __gdth_queuecommand(ha, scp, cmndinfo);
 }
 
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c5d0606..8d0f51d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1934,13 +1934,17 @@ static int hpsa_scsi_queue_command(struct scsi_cmnd *cmd,
 	unsigned char scsi3addr[8];
 	struct CommandList *c;
 	unsigned long flags;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	/* Get the ptr to our adapter structure out of cmd->host. */
 	h = sdev_to_hba(cmd->device);
 	dev = cmd->device->hostdata;
 	if (!dev) {
 		cmd->result = DID_NO_CONNECT << 16;
 		done(cmd);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return 0;
 	}
 	memcpy(scsi3addr, dev->scsi3addr, sizeof(scsi3addr));
@@ -1951,6 +1955,7 @@ static int hpsa_scsi_queue_command(struct scsi_cmnd *cmd,
 	spin_unlock_irqrestore(&h->lock, flags);
 	if (c == NULL) {			/* trouble... */
 		dev_err(&h->pdev->dev, "cmd_alloc returned NULL!\n");
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -2013,10 +2018,12 @@ static int hpsa_scsi_queue_command(struct scsi_cmnd *cmd,
 
 	if (hpsa_scatter_gather(h, c, cmd) < 0) { /* Fill SG list */
 		cmd_free(h, c);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 	enqueue_cmd_and_start_io(h, c);
 	/* the cmd'll come back via intr handler in complete_scsi_command()  */
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 0729f15..04903e4 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -759,13 +759,17 @@ static int hptiop_queuecommand(struct scsi_cmnd *scp,
 	struct hpt_iop_request_scsi_command *req;
 	int sg_count = 0;
 	struct hptiop_request *_req;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(scp->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(scp->device->host, scp);
 	BUG_ON(!done);
 	scp->scsi_done = done;
 
 	_req = get_req(hba);
 	if (_req == NULL) {
 		dprintk("hptiop_queuecmd : no free req\n");
+		spin_unlock_irqrestore(scp->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -811,11 +815,13 @@ static int hptiop_queuecommand(struct scsi_cmnd *scp,
 
 	memcpy(req->cdb, scp->cmnd, sizeof(req->cdb));
 	hba->ops->post_req(hba, _req);
+	spin_unlock_irqrestore(scp->device->host->host_lock, irqflags);
 	return 0;
 
 cmd_done:
 	dprintk("scsi_done(scp=%p)\n", scp);
 	scp->scsi_done(scp);
+	spin_unlock_irqrestore(scp->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 9a4b69d..65595e2 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -1703,6 +1703,10 @@ static int ibmmca_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 	int max_pun;
 	int i;
 	struct scatterlist *sg;
+	unsigned long irqflags;
+
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 
 	shpnt = cmd->device->host;
 
@@ -1721,6 +1725,8 @@ static int ibmmca_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 		cmd->result = DID_NO_CONNECT << 16;
 		if (done)
 			done(cmd);
+
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -1743,6 +1749,8 @@ static int ibmmca_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 					cmd->result = DID_NO_CONNECT << 16;	/* return no connect */
 					if (done)
 						done(cmd);
+
+					spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 					return 0;
 				}
 			}
@@ -1804,6 +1812,8 @@ static int ibmmca_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 			cmd->result = DID_BAD_TARGET << 16;
 			if (done)
 				done(cmd);
+
+			spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 			return 0;
 		}
 	}
@@ -1993,6 +2003,8 @@ static int ibmmca_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 		issue_cmd(shpnt, isa_virt_to_bus(scb), IM_SCB | ldn);
 		IBM_DS(shpnt).scbs++;
 	}
+
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 00d08b2..fb1e719 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1615,11 +1615,15 @@ static int ibmvfc_queuecommand(struct scsi_cmnd *cmnd,
 	struct ibmvfc_event *evt;
 	u8 tag[2];
 	int rc;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmnd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmnd->device->host, cmnd);
 	if (unlikely((rc = fc_remote_port_chkready(rport))) ||
 	    unlikely((rc = ibmvfc_host_chkready(vhost)))) {
 		cmnd->result = rc;
 		done(cmnd);
+		spin_unlock_irqrestore(cmnd->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -1656,12 +1660,16 @@ static int ibmvfc_queuecommand(struct scsi_cmnd *cmnd,
 		};
 	}
 
-	if (likely(!(rc = ibmvfc_map_sg_data(cmnd, evt, vfc_cmd, vhost->dev))))
+	if (likely(!(rc = ibmvfc_map_sg_data(cmnd, evt, vfc_cmd, vhost->dev)))) {
+		spin_unlock_irqrestore(cmnd->device->host->host_lock, irqflags);
 		return ibmvfc_send_event(evt, vhost, 0);
+	}
 
 	ibmvfc_free_event(evt);
-	if (rc == -ENOMEM)
+	if (rc == -ENOMEM) {
+		spin_unlock_irqrestore(cmnd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	if (vhost->log_level > IBMVFC_DEFAULT_LOG_LEVEL)
 		scmd_printk(KERN_ERR, cmnd,
@@ -1669,6 +1677,7 @@ static int ibmvfc_queuecommand(struct scsi_cmnd *cmnd,
 
 	cmnd->result = DID_ERROR << 16;
 	done(cmnd);
+	spin_unlock_irqrestore(cmnd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 67f78a4..81be256 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -722,11 +722,16 @@ static int ibmvscsi_queuecommand(struct scsi_cmnd *cmnd,
 	struct ibmvscsi_host_data *hostdata = shost_priv(cmnd->device->host);
 	u16 lun = lun_from_dev(cmnd->device);
 	u8 out_fmt, in_fmt;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmnd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmnd->device->host, cmnd);
 	cmnd->result = (DID_OK << 16);
 	evt_struct = get_event_struct(&hostdata->pool);
-	if (!evt_struct)
+	if (!evt_struct) {
+		spin_unlock_irqrestore(cmnd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	/* Set up the actual SRP IU */
 	srp_cmd = &evt_struct->iu.srp.cmd;
@@ -740,6 +745,7 @@ static int ibmvscsi_queuecommand(struct scsi_cmnd *cmnd,
 			sdev_printk(KERN_ERR, cmnd->device,
 			            "couldn't convert cmd to srp_cmd\n");
 		free_event_struct(&hostdata->pool, evt_struct);
+		spin_unlock_irqrestore(cmnd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -763,6 +769,7 @@ static int ibmvscsi_queuecommand(struct scsi_cmnd *cmnd,
 			offsetof(struct srp_indirect_buf, desc_list);
 	}
 
+	spin_unlock_irqrestore(cmnd->device->host->host_lock, irqflags);
 	return ibmvscsi_send_srp_event(evt_struct, hostdata, 0);
 }
 
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 4734ab0..be88999 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -930,9 +930,13 @@ static int imm_queuecommand(struct scsi_cmnd *cmd,
 		void (*done)(struct scsi_cmnd *))
 {
 	imm_struct *dev = imm_dev(cmd->device->host);
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	if (dev->cur_cmd) {
 		printk("IMM: bug in imm_queuecommand\n");
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return 0;
 	}
 	dev->failed = 0;
@@ -946,6 +950,7 @@ static int imm_queuecommand(struct scsi_cmnd *cmd,
 
 	imm_pb_claim(dev);
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index 52bdc6d..2339bb3 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -339,7 +339,10 @@ static int in2000_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 	struct Scsi_Host *instance;
 	struct IN2000_hostdata *hostdata;
 	Scsi_Cmnd *tmp;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	instance = cmd->device->host;
 	hostdata = (struct IN2000_hostdata *) instance->hostdata;
 
@@ -428,6 +431,7 @@ static int in2000_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 	in2000_execute(cmd->device->host);
 
 	DB(DB_QUEUE_COMMAND, printk(")Q-%ld ", cmd->serial_number))
+	    spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	    return 0;
 }
 
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 1087977..0ef119e 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2644,15 +2644,21 @@ static int i91u_queuecommand(struct scsi_cmnd *cmd,
 {
 	struct initio_host *host = (struct initio_host *) cmd->device->host->hostdata;
 	struct scsi_ctrl_blk *cmnd;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	cmd->scsi_done = done;
 
 	cmnd = initio_alloc_scb(host);
-	if (!cmnd)
+	if (!cmnd) {
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	initio_build_scb(host, cmnd, cmd);
 	initio_exec_scb(host, cmnd);
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index df9a12c..d0ca800 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5717,7 +5717,10 @@ static int ipr_queuecommand(struct scsi_cmnd *scsi_cmd,
 	struct ipr_ioarcb *ioarcb;
 	struct ipr_cmnd *ipr_cmd;
 	int rc = 0;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(&scsi_cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(scsi_cmd->device->host, scsi_cmd);
 	scsi_cmd->scsi_done = done;
 	ioa_cfg = (struct ipr_ioa_cfg *)scsi_cmd->device->host->hostdata;
 	res = scsi_cmd->device->hostdata;
@@ -5728,8 +5731,10 @@ static int ipr_queuecommand(struct scsi_cmnd *scsi_cmd,
 	 * We have told the host to stop giving us new requests, but
 	 * ERP ops don't count. FIXME
 	 */
-	if (unlikely(!ioa_cfg->allow_cmds && !ioa_cfg->ioa_is_dead))
+	if (unlikely(!ioa_cfg->allow_cmds && !ioa_cfg->ioa_is_dead)) {
+		spin_unlock_irqrestore(&scsi_cmd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	/*
 	 * FIXME - Create scsi_set_host_offline interface
@@ -5739,11 +5744,15 @@ static int ipr_queuecommand(struct scsi_cmnd *scsi_cmd,
 		memset(scsi_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 		scsi_cmd->result = (DID_NO_CONNECT << 16);
 		scsi_cmd->scsi_done(scsi_cmd);
+		spin_unlock_irqrestore(&scsi_cmd->device->host->host_lock, irqflags);
 		return 0;
 	}
 
-	if (ipr_is_gata(res) && res->sata_port)
-		return ata_sas_queuecmd(scsi_cmd, done, res->sata_port->ap);
+	if (ipr_is_gata(res) && res->sata_port) {
+		rc = ata_sas_queuecmd(scsi_cmd, done, res->sata_port->ap);
+		spin_unlock_irqrestore(&scsi_cmd->device->host->host_lock, irqflags);
+		return rc;
+	}
 
 	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
 	ioarcb = &ipr_cmd->ioarcb;
@@ -5786,9 +5795,11 @@ static int ipr_queuecommand(struct scsi_cmnd *scsi_cmd,
 		ipr_send_command(ipr_cmd);
 	} else {
 		 list_move_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
+		 spin_unlock_irqrestore(&scsi_cmd->device->host->host_lock, irqflags);
 		 return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
+	spin_unlock_irqrestore(&scsi_cmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index f83a116..cd83a25 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -1050,28 +1050,37 @@ static int ips_queue(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *))
 {
 	ips_ha_t *ha;
 	ips_passthru_t *pt;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(SC->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(SC->device->host, SC);
 	METHOD_TRACE("ips_queue", 1);
 
 	ha = (ips_ha_t *) SC->device->host->hostdata;
 
-	if (!ha)
+	if (!ha) {
+		spin_unlock_irqrestore(SC->device->host->host_lock, irqflags);
 		return (1);
+	}
 
-	if (!ha->active)
+	if (!ha->active) {
+		spin_unlock_irqrestore(SC->device->host->host_lock, irqflags);
 		return (DID_ERROR);
+	}
 
 	if (ips_is_passthru(SC)) {
 		if (ha->copp_waitlist.count == IPS_MAX_IOCTL_QUEUE) {
 			SC->result = DID_BUS_BUSY << 16;
 			done(SC);
 
+			spin_unlock_irqrestore(SC->device->host->host_lock, irqflags);
 			return (0);
 		}
 	} else if (ha->scb_waitlist.count == IPS_MAX_QUEUE) {
 		SC->result = DID_BUS_BUSY << 16;
 		done(SC);
 
+		spin_unlock_irqrestore(SC->device->host->host_lock, irqflags);
 		return (0);
 	}
 
@@ -1089,6 +1098,7 @@ static int ips_queue(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *))
 		SC->result = DID_NO_CONNECT << 16;
 		done(SC);
 
+		spin_unlock_irqrestore(SC->device->host->host_lock, irqflags);
 		return (0);
 	}
 
@@ -1105,12 +1115,14 @@ static int ips_queue(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *))
 			if (ha->scb_activelist.count != 0) {
 				SC->result = DID_BUS_BUSY << 16;
 				done(SC);
+				spin_unlock_irqrestore(SC->device->host->host_lock, irqflags);
 				return (0);
 			}
 			ha->ioctl_reset = 1;	/* This reset request is from an IOCTL */
 			__ips_eh_reset(SC);
 			SC->result = DID_OK << 16;
 			SC->scsi_done(SC);
+			spin_unlock_irqrestore(SC->device->host->host_lock, irqflags);
 			return (0);
 		}
 
@@ -1121,6 +1133,7 @@ static int ips_queue(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *))
 			SC->result = DID_ERROR << 16;
 			done(SC);
 
+			spin_unlock_irqrestore(SC->device->host->host_lock, irqflags);
 			return (0);
 		}
 
@@ -1134,6 +1147,7 @@ static int ips_queue(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *))
 
 	ips_next(ha, IPS_INTR_IORL);
 
+	spin_unlock_irqrestore(SC->device->host->host_lock, irqflags);
 	return (0);
 }
 
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index c797f6b..5a91e1d 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1763,13 +1763,17 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 	int rval;
 	int rc = 0;
 	struct fcoe_dev_stats *stats;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(sc_cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(sc_cmd->device->host, sc_cmd);
 	lport = shost_priv(sc_cmd->device->host);
 
 	rval = fc_remote_port_chkready(rport);
 	if (rval) {
 		sc_cmd->result = rval;
 		done(sc_cmd);
+		spin_unlock_irqrestore(sc_cmd->device->host->host_lock, irqflags);
 		return 0;
 	}
 	spin_unlock_irq(lport->host->host_lock);
@@ -1850,6 +1854,7 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 	}
 out:
 	spin_lock_irq(lport->host->host_lock);
+	spin_unlock_irqrestore(sc_cmd->device->host->host_lock, irqflags);
 	return rc;
 }
 EXPORT_SYMBOL(fc_queuecommand);
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 633e090..444488d 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1608,6 +1608,10 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 	struct iscsi_session *session;
 	struct iscsi_conn *conn;
 	struct iscsi_task *task = NULL;
+	unsigned long irqflags;
+
+	spin_lock_irqsave(sc->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(sc->device->host, sc);
 
 	sc->scsi_done = done;
 	sc->result = 0;
@@ -1707,6 +1711,7 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 	session->queued_cmdsn++;
 	spin_unlock(&session->lock);
 	spin_lock(host->host_lock);
+	spin_unlock_irqrestore(sc->device->host->host_lock, irqflags);
 	return 0;
 
 prepd_reject:
@@ -1717,6 +1722,7 @@ reject:
 	ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
 			  sc->cmnd[0], reason);
 	spin_lock(host->host_lock);
+	spin_unlock_irqrestore(sc->device->host->host_lock, irqflags);
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
 prepd_fault:
@@ -1734,6 +1740,7 @@ fault:
 	}
 	done(sc);
 	spin_lock(host->host_lock);
+	spin_unlock_irqrestore(sc->device->host->host_lock, irqflags);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_queuecommand);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 55f09e9..28375e2 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -200,7 +200,10 @@ int sas_queuecommand(struct scsi_cmnd *cmd,
 	struct domain_device *dev = cmd_to_domain_dev(cmd);
 	struct Scsi_Host *host = cmd->device->host;
 	struct sas_internal *i = to_sas_internal(host->transportt);
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	spin_unlock_irq(host->host_lock);
 
 	{
@@ -251,6 +254,7 @@ int sas_queuecommand(struct scsi_cmnd *cmd,
 	}
 out:
 	spin_lock_irq(host->host_lock);
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return res;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 3a65895..3828e00 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -2906,6 +2906,10 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	int err;
 
+	unsigned long irqflags;
+
+	spin_lock_irqsave(cmnd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmnd->device->host, cmnd);
 	err = fc_remote_port_chkready(rport);
 	if (err) {
 		cmnd->result = err;
@@ -3043,16 +3047,19 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 			lpfc_poll_rearm_timer(phba);
 	}
 
+	spin_unlock_irqrestore(cmnd->device->host->host_lock, irqflags);
 	return 0;
 
  out_host_busy_free_buf:
 	lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
 	lpfc_release_scsi_buf(phba, lpfc_cmd);
  out_host_busy:
+	spin_unlock_irqrestore(cmnd->device->host->host_lock, irqflags);
 	return SCSI_MLQUEUE_HOST_BUSY;
 
  out_fail_command:
 	done(cmnd);
+	spin_unlock_irqrestore(cmnd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index 3ddb4dc..37b01bd 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -82,6 +82,9 @@ static int mac53c94_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *
 	}
 #endif
 
+	unsigned long irqflags;
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	cmd->scsi_done = done;
 	cmd->host_scribble = NULL;
 
@@ -96,6 +99,7 @@ static int mac53c94_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *
 	if (state->phase == idle)
 		mac53c94_start(state);
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 7ceb5cf..070fdd0 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -372,7 +372,10 @@ megaraid_queue(Scsi_Cmnd *scmd, void (*done)(Scsi_Cmnd *))
 	scb_t	*scb;
 	int	busy=0;
 	unsigned long flags;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(scmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(scmd->device->host, scmd);
 	adapter = (adapter_t *)scmd->device->host->hostdata;
 
 	scmd->scsi_done = done;
@@ -406,6 +409,7 @@ megaraid_queue(Scsi_Cmnd *scmd, void (*done)(Scsi_Cmnd *))
 	busy = 0;
  out:
 	spin_unlock_irqrestore(&adapter->lock, flags);
+	spin_unlock_irqrestore(scmd->device->host->host_lock, irqflags);
 	return busy;
 }
 
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index a7810a1..07ade30 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1489,7 +1489,10 @@ megaraid_queue_command(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
 	adapter_t	*adapter;
 	scb_t		*scb;
 	int		if_busy;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(scp->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(scp->device->host, scp);
 	adapter		= SCP2ADAPTER(scp);
 	scp->scsi_done	= done;
 	scp->result	= 0;
@@ -1506,10 +1509,12 @@ megaraid_queue_command(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
 	scb = megaraid_mbox_build_cmd(adapter, scp, &if_busy);
 	if (!scb) {	// command already completed
 		done(scp);
+		spin_unlock_irqrestore(scp->device->host->host_lock, irqflags);
 		return 0;
 	}
 
 	megaraid_mbox_runpendq(adapter, scb);
+	spin_unlock_irqrestore(scp->device->host->host_lock, irqflags);
 	return if_busy;
 }
 
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index d3c9cde..cb0b400 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -1325,16 +1325,22 @@ megasas_queue_command(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd *))
 	struct megasas_cmd *cmd;
 	struct megasas_instance *instance;
 	unsigned long flags;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(scmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(scmd->device->host, scmd);
 	instance = (struct megasas_instance *)
 	    scmd->device->host->hostdata;
 
-	if (instance->issuepend_done == 0)
+	if (instance->issuepend_done == 0) {
+		spin_unlock_irqrestore(scmd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	spin_lock_irqsave(&instance->hba_lock, flags);
 	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
+		spin_unlock_irqrestore(scmd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -1362,8 +1368,10 @@ megasas_queue_command(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd *))
 	}
 
 	cmd = megasas_get_cmd(instance);
-	if (!cmd)
+	if (!cmd) {
+		spin_unlock_irqrestore(scmd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	/*
 	 * Logical drive command
@@ -1393,12 +1401,14 @@ megasas_queue_command(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd *))
 		tasklet_schedule(&instance->isr_tasklet);
 
 
+	spin_unlock_irqrestore(scmd->device->host->host_lock, irqflags);
 	return 0;
 
  out_return_cmd:
 	megasas_return_cmd(instance, cmd);
  out_done:
 	done(scmd);
+	spin_unlock_irqrestore(scmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 1f784fd..93e6596 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -1630,7 +1630,10 @@ static void cmd_complete(struct mesh_state *ms)
 static int mesh_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
 	struct mesh_state *ms;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	cmd->scsi_done = done;
 	cmd->host_scribble = NULL;
 
@@ -1645,6 +1648,7 @@ static int mesh_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	if (ms->phase == idle)
 		mesh_start(ms);
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 16e99b6..e849aa2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3323,18 +3323,23 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	Mpi2SCSIIORequest_t *mpi_request;
 	u32 mpi_control;
 	u16 smid;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(scmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(scmd->device->host, scmd);
 	scmd->scsi_done = done;
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
 		scmd->result = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
+		spin_unlock_irqrestore(scmd->device->host->host_lock, irqflags);
 		return 0;
 	}
 
 	if (ioc->pci_error_recovery) {
 		scmd->result = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
+		spin_unlock_irqrestore(scmd->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -3343,19 +3348,25 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	if (sas_target_priv_data->handle == MPT2SAS_INVALID_DEVICE_HANDLE) {
 		scmd->result = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
+		spin_unlock_irqrestore(scmd->device->host->host_lock, irqflags);
 		return 0;
 	}
 
 	/* host recovery or link resets sent via IOCTLs */
-	if (ioc->shost_recovery || ioc->ioc_link_reset_in_progress)
+	if (ioc->shost_recovery || ioc->ioc_link_reset_in_progress) {
+		spin_unlock_irqrestore(scmd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 	/* device busy with task management */
-	else if (sas_device_priv_data->block || sas_target_priv_data->tm_busy)
+	else if (sas_device_priv_data->block || sas_target_priv_data->tm_busy) {
+		spin_unlock_irqrestore(scmd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_DEVICE_BUSY;
+	}
 	/* device has been deleted */
 	else if (sas_target_priv_data->deleted) {
 		scmd->result = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
+		spin_unlock_irqrestore(scmd->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -3435,9 +3446,11 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 		    sas_device_priv_data->sas_target->handle);
 	else
 		mpt2sas_base_put_smid_default(ioc, smid);
+	spin_unlock_irqrestore(scmd->device->host->host_lock, irqflags);
 	return 0;
 
  out:
+	spin_unlock_irqrestore(scmd->device->host->host_lock, irqflags);
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index d013a2a..00a8b1e 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -8034,7 +8034,10 @@ static int ncr53c8xx_queue_command (struct scsi_cmnd *cmd, void (* done)(struct
      struct ncb *np = ((struct host_data *) cmd->device->host->hostdata)->ncb;
      unsigned long flags;
      int sts;
+     unsigned long irqflags;
 
+     spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+     scsi_cmd_get_serial(cmd->device->host, cmd);
 #ifdef DEBUG_NCR53C8XX
 printk("ncr53c8xx_queue_command\n");
 #endif
@@ -8065,6 +8068,7 @@ printk("ncr53c8xx : command successfully queued\n");
 	  sts = 0;
      }
 
+     spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
      return sts;
 }
 
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 4c1e545..42864e2 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -915,7 +915,10 @@ static int nsp32_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 	nsp32_target *target;
 	nsp32_lunt   *cur_lunt;
 	int ret;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
 	nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND,
 		  "enter. target: 0x%x LUN: 0x%x cmnd: 0x%x cmndlen: 0x%x "
 		  "use_sg: 0x%x reqbuf: 0x%lx reqlen: 0x%x",
@@ -927,6 +930,7 @@ static int nsp32_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 		data->CurrentSC = NULL;
 		SCpnt->result   = DID_NO_CONNECT << 16;
 		done(SCpnt);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -935,6 +939,7 @@ static int nsp32_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "terget==host???");
 		SCpnt->result = DID_BAD_TARGET << 16;
 		done(SCpnt);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -943,6 +948,7 @@ static int nsp32_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "no more lun");
 		SCpnt->result = DID_BAD_TARGET << 16;
 		done(SCpnt);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -975,6 +981,7 @@ static int nsp32_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 		nsp32_msg(KERN_ERR, "SGT fail");
 		SCpnt->result = DID_ERROR << 16;
 		nsp32_scsi_done(SCpnt);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -1047,6 +1054,7 @@ static int nsp32_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 		nsp32_scsi_done(SCpnt);
 	}
 
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 9326c2c..6c4277d 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -193,7 +193,10 @@ static int nsp_queuecommand(struct scsi_cmnd *SCpnt,
 	unsigned char target = scmd_id(SCpnt);
 #endif
 	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
 	nsp_dbg(NSP_DEBUG_QUEUECOMMAND,
 		"SCpnt=0x%p target=%d lun=%d sglist=0x%p bufflen=%d sg_count=%d",
 		SCpnt, target, SCpnt->device->lun, scsi_sglist(SCpnt),
@@ -206,6 +209,7 @@ static int nsp_queuecommand(struct scsi_cmnd *SCpnt,
 		nsp_msg(KERN_DEBUG, "CurrentSC!=NULL this can't be happen");
 		SCpnt->result   = DID_BAD_TARGET << 16;
 		nsp_scsi_done(SCpnt);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -253,6 +257,7 @@ static int nsp_queuecommand(struct scsi_cmnd *SCpnt,
 		nsp_dbg(NSP_DEBUG_QUEUECOMMAND, "selection fail");
 		SCpnt->result   = DID_BUS_BUSY << 16;
 		nsp_scsi_done(SCpnt);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -261,6 +266,7 @@ static int nsp_queuecommand(struct scsi_cmnd *SCpnt,
 #ifdef NSP_DEBUG
 	data->CmdId++;
 #endif
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 0ae27cb..5f926bb 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -553,7 +553,10 @@ SYM53C500_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	int port_base = SCpnt->device->host->io_port;
 	struct sym53c500_data *data =
 	    (struct sym53c500_data *)SCpnt->device->host->hostdata;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
 	VDEB(printk("SYM53C500_queue called\n"));
 
 	DEB(printk("cmd=%02x, cmd_len=%02x, target=%02x, lun=%02x, bufflen=%d\n", 
@@ -580,6 +583,7 @@ SYM53C500_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	}
 	outb(SELECT_NO_ATN, port_base + CMD_REG);
 
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 4b87657..607a3cf 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3482,7 +3482,10 @@ static int pmcraid_queuecommand(
 	struct pmcraid_cmd *cmd;
 	u32 fw_version;
 	int rc = 0;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(scsi_cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(scsi_cmd->device->host, scsi_cmd);
 	pinstance =
 		(struct pmcraid_instance *)scsi_cmd->device->host->hostdata;
 	fw_version = be16_to_cpu(pinstance->inq_data->fw_version);
@@ -3497,12 +3500,15 @@ static int pmcraid_queuecommand(
 		pmcraid_info("IOA is dead, but queuecommand is scheduled\n");
 		scsi_cmd->result = (DID_NO_CONNECT << 16);
 		scsi_cmd->scsi_done(scsi_cmd);
+		spin_unlock_irqrestore(scsi_cmd->device->host->host_lock, irqflags);
 		return 0;
 	}
 
 	/* If IOA reset is in progress, can't queue the commands */
-	if (pinstance->ioa_reset_in_progress)
+	if (pinstance->ioa_reset_in_progress) {
+		spin_unlock_irqrestore(scsi_cmd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	/* Firmware doesn't support SYNCHRONIZE_CACHE command (0x35), complete
 	 * the command here itself with success return
@@ -3510,6 +3516,7 @@ static int pmcraid_queuecommand(
 	if (scsi_cmd->cmnd[0] == SYNCHRONIZE_CACHE) {
 		pmcraid_info("SYNC_CACHE(0x35), completing in driver itself\n");
 		scsi_cmd->scsi_done(scsi_cmd);
+		spin_unlock_irqrestore(scsi_cmd->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -3518,6 +3525,7 @@ static int pmcraid_queuecommand(
 
 	if (cmd == NULL) {
 		pmcraid_err("free command block is not available\n");
+		spin_unlock_irqrestore(scsi_cmd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -3574,6 +3582,7 @@ static int pmcraid_queuecommand(
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 	}
 
+	spin_unlock_irqrestore(scsi_cmd->device->host->host_lock, irqflags);
 	return rc;
 }
 
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index 7bc2d79..8f03631 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -802,9 +802,13 @@ static int ppa_queuecommand(struct scsi_cmnd *cmd,
 		void (*done) (struct scsi_cmnd *))
 {
 	ppa_struct *dev = ppa_dev(cmd->device->host);
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	if (dev->cur_cmd) {
 		printk(KERN_ERR "PPA: bug in ppa_queuecommand\n");
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return 0;
 	}
 	dev->failed = 0;
@@ -818,6 +822,7 @@ static int ppa_queuecommand(struct scsi_cmnd *cmd,
 
 	ppa_pb_claim(dev);
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index 92ffbb5..9cb6ad3 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -218,7 +218,10 @@ static int ps3rom_queuecommand(struct scsi_cmnd *cmd,
 	struct ps3_storage_device *dev = priv->dev;
 	unsigned char opcode;
 	int res;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 #ifdef DEBUG
 	scsi_print_command(cmd);
 #endif
@@ -257,6 +260,7 @@ static int ps3rom_queuecommand(struct scsi_cmnd *cmd,
 		cmd->scsi_done(cmd);
 	}
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index b8166ec..ca34ed1 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -733,7 +733,10 @@ qla1280_queuecommand(struct scsi_cmnd *cmd, void (*fn)(struct scsi_cmnd *))
 	struct scsi_qla_host *ha = (struct scsi_qla_host *)host->hostdata;
 	struct srb *sp = (struct srb *)CMD_SP(cmd);
 	int status;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	cmd->scsi_done = fn;
 	sp->cmd = cmd;
 	sp->flags = 0;
@@ -753,6 +756,7 @@ qla1280_queuecommand(struct scsi_cmnd *cmd, void (*fn)(struct scsi_cmnd *))
 #else
 	status = qla1280_32bit_start_scsi(ha, sp);
 #endif
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return status;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 800ea92..2c2224e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -538,7 +538,10 @@ qla2xxx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 	srb_t *sp;
 	int rval;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	if (ha->flags.eeh_busy) {
 		if (ha->flags.pci_channel_io_perm_failure)
 			cmd->result = DID_NO_CONNECT << 16;
@@ -586,6 +589,7 @@ qla2xxx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 
 	spin_lock_irq(vha->host->host_lock);
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 
 qc24_host_busy_free_sp:
@@ -594,14 +598,17 @@ qc24_host_busy_free_sp:
 
 qc24_host_busy_lock:
 	spin_lock_irq(vha->host->host_lock);
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return SCSI_MLQUEUE_HOST_BUSY;
 
 qc24_target_busy:
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
 qc24_fail_command:
 	done(cmd);
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 370d40f..568e61f 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -474,7 +474,10 @@ static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
 	struct iscsi_cls_session *sess = ddb_entry->sess;
 	struct srb *srb;
 	int rval;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	if (test_bit(AF_EEH_BUSY, &ha->flags)) {
 		if (test_bit(AF_PCI_CHANNEL_IO_PERM_FAILURE, &ha->flags))
 			cmd->result = DID_NO_CONNECT << 16;
@@ -499,6 +502,7 @@ static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
 			cmd->result = DID_NO_CONNECT << 16;
 			goto qc_fail_command;
 		}
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_TARGET_BUSY;
 	}
 
@@ -522,6 +526,7 @@ static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
 		goto qc_host_busy_free_sp;
 
 	spin_lock_irq(ha->host->host_lock);
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 
 qc_host_busy_free_sp:
@@ -532,11 +537,13 @@ qc_host_busy_lock:
 	spin_lock_irq(ha->host->host_lock);
 
 qc_host_busy:
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return SCSI_MLQUEUE_HOST_BUSY;
 
 qc_fail_command:
 	done(cmd);
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index 1ad5155..4146a5f 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -443,6 +443,9 @@ int qlogicfas408_queuecommand(struct scsi_cmnd *cmd,
 			      void (*done) (struct scsi_cmnd *))
 {
 	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
+	unsigned long irqflags;
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	if (scmd_id(cmd) == priv->qinitid) {
 		cmd->result = DID_BAD_TARGET << 16;
 		done(cmd);
@@ -456,6 +459,7 @@ int qlogicfas408_queuecommand(struct scsi_cmnd *cmd,
 		cpu_relax();
 	}
 	ql_icmd(cmd);
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index f8c561c..e1491e5 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1010,7 +1010,10 @@ static int qlogicpti_queuecommand(struct scsi_cmnd *Cmnd, void (*done)(struct sc
 	struct Command_Entry *cmd;
 	u_int out_ptr;
 	int in_ptr;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(Cmnd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(Cmnd->device->host, Cmnd);
 	Cmnd->scsi_done = done;
 
 	in_ptr = qpti->req_in_ptr;
@@ -1037,6 +1040,7 @@ static int qlogicpti_queuecommand(struct scsi_cmnd *Cmnd, void (*done)(struct sc
 
 	update_can_queue(host, in_ptr, out_ptr);
 
+	spin_unlock_irqrestore(Cmnd->device->host->host_lock, irqflags);
 	return 0;
 
 toss_command:
@@ -1049,6 +1053,7 @@ toss_command:
 	 */
 	Cmnd->result = DID_BUS_BUSY;
 	done(Cmnd);
+	spin_unlock_irqrestore(Cmnd->device->host->host_lock, irqflags);
 	return 1;
 }
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 348fba0..d6d3c50 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -634,13 +634,15 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
  * Description: a serial number identifies a request for error recovery
  * and debugging purposes.  Protected by the Host_Lock of host.
  */
-static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
+void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 {
 	cmd->serial_number = host->cmd_serial_number++;
 	if (cmd->serial_number == 0) 
 		cmd->serial_number = host->cmd_serial_number++;
 }
 
+EXPORT_SYMBOL(scsi_cmd_get_serial);
+
 /**
  * scsi_dispatch_command - Dispatch a command to the low-level driver.
  * @cmd: command block we are dispatching.
@@ -651,7 +653,6 @@ static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd
 int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
-	unsigned long flags = 0;
 	unsigned long timeout;
 	int rtn = 0;
 
@@ -737,15 +738,6 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		goto out;
 	}
 
-	spin_lock_irqsave(host->host_lock, flags);
-	/*
-	 * AK: unlikely race here: for some reason the timer could
-	 * expire before the serial number is set up below.
-	 *
-	 * TODO: kill serial or move to blk layer
-	 */
-	scsi_cmd_get_serial(host, cmd); 
-
 	if (unlikely(host->shost_state == SHOST_DEL)) {
 		cmd->result = (DID_NO_CONNECT << 16);
 		scsi_done(cmd);
@@ -753,7 +745,6 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		trace_scsi_dispatch_cmd_start(cmd);
 		rtn = host->hostt->queuecommand(cmd, scsi_done);
 	}
-	spin_unlock_irqrestore(host->host_lock, flags);
 	if (rtn) {
 		trace_scsi_dispatch_cmd_error(cmd, rtn);
 		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 9c73dbd..351872e 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -579,14 +579,19 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 	unsigned int id, lun;
 	struct req_msg *req;
 	u16 tag;
+	unsigned long irqflags;
 
 	host = cmd->device->host;
+	spin_lock_irqsave(host->host_lock, irqflags);
+	scsi_cmd_get_serial(host, cmd);
 	id = cmd->device->id;
 	lun = cmd->device->lun;
 	hba = (struct st_hba *) &host->hostdata[0];
 
-	if (unlikely(hba->mu_status == MU_STATE_RESETTING))
+	if (unlikely(hba->mu_status == MU_STATE_RESETTING)) {
+		spin_unlock_irqrestore(host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	switch (cmd->cmnd[0]) {
 	case MODE_SENSE_10:
@@ -603,6 +608,8 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 			done(cmd);
 		} else
 			stex_invalid_field(cmd, done);
+
+		spin_unlock_irqrestore(host->host_lock, irqflags);
 		return 0;
 	}
 	case REPORT_LUNS:
@@ -613,6 +620,8 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 		 */
 		if (hba->cardtype == st_shasta || id == host->max_id - 1) {
 			stex_invalid_field(cmd, done);
+
+			spin_unlock_irqrestore(host->host_lock, irqflags);
 			return 0;
 		}
 		break;
@@ -620,6 +629,7 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 		if (id == host->max_id - 1) {
 			cmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
 			done(cmd);
+			spin_unlock_irqrestore(host->host_lock, irqflags);
 			return 0;
 		}
 		break;
@@ -627,6 +637,7 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 		if (lun >= host->max_lun) {
 			cmd->result = DID_NO_CONNECT << 16;
 			done(cmd);
+			spin_unlock_irqrestore(host->host_lock, irqflags);
 			return 0;
 		}
 		if (id != host->max_id - 1)
@@ -639,6 +650,7 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 			done(cmd);
 		} else
 			stex_invalid_field(cmd, done);
+		spin_unlock_irqrestore(host->host_lock, irqflags);
 		return 0;
 	case PASSTHRU_CMD:
 		if (cmd->cmnd[1] == PASSTHRU_GET_DRVVER) {
@@ -657,6 +669,7 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 				DID_OK << 16 | COMMAND_COMPLETE << 8 :
 				DID_ERROR << 16 | COMMAND_COMPLETE << 8;
 			done(cmd);
+			spin_unlock_irqrestore(host->host_lock, irqflags);
 			return 0;
 		}
 	default:
@@ -667,8 +680,10 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 
 	tag = cmd->request->tag;
 
-	if (unlikely(tag >= host->can_queue))
+	if (unlikely(tag >= host->can_queue)) {
+		spin_unlock_irqrestore(host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	req = hba->alloc_rq(hba);
 
@@ -695,6 +710,7 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 	}
 
 	hba->send(hba, req, tag);
+	spin_unlock_irqrestore(host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index 713620e..82eaa21 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -914,6 +914,10 @@ static int NCR5380_queue_command(struct scsi_cmnd *cmd,
     SETUP_HOSTDATA(cmd->device->host);
     struct scsi_cmnd *tmp;
     unsigned long flags;
+    unsigned long irqflags;
+
+    spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+    scsi_cmd_get_serial(cmd->device->host);
 
 #if (NDEBUG & NDEBUG_NO_WRITE)
     switch (cmd->cmnd[0]) {
@@ -923,6 +927,8 @@ static int NCR5380_queue_command(struct scsi_cmnd *cmd,
 	       H_NO(cmd));
 	cmd->result = (DID_ERROR << 16);
 	done(cmd);
+
+        spin_lock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
     }
 #endif /* (NDEBUG & NDEBUG_NO_WRITE) */
@@ -1016,6 +1022,8 @@ static int NCR5380_queue_command(struct scsi_cmnd *cmd,
 	queue_main();
     else
 	NCR5380_main(NULL);
+
+    spin_lock_irqrestore(cmd->device->host->host_lock, irqflags);
     return 0;
 }
 
diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index e5c369b..28e24d2 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -739,7 +739,10 @@ int sym53c416_queuecommand(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
 	int base;
 	unsigned long flags = 0;
 	int i;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
 	/* Store base register as we can have more than one controller in the system */
 	base = SCpnt->device->host->io_port;
 	current_command = SCpnt;                  /* set current command                */
@@ -758,6 +761,7 @@ int sym53c416_queuecommand(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
 	outb(SEL_WITHOUT_ATN_SEQ, base + COMMAND_REG);
 	/* Now an interrupt will be generated which we will catch in out interrupt routine */
 	spin_unlock_irqrestore(&sym53c416_lock, flags);
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 8b955b5..eb0734a 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -511,7 +511,10 @@ static int sym53c8xx_queue_command(struct scsi_cmnd *cmd,
 	struct sym_hcb *np = SYM_SOFTC_PTR(cmd);
 	struct sym_ucmd *ucp = SYM_UCMD_PTR(cmd);
 	int sts = 0;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	cmd->scsi_done = done;
 	memset(ucp, 0, sizeof(*ucp));
 
@@ -527,12 +530,17 @@ static int sym53c8xx_queue_command(struct scsi_cmnd *cmd,
 		}
 	}
 
-	if (np->s.settle_time_valid)
+	if (np->s.settle_time_valid) {
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	sts = sym_queue_command(np, cmd);
-	if (sts)
+	if (sts) {
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 27866b0..fca1761 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -1890,7 +1890,10 @@ static int DC390_queuecommand(struct scsi_cmnd *cmd,
 	struct dc390_acb *acb = (struct dc390_acb *)sdev->host->hostdata;
 	struct dc390_dcb *dcb = sdev->hostdata;
 	struct dc390_srb *srb;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	if (sdev->queue_depth <= dcb->GoingSRBCnt)
 		goto device_busy;
 	if (acb->pActiveDCB)
@@ -1935,9 +1938,11 @@ static int DC390_queuecommand(struct scsi_cmnd *cmd,
 
 	dc390_Going_append(dcb, srb);
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 
  host_busy:
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return SCSI_MLQUEUE_HOST_BUSY;
 
  device_busy:
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 5d9fdee..2345891 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1251,7 +1251,10 @@ static void scsi_to_dev_dir(unsigned int i, unsigned int j) {
 static int u14_34f_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *)) {
    unsigned int i, j, k;
    struct mscp *cpp;
+   unsigned long irqflags;
 
+   spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+   scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
    /* j is the board number */
    j = ((struct hostdata *) SCpnt->device->host->hostdata)->board_number;
 
@@ -1275,6 +1278,7 @@ static int u14_34f_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scs
 
    if (k == sh[j]->can_queue) {
       printk("%s: qcomm, no free mailbox.\n", BN(j));
+      spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
       return 1;
       }
 
@@ -1308,6 +1312,7 @@ static int u14_34f_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scs
                                      && TLDEV(SCpnt->device->type)) {
       HD(j)->cp_stat[i] = READY;
       flush_dev(SCpnt->device, blk_rq_pos(SCpnt->request), j, FALSE);
+      spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
       return 0;
       }
 
@@ -1316,6 +1321,7 @@ static int u14_34f_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scs
       SCpnt->host_scribble = NULL;
       scmd_printk(KERN_INFO, SCpnt,
       		"qcomm, pid %ld, adapter busy.\n", SCpnt->serial_number);
+      spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
       return 1;
       }
 
@@ -1326,6 +1332,7 @@ static int u14_34f_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scs
    outb(CMD_OGM_INTR, sh[j]->io_port + REG_LCL_INTR);
 
    HD(j)->cp_stat[i] = IN_USE;
+   spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
    return 0;
 }
 
diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index 27aa40f..d3b968f 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -708,6 +708,10 @@ static int ultrastor_queuecommand(struct scsi_cmnd *SCpnt,
     int mscp_index;
 #endif
     unsigned int status;
+    unsigned long irqflags;
+
+    spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+    scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
 
     /* Next test is for debugging; "can't happen" */
     if ((config.mscp_free & ((1U << ULTRASTOR_MAX_CMDS) - 1)) == 0)
@@ -800,8 +804,10 @@ retry:
 #if ULTRASTOR_MAX_CMDS > 1
 	SCpnt->result = status;
 	done(SCpnt);
+        spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return 0;
 #else
+        spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return status;
 #endif
     }
@@ -822,6 +828,7 @@ retry:
     printk("USx4F: queuecommand: returning\n");
 #endif
 
+    spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
     return 0;
 }
 
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 2689445..bfb85b0 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -696,7 +696,10 @@ static int pvscsi_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	struct pvscsi_adapter *adapter = shost_priv(host);
 	struct pvscsi_ctx *ctx;
 	unsigned long flags;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	spin_lock_irqsave(&adapter->hw_lock, flags);
 
 	ctx = pvscsi_acquire_context(adapter, cmd);
@@ -704,6 +707,7 @@ static int pvscsi_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 		if (ctx)
 			pvscsi_release_context(adapter, ctx);
 		spin_unlock_irqrestore(&adapter->hw_lock, flags);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -716,6 +720,7 @@ static int pvscsi_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 
 	pvscsi_kick_io(adapter, cmd->cmnd[0]);
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index b701bf2..d552930 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -377,7 +377,10 @@ wd33c93_queuecommand(struct scsi_cmnd *cmd,
 {
 	struct WD33C93_hostdata *hostdata;
 	struct scsi_cmnd *tmp;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmd->device->host, cmd);
 	hostdata = (struct WD33C93_hostdata *) cmd->device->host->hostdata;
 
 	DB(DB_QUEUE_COMMAND,
@@ -464,7 +467,8 @@ wd33c93_queuecommand(struct scsi_cmnd *cmd,
 
 	DB(DB_QUEUE_COMMAND, printk(")Q-%ld ", cmd->serial_number))
 
-	spin_unlock_irq(&hostdata->lock);
+	spin_unlock(&hostdata->lock);
+	spin_unlock_irqrestore(cmd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 333580b..70ff71b 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1092,7 +1092,10 @@ static int wd7000_queuecommand(struct scsi_cmnd *SCpnt,
 	short cdblen;
 	int nseg;
 	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(SCpnt->device->host, SCpnt);
 	cdblen = SCpnt->cmd_len;
 	idlun = ((SCpnt->device->id << 5) & 0xe0) | (SCpnt->device->lun & 7);
 	SCpnt->scsi_done = done;
@@ -1136,6 +1139,7 @@ static int wd7000_queuecommand(struct scsi_cmnd *SCpnt,
 	while (!mail_out(host, scb))
 		cpu_relax();	/* keep trying */
 
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 62882a4..7d19576 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -616,6 +616,10 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
 	int i;
 	struct scatterlist *sgl;
 	unsigned int sg_count = 0;
+	unsigned long irqflags;
+
+	spin_lock_irqsave(scmnd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(scmnd->device->host, scmnd);
 
 	DPRINT_DBG(STORVSC_DRV, "scmnd %p dir %d, use_sg %d buf %p len %d "
 		   "queue depth %d tagged %d", scmnd, scmnd->sc_data_direction,
@@ -648,6 +652,8 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
 		DPRINT_ERR(STORVSC_DRV, "scmnd (%p) - unable to allocate "
 			   "storvsc_cmd_request...marking queue busy", scmnd);
 		scmnd->scsi_done = NULL;
+
+		spin_unlock_irqrestore(scmnd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 
@@ -718,6 +724,7 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
 				kmem_cache_free(host_device_ctx->request_pool,
 						cmd_request);
 
+				spin_unlock_irqrestore(scmnd->device->host->host_lock, irqflags);
 				return SCSI_MLQUEUE_HOST_BUSY;
 			}
 
@@ -782,6 +789,7 @@ retry_request:
 		ret = SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 
+	spin_unlock_irqrestore(scmnd->device->host->host_lock, irqflags);
 	return ret;
 }
 
diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 5a47805..7543420 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -578,7 +578,10 @@ mts_scsi_queuecommand(struct scsi_cmnd *srb, mts_scsi_cmnd_callback callback)
 	struct mts_desc* desc = (struct mts_desc*)(srb->device->host->hostdata[0]);
 	int err = 0;
 	int res;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(srb->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(srb->device->host, srb);
 	MTS_DEBUG_GOT_HERE();
 	mts_show_command(srb);
 	mts_debug_dump(desc);
@@ -623,6 +626,7 @@ mts_scsi_queuecommand(struct scsi_cmnd *srb, mts_scsi_cmnd_callback callback)
 
 	}
 out:
+	spin_unlock_irqrestore(srb->device->host->host_lock, irqflags);
 	return err;
 }
 
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index a688b1e..f1b0aa9 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -289,13 +289,17 @@ static int queuecommand(struct scsi_cmnd *srb,
 			void (*done)(struct scsi_cmnd *))
 {
 	struct us_data *us = host_to_us(srb->device->host);
+	unsigned long irqflags;
 
+	spin_lock_irqsave(srb->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(srb->device->host, srb);
 	US_DEBUGP("%s called\n", __func__);
 
 	/* check for state-transition errors */
 	if (us->srb != NULL) {
 		printk(KERN_ERR USB_STORAGE "Error in %s: us->srb = %p\n",
 			__func__, us->srb);
+		spin_unlock_irqrestore(srb->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -304,6 +308,7 @@ static int queuecommand(struct scsi_cmnd *srb,
 		US_DEBUGP("Fail command during disconnect\n");
 		srb->result = DID_NO_CONNECT << 16;
 		done(srb);
+		spin_unlock_irqrestore(srb->device->host->host_lock, irqflags);
 		return 0;
 	}
 
@@ -312,6 +317,7 @@ static int queuecommand(struct scsi_cmnd *srb,
 	us->srb = srb;
 	complete(&us->cmnd_ready);
 
+	spin_unlock_irqrestore(srb->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 2054b1e..d00db31 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -440,11 +440,16 @@ static int uas_queuecommand(struct scsi_cmnd *cmnd,
 	struct uas_dev_info *devinfo = sdev->hostdata;
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
 	int err;
+	unsigned long irqflags;
 
+	spin_lock_irqsave(cmnd->device->host->host_lock, irqflags);
+	scsi_cmd_get_serial(cmnd->device->host, cmnd);
 	BUILD_BUG_ON(sizeof(struct uas_cmd_info) > sizeof(struct scsi_pointer));
 
-	if (!cmdinfo->sense_urb && sdev->current_cmnd)
+	if (!cmdinfo->sense_urb && sdev->current_cmnd) {
+		spin_unlock_irqrestore(cmnd->device->host->host_lock, irqflags);
 		return SCSI_MLQUEUE_DEVICE_BUSY;
+	}
 
 	if (blk_rq_tagged(cmnd->request)) {
 		cmdinfo->stream = cmnd->request->tag + 1;
@@ -480,6 +485,7 @@ static int uas_queuecommand(struct scsi_cmnd *cmnd,
 		/* If we did nothing, give up now */
 		if (cmdinfo->state & SUBMIT_SENSE_URB) {
 			usb_free_urb(cmdinfo->sense_urb);
+			spin_unlock_irqrestore(cmnd->device->host->host_lock, irqflags);
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		}
 		spin_lock(&uas_work_lock);
@@ -488,6 +494,7 @@ static int uas_queuecommand(struct scsi_cmnd *cmnd,
 		schedule_work(&uas_work);
 	}
 
+	spin_unlock_irqrestore(cmnd->device->host->host_lock, irqflags);
 	return 0;
 }
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index d0a6a84..99a2da7 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -881,5 +881,6 @@ static inline unsigned char scsi_host_get_guard(struct Scsi_Host *shost)
 extern struct Scsi_Host *scsi_register(struct scsi_host_template *, int);
 extern void scsi_unregister(struct Scsi_Host *);
 extern int scsi_host_set_state(struct Scsi_Host *, enum scsi_host_state);
+extern void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd);
 
 #endif /* _SCSI_SCSI_HOST_H */
