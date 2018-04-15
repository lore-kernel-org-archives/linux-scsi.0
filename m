From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 4.16+ merge window
Date: Sun, 15 Apr 2018 10:10:30 +0100
Message-ID: <1523783430.3180.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a set of minor (and safe changes) that didn't make the initial
pull request plus some bug fixes.  The status handling code is actually
a running regression from the previous merge window which had an
incomplete fix (now reverted) and most of the remaining bug fixes are
for problems older than the current merge window.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (3):
      scsi: core: Make scsi_result_to_blk_status() recognize CONDITION MET
      scsi: core: Rename __scsi_error_from_host_byte() into scsi_result_to_blk_status()
      Revert "scsi: core: return BLK_STS_OK for DID_OK in __scsi_error_from_host_byte()"

Ben Hutchings (2):
      scsi: qla2xxx: Fix race condition between iocb timeout and initialisation
      scsi: qla2xxx: Avoid double completion of abort command

Bill Kuzeja (1):
      scsi: qla2xxx: Fix small memory leak in qla2x00_probe_one on probe failure

Colin Ian King (1):
      scsi: core: remove redundant assignment to shost->use_blk_mq

Dan Carpenter (2):
      scsi: cxgb4i: silence overflow warning in t4_uld_rx_handler()
      scsi: dpt_i2o: Use after free in I2ORESETCMD ioctl

Dave Carroll (1):
      scsi: aacraid: Insure command thread is not recursively stopped

Johannes Thumshirn (3):
      scsi: qla2xxx: Correct setting of SAM_STAT_CHECK_CONDITION
      scsi: qla2xxx: correctly shift host byte
      scsi: scsi_dh: Don't look for NULL devices handlers by name

Ross Lagerwall (1):
      scsi: devinfo: Add Microsoft iSCSI target to 1024 sector blacklist

And the diffstat:

 drivers/scsi/aacraid/commsup.c     |  4 +++-
 drivers/scsi/aacraid/linit.c       |  1 +
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |  8 +++----
 drivers/scsi/dpt_i2o.c             | 13 ++++++-----
 drivers/scsi/hosts.c               |  1 -
 drivers/scsi/qla2xxx/qla_gs.c      | 12 ++++++-----
 drivers/scsi/qla2xxx/qla_init.c    | 41 +++++++++++++++++++++--------------
 drivers/scsi/qla2xxx/qla_inline.h  |  2 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |  8 ++++---
 drivers/scsi/qla2xxx/qla_isr.c     |  8 +++----
 drivers/scsi/qla2xxx/qla_mbx.c     |  8 +++----
 drivers/scsi/qla2xxx/qla_mid.c     |  2 +-
 drivers/scsi/qla2xxx/qla_mr.c      |  5 +++--
 drivers/scsi/qla2xxx/qla_os.c      | 44 ++++++++++++++++++--------------------
 drivers/scsi/qla2xxx/qla_target.c  |  2 +-
 drivers/scsi/scsi_devinfo.c        |  2 +-
 drivers/scsi/scsi_dh.c             |  3 +++
 drivers/scsi/scsi_lib.c            | 27 ++++++++++++++---------
 18 files changed, 109 insertions(+), 82 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 84858d5c8257..0156c9623c35 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1502,9 +1502,10 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	host = aac->scsi_host_ptr;
 	scsi_block_requests(host);
 	aac_adapter_disable_int(aac);
-	if (aac->thread->pid != current->pid) {
+	if (aac->thread && aac->thread->pid != current->pid) {
 		spin_unlock_irq(host->host_lock);
 		kthread_stop(aac->thread);
+		aac->thread = NULL;
 		jafo = 1;
 	}
 
@@ -1591,6 +1592,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 					  aac->name);
 		if (IS_ERR(aac->thread)) {
 			retval = PTR_ERR(aac->thread);
+			aac->thread = NULL;
 			goto out;
 		}
 	}
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 2664ea0df35f..f24fb942065d 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1562,6 +1562,7 @@ static void __aac_shutdown(struct aac_dev * aac)
 				up(&fib->event_wait);
 		}
 		kthread_stop(aac->thread);
