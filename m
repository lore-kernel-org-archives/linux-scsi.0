Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44DC5C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbiBRDQF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:16:05 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbiBRDPu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:50 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74570120F7A
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154133; x=1676690133;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bisDyyzh3Z8JkeTW8FlVEwn2u5adpcI42HFL/TB7C8A=;
  b=ohwADtXbRaDkLUDIpHlDNlPmvbef2qjIy0i6YKZ/lySkTxojOkcWPGxR
   KsXqM5cGgKOFRj2EZEh1PtiBBJZcxZGQ8Clt+m+bVcjRPob7cmaPFy9gq
   RWnWZ0HWNfIdHY1iHYGkPWiqBnJ5LgZyWVdWZmb93wq63OGTk8b9+m2Ey
   pHy7R2n1hIbcO7K0RHlyZ1JlW+aMPwDslM9ccgCp1JfZNITs/GclUuK6a
   CPfTN5bt2UNAnWFPJT536+dDxsKERdUWxEHbFECjW3TZKLTkm2dBtLaiL
   L5PH34w5g67WfiMPN+r7d/P7WVUbdhswHtmw82QykjxgRXh1GbjTwb1af
   A==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="192180424"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:15:32 +0800
IronPort-SDR: O3PVrO0bIqefQZ+Juu777FhlSS9+70CtpDZbPp++zeHZYwrjBJ9RBpJEiVMmGIJmVUf4XieKiz
 +pOSldu8VKQSuS1BFYTmuqnQnEKTQIHCerdVFAIuu/siqu3jL2ZVuybNAh89YrHC9QMcDmFjtQ
 xGxcrhf+A1fOhYZ4jjrQQY6gA1hJhblzEr6we/W1/UOPJz1NEjoMsig019wed3pLxWsFNoc857
 O6XiKB+Q0f92Q1ZIVzeaYB4aO0dQ+CLn3ddcOZnZbvQRQyIdSya9mtWKC+I3rIsuVn5Qs/28QN
 IKAK46RFEptHBBuQxEEORb5O
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:47:10 -0800
IronPort-SDR: HY1ReURS69cntXec820Yh7f5WbEpJIlcab/FjRKcTGVfUFE0dU2eb6sCCCugdZDLu8ykNEqAA8
 eSK4dSF3UzXspO7NyrL7eTGOv08vTJhOn4adWoH8gjiuZdVFNkuE3U2r8xIKceJRxKomVHN7d0
 PmOGMA8j+pbQqef8R+5nXIk3oOiqnT9N5ZYXp2kKUDkU0igsVbdnOIBxdjjTRfuTDoAGIeEmAl
 IneYATwalDznxIpxJFIT0XrrDdYUjFNHk92G72n//KMuYsAb6BBcFl59FeWdzBE9dwB3halQts
 Ci0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:15:32 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0GzS35V4z1SVnx
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:32 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154131; x=1647746132; bh=bisDyyzh3Z8JkeTW8F
        lVEwn2u5adpcI42HFL/TB7C8A=; b=cpE9qJjEjQoEYnHmd8s0l0FNbH9ZLeNtRj
        o8HQf1cGsRZbY30E4SDKn/nYtUauu1jJBhtUoh7+tPLt49QxcGeFL+1bIgv9yzXX
        Vp5+QAgJ4cxUU453RtlW0btfoT/xqvS8MnW5LbulAptaPPDe0Yyrbzpg9Wj6ezP+
        RCHPDahpqwgJCGCAmw12ZHukd8P5pAOfWNio0Rl7W5QWR/ED/F9F+ox5w4hZhagx
        bbjK7H4YcqF/lq5Dc8aOYFw3h6DX8iFEwT5ATg2lBO+aZP7VAFF1JZbBEiy97mlb
        oHAqmtw9BAqOIqWJ2RyTwgKoX7x9d2y37gZpSsYtfKNxszMOYrlQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id jBpqF1repCMX for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:15:31 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0GzP6lb4z1Rwrw;
        Thu, 17 Feb 2022 19:15:29 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 29/31] scsi: pm8001: Simplify pm8001_ccb_task_free()
