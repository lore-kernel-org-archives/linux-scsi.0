Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15440C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Dec 2021 07:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351755AbhLXHHw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Dec 2021 02:07:52 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58230 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351729AbhLXHHw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Dec 2021 02:07:52 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BO2o6Ab008389
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2021 23:07:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=j/s5iMQhsDv6wgta50H5EtC1iwfkoSpJYfDXhwfAq1A=;
 b=UrDZ+mJrrtL3B/KuLQeQZvMZ5HfQ/bObf/nTPwvrvqR1375kfBf4CZV9PEeTQ4WIAmAi
 FnNURiUGkzUkkcJyilBCmF0hRwWt36qMurSLePBr70l2rLwyNqm8myKytFu9F2IVHUmG
 WlOkvgE6Bw7DtcbZX8vLiLxkw5MHlCS/HiiBpr93C+U0tk10KW88BF1GSz0cXxroZiam
 ftcbZAUpny4n/fINwIZF4V1PEPPcVkWvW5/Uztd61faJB+cYPs1BCsNzE+xSQnMQfzbk
 L/m5rm5N6ZMkpj5LZ94X7f6iRR6qaqLUlx9wFsajrgd8rIKp1+AKtXIEgsbQZlwbuyNG CA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3d4t6kjua3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2021 23:07:51 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Dec
 2021 23:07:48 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 23 Dec 2021 23:07:50 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E49FD3F7076;
        Thu, 23 Dec 2021 23:07:48 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 1BO77mwf017956;
        Thu, 23 Dec 2021 23:07:48 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 1BO77mBU017955;
        Thu, 23 Dec 2021 23:07:48 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 02/16] qla2xxx: Implement ref count for srb
Date:   Thu, 23 Dec 2021 23:06:58 -0800
Message-ID: <20211224070712.17905-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20211224070712.17905-1-njavali@marvell.com>
References: <20211224070712.17905-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: vV_jvCOxV788YoWKcHAt6vAgYG23U1p3
X-Proofpoint-ORIG-GUID: vV_jvCOxV788YoWKcHAt6vAgYG23U1p3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-24_02,2021-12-24_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

Fix race between timeout handler and completion handler by introducing
a reference counter. One reference is taken for the normal code path
(the 'good case') and one for the timeout path.

Cc: stable@vger.kernel.org
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c    |  6 ++-
 drivers/scsi/qla2xxx/qla_def.h    |  5 ++
 drivers/scsi/qla2xxx/qla_edif.c   |  3 +-
 drivers/scsi/qla2xxx/qla_gbl.h    |  1 +
 drivers/scsi/qla2xxx/qla_gs.c     | 85 +++++++++++++++++++++----------
 drivers/scsi/qla2xxx/qla_init.c   | 70 +++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_inline.h |  2 +
 drivers/scsi/qla2xxx/qla_iocb.c   | 41 +++++++++++----
 drivers/scsi/qla2xxx/qla_mbx.c    |  4 +-
 drivers/scsi/qla2xxx/qla_mid.c    |  4 +-
 drivers/scsi/qla2xxx/qla_mr.c     |  4 +-
 drivers/scsi/qla2xxx/qla_os.c     | 14 +++--
 drivers/scsi/qla2xxx/qla_target.c |  4 +-
 13 files changed, 173 insertions(+), 70 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 9da8034ccad4..c2f00f076f79 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -29,7 +29,8 @@ void qla2x00_bsg_job_done(srb_t *sp, int res)
 	    "%s: sp hdl %x, result=%x bsg ptr %p\n",
 	    __func__, sp->handle, res, bsg_job);
 
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 
 	bsg_reply->result = res;
 	bsg_job_done(bsg_job, bsg_reply->result,
@@ -3013,7 +3014,8 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
 
 done:
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	return 0;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 9ebf4a234d9a..a5fc01b4fa96 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -726,6 +726,11 @@ typedef struct srb {
 	 * code.
 	 */
 	void (*put_fn)(struct kref *kref);
+
+	/*
+	 * Report completion for asynchronous commands.
+	 */
+	void (*async_done)(struct srb *sp, int res);
 } srb_t;
 
 #define GET_CMD_SP(sp) (sp->u.scmd.cmd)
diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 53d2b8562027..c04957c363d8 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2146,7 +2146,8 @@ edif_doorbell_show(struct device *dev, struct device_attribute *attr,
 
 static void qla_noop_sp_done(srb_t *sp, int res)
 {
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 5056564f0d0c..3f8b8bbabe6d 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -333,6 +333,7 @@ extern int qla24xx_get_one_block_sg(uint32_t, struct qla2_sgx *, uint32_t *);
 extern int qla24xx_configure_prot_mode(srb_t *, uint16_t *);
 extern int qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha,
 	struct qla_work_evt *e);
+void qla2x00_sp_release(struct kref *kref);
 
 /*
  * Global Function Prototypes in qla_mbx.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 744eb3192056..a812f4a45232 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -529,7 +529,6 @@ static void qla2x00_async_sns_sp_done(srb_t *sp, int rc)
 		if (!e)
 			goto err2;
 
-		del_timer(&sp->u.iocb_cmd.timer);
 		e->u.iosb.sp = sp;
 		qla2x00_post_work(vha, e);
 		return;
@@ -556,8 +555,8 @@ static void qla2x00_async_sns_sp_done(srb_t *sp, int rc)
 			sp->u.iocb_cmd.u.ctarg.rsp = NULL;
 		}
 
-		sp->free(sp);
-
+		/* ref: INIT */
+		kref_put(&sp->cmd_kref, qla2x00_sp_release);
 		return;
 	}
 
@@ -592,6 +591,7 @@ static int qla_async_rftid(scsi_qla_host_t *vha, port_id_t *d_id)
 	if (!vha->flags.online)
 		goto done;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -652,7 +652,8 @@ static int qla_async_rftid(scsi_qla_host_t *vha, port_id_t *d_id)
 	}
 	return rval;
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	return rval;
 }