+		aac->thread = NULL;
 	}
 
 	aac_send_shutdown(aac);
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 406e94312d4e..211da1d5a869 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -2108,12 +2108,12 @@ static int t4_uld_rx_handler(void *handle, const __be64 *rsp,
 	log_debug(1 << CXGBI_DBG_TOE,
 		"cdev %p, opcode 0x%x(0x%x,0x%x), skb %p.\n",
 		 cdev, opc, rpl->ot.opcode_tid, ntohl(rpl->ot.opcode_tid), skb);
-	if (cxgb4i_cplhandlers[opc])
-		cxgb4i_cplhandlers[opc](cdev, skb);
-	else {
+	if (opc >= ARRAY_SIZE(cxgb4i_cplhandlers) || !cxgb4i_cplhandlers[opc]) {
 		pr_err("No handler for opcode 0x%x.\n", opc);
 		__kfree_skb(skb);
-	}
+	} else
+		cxgb4i_cplhandlers[opc](cdev, skb);
+
 	return 0;
 nomem:
 	log_debug(1 << CXGBI_DBG_TOE, "OOM bailing out.\n");
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 6866975b25f3..5ceea8da7bb6 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -2051,13 +2051,16 @@ static int adpt_ioctl(struct inode *inode, struct file *file, uint cmd, ulong ar
 		}
 		break;
 		}
-	case I2ORESETCMD:
-		if(pHba->host)
-			spin_lock_irqsave(pHba->host->host_lock, flags);
+	case I2ORESETCMD: {
+		struct Scsi_Host *shost = pHba->host;
+
+		if (shost)
+			spin_lock_irqsave(shost->host_lock, flags);
 		adpt_hba_reset(pHba);
-		if(pHba->host)
-			spin_unlock_irqrestore(pHba->host->host_lock, flags);
+		if (shost)
+			spin_unlock_irqrestore(shost->host_lock, flags);
 		break;
+	}
 	case I2ORESCANCMD:
 		adpt_rescan(pHba);
 		break;
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 7649d63a1b8d..3771e59a9fae 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -472,7 +472,6 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	else
 		shost->dma_boundary = 0xffffffff;
 
-	shost->use_blk_mq = scsi_use_blk_mq;
 	shost->use_blk_mq = scsi_use_blk_mq || shost->hostt->force_blk_mq;
 
 	device_initialize(&shost->shost_gendev);
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 2288757b5c9e..9e914f9c3ffb 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3794,6 +3794,7 @@ int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
 
+	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
 
 	/* CT_IU preamble  */
@@ -3812,7 +3813,6 @@ int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	sp->u.iocb_cmd.u.ctarg.rsp_size = GFF_ID_RSP_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
 
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
 	sp->done = qla24xx_async_gffid_sp_done;
 
 	rval = qla2x00_start_sp(sp);
