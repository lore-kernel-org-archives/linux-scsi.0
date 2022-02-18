Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B6C6C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbiBRDQA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:16:00 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231937AbiBRDPr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:47 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C173166F8B
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154130; x=1676690130;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K6ZoULG/Hjdqc12xeSNdtQ8HkebdTxwEHmR2H/cwol4=;
  b=G0FoiOpMx+0C5+M/T74Ez7dorQidNpGamzGmDG1nYFpxSuaPCpUWIEz0
   7gl+Ej73ysixfb5ogVcqPmlFDaZBOEdTX7dokPrD29OCvl/f7UKOVnKFh
   0/5xWtgnWitczESVMvJVaszUtpD6jsYnXvLDYvgnrQLF8VhbWiSCzffHT
   3phohQZyYzCch06K0wPInpfTvyg5TA989O4TMeLTtOe94S1J4tjciKEEQ
   1gBtS8Vv9KHnD13va0S3l0Z/TW82e/E1e0gzFwjv0USTNAeuAh9anbEFP
   vekZRkwSbjftu+ltYJSB2awShP/SwZfMlSHIF334vBBiTUTMt3/b54Bcj
   g==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="198074213"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:15:30 +0800
IronPort-SDR: 5XA9yzBI+T8lxdU2Y0rcMkeVTQCAPPW+1iKhSK42jyIo1ooH4RMlb7/GjVYWziKyPZDRPVJTY4
 FFaIiDoBYFEn+buN4iPwyHsDPBgsfuRMrCDGZRD5JmE1/neqQdZwp7RemWD71a0EDudfSAQ+58
 vtM5865S6oTKfnbpFE18NeIgGURThu4DXFw0H0tMR/KQm55NQ4n70NkWUWjffvr+3tg+6duY71
 mkmHGB8GAUnUlHfjS+lBlar49bnXuZF8yreMOBlA6m6miSyDrcdJWirJmcHndSb/s+gYgG9BRQ
 e7UlgQ3kVRyNiN2nXXL85rrH
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:47:09 -0800
IronPort-SDR: sZiikbjxEjNjhIiZrIVInHaumSNhYOzvknHrqucS32Tl1XQW/rYtD/CyiLHIEop55MdUyx4O3u
 LRft0XSpadAlZR/+RDreJe9WTukmZkbrYG2HKlTXxCZ2HoqfGKbNE56i7HzXWIUVGcPq+VBpGB
 H5ZE6r43LBaDug4eaeWCW9ZOgYeTWCgTHnQVlyZEstbsGPFAB3megY84cZXGFfsDPqbOLBuAWP
 /MPdz7qf0SDzsNhM1e7eEa+qXdkE4FB5IYVZSzY5/veK4dokInTk3Uw7PSqZWPtSIvVtq/VXCa
 vV8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:15:31 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0GzQ5nMbz1SVp5
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:30 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154129; x=1647746130; bh=K6ZoULG/Hjdqc12xeS
        NdtQ8HkebdTxwEHmR2H/cwol4=; b=ftQOmckuHT7dO2jpvMEJALhBaMX/pgdwbj
        6lJvudUAPjGe9NlDStxllX4pumjlh9etGLZvYVrhfKXvo//6TxZfv3h16RmUmos6
        hNaWpH1ZjnRiUH3dWL6gJvGaNOZ2Dy1tNFlwHE9MoG336OxiC+G81a50tl+jXCpD
        IlKk21DA5b7/Czut6pbdvDTSjEPepxP0gLaHkBnLo343oZC17GsUIUvzwml/zHPJ
        of3A6O9Jre2hU5pL5nbKagSh68w0FWlT30BOfRSLYwJVoFRPtUmRmLzeasXND48l
        2ee88UY2E2DnQ0Bhz1xMYV/NAWhafBThtga4/iQJy6tJncKhQ09Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 9GYk8N_emvFw for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:15:29 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0GzM3dTLz1SVp6;
        Thu, 17 Feb 2022 19:15:27 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 28/31] scsi: pm8001: Simplify pm8001_task_exec()
Date:   Fri, 18 Feb 2022 12:14:42 +0900
Message-Id: <20220218031445.548767-29-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
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
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 174 ++++++++++++++-----------------
 1 file changed, 80 insertions(+), 94 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
index 6c6138effab1..03c275b53ff4 100644
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