Date:   Fri, 18 Feb 2022 12:14:43 +0900
Message-Id: <20220218031445.548767-30-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The task argument of the pm8001_ccb_task_free() function can be infered
from the ccb argument ccb_task field. So there is no need to have this
argument. Likewise, the ccb_index argument is always equal to the ccb
tag field and is not needed either. Remove both arguments and update all
call sites. The pm8001_ccb_task_free_done() helper is also modified to
match this change.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 42 +++++++++++++++-----------------
 drivers/scsi/pm8001/pm8001_sas.c | 25 +++++++++----------
 drivers/scsi/pm8001/pm8001_sas.h | 12 ++++-----
 drivers/scsi/pm8001/pm80xx_hwi.c | 35 ++++++++++++--------------
 4 files changed, 52 insertions(+), 62 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index 03bcf7497bf9..c2dbadb5d91e 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1564,11 +1564,11 @@ void pm8001_work_fn(struct work_struct *work)
 			spin_unlock_irqrestore(&t->task_state_lock, flags1);
 			pm8001_dbg(pm8001_ha, FAIL, "task 0x%p done with event 0x%x resp 0x%x=
 stat 0x%x but aborted by upper layer!\n",
 				   t, pw->handler, ts->resp, ts->stat);
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, ccb->ccb_tag);
+			pm8001_ccb_task_free(pm8001_ha, ccb);
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 		} else {
 			spin_unlock_irqrestore(&t->task_state_lock, flags1);
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, ccb->ccb_tag);
+			pm8001_ccb_task_free(pm8001_ha, ccb);
 			mb();/* in order to force CPU ordering */
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			t->task_done(t);
@@ -1697,8 +1697,7 @@ void pm8001_work_fn(struct work_struct *work)
 					continue;
 				}
 				/*complete sas task and update to top layer */
-				pm8001_ccb_task_free(pm8001_ha, task, ccb,
-						     ccb->ccb_tag);
+				pm8001_ccb_task_free(pm8001_ha, ccb);
 				ts->resp =3D SAS_TASK_COMPLETE;
 				task->task_done(task);
 			} else if (ccb->ccb_tag !=3D PM8001_INVALID_TAG) {
@@ -2084,10 +2083,10 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001=
_ha, void *piomb)
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
 		pm8001_dbg(pm8001_ha, FAIL, "task 0x%p done with io_status 0x%x resp 0=
x%x stat 0x%x but aborted by upper layer!\n",
 			   t, status, ts->resp, ts->stat);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, ccb);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, ccb);
 		mb();/* in order to force CPU ordering */
 		t->task_done(t);
 	}
@@ -2251,10 +2250,10 @@ static void mpi_ssp_event(struct pm8001_hba_info =
*pm8001_ha, void *piomb)
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
 		pm8001_dbg(pm8001_ha, FAIL, "task 0x%p done with event 0x%x resp 0x%x =
stat 0x%x but aborted by upper layer!\n",
 			   t, event, ts->resp, ts->stat);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, ccb);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, ccb);
 		mb();/* in order to force CPU ordering */
 		t->task_done(t);
 	}
@@ -2480,7 +2479,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_=
ha, void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp =3D SAS_TASK_UNDELIVERED;
 			ts->stat =3D SAS_QUEUE_FULL;
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, ccb);
 			return;
 		}
 		break;
@@ -2496,7 +2495,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_=
ha, void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp =3D SAS_TASK_UNDELIVERED;
 			ts->stat =3D SAS_QUEUE_FULL;
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, ccb);
 			return;
 		}
 		break;
@@ -2518,7 +2517,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_=
ha, void *piomb)
 				IO_OPEN_CNX_ERROR_STP_RESOURCES_BUSY);
 			ts->resp =3D SAS_TASK_UNDELIVERED;
 			ts->stat =3D SAS_QUEUE_FULL;
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, ccb);
 			return;
 		}
 		break;
