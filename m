Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFCBC43334
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jun 2022 11:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235413AbiFIL5Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jun 2022 07:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244867AbiFIL5W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2022 07:57:22 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409CA614A
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jun 2022 04:57:20 -0700 (PDT)
Received: from fsav314.sakura.ne.jp (fsav314.sakura.ne.jp [153.120.85.145])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 259Bv9KD069512;
        Thu, 9 Jun 2022 20:57:09 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav314.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav314.sakura.ne.jp);
 Thu, 09 Jun 2022 20:57:09 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav314.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 259Bv8f5069508
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 9 Jun 2022 20:57:09 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <b4a96c07-76ef-c7ac-6a73-a64bba32d26f@I-love.SAKURA.ne.jp>
Date:   Thu, 9 Jun 2022 20:57:08 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH] scsi: qla2xxx: avoid flush_scheduled_work() usage
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace system_wq with qla2xxx_wq in files which will be compiled as
qla2xxx.o, in order to avoid flush_scheduled_work() usage.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
Please see commit c4f135d643823a86 ("workqueue: Wrap flush_workqueue()
using a macro") for background.

This is a blind conversion, for I don't know whether qlt_stop_phase1()
needs to wait all works. If qlt_stop_phase1() needs to wait only works
scheduled via qlt_sched_sess_work(), can we use flush_work() instead of
introducing dedicated qla2xxx_wq ?

Well, it seems to me that currently qlt_sess_work_fn() is racy with regard
to flush_scheduled_work() from qlt_stop_phase1(), for flush_scheduled_work()
will not be called if list_empty() == true due to qlt_sess_work_fn() already
called list_del(). That won't be fixed by replacing flush_scheduled_work()
with flush_work(&tgt->sess_work)... What do you want to do? Just call
drain_workqueue(qla2xxx_wq) unconditionally?

 drivers/scsi/qla2xxx/qla_def.h    |  2 ++
 drivers/scsi/qla2xxx/qla_gs.c     |  4 ++--
 drivers/scsi/qla2xxx/qla_init.c   |  2 +-
 drivers/scsi/qla2xxx/qla_nvme.c   |  6 +++---
 drivers/scsi/qla2xxx/qla_os.c     | 16 ++++++++++++++--
 drivers/scsi/qla2xxx/qla_target.c |  9 ++++-----
 6 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index e8f69c486be1..1051296617ac 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -35,6 +35,8 @@
 
 #include <uapi/scsi/fc/fc_els.h>
 
+extern struct workqueue_struct *qla2xxx_wq;
+
 /* Big endian Fibre Channel S_ID (source ID) or D_ID (destination ID). */
 typedef struct {
 	uint8_t domain;
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index e811de2f6a25..2f659be133cd 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3947,7 +3947,7 @@ static int qla24xx_async_gnnft(scsi_qla_host_t *vha, struct srb *sp,
 		ql_dbg(ql_dbg_disc, vha, 0xffff,
 		    "%s: schedule\n", __func__);
 		vha->scan.scan_flags |= SF_QUEUED;
-		schedule_delayed_work(&vha->scan.scan_work, 5);
+		queue_delayed_work(qla2xxx_wq, &vha->scan.scan_work, 5);
 	}
 	spin_unlock_irqrestore(&vha->work_lock, flags);
 
@@ -4113,7 +4113,7 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
 		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xffff,
 		    "%s: Scan scheduled.\n", __func__);
 		vha->scan.scan_flags |= SF_QUEUED;
-		schedule_delayed_work(&vha->scan.scan_work, 5);
+		queue_delayed_work(qla2xxx_wq, &vha->scan.scan_work, 5);
 	}
 	spin_unlock_irqrestore(&vha->work_lock, flags);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3f3417a3e891..ca3a5be4c0b1 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1886,7 +1886,7 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 	if (vha->scan.scan_flags == 0) {
 		ql_dbg(ql_dbg_disc, vha, 0xffff, "%s: schedule\n", __func__);
 		vha->scan.scan_flags |= SF_QUEUED;
-		schedule_delayed_work(&vha->scan.scan_work, 5);
+		queue_delayed_work(qla2xxx_wq, &vha->scan.scan_work, 5);
 	}
 	spin_unlock_irqrestore(&vha->work_lock, flags);
 }
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 87c9404aa401..866d0b410b8e 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -230,7 +230,7 @@ static void qla_nvme_sp_ls_done(srb_t *sp, int res)
 
 	priv->comp_status = res;
 	INIT_WORK(&priv->ls_work, qla_nvme_ls_complete);
-	schedule_work(&priv->ls_work);
+	queue_work(qla2xxx_wq, &priv->ls_work);
 }
 
 /* it assumed that QPair lock is held. */
