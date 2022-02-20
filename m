Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 629A7C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243371AbiBTDTC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:19:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240614AbiBTDSz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:18:55 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C17340D1
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327114; x=1676863114;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JPPcNbEYri1ah8CSIxH5TG0sGDMY7KcxgAntH1kk7SY=;
  b=Hjcihd3DMciL0eZBYjVQ7AVgQkxA2emhCfufUWUjLREFbPVl9AlK4w1S
   1Q+G+gEK0BcMy8iXpdGCYHKaFRUjp6l9qjcI1WUb81scd+spiiGDwj0qm
   vkcZEhzxwkijj6MgD9i9mci1OXiRGwlKWDo1ZJ8GNJKN4Q09QOf5748ok
   gj6e/yLPF6QlaeCBd7/9dpC/NwLhaLJeJSVjbHUc87rUjY9SqTeY9H+Fk
   80COeyhXiDWqh6v1ZTARrAEA4vRxlTyRlHFhZ8gvzh5psEEcclU98jpke
   YxLxhgIRw74+Tc5+iS20LJeNRy1zhER+G2H92Pofp2EamiI6WYCtUE0rN
   g==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405772"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:34 +0800
IronPort-SDR: BYFzLeNlCL1wjLYMSgLpdPbG0FK4tkZGRVkl2gYHcnNkMWgMLpZwEWGdxmhKC5sIC7JyZIcXMy
 Y0BO1YCQ7h1L3fv7JJo9ddsNu590UwGcvoa3WDacCWfWcbRH4InOb2fvmhVcNJg/pDo4X0iraq
 wTf1s6U2LlDMR7/+CKeDUyfDWsflKmaGcEYXMpwBqeQZhsLuVb9t5umWE45gvgEl4WG6xkU7Hh
 LUZKtLW/BNIPnqaB+u4/AHcQ5XSWkY+/LwT7Bwm2pzWAzjcS3a4FzJpeGFItjDATW5UQ45Q2lL
 U77ZM5aQ/1IAlnAl7llrimGH
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:50:10 -0800
IronPort-SDR: N/p2XmbMv0UE1gQvmk0sQXFqm16tegZKy1t07hiX7lPp98Uc/mX7hx2u9NhQjKc/0FIBdiZ86l
 pK7kJRJI7C8Oje3we47Ilpdblr+tD1BqqckzgHXYTJw6IgHXYX/Q1oSl1hKxsjTSY0yeZR2Fjr
 gy68BKeqxjnxiGaeyFjBsC+7iI12XzNy0/N+KvncGUGn0Bt1oDApVlEo5qsClvgXZSCYsI/2t4
 aJWiqOdz4sBiUNhJOolxPAZPVAkzUC6W5Xo6BxyoPuw/1okGfVTX3D4ifvNsuvWfIwCYwfY0/K
 8Rc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:35 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1Vy26Qpqz1SVnx
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:34 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327114; x=1647919115; bh=JPPcNbEYri1ah8CSIx
        H5TG0sGDMY7KcxgAntH1kk7SY=; b=ZCHpomEQJpLq5oRWvDhEzYdKRH+VR0UO5X
        HXXjPnFiLT5ill4I5C5q5M+x1nNeRSRQEK6bHfvkGh50ry9FJASvA/NSK9vydDRL
        sZY+cQeI4gB8+Lu0p4aUSvXMeMtqgj8ZzglR3sTvMcbYMO97Q2wtuBKtDo9ToRc9
        3vv1N94kP0Xg/UY6hxB8xhrikvgk5Ia7ESdoYZH3gF2gbThx0Q0ACL/pSN6cBo2+
        bhcDCSL5sd/DrlDHkmHOL118lXCnzY34CB0haTd+VQQV1JYeiBN/K02Oc8/I1iTK
        bl9WTLDNJjmI0l4xIar4bzcJEa9zsMVEYMMCn8s5rc0Mq/QAg9MQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 8XV060PDCpCJ for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:34 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1Vy121kSz1Rvlx;
        Sat, 19 Feb 2022 19:18:33 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 14/31] scsi: pm8001: Fix NCQ NON DATA command task initialization
Date:   Sun, 20 Feb 2022 12:17:53 +0900
Message-Id: <20220220031810.738362-15-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the pm8001_chip_sata_req() and pm80xx_chip_sata_req() functions, all
tasks with a DMA direction of DMA_NONE (no data transfer) are
initialized using the ATAP value 0x04. However, NCQ NON DATA commands,
while being DMA_NONE commands are NCQ commands and need to be
initialized using the value 0x07 for ATAP, similarly to other NCQ
commands.