@@ -4230,6 +4230,8 @@ static int qla24xx_async_gnnft(scsi_qla_host_t *vha, struct srb *sp,
 	sp->name = "gnnft";
 	sp->gen1 = vha->hw->base_qpair->chip_reset;
 	sp->gen2 = fc4_type;
+
+	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
 
 	memset(sp->u.iocb_cmd.u.ctarg.rsp, 0, sp->u.iocb_cmd.u.ctarg.rsp_size);
@@ -4246,7 +4248,6 @@ static int qla24xx_async_gnnft(scsi_qla_host_t *vha, struct srb *sp,
 	sp->u.iocb_cmd.u.ctarg.req_size = GNN_FT_REQ_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
 
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
 	sp->done = qla2x00_async_gpnft_gnnft_sp_done;
 
 	rval = qla2x00_start_sp(sp);
@@ -4370,6 +4371,8 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
 	sp->name = "gpnft";
 	sp->gen1 = vha->hw->base_qpair->chip_reset;
 	sp->gen2 = fc4_type;
+
+	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
 
 	rspsz = sizeof(struct ct_sns_gpnft_rsp) +
@@ -4385,7 +4388,6 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
 
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
 
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
 	sp->done = qla2x00_async_gpnft_gnnft_sp_done;
 
 	rval = qla2x00_start_sp(sp);
@@ -4495,6 +4497,7 @@ int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
 
+	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
 
 	/* CT_IU preamble  */
@@ -4516,7 +4519,6 @@ int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	sp->u.iocb_cmd.u.ctarg.rsp_size = GNN_ID_RSP_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
 
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
 	sp->done = qla2x00_async_gnnid_sp_done;
 
 	rval = qla2x00_start_sp(sp);
@@ -4632,6 +4634,7 @@ int qla24xx_async_gfpnid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
 
+	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
 
 	/* CT_IU preamble  */
@@ -4653,7 +4656,6 @@ int qla24xx_async_gfpnid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	sp->u.iocb_cmd.u.ctarg.rsp_size = GFPN_ID_RSP_SIZE;
 	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
 
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
 	sp->done = qla2x00_async_gfpnid_sp_done;
 
 	rval = qla2x00_start_sp(sp);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8aeb0ed524a1..8f55dd44adae 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -183,10 +183,11 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 	sp->name = "login";
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
 
 	lio = &sp->u.iocb_cmd;
 	lio->timeout = qla2x00_async_iocb_timeout;
+	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+
 	sp->done = qla2x00_async_login_sp_done;
 	lio->u.logio.flags |= SRB_LOGIN_COND_PLOGI;
 
@@ -245,10 +246,11 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
 
 	sp->type = SRB_LOGOUT_CMD;
 	sp->name = "logout";
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
 
 	lio = &sp->u.iocb_cmd;
 	lio->timeout = qla2x00_async_iocb_timeout;
+	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+
 	sp->done = qla2x00_async_logout_sp_done;
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS)
@@ -307,10 +309,11 @@ qla2x00_async_prlo(struct scsi_qla_host *vha, fc_port_t *fcport)
 
 	sp->type = SRB_PRLO_CMD;
 	sp->name = "prlo";
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
 
 	lio = &sp->u.iocb_cmd;
 	lio->timeout = qla2x00_async_iocb_timeout;
+	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+
 	sp->done = qla2x00_async_prlo_sp_done;
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS)
@@ -412,10 +415,11 @@ qla2x00_async_adisc(struct scsi_qla_host *vha, fc_port_t *fcport,
 
 	sp->type = SRB_ADISC_CMD;
 	sp->name = "adisc";
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
 
 	lio = &sp->u.iocb_cmd;
 	lio->timeout = qla2x00_async_iocb_timeout;
+	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+
 	sp->done = qla2x00_async_adisc_sp_done;
 	if (data[1] & QLA_LOGIO_LOGIN_RETRIED)
 		lio->u.logio.flags |= SRB_LOGIN_RETRIED;
@@ -745,6 +749,8 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
 
+	mbx = &sp->u.iocb_cmd;
+	mbx->timeout = qla2x00_async_iocb_timeout;
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha)+2);
 
 	mb = sp->u.iocb_cmd.u.mbx.out_mb;
@@ -757,9 +763,6 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 	mb[8] = vha->gnl.size;
 	mb[9] = vha->vp_idx;
 
-	mbx = &sp->u.iocb_cmd;
-	mbx->timeout = qla2x00_async_iocb_timeout;
-
 	sp->done = qla24xx_async_gnl_sp_done;
 
 	rval = qla2x00_start_sp(sp);
@@ -887,10 +890,11 @@ qla24xx_async_prli(struct scsi_qla_host *vha, fc_port_t *fcport)
 
 	sp->type = SRB_PRLI_CMD;
 	sp->name = "prli";
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
 
 	lio = &sp->u.iocb_cmd;
 	lio->timeout = qla2x00_async_iocb_timeout;
+	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+
 	sp->done = qla2x00_async_prli_sp_done;
 	lio->u.logio.flags = 0;
 
@@ -955,6 +959,9 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
 	sp->name = "gpdb";
 	sp->gen1 = fcport->rscn_gen;
 	sp->gen2 = fcport->login_gen;
+
+	mbx = &sp->u.iocb_cmd;
+	mbx->timeout = qla2x00_async_iocb_timeout;
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
 
 	pd = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &pd_dma);
@@ -974,8 +981,6 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
 	mb[9] = vha->vp_idx;
 	mb[10] = opt;
 
-	mbx = &sp->u.iocb_cmd;
-	mbx->timeout = qla2x00_async_iocb_timeout;
 	mbx->u.mbx.in = (void *)pd;
 	mbx->u.mbx.in_dma = pd_dma;
 
