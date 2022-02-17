Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53783C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240986AbiBQNbI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:31:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240984AbiBQNa5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:57 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A362AE2BE
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104643; x=1676640643;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0maIJiiGjVKGfUJT7QT9WvAyoeH6Ycwg0+jbKTH7PS0=;
  b=aBtYPi9mgO2XotIQbB8kNKu+Xoo9fU9AH+RzlUgeiHjA2ndUP2vwOgxx
   NqPvYdJPk4k1ss75A4DlJcJ27I6VdN6ti7ontptYbBCNyxeICS8Ic8oxr
   5XTlAxgJCKVM2hrERR6ICOJWEv7gj6x24M/WcuZg0NknYCLQYM6LXRpKE
   TAikK7fsrN0SO3gs3br4er+GxG5bP6C70O03dFrai7uKs35PNXKbhyqmJ
   2GbZtlxMnzhpmpttzoveV1ti9F65bK9qk2f8TuMQ1H7rE7GNGgt+5tWvK
   1GitPctWHPiZdchKyn8QiullgPbNWEnbyIYKDb5GnNZGQb02LksKLsN03
   A==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303246"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:42 +0800
IronPort-SDR: Fc40swydzdMFv3sAHWLr82XPEz1ayyQeMgH9+gHZkB2QBKJcvz4KlYa49OOl8U9UJ7cJ1U+lst
 PzyrTRVufAj+D1KpCfeKhaLXrHW/EG8HGHfItKwu97RZXNjKC7JaHNfkT/2CpKo1f267tzg8zA
 xcJGf7ebpt/7zxPzbju4W9UGPGCBBS8HOjxf3c4yrbetBcYV07vz6kSwoyoL3ETElxY5Hhqf6j
 W7eF6BFVAz6aK6eTWgq3knIJ/WGhChBSPW8AbU0nblCnJFFfJ39k+zf8fdTl1eYFdNo4OEc2p+
 Sgf/1yb3CtEKMa3l1FoJbHfO
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:02:21 -0800
IronPort-SDR: rYPPHgKJPeoJD1mt4OgDSNG7egGIBVCO3CSwMXW9IMkqQmOQFbT27b/ed0VwjHxbw5UhXBSaM7
 XiWISaMX99fUgjfXbdIyJGlaEyzhsnf6f3ip8xWHOWAN4yybmXb1IieoWANnDtKAKT7uxAin5G
 OcsU8WqktEatPxcZ8AF9V9nKarV+lxgEJNQN6mKHmuVtBZV8Oa7WyRjssRY+xPBGNwCyHtC7Kl
 C5sftbzeHtWMabEvNl95d4iUC359cAiwBnCgxElhsU3onsY0K/sOUXT8Bsx0a1+kMHUqpr8NH/
 SVw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:43 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jzwgk3Tz7z1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:42 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104641; x=1647696642; bh=0maIJiiGjVKGfUJT7Q
        T9WvAyoeH6Ycwg0+jbKTH7PS0=; b=boqJnBhSF1VC8POlkh7o5LTUrFewtPIO6N
        ERBXFWkL/qaBv50H67d1zquvafh2OpeZU2k9aw3VGlyYTbRGUpvj2qy81lU/yofM
        QrwnnA4mr5eBn/N6HROcJF5ajcJtyGdBgBNgvwmqou7/XbZuZbm9tGqyV4p2Bpul
        PApsA+FkAXXjVyXvH5MxXc3sABXojvjuuzqakqA2pIA68txDpmdDe8Gve/N07GlY
        +3su744SPMgnCXUe14Ke5zH5bqVQKeoRhZ/YhoudOOrQg7UTrvw54rcKja7NcZKn
        +10JGydOJDXCkifPosPFdjCiGqCzFPkb4UdGaaRvjaOPZ3xWItbg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id uFIZ25jorXG1 for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:41 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jzwgg253Wz1SHwl;
        Thu, 17 Feb 2022 05:30:39 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 28/31] scsi: pm8001: Simplify pm8001_task_exec()
Date:   Thu, 17 Feb 2022 22:29:53 +0900
Message-Id: <20220217132956.484818-29-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The main part of the pm8001_task_exec() function uses a do {} while(0)
loop that is useless and only makes the code harder to read. Remove this
loop. The unnecessary local variable t is also removed.

Additionally, avoid repeatedly declaring "struct task_status_struct *ts"
to handle error cases by declaring this variable for the entire function
scope. This allows simplifying the error cases, and together with the
addition of blank lines make the code more readable.