Make sure that NCQ NON DATA command tasks are initialized similarly to
other NCQ commands by also testing the task "use_ncq" field in addition
to the DMA direction. While at it, reorganize the code into a chain of
if - else if - else to avoid useless affectations and debug messages.

Fixes: dbf9bfe61571 ("[SCSI] pm8001: add SAS/SATA HBA driver")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 14 +++++++-------
 drivers/scsi/pm8001/pm80xx_hwi.c | 13 ++++++-------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index d80b48e0e41b..c680baa5ef24 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4265,22 +4265,22 @@ static int pm8001_chip_sata_req(struct pm8001_hba=
_info *pm8001_ha,
 	u32  opc =3D OPC_INB_SATA_HOST_OPSTART;
 	memset(&sata_cmd, 0, sizeof(sata_cmd));
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
-	if (task->data_dir =3D=3D DMA_NONE) {
+
+	if (task->data_dir =3D=3D DMA_NONE && !task->ata_task.use_ncq) {
 		ATAP =3D 0x04;  /* no data*/
 		pm8001_dbg(pm8001_ha, IO, "no data\n");
 	} else if (likely(!task->ata_task.device_control_reg_update)) {
-		if (task->ata_task.dma_xfer) {
+		if (task->ata_task.use_ncq &&
+		    dev->sata_dev.class !=3D ATA_DEV_ATAPI) {
+			ATAP =3D 0x07; /* FPDMA */
+			pm8001_dbg(pm8001_ha, IO, "FPDMA\n");
+		} else if (task->ata_task.dma_xfer) {
 			ATAP =3D 0x06; /* DMA */
 			pm8001_dbg(pm8001_ha, IO, "DMA\n");
 		} else {
 			ATAP =3D 0x05; /* PIO*/
 			pm8001_dbg(pm8001_ha, IO, "PIO\n");
 		}
-		if (task->ata_task.use_ncq &&
-			dev->sata_dev.class !=3D ATA_DEV_ATAPI) {
-			ATAP =3D 0x07; /* FPDMA */
-			pm8001_dbg(pm8001_ha, IO, "FPDMA\n");
-		}
 	}
 	if (task->ata_task.use_ncq && pm8001_get_ncq_tag(task, &hdr_tag)) {
 		task->ata_task.fis.sector_count |=3D (u8) (hdr_tag << 3);
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 60c305f987b5..3deb89b11d2f 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4546,22 +4546,21 @@ static int pm80xx_chip_sata_req(struct pm8001_hba=
_info *pm8001_ha,
 	q_index =3D (u32) (cpu_id) % (pm8001_ha->max_q_num);
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[q_index];
=20
-	if (task->data_dir =3D=3D DMA_NONE) {
+	if (task->data_dir =3D=3D DMA_NONE && !task->ata_task.use_ncq) {
 		ATAP =3D 0x04; /* no data*/
 		pm8001_dbg(pm8001_ha, IO, "no data\n");
 	} else if (likely(!task->ata_task.device_control_reg_update)) {
-		if (task->ata_task.dma_xfer) {
+		if (task->ata_task.use_ncq &&
+		    dev->sata_dev.class !=3D ATA_DEV_ATAPI) {
+			ATAP =3D 0x07; /* FPDMA */
+			pm8001_dbg(pm8001_ha, IO, "FPDMA\n");
+		} else if (task->ata_task.dma_xfer) {
 			ATAP =3D 0x06; /* DMA */
 			pm8001_dbg(pm8001_ha, IO, "DMA\n");
 		} else {
 			ATAP =3D 0x05; /* PIO*/
 			pm8001_dbg(pm8001_ha, IO, "PIO\n");
 		}
-		if (task->ata_task.use_ncq &&
-		    dev->sata_dev.class !=3D ATA_DEV_ATAPI) {
-			ATAP =3D 0x07; /* FPDMA */
-			pm8001_dbg(pm8001_ha, IO, "FPDMA\n");
-		}
 	}
 	if (task->ata_task.use_ncq && pm8001_get_ncq_tag(task, &hdr_tag)) {
 		task->ata_task.fis.sector_count |=3D (u8) (hdr_tag << 3);
--=20
2.34.1