@@ -1490,13 +1495,15 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 	tm_iocb = &sp->u.iocb_cmd;
 	sp->type = SRB_TM_CMD;
 	sp->name = "tmf";
+
+	tm_iocb->timeout = qla2x00_tmf_iocb_timeout;
+	init_completion(&tm_iocb->u.tmf.comp);
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha));
+
 	tm_iocb->u.tmf.flags = flags;
 	tm_iocb->u.tmf.lun = lun;
 	tm_iocb->u.tmf.data = tag;
 	sp->done = qla2x00_tmf_sp_done;
-	tm_iocb->timeout = qla2x00_tmf_iocb_timeout;
-	init_completion(&tm_iocb->u.tmf.comp);
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS)
@@ -1550,8 +1557,8 @@ qla24xx_abort_sp_done(void *ptr, int res)
 	srb_t *sp = ptr;
 	struct srb_iocb *abt = &sp->u.iocb_cmd;
 
-	del_timer(&sp->u.iocb_cmd.timer);
-	complete(&abt->u.abt.comp);
+	if (del_timer(&sp->u.iocb_cmd.timer))
+		complete(&abt->u.abt.comp);
 }
 
 int
@@ -1570,7 +1577,11 @@ qla24xx_async_abort_cmd(srb_t *cmd_sp)
 	abt_iocb = &sp->u.iocb_cmd;
 	sp->type = SRB_ABT_CMD;
 	sp->name = "abort";
+
+	abt_iocb->timeout = qla24xx_abort_iocb_timeout;
+	init_completion(&abt_iocb->u.abt.comp);
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha));
+
 	abt_iocb->u.abt.cmd_hndl = cmd_sp->handle;
 
 	if (vha->flags.qpairs_available && cmd_sp->qpair)
@@ -1580,8 +1591,6 @@ qla24xx_async_abort_cmd(srb_t *cmd_sp)
 		abt_iocb->u.abt.req_que_no = cpu_to_le16(vha->req->id);
 
 	sp->done = qla24xx_abort_sp_done;
-	abt_iocb->timeout = qla24xx_abort_iocb_timeout;
-	init_completion(&abt_iocb->u.abt.comp);
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS)
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index b7a05aebf065..37ae0f6d8ae5 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -272,13 +272,13 @@ qla2x00_init_timer(srb_t *sp, unsigned long tmo)
 {
 	timer_setup(&sp->u.iocb_cmd.timer, qla2x00_sp_timeout, 0);
 	sp->u.iocb_cmd.timer.expires = jiffies + tmo * HZ;
-	add_timer(&sp->u.iocb_cmd.timer);
 	sp->free = qla2x00_sp_free;
 	init_completion(&sp->comp);
 	if (IS_QLAFX00(sp->vha->hw) && (sp->type == SRB_FXIOCB_DCMD))
 		init_completion(&sp->u.iocb_cmd.u.fxiocb.fxiocb_comp);
 	if (sp->type == SRB_ELS_DCMD)
 		init_completion(&sp->u.iocb_cmd.u.els_logo.comp);
+	add_timer(&sp->u.iocb_cmd.timer);
 }
 
 static inline int
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index f74ff7b550b6..a91cca52b5d5 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2460,8 +2460,8 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	sp->type = SRB_ELS_DCMD;
 	sp->name = "ELS_DCMD";
 	sp->fcport = fcport;
-	qla2x00_init_timer(sp, ELS_DCMD_TIMEOUT);
 	elsio->timeout = qla2x00_els_dcmd_iocb_timeout;
+	qla2x00_init_timer(sp, ELS_DCMD_TIMEOUT);
 	sp->done = qla2x00_els_dcmd_sp_done;
 	sp->free = qla2x00_els_dcmd_sp_free;
 
@@ -2658,8 +2658,11 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	sp->type = SRB_ELS_DCMD;
 	sp->name = "ELS_DCMD";
 	sp->fcport = fcport;
-	qla2x00_init_timer(sp, ELS_DCMD_TIMEOUT);
+
 	elsio->timeout = qla2x00_els_dcmd2_iocb_timeout;
