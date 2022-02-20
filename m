Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9132C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243426AbiBTDTn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:19:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243375AbiBTDTa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:19:30 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85618340DD
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327139; x=1676863139;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4baZIJMM4uBqIcpGSfWCIseJ7c/gtGRLhWgjKFC85eI=;
  b=iQUmXTKnxUWop0edy2mjD/bt+9EQrGAagzitLoNm5dzkCD6E2PGNchDZ
   o8m8Jobf78iQsxf1lG9swUorHjdG21Hpa3Q2ygVVUMtG/4wHBganXg6GO
   qA73mhP/RHajrmJR1YNsdXaLfc00PfYscJzG03aOd9fhQoetlcqDvGhS9
   XOXVGunk3/1xw5oTQ6Tfnl1hYssTCa4pNKk3EHvIiLhySKl1LKP1NcrYM
   uL+79HwgslRaQrHiu/qzVFJ6SX9RwM2yZz96lSOemdEYdjjSplK/SKOrv
   jcOhv2QtWzVuFzutktfZgmtvbTkOgN6IvcTJlnlUWot9rdus9OJ6dfAk/
   A==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405829"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:58 +0800
IronPort-SDR: arCCaJ8MpPG/q71yBy2Kk4o4U2bsyhvMFR5nZMkTLwqQOunkAnHbJy6lyxcC6ZECSndKDE1Xj0
 w6dcR7S0m0zppwXY23dJGnusx3IPoSIGeSejC1dJqwHmJy9tG6I00sgpak2veeqJPLFSSnMgu7
 18e/qmtabo8i7s3ypeuwBtQa+Ufe+YXvRL/li1jn+B2zqM7QTEasdhOOuCT7kFDdEuIyu3GXI7
 JgMzr9qD56Gc75o+RD5Wb8r6nXu8Qj8IcSSAUrQ8MW0q/SAT0wMRjpyu181SrMywp7Yjr3LoY0
 aut/B/QqttQzV+R13+Y2XbOP
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:50:34 -0800
IronPort-SDR: jyM9gAAxmMMgplojNxBsH54BXkD90lGpnUIOHMM3k1hiaJYMfzBf4nfKmlTeCrzrOBs6wAGlNQ
 C7sgNtUzluJkytJ5Bmm27J8cGO89Bc7z/9ItMsb5t9fjsjeMfkgaO9tcM3/HpMh2QX9TkuPSt8
 Zofx3STcXo2c5FHorusZCPUzpKNCoNBE6wZmKV87o1i6xVQ+qSFc/rb9l7DVZRFEcXoYDHi+AN
 88caixQaPAjZgJHpDtlD51yHOTJF0iPrVN/FPfXSgzglaln/kyy8Uk3c9OLDFPzSOHWx9+19jk
 SbM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:59 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1VyV6YS5z1SVp0
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:58 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327137; x=1647919138; bh=4baZIJMM4uBqIcpGSf
        WCIseJ7c/gtGRLhWgjKFC85eI=; b=eHlCWUEb94LbBDwgzrwhCpUrgzOMFzR0nx
        THZCR/oP3eSNmz8PEbvhQ4C1uy3ZfqtxJ30TqIeWkYkc185Tp4S9ykLmbzenAi85
        GNPpvHBrEvyzThXrTpdIB8wvQKX841qUQtwKrAvhmvNYbTSdDl2zZu7D33GvtV68
        q71xzDsOS6QPxGsYIIh/fM8Pqh84gwMeoauYo5wSyB+imIFltp/iUrbRS5WOzbm9
        WXrAqxbvqHeYiuVRtxsp9X54EE/NGaMDqksCiXPkN7t6dM5/ObNzvsw2CaHWgJmB
        5PtNpL91ChcnAvSA7GoThaoakUulJtl+iZwtNb4Yg8OoWU3bwNRQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id NVilhxt0AEkq for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:57 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1VyS1Nh1z1SVp1;
        Sat, 19 Feb 2022 19:18:55 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 29/31] scsi: pm8001: Simplify pm8001_ccb_task_free()
Date:   Sun, 20 Feb 2022 12:18:08 +0900
Message-Id: <20220220031810.738362-30-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
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
index eb6e09696b8b..1569aa483af5 100644
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
index ecd5cca2bb57..ac9c40c95070 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -489,22 +489,21 @@ int pm8001_queue_command(struct sas_task *task, gfp=
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
@@ -523,12 +522,12 @@ void pm8001_ccb_task_free(struct pm8001_hba_info *p=
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
@@ -844,11 +843,11 @@ void pm8001_open_reject_retry(
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
index 9f5d6abba785..6bbf118f61e7 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -637,7 +637,7 @@ int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_h=
a, u32 *tag_out);
 void pm8001_tag_init(struct pm8001_hba_info *pm8001_ha);
 u32 pm8001_get_ncq_tag(struct sas_task *task, u32 *tag);
 void pm8001_ccb_task_free(struct pm8001_hba_info *pm8001_ha,
-	struct sas_task *task, struct pm8001_ccb_info *ccb, u32 ccb_idx);
+			  struct pm8001_ccb_info *ccb);
 int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 	void *funcdata);
 void pm8001_scan_start(struct Scsi_Host *shost);
@@ -780,12 +780,12 @@ static inline void pm8001_ccb_free(struct pm8001_hb=
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