@@ -2589,7 +2588,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_=
ha, void *piomb)
 				    IO_DS_NON_OPERATIONAL);
 			ts->resp =3D SAS_TASK_UNDELIVERED;
 			ts->stat =3D SAS_QUEUE_FULL;
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, ccb);
 			return;
 		}
 		break;
@@ -2609,7 +2608,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_=
ha, void *piomb)
 				    IO_DS_IN_ERROR);
 			ts->resp =3D SAS_TASK_UNDELIVERED;
 			ts->stat =3D SAS_QUEUE_FULL;
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, ccb);
 			return;
 		}
 		break;
@@ -2639,10 +2638,10 @@ mpi_sata_completion(struct pm8001_hba_info *pm800=
1_ha, void *piomb)
 		pm8001_dbg(pm8001_ha, FAIL,
 			   "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborte=
d by upper layer!\n",
 			   t, status, ts->resp, ts->stat);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, ccb);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free_done(pm8001_ha, ccb);
 	}
 }
=20
@@ -2994,12 +2993,10 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001=
_ha, void *piomb)
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
 		pm8001_dbg(pm8001_ha, FAIL, "task 0x%p done with io_status 0x%x resp 0=
x%x stat 0x%x but aborted by upper layer!\n",
 			   t, status, ts->resp, ts->stat);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, ccb);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-		mb();/* in order to force CPU ordering */
-		t->task_done(t);
+		pm8001_ccb_task_free_done(pm8001_ha, ccb);
 	}
 }
=20
@@ -3649,7 +3646,7 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_in=
fo *pm8001_ha, void *piomb)
 	t->task_state_flags &=3D ~SAS_TASK_STATE_PENDING;
 	t->task_state_flags |=3D SAS_TASK_STATE_DONE;
 	spin_unlock_irqrestore(&t->task_state_lock, flags);
-	pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+	pm8001_ccb_task_free(pm8001_ha, ccb);
 	mb();
=20
 	if (pm8001_dev->id & NCQ_ABORT_ALL_FLAG) {
@@ -4287,12 +4284,11 @@ static int pm8001_chip_sata_req(struct pm8001_hba=
_info *pm8001_ha,
 					   "task 0x%p resp 0x%x  stat 0x%x but aborted by upper layer\n",
 					   task, ts->resp,
 					   ts->stat);
-				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
+				pm8001_ccb_task_free(pm8001_ha, ccb);
 			} else {
 				spin_unlock_irqrestore(&task->task_state_lock,
 							flags);
-				pm8001_ccb_task_free_done(pm8001_ha, task,
-								ccb, tag);
+				pm8001_ccb_task_free_done(pm8001_ha, ccb);
 				return 0;
 			}
 		}
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
index 03c275b53ff4..c5d4311887c3 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -499,22 +499,21 @@ int pm8001_queue_command(struct sas_task *task, gfp=
_t gfp_flags)
 /**
   * pm8001_ccb_task_free - free the sg for ssp and smp command, free the=
 ccb.
   * @pm8001_ha: our hba card information
-  * @ccb: the ccb which attached to ssp task
-  * @task: the task to be free.
-  * @ccb_idx: ccb index.
+  * @ccb: the ccb which attached to ssp task to free
   */
 void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