+	init_completion(&elsio->u.els_plogi.comp);
+	qla2x00_init_timer(sp, ELS_DCMD_TIMEOUT);
+
 	sp->done = qla2x00_els_dcmd2_sp_done;
 	sp->free = qla2x00_els_dcmd2_sp_free;
 
@@ -2696,7 +2699,6 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	ql_dump_buffer(ql_dbg_io + ql_dbg_buffer, vha, 0x0109,
 	    (uint8_t *)elsio->u.els_plogi.els_plogi_pyld, 0x70);
 
-	init_completion(&elsio->u.els_plogi.comp);
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 7cacdc3408fa..a3dc83f9444d 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2174,7 +2174,7 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 		    0x10, 0x1);
 		set_driver_byte(cmd, DRIVER_SENSE);
 		set_host_byte(cmd, DID_ABORT);
-		cmd->result |= SAM_STAT_CHECK_CONDITION << 1;
+		cmd->result |= SAM_STAT_CHECK_CONDITION;
 		return 1;
 	}
 
@@ -2184,7 +2184,7 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 		    0x10, 0x3);
 		set_driver_byte(cmd, DRIVER_SENSE);
 		set_host_byte(cmd, DID_ABORT);
-		cmd->result |= SAM_STAT_CHECK_CONDITION << 1;
+		cmd->result |= SAM_STAT_CHECK_CONDITION;
 		return 1;
 	}
 
@@ -2194,7 +2194,7 @@ qla2x00_handle_dif_error(srb_t *sp, struct sts_entry_24xx *sts24)
 		    0x10, 0x2);
 		set_driver_byte(cmd, DRIVER_SENSE);
 		set_host_byte(cmd, DID_ABORT);
-		cmd->result |= SAM_STAT_CHECK_CONDITION << 1;
+		cmd->result |= SAM_STAT_CHECK_CONDITION;
 		return 1;
 	}
 
@@ -2347,7 +2347,7 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
 	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
 	/* Always return DID_OK, bsg will send the vendor specific response
 	 * in this case only */
-	sp->done(sp, DID_OK << 6);
+	sp->done(sp, DID_OK << 16);
 
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 5db0262d5c94..d8a36c13aeda 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -6023,14 +6023,14 @@ int qla24xx_send_mb_cmd(struct scsi_qla_host *vha, mbx_cmd_t *mcp)
 	sp->type = SRB_MB_IOCB;
 	sp->name = mb_to_str(mcp->mb[0]);
 
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
-
-	memcpy(sp->u.iocb_cmd.u.mbx.out_mb, mcp->mb, SIZEOF_IOCB_MB_REG);
-
 	c = &sp->u.iocb_cmd;
 	c->timeout = qla2x00_async_iocb_timeout;
 	init_completion(&c->u.mbx.comp);
 
+	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
+
+	memcpy(sp->u.iocb_cmd.u.mbx.out_mb, mcp->mb, SIZEOF_IOCB_MB_REG);
+
 	sp->done = qla2x00_async_mb_sp_done;
 
 	rval = qla2x00_start_sp(sp);
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index da85cd89639f..f6f0a759a7c2 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -929,8 +929,8 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	sp->type = SRB_CTRL_VP;
 	sp->name = "ctrl_vp";
 	sp->done = qla_ctrlvp_sp_done;
-	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
 	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
+	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
 	sp->u.iocb_cmd.u.ctrlvp.cmd = cmd;
 	sp->u.iocb_cmd.u.ctrlvp.vp_index = vp_index;
 
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 7113acf42ff3..521a51370554 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1821,9 +1821,11 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 
 	sp->type = SRB_FXIOCB_DCMD;
 	sp->name = "fxdisc";
-	qla2x00_init_timer(sp, FXDISC_TIMEOUT);
 
 	fdisc = &sp->u.iocb_cmd;
+	fdisc->timeout = qla2x00_fxdisc_iocb_timeout;
+	qla2x00_init_timer(sp, FXDISC_TIMEOUT);
+
 	switch (fx_type) {
 	case FXDISC_GET_CONFIG_INFO:
 	fdisc->u.fxiocb.flags =
@@ -1924,7 +1926,6 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 			goto done_unmap_req;
 	}
 