@@ -324,7 +324,7 @@ static void qla_nvme_ls_abort(struct nvme_fc_local_port *lport,
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
 	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
-	schedule_work(&priv->abort_work);
+	queue_work(qla2xxx_wq, &priv->abort_work);
 }
 
 static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
@@ -411,7 +411,7 @@ static void qla_nvme_fcp_abort(struct nvme_fc_local_port *lport,
 	spin_unlock_irqrestore(&priv->cmd_lock, flags);
 
 	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
-	schedule_work(&priv->abort_work);
+	queue_work(qla2xxx_wq, &priv->abort_work);
 }
 
 static inline int qla2x00_start_nvme_mq(srb_t *sp)
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 73073fb08369..86a66da928c8 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -45,6 +45,8 @@ module_param(ql2xenforce_iocb_limit, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ql2xenforce_iocb_limit,
 		 "Enforce IOCB throttling, to avoid FW congestion. (default: 1)");
 
+struct workqueue_struct *qla2xxx_wq;
+
 /*
  * CT6 CTX allocation cache
  */
@@ -5341,7 +5343,7 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 				}
 				fcport->fw_login_state = 0;
 
-				schedule_delayed_work(&vha->scan.scan_work, 5);
+				queue_delayed_work(qla2xxx_wq, &vha->scan.scan_work, 5);
 			} else {
 				qla24xx_fcport_handle_login(vha, fcport);
 			}
@@ -8123,10 +8125,16 @@ qla2x00_module_init(void)
 		return -ENOMEM;
 	}
 
+	qla2xxx_wq = alloc_workqueue("qla2xxx_wq", 0, 0);
+	if (!qla2xxx_wq) {
+		ret = -ENOMEM;
+		goto destroy_cache;
+	}
+
 	/* Initialize target kmem_cache and mem_pools */
 	ret = qlt_init();
 	if (ret < 0) {
-		goto destroy_cache;
+		goto destroy_wq;
 	} else if (ret > 0) {
 		/*
 		 * If initiator mode is explictly disabled by qlt_init(),
@@ -8190,6 +8198,9 @@ qla2x00_module_init(void)
 qlt_exit:
 	qlt_exit();
 
+destroy_wq:
+	destroy_workqueue(qla2xxx_wq);
+
 destroy_cache:
 	kmem_cache_destroy(srb_cachep);
 	return ret;
@@ -8209,6 +8220,7 @@ qla2x00_module_exit(void)
 		unregister_chrdev(apidev_major, QLA2XXX_APIDEV);
 	fc_release_transport(qla2xxx_transport_template);
 	qlt_exit();
+	destroy_workqueue(qla2xxx_wq);
 	kmem_cache_destroy(srb_cachep);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index cb97f625970d..aff5cb01c601 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -262,7 +262,7 @@ static void qlt_queue_unknown_atio(scsi_qla_host_t *vha,
 	list_add_tail(&u->cmd_list, &vha->unknown_atio_list);
 	spin_unlock_irqrestore(&vha->cmd_list_lock, flags);
 
-	schedule_delayed_work(&vha->unknown_atio_work, 1);
+	queue_delayed_work(qla2xxx_wq, &vha->unknown_atio_work, 1);
 
 out:
 	return;
@@ -307,8 +307,7 @@ static void qlt_try_to_dequeue_unknown_atios(struct scsi_qla_host *vha,
 			    "Reschedule u %p, vha %p, host %p\n", u, vha, host);
 			if (!queued) {
 				queued = 1;
-				schedule_delayed_work(&vha->unknown_atio_work,
-				    1);
+				queue_delayed_work(qla2xxx_wq, &vha->unknown_atio_work, 1);
 			}
 			continue;
 		}
@@ -1556,7 +1555,7 @@ int qlt_stop_phase1(struct qla_tgt *tgt)
 	spin_lock_irqsave(&tgt->sess_work_lock, flags);
 	while (!list_empty(&tgt->sess_works_list)) {
 		spin_unlock_irqrestore(&tgt->sess_work_lock, flags);
-		flush_scheduled_work();
+		flush_workqueue(qla2xxx_wq);
 		spin_lock_irqsave(&tgt->sess_work_lock, flags);
 	}
 	spin_unlock_irqrestore(&tgt->sess_work_lock, flags);
@@ -1696,7 +1695,7 @@ static int qlt_sched_sess_work(struct qla_tgt *tgt, int type,
 	list_add_tail(&prm->sess_works_list_entry, &tgt->sess_works_list);
 	spin_unlock_irqrestore(&tgt->sess_work_lock, flags);
 
-	schedule_work(&tgt->sess_work);
+	queue_work(qla2xxx_wq, &tgt->sess_work);
 
 	return 0;
 }
-- 
2.18.4


