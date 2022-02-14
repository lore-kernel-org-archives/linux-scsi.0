Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23DF0C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239346AbiBNCUv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:20:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235569AbiBNCUU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:20:20 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361D755BC7
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805212; x=1676341212;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=ZZNXcE6N18y2HX8pZrWvNEXQPDGP7fWL/LzC29vZopo=;
  b=g/EjXGtvVanGaaVfTYk8kIlXPblW5NrIGNhgO1YN2pO/eEEqL2uKTZrY
   jBOxNz8A05om5lxzsRPKX1B51dEx9CxZ1W4n4cl+pNOt5Onh3CA3iOKHb
   rs3vGkeIO0mc13CZhIWTzd4OdKAW0zfCwseOMomBDawvQGZO4ICWOzG8L
   Eu8mikuo8OI92Ld65SMWU9qMbMVAJTv3/ui+J1KrQGnAw05LRnzt2bUbZ
   5OA/TkFilFEG8qzHDig41P5uVkuKLPQ27Pk4eSj6qZ/veyZ3XSqOHpuxJ
   2ouLidsbk0zjjtjskYXIMna0d1aTUECxkcsTFYYgmUQuB3cOEau2A3h4G
   w==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819845"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:20:12 +0800
IronPort-SDR: SFKmyMUW9PHrvcd09nNijGLYSL9DQ1VODt1G61Teczgp10wLoPMukvW4TaEWCwMhjZYIdiEURv
 flPlpdsiWBAx4KHdTf6oWIAM2U1DKuDCp/zONnC337lhZmn593+GaJq2lpp7zX9Mz3OXpqltYp
 hTSL7/DZDjEM0rmddNguOkAnbnBu9NPtZA4jQPbX7+ZTprlVul43rnJGcDUfahI0NLq7V5JUV5
 lZxCRJLkiv4qGzM51QyeXpW6kJeFTQ/JKMl4G+yCbWu2JVHxCftcCZ3Ou0nEkVVUpDTyLgLpB/
 /b/BvKLdzp7rJjR26oYuVGK7
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:53:04 -0800
IronPort-SDR: RcvH5BTeY63zPAzw7xAKBu9pqgN3nQgAAqTrYnjm3jEZyCGcoZU14qDW2knAh3sKUsphgHlWMG
 E5kr1jP+pCLP3MLuFtvWMcLVc2EVFpcX4/n9zRALGE29WTjNr82J6uA/FnT0sHyR2tFuaxHWkU
 k9mhUus10F5ELFYj7oaH9NXV3JVxj7Xz78+tK6ij0WF8hqOylRwQcFE15FBaIdgkGcIIqPPwIk
 cxYI0LeM7YRCapdNCYdexQ/dACQgB1PR3Vk8APz7oomaXO6HXeSc90AaxI2P5wVs+bxMnZJlBH
 ojA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:20:13 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JxnxS5DM7z1SVp0
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:20:12 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805211; x=1647397212; bh=ZZNXcE6N18y2HX8pZr
        WvNEXQPDGP7fWL/LzC29vZopo=; b=kv6A7eDhkIig3f0YDVXf5gwbpRoXlpk0hk
        u+2q56YlOJjyr9QiroOmgu3W74JquvulghWTK4YQjz7cKOYsaI1x0eO2CkqQT56f
        bEi5eYf7fyywJl5CnYXNHO33mydMIglIZmOKSKN6AfAT6HNR7/HKusLa7I2X97ht
        Kj2oreaXsY2JQvBBazQyxzUphL5MVHp9x2olzmF7k8B9z1PfA+x7sVaWe/M66F7M
        qpCvmoDs11YMBFuEai1Ki5QcRX6IXPmfX95X3HQDv0yMaJP/MgtP+u6Bbu4IqQsm
        vIaTnWMkwBXRk+RuxLa0IFGW+3wq5fJUds1FmWUTQFIvnu12gXOA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id l9mditbLCiZh for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:20:11 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JxnxQ0h3wz1SVp2;
        Sun, 13 Feb 2022 18:20:09 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 31/31] scsi: pm8001: Simplify pm8001_ccb_task_free()