-	struct sas_task *task, struct pm8001_ccb_info *ccb, u32 ccb_idx)
+			  struct pm8001_ccb_info *ccb)
 {
+	struct sas_task *task =3D ccb->task;
 	struct ata_queued_cmd *qc;
 	struct pm8001_device *pm8001_dev;
=20
-	if (!ccb->task)
+	if (!task)
 		return;
-	if (!sas_protocol_ata(task->task_proto))
-		if (ccb->n_elem)
-			dma_unmap_sg(pm8001_ha->dev, task->scatter,
-				task->num_scatter, task->data_dir);
+
+	if (!sas_protocol_ata(task->task_proto) && ccb->n_elem)
+		dma_unmap_sg(pm8001_ha->dev, task->scatter,
+			     task->num_scatter, task->data_dir);
=20
 	switch (task->task_proto) {
 	case SAS_PROTOCOL_SMP:
@@ -533,12 +532,12 @@ void pm8001_ccb_task_free(struct pm8001_hba_info *p=
m8001_ha,
 	}
=20
 	if (sas_protocol_ata(task->task_proto)) {
-		// For SCSI/ATA commands uldd_task points to ata_queued_cmd
+		/* For SCSI/ATA commands uldd_task points to ata_queued_cmd */
 		qc =3D task->uldd_task;
 		pm8001_dev =3D ccb->device;
 		trace_pm80xx_request_complete(pm8001_ha->id,
 			pm8001_dev ? pm8001_dev->attached_phy : PM8001_MAX_PHYS,
-			ccb_idx, 0 /* ctlr_opcode not known */,
+			ccb->ccb_tag, 0 /* ctlr_opcode not known */,
 			qc ? qc->tf.command : 0, // ata opcode
 			pm8001_dev ? atomic_read(&pm8001_dev->running_req) : -1);
 	}
@@ -961,11 +960,11 @@ void pm8001_open_reject_retry(
 				& SAS_TASK_STATE_ABORTED))) {
 			spin_unlock_irqrestore(&task->task_state_lock,
 				flags1);
-			pm8001_ccb_task_free(pm8001_ha, task, ccb, ccb->ccb_tag);
+			pm8001_ccb_task_free(pm8001_ha, ccb);
 		} else {
 			spin_unlock_irqrestore(&task->task_state_lock,
 				flags1);
-			pm8001_ccb_task_free(pm8001_ha, task, ccb, ccb->ccb_tag);
+			pm8001_ccb_task_free(pm8001_ha, ccb);
 			mb();/* in order to force CPU ordering */
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			task->task_done(task);
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm800=
1_sas.h
index aec4572906cf..2aab357d9a23 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -641,7 +641,7 @@ int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_h=
a, u32 *tag_out);
 void pm8001_tag_init(struct pm8001_hba_info *pm8001_ha);
 u32 pm8001_get_ncq_tag(struct sas_task *task, u32 *tag);
 void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
-	struct sas_task *task, struct pm8001_ccb_info *ccb, u32 ccb_idx);
+			  struct pm8001_ccb_info *ccb);
 int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 	void *funcdata);
 void pm8001_scan_start(struct Scsi_Host *shost);
@@ -786,12 +786,12 @@ static inline void pm8001_ccb_free(struct pm8001_hb=
a_info *pm8001_ha,
 	pm8001_tag_free(pm8001_ha, tag);
 }
=20
-static inline void
-pm8001_ccb_task_free_done(struct pm8001_hba_info *pm8001_ha,
-			struct sas_task *task, struct pm8001_ccb_info *ccb,
-			u32 ccb_idx)
+static inline void pm8001_ccb_task_free_done(struct pm8001_hba_info *pm8=
001_ha,
+					     struct pm8001_ccb_info *ccb)
 {
-	pm8001_ccb_task_free(pm8001_ha, task, ccb, ccb_idx);
+	struct sas_task *task =3D ccb->task;
+
+	pm8001_ccb_task_free(pm8001_ha, ccb);
 	smp_mb(); /*in order to force CPU ordering*/
 	task->task_done(task);
 }
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index ce19aa361d26..b5e1aaa0fd58 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2157,14 +2157,12 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001=
_ha, void *piomb)
 		pm8001_dbg(pm8001_ha, FAIL,
 			   "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborte=
d by upper layer!\n",
 			   t, status, ts->resp, ts->stat);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, ccb);
 		if (t->slow_task)
 			complete(&t->slow_task->completion);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-		mb();/* in order to force CPU ordering */
-		t->task_done(t);
+		pm8001_ccb_task_free_done(pm8001_ha, ccb);
 	}
 }