-	fdisc->timeout = qla2x00_fxdisc_iocb_timeout;
 	fdisc->u.fxiocb.req_func_type = cpu_to_le16(fx_type);
 	sp->done = qla2x00_fxdisc_sp_done;
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2bbf0bff0da0..15eaa6dded04 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -470,9 +470,6 @@ static int qla2x00_alloc_queues(struct qla_hw_data *ha, struct req_que *req,
 
 static void qla2x00_free_req_que(struct qla_hw_data *ha, struct req_que *req)
 {
-	if (!ha->req_q_map)
-		return;
-
 	if (IS_QLAFX00(ha)) {
 		if (req && req->ring_fx00)
 			dma_free_coherent(&ha->pdev->dev,
@@ -483,17 +480,14 @@ static void qla2x00_free_req_que(struct qla_hw_data *ha, struct req_que *req)
 		(req->length + 1) * sizeof(request_t),
 		req->ring, req->dma);
 
-	if (req) {
+	if (req)
 		kfree(req->outstanding_cmds);
-		kfree(req);
-	}
+
+	kfree(req);
 }
 
 static void qla2x00_free_rsp_que(struct qla_hw_data *ha, struct rsp_que *rsp)
 {
-	if (!ha->rsp_q_map)
-		return;
-
 	if (IS_QLAFX00(ha)) {
 		if (rsp && rsp->ring_fx00)
 			dma_free_coherent(&ha->pdev->dev,
@@ -504,8 +498,7 @@ static void qla2x00_free_rsp_que(struct qla_hw_data *ha, struct rsp_que *rsp)
 		(rsp->length + 1) * sizeof(response_t),
 		rsp->ring, rsp->dma);
 	}
-	if (rsp)
-		kfree(rsp);
+	kfree(rsp);
 }
 
 static void qla2x00_free_queues(struct qla_hw_data *ha)
@@ -3106,7 +3099,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto probe_failed;
 
 	/* Alloc arrays of request and response ring ptrs */
-	if (qla2x00_alloc_queues(ha, req, rsp)) {
+	ret = qla2x00_alloc_queues(ha, req, rsp);
+	if (ret) {
 		ql_log(ql_log_fatal, base_vha, 0x003d,
 		    "Failed to allocate memory for queue pointers..."
 		    "aborting.\n");
@@ -3407,8 +3401,15 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	qla2x00_free_device(base_vha);
-
 	scsi_host_put(base_vha->host);
+	/*
+	 * Need to NULL out local req/rsp after
+	 * qla2x00_free_device => qla2x00_free_queues frees
+	 * what these are pointing to. Or else we'll
+	 * fall over below in qla2x00_free_req/rsp_que.
+	 */
+	req = NULL;
+	rsp = NULL;
 
 probe_hw_failed:
 	qla2x00_mem_free(ha);
@@ -4114,6 +4115,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	(*rsp)->dma = 0;
 fail_rsp_ring:
 	kfree(*rsp);
+	*rsp = NULL;
 fail_rsp:
 	dma_free_coherent(&ha->pdev->dev, ((*req)->length + 1) *
 		sizeof(request_t), (*req)->ring, (*req)->dma);
@@ -4121,6 +4123,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	(*req)->dma = 0;
 fail_req_ring:
 	kfree(*req);
+	*req = NULL;
 fail_req:
 	dma_free_coherent(&ha->pdev->dev, sizeof(struct ct_sns_pkt),
 		ha->ct_sns, ha->ct_sns_dma);
@@ -4508,16 +4511,11 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 		dma_free_coherent(&ha->pdev->dev, ha->init_cb_size,
 			ha->init_cb, ha->init_cb_dma);
 
-	if (ha->optrom_buffer)
-		vfree(ha->optrom_buffer);
-	if (ha->nvram)
-		kfree(ha->nvram);
-	if (ha->npiv_info)
-		kfree(ha->npiv_info);
-	if (ha->swl)
-		kfree(ha->swl);
-	if (ha->loop_id_map)
-		kfree(ha->loop_id_map);
+	vfree(ha->optrom_buffer);
+	kfree(ha->nvram);
+	kfree(ha->npiv_info);
+	kfree(ha->swl);
+	kfree(ha->loop_id_map);
 
 	ha->srb_mempool = NULL;
 	ha->ctx_mempool = NULL;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 5546ac9c3d9d..025dc2d3f3de 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -664,10 +664,10 @@ int qla24xx_async_notify_ack(scsi_qla_host_t *vha, fc_port_t *fcport,
 	sp->type = type;
 	sp->name = "nack";
 
+	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha)+2);
 
 	sp->u.iocb_cmd.u.nack.ntfy = ntfy;
-	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
 	sp->done = qla2x00_async_nack_sp_done;
 
 	rval = qla2x00_start_sp(sp);
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index e5370d718058..dd107dc4db0e 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -202,7 +202,7 @@ static struct {
 	{"Medion", "Flash XL  MMC/SD", "2.6D", BLIST_FORCELUN},
 	{"MegaRAID", "LD", NULL, BLIST_FORCELUN},
 	{"MICROP", "4110", NULL, BLIST_NOTQ},
-	{"MSFT", "Virtual HD", NULL, BLIST_NO_RSOC},
+	{"MSFT", "Virtual HD", NULL, BLIST_MAX_1024 | BLIST_NO_RSOC},
 	{"MYLEX", "DACARMRB", "*", BLIST_REPORTLUN2},
 	{"nCipher", "Fastness Crypto", NULL, BLIST_FORCELUN},
 	{"NAKAMICH", "MJ-4.8S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index b88b5dbbc444..188f30572aa1 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -112,6 +112,9 @@ static struct scsi_device_handler *scsi_dh_lookup(const char *name)
 {
 	struct scsi_device_handler *dh;
 
+	if (!name || strlen(name) == 0)
+		return NULL;
+
 	dh = __scsi_dh_lookup(name);
 	if (!dh) {
 		request_module("scsi_dh_%s", name);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0dfec0dedd5e..e9b4f279d29c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -723,18 +723,25 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 }
 
 /**
- * __scsi_error_from_host_byte - translate SCSI error code into errno
- * @cmd:	SCSI command (unused)
+ * scsi_result_to_blk_status - translate a SCSI result code into blk_status_t
+ * @cmd:	SCSI command
  * @result:	scsi error code
  *
- * Translate SCSI error code into block errors.
+ * Translate a SCSI result code into a blk_status_t value. May reset the host
+ * byte of @cmd->result.
  */
-static blk_status_t __scsi_error_from_host_byte(struct scsi_cmnd *cmd,
-		int result)
+static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
 {
 	switch (host_byte(result)) {
 	case DID_OK:
-		return BLK_STS_OK;
+		/*
+		 * Also check the other bytes than the status byte in result
+		 * to handle the case when a SCSI LLD sets result to
+		 * DRIVER_SENSE << 24 without setting SAM_STAT_CHECK_CONDITION.
+		 */
+		if (scsi_status_is_good(result) && (result & ~0xff) == 0)
+			return BLK_STS_OK;
+		return BLK_STS_IOERR;
 	case DID_TRANSPORT_FAILFAST:
 		return BLK_STS_TRANSPORT;
 	case DID_TARGET_FAILURE:
@@ -812,10 +819,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 					    SCSI_SENSE_BUFFERSIZE);
 			}
 			if (!sense_deferred)
-				error = __scsi_error_from_host_byte(cmd, result);
+				error = scsi_result_to_blk_status(cmd, result);
 		}
 		/*
-		 * __scsi_error_from_host_byte may have reset the host_byte
+		 * scsi_result_to_blk_status may have reset the host_byte
 		 */
 		scsi_req(req)->result = cmd->result;
 		scsi_req(req)->resid_len = scsi_get_resid(cmd);
@@ -837,7 +844,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		 * good_bytes != blk_rq_bytes(req) as the signal for an error.
 		 * This sets the error explicitly for the problem case.
 		 */
-		error = __scsi_error_from_host_byte(cmd, result);
+		error = scsi_result_to_blk_status(cmd, result);
 	}
 
 	/* no bidi support for !blk_rq_is_passthrough yet */
@@ -907,7 +914,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	if (result == 0)
 		goto requeue;
 
-	error = __scsi_error_from_host_byte(cmd, result);
+	error = scsi_result_to_blk_status(cmd, result);
 
 	if (host_byte(result) == DID_RESET) {
 		/* Third party bus reset or reset for error recovery
