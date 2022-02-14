Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC634C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239334AbiBNCUq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:20:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239354AbiBNCUR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:20:17 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8EF554AB
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805209; x=1676341209;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=M+uhkGOTtdbTkw7P+LJeHPogOfLwgpAmXahG5AqeDIY=;
  b=LCzcy2Ep2gop6EIhssZgHLhK0AUFl+WcZsRWQ685KhDW05+cueXiFq1q
   x8IxkTlz1QHZ9Ol38LzXvEv5STwQv60WqEFGinyHv3eEdnyMHOg+FhlGW
   zOi/0/X2NeT5iuSw9eT/g0y3Pmxm6zsakmO7igKUKIJKky3B45dcx7x7c
   3un85WdMC8lUw+YJQsJCF0cxOwqdQVgDnLamO+QbCu5vJ+jOVa4X20QxF
   8EfX12Jad0T0r3QGXnnw1yHNA5GHNGYF5hYNC6Ps6HTkitcqLCgcZkWVO
   EoR0iiT/h1aqz6M2Ubo24ypt8hlPlrgQyZCKf8cq3CFf7uX8Xe+fTtsa2
   w==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819841"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:20:09 +0800
IronPort-SDR: V/rHF51vL3f5dmAxrjJC9ujdyQYf9rI0qw/ggygmS+9KbFv6MMyRF5LtXSv2heQDqc3qVA9FSF
 HGfkKC+TqPdFyr4aLbli3wFDD8Xn8p2kJuWt5BOHONKRpaFZuTT6mGHvkOyMW1HZlTZ+rmnW1p
 qPfMpxJTCCVuofKGLXUXpI8PcBK9QZcoqYUVbd/0RB9OX86TPBAnY7Kjq7KyAZfKoSsh/Wtz/n
 0usV76UCo50pDCL3S0+PJsgIi+m/R4uI5xsWwCD5Ehcfsbmjoxn/EQpxC0Tdn1qedLEkvO06py
 8KwplxUEP1w0wX521+7IEKlK
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:53:02 -0800
IronPort-SDR: rInl9mFtitOXIdj6ZURHu7ax+FBZi0U6GpPIgHKIvWCDt/KGgQoAD5pyJMSWTopM3VF1MXJwMN
 UHleSBFy35pP8r6RbFDldFZhbzNyZHYDMIkvTUj3/8GAgof7u3xDEsonjZaqHusdqgWb8zdqiT
 Z0fsuAz7RIXhGuootQO0T9sqoTdOIoe2JDK6Bn2Kl1ccJxhjn0C4fpB6J9FpjNHgk6aMX76Zby
 jPvRNkleto36YGRlQXBEpinQNcHens2ECxY+kAc4sXH2hrlhPJ0v+Nj9im/SzfF8zO7kJRH94u
 q1U=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:20:11 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JxnxQ6H0Qz1Rwrw
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:20:10 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805209; x=1647397210; bh=M+uhkGOTtdbTkw7P+L
        JeHPogOfLwgpAmXahG5AqeDIY=; b=jM6Gi1hwBjDRlMef5+rgCoQPf4cjlcDahe
        WEu7O2GOePAU5tZJPnTjKfb4uVCoa2AR/9itglnCDHQkP/hXjyqtaCrSgOGxbt1H
        YCDQjrBfjeZNJsIrItFISbA2u0ZhfzJMrO09Q3fs9l3RPss5dotx3lC221WVyHXN
        LVaYRgny5h6JWgHfWPV1u6DFu3NMI9qWgiqd2bADK88dWhlUVwaqms7ka2MdLSJN
        oCW3rPwsMZmwH5PRPddxSNLc3QKvwqStSf8Jlmq3x1fRpYrCMbJlCIXiIdn+Uwuw
        N/3wTJNg9RbHGfvYI9w+EjkkutCr0Z+VnXge/FKBn//KVaGQIoBQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ZRIm3_lGa3jv for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:20:09 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JxnxN0ZW0z1SVp5;
        Sun, 13 Feb 2022 18:20:07 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 30/31] scsi: pm8001: Simplify pm8001_task_exec()
Date:   Mon, 14 Feb 2022 11:17:46 +0900
Message-Id: <20220214021747.4976-31-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The main part of the pm8001_task_exec() function uses a do {} while(0)
loop that is useless and only makes the code harder to read. Remove this
loop. Also, the unnecessary local variable t is removed.
Additionnally, handling of the running_req counter is fixed to avoid
decrementing it without a corresponding incrementation in the case of an
invalid task protocol.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 160 ++++++++++++++-----------------
 1 file changed, 73 insertions(+), 87 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
index 6c4aa04c9144..980afde2a0ab 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -373,32 +373,32 @@ static int sas_find_local_port_id(struct domain_dev=
ice *dev)
   * @is_tmf: if it is task management task.
   * @tmf: the task management IU
   */
