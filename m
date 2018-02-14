From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.16-rc1
Date: Wed, 14 Feb 2018 12:19:38 -0800
Message-ID: <1518639578.3223.44.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

These are mostly fixes for problems with merge window code.  In
addition we have one doc update (alua) and two dead code removals
(aiclib and octogon) a spurious assignment removal (csiostor) and a
performance improvement for storvsc involving better interrupt
spreading and increasing the command per lun handling.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (3):
      scsi: qla2xxx: Fix a locking imbalance in qlt_24xx_handle_els()
      scsi: scsi_dh: Document alua_rtpg_queue() arguments
      scsi: qla2xxx: Avoid triggering undefined behavior in qla2x00_mbx_completion()

Chad Dupuis (1):
      scsi: bnx2fc: Fix check in SCSI completion handler for timed out request

Colin Ian King (1):
      scsi: csiostor: remove redundant assignment to pointer 'ln'

Corentin Labbe (2):
      scsi: Remove Makefile entry for oktagon files
      scsi: aic7xxx: remove aiclib.c

Dan Carpenter (2):
      scsi: mptfusion: Add bounds check in mptctl_hp_targetinfo()
      scsi: sym53c8xx_2: iterator underflow in sym_getsync()

Himanshu Madhani (1):
      scsi: qla2xxx: Fix incorrect handle for abort IOCB

Michael Kelley (EOSG) (2):
      scsi: storvsc: Increase cmd_per_lun for higher speed devices
      scsi: storvsc: Spread interrupts when picking a channel for I/O requests

Quinn Tran (2):
      scsi: qla2xxx: Fix double free bug after firmware timeout
      scsi: qla2xxx: Fix memory corruption during hba reset test

Sujit Reddy Thumma (1):
      scsi: ufs: Enable quirk to ignore sending WRITE_SAME command

Tomas Henzl (1):
      scsi: mpt3sas: fix an out of bound write

Tyrel Datwyler (1):
      scsi: ibmvfc: fix misdefined reserved field in ibmvfc_fcp_rsp_info

and diffstat:

 drivers/message/fusion/mptctl.c            |  2 ++
 drivers/scsi/Makefile                      |  1 -
 drivers/scsi/aic7xxx/aiclib.c              | 34 ------------------------------
 drivers/scsi/bnx2fc/bnx2fc_io.c            |  1 +
 drivers/scsi/csiostor/csio_lnode.c         |  2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c |  5 +++++
 drivers/scsi/ibmvscsi/ibmvfc.h             |  2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c        |  5 ++++-
 drivers/scsi/qla2xxx/qla_init.c            | 23 +++-----------------
 drivers/scsi/qla2xxx/qla_iocb.c            |  7 +++---
 drivers/scsi/qla2xxx/qla_isr.c             |  6 ++++--
 drivers/scsi/qla2xxx/qla_os.c              |  2 ++
 drivers/scsi/qla2xxx/qla_target.c          |  2 --
 drivers/scsi/storvsc_drv.c                 |  5 +++--
 drivers/scsi/sym53c8xx_2/sym_hipd.c        |  2 +-
 drivers/scsi/ufs/ufshcd.c                  |  2 ++
 16 files changed, 32 insertions(+), 69 deletions(-)
 delete mode 100644 drivers/scsi/aic7xxx/aiclib.c

With full diff below.

James

---

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 8d12017b9893..4470630dd545 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -2687,6 +2687,8 @@ mptctl_hp_targetinfo(unsigned long arg)
 				__FILE__, __LINE__, iocnum);
 		return -ENODEV;
 	}
