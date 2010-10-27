From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] scsi: Add SHT->queuecommand_unlocked() for host_lock less I/O dispatch
Date: Wed, 27 Oct 2010 12:48:48 -0700
Message-ID: <1288208928-15653-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm30-vm0.bullet.mail.ac4.yahoo.com ([98.139.52.250]:23602 "HELO
	nm30-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752599Ab0J0Ts4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Oct 2010 15:48:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux>
Cc: James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, "eata.c maintainer" <dario.ballabio@inwind.it>, Luben Tuikov <ltuikov@yahoo.com>, mvsas maintainer <kewei@marvell.com>, pm8001 maintainer Jack Wang <jack_wang@usish.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Following up on a request made by jejb and Co. offlist to convert SHT->unlocked_cmd
to use SHT->queuecommand_unlocked() for host_lock less operation in modern LLDs..

This patch adds scsi_dispatch_cmd_unlocked() and scsi_dispatch_cmd_locked()
which are now called directly from scsi_dispatch_cmd() depending upon if
SHT->queuecommand_unlocked() function pointer exists on a per driver basis.
Note that by default ->queuecommand_unlocked is disabled, and all LLDs not
defining a SHT->queuecommand_unlocked() will be using the legacy
scsi_dispatch_cmd_locked() -> SHT->queuecommand() for I/O dispatch.

This patch also drops the usage of scsi_cmd_get_serial() in scsi_dispatch_cmd()
and assumes the legacy SCSI LLDs that depend upon struct scsi_cmnd->serial_number
will call the now EXPORT_SYMBOL()'ed scsi_cmd_get_serial() call.

This patch also adds a cmd->eh_eflags |= SCSI_EH_SOFTIRQ_DONE assignment in
scsi_softirq_done() in order to signal scsi_try_to_abort_cmd() that the command
has been completed.  This patch uses blk_test_rq_complete() together with a
new SCSI_EH_SOFTIRQ_DONE in scsi_error.c:scsi_try_to_abort_cmd() in order to
handle the struct scsi_cmnd timeout case intsead w/o scmd->serial_number usage:

-       if (scmd->serial_number == 0)
+       if ((blk_test_rq_complete(scmd->request)) &&
+           (scmd->eh_eflags & SCSI_EH_SOFTIRQ_DONE))
                return SUCCESS;

Finally, this patch also converts the remaining struct Scsi_Host->cmd_serial_number
to atomic_t following a recommedation by Joe Eykholt to increment each serial_number
by 2 so that the serial is odd, and wraps to 1 instead of 0.

Along with the changes to SCSI ML, this series includes the following LLD
commits to enable lock-less operation for certain LLDs, and adds the explict
scsi_cmd_get_serial() to the legacy LLDs still requring cmd->serial_number
for anything beyond informational purposes:

libiscsi: Remove host_lock unlock() + lock() from iscsi_queuecommand()
libsas: Remove host_lock unlock() + lock() from sas_queuecommand()
aic94xx: Set SHT->queuecommand_unlocked for libsas queuecommand()
mvsas: Set SHT->queuecommand_unlocked for libsas queuecommand()
pm8001: Set SHT->queuecommand_unlocked for libsas queuecommand()
libata: Remove host_lock unlock() + lock() and set SHT->queuecommand_unlocked()
lpfc: Remove host_lock unlock() + lock() and set SHT->queuecommand_unlocked()
qla4xxx: Remove host_lock unlock() + lock() and set SHT->queuecommand_unlocked()
qla2xxx: Remove host_lock unlock() + lock() and set SHT->queuecommand_unlocked()
fnic: Remove host_lock unlock() + lock() and set SHT->queuecommand_unlocked()
mpt2sas: Add scsi_cmd_get_serial() call and set SHT->queuecommand_unlocked()
mpt/fusion: Add scsi_cmd_get_serial() call and set SHT->queuecommand_unlocked()
dpt_i2o: Add scsi_cmd_get_serial() call
eata: Add scsi_cmd_get_serial() call
u14-34f: Add scsi_cmd_get_serial() call

Note that this patch series currently does not contain host_lock less operation
for libfc or fcoe as there are outstanding items wrt to rport state w/o host_lock
held in libfc ->queuecommand().

Many thanks to Vasu Dev, Tim Chen, Andi Kleen, Mike Christie, Joe Eykholt,
Mike Anderson, Christof Schmitt, Brian King, Jens Axboe, James Bottomley, and
H. Peter Anvin for their help with this series!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Acked-by: Ravi Anand <ravi.anand@qlogic.com> (for qla2xx)
Acked-by: Luben Tuikov <ltuikov@yahoo.com> (for aic94xx)
Acked-by: Jack Wang <jack_wang@usish.com> (for pm8001)
---
 block/blk.h                          |    4 ++
 drivers/ata/libata-scsi.c            |    4 +-
 drivers/message/fusion/mptfc.c       |    2 +-
 drivers/message/fusion/mptsas.c      |    2 +-
 drivers/message/fusion/mptscsih.c    |    5 ++
 drivers/message/fusion/mptspi.c      |    2 +-
 drivers/scsi/aic94xx/aic94xx_init.c  |    2 +-
 drivers/scsi/dpt_i2o.c               |    5 ++
 drivers/scsi/eata.c                  |    5 ++
 drivers/scsi/fnic/fnic_main.c        |    2 +-
 drivers/scsi/fnic/fnic_scsi.c        |    9 ---
 drivers/scsi/hosts.c                 |    4 ++
 drivers/scsi/iscsi_tcp.c             |    2 +-
 drivers/scsi/libiscsi.c              |    4 --
 drivers/scsi/libsas/sas_scsi_host.c  |    5 --
 drivers/scsi/lpfc/lpfc_scsi.c        |    6 +--
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    7 ++-
 drivers/scsi/mvsas/mv_init.c         |    2 +-
 drivers/scsi/pm8001/pm8001_init.c    |    2 +-
 drivers/scsi/qla2xxx/qla_os.c        |   11 +---
 drivers/scsi/qla4xxx/ql4_os.c        |   10 +---
 drivers/scsi/scsi.c                  |   95 ++++++++++++++++++++++++++--------
 drivers/scsi/scsi_error.c            |   11 +++-
 drivers/scsi/scsi_lib.c              |    6 ++
 drivers/scsi/scsi_priv.h             |    1 +
 drivers/scsi/u14-34f.c               |    6 ++
 include/linux/libata.h               |    2 +-
 include/scsi/scsi_cmnd.h             |    1 +
 include/scsi/scsi_host.h             |   23 +++++++-
 29 files changed, 162 insertions(+), 78 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index 2db8f32..4b14cfa 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -46,6 +46,10 @@ static inline void blk_clear_rq_complete(struct request *rq)
 	clear_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags);
 }
 
