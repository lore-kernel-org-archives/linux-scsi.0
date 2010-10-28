From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH v8] scsi: Push down host_lock into legacy LLD SHT->queuecommand()
Date: Thu, 28 Oct 2010 00:01:08 -0700
Message-ID: <1288249268-17734-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp104.sbc.mail.gq1.yahoo.com ([67.195.15.63]:29114 "HELO
	smtp104.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754411Ab0J1HBR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2010 03:01:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux>
Cc: James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, "eata.c maintainer" <dario.ballabio@inwind.it>, Luben Tuikov <ltuikov@yahoo.com>, mvsas maintainer <kewei@marvell.com>, pm8001 maintainer Jack Wang <jack_wang@usish.com>, be2iscsi maintainer Jayamohan Kallickal <jayamohank@serverengines.com>, cxgb43i maintainer Karen Xie <kxie@chelsio.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Following yet another round of convincing discussions from jgarzik and jejb
this afternoon, this RFCv8 patch series follows their recommendation and does a
SCSI subsystem wide 'push down' of struct Scsi_Host->host_lock usage from
scsi_dispatch_cmd() into legacy LLDs that require (or we are not sure about)
the host_lock held while SHT->queuecommand() I/O dispatch occurs.

This patch still calls scsi_cmd_get_serial() for all LLDs within scsi_dispatch_cmd()
to perform struct scsi_cmnd->serial_number assignment using the new atomic_t
struct Scsi_Host->cmd_serial_number counter.  This counter follows a recommedation by
Joe Eykholt to increment each serial_number by 2 so that the serial is odd, and wraps
to 1 instead of 0.

Finally this patch also changes modern LLDs originally using the SHT->queuecommand() ->
unlock() -> do_some_lld_work() -> lock() -> return from lld_queuecommand()
optimization to now run by default in the 'host_lock-less' mode.  This also
includes a handful of other LLDs that folks have tested in unlocked mode and
appear to be functioning as expected.

The full list of LLDs and their respective host_lock-less or legacy states are as
follows:

arch/ia64/hp/sim/simscsi.c: legacy LLD queuecommand() host_lock
drivers/ata/libata-scsi.c: Running in host_lock less mode (libata)
drivers/block/cciss_scsi.c: legacy LLD queuecommand() host_lock
drivers/firewire/sbp2.c: legacy LLD queuecommand() host_lock
drivers/infiniband/ulp/iser/iscsi_iser.c: Running in host_lock less mode (libiscsi)
drivers/infiniband/ulp/srp/ib_srp.c: Running in host_lock less mode (internal)
drivers/message/fusion/mptscsih.c: Running in host_lock less mode (internal)
drivers/message/fusion/mptfc.c: Running in host_lock less mode (internal)
drivers/message/fusion/mptsas.c: Running in host_lock less mode (internal)
drivers/message/fusion/mptspi.c: Running in host_lock less mode (internal)
drivers/message/i2o/i2o_scsi.c: legacy LLD queuecommand() host_lock
drivers/s390/scsi/zfcp_scsi.c: legacy LLD queuecommand() host_lock
drivers/scsi/3w-sas.c: legacy LLD queuecommand() host_lock
drivers/scsi/3w-xxxx.c: legacy LLD queuecommand() host_lock
drivers/scsi/BusLogic.c: legacy LLD queuecommand() host_lock
drivers/scsi/aic7xxx_old.c: legacy LLD queuecommand() host_lock
drivers/scsi/NCR53c406a.c: legacy LLD queuecommand() host_lock
drivers/scsi/a100u2w.c: legacy LLD queuecommand() host_lock
drivers/scsi/a2091.c: legacy LLD queuecommand() host_lock
drivers/scsi/a3000.c: legacy LLD queuecommand() host_lock
drivers/scsi/aacraid/linit.c: legacy LLD queuecommand() host_lock
drivers/scsi/advansys.c: legacy LLD queuecommand() host_lock
drivers/scsi/aha152x.c: legacy LLD queuecommand() host_lock
drivers/scsi/aha1542.c: legacy LLD queuecommand() host_lock
drivers/scsi/aha1740.c: legacy LLD queuecommand() host_lock
drivers/scsi/aic7xxx/aic79xx_osm.c: legacy LLD queuecommand() host_lock
drivers/scsi/aic7xxx/aic7xxx_osm.c: legacy LLD queuecommand() host_lock
drivers/scsi/aic94xx/aic94xx_init.c: Running in host_lock less mode (libsas)
drivers/scsi/arcmsr/arcmsr_hba.c: legacy LLD queuecommand() host_lock
drivers/scsi/arm/arxescsi.c: legacy LLD queuecommand() host_lock
drivers/scsi/arm/cumana_1.c: legacy LLD queuecommand() host_lock
drivers/scsi/arm/cumana_2.c: legacy LLD queuecommand() host_lock
drivers/scsi/arm/eesox.c: legacy LLD queuecommand() host_lock
drivers/scsi/arm/oak.c: legacy LLD queuecommand() host_lock
drivers/scsi/arm/powertec.c: legacy LLD queuecommand() host_lock
drivers/scsi/arm/acornscsi.c: legacy LLD queuecommand() host_lock
drivers/scsi/atari_scsi.c: legacy LLD queuecommand() host_lock
drivers/scsi/atp870u.c: legacy LLD queuecommand() host_lock
drivers/scsi/be2iscsi/be_main.c: Running in host_lock less mode (libiscsi)
drivers/scsi/bfa/bfad_im.c: legacy LLD queuecommand() host_lock
drivers/scsi/bfa/bfad_im.c: legacy LLD queuecommand() host_lock
drivers/scsi/bnx2i/bnx2i_iscsi.c: Running in host_lock less mode (libiscsi)
drivers/scsi/ipr.c: legacy LLD queuecommand() host_lock
drivers/scsi/3w-9xxx.c: legacy LLD queuecommand() host_lock
drivers/scsi/dc395x.c: legacy LLD queuecommand() host_lock
drivers/scsi/dmx3191d.c: legacy LLD queuecommand() host_lock
drivers/scsi/dpt_i2o.c: legacy LLD queuecommand() host_lock
drivers/scsi/dtc.c: legacy LLD queuecommand() host_lock
drivers/scsi/eata.c: legacy LLD queuecommand() host_lock
drivers/scsi/eata_pio.c: legacy LLD queuecommand() host_lock
drivers/scsi/esp_scsi.c: legacy LLD queuecommand() host_lock
drivers/scsi/fcoe/fcoe.c: legacy LLD queuecommand() host_lock (libfc)
drivers/scsi/fd_mcs.c: legacy LLD queuecommand() host_lock
drivers/scsi/fdomain.c: legacy LLD queuecommand() host_lock
drivers/scsi/fnic/fnic_main.c: Running in host_lock less mode (internal)
drivers/scsi/g_NCR5380.c: legacy LLD queuecommand() host_lock
drivers/scsi/gdth.c: legacy LLD queuecommand() host_lock
drivers/scsi/gvp11.c: legacy LLD queuecommand() host_lock
drivers/scsi/hpsa.c: legacy LLD queuecommand() host_lock
drivers/scsi/hptiop.c: legacy LLD queuecommand() host_lock
drivers/scsi/ibmmca.c: legacy LLD queuecommand() host_lock
drivers/scsi/ibmvscsi/ibmvscsi.c: legacy LLD queuecommand() host_lock
drivers/scsi/ibmvscsi/ibmvfc.c: legacy LLD queuecommand() host_lock
drivers/scsi/imm.c: legacy LLD queuecommand() host_lock
drivers/scsi/in2000.c: legacy LLD queuecommand() host_lock
drivers/scsi/initio.c: legacy LLD queuecommand() host_lock
drivers/scsi/ips.c: legacy LLD queuecommand() host_lock
drivers/scsi/iscsi_tcp.c: Running in host_lock less mode (libiscsi)
drivers/scsi/lpfc/lpfc_scsi.c: Running in host_lock less mode (internal)
drivers/scsi/mac53c94.c: legacy LLD queuecommand() host_lock
drivers/scsi/mac_scsi.c: legacy LLD queuecommand() host_lock
drivers/scsi/megaraid.c: legacy LLD queuecommand() host_lock
drivers/scsi/megaraid/megaraid_mbox.c: legacy LLD queuecommand() host_lock
drivers/scsi/megaraid/megaraid_sas.c: legacy LLD queuecommand() host_lock
drivers/scsi/mesh.c: legacy LLD queuecommand() host_lock
drivers/scsi/mpt2sas/mpt2sas_scsih.c: Running in host_lock less mode (internal)
drivers/scsi/mvme147.c: legacy LLD queuecommand() host_lock
drivers/scsi/mvsas/mv_init.c: Running in host_lock less mode (libsas)
drivers/scsi/nsp32.c: legacy LLD queuecommand() host_lock
drivers/scsi/pas16.c: legacy LLD queuecommand() host_lock
drivers/scsi/pcmcia/qlogic_stub.c: legacy LLD queuecommand() host_lock
drivers/scsi/pcmcia/nsp_cs.c: legacy LLD queuecommand() host_lock
drivers/scsi/pcmcia/sym53c500_cs.c: legacy LLD queuecommand() host_lock
drivers/scsi/pm8001/pm8001_init.c: Running in host_lock less mode (libsas)
drivers/scsi/pmcraid.c: legacy LLD queuecommand() host_lock
drivers/scsi/ppa.c: legacy LLD queuecommand() host_lock
drivers/scsi/ps3rom.c: legacy LLD queuecommand() host_lock
drivers/scsi/qla1280.c: legacy LLD queuecommand() host_lock
drivers/scsi/qla2xxx/qla_os.c: Running in host_lock less mode (internal)
drivers/scsi/qla4xxx/ql4_os.c: Running in host_lock less mode (internal)
drivers/scsi/qlogicfas.c: legacy LLD queuecommand() host_lock
drivers/scsi/qlogicpti.c: legacy LLD queuecommand() host_lock
drivers/scsi/scsi_debug.c: Running in host_lock less mode (internal)
drivers/scsi/sgiwd93.c: legacy LLD queuecommand() host_lock
drivers/scsi/sun3_scsi.c: legacy LLD queuecommand() host_lock
drivers/scsi/sun3_scsi_vme.c: legacy LLD queuecommand() host_lock
drivers/scsi/sym53c8xx_2/sym_glue.c: legacy LLD queuecommand() host_lock
drivers/scsi/t128.c: legacy LLD queuecommand() host_lock
drivers/scsi/cxgbi/cxgb3i/cxgb3i.c: Running in host_lock less mode (libiscsi)
drivers/scsi/cxgbi/cxgb4i/cxgb4i.c: Running in host_lock less mode (libiscsi)
drivers/scsi/u14-34f.c: legacy LLD queuecommand() host_lock
drivers/scsi/stex.c: legacy LLD queuecommand() host_lock
drivers/scsi/sym53c416.c: legacy LLD queuecommand() host_lock
drivers/scsi/tmscsim.c: legacy LLD queuecommand() host_lock
drivers/scsi/ultrastor.c: legacy LLD queuecommand() host_lock
drivers/scsi/vmw_pvscsi.c: legacy LLD queuecommand() host_lock
drivers/scsi/wd7000.c: legacy LLD queuecommand() host_lock
drivers/staging/hv/storvsc_drv.c: legacy LLD queuecommand() host_lock
drivers/usb/image/microtek.c: legacy LLD queuecommand() host_lock
drivers/usb/storage/scsiglue.c: legacy LLD queuecommand() host_lock
drivers/usb/storage/uas.c: legacy LLD queuecommand() host_lock

So at this point if any LLDs maintainers see their driver listed above as:

	"legacy LLD queuecommand() host_lock"

and can verify that host_lock is *not* a hard requirement for I/O dispatch via
SHT->queuecommand(), please let me know and I will drop the legacy mode push
down patch for the LLD in question.

Many thanks to Vasu Dev, Tim Chen, Andi Kleen, Mike Christie, Joe Eykholt,
Mike Anderson, Christof Schmitt, Brian King, Jens Axboe, James Bottomley,
H. Peter Anvin, and Jeff Garzik for their help with this series!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Acked-by: Ravi Anand <ravi.anand@qlogic.com> (for qla2xxx)
Acked-by: Luben Tuikov <ltuikov@yahoo.com> (for aic94xx)
Acked-by: Jack Wang <jack_wang@usish.com> (for pm8001)
---
 arch/ia64/hp/sim/simscsi.c            |    5 ++++
 drivers/ata/libata-scsi.c             |    4 +--
 drivers/block/cciss_scsi.c            |    6 ++++-
 drivers/firewire/sbp2.c               |    5 ++++
 drivers/message/i2o/i2o_scsi.c        |    3 ++
 drivers/s390/scsi/zfcp_scsi.c         |   14 +++++++++++-
 drivers/scsi/3w-9xxx.c                |    4 +++
 drivers/scsi/3w-sas.c                 |    3 ++
 drivers/scsi/3w-xxxx.c                |    9 ++++++-
 drivers/scsi/BusLogic.c               |    8 +++++++
 drivers/scsi/NCR5380.c                |    6 +++++
 drivers/scsi/NCR53c406a.c             |    4 +++
 drivers/scsi/a100u2w.c                |   10 +++++++-
 drivers/scsi/aacraid/linit.c          |    9 +++++++-
 drivers/scsi/advansys.c               |    3 ++
 drivers/scsi/aha152x.c                |   10 +++++++-
 drivers/scsi/aha1542.c                |   16 +++++++++++---
 drivers/scsi/aha1740.c                |    7 +++++-
 drivers/scsi/aic7xxx/aic79xx_osm.c    |    3 ++
 drivers/scsi/aic7xxx/aic7xxx_osm.c    |    4 ++-
 drivers/scsi/aic7xxx_old.c            |    4 +++
 drivers/scsi/arcmsr/arcmsr_hba.c      |   16 +++++++++++++-
 drivers/scsi/arm/acornscsi.c          |    7 ++++++
 drivers/scsi/arm/fas216.c             |    7 +++--
 drivers/scsi/atp870u.c                |    9 ++++++++
 drivers/scsi/bfa/bfad_im.c            |   13 +++++++++--
 drivers/scsi/dc395x.c                 |    8 +++++++
 drivers/scsi/dpt_i2o.c                |   14 ++++++++++++-
 drivers/scsi/eata.c                   |    8 +++++++
 drivers/scsi/eata_pio.c               |    6 ++++-
 drivers/scsi/esp_scsi.c               |    9 ++++++-
 drivers/scsi/fd_mcs.c                 |    4 +++
 drivers/scsi/fdomain.c                |    5 ++++
 drivers/scsi/fnic/fnic_scsi.c         |    9 --------
 drivers/scsi/gdth.c                   |    8 ++++++-
 drivers/scsi/hosts.c                  |    4 +++
 drivers/scsi/hpsa.c                   |    9 +++++++-
 drivers/scsi/hptiop.c                 |    7 ++++++
 drivers/scsi/ibmmca.c                 |   13 ++++++++++++
 drivers/scsi/ibmvscsi/ibmvfc.c        |   17 +++++++++++++--
 drivers/scsi/ibmvscsi/ibmvscsi.c      |   15 +++++++++++--
 drivers/scsi/imm.c                    |    5 ++++
 drivers/scsi/in2000.c                 |    7 +++++-
 drivers/scsi/initio.c                 |    9 +++++++-
 drivers/scsi/ipr.c                    |   23 +++++++++++++++++----
 drivers/scsi/ips.c                    |   26 ++++++++++++++++++-----
 drivers/scsi/libfc/fc_fcp.c           |    7 ++++-
 drivers/scsi/libiscsi.c               |    4 ---
 drivers/scsi/libsas/sas_scsi_host.c   |    5 ----
 drivers/scsi/lpfc/lpfc_scsi.c         |    2 -
 drivers/scsi/mac53c94.c               |    3 ++
 drivers/scsi/megaraid.c               |    5 +++-
 drivers/scsi/megaraid/megaraid_mbox.c |    6 +++++
 drivers/scsi/megaraid/megaraid_sas.c  |   17 +++++++++++----
 drivers/scsi/mesh.c                   |    4 +++
 drivers/scsi/nsp32.c                  |    8 +++++++
 drivers/scsi/pcmcia/nsp_cs.c          |    7 ++++++
 drivers/scsi/pcmcia/sym53c500_cs.c    |    4 +++
 drivers/scsi/pmcraid.c                |   16 +++++++++++++-
 drivers/scsi/ppa.c                    |    5 ++++
 drivers/scsi/ps3rom.c                 |    4 +++
 drivers/scsi/qla1280.c                |    5 ++++
 drivers/scsi/qla2xxx/qla_os.c         |    9 +------
 drivers/scsi/qla4xxx/ql4_os.c         |    8 +------
 drivers/scsi/qlogicfas408.c           |    7 ++++++
 drivers/scsi/qlogicpti.c              |    6 +++++
 drivers/scsi/scsi.c                   |   35 +++++++++++++++++---------------
 drivers/scsi/stex.c                   |   25 +++++++++++++++++++++-
 drivers/scsi/sym53c416.c              |    6 ++++-
 drivers/scsi/sym53c8xx_2/sym_glue.c   |   13 ++++++++++-
 drivers/scsi/tmscsim.c                |    6 +++++
 drivers/scsi/u14-34f.c                |    8 +++++++
 drivers/scsi/ultrastor.c              |    6 +++++
 drivers/scsi/vmw_pvscsi.c             |    6 ++++-
 drivers/scsi/wd33c93.c                |    3 ++
 drivers/scsi/wd7000.c                 |    4 +++
 drivers/staging/hv/storvsc_drv.c      |    7 ++++++
 drivers/usb/image/microtek.c          |    4 +++
 drivers/usb/storage/scsiglue.c        |    6 +++++
 drivers/usb/storage/uas.c             |   10 ++++++++-
 include/scsi/scsi_host.h              |    5 +--
 81 files changed, 549 insertions(+), 122 deletions(-)

diff --git a/arch/ia64/hp/sim/simscsi.c b/arch/ia64/hp/sim/simscsi.c
index 3a078ad..c7e1dbd 100644
--- a/arch/ia64/hp/sim/simscsi.c
+++ b/arch/ia64/hp/sim/simscsi.c
@@ -204,6 +204,7 @@ simscsi_readwrite10 (struct scsi_cmnd *sc, int mode)
 static int
 simscsi_queuecommand (struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 {
+	unsigned long hflags;
 	unsigned int target_id = sc->device->id;
 	char fname[MAX_ROOT_LEN+16];
 	size_t disk_size;
@@ -217,6 +218,8 @@ simscsi_queuecommand (struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		       target_id, sc->cmnd[0], sc->serial_number, sp, done);
 #endif
 
+	spin_lock_irqsave(sc->device->host->host_lock, hflags);
+
 	sc->result = DID_BAD_TARGET << 16;
 	sc->scsi_done = done;
 	if (target_id <= 15 && sc->device->lun == 0) {
@@ -323,6 +326,8 @@ simscsi_queuecommand (struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 	wr = (wr + 1) % SIMSCSI_REQ_QUEUE_LEN;
 
 	tasklet_schedule(&simscsi_tasklet);
+
+	spin_unlock_irqrestore(sc->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index d050e07..672a8c9 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3174,7 +3174,7 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
  *	ATA and ATAPI devices appearing as SCSI devices.
  *
  *	LOCKING:
- *	Releases scsi-layer-held lock, and obtains host lock.
+ *	None
  *
  *	RETURNS:
  *	Return value from __ata_scsi_queuecmd() if @cmd can be queued,
@@ -3190,7 +3190,6 @@ int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 
 	ap = ata_shost_to_port(shost);
 
-	spin_unlock(shost->host_lock);
 	spin_lock(ap->lock);
 
 	ata_scsi_dump_cdb(ap, cmd);
@@ -3204,7 +3203,6 @@ int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	}
 
 	spin_unlock(ap->lock);
-	spin_lock(shost->host_lock);
 	return rc;
 }
 
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 575495f..bb7a4e9 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -1412,8 +1412,9 @@ cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd
 	int rc;
 	unsigned char scsi3addr[8];
 	CommandList_struct *c;
-	unsigned long flags;
+	unsigned long flags, hflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
 	// Get the ptr to our adapter structure (hba[i]) out of cmd->host.
 	// We violate cmd->host privacy here.  (Is there another way?)
 	h = (ctlr_info_t *) cmd->device->host->hostdata[0];
@@ -1427,6 +1428,7 @@ cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd
 		done(cmd);
 		/* we might want to think about registering controller itself
 		   as a processor device on the bus so sg binds to it. */
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return 0;
 	}
 
@@ -1441,6 +1443,7 @@ cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd
 		/* FIXME: next 3 lines are -> BAD! <- */
 		cmd->result = DID_NO_CONNECT << 16;
 		done(cmd);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return 0;
 	}
 
@@ -1501,6 +1504,7 @@ cciss_scsi_queue_command (struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd
 	cciss_scatter_gather(h, c, cmd);
 	enqueue_cmd_and_start_io(h, c);
 	/* the cmd'll come back via intr handler in complete_scsi_command()  */
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index bfae4b3..52b7330 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1473,8 +1473,10 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 	struct sbp2_logical_unit *lu = cmd->device->hostdata;
 	struct fw_device *device = target_device(lu->tgt);
 	struct sbp2_command_orb *orb;
+	unsigned long hflags;
 	int generation, retval = SCSI_MLQUEUE_HOST_BUSY;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
 	/*
 	 * Bidirectional commands are not yet implemented, and unknown
 	 * transfer direction not handled.
@@ -1483,12 +1485,14 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 		fw_error("Can't handle DMA_BIDIRECTIONAL, rejecting command\n");
 		cmd->result = DID_ERROR << 16;
 		done(cmd);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return 0;
 	}
 
 	orb = kzalloc(sizeof(*orb), GFP_ATOMIC);
 	if (orb == NULL) {
 		fw_notify("failed to alloc orb\n");
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -1531,6 +1535,7 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 	retval = 0;
  out:
 	kref_put(&orb->base.kref, free_orb);
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return retval;
 }
 
diff --git a/drivers/message/i2o/i2o_scsi.c b/drivers/message/i2o/i2o_scsi.c
index ea6b219..46c37d4 100644
--- a/drivers/message/i2o/i2o_scsi.c
+++ b/drivers/message/i2o/i2o_scsi.c
@@ -511,6 +511,7 @@ static int i2o_scsi_queuecommand(struct scsi_cmnd *SCpnt,
 {
 	struct i2o_controller *c;
 	struct i2o_device *i2o_dev;
+	unsigned long hflags;
 	int tid;
 	struct i2o_message *msg;
 	/*
@@ -524,6 +525,7 @@ static int i2o_scsi_queuecommand(struct scsi_cmnd *SCpnt,
 	u32 cmd = I2O_CMD_SCSI_EXEC << 24;
 	int rc = 0;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, hflags);
 	/*
 	 *      Do the incoming paperwork
 	 */
@@ -687,6 +689,7 @@ static int i2o_scsi_queuecommand(struct scsi_cmnd *SCpnt,
 	i2o_msg_nop(c, msg);
 
       exit:
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 	return rc;
 };
 
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 50286d8..0ca1bd3 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -82,8 +82,11 @@ static int zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
 	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
 	struct fc_rport *rport = starget_to_rport(scsi_target(scpnt->device));
+	unsigned long hflags;
 	int    status, scsi_result, ret;
 
+	spin_lock_irqsave(scpnt->device->host->host_lock, hflags);
+
 	/* reset the status for this request */
 	scpnt->result = 0;
 	scpnt->host_scribble = NULL;
@@ -94,6 +97,7 @@ static int zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
 		scpnt->result = scsi_result;
 		zfcp_dbf_scsi_fail_send(adapter->dbf, scpnt);
 		scpnt->scsi_done(scpnt);
+		spin_unlock_irqrestore(scpnt->device->host->host_lock, hflags);
 		return 0;
 	}
 
@@ -104,6 +108,7 @@ static int zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
 		/* only LUN access denied, but port is good
 		 * not covered by FC transport, have to fail here */
 		zfcp_scsi_command_fail(scpnt, DID_ERROR);
+		spin_unlock_irqrestore(scpnt->device->host->host_lock, hflags);
 		return 0;
 	}
 
@@ -115,15 +120,20 @@ static int zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
 		 * 	fc_remote_port_chkready until rport is BLOCKED
 		 */
 		zfcp_scsi_command_fail(scpnt, DID_IMM_RETRY);
+		spin_unlock_irqrestore(scpnt->device->host->host_lock, hflags);
 		return 0;
 	}
 
 	ret = zfcp_fsf_fcp_cmnd(scpnt);