=20
@@ -2340,12 +2338,10 @@ static void mpi_ssp_event(struct pm8001_hba_info =
*pm8001_ha, void *piomb)
 		pm8001_dbg(pm8001_ha, FAIL,
 			   "task 0x%p done with event 0x%x resp 0x%x stat 0x%x but aborted by=
 upper layer!\n",
 			   t, event, ts->resp, ts->stat);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, ccb);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-		mb();/* in order to force CPU ordering */
-		t->task_done(t);
+		pm8001_ccb_task_free_done(pm8001_ha, ccb);
 	}
 }
=20
@@ -2579,7 +2575,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_=
ha,
 			ts->stat =3D SAS_QUEUE_FULL;
 			spin_unlock_irqrestore(&circularQ->oq_lock,
 					circularQ->lock_flags);
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, ccb);
 			spin_lock_irqsave(&circularQ->oq_lock,
 					circularQ->lock_flags);
 			return;
@@ -2599,7 +2595,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_=
ha,
 			ts->stat =3D SAS_QUEUE_FULL;
 			spin_unlock_irqrestore(&circularQ->oq_lock,
 					circularQ->lock_flags);
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, ccb);
 			spin_lock_irqsave(&circularQ->oq_lock,
 					circularQ->lock_flags);
 			return;
@@ -2627,7 +2623,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_=
ha,
 			ts->stat =3D SAS_QUEUE_FULL;
 			spin_unlock_irqrestore(&circularQ->oq_lock,
 					circularQ->lock_flags);
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, ccb);
 			spin_lock_irqsave(&circularQ->oq_lock,
 					circularQ->lock_flags);
 			return;
@@ -2702,7 +2698,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_=
ha,
 			ts->stat =3D SAS_QUEUE_FULL;
 			spin_unlock_irqrestore(&circularQ->oq_lock,
 					circularQ->lock_flags);
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, ccb);
 			spin_lock_irqsave(&circularQ->oq_lock,
 					circularQ->lock_flags);
 			return;
@@ -2726,7 +2722,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_=
ha,
 			ts->stat =3D SAS_QUEUE_FULL;
 			spin_unlock_irqrestore(&circularQ->oq_lock,
 					circularQ->lock_flags);
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, ccb);
 			spin_lock_irqsave(&circularQ->oq_lock,
 					circularQ->lock_flags);
 			return;
@@ -2760,14 +2756,14 @@ mpi_sata_completion(struct pm8001_hba_info *pm800=
1_ha,
 		pm8001_dbg(pm8001_ha, FAIL,
 			   "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborte=
d by upper layer!\n",
 			   t, status, ts->resp, ts->stat);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, ccb);
 		if (t->slow_task)
 			complete(&t->slow_task->completion);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
 		spin_unlock_irqrestore(&circularQ->oq_lock,
 				circularQ->lock_flags);
-		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free_done(pm8001_ha, ccb);
 		spin_lock_irqsave(&circularQ->oq_lock,
 				circularQ->lock_flags);
 	}
@@ -3171,10 +3167,10 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001=
_ha, void *piomb)
 		pm8001_dbg(pm8001_ha, FAIL,
 			   "task 0x%p done with io_status 0x%x resp 0x%xstat 0x%x but aborted=
 by upper layer!\n",
 			   t, status, ts->resp, ts->stat);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, ccb);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, ccb);
 		mb();/* in order to force CPU ordering */
 		t->task_done(t);
 	}
@@ -4702,13 +4698,12 @@ static int pm80xx_chip_sata_req(struct pm8001_hba=
_info *pm8001_ha,
 					   "task 0x%p resp 0x%x  stat 0x%x but aborted by upper layer\n",
 					   task, ts->resp,
 					   ts->stat);
-				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
+				pm8001_ccb_task_free(pm8001_ha, ccb);
 				return 0;
 			} else {
 				spin_unlock_irqrestore(&task->task_state_lock,
 							flags);
-				pm8001_ccb_task_free_done(pm8001_ha, task,
-								ccb, tag);
+				pm8001_ccb_task_free_done(pm8001_ha, ccb);
 				atomic_dec(&pm8001_ha_dev->running_req);
 				return 0;
 			}
--=20
2.34.1