Finally, handling of the running_req counter is fixed to avoid
decrementing it without a corresponding incrementation in the case of
an invalid task protocol.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 174 ++++++++++++++-----------------
 1 file changed, 80 insertions(+), 94 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
index 52507bc8f963..37aba0335f18 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -373,129 +373,115 @@ static int sas_find_local_port_id(struct domain_d=
evice *dev)
   * @is_tmf: if it is task management task.
   * @tmf: the task management IU
   */
-static int pm8001_task_exec(struct sas_task *task,
-	gfp_t gfp_flags, int is_tmf, struct pm8001_tmf_task *tmf)
+static int pm8001_task_exec(struct sas_task *task, gfp_t gfp_flags, int =
is_tmf,
+			    struct pm8001_tmf_task *tmf)
 {
+	struct task_status_struct *ts =3D &task->task_status;
+	enum sas_protocol task_proto =3D task->task_proto;
 	struct domain_device *dev =3D task->dev;
+	struct pm8001_device *pm8001_dev =3D dev->lldd_dev;
 	struct pm8001_hba_info *pm8001_ha;
-	struct pm8001_device *pm8001_dev;
 	struct pm8001_port *port =3D NULL;
-	struct sas_task *t =3D task;
 	struct pm8001_ccb_info *ccb;
-	u32 rc =3D 0, n_elem =3D 0;
-	unsigned long flags =3D 0;
-	enum sas_protocol task_proto =3D t->task_proto;
+	unsigned long flags;
+	u32 n_elem =3D 0;
+	int rc =3D 0;
=20
 	if (!dev->port) {
-		struct task_status_struct *tsm =3D &t->task_status;
-		tsm->resp =3D SAS_TASK_UNDELIVERED;
-		tsm->stat =3D SAS_PHY_DOWN;
+		ts->resp =3D SAS_TASK_UNDELIVERED;
+		ts->stat =3D SAS_PHY_DOWN;
 		if (dev->dev_type !=3D SAS_SATA_DEV)
-			t->task_done(t);
+			task->task_done(task);
 		return 0;
 	}
-	pm8001_ha =3D pm8001_find_ha_by_dev(task->dev);
-	if (pm8001_ha->controller_fatal_error) {
-		struct task_status_struct *ts =3D &t->task_status;
=20
+	pm8001_ha =3D pm8001_find_ha_by_dev(dev);
+	if (pm8001_ha->controller_fatal_error) {
 		ts->resp =3D SAS_TASK_UNDELIVERED;
-		t->task_done(t);
+		task->task_done(task);
 		return 0;
 	}
+
 	pm8001_dbg(pm8001_ha, IO, "pm8001_task_exec device\n");
+
 	spin_lock_irqsave(&pm8001_ha->lock, flags);
-	do {
-		dev =3D t->dev;
-		pm8001_dev =3D dev->lldd_dev;
-		port =3D &pm8001_ha->port[sas_find_local_port_id(dev)];
-		if (DEV_IS_GONE(pm8001_dev) || !port->port_attached) {
-			if (sas_protocol_ata(task_proto)) {
-				struct task_status_struct *ts =3D &t->task_status;
-				ts->resp =3D SAS_TASK_UNDELIVERED;
-				ts->stat =3D SAS_PHY_DOWN;
=20
-				spin_unlock_irqrestore(&pm8001_ha->lock, flags);
-				t->task_done(t);
-				spin_lock_irqsave(&pm8001_ha->lock, flags);
-				continue;
-			} else {
-				struct task_status_struct *ts =3D &t->task_status;
-				ts->resp =3D SAS_TASK_UNDELIVERED;
-				ts->stat =3D SAS_PHY_DOWN;
-				t->task_done(t);
-				continue;
-			}
-		}
+	pm8001_dev =3D dev->lldd_dev;
+	port =3D &pm8001_ha->port[sas_find_local_port_id(dev)];
=20
-		ccb =3D pm8001_ccb_alloc(pm8001_ha, pm8001_dev, t);
-		if (!ccb) {
-			rc =3D -SAS_QUEUE_FULL;
-			goto err_out;
+	if (DEV_IS_GONE(pm8001_dev) || !port->port_attached) {
+		ts->resp =3D SAS_TASK_UNDELIVERED;
+		ts->stat =3D SAS_PHY_DOWN;
+		if (sas_protocol_ata(task_proto)) {
+			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			task->task_done(task);
+			spin_lock_irqsave(&pm8001_ha->lock, flags);
+		} else {
+			task->task_done(task);
 		}
+		rc =3D -ENODEV;
+		goto err_out;
+	}
=20
-		if (!sas_protocol_ata(task_proto)) {
-			if (t->num_scatter) {
-				n_elem =3D dma_map_sg(pm8001_ha->dev,
-					t->scatter,
-					t->num_scatter,
-					t->data_dir);
-				if (!n_elem) {
-					rc =3D -ENOMEM;
-					goto err_out_ccb;
-				}
+	ccb =3D pm8001_ccb_alloc(pm8001_ha, pm8001_dev, task);
+	if (!ccb) {
+		rc =3D -SAS_QUEUE_FULL;
+		goto err_out;
+	}
+
+	if (!sas_protocol_ata(task_proto)) {
+		if (task->num_scatter) {
+			n_elem =3D dma_map_sg(pm8001_ha->dev, task->scatter,
+					    task->num_scatter, task->data_dir);
+			if (!n_elem) {
+				rc =3D -ENOMEM;
+				goto err_out_ccb;
 			}
-		} else {
-			n_elem =3D t->num_scatter;
 		}
+	} else {
+		n_elem =3D task->num_scatter;
+	}
=20
-		t->lldd_task =3D ccb;
-		ccb->n_elem =3D n_elem;
+	task->lldd_task =3D ccb;
+	ccb->n_elem =3D n_elem;
=20
-		switch (task_proto) {
-		case SAS_PROTOCOL_SMP:
-			atomic_inc(&pm8001_dev->running_req);
-			rc =3D pm8001_task_prep_smp(pm8001_ha, ccb);
-			break;
-		case SAS_PROTOCOL_SSP:
-			atomic_inc(&pm8001_dev->running_req);
-			if (is_tmf)
-				rc =3D pm8001_task_prep_ssp_tm(pm8001_ha,
-					ccb, tmf);
-			else
-				rc =3D pm8001_task_prep_ssp(pm8001_ha, ccb);
-			break;
-		case SAS_PROTOCOL_SATA:
-		case SAS_PROTOCOL_STP:
-			atomic_inc(&pm8001_dev->running_req);
-			rc =3D pm8001_task_prep_ata(pm8001_ha, ccb);
-			break;
-		default:
-			dev_printk(KERN_ERR, pm8001_ha->dev,
-				"unknown sas_task proto: 0x%x\n", task_proto);
-			rc =3D -EINVAL;
-			break;
-		}
+	atomic_inc(&pm8001_dev->running_req);
=20
-		if (rc) {
-			pm8001_dbg(pm8001_ha, IO, "rc is %x\n", rc);
-			atomic_dec(&pm8001_dev->running_req);
-			goto err_out_ccb;
-		}
-		/* TODO: select normal or high priority */
-	} while (0);
-	rc =3D 0;
-	goto out_done;
+	switch (task_proto) {
+	case SAS_PROTOCOL_SMP:
+		rc =3D pm8001_task_prep_smp(pm8001_ha, ccb);
+		break;
+	case SAS_PROTOCOL_SSP:
+		if (is_tmf)
+			rc =3D pm8001_task_prep_ssp_tm(pm8001_ha, ccb, tmf);
+		else
+			rc =3D pm8001_task_prep_ssp(pm8001_ha, ccb);
+		break;
+	case SAS_PROTOCOL_SATA:
+	case SAS_PROTOCOL_STP:
+		rc =3D pm8001_task_prep_ata(pm8001_ha, ccb);
+		break;
+	default:
+		dev_printk(KERN_ERR, pm8001_ha->dev,
+			   "unknown sas_task proto: 0x%x\n", task_proto);
+		rc =3D -EINVAL;
+		break;
+	}
=20
+	if (rc) {
+		atomic_dec(&pm8001_dev->running_req);
+		if (!sas_protocol_ata(task_proto) && n_elem)
+			dma_unmap_sg(pm8001_ha->dev, task->scatter,
+				     task->num_scatter, task->data_dir);
 err_out_ccb:
-	pm8001_ccb_free(pm8001_ha, ccb);
+		pm8001_ccb_free(pm8001_ha, ccb);
+
 err_out:
-	dev_printk(KERN_ERR, pm8001_ha->dev, "pm8001 exec failed[%d]!\n", rc);
-	if (!sas_protocol_ata(task_proto))
-		if (n_elem)
-			dma_unmap_sg(pm8001_ha->dev, t->scatter, t->num_scatter,
-				t->data_dir);
-out_done:
+		pm8001_dbg(pm8001_ha, IO, "pm8001_task_exec failed[%d]!\n", rc);
+	}
+
 	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+
 	return rc;
 }
=20
--=20
2.34.1