-	if (unlikely(ret == -EBUSY))
+	if (unlikely(ret == -EBUSY)) {
+		spin_unlock_irqrestore(scpnt->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_DEVICE_BUSY;
-	else if (unlikely(ret < 0))
+	} else if (unlikely(ret < 0)) {
+		spin_unlock_irqrestore(scpnt->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
+	spin_unlock_irqrestore(scpnt->device->host->host_lock, hflags);
 	return ret;
 }
 
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index fcf08b3..507943f 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1767,9 +1767,12 @@ out:
 /* This is the main scsi queue function to handle scsi opcodes */
 static int twa_scsi_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
+	unsigned long hflags;
 	int request_id, retval;
 	TW_Device_Extension *tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, hflags);
+
 	/* If we are resetting due to timed out ioctl, report as busy */
 	if (test_bit(TW_IN_RESET, &tw_dev->flags)) {
 		retval = SCSI_MLQUEUE_HOST_BUSY;
@@ -1809,6 +1812,7 @@ static int twa_scsi_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd
 		retval = 0;
 	}
 out:
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 	return retval;
 } /* End twa_scsi_queue() */
 
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 6a95d11..3a2f143 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1503,9 +1503,11 @@ out:
 /* This is the main scsi queue function to handle scsi opcodes */
 static int twl_scsi_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
+	unsigned long hflags;
 	int request_id, retval;
 	TW_Device_Extension *tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, hflags);
 	/* If we are resetting due to timed out ioctl, report as busy */
 	if (test_bit(TW_IN_RESET, &tw_dev->flags)) {
 		retval = SCSI_MLQUEUE_HOST_BUSY;
@@ -1533,6 +1535,7 @@ static int twl_scsi_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd
 		retval = 0;
 	}
 out:
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 	return retval;
 } /* End twl_scsi_queue() */
 
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index b112534..febedc4 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1950,14 +1950,18 @@ static int tw_scsiop_test_unit_ready_complete(TW_Device_Extension *tw_dev, int r
 static int tw_scsi_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *)) 
 {
 	unsigned char *command = SCpnt->cmnd;
+	unsigned long hflags;
 	int request_id = 0;
 	int retval = 1;
 	TW_Device_Extension *tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, hflags);
+
 	/* If we are resetting due to timed out ioctl, report as busy */
-	if (test_bit(TW_IN_RESET, &tw_dev->flags))
+	if (test_bit(TW_IN_RESET, &tw_dev->flags)) {
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
-
+	}
 	/* Save done function into Scsi_Cmnd struct */
 	SCpnt->scsi_done = done;
 		 
@@ -2020,6 +2024,7 @@ static int tw_scsi_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd
 		done(SCpnt);
 		retval = 0;
 	}
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 	return retval;
 } /* End tw_scsi_queue() */
 
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index fc0b4b8..e73c2fb 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2813,12 +2813,15 @@ static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRou
 	struct BusLogic_TargetFlags *TargetFlags = &HostAdapter->TargetFlags[Command->device->id];
 	struct BusLogic_TargetStatistics *TargetStatistics = HostAdapter->TargetStatistics;
 	unsigned char *CDB = Command->cmnd;
+	unsigned long hflags;
 	int CDB_Length = Command->cmd_len;
 	int TargetID = Command->device->id;
 	int LogicalUnit = Command->device->lun;
 	int BufferLength = scsi_bufflen(Command);
 	int Count;
 	struct BusLogic_CCB *CCB;