@@ -687,6 +688,7 @@ static int qla_async_rffid(scsi_qla_host_t *vha, port_id_t *d_id,
 	srb_t *sp;
 	struct ct_sns_pkt *ct_sns;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -747,7 +749,8 @@ static int qla_async_rffid(scsi_qla_host_t *vha, port_id_t *d_id,
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	return rval;
 }
@@ -777,6 +780,7 @@ static int qla_async_rnnid(scsi_qla_host_t *vha, port_id_t *d_id,
 	srb_t *sp;
 	struct ct_sns_pkt *ct_sns;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -836,7 +840,8 @@ static int qla_async_rnnid(scsi_qla_host_t *vha, port_id_t *d_id,
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	return rval;
 }
@@ -882,6 +887,7 @@ static int qla_async_rsnn_nn(scsi_qla_host_t *vha)
 	srb_t *sp;
 	struct ct_sns_pkt *ct_sns;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -947,7 +953,8 @@ static int qla_async_rsnn_nn(scsi_qla_host_t *vha)
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	return rval;
 }
@@ -2887,7 +2894,8 @@ static void qla24xx_async_gpsc_sp_done(srb_t *sp, int res)
 	qla24xx_handle_gpsc_event(vha, &ea);
 
 done:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
@@ -2899,6 +2907,7 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
 	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
 		return rval;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -2938,7 +2947,8 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	return rval;
 }
@@ -2987,7 +2997,8 @@ void qla24xx_sp_unmap(scsi_qla_host_t *vha, srb_t *sp)
 		break;
 	}
 
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 void qla24xx_handle_gpnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
@@ -3126,13 +3137,15 @@ static void qla2x00_async_gpnid_sp_done(srb_t *sp, int res)
 	if (res) {
 		if (res == QLA_FUNCTION_TIMEOUT) {
 			qla24xx_post_gpnid_work(sp->vha, &ea.id);
-			sp->free(sp);
+			/* ref: INIT */
+			kref_put(&sp->cmd_kref, qla2x00_sp_release);
 			return;
 		}
 	} else if (sp->gen1) {
 		/* There was another RSCN for this Nport ID */
 		qla24xx_post_gpnid_work(sp->vha, &ea.id);
-		sp->free(sp);
+		/* ref: INIT */
+		kref_put(&sp->cmd_kref, qla2x00_sp_release);
 		return;
 	}
 
@@ -3153,7 +3166,8 @@ static void qla2x00_async_gpnid_sp_done(srb_t *sp, int res)
 				  sp->u.iocb_cmd.u.ctarg.rsp_dma);
 		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
 
-		sp->free(sp);
+		/* ref: INIT */
+		kref_put(&sp->cmd_kref, qla2x00_sp_release);
 		return;
 	}
 