-static int pm8001_task_exec(struct sas_task *task,
-	gfp_t gfp_flags, int is_tmf, struct pm8001_tmf_task *tmf)
+static int pm8001_task_exec(struct sas_task *task, gfp_t gfp_flags, int =
is_tmf,
+			    struct pm8001_tmf_task *tmf)
 {
 	struct domain_device *dev =3D task->dev;
+	struct pm8001_device *pm8001_dev =3D dev->lldd_dev;
 	struct pm8001_hba_info *pm8001_ha;
-	struct pm8001_device *pm8001_dev;
 	struct pm8001_port *port =3D NULL;
-	struct sas_task *t =3D task;
-	struct task_status_struct *ts =3D &t->task_status;
+	struct task_status_struct *ts =3D &task->task_status;
+	enum sas_protocol task_proto =3D task->task_proto;
 	struct pm8001_ccb_info *ccb;
-	u32 rc =3D 0, n_elem =3D 0;
-	unsigned long flags =3D 0;
-	enum sas_protocol task_proto =3D t->task_proto;
+	unsigned long flags;
+	u32 n_elem =3D 0;
+	int rc =3D 0;
=20
 	if (!dev->port) {
 		ts->resp =3D SAS_TASK_UNDELIVERED;
 		ts->stat =3D SAS_PHY_DOWN;
 		if (dev->dev_type !=3D SAS_SATA_DEV)
-			t->task_done(t);
+			task->task_done(task);
 		return 0;
 	}
=20
-	pm8001_ha =3D pm8001_find_ha_by_dev(task->dev);
+	pm8001_ha =3D pm8001_find_ha_by_dev(dev);
 	if (pm8001_ha->controller_fatal_error) {
 		ts->resp =3D SAS_TASK_UNDELIVERED;
-		t->task_done(t);
+		task->task_done(task);
 		return 0;
 	}
=20
@@ -406,92 +406,78 @@ static int pm8001_task_exec(struct sas_task *task,
=20
 	spin_lock_irqsave(&pm8001_ha->lock, flags);
=20
-	do {
-		dev =3D t->dev;
-		pm8001_dev =3D dev->lldd_dev;
-		port =3D &pm8001_ha->port[sas_find_local_port_id(dev)];
+	pm8001_dev =3D dev->lldd_dev;
+	port =3D &pm8001_ha->port[sas_find_local_port_id(dev)];
=20
-		if (DEV_IS_GONE(pm8001_dev) || !port->port_attached) {
-			ts->resp =3D SAS_TASK_UNDELIVERED;
-			ts->stat =3D SAS_PHY_DOWN;
-			if (sas_protocol_ata(task_proto)) {
-				spin_unlock_irqrestore(&pm8001_ha->lock, flags);
-				t->task_done(t);
-				spin_lock_irqsave(&pm8001_ha->lock, flags);
-			} else {
-				t->task_done(t);
-			}
-			continue;
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
+		goto unlock;
+	}
=20
-		ccb =3D pm8001_ccb_alloc(pm8001_ha, pm8001_dev, t);
-		if (!ccb) {
-			rc =3D -SAS_QUEUE_FULL;
-			goto err_out;
-		}
+	ccb =3D pm8001_ccb_alloc(pm8001_ha, pm8001_dev, task);
+	if (!ccb) {
+		rc =3D -SAS_QUEUE_FULL;
+		goto unlock;
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
+	if (!sas_protocol_ata(task_proto)) {
+		if (task->num_scatter) {
+			n_elem =3D dma_map_sg(pm8001_ha->dev, task->scatter,
+					    task->num_scatter, task->data_dir);
+			if (!n_elem) {
+				rc =3D -ENOMEM;
+				goto ccb_free;
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
-err_out_ccb:
-	pm8001_ccb_free(pm8001_ha, ccb);
-err_out:
-	dev_printk(KERN_ERR, pm8001_ha->dev, "pm8001 exec failed[%d]!\n", rc);
-	if (!sas_protocol_ata(task_proto))
-		if (n_elem)
-			dma_unmap_sg(pm8001_ha->dev, t->scatter, t->num_scatter,
-				t->data_dir);
-out_done:
+	if (rc) {
+		atomic_dec(&pm8001_dev->running_req);
+		if (!sas_protocol_ata(task_proto) && n_elem)
+			dma_unmap_sg(pm8001_ha->dev, task->scatter,
+				     task->num_scatter, task->data_dir);
+ccb_free:
+		pm8001_ccb_free(pm8001_ha, ccb);
+		dev_err(pm8001_ha->dev, "pm8001 exec failed[%d]!\n", rc);
+	}
+
+unlock:
 	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 	return rc;
 }
--=20
2.34.1