+
+	spin_lock_irqsave(Command->device->host->host_lock, hflags);
 	/*
 	   SCSI REQUEST_SENSE commands will be executed automatically by the Host
 	   Adapter for any errors, so they should not be executed explicitly unless
@@ -2827,6 +2830,8 @@ static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRou
 	if (CDB[0] == REQUEST_SENSE && Command->sense_buffer[0] != 0) {
 		Command->result = DID_OK << 16;
 		CompletionRoutine(Command);
+		spin_unlock_irqrestore(Command->device->host->host_lock,
+					hflags);
 		return 0;
 	}
 	/*
@@ -2844,6 +2849,8 @@ static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRou
 		if (CCB == NULL) {
 			Command->result = DID_ERROR << 16;
 			CompletionRoutine(Command);
+			spin_unlock_irqrestore(Command->device->host->host_lock,
+						hflags);
 			return 0;
 		}
 	}
@@ -2991,6 +2998,7 @@ static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRou
 		if (CCB->Status == BusLogic_CCB_Completed)
 			BusLogic_ProcessCompletedCCBs(HostAdapter);
 	}
+	spin_unlock_irqrestore(Command->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 5d2f148..e1accf1 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -957,6 +957,9 @@ static int NCR5380_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 	struct Scsi_Host *instance = cmd->device->host;
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 	Scsi_Cmnd *tmp;
+	unsigned long hflags;
+
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
 
 #if (NDEBUG & NDEBUG_NO_WRITE)
 	switch (cmd->cmnd[0]) {
@@ -965,6 +968,7 @@ static int NCR5380_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 		printk("scsi%d : WRITE attempted with NO_WRITE debugging flag set\n", instance->host_no);
 		cmd->result = (DID_ERROR << 16);
 		done(cmd);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return 0;
 	}
 #endif				/* (NDEBUG & NDEBUG_NO_WRITE) */
@@ -1018,6 +1022,8 @@ static int NCR5380_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 	/* Run the coroutine if it isn't already running. */
 	/* Kick off command processing */
 	schedule_delayed_work(&hostdata->coroutine, 0);
+
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
index 6961f78..d8851de 100644
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -695,8 +695,10 @@ static void wait_intr(void)
 
 static int NCR53c406a_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 {
+	unsigned long hflags;
 	int i;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, hflags);
 	VDEB(printk("NCR53c406a_queue called\n"));
 	DEB(printk("cmd=%02x, cmd_len=%02x, target=%02x, lun=%02x, bufflen=%d\n", SCpnt->cmnd[0], SCpnt->cmd_len, SCpnt->target, SCpnt->lun, scsi_bufflen(SCpnt)));
 
@@ -723,6 +725,8 @@ static int NCR53c406a_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 	outb(SELECT_NO_ATN, CMD_REG);
 
 	rtrc(1);
+
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index dbbc601..7ed5e94 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -915,18 +915,24 @@ static int inia100_queue(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd
 {
 	struct orc_scb *scb;
 	struct orc_host *host;		/* Point to Host adapter control block */
+	unsigned long hflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
 	host = (struct orc_host *) cmd->device->host->hostdata;
 	cmd->scsi_done = done;
 	/* Get free SCSI control block  */
-	if ((scb = orc_alloc_scb(host)) == NULL)
+	if ((scb = orc_alloc_scb(host)) == NULL) {
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
-
+	}
 	if (inia100_build_scb(host, scb, cmd)) {
 		orc_release_scb(host, scb);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 	orc_exec_scb(host, scb);	/* Start execute SCB            */
+
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 29c0ed1..48869d5 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -252,7 +252,10 @@ static int aac_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct aac_dev *dev = (struct aac_dev *)host->hostdata;
+	unsigned long hflags;
 	u32 count = 0;
+
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
 	cmd->scsi_done = done;
 	for (; count < (host->can_queue + AAC_NUM_MGT_FIB); ++count) {
 		struct fib * fib = &dev->fibs[count];
@@ -260,10 +263,14 @@ static int aac_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd
 		if (fib->hw_fib_va->header.XferState &&
 		    ((command = fib->callback_data)) &&
 		    (command == cmd) &&
-		    (cmd->SCp.phase == AAC_OWNER_FIRMWARE))
+		    (cmd->SCp.phase == AAC_OWNER_FIRMWARE)) {
+			spin_unlock_irqrestore(cmd->device->host->host_lock,
+						hflags);
 			return 0; /* Already owned by Adapter */
+		}
 	}
 	cmd->SCp.phase = AAC_OWNER_LOWLEVEL;
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return (aac_scsi_cmd(cmd) ? FAILED : 0);
 }
 
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 0ec3da6..971f433 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -9503,8 +9503,10 @@ static int
 advansys_queuecommand(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
 {
 	struct Scsi_Host *shost = scp->device->host;
+	unsigned long hflags;
 	int asc_res, result = 0;
 
+	spin_lock_irqsave(scp->device->host->host_lock, hflags);
 	ASC_STATS(shost, queuecommand);
 	scp->scsi_done = done;
 
@@ -9522,6 +9524,7 @@ advansys_queuecommand(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
 		break;
 	}
 
+	spin_unlock_irqrestore(scp->device->host->host_lock, hflags);
 	return result;
 }
 
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 8eab858..54f5b94 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1058,16 +1058,22 @@ static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct completion *complete,
  */
 static int aha152x_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
 {
+	unsigned long hflags;
+	int ret;
+
+	spin_lock_irqsave(SCpnt->device->host->host_lock, hflags);
 #if 0
 	if(*SCpnt->cmnd == REQUEST_SENSE) {
 		SCpnt->result = 0;
 		done(SCpnt);
-
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 		return 0;
 	}
 #endif
 
-	return aha152x_internal_queue(SCpnt, NULL, 0, done);
+	ret = aha152x_internal_queue(SCpnt, NULL, 0, done);
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
+	return ret;
 }
 
 
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 4f785f2..737b8d8 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -565,20 +565,22 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 	unchar *cmd = (unchar *) SCpnt->cmnd;
 	unchar target = SCpnt->device->id;
 	unchar lun = SCpnt->device->lun;
-	unsigned long flags;
+	unsigned long flags, hflags;
 	int bufflen = scsi_bufflen(SCpnt);
 	int mbo;
 	struct mailbox *mb;
 	struct ccb *ccb;
-
 	DEB(int i);
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, hflags);
+
 	mb = HOSTDATA(SCpnt->device->host)->mb;
 	ccb = HOSTDATA(SCpnt->device->host)->ccb;
 
 	DEB(if (target > 1) {
 	    SCpnt->result = DID_TIME_OUT << 16;
-	    done(SCpnt); return 0;
+	    done(SCpnt); spin_unlock_irqrestore(SCpnt->device->host->host_lock,
+		hflags); return 0;
 	    }
 	);
 
@@ -593,6 +595,7 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 #endif
 		SCpnt->result = 0;
 		done(SCpnt);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 		return 0;
 	}
 #ifdef DEBUG
@@ -611,8 +614,10 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 	for (i = 0; i < SCpnt->cmd_len; i++)
 		printk("%02x ", cmd[i]);
 	printk("\n");
-	if (*cmd == WRITE_10 || *cmd == WRITE_6)
+	if (*cmd == WRITE_10 || *cmd == WRITE_6) {
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 		return 0;	/* we are still testing, so *don't* write */
+	}
 #endif
 	/* Use the outgoing mailboxes in a round-robin fashion, because this
 	   is how the host adapter will scan for them */
@@ -671,6 +676,8 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 		if (cptr == NULL) {
 			/* free the claimed mailbox slot */
 			HOSTDATA(SCpnt->device->host)->SCint[mbo] = NULL;
+			spin_unlock_irqrestore(SCpnt->device->host->host_lock,
+						hflags);
 			return SCSI_MLQUEUE_HOST_BUSY;
 		}
 		scsi_for_each_sg(SCpnt, sg, sg_count, i) {
@@ -715,6 +722,7 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 	} else
 		printk("aha1542_queuecommand: done can't be NULL\n");
 
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 0107a4c..e4b8ab5 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -337,15 +337,17 @@ static int aha1740_queuecommand(Scsi_Cmnd * SCpnt, void (*done)(Scsi_Cmnd *))
 	unchar *cmd = (unchar *) SCpnt->cmnd;
 	unchar target = scmd_id(SCpnt);
 	struct aha1740_hostdata *host = HOSTDATA(SCpnt->device->host);
-	unsigned long flags;
+	unsigned long flags, hflags
 	dma_addr_t sg_dma;
 	struct aha1740_sg *sgptr;
 	int ecbno, nseg;
 	DEB(int i);
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, hflags);
 	if(*cmd == REQUEST_SENSE) {
 		SCpnt->result = 0;
 		done(SCpnt); 
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 		return 0;
 	}
 
@@ -406,6 +408,7 @@ static int aha1740_queuecommand(Scsi_Cmnd * SCpnt, void (*done)(Scsi_Cmnd *))
 						   &sg_dma, GFP_ATOMIC);
 	if(SCpnt->host_scribble == NULL) {
 		printk(KERN_WARNING "aha1740: out of memory in queuecommand!\n");
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 		return 1;
 	}
 	sgptr = (struct aha1740_sg *) SCpnt->host_scribble;
@@ -500,6 +503,8 @@ static int aha1740_queuecommand(Scsi_Cmnd * SCpnt, void (*done)(Scsi_Cmnd *))
 		DEB(printk("aha1740[%d] request queued.\n",ecbno));
 	} else
 		printk(KERN_ALERT "aha1740_queuecommand: done can't be NULL\n");
+
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 88ad848..2ee48e3 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -577,14 +577,17 @@ ahd_linux_queue(struct scsi_cmnd * cmd, void (*scsi_done) (struct scsi_cmnd *))
 {
 	struct	 ahd_softc *ahd;
 	struct	 ahd_linux_device *dev = scsi_transport_device_data(cmd->device);
+	unsigned long hflags;
 	int rtn = SCSI_MLQUEUE_HOST_BUSY;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
 	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
 
 	cmd->scsi_done = scsi_done;
 	cmd->result = CAM_REQ_INPROG << 16;
 	rtn = ahd_linux_run_command(ahd, dev, cmd);
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return rtn;
 }
 
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index aeea7a6..5631528 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -533,8 +533,9 @@ ahc_linux_queue(struct scsi_cmnd * cmd, void (*scsi_done) (struct scsi_cmnd *))
 	struct	 ahc_softc *ahc;
 	struct	 ahc_linux_device *dev = scsi_transport_device_data(cmd->device);
 	int rtn = SCSI_MLQUEUE_HOST_BUSY;
-	unsigned long flags;
+	unsigned long flags, hflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
 	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
 
 	ahc_lock(ahc, &flags);
@@ -545,6 +546,7 @@ ahc_linux_queue(struct scsi_cmnd * cmd, void (*scsi_done) (struct scsi_cmnd *))
 	}
 	ahc_unlock(ahc, &flags);
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return rtn;
 }
 
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index aee73fa..8283e19a 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -10239,7 +10239,9 @@ static int aic7xxx_queue(struct scsi_cmnd *cmd, void (*fn)(struct scsi_cmnd *))
   struct aic7xxx_host *p;
   struct aic7xxx_scb *scb;
   struct aic_dev_data *aic_dev;
+  unsigned long hflags;
 
+  spin_lock_irqsave(cmd->device->host->host_lock, hflags);
   p = (struct aic7xxx_host *) cmd->device->host->hostdata;
 
   aic_dev = cmd->device->hostdata;  
@@ -10262,6 +10264,7 @@ static int aic7xxx_queue(struct scsi_cmnd *cmd, void (*fn)(struct scsi_cmnd *))
     {
       printk(WARN_LEAD "Couldn't get a free SCB.\n", p->host_no,
              CTL_OF_CMD(cmd));
+      spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
       return 1;
     }
   }
@@ -10289,6 +10292,7 @@ static int aic7xxx_queue(struct scsi_cmnd *cmd, void (*fn)(struct scsi_cmnd *))
 
   scbq_insert_tail(&p->waiting_scbs, scb);
   aic7xxx_run_waiting_queues(p);