@@ -3173,6 +3187,7 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_id_t *id)
 	if (!vha->flags.online)
 		goto done;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -3189,7 +3204,8 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_id_t *id)
 		if (tsp->u.iocb_cmd.u.ctarg.id.b24 == id->b24) {
 			tsp->gen1++;
 			spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
-			sp->free(sp);
+			/* ref: INIT */
+			kref_put(&sp->cmd_kref, qla2x00_sp_release);
 			goto done;
 		}
 	}
@@ -3259,8 +3275,8 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_id_t *id)
 			sp->u.iocb_cmd.u.ctarg.rsp_dma);
 		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
 	}
-
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	return rval;
 }
@@ -3315,7 +3331,8 @@ void qla24xx_async_gffid_sp_done(srb_t *sp, int res)
 	ea.rc = res;
 
 	qla24xx_handle_gffid_event(vha, &ea);
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 /* Get FC4 Feature with Nport ID. */
@@ -3328,6 +3345,7 @@ int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
 		return rval;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		return rval;
@@ -3366,7 +3384,8 @@ int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport)
 
 	return rval;
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
 }
@@ -3753,7 +3772,6 @@ static void qla2x00_async_gpnft_gnnft_sp_done(srb_t *sp, int res)
 	    "Async done-%s res %x FC4Type %x\n",
 	    sp->name, res, sp->gen2);
 
-	del_timer(&sp->u.iocb_cmd.timer);
 	sp->rc = res;
 	if (res) {
 		unsigned long flags;
@@ -3921,8 +3939,8 @@ static int qla24xx_async_gnnft(scsi_qla_host_t *vha, struct srb *sp,
 		    sp->u.iocb_cmd.u.ctarg.rsp_dma);
 		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
 	}
-
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 
 	spin_lock_irqsave(&vha->work_lock, flags);
 	vha->scan.scan_flags &= ~SF_SCANNING;
@@ -3974,9 +3992,12 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
 		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xffff,
 		    "%s: Performing FCP Scan\n", __func__);
 
-		if (sp)
-			sp->free(sp); /* should not happen */
+		if (sp) {
+			/* ref: INIT */
+			kref_put(&sp->cmd_kref, qla2x00_sp_release);
+		}
 
+		/* ref: INIT */
 		sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
 		if (!sp) {
 			spin_lock_irqsave(&vha->work_lock, flags);
@@ -4021,6 +4042,7 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
 			    sp->u.iocb_cmd.u.ctarg.req,
 			    sp->u.iocb_cmd.u.ctarg.req_dma);
 			sp->u.iocb_cmd.u.ctarg.req = NULL;
+			/* ref: INIT */
 			qla2x00_rel_sp(sp);
 			return rval;
 		}
@@ -4083,7 +4105,8 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
 		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
 	}
 
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 
 	spin_lock_irqsave(&vha->work_lock, flags);
 	vha->scan.scan_flags &= ~SF_SCANNING;
@@ -4147,7 +4170,8 @@ static void qla2x00_async_gnnid_sp_done(srb_t *sp, int res)
 
 	qla24xx_handle_gnnid_event(vha, &ea);
 
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_port_t *fcport)
@@ -4160,6 +4184,7 @@ int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_port_t *fcport)
 		return rval;
 
 	qla2x00_set_fcport_disc_state(fcport, DSC_GNN_ID);
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
 	if (!sp)
 		goto done;
@@ -4200,7 +4225,8 @@ int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
 	return rval;
@@ -4274,7 +4300,8 @@ static void qla2x00_async_gfpnid_sp_done(srb_t *sp, int res)
 
 	qla24xx_handle_gfpnid_event(vha, &ea);
 
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int qla24xx_async_gfpnid(scsi_qla_host_t *vha, fc_port_t *fcport)
@@ -4286,6 +4313,7 @@ int qla24xx_async_gfpnid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
 		return rval;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
 	if (!sp)
 		goto done;
@@ -4326,7 +4354,8 @@ int qla24xx_async_gfpnid(scsi_qla_host_t *vha, fc_port_t *fcport)
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e6f13cb6fa28..38c11b75f644 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -51,6 +51,9 @@ qla2x00_sp_timeout(struct timer_list *t)
 	WARN_ON(irqs_disabled());
 	iocb = &sp->u.iocb_cmd;
 	iocb->timeout(sp);
