Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46D27C43460
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 12:31:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 166196144F
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 12:31:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236760AbhEGMcI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 May 2021 08:32:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:46852 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236689AbhEGMcF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 May 2021 08:32:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 72F20B18B;
        Fri,  7 May 2021 12:31:04 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     GR-QLogic-Storage-Upstream@marvell.com,
        linux-kernel@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Arun Easi <aeasi@marvell.com>, Daniel Wagner <dwagner@suse.de>
Subject: [RFC 2/2] qla2xxx: Do not free resource to early in qla24xx_async_gpsc_sp_done()
Date:   Fri,  7 May 2021 14:31:03 +0200
Message-Id: <20210507123103.10265-4-dwagner@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210507123103.10265-1-dwagner@suse.de>
References: <20210507123103.10265-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The timeout handler and done function are racing. When
qla2x00_async_iocb_timeout() starts to run it can be preempted by the
normal response path (via the firmware?). qla24xx_async_gpsc_sp_done()
releases the SRB unconditionally. When scheduling back to
qla2x00_async_iocb_timeout() qla24xx_async_abort_cmd() will access an
freed sp->qpair pointer:

  qla2xxx [0000:83:00.0]-2871:0: Async-gpsc timeout - hdl=63d portid=234500 50:06:0e:80:08:77:b6:21.
  qla2xxx [0000:83:00.0]-2853:0: Async done-gpsc res 0, WWPN 50:06:0e:80:08:77:b6:21
  qla2xxx [0000:83:00.0]-2854:0: Async-gpsc OUT WWPN 20:45:00:27:f8:75:33:00 speeds=2c00 speed=0400.
  qla2xxx [0000:83:00.0]-28d8:0: qla24xx_handle_gpsc_event 50:06:0e:80:08:77:b6:21 DS 7 LS 6 rc 0 login 1|1 rscn 1|0 lid 5
  BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
  IP: qla24xx_async_abort_cmd+0x1b/0x1c0 [qla2xxx]

An obvious solution to this is to introduce a reference counter. One
reference is taken for the normal code path (the 'good case') and one
for the timeout path. As we always race between the normal good case
and the timeout/abort handler we need to serialize it. Also we cannot
assume any order between the handlers. Since this is slow path we can
use proper synchronization via locks.

When we are able to cancel a timer (del_timer returns 1) we know there
can't be any error handling in progress because the timeout handler
hasn't expired yet, thus we can safely decrement the refcounter by one.

If we are not able to cancel the timer, we know an abort handler is
running. We have to make sure we call sp->done() in the abort handlers
before calling kref_put().

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/qla2xxx/qla_def.h  |  5 +++++
 drivers/scsi/qla2xxx/qla_gbl.h  |  1 +
 drivers/scsi/qla2xxx/qla_gs.c   | 16 +++++++---------
 drivers/scsi/qla2xxx/qla_init.c | 19 +++++++++++++++----
 drivers/scsi/qla2xxx/qla_iocb.c | 27 +++++++++++++++++++++++++--
 5 files changed, 53 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index def4d99f80e9..4bff1ae42d73 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -676,6 +676,11 @@ typedef struct srb {
 	 * code.
 	 */
 	void (*put_fn)(struct kref *kref);
+	/*
+	 * Report completition for asynchronous commands.
+	 */
+	void (*async_done)(struct srb *sp, int res);
+	spinlock_t lock;
 } srb_t;
 
 #define GET_CMD_SP(sp) (sp->u.scmd.cmd)
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 15e6a61905c9..74fed0c46ac4 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -313,6 +313,7 @@ extern int qla24xx_walk_and_build_prot_sglist(struct qla_hw_data *, srb_t *,
 	struct dsd64 *, uint16_t, struct qla_tgt_cmd *);
 extern int qla24xx_get_one_block_sg(uint32_t, struct qla2_sgx *, uint32_t *);
 extern int qla24xx_configure_prot_mode(srb_t *, uint16_t *);
