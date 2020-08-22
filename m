Return-Path: <SRS0=DDJn=CA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B8A4C433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Aug 2020 05:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77A3D208DB
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Aug 2020 05:48:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Ad3m1CFt";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="sYZLZkl3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgHVFsf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 Aug 2020 01:48:35 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46426 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725863AbgHVFsc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 Aug 2020 01:48:32 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 6C26C8EE3F2;
        Fri, 21 Aug 2020 22:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1598075310;
        bh=W6OM5RyrYrahFPwuAjc4kAJLRvt4bD+A4kwjN7nE/1o=;
        h=Subject:From:To:Cc:Date:From;
        b=Ad3m1CFtY0GnSqkKDROsUwEg2Qa2yLWxksebRhgFBmy/vUsHc1H9MpPtnwZLwLMb0
         xVf47beXhJ8WxVf5mxwZVGrMrrpkuO7hy1xa8L5JdRFFDSuj0JrpLv4QDCTymVPKee
         Ow6HAYDAgY5rH47Q85Md4QxKGDlDokLQV4VIHjzI=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8XQRnRLXNWtZ; Fri, 21 Aug 2020 22:48:29 -0700 (PDT)
Received: from [153.66.254.174] (c-73-35-198-56.hsd1.wa.comcast.net [73.35.198.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 6908A8EE10C;
        Fri, 21 Aug 2020 22:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1598075309;
        bh=W6OM5RyrYrahFPwuAjc4kAJLRvt4bD+A4kwjN7nE/1o=;
        h=Subject:From:To:Cc:Date:From;
        b=sYZLZkl30xjWb20dzUbSUK6x1D4nBQh//6lHxiWFHbgLqV9JxAxXw6Rlu29/f03jz
         U2khunmmNjuhQqeqDeBRpu0dcvneMmywQ2klmLYfItghO4JYykfrDgmCyh5MFV2ZS/
         Ot0qV2vkCWdBKGkRfacK7Fl8xxAdAe2J8ZxVBsLo=
Message-ID: <1598075304.3547.4.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.9-rc1
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Fri, 21 Aug 2020 22:48:24 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

23 fixes in 5 drivers (qla2xxx, ufs, scsi_debug, fcoe, zfcp).  The bulk
of the changes are in qla2xxx and ufs and all are mostly small and
definitely don't impact the core.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Adrian Hunter (3):
      scsi: ufs: Improve interrupt handling for shared interrupts
      scsi: ufs: Fix interrupt error message for shared interrupts
      scsi: ufs-pci: Add quirk for broken auto-hibernate for Intel EHL

Arun Easi (2):
      scsi: qla2xxx: Fix WARN_ON in qla_nvme_register_hba
      scsi: qla2xxx: Allow ql2xextended_error_logging special value 1 to be set anytime

Bean Huo (1):
      scsi: ufs: No need to send Abort Task if the task in DB was cleared

Douglas Gilbert (1):
      scsi: scsi_debug: Fix scp is NULL errors

Enzo Matsumiya (1):
      scsi: qla2xxx: Use MBX_TOV_SECONDS for mailbox command timeout values

Jing Xiangfeng (1):
      scsi: ufs: ti-j721e-ufs: Fix error return in ti_j721e_ufs_probe()

Mike Christie (1):
      scsi: fcoe: Fix I/O path allocation

Quinn Tran (7):
      Revert "scsi: qla2xxx: Disable T10-DIF feature with FC-NVMe during probe"
      scsi: qla2xxx: Fix null pointer access during disconnect from subsystem
      scsi: qla2xxx: Reduce noisy debug message
      scsi: qla2xxx: Fix login timeout
      scsi: qla2xxx: Indicate correct supported speeds for Mezz card
      scsi: qla2xxx: Flush I/O on zone disable
      scsi: qla2xxx: Flush all sessions on zone disable

Saurav Kashyap (2):
      Revert "scsi: qla2xxx: Fix crash on qla2x00_mailbox_command"
      scsi: qla2xxx: Check if FW supports MQ before enabling

Stanley Chu (3):
      scsi: ufs: Clean up completed request without interrupt notification
      scsi: ufs-mediatek: Fix incorrect time to wait link status
      scsi: ufs: Fix possible infinite loop in ufshcd_hold

Steffen Maier (1):
      scsi: zfcp: Fix use-after-free in request timeout handlers

And the diffstat:

 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c |  2 +-
 drivers/s390/scsi/zfcp_fsf.c                  |  4 +--
 drivers/scsi/qla2xxx/qla_dbg.h                |  3 ++
 drivers/scsi/qla2xxx/qla_def.h                |  1 +
 drivers/scsi/qla2xxx/qla_gs.c                 | 48 ++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_isr.c                |  4 +--
 drivers/scsi/qla2xxx/qla_mbx.c                | 22 ++++--------
 drivers/scsi/qla2xxx/qla_nvme.c               | 15 ++++++++-
 drivers/scsi/qla2xxx/qla_os.c                 |  9 ++---
 drivers/scsi/qla2xxx/qla_target.c             |  2 +-
 drivers/scsi/scsi_debug.c                     |  2 ++
 drivers/scsi/ufs/ti-j721e-ufs.c               |  1 +
 drivers/scsi/ufs/ufs-mediatek.c               |  2 +-
 drivers/scsi/ufs/ufshcd-pci.c                 | 16 +++++++--
 drivers/scsi/ufs/ufshcd.c                     | 31 +++++++++--------
 drivers/scsi/ufs/ufshcd.h                     |  9 ++++-
 16 files changed, 119 insertions(+), 52 deletions(-)

With full diff below.

James

---

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
index e67b1a59ecb7..0fcd82036d4e 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
@@ -193,7 +193,7 @@ static int ixgbe_fcoe_ddp_setup(struct net_device *netdev, u16 xid,
 	}
 
 	/* alloc the udl from per cpu ddp pool */
-	ddp->udl = dma_pool_alloc(ddp_pool->pool, GFP_KERNEL, &ddp->udp);
+	ddp->udl = dma_pool_alloc(ddp_pool->pool, GFP_ATOMIC, &ddp->udp);
 	if (!ddp->udl) {
 		e_err(drv, "failed allocated ddp context\n");
 		goto out_noddp_unmap;
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index c795f22249d8..140186fe1d1e 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -434,7 +434,7 @@ static void zfcp_fsf_req_complete(struct zfcp_fsf_req *req)
 		return;
 	}
 
-	del_timer(&req->timer);
+	del_timer_sync(&req->timer);
 	zfcp_fsf_protstatus_eval(req);
 	zfcp_fsf_fsfstatus_eval(req);
 	req->handler(req);
@@ -867,7 +867,7 @@ static int zfcp_fsf_req_send(struct zfcp_fsf_req *req)
 	req->qdio_req.qdio_outb_usage = atomic_read(&qdio->req_q_free);
 	req->issued = get_tod_clock();
 	if (zfcp_qdio_send(qdio, &req->qdio_req)) {
-		del_timer(&req->timer);
+		del_timer_sync(&req->timer);
 		/* lookup request again, list might have changed */
 		zfcp_reqlist_find_rm(adapter->req_list, req_id);
 		zfcp_erp_adapter_reopen(adapter, 0, "fsrs__1");
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 91eb6901815c..e1d7de63e8f8 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -380,5 +380,8 @@ extern int qla24xx_soft_reset(struct qla_hw_data *);
 static inline int
 ql_mask_match(uint level)
 {
+	if (ql2xextended_error_logging == 1)
+		ql2xextended_error_logging = QL_DBG_DEFAULT1_MASK;
+
 	return (level & ql2xextended_error_logging) == level;
 }
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 8c92af5e4390..1bc090d8a71b 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3880,6 +3880,7 @@ struct qla_hw_data {
 		uint32_t	scm_supported_f:1;
 				/* Enabled in Driver */
 		uint32_t	scm_enabled:1;
+		uint32_t	max_req_queue_warned:1;
 	} flags;
 
 	uint16_t max_exchg;
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index df670fba2ab8..de9fd7f688d0 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1505,11 +1505,11 @@ qla2x00_prep_ct_fdmi_req(struct ct_sns_pkt *p, uint16_t cmd,
 static uint
 qla25xx_fdmi_port_speed_capability(struct qla_hw_data *ha)
 {
+	uint speeds = 0;
+
 	if (IS_CNA_CAPABLE(ha))
 		return FDMI_PORT_SPEED_10GB;
 	if (IS_QLA28XX(ha) || IS_QLA27XX(ha)) {
-		uint speeds = 0;
-
 		if (ha->max_supported_speed == 2) {
 			if (ha->min_supported_speed <= 6)
 				speeds |= FDMI_PORT_SPEED_64GB;
@@ -1536,9 +1536,16 @@ qla25xx_fdmi_port_speed_capability(struct qla_hw_data *ha)
 		}
 		return speeds;
 	}
-	if (IS_QLA2031(ha))
-		return FDMI_PORT_SPEED_16GB|FDMI_PORT_SPEED_8GB|
-			FDMI_PORT_SPEED_4GB;
+	if (IS_QLA2031(ha)) {
+		if ((ha->pdev->subsystem_vendor == 0x103C) &&
+		    (ha->pdev->subsystem_device == 0x8002)) {
+			speeds = FDMI_PORT_SPEED_16GB;
+		} else {
+			speeds = FDMI_PORT_SPEED_16GB|FDMI_PORT_SPEED_8GB|
+				FDMI_PORT_SPEED_4GB;
+		}
+		return speeds;
+	}
 	if (IS_QLA25XX(ha))
 		return FDMI_PORT_SPEED_8GB|FDMI_PORT_SPEED_4GB|
 			FDMI_PORT_SPEED_2GB|FDMI_PORT_SPEED_1GB;
@@ -3436,7 +3443,6 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 			list_for_each_entry(fcport, &vha->vp_fcports, list) {
 				if ((fcport->flags & FCF_FABRIC_DEVICE) != 0) {
 					fcport->scan_state = QLA_FCPORT_SCAN;
-					fcport->logout_on_delete = 0;
 				}
 			}
 			goto login_logout;
@@ -3532,10 +3538,22 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 		}
 
 		if (fcport->scan_state != QLA_FCPORT_FOUND) {
+			bool do_delete = false;
+
+			if (fcport->scan_needed &&
+			    fcport->disc_state == DSC_LOGIN_PEND) {
+				/* Cable got disconnected after we sent
+				 * a login. Do delete to prevent timeout.
+				 */
+				fcport->logout_on_delete = 1;
+				do_delete = true;
+			}
+
 			fcport->scan_needed = 0;
-			if ((qla_dual_mode_enabled(vha) ||
-				qla_ini_mode_enabled(vha)) &&
-			    atomic_read(&fcport->state) == FCS_ONLINE) {
+			if (((qla_dual_mode_enabled(vha) ||
+			      qla_ini_mode_enabled(vha)) &&
+			    atomic_read(&fcport->state) == FCS_ONLINE) ||
+				do_delete) {
 				if (fcport->loop_id != FC_NO_LOOP_ID) {
 					if (fcport->flags & FCF_FCP2_DEVICE)
 						fcport->logout_on_delete = 0;
@@ -3736,6 +3754,18 @@ static void qla2x00_async_gpnft_gnnft_sp_done(srb_t *sp, int res)
 		unsigned long flags;
 		const char *name = sp->name;
 
+		if (res == QLA_OS_TIMER_EXPIRED) {
+			/* switch is ignoring all commands.
+			 * This might be a zone disable behavior.
+			 * This means we hit 64s timeout.
+			 * 22s GPNFT + 44s Abort = 64s
+			 */
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			       "%s: Switch Zone check please .\n",
+			       name);
+			qla2x00_mark_all_devices_lost(vha);
+		}
+
 		/*
 		 * We are in an Interrupt context, queue up this
 		 * sp for GNNFT_DONE work. This will allow all
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 27bcd346af7c..ab5275dbc338 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2024,8 +2024,8 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 				res = DID_ERROR << 16;
 			}
 		}
-		ql_dbg(ql_dbg_user, vha, 0x503f,
-		    "ELS IOCB Done -%s error hdl=%x comp_status=0x%x error subcode 1=0x%x error subcode 2=0x%x total_byte=0x%x\n",
+		ql_dbg(ql_dbg_disc, vha, 0x503f,
+		    "ELS IOCB Done -%s hdl=%x comp_status=0x%x error subcode 1=0x%x error subcode 2=0x%x total_byte=0x%x\n",
 		    type, sp->handle, comp_status, fw_status[1], fw_status[2],
 		    le32_to_cpu(ese->total_byte_count));
 		goto els_ct_done;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 73883435ab58..226f1428d3e5 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -334,14 +334,6 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 			if (time_after(jiffies, wait_time))
 				break;
 
-			/*
-			 * Check if it's UNLOADING, cause we cannot poll in
-			 * this case, or else a NULL pointer dereference
-			 * is triggered.
-			 */
-			if (unlikely(test_bit(UNLOADING, &base_vha->dpc_flags)))
-				return QLA_FUNCTION_TIMEOUT;
-
 			/* Check for pending interrupts. */
 			qla2x00_poll(ha->rsp_q_map[0]);
 
@@ -5240,7 +5232,7 @@ qla2x00_read_ram_word(scsi_qla_host_t *vha, uint32_t risc_addr, uint32_t *data)
 	mcp->mb[8] = MSW(risc_addr);
 	mcp->out_mb = MBX_8|MBX_1|MBX_0;
 	mcp->in_mb = MBX_3|MBX_2|MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
@@ -5428,7 +5420,7 @@ qla2x00_write_ram_word(scsi_qla_host_t *vha, uint32_t risc_addr, uint32_t data)
 	mcp->mb[8] = MSW(risc_addr);
 	mcp->out_mb = MBX_8|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_1|MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
@@ -5700,7 +5692,7 @@ qla24xx_set_fcp_prio(scsi_qla_host_t *vha, uint16_t loop_id, uint16_t priority,
 	mcp->mb[9] = vha->vp_idx;
 	mcp->out_mb = MBX_9|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->in_mb = MBX_4|MBX_3|MBX_1|MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
 	if (mb != NULL) {
@@ -5787,7 +5779,7 @@ qla82xx_mbx_intr_enable(scsi_qla_host_t *vha)
 
 	mcp->out_mb = MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 
 	rval = qla2x00_mailbox_command(vha, mcp);
@@ -5822,7 +5814,7 @@ qla82xx_mbx_intr_disable(scsi_qla_host_t *vha)
 
 	mcp->out_mb = MBX_1|MBX_0;
 	mcp->in_mb = MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 
 	rval = qla2x00_mailbox_command(vha, mcp);
@@ -6014,7 +6006,7 @@ qla81xx_set_led_config(scsi_qla_host_t *vha, uint16_t *led_cfg)
 	if (IS_QLA8031(ha))
 		mcp->out_mb |= MBX_6|MBX_5|MBX_4|MBX_3;
 	mcp->in_mb = MBX_0;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 
 	rval = qla2x00_mailbox_command(vha, mcp);
@@ -6050,7 +6042,7 @@ qla81xx_get_led_config(scsi_qla_host_t *vha, uint16_t *led_cfg)
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
 	if (IS_QLA8031(ha))
 		mcp->in_mb |= MBX_6|MBX_5|MBX_4|MBX_3;
-	mcp->tov = 30;
+	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 
 	rval = qla2x00_mailbox_command(vha, mcp);
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index fa695a4007f8..90bbc61f361b 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -536,6 +536,11 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
 	struct nvme_private *priv = fd->private;
 	struct qla_nvme_rport *qla_rport = rport->private;
 
+	if (!priv) {
+		/* nvme association has been torn down */
+		return rval;
+	}
+
 	fcport = qla_rport->fcport;
 
 	if (!qpair || !fcport || (qpair && !qpair->fw_started) ||
@@ -687,7 +692,15 @@ int qla_nvme_register_hba(struct scsi_qla_host *vha)
 	tmpl = &qla_nvme_fc_transport;
 
 	WARN_ON(vha->nvme_local_port);
-	WARN_ON(ha->max_req_queues < 3);
+
+	if (ha->max_req_queues < 3) {
+		if (!ha->flags.max_req_queue_warned)
+			ql_log(ql_log_info, vha, 0x2120,
+			       "%s: Disabling FC-NVME due to lack of free queue pairs (%d).\n",
+			       __func__, ha->max_req_queues);
+		ha->flags.max_req_queue_warned = 1;
+		return ret;
+	}
 
 	qla_nvme_fc_transport.max_hw_queues =
 	    min((uint8_t)(qla_nvme_fc_transport.max_hw_queues),
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9b59f032a569..8da00ba54aec 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2017,6 +2017,11 @@ qla2x00_iospace_config(struct qla_hw_data *ha)
 	/* Determine queue resources */
 	ha->max_req_queues = ha->max_rsp_queues = 1;
 	ha->msix_count = QLA_BASE_VECTORS;
+
+	/* Check if FW supports MQ or not */
+	if (!(ha->fw_attributes & BIT_6))
+		goto mqiobase_exit;
+
 	if (!ql2xmqsupport || !ql2xnvmeenable ||
 	    (!IS_QLA25XX(ha) && !IS_QLA81XX(ha)))
 		goto mqiobase_exit;
@@ -2829,10 +2834,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* This may fail but that's ok */
 	pci_enable_pcie_error_reporting(pdev);
 
-	/* Turn off T10-DIF when FC-NVMe is enabled */
-	if (ql2xnvmeenable)
-		ql2xenabledif = 0;
-
 	ha = kzalloc(sizeof(struct qla_hw_data), GFP_KERNEL);
 	if (!ha) {
 		ql_log_pci(ql_log_fatal, pdev, 0x0009,
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index fbb80a043b4f..90289162dbd4 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1270,7 +1270,7 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 
 	qla24xx_chk_fcp_state(sess);
 
-	ql_dbg(ql_dbg_tgt, sess->vha, 0xe001,
+	ql_dbg(ql_dbg_disc, sess->vha, 0xe001,
 	    "Scheduling sess %p for deletion %8phC\n",
 	    sess, sess->port_name);
 
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 064ed680c053..139f0073da37 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5490,9 +5490,11 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 				u64 d = ktime_get_boottime_ns() - ns_from_boot;
 
 				if (kt <= d) {	/* elapsed duration >= kt */
+					spin_lock_irqsave(&sqp->qc_lock, iflags);
 					sqcp->a_cmnd = NULL;
 					atomic_dec(&devip->num_in_q);
 					clear_bit(k, sqp->in_use_bm);
+					spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 					if (new_sd_dp)
 						kfree(sd_dp);
 					/* call scsi_done() from this thread */
diff --git a/drivers/scsi/ufs/ti-j721e-ufs.c b/drivers/scsi/ufs/ti-j721e-ufs.c
index 46bb905b4d6a..eafe0db98d54 100644
--- a/drivers/scsi/ufs/ti-j721e-ufs.c
+++ b/drivers/scsi/ufs/ti-j721e-ufs.c
@@ -38,6 +38,7 @@ static int ti_j721e_ufs_probe(struct platform_device *pdev)
 	/* Select MPHY refclk frequency */
 	clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
 		dev_err(dev, "Cannot claim MPHY clock.\n");
 		goto clk_err;
 	}
diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 29cd017c1aa0..1755dd6b04ae 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -212,7 +212,7 @@ static int ufs_mtk_wait_link_state(struct ufs_hba *hba, u32 state,
 	ktime_t timeout, time_checked;
 	u32 val;
 
-	timeout = ktime_add_us(ktime_get(), ms_to_ktime(max_wait_ms));
+	timeout = ktime_add_ms(ktime_get(), max_wait_ms);
 	do {
 		time_checked = ktime_get();
 		ufshcd_writel(hba, 0x20, REG_UFS_DEBUG_SEL);
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index f407b13883ac..5a95a7bfbab0 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -44,11 +44,23 @@ static int ufs_intel_link_startup_notify(struct ufs_hba *hba,
 	return err;
 }
 
+static int ufs_intel_ehl_init(struct ufs_hba *hba)
+{
+	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
+	return 0;
+}
+
 static struct ufs_hba_variant_ops ufs_intel_cnl_hba_vops = {
 	.name                   = "intel-pci",
 	.link_startup_notify	= ufs_intel_link_startup_notify,
 };
 
+static struct ufs_hba_variant_ops ufs_intel_ehl_hba_vops = {
+	.name                   = "intel-pci",
+	.init			= ufs_intel_ehl_init,
+	.link_startup_notify	= ufs_intel_link_startup_notify,
+};
+
 #ifdef CONFIG_PM_SLEEP
 /**
  * ufshcd_pci_suspend - suspend power management function
@@ -177,8 +189,8 @@ static const struct dev_pm_ops ufshcd_pci_pm_ops = {
 static const struct pci_device_id ufshcd_pci_tbl[] = {
 	{ PCI_VENDOR_ID_SAMSUNG, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ PCI_VDEVICE(INTEL, 0x9DFA), (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
-	{ PCI_VDEVICE(INTEL, 0x4B41), (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
-	{ PCI_VDEVICE(INTEL, 0x4B43), (kernel_ulong_t)&ufs_intel_cnl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x4B41), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x4B43), (kernel_ulong_t)&ufs_intel_ehl_hba_vops },
 	{ }	/* terminate list */
 };
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 307622284239..da199fa7a3e0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1561,6 +1561,7 @@ static void ufshcd_ungate_work(struct work_struct *work)
 int ufshcd_hold(struct ufs_hba *hba, bool async)
 {
 	int rc = 0;
+	bool flush_result;
 	unsigned long flags;
 
 	if (!ufshcd_is_clkgating_allowed(hba))
@@ -1592,7 +1593,9 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 				break;
 			}
 			spin_unlock_irqrestore(hba->host->host_lock, flags);
-			flush_work(&hba->clk_gating.ungate_work);
+			flush_result = flush_work(&hba->clk_gating.ungate_work);
+			if (hba->clk_gating.is_suspended && !flush_result)
+				goto out;
 			spin_lock_irqsave(hba->host->host_lock, flags);
 			goto start;
 		}
@@ -5941,7 +5944,7 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
  */
 static irqreturn_t ufshcd_intr(int irq, void *__hba)
 {
-	u32 intr_status, enabled_intr_status;
+	u32 intr_status, enabled_intr_status = 0;
 	irqreturn_t retval = IRQ_NONE;
 	struct ufs_hba *hba = __hba;
 	int retries = hba->nutrs;
@@ -5955,7 +5958,7 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 	 * read, make sure we handle them by checking the interrupt status
 	 * again in a loop until we process all of the reqs before returning.
 	 */
-	do {
+	while (intr_status && retries--) {
 		enabled_intr_status =
 			intr_status & ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
 		if (intr_status)
@@ -5964,9 +5967,9 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 			retval |= ufshcd_sl_intr(hba, enabled_intr_status);
 
 		intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
-	} while (intr_status && --retries);
+	}
 
-	if (retval == IRQ_NONE) {
+	if (enabled_intr_status && retval == IRQ_NONE) {
 		dev_err(hba->dev, "%s: Unhandled interrupt 0x%08x\n",
 					__func__, intr_status);
 		ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE, "host_regs: ");
@@ -6434,14 +6437,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto out;
 	}
 
-	if (!(reg & (1 << tag))) {
-		dev_err(hba->dev,
-		"%s: cmd was completed, but without a notifying intr, tag = %d",
-		__func__, tag);
-	}
-
 	/* Print Transfer Request of aborted task */
-	dev_err(hba->dev, "%s: Device abort task at tag %d\n", __func__, tag);
+	dev_info(hba->dev, "%s: Device abort task at tag %d\n", __func__, tag);
 
 	/*
 	 * Print detailed info about aborted request.
@@ -6462,6 +6459,13 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	}
 	hba->req_abort_count++;
 
+	if (!(reg & (1 << tag))) {
+		dev_err(hba->dev,
+		"%s: cmd was completed, but without a notifying intr, tag = %d",
+		__func__, tag);
+		goto cleanup;
+	}
+
 	/* Skip task abort in case previous aborts failed and report failure */
 	if (lrbp->req_abort_skip) {
 		err = -EIO;
@@ -6492,7 +6496,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 			/* command completed already */
 			dev_err(hba->dev, "%s: cmd at tag %d successfully cleared from DB.\n",
 				__func__, tag);
-			goto out;
+			goto cleanup;
 		} else {
 			dev_err(hba->dev,
 				"%s: no response from device. tag = %d, err %d\n",
@@ -6526,6 +6530,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 		goto out;
 	}
 
+cleanup:
 	scsi_dma_unmap(cmd);
 
 	spin_lock_irqsave(host->host_lock, flags);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index b2ef18f1b746..363589c0bd37 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -520,6 +520,12 @@ enum ufshcd_quirks {
 	 * OCS FATAL ERROR with device error through sense data
 	 */
 	UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR		= 1 << 10,
+
+	/*
+	 * This quirk needs to be enabled if the host controller has
+	 * auto-hibernate capability but it doesn't work.
+	 */
+	UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8		= 1 << 11,
 };
 
 enum ufshcd_caps {
@@ -803,7 +809,8 @@ return true;
 
 static inline bool ufshcd_is_auto_hibern8_supported(struct ufs_hba *hba)
 {
-	return (hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT);
+	return (hba->capabilities & MASK_AUTO_HIBERN8_SUPPORT) &&
+		!(hba->quirks & UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8);
 }
 
 static inline bool ufshcd_is_auto_hibern8_enabled(struct ufs_hba *hba)