+
+	/* ref: TMR */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 void qla2x00_sp_free(srb_t *sp)
@@ -125,8 +128,13 @@ static void qla24xx_abort_iocb_timeout(void *data)
 	}
 	spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
 
-	if (sp->cmd_sp)
+	if (sp->cmd_sp) {
+		/*
+		 * This done function should take care of
+		 * original command ref: INIT
+		 */
 		sp->cmd_sp->done(sp->cmd_sp, QLA_OS_TIMER_EXPIRED);
+	}
 
 	abt->u.abt.comp_status = cpu_to_le16(CS_TIMEOUT);
 	sp->done(sp, QLA_OS_TIMER_EXPIRED);
@@ -140,11 +148,11 @@ static void qla24xx_abort_sp_done(srb_t *sp, int res)
 	if (orig_sp)
 		qla_wait_nvme_release_cmd_kref(orig_sp);
 
-	del_timer(&sp->u.iocb_cmd.timer);
 	if (sp->flags & SRB_WAKEUP_ON_COMP)
 		complete(&abt->u.abt.comp);
 	else
-		sp->free(sp);
+		/* ref: INIT */
+		kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
@@ -154,6 +162,7 @@ int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 	srb_t *sp;
 	int rval = QLA_FUNCTION_FAILED;
 
+	/* ref: INIT for ABTS command */
 	sp = qla2xxx_get_qpair_sp(cmd_sp->vha, cmd_sp->qpair, cmd_sp->fcport,
 				  GFP_ATOMIC);
 	if (!sp)
@@ -181,7 +190,8 @@ int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
-		sp->free(sp);
+		/* ref: INIT */
+		kref_put(&sp->cmd_kref, qla2x00_sp_release);
 		return rval;
 	}
 
@@ -189,7 +199,8 @@ int qla24xx_async_abort_cmd(srb_t *cmd_sp, bool wait)
 		wait_for_completion(&abt_iocb->u.abt.comp);
 		rval = abt_iocb->u.abt.comp_status == CS_COMPLETE ?
 			QLA_SUCCESS : QLA_ERR_FROM_FW;
-		sp->free(sp);
+		/* ref: INIT */
+		kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	}
 
 	return rval;
@@ -287,7 +298,8 @@ static void qla2x00_async_login_sp_done(srb_t *sp, int res)
 		qla24xx_handle_plogi_done_event(vha, &ea);
 	}
 
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int
@@ -306,6 +318,7 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 		return rval;
 	}
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -354,7 +367,8 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
 	fcport->flags &= ~FCF_ASYNC_ACTIVE;
@@ -366,7 +380,8 @@ static void qla2x00_async_logout_sp_done(srb_t *sp, int res)
 	sp->fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 	sp->fcport->login_gen++;
 	qlt_logo_completion_handler(sp->fcport, sp->u.iocb_cmd.u.logio.data[0]);
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int
@@ -376,6 +391,7 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
 	int rval = QLA_FUNCTION_FAILED;
 
 	fcport->flags |= FCF_ASYNC_SENT;
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -397,7 +413,8 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 	return rval;
@@ -423,7 +440,8 @@ static void qla2x00_async_prlo_sp_done(srb_t *sp, int res)
 	if (!test_bit(UNLOADING, &vha->dpc_flags))
 		qla2x00_post_async_prlo_done_work(sp->fcport->vha, sp->fcport,
 		    lio->u.logio.data);
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int
@@ -433,6 +451,7 @@ qla2x00_async_prlo(struct scsi_qla_host *vha, fc_port_t *fcport)
 	int rval;
 
 	rval = QLA_FUNCTION_FAILED;
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -454,7 +473,8 @@ qla2x00_async_prlo(struct scsi_qla_host *vha, fc_port_t *fcport)
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	fcport->flags &= ~FCF_ASYNC_ACTIVE;
 	return rval;
@@ -539,8 +559,8 @@ static void qla2x00_async_adisc_sp_done(srb_t *sp, int res)
 	ea.sp = sp;
 
 	qla24xx_handle_adisc_event(vha, &ea);