+void qla2x00_sp_release(struct kref *kref);
 
 /*
  * Global Function Prototypes in qla_mbx.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 1784ebfacfab..e1b2474f0f65 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -529,7 +529,6 @@ static void qla2x00_async_sns_sp_done(srb_t *sp, int rc)
 		if (!e)
 			goto err2;
 
-		del_timer(&sp->u.iocb_cmd.timer);
 		e->u.iosb.sp = sp;
 		qla2x00_post_work(vha, e);
 		return;
@@ -556,7 +555,7 @@ static void qla2x00_async_sns_sp_done(srb_t *sp, int rc)
 			sp->u.iocb_cmd.u.ctarg.rsp = NULL;
 		}
 
-		sp->free(sp);
+		kref_put_lock(&sp->cmd_kref, qla2x00_sp_release, &sp->lock);
 
 		return;
 	}
@@ -2982,7 +2981,7 @@ void qla24xx_sp_unmap(scsi_qla_host_t *vha, srb_t *sp)
 		break;
 	}
 
-	sp->free(sp);
+	kref_put_lock(&sp->cmd_kref, qla2x00_sp_release, &sp->lock);
 }
 
 void qla24xx_handle_gpnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
@@ -3121,13 +3120,13 @@ static void qla2x00_async_gpnid_sp_done(srb_t *sp, int res)
 	if (res) {
 		if (res == QLA_FUNCTION_TIMEOUT) {
 			qla24xx_post_gpnid_work(sp->vha, &ea.id);
-			sp->free(sp);
+			kref_put_lock(&sp->cmd_kref, qla2x00_sp_release, &sp->lock);
 			return;
 		}
 	} else if (sp->gen1) {
 		/* There was another RSCN for this Nport ID */
 		qla24xx_post_gpnid_work(sp->vha, &ea.id);
-		sp->free(sp);
+		kref_put_lock(&sp->cmd_kref, qla2x00_sp_release, &sp->lock);
 		return;
 	}
 
@@ -3148,7 +3147,7 @@ static void qla2x00_async_gpnid_sp_done(srb_t *sp, int res)
 				  sp->u.iocb_cmd.u.ctarg.rsp_dma);
 		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
 
-		sp->free(sp);
+		kref_put_lock(&sp->cmd_kref, qla2x00_sp_release, &sp->lock);
 		return;
 	}
 
@@ -3739,7 +3738,6 @@ static void qla2x00_async_gpnft_gnnft_sp_done(srb_t *sp, int res)
 	    "Async done-%s res %x FC4Type %x\n",
 	    sp->name, res, sp->gen2);
 
-	del_timer(&sp->u.iocb_cmd.timer);
 	sp->rc = res;
 	if (res) {
 		unsigned long flags;
@@ -4133,7 +4131,7 @@ static void qla2x00_async_gnnid_sp_done(srb_t *sp, int res)
 
 	qla24xx_handle_gnnid_event(vha, &ea);
 
-	sp->free(sp);
+	kref_put_lock(&sp->cmd_kref, qla2x00_sp_release, &sp->lock);
 }
 
 int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_port_t *fcport)
@@ -4260,7 +4258,7 @@ static void qla2x00_async_gfpnid_sp_done(srb_t *sp, int res)
 
 	qla24xx_handle_gfpnid_event(vha, &ea);
 
-	sp->free(sp);
+	kref_put_lock(&sp->cmd_kref, qla2x00_sp_release, &sp->lock);
 }
 
 int qla24xx_async_gfpnid(scsi_qla_host_t *vha, fc_port_t *fcport)
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6497bf405d82..be85109fd850 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -126,11 +126,14 @@ static void qla24xx_abort_iocb_timeout(void *data)
 	}
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
-	if (sp->cmd_sp)
+	if (sp->cmd_sp) {
 		sp->cmd_sp->done(sp->cmd_sp, QLA_OS_TIMER_EXPIRED);
+		kref_put_lock(&sp->cmd_kref, qla2x00_sp_release, &sp->lock);
+	}
 
 	abt->u.abt.comp_status = cpu_to_le16(CS_TIMEOUT);
 	sp->done(sp, QLA_OS_TIMER_EXPIRED);
+	kref_put_lock(&sp->cmd_kref, qla2x00_sp_release, &sp->lock);
 }
 
 static void qla24xx_abort_sp_done(srb_t *sp, int res)