+	if (karg.hdr.id >= MPT_MAX_FC_DEVICES)
+		return -EINVAL;
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mptctl_hp_targetinfo called.\n",
 	    ioc->name));
 
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index fcfd28d2884c..de1b3fce936d 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -185,7 +185,6 @@ ncr53c8xx-flags-$(CONFIG_SCSI_ZALON) \
 CFLAGS_ncr53c8xx.o	:= $(ncr53c8xx-flags-y) $(ncr53c8xx-flags-m)
 zalon7xx-objs	:= zalon.o ncr53c8xx.o
 NCR_Q720_mod-objs	:= NCR_Q720.o ncr53c8xx.o
-oktagon_esp_mod-objs	:= oktagon_esp.o oktagon_io.o
 
 # Files generated that shall be removed upon make clean
 clean-files :=	53c700_d.h 53c700_u.h
diff --git a/drivers/scsi/aic7xxx/aiclib.c b/drivers/scsi/aic7xxx/aiclib.c
deleted file mode 100644
index 828ae3d9a510..000000000000
--- a/drivers/scsi/aic7xxx/aiclib.c
+++ /dev/null
@@ -1,34 +0,0 @@
-/*
- * Implementation of Utility functions for all SCSI device types.
- *
- * Copyright (c) 1997, 1998, 1999 Justin T. Gibbs.
- * Copyright (c) 1997, 1998 Kenneth D. Merry.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions, and the following disclaimer,
- *    without modification, immediately at the beginning of the file.
- * 2. The name of the author may not be used to endorse or promote products
- *    derived from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR
- * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
- *
- * $FreeBSD: src/sys/cam/scsi/scsi_all.c,v 1.38 2002/09/23 04:56:35 mjacob Exp $
- * $Id$
- */
-
-#include "aiclib.h"
-
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 8e2f767147cb..5a645b8b9af1 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1889,6 +1889,7 @@ void bnx2fc_process_scsi_cmd_compl(struct bnx2fc_cmd *io_req,
 		/* we will not receive ABTS response for this IO */
 		BNX2FC_IO_DBG(io_req, "Timer context finished processing "
 			   "this scsi cmd\n");
+		return;
 	}
 
 	/* Cancel the timeout_work, as we received IO completion */
