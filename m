From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 07/12] qla2xxx: Convert to host_lock less w/ interrupts
	disabled externally
Date: Sun, 19 Dec 2010 16:11:14 -0700
Message-ID: <20101219231114.GI1263@parisc-linux.org>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org> <1292793727-31957-8-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1292793727-31957-8-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Mike Anderson <andmike@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Douglas Gilbert <dgilbert@interlog.com>, adam radford <aradford@gmail.com>, Kashyap Desai <Kashyap.Desai@lsi.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, Dec 19, 2010 at 01:22:02PM -0800, Nicholas A. Bellinger wrote:
> This patch converts qla2xxx to run in host_lock less mode with the new
> IRQ_DISABLE_SCSI_QCMD() that disables interrupts while calling ->queuecommand()
> dispatch.  It also drops the legacy host_lock unlock optimization.

I'm not sure this is the right direction to go.  Now that Jeff's done
the pushdown and put in the compatibility macros, I don't think it makes
sense to do another partial transition on each driver.  Much better to
take our time, analyse each driver thoroughly, and kill the DEF_SCSI_QCMD
in each driver without introducing IRQ_DISABLE_SCSI_QCMD.

In particular for this driver, it explicitly re-enables interrupts,
so it's pretty easy to do a full conversion.  Compile-tested only.

Convert qla2xxx driver to run without the shost lock

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2c0876c..b44d986 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -513,7 +513,7 @@ qla24xx_fw_version_str(struct scsi_qla_host *vha, char *str)
 
 static inline srb_t *
 qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
-    struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
+    struct scsi_cmnd *cmd)
 {
 	srb_t *sp;
 	struct qla_hw_data *ha = vha->hw;
@@ -527,16 +527,15 @@ qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
 	sp->cmd = cmd;
 	sp->flags = 0;
 	CMD_SP(cmd) = (void *)sp;
-	cmd->scsi_done = done;
 	sp->ctx = NULL;
 
 	return sp;
 }
 
 static int
-qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
+qla2xxx_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 {
-	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
+	scsi_qla_host_t *vha = shost_priv(shost);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmd->device));
 	struct qla_hw_data *ha = vha->hw;
@@ -544,7 +543,6 @@ qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *)
 	srb_t *sp;
 	int rval;
 
-	spin_unlock_irq(vha->host->host_lock);
 	if (ha->flags.eeh_busy) {
 		if (ha->flags.pci_channel_io_perm_failure)
 			cmd->result = DID_NO_CONNECT << 16;
@@ -577,39 +575,32 @@ qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *)
 		goto qc24_target_busy;
 	}
 
-	sp = qla2x00_get_new_sp(base_vha, fcport, cmd, done);
+	sp = qla2x00_get_new_sp(base_vha, fcport, cmd);
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
-	spin_lock_irq(vha->host->host_lock);
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
 qc24_fail_command:
-	spin_lock_irq(vha->host->host_lock);
-	done(cmd);
+	cmd->scsi_done(cmd);
 
 	return 0;
 }
 
-static DEF_SCSI_QCMD(qla2xxx_queuecommand)
-
 
 /*
  * qla2x00_eh_wait_on_command

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