@@ -141,11 +144,17 @@ static void qla24xx_abort_sp_done(srb_t *sp, int res)
 	if (orig_sp)
 		qla_wait_nvme_release_cmd_kref(orig_sp);
 
-	del_timer(&sp->u.iocb_cmd.timer);
+	if (sp->cmd_sp) {
+		sp->cmd_sp->done(sp->cmd_sp, QLA_OS_TIMER_EXPIRED);
+		kref_put_lock(&sp->cmd_sp->cmd_kref,
+			      qla2x00_sp_release,
+			      &sp->cmd_sp->lock);
+	}
+
 	if (sp->flags & SRB_WAKEUP_ON_COMP)
 		complete(&abt->u.abt.comp);
 	else
-		sp->free(sp);
+		kref_put_lock(&sp->cmd_kref, qla2x00_sp_release, &sp->lock);
 }
 
 int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
@@ -190,7 +199,7 @@ int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 		wait_for_completion(&abt_iocb->u.abt.comp);
 		rval = abt_iocb->u.abt.comp_status == CS_COMPLETE ?
 			QLA_SUCCESS : QLA_FUNCTION_FAILED;
-		sp->free(sp);
+		kref_put_lock(&sp->cmd_kref, qla2x00_sp_release, &sp->lock);
 	}
 
 	return rval;
@@ -237,6 +246,7 @@ qla2x00_async_iocb_timeout(void *data)
 			}
 			spin_unlock_irqrestore(sp->qpair->qp_lock_ptr, flags);
 			sp->done(sp, QLA_FUNCTION_TIMEOUT);
+			kref_put_lock(&sp->cmd_kref, qla2x00_sp_release, &sp->lock);
 		}
 		break;
 	case SRB_LOGOUT_CMD:
@@ -261,6 +271,7 @@ qla2x00_async_iocb_timeout(void *data)
 			}
 			spin_unlock_irqrestore(sp->qpair->qp_lock_ptr, flags);
 			sp->done(sp, QLA_FUNCTION_TIMEOUT);
+			kref_put_lock(&sp->cmd_kref, qla2x00_sp_release, &sp->lock);
 		}
 		break;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 1e848ded06a4..619e39580aa6 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2597,12 +2597,36 @@ qla24xx_tm_iocb(srb_t *sp, struct tsk_mgmt_entry *tsk)
 	}
 }
 
+static void
+qla2x00_async_done(struct srb *sp, int res)
+{
+	if (del_timer(&sp->u.iocb_cmd.timer)) {
+		/* Succcesfully cancelled the timeout handler */
+		if (kref_put_lock(&sp->cmd_kref, qla2x00_sp_release, &sp->lock))
+                       return;
+	}
+
+	sp->async_done(sp, res);
+}
+
+void
+qla2x00_sp_release(struct kref *kref)
+{
+	struct srb *sp = container_of(kref, struct srb, cmd_kref);
+
+	sp->free(sp);
+}
+
 void
 qla2x00_init_async_sp(srb_t *sp, unsigned long tmo,
 		      void (*done)(struct srb *sp, int res))
 {
 	timer_setup(&sp->u.iocb_cmd.timer, qla2x00_sp_timeout, 0);
-	sp->done = done;
+	kref_init(&sp->cmd_kref); /* normal control flow */
+	kref_get(&sp->cmd_kref);  /* timeout control flow */
+	spin_lock_init(&sp->lock);
+	sp->done = qla2x00_async_done;
+	sp->async_done = done;
 	sp->free = qla2x00_sp_free;
 	sp->u.iocb_cmd.timeout = qla2x00_async_iocb_timeout;
 	sp->u.iocb_cmd.timer.expires = jiffies + tmo * HZ;
@@ -2889,7 +2913,6 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 	    sp->name, res, sp->handle, fcport->d_id.b24, fcport->port_name);
 
 	fcport->flags &= ~(FCF_ASYNC_SENT|FCF_ASYNC_ACTIVE);
-	del_timer(&sp->u.iocb_cmd.timer);
 
 	if (sp->flags & SRB_WAKEUP_ON_COMP)
 		complete(&lio->u.els_plogi.comp);
-- 
2.29.2