-
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int
@@ -555,6 +575,7 @@ qla2x00_async_adisc(struct scsi_qla_host *vha, fc_port_t *fcport,
 		return rval;
 
 	fcport->flags |= FCF_ASYNC_SENT;
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -582,7 +603,8 @@ qla2x00_async_adisc(struct scsi_qla_host *vha, fc_port_t *fcport,
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 	qla2x00_post_async_adisc_work(vha, fcport, data);
@@ -1063,7 +1085,8 @@ static void qla24xx_async_gnl_sp_done(srb_t *sp, int res)
 	}
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
@@ -1093,6 +1116,7 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 	vha->gnl.sent = 1;
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -1125,7 +1149,8 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	fcport->flags &= ~(FCF_ASYNC_ACTIVE | FCF_ASYNC_SENT);
 	return rval;
@@ -1171,7 +1196,7 @@ static void qla24xx_async_gpdb_sp_done(srb_t *sp, int res)
 	dma_pool_free(ha->s_dma_pool, sp->u.iocb_cmd.u.mbx.in,
 		sp->u.iocb_cmd.u.mbx.in_dma);
 
-	sp->free(sp);
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int qla24xx_post_prli_work(struct scsi_qla_host *vha, fc_port_t *fcport)
@@ -1216,7 +1241,7 @@ static void qla2x00_async_prli_sp_done(srb_t *sp, int res)
 		qla24xx_handle_prli_done_event(vha, &ea);
 	}
 
-	sp->free(sp);
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int
@@ -1274,7 +1299,8 @@ qla24xx_async_prli(struct scsi_qla_host *vha, fc_port_t *fcport)
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
 }
@@ -1359,7 +1385,7 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
 	if (pd)
 		dma_pool_free(ha->s_dma_pool, pd, pd_dma);
 
-	sp->free(sp);
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
 	fcport->flags &= ~FCF_ASYNC_ACTIVE;
@@ -1945,6 +1971,7 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 	srb_t *sp;
 	int rval = QLA_FUNCTION_FAILED;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -1988,7 +2015,8 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 	}
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
 	return rval;
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 5f3b7995cc8f..db17f7f410cd 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -184,6 +184,8 @@ static void qla2xxx_init_sp(srb_t *sp, scsi_qla_host_t *vha,
 	sp->vha = vha;
 	sp->qpair = qpair;
 	sp->cmd_type = TYPE_SRB;
+	/* ref : INIT - normal flow */
+	kref_init(&sp->cmd_kref);
 	INIT_LIST_HEAD(&sp->elem);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 95aae9a9631e..7dd82214d59f 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2560,6 +2560,14 @@ qla24xx_tm_iocb(srb_t *sp, struct tsk_mgmt_entry *tsk)
 	}
 }
 
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
@@ -2655,7 +2663,9 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	       return -ENOMEM;
 	}
 
-	/* Alloc SRB structure */
+	/* Alloc SRB structure
+	 * ref: INIT
+	 */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp) {
 		kfree(fcport);
@@ -2687,7 +2697,8 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 			    GFP_KERNEL);
 
 	if (!elsio->u.els_logo.els_logo_pyld) {
-		sp->free(sp);
+		/* ref: INIT */
+		kref_put(&sp->cmd_kref, qla2x00_sp_release);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2710,7 +2721,8 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
-		sp->free(sp);
+		/* ref: INIT */
+		kref_put(&sp->cmd_kref, qla2x00_sp_release);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2721,7 +2733,8 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 
 	wait_for_completion(&elsio->u.els_logo.comp);
 
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	return rval;
 }
 
@@ -2854,7 +2867,6 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 	    sp->name, res, sp->handle, fcport->d_id.b24, fcport->port_name);
 
 	fcport->flags &= ~(FCF_ASYNC_SENT|FCF_ASYNC_ACTIVE);
-	del_timer(&sp->u.iocb_cmd.timer);
 
 	if (sp->flags & SRB_WAKEUP_ON_COMP)
 		complete(&lio->u.els_plogi.comp);
@@ -2964,7 +2976,8 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, int res)
 			struct srb_iocb *elsio = &sp->u.iocb_cmd;
 
 			qla2x00_els_dcmd2_free(vha, &elsio->u.els_plogi);
-			sp->free(sp);
+			/* ref: INIT */
+			kref_put(&sp->cmd_kref, qla2x00_sp_release);
 			return;
 		}
 		e->u.iosb.sp = sp;
@@ -2982,7 +2995,9 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	int rval = QLA_SUCCESS;
 	void	*ptr, *resp_ptr;
 