+static inline int blk_test_rq_complete(struct request *rq)
+{
+	return test_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags);
+}
 /*
  * Internal elevator interface
  */
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
 
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index e15220f..1368f34 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -113,7 +113,7 @@ static struct scsi_host_template mptfc_driver_template = {
 	.proc_info			= mptscsih_proc_info,
 	.name				= "MPT FC Host",
 	.info				= mptscsih_info,
-	.queuecommand			= mptfc_qcmd,
+	.queuecommand_unlocked		= mptfc_qcmd,
 	.target_alloc			= mptfc_target_alloc,
 	.slave_alloc			= mptfc_slave_alloc,
 	.slave_configure		= mptscsih_slave_configure,
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 83a5115..337bc67 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1962,7 +1962,7 @@ static struct scsi_host_template mptsas_driver_template = {
 	.proc_info			= mptscsih_proc_info,
 	.name				= "MPT SAS Host",
 	.info				= mptscsih_info,
-	.queuecommand			= mptsas_qcmd,
+	.queuecommand_unlocked		= mptsas_qcmd,
 	.target_alloc			= mptsas_target_alloc,
 	.slave_alloc			= mptsas_slave_alloc,
 	.slave_configure		= mptsas_slave_configure,
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 59b8f53..6aaa553 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1411,6 +1411,11 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	hd = shost_priv(SCpnt->device->host);
 	ioc = hd->ioc;
 	SCpnt->scsi_done = done;
+	/*
+	 * Call scsi_cmd_get_serial() because we need a valid serial number
+	 * in mptscsih_abort()
+	 */
+	scsi_cmd_get_serial(SCpnt);
 
 	dmfprintk(ioc, printk(MYIOC_s_DEBUG_FMT "qcmd: SCpnt=%p, done()=%p\n",
 		ioc->name, SCpnt, done));
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 0e28031..f2201f0 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -832,7 +832,7 @@ static struct scsi_host_template mptspi_driver_template = {
 	.proc_info			= mptscsih_proc_info,
 	.name				= "MPT SPI Host",
 	.info				= mptscsih_info,
-	.queuecommand			= mptspi_qcmd,
+	.queuecommand_unlocked		= mptspi_qcmd,
 	.target_alloc			= mptspi_target_alloc,
 	.slave_alloc			= mptspi_slave_alloc,
 	.slave_configure		= mptspi_slave_configure,
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 3b7e83d..c079a70 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -65,7 +65,7 @@ static struct scsi_host_template aic94xx_sht = {
 	.module			= THIS_MODULE,
 	/* .name is initialized */
 	.name			= "aic94xx",
-	.queuecommand		= sas_queuecommand,
+	.queuecommand_unlocked	= sas_queuecommand,
 	.target_alloc		= sas_target_alloc,
 	.slave_configure	= sas_slave_configure,
 	.slave_destroy		= sas_slave_destroy,
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 23dec00..ea0bfe6 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -430,6 +430,11 @@ static int adpt_queue(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
 
 	cmd->scsi_done = done;
 	/*
+	 * Call scsi_cmd_get_serial() because we need a valid serial number
+	 * for adpt_cmd_to_context()
+	 */
+	scsi_cmd_get_serial(cmd);
+	/*
 	 * SCSI REQUEST_SENSE commands will be executed automatically by the 
 	 * Host Adapter for any errors, so they should not be executed 
 	 * explicitly unless the Sense Data is zero indicating that no error 
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index d1c3137..e56a0d7 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1765,6 +1765,11 @@ static int eata2x_queuecommand(struct scsi_cmnd *SCpnt,
 	struct hostdata *ha = (struct hostdata *)shost->hostdata;
 	unsigned int i, k;
 	struct mscp *cpp;
+        /*
+	 * Call scsi_cmd_get_serial() because we need a valid serial number
+	 * for the main eata interrupt handler in ihdlr()
+	 */
+        scsi_cmd_get_serial(SCpnt);
 
 	if (SCpnt->host_scribble)
 		panic("%s: qcomm, pid %ld, SCpnt %p already active.\n",
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index bb63f1a..586b291 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -93,7 +93,7 @@ static int fnic_slave_alloc(struct scsi_device *sdev)
 static struct scsi_host_template fnic_host_template = {
 	.module = THIS_MODULE,
 	.name = DRV_NAME,
-	.queuecommand = fnic_queuecommand,
+	.queuecommand_unlocked = fnic_queuecommand,
 	.eh_abort_handler = fnic_abort_cmd,
 	.eh_device_reset_handler = fnic_device_reset,
 	.eh_host_reset_handler = fnic_host_reset,
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
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index fec47de..74870996 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -867,7 +867,7 @@ static int iscsi_sw_tcp_slave_configure(struct scsi_device *sdev)
 static struct scsi_host_template iscsi_sw_tcp_sht = {
 	.module			= THIS_MODULE,
 	.name			= "iSCSI Initiator over TCP/IP",
-	.queuecommand           = iscsi_queuecommand,
+	.queuecommand_unlocked	= iscsi_queuecommand,
 	.change_queue_depth	= iscsi_change_queue_depth,
 	.can_queue		= ISCSI_DEF_XMIT_CMDS_MAX - 1,
 	.sg_tablesize		= 4096,
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
index 3a65895..8320f51 100644
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
@@ -3721,7 +3719,7 @@ struct scsi_host_template lpfc_template = {
 	.module			= THIS_MODULE,
 	.name			= LPFC_DRIVER_NAME,
 	.info			= lpfc_info,
-	.queuecommand		= lpfc_queuecommand,
+	.queuecommand_unlocked	= lpfc_queuecommand,
 	.eh_abort_handler	= lpfc_abort_handler,
 	.eh_device_reset_handler = lpfc_device_reset_handler,
 	.eh_target_reset_handler = lpfc_target_reset_handler,
@@ -3744,7 +3742,7 @@ struct scsi_host_template lpfc_vport_template = {
 	.module			= THIS_MODULE,
 	.name			= LPFC_DRIVER_NAME,
 	.info			= lpfc_info,
-	.queuecommand		= lpfc_queuecommand,
+	.queuecommand_unlocked	= lpfc_queuecommand,
 	.eh_abort_handler	= lpfc_abort_handler,
 	.eh_device_reset_handler = lpfc_device_reset_handler,
 	.eh_target_reset_handler = lpfc_target_reset_handler,
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 16e99b6..dbf10d6 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3325,6 +3325,11 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	u16 smid;
 
 	scmd->scsi_done = done;
+	/*
+	 * Call scsi_cmd_get_serial() because we need a valid serial number
+	 * in mpt2sas_scsih_issue_tm()
+	 */
+	scsi_cmd_get_serial(scmd);
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
 		scmd->result = DID_NO_CONNECT << 16;
@@ -6450,7 +6455,7 @@ static struct scsi_host_template scsih_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= "Fusion MPT SAS Host",
 	.proc_name			= MPT2SAS_DRIVER_NAME,
-	.queuecommand			= _scsih_qcmd,
+	.queuecommand_unlocked		= _scsih_qcmd,
 	.target_alloc			= _scsih_target_alloc,
 	.slave_alloc			= _scsih_slave_alloc,
 	.slave_configure		= _scsih_slave_configure,
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 19ad34f..9a1e9e6 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -42,7 +42,7 @@ static const struct mvs_chip_info mvs_chips[] = {
 static struct scsi_host_template mvs_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
-	.queuecommand		= sas_queuecommand,
+	.queuecommand_unlocked	= sas_queuecommand,
 	.target_alloc		= sas_target_alloc,
 	.slave_configure	= mvs_slave_configure,
 	.slave_destroy		= sas_slave_destroy,
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index f8c86b2..107c9d0 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -57,7 +57,7 @@ LIST_HEAD(hba_list);
 static struct scsi_host_template pm8001_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
-	.queuecommand		= sas_queuecommand,
+	.queuecommand_unlocked	= sas_queuecommand,
 	.target_alloc		= sas_target_alloc,
 	.slave_configure	= pm8001_slave_configure,
 	.slave_destroy		= sas_slave_destroy,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 800ea92..33a20d4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -188,7 +188,7 @@ static int qla2x00_change_queue_type(struct scsi_device *, int);
 struct scsi_host_template qla2xxx_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= QLA2XXX_DRIVER_NAME,
-	.queuecommand		= qla2xxx_queuecommand,
+	.queuecommand_unlocked	= qla2xxx_queuecommand,
 
 	.eh_abort_handler	= qla2xxx_eh_abort,
 	.eh_device_reset_handler = qla2xxx_eh_device_reset,
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
index 370d40f..771c8c6 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -97,7 +97,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= DRIVER_NAME,
 	.proc_name		= DRIVER_NAME,
-	.queuecommand		= qla4xxx_queuecommand,
+	.queuecommand_unlocked	= qla4xxx_queuecommand,
 
 	.eh_abort_handler	= qla4xxx_eh_abort,
 	.eh_device_reset_handler = qla4xxx_eh_device_reset,
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
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 348fba0..fee38d2 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -628,17 +628,75 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 
 /**
  * scsi_cmd_get_serial - Assign a serial number to a command
- * @host: the scsi host
  * @cmd: command to assign serial number to
  *
  * Description: a serial number identifies a request for error recovery
- * and debugging purposes.  Protected by the Host_Lock of host.
+ * and debugging purposes.  Called directly by SCSI LLDs that have a
+ * legacy requirement for struct scsi_cmnd->serial_number.
  */
-static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
+void scsi_cmd_get_serial(struct scsi_cmnd *cmd)
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
+}
+EXPORT_SYMBOL(scsi_cmd_get_serial);
+
+/*
+ * scsi_dispatch_cmd_unlocked() - Dispatch a cmd w/o host_lock
+ * @cmd: command to dispatch.
+ * @host: SCSI host of the passed command
+ *
+ * Description: Used by modern SCSI LLDs that do not require that
+ * struct Scsi_Host->host_lock is held during a dispatch call to
+ * SHT->queuecommand().
+ */
+
+static inline int scsi_dispatch_cmd_unlocked(struct scsi_cmnd *cmd,
+					struct Scsi_Host *host)
+{
+	int rtn = 0;
+
+	if (unlikely(host->shost_state == SHOST_DEL)) {
+		cmd->result = (DID_NO_CONNECT << 16);
+		scsi_done(cmd);
+	} else {
+		trace_scsi_dispatch_cmd_start(cmd);
+		rtn = host->hostt->queuecommand_unlocked(cmd, scsi_done);
+	}
+
+	return rtn;
+}
+
+/*
+ * scsi_dispatch_cmd_locked() - Dispatch a cmd w/ host_lock
+ * @cmd: command to dispatch.
+ * @host: SCSI host of the passed command
+ *
+ * Description: Used by kegacy SCSI LLDs that require that
+ * struct Scsi_Host->host_lock is held during a dispatch call to
+ * SHT->queuecommand().
+ */
+static inline int scsi_dispatch_cmd_locked(struct scsi_cmnd *cmd,
+					struct Scsi_Host *host)
+{
+	unsigned long flags;
+	int rtn = 0;
+
+	spin_lock_irqsave(host->host_lock, flags);
+	if (unlikely(host->shost_state == SHOST_DEL)) {
+		cmd->result = (DID_NO_CONNECT << 16);
+		scsi_done(cmd);
+	} else {
+		trace_scsi_dispatch_cmd_start(cmd);
+		rtn = host->hostt->queuecommand(cmd, scsi_done);
+	}
+	spin_unlock_irqrestore(host->host_lock, flags);
+
+	return rtn;
 }
 
 /**
@@ -651,7 +709,6 @@ static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd
 int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
-	unsigned long flags = 0;
 	unsigned long timeout;
 	int rtn = 0;
 
@@ -736,24 +793,20 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		scsi_done(cmd);
 		goto out;
 	}
-
-	spin_lock_irqsave(host->host_lock, flags);
 	/*
-	 * AK: unlikely race here: for some reason the timer could
-	 * expire before the serial number is set up below.
+	 * Note that scsi_cmd_get_serial() used to be called here, but
+	 * now we expect the legacy SCSI LLDs that actually need this
+	 * to call it directly within their SHT->queuecommand() caller.
 	 *
-	 * TODO: kill serial or move to blk layer
+	 * Also check for the new queuecommand_unlocked() to signal that
+	 * underlying LLD SHT->queuecommand() code is safe to run w/o
+	 * struct Scsi_Host->host_lock held.
 	 */
-	scsi_cmd_get_serial(host, cmd); 
+	if (host->hostt->queuecommand_unlocked != NULL)
+		rtn = scsi_dispatch_cmd_unlocked(cmd, host);
+	else
+		rtn = scsi_dispatch_cmd_locked(cmd, host);
 
-	if (unlikely(host->shost_state == SHOST_DEL)) {
-		cmd->result = (DID_NO_CONNECT << 16);
-		scsi_done(cmd);
-	} else {
-		trace_scsi_dispatch_cmd_start(cmd);
-		rtn = host->hostt->queuecommand(cmd, scsi_done);
-	}
-	spin_unlock_irqrestore(host->host_lock, flags);
 	if (rtn) {
 		trace_scsi_dispatch_cmd_error(cmd, rtn);
 		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1de30eb..e75b388 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -39,6 +39,8 @@
 #include "scsi_logging.h"
 #include "scsi_transport_api.h"
 
+#include <../block/blk.h> /* For REQ_ATOM_COMPLETE */
+
 #include <trace/events/scsi.h>
 
 #define SENSE_TIMEOUT		(10*HZ)
@@ -645,11 +647,14 @@ static int __scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
 static int scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
 {
 	/*
-	 * scsi_done was called just after the command timed out and before
-	 * we had a chance to process it. (db)
+	 * Use the struct request atomic_flags here to check if
+	 * block/blk.h:blk_mark_rq_complete() has already been called
+	 * from the block softirq
 	 */
-	if (scmd->serial_number == 0)
+	if ((blk_test_rq_complete(scmd->request)) &&
+	    (scmd->eh_eflags & SCSI_EH_SOFTIRQ_DONE))
 		return SUCCESS;
+
 	return __scsi_try_to_abort_cmd(scmd);
 }
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8041fe1..7e3c477 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1402,6 +1402,12 @@ static void scsi_softirq_done(struct request *rq)
 	int disposition;
 
 	INIT_LIST_HEAD(&cmd->eh_entry);
+	/*
+	 * Set the SCSI_EH_SOFTIRQ_DONE flag to signal scsi_error.c:
+	 * scsi_try_to_abort_cmd() that this cmd has reached
+	 * scsi_softirq_done()
+	 */
+	cmd->eh_eflags |= SCSI_EH_SOFTIRQ_DONE;
 
 	/*
 	 * Set the serial numbers back to zero
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index b4056d1..2f64350 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -17,6 +17,7 @@ struct scsi_nl_hdr;
  * Scsi Error Handler Flags
  */
 #define SCSI_EH_CANCEL_CMD	0x0001	/* Cancel this cmd */
+#define SCSI_EH_SOFTIRQ_DONE	0x0002	/* cmd reached scsi_softirq_done() */
 
 #define SCSI_SENSE_VALID(scmd) \
 	(((scmd)->sense_buffer[0] & 0x70) == 0x70)
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 5d9fdee..ea20906 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1255,6 +1255,12 @@ static int u14_34f_queuecommand(struct scsi_cmnd *SCpnt, void (*done)(struct scs
    /* j is the board number */
    j = ((struct hostdata *) SCpnt->device->host->hostdata)->board_number;
 
+   /*
+    * Call scsi_cmd_get_serial() because we need a valid serial number
+    * for reorder().
+    */
+   scsi_cmd_get_serial(SCpnt);
+
    if (SCpnt->host_scribble)
       panic("%s: qcomm, pid %ld, SCpnt %p already active.\n",
             BN(j), SCpnt->serial_number, SCpnt);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 15b77b8..8d281d8 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1187,7 +1187,7 @@ extern struct device_attribute *ata_common_sdev_attrs[];
 	.module			= THIS_MODULE,			\
 	.name			= drv_name,			\
 	.ioctl			= ata_scsi_ioctl,		\
-	.queuecommand		= ata_scsi_queuecmd,		\
+	.queuecommand_unlocked	= ata_scsi_queuecmd,		\
 	.can_queue		= ATA_DEF_QUEUE,		\
 	.this_id		= ATA_SHT_THIS_ID,		\
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,		\
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a5e885a..bbba4fa 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -136,6 +136,7 @@ extern struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *, gfp_t);
 extern void scsi_put_command(struct scsi_cmnd *);
 extern void __scsi_put_command(struct Scsi_Host *, struct scsi_cmnd *,
 			       struct device *);
+extern void scsi_cmd_get_serial(struct scsi_cmnd *);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 
 extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index d0a6a84..d741cf2 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -106,6 +106,12 @@ struct scsi_host_template {
 	 * command before queuecommand returns, but in this case you
 	 * *must* return 0 from queuecommand).
 	 *
+	 * Note that queuecommand() is the function used by legacy
+	 * LLDs that require struct Scsi_Host->host_lock be held while
+	 * dispatching struct scsi_cmnd descriptors.  Modern LLDs that
+	 * do not have this requirement run in 'host_lock-less' mode
+	 * using queuecommand_unlocked below.
+	 *
 	 * Queuecommand may also reject the command, in which case it may
 	 * not touch the command and must not call done() for it.
 	 *
@@ -131,6 +137,18 @@ struct scsi_host_template {
 			     void (*done)(struct scsi_cmnd *));
 
 	/*
+	 * The queuecommand_unlocked() function that provides an opitional
+	 * method of struct Scsi_Host->host_lock less dispatch of
+	 * struct scsi_cmnd descriptors.
+	 *
+	 * Note that this API caller is otherwise expected to function the
+	 * exact same as the legacy queuecommand().
+	 *
+	 * STATUS: OPTIONAL
+	 */
+	int (* queuecommand_unlocked)(struct scsi_cmnd *,
+				void (*done)(struct scsi_cmnd *));
+	/*
 	 * The transfer functions are used to queue a scsi command to
 	 * the LLD. When the driver is finished processing the command
 	 * the done callback is invoked.
@@ -604,10 +622,9 @@ struct Scsi_Host {
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