Date:   Mon, 14 Feb 2022 11:17:47 +0900
Message-Id: <20220214021747.4976-32-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
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
---
 drivers/scsi/pm8001/pm8001_hwi.c | 48 +++++++++++++++-----------------
 drivers/scsi/pm8001/pm8001_sas.c | 25 ++++++++---------
 drivers/scsi/pm8001/pm8001_sas.h | 12 ++++----
 drivers/scsi/pm8001/pm80xx_hwi.c | 41 ++++++++++++---------------
 4 files changed, 58 insertions(+), 68 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index 726421311543..d70a38c17544 100644
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
@@ -2734,7 +2733,7 @@ static void mpi_sata_event(struct pm8001_hba_info *=
pm8001_ha, void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp =3D SAS_TASK_COMPLETE;
 			ts->stat =3D SAS_QUEUE_FULL;
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, ccb);
 			return;
 		}
 		break;
@@ -2828,10 +2827,10 @@ static void mpi_sata_event(struct pm8001_hba_info=
 *pm8001_ha, void *piomb)
 		pm8001_dbg(pm8001_ha, FAIL,
 			   "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborte=
d by upper layer!\n",
 			   t, event, ts->resp, ts->stat);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, ccb);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free_done(pm8001_ha, ccb);
 	}
 }
=20
@@ -3011,12 +3010,10 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001=
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
@@ -3666,7 +3663,7 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_in=
fo *pm8001_ha, void *piomb)
 	t->task_state_flags &=3D ~SAS_TASK_STATE_PENDING;
 	t->task_state_flags |=3D SAS_TASK_STATE_DONE;
 	spin_unlock_irqrestore(&t->task_state_lock, flags);
-	pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+	pm8001_ccb_task_free(pm8001_ha, ccb);
 	mb();
=20
 	if (pm8001_dev->id & NCQ_ABORT_ALL_FLAG) {
@@ -4304,12 +4301,11 @@ static int pm8001_chip_sata_req(struct pm8001_hba=
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
index 980afde2a0ab..ddcd96e0fd95 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -496,22 +496,21 @@ int pm8001_queue_command(struct sas_task *task, gfp=
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
@@ -530,12 +529,12 @@ void pm8001_ccb_task_free(struct pm8001_hba_info *p=
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
@@ -952,11 +951,11 @@ void pm8001_open_reject_retry(
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
index c25d2c435f6a..9550c586ff66 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2159,12 +2159,10 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001=
_ha, void *piomb)
 			   t, status, ts->resp, ts->stat);
 		if (t->slow_task)
 			complete(&t->slow_task->completion);
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
@@ -2762,12 +2758,12 @@ mpi_sata_completion(struct pm8001_hba_info *pm800=
1_ha,
 			   t, status, ts->resp, ts->stat);
 		if (t->slow_task)
 			complete(&t->slow_task->completion);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, ccb);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
 		spin_unlock_irqrestore(&circularQ->oq_lock,
 				circularQ->lock_flags);
-		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free_done(pm8001_ha, ccb);
 		spin_lock_irqsave(&circularQ->oq_lock,
 				circularQ->lock_flags);
 	}
@@ -2872,7 +2868,7 @@ static void mpi_sata_event(struct pm8001_hba_info *=
pm8001_ha,
 			ts->stat =3D SAS_QUEUE_FULL;
 			spin_unlock_irqrestore(&circularQ->oq_lock,
 					circularQ->lock_flags);
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free_done(pm8001_ha, ccb);
 			spin_lock_irqsave(&circularQ->oq_lock,
 					circularQ->lock_flags);
 			return;
@@ -2982,12 +2978,12 @@ static void mpi_sata_event(struct pm8001_hba_info=
 *pm8001_ha,
 		pm8001_dbg(pm8001_ha, FAIL,
 			   "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborte=
d by upper layer!\n",
 			   t, event, ts->resp, ts->stat);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free(pm8001_ha, ccb);
 	} else {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
 		spin_unlock_irqrestore(&circularQ->oq_lock,
 				circularQ->lock_flags);
-		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
+		pm8001_ccb_task_free_done(pm8001_ha, ccb);
 		spin_lock_irqsave(&circularQ->oq_lock,
 				circularQ->lock_flags);
 	}
@@ -3196,10 +3192,10 @@ mpi_smp_completion(struct pm8001_hba_info *pm8001=
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
@@ -4715,13 +4711,12 @@ static int pm80xx_chip_sata_req(struct pm8001_hba=
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