+  spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
   return (0);
 }
 
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 05a78e5..3744697 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2087,9 +2087,12 @@ static int arcmsr_queue_command(struct scsi_cmnd *cmd,
 	struct Scsi_Host *host = cmd->device->host;
 	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
 	struct CommandControlBlock *ccb;
+	unsigned long hflags;
 	int target = cmd->device->id;
 	int lun = cmd->device->lun;
 	uint8_t scsicmd = cmd->cmnd[0];
+
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
 	cmd->scsi_done = done;
 	cmd->host_scribble = NULL;
 	cmd->result = 0;
@@ -2098,29 +2101,38 @@ static int arcmsr_queue_command(struct scsi_cmnd *cmd,
     			cmd->result = (DID_NO_CONNECT << 16);
 		}
 		cmd->scsi_done(cmd);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return 0;
 	}
 	if (target == 16) {
 		/* virtual device for iop message transfer */
 		arcmsr_handle_virtual_command(acb, cmd);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return 0;
 	}
 	if (atomic_read(&acb->ccboutstandingcount) >=
-			ARCMSR_MAX_OUTSTANDING_CMD)
+			ARCMSR_MAX_OUTSTANDING_CMD) {
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 	if ((scsicmd == SCSI_CMD_ARECA_SPECIFIC)) {
 		printk(KERN_NOTICE "Receiveing SCSI_CMD_ARECA_SPECIFIC command..\n");
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return 0;
 	}
 	ccb = arcmsr_get_freeccb(acb);
-	if (!ccb)
+	if (!ccb) {
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 	if (arcmsr_build_ccb( acb, ccb, cmd ) == FAILED) {
 		cmd->result = (DID_ERROR << 16) | (RESERVATION_CONFLICT << 1);
 		cmd->scsi_done(cmd);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return 0;
 	}
 	arcmsr_post_ccb(acb, ccb);
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 918ccf8..a646f08 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -2514,12 +2514,16 @@ acornscsi_intr(int irq, void *dev_id)
 int acornscsi_queuecmd(struct scsi_cmnd *SCpnt,
 		       void (*done)(struct scsi_cmnd *))
 {
+    unsigned long hflags;
+
+    spin_lock_irqsave(SCpnt->device->host->host_lock, hflags);
     AS_Host *host = (AS_Host *)SCpnt->device->host->hostdata;
 
     if (!done) {
 	/* there should be some way of rejecting errors like this without panicing... */
 	panic("scsi%d: queuecommand called with NULL done function [cmd=%p]",
 		host->host->host_no, SCpnt);
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 	return -EINVAL;
     }
 
@@ -2529,6 +2533,7 @@ int acornscsi_queuecmd(struct scsi_cmnd *SCpnt,
 	    host->host->host_no, '0' + SCpnt->device->id);
 	SCpnt->result = DID_NO_CONNECT << 16;
 	done(SCpnt);
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 	return 0;
     }
 #endif
@@ -2551,6 +2556,7 @@ int acornscsi_queuecmd(struct scsi_cmnd *SCpnt,
 	if (!queue_add_cmd_ordered(&host->queues.issue, SCpnt)) {
 	    SCpnt->result = DID_ERROR << 16;
 	    done(SCpnt);
+	    spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 	    return 0;
 	}
 	local_irq_save(flags);
@@ -2558,6 +2564,7 @@ int acornscsi_queuecmd(struct scsi_cmnd *SCpnt,
 	    acornscsi_kick(host);
 	local_irq_restore(flags);
     }
+    spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
     return 0;
 }
 
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 9e71ac6..a3ec258 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2266,6 +2266,9 @@ static void fas216_internal_done(struct scsi_cmnd *SCpnt)
 int fas216_noqueue_command(struct scsi_cmnd *SCpnt,
 			   void (*done)(struct scsi_cmnd *))
 {
+	unsigned long hflags;
+
+	spin_lock_irqsave(SCpnt->device->host->host_lock, hflags);
 	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
 
 	fas216_checkmagic(info);
@@ -2285,7 +2288,7 @@ int fas216_noqueue_command(struct scsi_cmnd *SCpnt,
 	 * However, we must re-enable interrupts, or else we'll be
 	 * waiting forever.
 	 */
-	spin_unlock_irq(info->host->host_lock);
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 
 	while (!info->internal_done) {
 		/*
@@ -2303,8 +2306,6 @@ int fas216_noqueue_command(struct scsi_cmnd *SCpnt,
 		}
 	}
 
-	spin_lock_irq(info->host->host_lock);
-
 	done(SCpnt);
 
 	return 0;
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index ab5bdda..03e609b 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -608,11 +608,14 @@ handled:
 static int atp870u_queuecommand(struct scsi_cmnd * req_p, 
 			 void (*done) (struct scsi_cmnd *))
 {
+	unsigned long hflags;
 	unsigned char c;
 	unsigned int tmport,m;	
 	struct atp_unit *dev;
 	struct Scsi_Host *host;
 
+	spin_lock_irqsave(req_p->device->host->host_lock, hflags);
+
 	c = scmd_channel(req_p);
 	req_p->sense_buffer[0]=0;
 	scsi_set_resid(req_p, 0);
@@ -622,6 +625,7 @@ static int atp870u_queuecommand(struct scsi_cmnd * req_p,
 #ifdef ED_DBGP		
 		printk("atp870u_queuecommand : req_p->device->channel > 1\n");	
 #endif			
+		spin_unlock_irqrestore(req_p->device->host->host_lock, hflags);
 		return 0;
 	}
 
@@ -640,6 +644,7 @@ static int atp870u_queuecommand(struct scsi_cmnd * req_p,
 	if ((m & dev->active_id[c]) == 0) {
 		req_p->result = 0x00040000;
 		done(req_p);
+		spin_unlock_irqrestore(req_p->device->host->host_lock, hflags);
 		return 0;
 	}
 
@@ -651,6 +656,7 @@ static int atp870u_queuecommand(struct scsi_cmnd * req_p,
 #endif		
 		req_p->result = 0;
 		done(req_p);
+		spin_unlock_irqrestore(req_p->device->host->host_lock, hflags);
 		return 0;
 	}
 	
@@ -675,6 +681,7 @@ static int atp870u_queuecommand(struct scsi_cmnd * req_p,
 		dev->quend[c]--;
 		req_p->result = 0x00020000;
 		done(req_p);	
+		spin_unlock_irqrestore(req_p->device->host->host_lock, hflags);
 		return 0;
 	}
 	dev->quereq[c][dev->quend[c]] = req_p;
@@ -691,6 +698,8 @@ static int atp870u_queuecommand(struct scsi_cmnd * req_p,
 #ifdef ED_DBGP	
 	printk("atp870u_queuecommand : exit\n");
 #endif	
+
+	spin_unlock_irqrestore(req_p->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index d950ee4..710a5fa 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -1127,22 +1127,26 @@ bfad_im_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 	struct bfad_itnim_data_s *itnim_data = cmnd->device->hostdata;
 	struct bfad_itnim_s   *itnim;
 	struct bfa_ioim_s *hal_io;
-	unsigned long   flags;
+	unsigned long   flags, hflags;
 	int             rc;
 	int       sg_cnt = 0;
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 
+	spin_lock_irqsave(cmnd->device->host->host_lock, hflags);
+
 	rc = fc_remote_port_chkready(rport);
 	if (rc) {
 		cmnd->result = rc;
 		done(cmnd);
+		spin_unlock_irqrestore(cmnd->device->host->host_lock, hflags);
 		return 0;
 	}
 
 	sg_cnt = scsi_dma_map(cmnd);
-	if (sg_cnt < 0)
+	if (sg_cnt < 0) {
+		spin_unlock_irqrestore(cmnd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
-
+	}
 	cmnd->scsi_done = done;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
@@ -1167,6 +1171,7 @@ bfad_im_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 		printk(KERN_WARNING "hal_io failure\n");
 		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 		scsi_dma_unmap(cmnd);
+		spin_unlock_irqrestore(cmnd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -1175,6 +1180,7 @@ bfad_im_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 	bfa_ioim_start(hal_io);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
+	spin_unlock_irqrestore(cmnd->device->host->host_lock, hflags);
 	return 0;
 
 out_fail_cmd:
@@ -1183,6 +1189,7 @@ out_fail_cmd:
 	if (done)
 		done(cmnd);
 
+	spin_unlock_irqrestore(cmnd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 54f50b0..28996b4 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1086,6 +1086,10 @@ static int dc395x_queue_command(struct scsi_cmnd *cmd, void (*done)(struct scsi_
 	struct ScsiReqBlk *srb;
 	struct AdapterCtlBlk *acb =
 	    (struct AdapterCtlBlk *)cmd->device->host->hostdata;
+	unsigned long hflags;
+
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
+
 	dprintkdbg(DBG_0, "queue_command: (pid#%li) <%02i-%i> cmnd=0x%02x\n",
 		cmd->serial_number, cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 
@@ -1127,6 +1131,7 @@ static int dc395x_queue_command(struct scsi_cmnd *cmd, void (*done)(struct scsi_
 		 * point in time.
 		 */
 		dprintkdbg(DBG_0, "queue_command: No free srb's\n");
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return 1;
 	}
 
@@ -1141,6 +1146,8 @@ static int dc395x_queue_command(struct scsi_cmnd *cmd, void (*done)(struct scsi_
 		send_srb(acb, srb);
 	}
 	dprintkdbg(DBG_1, "queue_command: (pid#%li) done\n", cmd->serial_number);
+
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return 0;
 
 complete:
@@ -1151,6 +1158,7 @@ complete:
 	 * devices.
 	 */
 	done(cmd);
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 23dec00..75ceb07 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -427,6 +427,10 @@ static int adpt_queue(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
 {
 	adpt_hba* pHba = NULL;
 	struct adpt_device* pDev = NULL;	/* dpt per device information */
+	unsigned long hflags;
+	int rc;
+
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
 
 	cmd->scsi_done = done;
 	/*
@@ -439,11 +443,13 @@ static int adpt_queue(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
 	if ((cmd->cmnd[0] == REQUEST_SENSE) && (cmd->sense_buffer[0] != 0)) {
 		cmd->result = (DID_OK << 16);
 		cmd->scsi_done(cmd);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return 0;
 	}
 
 	pHba = (adpt_hba*)cmd->device->host->hostdata[0];
 	if (!pHba) {
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return FAILED;
 	}
 
@@ -459,6 +465,7 @@ static int adpt_queue(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
 	if(((pHba->state) & DPTI_STATE_IOCTL) || ((pHba->state) & DPTI_STATE_RESET)) {
 		pHba->host->last_reset = jiffies;
 		pHba->host->resetting = 1;
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return 1;
 	}
 
@@ -475,6 +482,7 @@ static int adpt_queue(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
 			// with type 7F (for all luns less than the max for this bus,id) so the lun scan will continue.
 			cmd->result = (DID_NO_CONNECT << 16);
 			cmd->scsi_done(cmd);
+			spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 			return 0;
 		}
 		cmd->device->hostdata = pDev;
@@ -486,9 +494,13 @@ static int adpt_queue(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
 	 * delay processing of the command until later.
 	 */
 	if (pDev->state & DPTI_DEV_RESET ) {
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return FAILED;
 	}
-	return adpt_scsi_to_i2o(pHba, cmd, pDev);
+
+	rc = adpt_scsi_to_i2o(pHba, cmd, pDev);
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
+	return rc;
 }
 
 static int adpt_bios_param(struct scsi_device *sdev, struct block_device *dev,
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index d1c3137..28a749a 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1763,9 +1763,12 @@ static int eata2x_queuecommand(struct scsi_cmnd *SCpnt,
 {
 	struct Scsi_Host *shost = SCpnt->device->host;
 	struct hostdata *ha = (struct hostdata *)shost->hostdata;
+	unsigned long hflags;
 	unsigned int i, k;
 	struct mscp *cpp;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, hflags);
+
 	if (SCpnt->host_scribble)
 		panic("%s: qcomm, pid %ld, SCpnt %p already active.\n",
 		      ha->board_name, SCpnt->serial_number, SCpnt);
@@ -1785,6 +1788,7 @@ static int eata2x_queuecommand(struct scsi_cmnd *SCpnt,
 
 	if (k == shost->can_queue) {
 		printk("%s: qcomm, no free mailbox.\n", ha->board_name);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 		return 1;
 	}
 
@@ -1827,6 +1831,7 @@ static int eata2x_queuecommand(struct scsi_cmnd *SCpnt,
 	    && TLDEV(SCpnt->device->type)) {
 		ha->cp_stat[i] = READY;
 		flush_dev(SCpnt->device, blk_rq_pos(SCpnt->request), ha, 0);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 		return 0;
 	}
 
@@ -1836,10 +1841,13 @@ static int eata2x_queuecommand(struct scsi_cmnd *SCpnt,
 		SCpnt->host_scribble = NULL;
 		scmd_printk(KERN_INFO, SCpnt,
 			"qcomm, pid %ld, adapter busy.\n", SCpnt->serial_number);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 		return 1;
 	}
 
 	ha->cp_stat[i] = IN_USE;
+
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index 60886c1..78ba1d1 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -339,12 +339,14 @@ static int eata_pio_queue(struct scsi_cmnd *cmd,
 		void (*done)(struct scsi_cmnd *))
 {
 	unsigned int x, y;
-	unsigned long base;
+	unsigned long base, hflags;
 
 	hostdata *hd;
 	struct Scsi_Host *sh;
 	struct eata_ccb *cp;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
+
 	queue_counter++;
 
 	hd = HD(cmd);
@@ -421,6 +423,7 @@ static int eata_pio_queue(struct scsi_cmnd *cmd,
 			"returning DID_BUS_BUSY, done.\n", cmd->serial_number);
 		done(cmd);
 		cp->status = FREE;
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return 0;
 	}
 	/* FIXME: timeout */
@@ -435,6 +438,7 @@ static int eata_pio_queue(struct scsi_cmnd *cmd,
 		"Queued base %#.4lx pid: %ld "
 		"slot %d irq %d\n", sh->base, cmd->serial_number, y, sh->irq));
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index e2bc779..45d4e99 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -922,11 +922,15 @@ static int esp_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd
 	struct esp *esp = shost_priv(dev->host);
 	struct esp_cmd_priv *spriv;
 	struct esp_cmd_entry *ent;
+	unsigned long hflags;
+
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
 
 	ent = esp_get_ent(esp);
-	if (!ent)
+	if (!ent) {
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
-
+	}
 	ent->cmd = cmd;
 
 	cmd->scsi_done = done;
@@ -938,6 +942,7 @@ static int esp_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd
 
 	esp_maybe_execute_command(esp);
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/fd_mcs.c b/drivers/scsi/fd_mcs.c
index 2ad95aa..7c0b5d6 100644
--- a/drivers/scsi/fd_mcs.c
+++ b/drivers/scsi/fd_mcs.c
@@ -1075,6 +1075,9 @@ static int fd_mcs_release(struct Scsi_Host *shpnt)
 static int fd_mcs_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
+	unsigned long hflags;
+
+	spin_lock_irqsave(SCpnt->device->host->host_lock, hflags);
 
 	if (in_command) {
 		panic("fd_mcs: fd_mcs_queue() NOT REENTRANT!\n");
@@ -1119,6 +1122,7 @@ static int fd_mcs_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 	outb(0x20, Interrupt_Cntl_port);
 	outb(0x14 | PARITY_MASK, TMC_Cntl_port);	/* Start arbitration */
 
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index e296bcc..cdbc36e 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -1422,6 +1422,10 @@ static irqreturn_t do_fdomain_16x0_intr(int irq, void *dev_id)
 static int fdomain_16x0_queue(struct scsi_cmnd *SCpnt,
 		void (*done)(struct scsi_cmnd *))
 {
+   unsigned long hflags;
+
+   spin_lock_irqsave(SCpnt->device->host->host_lock, hflags);
+  
    if (in_command) {
       panic( "scsi: <fdomain> fdomain_16x0_queue() NOT REENTRANT!\n" );
    }
@@ -1466,6 +1470,7 @@ static int fdomain_16x0_queue(struct scsi_cmnd *SCpnt,
    outb(0x20, port_base + Interrupt_Cntl);
    outb(0x14 | PARITY_MASK, port_base + TMC_Cntl); /* Start arbitration */
 
+   spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
    return 0;
 }
 
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 198cbab..7cf3372 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -373,13 +373,6 @@ int fnic_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 	if (lp->state != LPORT_ST_READY || !(lp->link_up))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-	/*
-	 * Release host lock, use driver resource specific locks from here.
-	 * Don't re-enable interrupts in case they were disabled prior to the
-	 * caller disabling them.
-	 */
-	spin_unlock(lp->host->host_lock);
-
 	/* Get a new io_req for this SCSI IO */
 	fnic = lport_priv(lp);
 
@@ -452,8 +445,6 @@ int fnic_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		}
 	}
 out:
-	/* acquire host lock before returning to SCSI */
-	spin_lock(lp->host->host_lock);
 	return ret;
 }
 
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 5a3f931..0843095 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4009,6 +4009,10 @@ static int gdth_queuecommand(struct scsi_cmnd *scp,
 {
     gdth_ha_str *ha = shost_priv(scp->device->host);
     struct gdth_cmndinfo *cmndinfo;
+    unsigned long hflags;
+    int rc;
+
+    spin_lock_irqsave(scp->device->host->host_lock, hflags);
 
     TRACE(("gdth_queuecommand() cmd 0x%x\n", scp->cmnd[0]));
 
@@ -4019,7 +4023,9 @@ static int gdth_queuecommand(struct scsi_cmnd *scp,
     cmndinfo->timeout_count = 0;
     cmndinfo->priority = DEFAULT_PRI;
 
-    return __gdth_queuecommand(ha, scp, cmndinfo);
+    rc = __gdth_queuecommand(ha, scp, cmndinfo);
+    spin_unlock_irqrestore(scp->device->host->host_lock, hflags);
+    return rc;
 }
 
 static int __gdth_queuecommand(gdth_ha_str *ha, struct scsi_cmnd *scp,
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 4f7a582..8c1760d 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -381,6 +381,10 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
+	/*
+	 * Set the default shost->cmd_serial_number to 1.
+	 */
+	atomic_set(&shost->cmd_serial_number, 1);
 
 	if (sht->supported_mode == MODE_UNKNOWN)
 		/* means we didn't set it ... default to INITIATOR */
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c5d0606..8707f5a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1933,7 +1933,9 @@ static int hpsa_scsi_queue_command(struct scsi_cmnd *cmd,
 	struct hpsa_scsi_dev_t *dev;
 	unsigned char scsi3addr[8];
 	struct CommandList *c;
-	unsigned long flags;
+	unsigned long flags, hflags;
+
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
 
 	/* Get the ptr to our adapter structure out of cmd->host. */
 	h = sdev_to_hba(cmd->device);
@@ -1941,6 +1943,7 @@ static int hpsa_scsi_queue_command(struct scsi_cmnd *cmd,
 	if (!dev) {
 		cmd->result = DID_NO_CONNECT << 16;
 		done(cmd);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return 0;
 	}
 	memcpy(scsi3addr, dev->scsi3addr, sizeof(scsi3addr));
@@ -1951,6 +1954,7 @@ static int hpsa_scsi_queue_command(struct scsi_cmnd *cmd,
 	spin_unlock_irqrestore(&h->lock, flags);
 	if (c == NULL) {			/* trouble... */
 		dev_err(&h->pdev->dev, "cmd_alloc returned NULL!\n");
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -2013,10 +2017,13 @@ static int hpsa_scsi_queue_command(struct scsi_cmnd *cmd,
 
 	if (hpsa_scatter_gather(h, c, cmd) < 0) { /* Fill SG list */
 		cmd_free(h, c);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 	enqueue_cmd_and_start_io(h, c);
 	/* the cmd'll come back via intr handler in complete_scsi_command()  */
+
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 0729f15..3ff97df 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -757,15 +757,19 @@ static int hptiop_queuecommand(struct scsi_cmnd *scp,
 	struct Scsi_Host *host = scp->device->host;
 	struct hptiop_hba *hba = (struct hptiop_hba *)host->hostdata;
 	struct hpt_iop_request_scsi_command *req;
+	unsigned long hflags;
 	int sg_count = 0;
 	struct hptiop_request *_req;
 
+	spin_lock_irqsave(scp->device->host->host_lock, hflags);
+
 	BUG_ON(!done);
 	scp->scsi_done = done;
 
 	_req = get_req(hba);
 	if (_req == NULL) {
 		dprintk("hptiop_queuecmd : no free req\n");
+		spin_unlock_irqrestore(scp->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -811,11 +815,14 @@ static int hptiop_queuecommand(struct scsi_cmnd *scp,
 
 	memcpy(req->cdb, scp->cmnd, sizeof(req->cdb));
 	hba->ops->post_req(hba, _req);
+
+	spin_unlock_irqrestore(scp->device->host->host_lock, hflags);
 	return 0;
 
 cmd_done:
 	dprintk("scsi_done(scp=%p)\n", scp);
 	scp->scsi_done(scp);
+	spin_unlock_irqrestore(scp->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 9a4b69d..b77e11f 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -1697,6 +1697,7 @@ static int ibmmca_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 	unsigned int scsi_cmd;
 	struct im_scb *scb;
 	struct Scsi_Host *shpnt;
+	unsigned long hflags;
 	int current_ldn;
 	int id, lun;
 	int target;
@@ -1704,6 +1705,8 @@ static int ibmmca_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 	int i;
 	struct scatterlist *sg;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
+
 	shpnt = cmd->device->host;
 
 	max_pun = subsystem_maxid(shpnt);
@@ -1721,6 +1724,8 @@ static int ibmmca_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 		cmd->result = DID_NO_CONNECT << 16;
 		if (done)
 			done(cmd);
+
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return 0;
 	}
 
@@ -1743,6 +1748,9 @@ static int ibmmca_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 					cmd->result = DID_NO_CONNECT << 16;	/* return no connect */
 					if (done)
 						done(cmd);
+
+					spin_unlock_irqrestore(cmd->device->host->host_lock,
+								hflags);
 					return 0;
 				}
 			}
@@ -1804,6 +1812,9 @@ static int ibmmca_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 			cmd->result = DID_BAD_TARGET << 16;
 			if (done)
 				done(cmd);
+
+			spin_unlock_irqrestore(cmd->device->host->host_lock,
+						hflags);
 			return 0;
 		}
 	}
@@ -1993,6 +2004,8 @@ static int ibmmca_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 		issue_cmd(shpnt, isa_virt_to_bus(scb), IM_SCB | ldn);
 		IBM_DS(shpnt).scbs++;
 	}
+
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 00d08b2..d3fc01e 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1613,13 +1613,17 @@ static int ibmvfc_queuecommand(struct scsi_cmnd *cmnd,
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	struct ibmvfc_cmd *vfc_cmd;
 	struct ibmvfc_event *evt;
+	unsigned long hflags;
 	u8 tag[2];
 	int rc;
 
+	spin_lock_irqsave(cmnd->device->host->host_lock, hflags);
+
 	if (unlikely((rc = fc_remote_port_chkready(rport))) ||
 	    unlikely((rc = ibmvfc_host_chkready(vhost)))) {
 		cmnd->result = rc;
 		done(cmnd);
+		spin_unlock_irqrestore(cmnd->device->host->host_lock, hflags);
 		return 0;
 	}
 
@@ -1656,12 +1660,17 @@ static int ibmvfc_queuecommand(struct scsi_cmnd *cmnd,
 		};
 	}
 
-	if (likely(!(rc = ibmvfc_map_sg_data(cmnd, evt, vfc_cmd, vhost->dev))))
-		return ibmvfc_send_event(evt, vhost, 0);
+	if (likely(!(rc = ibmvfc_map_sg_data(cmnd, evt, vfc_cmd, vhost->dev)))) {
+		rc = ibmvfc_send_event(evt, vhost, 0);
+		spin_unlock_irqrestore(cmnd->device->host->host_lock, hflags);
+		return rc;
+	}
 
 	ibmvfc_free_event(evt);
-	if (rc == -ENOMEM)
+	if (rc == -ENOMEM) {
+		spin_unlock_irqrestore(cmnd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	if (vhost->log_level > IBMVFC_DEFAULT_LOG_LEVEL)
 		scmd_printk(KERN_ERR, cmnd,
@@ -1669,6 +1678,8 @@ static int ibmvfc_queuecommand(struct scsi_cmnd *cmnd,
 
 	cmnd->result = DID_ERROR << 16;
 	done(cmnd);
+
+	spin_unlock_irqrestore(cmnd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 67f78a4..2ada98b 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -720,14 +720,19 @@ static int ibmvscsi_queuecommand(struct scsi_cmnd *cmnd,
 	struct srp_event_struct *evt_struct;
 	struct srp_indirect_buf *indirect;
 	struct ibmvscsi_host_data *hostdata = shost_priv(cmnd->device->host);
+	unsigned long hflags;
+	int rc;
 	u16 lun = lun_from_dev(cmnd->device);
 	u8 out_fmt, in_fmt;
 
+	spin_lock_irqsave(cmnd->device->host->host_lock, hflags);
+	
 	cmnd->result = (DID_OK << 16);
 	evt_struct = get_event_struct(&hostdata->pool);
-	if (!evt_struct)
+	if (!evt_struct) {
+		spin_unlock_irqrestore(cmnd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
-
+	}
 	/* Set up the actual SRP IU */
 	srp_cmd = &evt_struct->iu.srp.cmd;
 	memset(srp_cmd, 0x00, SRP_MAX_IU_LEN);
@@ -740,6 +745,7 @@ static int ibmvscsi_queuecommand(struct scsi_cmnd *cmnd,
 			sdev_printk(KERN_ERR, cmnd->device,
 			            "couldn't convert cmd to srp_cmd\n");
 		free_event_struct(&hostdata->pool, evt_struct);
+		spin_unlock_irqrestore(cmnd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -763,7 +769,10 @@ static int ibmvscsi_queuecommand(struct scsi_cmnd *cmnd,
 			offsetof(struct srp_indirect_buf, desc_list);
 	}
 
-	return ibmvscsi_send_srp_event(evt_struct, hostdata, 0);
+	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, 0);
+
+	spin_unlock_irqrestore(cmnd->device->host->host_lock, hflags);
+	return rc;
 }
 
 /* ------------------------------------------------------------
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 4734ab0..451f9da 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -930,9 +930,13 @@ static int imm_queuecommand(struct scsi_cmnd *cmd,
 		void (*done)(struct scsi_cmnd *))
 {
 	imm_struct *dev = imm_dev(cmd->device->host);
+	unsigned long hflags;
+
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
 
 	if (dev->cur_cmd) {
 		printk("IMM: bug in imm_queuecommand\n");
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return 0;
 	}
 	dev->failed = 0;
@@ -946,6 +950,7 @@ static int imm_queuecommand(struct scsi_cmnd *cmd,
 
 	imm_pb_claim(dev);
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index 52bdc6d..cb588e8 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -339,6 +339,9 @@ static int in2000_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 	struct Scsi_Host *instance;
 	struct IN2000_hostdata *hostdata;
 	Scsi_Cmnd *tmp;
+	unsigned long hflags;
+
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
 
 	instance = cmd->device->host;
 	hostdata = (struct IN2000_hostdata *) instance->hostdata;
@@ -428,7 +431,9 @@ static int in2000_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 	in2000_execute(cmd->device->host);
 
 	DB(DB_QUEUE_COMMAND, printk(")Q-%ld ", cmd->serial_number))
-	    return 0;
+
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
+	return 0;
 }
 
 
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 1087977..3d0e784 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2644,15 +2644,22 @@ static int i91u_queuecommand(struct scsi_cmnd *cmd,
 {
 	struct initio_host *host = (struct initio_host *) cmd->device->host->hostdata;
 	struct scsi_ctrl_blk *cmnd;
+	unsigned long hflags;
+
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
 
 	cmd->scsi_done = done;
 
 	cmnd = initio_alloc_scb(host);
-	if (!cmnd)
+	if (!cmnd) {
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	initio_build_scb(host, cmnd, cmd);
 	initio_exec_scb(host, cmnd);
+
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index df9a12c..a1bc068 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5716,8 +5716,11 @@ static int ipr_queuecommand(struct scsi_cmnd *scsi_cmd,
 	struct ipr_resource_entry *res;
 	struct ipr_ioarcb *ioarcb;
 	struct ipr_cmnd *ipr_cmd;
+	unsigned long hflags;
 	int rc = 0;
 
+	spin_lock_irqsave(scsi_cmd->device->host->host_lock, hflags);
+
 	scsi_cmd->scsi_done = done;
 	ioa_cfg = (struct ipr_ioa_cfg *)scsi_cmd->device->host->hostdata;
 	res = scsi_cmd->device->hostdata;
@@ -5728,9 +5731,11 @@ static int ipr_queuecommand(struct scsi_cmnd *scsi_cmd,
 	 * We have told the host to stop giving us new requests, but
 	 * ERP ops don't count. FIXME
 	 */
-	if (unlikely(!ioa_cfg->allow_cmds && !ioa_cfg->ioa_is_dead))
+	if (unlikely(!ioa_cfg->allow_cmds && !ioa_cfg->ioa_is_dead)) {
+		spin_unlock_irqrestore(scsi_cmd->device->host->host_lock,
+					hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
-
+	}
 	/*
 	 * FIXME - Create scsi_set_host_offline interface
 	 *  and the ioa_is_dead check can be removed
@@ -5739,12 +5744,17 @@ static int ipr_queuecommand(struct scsi_cmnd *scsi_cmd,
 		memset(scsi_cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 		scsi_cmd->result = (DID_NO_CONNECT << 16);
 		scsi_cmd->scsi_done(scsi_cmd);
+		spin_unlock_irqrestore(scsi_cmd->device->host->host_lock,
+					hflags);
 		return 0;
 	}
 
-	if (ipr_is_gata(res) && res->sata_port)
-		return ata_sas_queuecmd(scsi_cmd, done, res->sata_port->ap);
-
+	if (ipr_is_gata(res) && res->sata_port) {
+		rc = ata_sas_queuecmd(scsi_cmd, done, res->sata_port->ap);
+		spin_unlock_irqrestore(scsi_cmd->device->host->host_lock,
+					hflags);
+		return rc;
+	}
 	ipr_cmd = ipr_get_free_ipr_cmnd(ioa_cfg);
 	ioarcb = &ipr_cmd->ioarcb;
 	list_add_tail(&ipr_cmd->queue, &ioa_cfg->pending_q);
@@ -5786,9 +5796,12 @@ static int ipr_queuecommand(struct scsi_cmnd *scsi_cmd,
 		ipr_send_command(ipr_cmd);
 	} else {
 		 list_move_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
+		 spin_unlock_irqrestore(scsi_cmd->device->host->host_lock,
+					hflags);
 		 return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
+	spin_unlock_irqrestore(scsi_cmd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index f83a116..70a0d09 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -1050,28 +1050,36 @@ static int ips_queue(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *))
 {
 	ips_ha_t *ha;
 	ips_passthru_t *pt;
+	unsigned long hflags;
+
+	spin_lock_irqsave(SC->device->host->host_lock, hflags);
 
 	METHOD_TRACE("ips_queue", 1);
 
 	ha = (ips_ha_t *) SC->device->host->hostdata;
 
-	if (!ha)
+	if (!ha) {
+		spin_unlock_irqrestore(SC->device->host->host_lock, hflags);
 		return (1);
+	}
 
-	if (!ha->active)
+	if (!ha->active) {
+		spin_unlock_irqrestore(SC->device->host->host_lock, hflags);
 		return (DID_ERROR);
+	}
 
 	if (ips_is_passthru(SC)) {
 		if (ha->copp_waitlist.count == IPS_MAX_IOCTL_QUEUE) {
 			SC->result = DID_BUS_BUSY << 16;
 			done(SC);
-
+			spin_unlock_irqrestore(SC->device->host->host_lock,
+						hflags);
 			return (0);
 		}
 	} else if (ha->scb_waitlist.count == IPS_MAX_QUEUE) {
 		SC->result = DID_BUS_BUSY << 16;
 		done(SC);
-
+		spin_unlock_irqrestore(SC->device->host->host_lock, hflags);
 		return (0);
 	}
 
@@ -1088,7 +1096,7 @@ static int ips_queue(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *))
 	    && (scmd_id(SC) == ha->ha_id[scmd_channel(SC)])) {
 		SC->result = DID_NO_CONNECT << 16;
 		done(SC);
-
+		spin_unlock_irqrestore(SC->device->host->host_lock, hflags);
 		return (0);
 	}
 
@@ -1105,12 +1113,16 @@ static int ips_queue(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *))
 			if (ha->scb_activelist.count != 0) {
 				SC->result = DID_BUS_BUSY << 16;
 				done(SC);
+				spin_unlock_irqrestore(SC->device->host->host_lock,
+							hflags);
 				return (0);
 			}
 			ha->ioctl_reset = 1;	/* This reset request is from an IOCTL */
 			__ips_eh_reset(SC);
 			SC->result = DID_OK << 16;
 			SC->scsi_done(SC);
+			spin_unlock_irqrestore(SC->device->host->host_lock,
+						hflags);
 			return (0);
 		}
 
@@ -1120,7 +1132,8 @@ static int ips_queue(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *))
 		if (!scratch) {
 			SC->result = DID_ERROR << 16;
 			done(SC);
-
+			spin_unlock_irqrestore(SC->device->host->host_lock,
+						hflags);
 			return (0);
 		}
 
@@ -1134,6 +1147,7 @@ static int ips_queue(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *))
 
 	ips_next(ha, IPS_INTR_IORL);
 
+	spin_unlock_irqrestore(SC->device->host->host_lock, hflags);
 	return (0);
 }
 
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index c797f6b..959b856 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1760,19 +1760,23 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
 	struct fc_fcp_pkt *fsp;
 	struct fc_rport_libfc_priv *rpriv;
+	unsigned long hflags;
 	int rval;
 	int rc = 0;
 	struct fcoe_dev_stats *stats;
 
+	spin_lock_irqsave(sc_cmd->device->host->host_lock, hflags);
+
 	lport = shost_priv(sc_cmd->device->host);
 
 	rval = fc_remote_port_chkready(rport);
 	if (rval) {
 		sc_cmd->result = rval;
 		done(sc_cmd);
+		spin_unlock_irqrestore(sc_cmd->device->host->host_lock, hflags);
 		return 0;
 	}
-	spin_unlock_irq(lport->host->host_lock);
+	spin_unlock_irqrestore(sc_cmd->device->host->host_lock, hflags);
 
 	if (!*(struct fc_remote_port **)rport->dd_data) {
 		/*
@@ -1849,7 +1853,6 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 	}
 out:
-	spin_lock_irq(lport->host->host_lock);
 	return rc;
 }
 EXPORT_SYMBOL(fc_queuecommand);
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 633e090..7e4134e 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1615,7 +1615,6 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 
 	host = sc->device->host;
 	ihost = shost_priv(host);
-	spin_unlock(host->host_lock);
 
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
@@ -1706,7 +1705,6 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 
 	session->queued_cmdsn++;
 	spin_unlock(&session->lock);
-	spin_lock(host->host_lock);
 	return 0;
 
 prepd_reject:
@@ -1716,7 +1714,6 @@ reject:
 	spin_unlock(&session->lock);
 	ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
 			  sc->cmnd[0], reason);
-	spin_lock(host->host_lock);
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
 prepd_fault:
@@ -1733,7 +1730,6 @@ fault:
 		scsi_in(sc)->resid = scsi_in(sc)->length;
 	}
 	done(sc);
-	spin_lock(host->host_lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iscsi_queuecommand);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 55f09e9..cc12cd7 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -191,18 +191,14 @@ int sas_queue_up(struct sas_task *task)
  */
 int sas_queuecommand(struct scsi_cmnd *cmd,
 		     void (*scsi_done)(struct scsi_cmnd *))
-	__releases(host->host_lock)
 	__acquires(dev->sata_dev.ap->lock)
 	__releases(dev->sata_dev.ap->lock)
-	__acquires(host->host_lock)
 {
 	int res = 0;
 	struct domain_device *dev = cmd_to_domain_dev(cmd);
 	struct Scsi_Host *host = cmd->device->host;
 	struct sas_internal *i = to_sas_internal(host->transportt);
 
-	spin_unlock_irq(host->host_lock);
-
 	{
 		struct sas_ha_struct *sas_ha = dev->port->ha;
 		struct sas_task *task;
@@ -250,7 +246,6 @@ int sas_queuecommand(struct scsi_cmnd *cmd,
 		}
 	}
 out:
-	spin_lock_irq(host->host_lock);
 	return res;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 3a65895..5a9e0d7 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3034,11 +3034,9 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
 		goto out_host_busy_free_buf;
 	}
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
-		spin_unlock(shost->host_lock);
 		lpfc_sli_handle_fast_ring_event(phba,
 			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
 
-		spin_lock(shost->host_lock);
 		if (phba->cfg_poll & DISABLE_FCP_RING_INT)
 			lpfc_poll_rearm_timer(phba);
 	}
diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index 3ddb4dc..29cee24 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -69,7 +69,9 @@ static void set_dma_cmds(struct fsc_state *, struct scsi_cmnd *);
 static int mac53c94_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
 	struct fsc_state *state;
+	unsigned long hflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
 #if 0
 	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
 		int i;
@@ -96,6 +98,7 @@ static int mac53c94_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *
 	if (state->phase == idle)
 		mac53c94_start(state);
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 7ceb5cf..b585f75 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -371,7 +371,9 @@ megaraid_queue(Scsi_Cmnd *scmd, void (*done)(Scsi_Cmnd *))
 	adapter_t	*adapter;
 	scb_t	*scb;
 	int	busy=0;
-	unsigned long flags;
+	unsigned long flags, hflags;
+
+	spin_lock_irqsave(scmd->device->host->host_lock, hflags);
 
 	adapter = (adapter_t *)scmd->device->host->hostdata;
 
@@ -406,6 +408,7 @@ megaraid_queue(Scsi_Cmnd *scmd, void (*done)(Scsi_Cmnd *))
 	busy = 0;
  out:
 	spin_unlock_irqrestore(&adapter->lock, flags);
+	spin_unlock_irqrestore(scmd->device->host->host_lock, hflags);
 	return busy;
 }
 
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index a7810a1..eafb53f 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1488,8 +1488,11 @@ megaraid_queue_command(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
 {
 	adapter_t	*adapter;
 	scb_t		*scb;
+	unsigned long	hflags;
 	int		if_busy;
 
+	spin_lock_irqsave(scp->device->host->host_lock, hflags);
+
 	adapter		= SCP2ADAPTER(scp);
 	scp->scsi_done	= done;
 	scp->result	= 0;
@@ -1506,10 +1509,13 @@ megaraid_queue_command(struct scsi_cmnd *scp, void (*done)(struct scsi_cmnd *))
 	scb = megaraid_mbox_build_cmd(adapter, scp, &if_busy);
 	if (!scb) {	// command already completed
 		done(scp);
+		spin_unlock_irqrestore(scp->device->host->host_lock, hflags);
 		return 0;
 	}
 
 	megaraid_mbox_runpendq(adapter, scb);
+
+	spin_unlock_irqrestore(scp->device->host->host_lock, hflags);
 	return if_busy;
 }
 
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index d3c9cde..abd61d8 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -1324,17 +1324,22 @@ megasas_queue_command(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd *))
 	u32 frame_count;
 	struct megasas_cmd *cmd;
 	struct megasas_instance *instance;
-	unsigned long flags;
+	unsigned long flags, hflags;
+
+	spin_lock_irqsave(scmd->device->host->host_lock, hflags);
 
 	instance = (struct megasas_instance *)
 	    scmd->device->host->hostdata;
 
-	if (instance->issuepend_done == 0)
+	if (instance->issuepend_done == 0) {
+		spin_unlock_irqrestore(scmd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	spin_lock_irqsave(&instance->hba_lock, flags);
 	if (instance->adprecovery != MEGASAS_HBA_OPERATIONAL) {
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
+		spin_unlock_irqrestore(scmd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -1362,9 +1367,10 @@ megasas_queue_command(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd *))
 	}
 
 	cmd = megasas_get_cmd(instance);
-	if (!cmd)
+	if (!cmd) {
+		spin_unlock_irqrestore(scmd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
-
+	}
 	/*
 	 * Logical drive command
 	 */
@@ -1392,13 +1398,14 @@ megasas_queue_command(struct scsi_cmnd *scmd, void (*done) (struct scsi_cmnd *))
 	if (poll_mode_io && atomic_read(&instance->fw_outstanding))
 		tasklet_schedule(&instance->isr_tasklet);
 
-
+	spin_unlock_irqrestore(scmd->device->host->host_lock, hflags);
 	return 0;
 
  out_return_cmd:
 	megasas_return_cmd(instance, cmd);
  out_done:
 	done(scmd);
+	spin_unlock_irqrestore(scmd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 1f784fd..1adb07b 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -1630,6 +1630,9 @@ static void cmd_complete(struct mesh_state *ms)
 static int mesh_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
 	struct mesh_state *ms;
+	unsigned long hflags;
+
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
 
 	cmd->scsi_done = done;
 	cmd->host_scribble = NULL;
@@ -1645,6 +1648,7 @@ static int mesh_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	if (ms->phase == idle)
 		mesh_start(ms);
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 4c1e545..f1d544b 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -914,8 +914,11 @@ static int nsp32_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	nsp32_target *target;
 	nsp32_lunt   *cur_lunt;
+	unsigned long hflags;
 	int ret;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, hflags);
+
 	nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND,
 		  "enter. target: 0x%x LUN: 0x%x cmnd: 0x%x cmndlen: 0x%x "
 		  "use_sg: 0x%x reqbuf: 0x%lx reqlen: 0x%x",
@@ -927,6 +930,7 @@ static int nsp32_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 		data->CurrentSC = NULL;
 		SCpnt->result   = DID_NO_CONNECT << 16;
 		done(SCpnt);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 		return 0;
 	}
 
@@ -935,6 +939,7 @@ static int nsp32_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "terget==host???");
 		SCpnt->result = DID_BAD_TARGET << 16;
 		done(SCpnt);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 		return 0;
 	}
 
@@ -943,6 +948,7 @@ static int nsp32_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "no more lun");
 		SCpnt->result = DID_BAD_TARGET << 16;
 		done(SCpnt);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 		return 0;
 	}
 
@@ -975,6 +981,7 @@ static int nsp32_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 		nsp32_msg(KERN_ERR, "SGT fail");
 		SCpnt->result = DID_ERROR << 16;
 		nsp32_scsi_done(SCpnt);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 		return 0;
 	}
 
@@ -1047,6 +1054,7 @@ static int nsp32_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 		nsp32_scsi_done(SCpnt);
 	}
 
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 9326c2c..1717805 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -193,6 +193,9 @@ static int nsp_queuecommand(struct scsi_cmnd *SCpnt,
 	unsigned char target = scmd_id(SCpnt);
 #endif
 	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
+	unsigned long hflags;
+
+	spin_lock_irqsave(SCpnt->device->host->host_lock, hflags);
 
 	nsp_dbg(NSP_DEBUG_QUEUECOMMAND,
 		"SCpnt=0x%p target=%d lun=%d sglist=0x%p bufflen=%d sg_count=%d",
@@ -206,6 +209,7 @@ static int nsp_queuecommand(struct scsi_cmnd *SCpnt,
 		nsp_msg(KERN_DEBUG, "CurrentSC!=NULL this can't be happen");
 		SCpnt->result   = DID_BAD_TARGET << 16;
 		nsp_scsi_done(SCpnt);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 		return 0;
 	}
 
@@ -253,6 +257,7 @@ static int nsp_queuecommand(struct scsi_cmnd *SCpnt,
 		nsp_dbg(NSP_DEBUG_QUEUECOMMAND, "selection fail");
 		SCpnt->result   = DID_BUS_BUSY << 16;
 		nsp_scsi_done(SCpnt);
+		spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 		return 0;
 	}
 
@@ -261,6 +266,8 @@ static int nsp_queuecommand(struct scsi_cmnd *SCpnt,
 #ifdef NSP_DEBUG
 	data->CmdId++;
 #endif
+
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 0ae27cb..2c06308 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -549,11 +549,14 @@ SYM53C500_info(struct Scsi_Host *SChost)
 static int 
 SYM53C500_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
+	unsigned long hflags;
 	int i;
 	int port_base = SCpnt->device->host->io_port;
 	struct sym53c500_data *data =
 	    (struct sym53c500_data *)SCpnt->device->host->hostdata;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, hflags);
+
 	VDEB(printk("SYM53C500_queue called\n"));
 
 	DEB(printk("cmd=%02x, cmd_len=%02x, target=%02x, lun=%02x, bufflen=%d\n", 
@@ -580,6 +583,7 @@ SYM53C500_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	}
 	outb(SELECT_NO_ATN, port_base + CMD_REG);
 
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);	
 	return 0;
 }
 
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 4b87657..3025e04 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3480,9 +3480,12 @@ static int pmcraid_queuecommand(
 	struct pmcraid_resource_entry *res;
 	struct pmcraid_ioarcb *ioarcb;
 	struct pmcraid_cmd *cmd;
+	unsigned long hflags;
 	u32 fw_version;
 	int rc = 0;
 
+	spin_lock_irqsave(scsi_cmd->device->host->host_lock, hflags);
+
 	pinstance =
 		(struct pmcraid_instance *)scsi_cmd->device->host->hostdata;
 	fw_version = be16_to_cpu(pinstance->inq_data->fw_version);
@@ -3497,19 +3500,25 @@ static int pmcraid_queuecommand(
 		pmcraid_info("IOA is dead, but queuecommand is scheduled\n");
 		scsi_cmd->result = (DID_NO_CONNECT << 16);
 		scsi_cmd->scsi_done(scsi_cmd);
+		spin_unlock_irqrestore(scsi_cmd->device->host->host_lock,
+					hflags);
 		return 0;
 	}
 
 	/* If IOA reset is in progress, can't queue the commands */
-	if (pinstance->ioa_reset_in_progress)
+	if (pinstance->ioa_reset_in_progress) {
+		spin_unlock_irqrestore(scsi_cmd->device->host->host_lock,
+					hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
-
+	}
 	/* Firmware doesn't support SYNCHRONIZE_CACHE command (0x35), complete
 	 * the command here itself with success return
 	 */
 	if (scsi_cmd->cmnd[0] == SYNCHRONIZE_CACHE) {
 		pmcraid_info("SYNC_CACHE(0x35), completing in driver itself\n");
 		scsi_cmd->scsi_done(scsi_cmd);
+		spin_unlock_irqrestore(scsi_cmd->device->host->host_lock,
+					hflags);
 		return 0;
 	}
 
@@ -3518,6 +3527,8 @@ static int pmcraid_queuecommand(
 
 	if (cmd == NULL) {
 		pmcraid_err("free command block is not available\n");
+		spin_unlock_irqrestore(scsi_cmd->device->host->host_lock,
+					hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -3574,6 +3585,7 @@ static int pmcraid_queuecommand(
 		rc = SCSI_MLQUEUE_HOST_BUSY;
 	}
 
+	spin_unlock_irqrestore(scsi_cmd->device->host->host_lock, hflags);
 	return rc;
 }
 
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index 7bc2d79..bf8cd3d 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -802,9 +802,13 @@ static int ppa_queuecommand(struct scsi_cmnd *cmd,
 		void (*done) (struct scsi_cmnd *))
 {
 	ppa_struct *dev = ppa_dev(cmd->device->host);
+	unsigned long hflags;
+
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
 
 	if (dev->cur_cmd) {
 		printk(KERN_ERR "PPA: bug in ppa_queuecommand\n");
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return 0;
 	}
 	dev->failed = 0;
@@ -818,6 +822,7 @@ static int ppa_queuecommand(struct scsi_cmnd *cmd,
 
 	ppa_pb_claim(dev);
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index 92ffbb5..cbc9c84 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -216,9 +216,12 @@ static int ps3rom_queuecommand(struct scsi_cmnd *cmd,
 {
 	struct ps3rom_private *priv = shost_priv(cmd->device->host);
 	struct ps3_storage_device *dev = priv->dev;
+	unsigned long hflags;
 	unsigned char opcode;
 	int res;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
+
 #ifdef DEBUG
 	scsi_print_command(cmd);
 #endif
@@ -257,6 +260,7 @@ static int ps3rom_queuecommand(struct scsi_cmnd *cmd,
 		cmd->scsi_done(cmd);
 	}
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index b8166ec..c0bf524 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -732,8 +732,11 @@ qla1280_queuecommand(struct scsi_cmnd *cmd, void (*fn)(struct scsi_cmnd *))
 	struct Scsi_Host *host = cmd->device->host;
 	struct scsi_qla_host *ha = (struct scsi_qla_host *)host->hostdata;
 	struct srb *sp = (struct srb *)CMD_SP(cmd);
+	unsigned long hflags;
 	int status;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
+
 	cmd->scsi_done = fn;
 	sp->cmd = cmd;
 	sp->flags = 0;
@@ -753,6 +756,8 @@ qla1280_queuecommand(struct scsi_cmnd *cmd, void (*fn)(struct scsi_cmnd *))
 #else
 	status = qla1280_32bit_start_scsi(ha, sp);
 #endif
+
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return status;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 800ea92..3cd3792 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -574,26 +574,21 @@ qla2xxx_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 		goto qc24_target_busy;
 	}
 
-	spin_unlock_irq(vha->host->host_lock);
-
 	sp = qla2x00_get_new_sp(base_vha, fcport, cmd, done);
 	if (!sp)
-		goto qc24_host_busy_lock;
+		goto qc24_host_busy;
 
 	rval = ha->isp_ops->start_scsi(sp);
 	if (rval != QLA_SUCCESS)
 		goto qc24_host_busy_free_sp;
 
-	spin_lock_irq(vha->host->host_lock);
-
 	return 0;
 
 qc24_host_busy_free_sp:
 	qla2x00_sp_free_dma(sp);
 	mempool_free(sp, ha->srb_mempool);
 
-qc24_host_busy_lock:
-	spin_lock_irq(vha->host->host_lock);
+qc24_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
 
 qc24_target_busy:
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 370d40f..cfbe8b5 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -511,26 +511,20 @@ static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
 	    test_bit(DPC_RESET_HA_FW_CONTEXT, &ha->dpc_flags))
 		goto qc_host_busy;
 
-	spin_unlock_irq(ha->host->host_lock);
-
 	srb = qla4xxx_get_new_srb(ha, ddb_entry, cmd, done);
 	if (!srb)
-		goto qc_host_busy_lock;
+		goto qc_host_busy;
 
 	rval = qla4xxx_send_command_to_isp(ha, srb);
 	if (rval != QLA_SUCCESS)
 		goto qc_host_busy_free_sp;
 
-	spin_lock_irq(ha->host->host_lock);
 	return 0;
 
 qc_host_busy_free_sp:
 	qla4xxx_srb_free_dma(ha, srb);
 	mempool_free(srb, ha->srb_mempool);
 
-qc_host_busy_lock:
-	spin_lock_irq(ha->host->host_lock);
-
 qc_host_busy:
 	return SCSI_MLQUEUE_HOST_BUSY;
 
diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index 1ad5155..c709ce3 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -443,9 +443,14 @@ int qlogicfas408_queuecommand(struct scsi_cmnd *cmd,
 			      void (*done) (struct scsi_cmnd *))
 {
 	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
+	unsigned long hflags;
+
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
+
 	if (scmd_id(cmd) == priv->qinitid) {
 		cmd->result = DID_BAD_TARGET << 16;
 		done(cmd);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return 0;
 	}
 
@@ -456,6 +461,8 @@ int qlogicfas408_queuecommand(struct scsi_cmnd *cmd,
 		cpu_relax();
 	}
 	ql_icmd(cmd);
+
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index f8c561c..9f4f5e1 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1008,9 +1008,12 @@ static int qlogicpti_queuecommand(struct scsi_cmnd *Cmnd, void (*done)(struct sc
 	struct Scsi_Host *host = Cmnd->device->host;
 	struct qlogicpti *qpti = (struct qlogicpti *) host->hostdata;
 	struct Command_Entry *cmd;
+	unsigned long hflags;
 	u_int out_ptr;
 	int in_ptr;
 
+	spin_lock_irqsave(Cmnd->device->host->host_lock, hflags);
+
 	Cmnd->scsi_done = done;
 
 	in_ptr = qpti->req_in_ptr;
@@ -1037,6 +1040,7 @@ static int qlogicpti_queuecommand(struct scsi_cmnd *Cmnd, void (*done)(struct sc
 
 	update_can_queue(host, in_ptr, out_ptr);
 
+	spin_unlock_irqrestore(Cmnd->device->host->host_lock, hflags);
 	return 0;
 
 toss_command:
@@ -1049,6 +1053,8 @@ toss_command:
 	 */
 	Cmnd->result = DID_BUS_BUSY;
 	done(Cmnd);
+
+	spin_unlock_irqrestore(Cmnd->device->host->host_lock, hflags);
 	return 1;
 }
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 348fba0..2d68d2b 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -628,17 +628,20 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 
 /**
  * scsi_cmd_get_serial - Assign a serial number to a command
- * @host: the scsi host
  * @cmd: command to assign serial number to
  *
  * Description: a serial number identifies a request for error recovery
- * and debugging purposes.  Protected by the Host_Lock of host.
+ * and debugging purposes.  Called directly by scsi_dispatch_cmd() for
+ * all LLDs.
  */
-static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
+static void scsi_cmd_get_serial(struct scsi_cmnd *cmd)
 {
-	cmd->serial_number = host->cmd_serial_number++;
-	if (cmd->serial_number == 0) 
-		cmd->serial_number = host->cmd_serial_number++;
+	struct Scsi_Host *host = cmd->device->host;
+	/*
+	 * Increment the host->cmd_serial_number by 2 so cmd->serial_number
+	 * is always odd and wraps to 1 instead of 0.
+	 */
+	cmd->serial_number = atomic_add_return(2, &host->cmd_serial_number);
 }
 
 /**
@@ -651,7 +654,6 @@ static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd
 int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
-	unsigned long flags = 0;
 	unsigned long timeout;
 	int rtn = 0;
 
@@ -736,16 +738,17 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		scsi_done(cmd);
 		goto out;
 	}
-
-	spin_lock_irqsave(host->host_lock, flags);
 	/*
-	 * AK: unlikely race here: for some reason the timer could
-	 * expire before the serial number is set up below.
-	 *
-	 * TODO: kill serial or move to blk layer
+	 * Assign a cmd->serial_number from host->cmd_serial_number that
+	 * is used by handful of LLDs, and by scsi_softirq_done() to signal
+	 * scsi_try_to_abort_cmd() that a outstanding cmd has been completed.
+	 */
+	scsi_cmd_get_serial(cmd);
+	/*
+	 * We expect legacy LLDs to perform their own host->host_lock
+	 * protection if the code itself cannot run in 'host_lock-less'
+	 * mode.
 	 */
-	scsi_cmd_get_serial(host, cmd); 
-
 	if (unlikely(host->shost_state == SHOST_DEL)) {
 		cmd->result = (DID_NO_CONNECT << 16);
 		scsi_done(cmd);
@@ -753,7 +756,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		trace_scsi_dispatch_cmd_start(cmd);
 		rtn = host->hostt->queuecommand(cmd, scsi_done);
 	}
-	spin_unlock_irqrestore(host->host_lock, flags);
+
 	if (rtn) {
 		trace_scsi_dispatch_cmd_error(cmd, rtn);
 		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 9c73dbd..f6cced9 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -576,17 +576,22 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 {
 	struct st_hba *hba;
 	struct Scsi_Host *host;
+	unsigned long hflags;
 	unsigned int id, lun;
 	struct req_msg *req;
 	u16 tag;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
+
 	host = cmd->device->host;
 	id = cmd->device->id;
 	lun = cmd->device->lun;
 	hba = (struct st_hba *) &host->hostdata[0];
 
-	if (unlikely(hba->mu_status == MU_STATE_RESETTING))
+	if (unlikely(hba->mu_status == MU_STATE_RESETTING)) {
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	switch (cmd->cmnd[0]) {
 	case MODE_SENSE_10:
@@ -603,6 +608,8 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 			done(cmd);
 		} else
 			stex_invalid_field(cmd, done);
+
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return 0;
 	}
 	case REPORT_LUNS:
@@ -613,6 +620,8 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 		 */
 		if (hba->cardtype == st_shasta || id == host->max_id - 1) {
 			stex_invalid_field(cmd, done);
+			spin_unlock_irqrestore(cmd->device->host->host_lock,
+						hflags);
 			return 0;
 		}
 		break;
@@ -620,6 +629,8 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 		if (id == host->max_id - 1) {
 			cmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
 			done(cmd);
+			spin_unlock_irqrestore(cmd->device->host->host_lock,
+						hflags);
 			return 0;
 		}
 		break;
@@ -627,6 +638,8 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 		if (lun >= host->max_lun) {
 			cmd->result = DID_NO_CONNECT << 16;
 			done(cmd);
+			spin_unlock_irqrestore(cmd->device->host->host_lock,
+						hflags);
 			return 0;
 		}
 		if (id != host->max_id - 1)
@@ -639,6 +652,8 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 			done(cmd);
 		} else
 			stex_invalid_field(cmd, done);
+
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return 0;
 	case PASSTHRU_CMD:
 		if (cmd->cmnd[1] == PASSTHRU_GET_DRVVER) {
@@ -657,6 +672,8 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 				DID_OK << 16 | COMMAND_COMPLETE << 8 :
 				DID_ERROR << 16 | COMMAND_COMPLETE << 8;
 			done(cmd);
+			spin_unlock_irqrestore(cmd->device->host->host_lock,
+						hflags);
 			return 0;
 		}
 	default:
@@ -667,8 +684,10 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 
 	tag = cmd->request->tag;
 
-	if (unlikely(tag >= host->can_queue))
+	if (unlikely(tag >= host->can_queue)) {
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	req = hba->alloc_rq(hba);
 
@@ -695,6 +714,8 @@ stex_queuecommand(struct scsi_cmnd *cmd, void (* done)(struct scsi_cmnd *))
 	}
 
 	hba->send(hba, req, tag);
+
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index e5c369b..c7f74c4 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -737,9 +737,11 @@ const char *sym53c416_info(struct Scsi_Host *SChost)
 int sym53c416_queuecommand(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
 {
 	int base;
-	unsigned long flags = 0;
+	unsigned long flags = 0, hflags;
 	int i;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, hflags);
+
 	/* Store base register as we can have more than one controller in the system */
 	base = SCpnt->device->host->io_port;
 	current_command = SCpnt;                  /* set current command                */
@@ -758,6 +760,8 @@ int sym53c416_queuecommand(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
 	outb(SEL_WITHOUT_ATN_SEQ, base + COMMAND_REG);
 	/* Now an interrupt will be generated which we will catch in out interrupt routine */
 	spin_unlock_irqrestore(&sym53c416_lock, flags);
+
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 8b955b5..f403387 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -510,8 +510,11 @@ static int sym53c8xx_queue_command(struct scsi_cmnd *cmd,
 {
 	struct sym_hcb *np = SYM_SOFTC_PTR(cmd);
 	struct sym_ucmd *ucp = SYM_UCMD_PTR(cmd);
+	unsigned long hflags;
 	int sts = 0;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
+
 	cmd->scsi_done = done;
 	memset(ucp, 0, sizeof(*ucp));
 
@@ -527,12 +530,18 @@ static int sym53c8xx_queue_command(struct scsi_cmnd *cmd,
 		}
 	}
 
-	if (np->s.settle_time_valid)
+	if (np->s.settle_time_valid) {
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 
 	sts = sym_queue_command(np, cmd);
-	if (sts)
+	if (sts) {
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 27866b0..226dcdd 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -1890,6 +1890,9 @@ static int DC390_queuecommand(struct scsi_cmnd *cmd,
 	struct dc390_acb *acb = (struct dc390_acb *)sdev->host->hostdata;
 	struct dc390_dcb *dcb = sdev->hostdata;
 	struct dc390_srb *srb;
+	unsigned long hflags;
+
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
 
 	if (sdev->queue_depth <= dcb->GoingSRBCnt)
 		goto device_busy;
@@ -1935,12 +1938,15 @@ static int DC390_queuecommand(struct scsi_cmnd *cmd,
 
 	dc390_Going_append(dcb, srb);
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return 0;
 
  host_busy:
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return SCSI_MLQUEUE_HOST_BUSY;
 
  device_busy:
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return SCSI_MLQUEUE_DEVICE_BUSY;
 }
 
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 5d9fdee..5b605f5 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1251,6 +1251,9 @@ static void scsi_to_dev_dir(unsigned int i, unsigned int j) {
 static int u14_34f_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *)) {
    unsigned int i, j, k;
    struct mscp *cpp;
+   unsigned long hflags;
+
+   spin_lock_irqsave(SCpnt->device->host->host_lock, hflags);
 
    /* j is the board number */
    j = ((struct hostdata *) SCpnt->device->host->hostdata)->board_number;
@@ -1275,6 +1278,7 @@ static int u14_34f_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scs
 
    if (k == sh[j]->can_queue) {
       printk("%s: qcomm, no free mailbox.\n", BN(j));
+      spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
       return 1;
       }
 
@@ -1308,6 +1312,7 @@ static int u14_34f_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scs
                                      && TLDEV(SCpnt->device->type)) {
       HD(j)->cp_stat[i] = READY;
       flush_dev(SCpnt->device, blk_rq_pos(SCpnt->request), j, FALSE);
+      spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
       return 0;
       }
 
@@ -1316,6 +1321,7 @@ static int u14_34f_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scs
       SCpnt->host_scribble = NULL;
       scmd_printk(KERN_INFO, SCpnt,
       		"qcomm, pid %ld, adapter busy.\n", SCpnt->serial_number);
+      spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
       return 1;
       }
 
@@ -1326,6 +1332,8 @@ static int u14_34f_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scs
    outb(CMD_OGM_INTR, sh[j]->io_port + REG_LCL_INTR);
 
    HD(j)->cp_stat[i] = IN_USE;
+
+   spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
    return 0;
 }
 
diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index 27aa40f..a37cec7 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -707,8 +707,11 @@ static int ultrastor_queuecommand(struct scsi_cmnd *SCpnt,
 #if ULTRASTOR_MAX_CMDS > 1
     int mscp_index;
 #endif
+    unsigned long hflags;
     unsigned int status;
 
+    spin_lock_irqsave(SCpnt->device->host->host_lock, hflags);
+
     /* Next test is for debugging; "can't happen" */
     if ((config.mscp_free & ((1U << ULTRASTOR_MAX_CMDS) - 1)) == 0)
 	panic("ultrastor_queuecommand: no free MSCP\n");
@@ -800,8 +803,10 @@ retry:
 #if ULTRASTOR_MAX_CMDS > 1
 	SCpnt->result = status;
 	done(SCpnt);
+    spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 	return 0;
 #else
+    spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 	return status;
 #endif
     }
@@ -822,6 +827,7 @@ retry:
     printk("USx4F: queuecommand: returning\n");
 #endif
 
+    spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
     return 0;
 }
 
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 2689445..a32ccd3 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -695,7 +695,9 @@ static int pvscsi_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	struct Scsi_Host *host = cmd->device->host;
 	struct pvscsi_adapter *adapter = shost_priv(host);
 	struct pvscsi_ctx *ctx;
-	unsigned long flags;
+	unsigned long flags, hflags;
+
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
 
 	spin_lock_irqsave(&adapter->hw_lock, flags);
 
@@ -704,6 +706,7 @@ static int pvscsi_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 		if (ctx)
 			pvscsi_release_context(adapter, ctx);
 		spin_unlock_irqrestore(&adapter->hw_lock, flags);
+		spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -716,6 +719,7 @@ static int pvscsi_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 
 	pvscsi_kick_io(adapter, cmd->cmnd[0]);
 
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index b701bf2..f5a5245 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -377,7 +377,9 @@ wd33c93_queuecommand(struct scsi_cmnd *cmd,
 {
 	struct WD33C93_hostdata *hostdata;
 	struct scsi_cmnd *tmp;
+	unsigned long hflags;
 
+	spin_lock_irqsave(cmd->device->host->host_lock, hflags);
 	hostdata = (struct WD33C93_hostdata *) cmd->device->host->hostdata;
 
 	DB(DB_QUEUE_COMMAND,
@@ -465,6 +467,7 @@ wd33c93_queuecommand(struct scsi_cmnd *cmd,
 	DB(DB_QUEUE_COMMAND, printk(")Q-%ld ", cmd->serial_number))
 
 	spin_unlock_irq(&hostdata->lock);
+	spin_unlock_irqrestore(cmd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 333580b..1fa5484 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1087,12 +1087,15 @@ static int wd7000_queuecommand(struct scsi_cmnd *SCpnt,
 {
 	Scb *scb;
 	Sgb *sgb;
+	unsigned long hflags;
 	unchar *cdb = (unchar *) SCpnt->cmnd;
 	unchar idlun;
 	short cdblen;
 	int nseg;
 	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
 
+	spin_lock_irqsave(SCpnt->device->host->host_lock, hflags);
+
 	cdblen = SCpnt->cmd_len;
 	idlun = ((SCpnt->device->id << 5) & 0xe0) | (SCpnt->device->lun & 7);
 	SCpnt->scsi_done = done;
@@ -1136,6 +1139,7 @@ static int wd7000_queuecommand(struct scsi_cmnd *SCpnt,
 	while (!mail_out(host, scb))
 		cpu_relax();	/* keep trying */
 
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 62882a4..165f8aa 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -612,11 +612,14 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
 		&storvsc_drv_ctx->drv_obj;
 	struct hv_storvsc_request *request;
 	struct storvsc_cmd_request *cmd_request;
+	unsigned long hflags;
 	unsigned int request_size = 0;
 	int i;
 	struct scatterlist *sgl;
 	unsigned int sg_count = 0;
 
+	spin_lock_irqsave(scmnd->device->host->host_lock, hflags);
+
 	DPRINT_DBG(STORVSC_DRV, "scmnd %p dir %d, use_sg %d buf %p len %d "
 		   "queue depth %d tagged %d", scmnd, scmnd->sc_data_direction,
 		   scsi_sg_count(scmnd), scsi_sglist(scmnd),
@@ -648,6 +651,7 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
 		DPRINT_ERR(STORVSC_DRV, "scmnd (%p) - unable to allocate "
 			   "storvsc_cmd_request...marking queue busy", scmnd);
 		scmnd->scsi_done = NULL;
+		spin_unlock_irqrestore(scmnd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 
@@ -718,6 +722,8 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
 				kmem_cache_free(host_device_ctx->request_pool,
 						cmd_request);
 
+				spin_unlock_irqrestore(scmnd->device->host->host_lock,
+							hflags);
 				return SCSI_MLQUEUE_HOST_BUSY;
 			}
 
@@ -782,6 +788,7 @@ retry_request:
 		ret = SCSI_MLQUEUE_DEVICE_BUSY;
 	}
 
+	spin_unlock_irqrestore(scmnd->device->host->host_lock, hflags);
 	return ret;
 }
 
diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 5a47805..789b4c9 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -576,9 +576,12 @@ static int
 mts_scsi_queuecommand(struct scsi_cmnd *srb, mts_scsi_cmnd_callback callback)
 {
 	struct mts_desc* desc = (struct mts_desc*)(srb->device->host->hostdata[0]);
+	unsigned long hflags;
 	int err = 0;
 	int res;
 
+	spin_lock_irqsave(srb->device->host->host_lock, hflags);
+
 	MTS_DEBUG_GOT_HERE();
 	mts_show_command(srb);
 	mts_debug_dump(desc);
@@ -623,6 +626,7 @@ mts_scsi_queuecommand(struct scsi_cmnd *srb, mts_scsi_cmnd_callback callback)
 
 	}
 out:
+	spin_unlock_irqrestore(srb->device->host->host_lock, hflags);
 	return err;
 }
 
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index a688b1e..e0a8c96 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -289,6 +289,9 @@ static int queuecommand(struct scsi_cmnd *srb,
 			void (*done)(struct scsi_cmnd *))
 {
 	struct us_data *us = host_to_us(srb->device->host);
+	unsigned long hflags;
+
+	spin_lock_irqsave(srb->device->host->host_lock, hflags);	
 
 	US_DEBUGP("%s called\n", __func__);
 
@@ -296,6 +299,7 @@ static int queuecommand(struct scsi_cmnd *srb,
 	if (us->srb != NULL) {
 		printk(KERN_ERR USB_STORAGE "Error in %s: us->srb = %p\n",
 			__func__, us->srb);
+		spin_unlock_irqrestore(srb->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
@@ -304,6 +308,7 @@ static int queuecommand(struct scsi_cmnd *srb,
 		US_DEBUGP("Fail command during disconnect\n");
 		srb->result = DID_NO_CONNECT << 16;
 		done(srb);
+		spin_unlock_irqrestore(srb->device->host->host_lock, hflags);
 		return 0;
 	}
 
@@ -312,6 +317,7 @@ static int queuecommand(struct scsi_cmnd *srb,
 	us->srb = srb;
 	complete(&us->cmnd_ready);
 
+	spin_unlock_irqrestore(srb->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 2054b1e..8ce723a 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -439,12 +439,17 @@ static int uas_queuecommand(struct scsi_cmnd *cmnd,
 	struct scsi_device *sdev = cmnd->device;
 	struct uas_dev_info *devinfo = sdev->hostdata;
 	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
+	unsigned long hflags;
 	int err;
 
+	spin_lock_irqsave(cmnd->device->host->host_lock, hflags);
+
 	BUILD_BUG_ON(sizeof(struct uas_cmd_info) > sizeof(struct scsi_pointer));
 
-	if (!cmdinfo->sense_urb && sdev->current_cmnd)
+	if (!cmdinfo->sense_urb && sdev->current_cmnd) {
+		spin_unlock_irqrestore(cmnd->device->host->host_lock, hflags);
 		return SCSI_MLQUEUE_DEVICE_BUSY;
+	}
 
 	if (blk_rq_tagged(cmnd->request)) {
 		cmdinfo->stream = cmnd->request->tag + 1;
@@ -480,6 +485,8 @@ static int uas_queuecommand(struct scsi_cmnd *cmnd,
 		/* If we did nothing, give up now */
 		if (cmdinfo->state & SUBMIT_SENSE_URB) {
 			usb_free_urb(cmdinfo->sense_urb);
+			spin_unlock_irqrestore(cmnd->device->host->host_lock,
+						hflags);
 			return SCSI_MLQUEUE_DEVICE_BUSY;
 		}
 		spin_lock(&uas_work_lock);
@@ -488,6 +495,7 @@ static int uas_queuecommand(struct scsi_cmnd *cmnd,
 		schedule_work(&uas_work);
 	}
 
+	spin_unlock_irqrestore(cmnd->device->host->host_lock, hflags);
 	return 0;
 }
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index d0a6a84..8586ac7 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -604,10 +604,9 @@ struct Scsi_Host {
 	short unsigned int max_sectors;
 	unsigned long dma_boundary;
 	/* 
-	 * Used to assign serial numbers to the cmds.
-	 * Protected by the host lock.
+	 * Used to assign serial numbers to the cmds in scsi_cmd_get_serial()
 	 */
-	unsigned long cmd_serial_number;
+	atomic_t cmd_serial_number;
 	
 	unsigned active_mode:2;
 	unsigned unchecked_isa_dma:1;
-- 
1.7.3.2