diff --git a/drivers/scsi/csiostor/csio_lnode.c b/drivers/scsi/csiostor/csio_lnode.c
index be5ee2d37815..7dbbbb81a1e7 100644
--- a/drivers/scsi/csiostor/csio_lnode.c
+++ b/drivers/scsi/csiostor/csio_lnode.c
@@ -114,7 +114,7 @@ static enum csio_ln_ev fwevt_to_lnevt[] = {
 static struct csio_lnode *
 csio_ln_lookup_by_portid(struct csio_hw *hw, uint8_t portid)
 {
-	struct csio_lnode *ln = hw->rln;
+	struct csio_lnode *ln;
 	struct list_head *tmp;
 
 	/* Match siblings lnode with portid */
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 022e421c2185..4b44325d1a82 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -876,6 +876,11 @@ static void alua_rtpg_work(struct work_struct *work)
 
 /**
  * alua_rtpg_queue() - cause RTPG to be submitted asynchronously
+ * @pg: ALUA port group associated with @sdev.
+ * @sdev: SCSI device for which to submit an RTPG.
+ * @qdata: Information about the callback to invoke after the RTPG.
+ * @force: Whether or not to submit an RTPG if a work item that will submit an
+ *         RTPG already has been scheduled.
  *
  * Returns true if and only if alua_rtpg_work() will be called asynchronously.
  * That function is responsible for calling @qdata->fn().
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 9a0696f68f37..b81a53c4a9a8 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -367,7 +367,7 @@ enum ibmvfc_fcp_rsp_info_codes {
 };
 
 struct ibmvfc_fcp_rsp_info {
-	__be16 reserved;
+	u8 reserved[3];
 	u8 rsp_code;
 	u8 reserved2[4];
 }__attribute__((packed, aligned (2)));
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 13d6e4ec3022..59a87ca328d3 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2410,8 +2410,11 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 				continue;
 			}
 
-			for_each_cpu(cpu, mask)
+			for_each_cpu_and(cpu, mask, cpu_online_mask) {
+				if (cpu >= ioc->cpu_msix_table_sz)
+					break;
 				ioc->cpu_msix_table[cpu] = reply_q->msix_index;
+			}
 		}
 		return;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index aececf664654..2dea1129d396 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -59,8 +59,6 @@ qla2x00_sp_timeout(struct timer_list *t)
 	req->outstanding_cmds[sp->handle] = NULL;
 	iocb = &sp->u.iocb_cmd;
 	iocb->timeout(sp);
-	if (sp->type != SRB_ELS_DCMD)
-		sp->free(sp);
 	spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
 }
 
@@ -102,7 +100,6 @@ qla2x00_async_iocb_timeout(void *data)
 	srb_t *sp = data;
 	fc_port_t *fcport = sp->fcport;
 	struct srb_iocb *lio = &sp->u.iocb_cmd;
-	struct event_arg ea;
 
 	if (fcport) {
 		ql_dbg(ql_dbg_disc, fcport->vha, 0x2071,
@@ -117,25 +114,13 @@ qla2x00_async_iocb_timeout(void *data)
 
 	switch (sp->type) {
 	case SRB_LOGIN_CMD:
-		if (!fcport)
-			break;
 		/* Retry as needed. */
 		lio->u.logio.data[0] = MBS_COMMAND_ERROR;
 		lio->u.logio.data[1] = lio->u.logio.flags & SRB_LOGIN_RETRIED ?
 			QLA_LOGIO_LOGIN_RETRIED : 0;
-		memset(&ea, 0, sizeof(ea));
-		ea.event = FCME_PLOGI_DONE;
-		ea.fcport = sp->fcport;
-		ea.data[0] = lio->u.logio.data[0];
-		ea.data[1] = lio->u.logio.data[1];
-		ea.sp = sp;
-		qla24xx_handle_plogi_done_event(fcport->vha, &ea);
+		sp->done(sp, QLA_FUNCTION_TIMEOUT);
 		break;
 	case SRB_LOGOUT_CMD:
-		if (!fcport)
-			break;
-		qlt_logo_completion_handler(fcport, QLA_FUNCTION_TIMEOUT);
-		break;
 	case SRB_CT_PTHRU_CMD:
 	case SRB_MB_IOCB:
 	case SRB_NACK_PLOGI:
@@ -235,12 +220,10 @@ static void
 qla2x00_async_logout_sp_done(void *ptr, int res)
 {
 	srb_t *sp = ptr;
-	struct srb_iocb *lio = &sp->u.iocb_cmd;
 
 	sp->fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
-	if (!test_bit(UNLOADING, &sp->vha->dpc_flags))
-		qla2x00_post_async_logout_done_work(sp->vha, sp->fcport,
-		    lio->u.logio.data);
+	sp->fcport->login_gen++;
+	qlt_logo_completion_handler(sp->fcport, res);
 	sp->free(sp);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 1b62e943ec49..8d00d559bd26 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3275,12 +3275,11 @@ qla24xx_abort_iocb(srb_t *sp, struct abort_entry_24xx *abt_iocb)
 	memset(abt_iocb, 0, sizeof(struct abort_entry_24xx));
 	abt_iocb->entry_type = ABORT_IOCB_TYPE;
 	abt_iocb->entry_count = 1;
-	abt_iocb->handle =
-	     cpu_to_le32(MAKE_HANDLE(aio->u.abt.req_que_no,
-		 aio->u.abt.cmd_hndl));
+	abt_iocb->handle = cpu_to_le32(MAKE_HANDLE(req->id, sp->handle));
 	abt_iocb->nport_handle = cpu_to_le16(sp->fcport->loop_id);
 	abt_iocb->handle_to_abort =
-	    cpu_to_le32(MAKE_HANDLE(req->id, aio->u.abt.cmd_hndl));
+	    cpu_to_le32(MAKE_HANDLE(aio->u.abt.req_que_no,
+				    aio->u.abt.cmd_hndl));
 	abt_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
 	abt_iocb->port_id[1] = sp->fcport->d_id.b.area;
 	abt_iocb->port_id[2] = sp->fcport->d_id.b.domain;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 14109d86c3f6..89f93ebd819d 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -272,7 +272,8 @@ qla2x00_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
 	/* Read all mbox registers? */
-	mboxes = (1 << ha->mbx_count) - 1;
+	WARN_ON_ONCE(ha->mbx_count > 32);
+	mboxes = (1ULL << ha->mbx_count) - 1;
 	if (!ha->mcp)
 		ql_dbg(ql_dbg_async, vha, 0x5001, "MBX pointer ERROR.\n");
 	else
@@ -2880,7 +2881,8 @@ qla24xx_mbx_completion(scsi_qla_host_t *vha, uint16_t mb0)
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
 	/* Read all mbox registers? */
-	mboxes = (1 << ha->mbx_count) - 1;
+	WARN_ON_ONCE(ha->mbx_count > 32);
+	mboxes = (1ULL << ha->mbx_count) - 1;
 	if (!ha->mcp)
 		ql_dbg(ql_dbg_async, vha, 0x504e, "MBX pointer ERROR.\n");
 	else
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 12ee6e02d146..afcb5567998a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3625,6 +3625,8 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	}
 	qla2x00_wait_for_hba_ready(base_vha);
 
+	qla2x00_wait_for_sess_deletion(base_vha);
+
 	/*
 	 * if UNLOAD flag is already set, then continue unload,
 	 * where it was set first.
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index fc89af8fe256..896b2d8bd803 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4871,8 +4871,6 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 				    sess);
 				qlt_send_term_imm_notif(vha, iocb, 1);
 				res = 0;
-				spin_lock_irqsave(&tgt->ha->tgt.sess_lock,
-				    flags);
 				break;
 			}
 
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index e07907d91d04..620510787763 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1310,7 +1310,8 @@ static int storvsc_do_io(struct hv_device *device,
 			 */
 			cpumask_and(&alloced_mask, &stor_device->alloced_cpus,
 				    cpumask_of_node(cpu_to_node(q_num)));
-			for_each_cpu(tgt_cpu, &alloced_mask) {
+			for_each_cpu_wrap(tgt_cpu, &alloced_mask,
+					outgoing_channel->target_cpu + 1) {
 				if (tgt_cpu != outgoing_channel->target_cpu) {
 					outgoing_channel =
 					stor_device->stor_chns[tgt_cpu];
@@ -1656,7 +1657,7 @@ static struct scsi_host_template scsi_driver = {
 	.eh_timed_out =		storvsc_eh_timed_out,
 	.slave_alloc =		storvsc_device_alloc,
 	.slave_configure =	storvsc_device_configure,
-	.cmd_per_lun =		255,
+	.cmd_per_lun =		2048,
 	.this_id =		-1,
 	.use_clustering =	ENABLE_CLUSTERING,
 	/* Make sure we dont get a sg segment crosses a page boundary */
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index ca360daa6a25..378af306fda1 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -536,7 +536,7 @@ sym_getsync(struct sym_hcb *np, u_char dt, u_char sfac, u_char *divp, u_char *fa
 	 *  Look for the greatest clock divisor that allows an 
 	 *  input speed faster than the period.
 	 */
-	while (div-- > 0)
+	while (--div > 0)
 		if (kpc >= (div_10M[div] << 2)) break;
 
 	/*
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 011c3369082c..8196976182c9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4352,6 +4352,8 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
 	/* REPORT SUPPORTED OPERATION CODES is not supported */
 	sdev->no_report_opcodes = 1;
 
+	/* WRITE_SAME command is not supported */
+	sdev->no_write_same = 1;
 
 	ufshcd_set_queue_depth(sdev);
 