-	/* Alloc SRB structure */
+	/* Alloc SRB structure
+	 * ref: INIT
+	 */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp) {
 		ql_log(ql_log_info, vha, 0x70e6,
@@ -3071,7 +3086,8 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 out:
 	fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 	qla2x00_els_dcmd2_free(vha, &elsio->u.els_plogi);
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	return rval;
 }
@@ -3882,8 +3898,15 @@ qla2x00_start_sp(srb_t *sp)
 		break;
 	}
 
-	if (sp->start_timer)
+	if (sp->start_timer) {
+		/* ref: TMR timer ref
+		 * this code should be just before start_iocbs function
+		 * This will make sure that caller function don't to do
+		 * kref_put even on failure
+		 */
+		kref_get(&sp->cmd_kref);
 		add_timer(&sp->u.iocb_cmd.timer);
+	}
 
 	wmb();
 	qla2x00_start_iocbs(vha, qp->req);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 2aacd3653245..38e0f02c75e1 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -6479,6 +6479,7 @@ int qla24xx_send_mb_cmd(struct scsi_qla_host *vha, mbx_cmd_t *mcp)
 	if (!vha->hw->flags.fw_started)
 		goto done;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -6524,7 +6525,8 @@ int qla24xx_send_mb_cmd(struct scsi_qla_host *vha, mbx_cmd_t *mcp)
 	}
 
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index c4a967c96fd6..e6b5c4ccce97 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -965,6 +965,7 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	if (vp_index == 0 || vp_index >= ha->max_npiv_vports)
 		return QLA_PARAMETER_ERROR;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(base_vha, NULL, GFP_KERNEL);
 	if (!sp)
 		return rval;
@@ -1007,6 +1008,7 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 		break;
 	}
 done:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index e3ae0894c7a8..f726eb8449c5 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1787,6 +1787,7 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 	struct register_host_info *preg_hsi;
 	struct new_utsname *p_sysid = NULL;
 
+	/* ref: INIT */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -1973,7 +1974,8 @@ qlafx00_fx_disc(scsi_qla_host_t *vha, fc_port_t *fcport, uint16_t fx_type)
 		dma_free_coherent(&ha->pdev->dev, fdisc->u.fxiocb.req_len,
 		    fdisc->u.fxiocb.req_addr, fdisc->u.fxiocb.req_dma_handle);
 done_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index abcd30917263..0a7b00d165c7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -728,7 +728,8 @@ void qla2x00_sp_compl(srb_t *sp, int res)
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 	struct completion *comp = sp->comp;
 
-	sp->free(sp);
+	/* kref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	cmd->result = res;
 	CMD_SP(cmd) = NULL;
 	scsi_done(cmd);
@@ -819,7 +820,8 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 	struct completion *comp = sp->comp;
 
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 	cmd->result = res;
 	CMD_SP(cmd) = NULL;
 	scsi_done(cmd);
@@ -919,6 +921,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		goto qc24_target_busy;
 
 	sp = scsi_cmd_priv(cmd);
+	/* ref: INIT */
 	qla2xxx_init_sp(sp, vha, vha->hw->base_qpair, fcport);
 
 	sp->u.scmd.cmd = cmd;
@@ -938,7 +941,8 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	return 0;
 
 qc24_host_busy_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 
 qc24_target_busy:
 	return SCSI_MLQUEUE_TARGET_BUSY;
@@ -1008,6 +1012,7 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 		goto qc24_target_busy;
 
 	sp = scsi_cmd_priv(cmd);
+	/* ref: INIT */
 	qla2xxx_init_sp(sp, vha, qpair, fcport);
 
 	sp->u.scmd.cmd = cmd;
@@ -1026,7 +1031,8 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 	return 0;
 
 qc24_host_busy_free_sp:
-	sp->free(sp);
+	/* ref: INIT */
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 
 qc24_target_busy:
 	return SCSI_MLQUEUE_TARGET_BUSY;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 83c8c55017d1..b0990f2ee91c 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -620,7 +620,7 @@ static void qla2x00_async_nack_sp_done(srb_t *sp, int res)
 	}
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
-	sp->free(sp);
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 }
 
 int qla24xx_async_notify_ack(scsi_qla_host_t *vha, fc_port_t *fcport,
@@ -672,7 +672,7 @@ int qla24xx_async_notify_ack(scsi_qla_host_t *vha, fc_port_t *fcport,
 	return rval;
 
 done_free_sp:
-	sp->free(sp);
+	kref_put(&sp->cmd_kref, qla2x00_sp_release);
 done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
-- 
2.23.1

