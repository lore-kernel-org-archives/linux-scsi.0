Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C880C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240938AbiBQNar (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:30:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240925AbiBQNal (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:41 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253872AF3E2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104620; x=1676640620;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2ZQE1pOE9YcEN/n4KyjyAVRN9XwlQw1FqxLrAh53aEw=;
  b=CT6FKf+CLIc+ArePYvxDJCTRugoeETI0HCqIuM68swep5DMZSmhQkq5y
   uQsrs1NPVlZ/bYTkjdAsNjhMxSA+aepr5iD9LXKfmWPqYSOq/RUj94l8A
   p6+DuqFH7XivtOGaQDSId13BViHlHTmRiQmg7i22/ZFMoAC+pNy/UKZsX
   M5AELLu8FD/BoU/+OiIgwPh5ZmLsasfaiy5/OLN63G1EZnQ8JFL9yy3zP
   A+SQtTtfolm21xNdTnkkB4Jm3jk75oypDoEfJz+eXFkeAcxGxL28X4Q/+
   ZyJ6aKq9jSaO6vN5fC/fMhctOxrHjORwqN1TfNIuSbkX1+zxlSDwnGib2
   A==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303179"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:20 +0800
IronPort-SDR: 4dZszbW5k+1gKkKXrW5CYn4wP1xr9/iCnP0pcP/cd8fIQvW2SHeydHO9dZvxXB1MPwH/JLHms/
 8T8Kx9wOHq1rUpQe1zMvXXLQlcORj4FkQMZaMItzL9bX1tVL7kFQhMJB1oBvCo5enGL5a0pPYN
 NiruxkK9yD3ntLpn96OlodbaailhZVSmte4zVEbtncGXjR4L7pewhVZnjxKnDPeFFA7PxisAg3
 SPXi9TefL5fNQjEOdl3sQ1D3HE0mTJYpDoYs+r34pSvFLoPey3g315v53QZZkAL4sH595K06sG
 5XWnHdmhYy8p9Yx53OEmEqQs
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:01:58 -0800
IronPort-SDR: N6f2HNYY2s0kc9+3rEm2H4nuVQ5iCW9vzkTY/BZCkKOksBC8PMuiLik0b/5x6AI8KNm4wWBzsS
 RpIQ/e5dW1LE6+M1wgXgYDEUmcseHUL7xPsMWkzeF3BdxDmXiqG1e8y11PH3AHPfkoTggNUY0q
 ETHsM+mbuC9W9dqebtkH1pJTZt5+oVKkbgcbDR8/6l0AxFJ1S4Fv/iDoKAg5WikQr0uJVnkay7
 Xnri0Mfxfe/UaZ5gRi1fTEpJ3cAxkIbe84pvRbxhW0q8Z+RkMjSZab2KZPsodxNefsDVFSaFjm
 zYE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:20 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JzwgH5CgYz1SVp5
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:19 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104619; x=1647696620; bh=2ZQE1pOE9YcEN/n4Ky
        jyAVRN9XwlQw1FqxLrAh53aEw=; b=kChRK2xLai51C/zfQNpYAx9dJdXtPy4HIQ
        dxxkBJGvmcsQ+f69sNYsHH0VbTl3Qoil+P5TYu1HlDtfLGwb5q6uCFBa24x0dDBb
        XZoF09PwF4lM+BdrMZUgMy9NX6XKFYssodqcouPvGRyOGoBzf2VNoN3/ON+IyiBY
        RON/XA7xyVsxXo9zD18GWfiED6+7I+ABXwwqdbBZ7zikC/HSZxH5PX10jPwAFTVt
        BDy/UMaLPCGscvlSoeX9gzw5IkjsOVMfUNjlanLDedoELqa/ZWPBs/B407qbZOEb
        c5ufLta6BwGJJPUY3hzxyMivRTmuVzHeJA4GRk7SyuU9uxS0Ko7Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 5WGpckGfL65t for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:19 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JzwgF6tz2z1SHwl;
        Thu, 17 Feb 2022 05:30:17 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 14/31] scsi: pm8001: Fix NCQ NON DATA command task initialization
Date:   Thu, 17 Feb 2022 22:29:39 +0900
Message-Id: <20220217132956.484818-15-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
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
---
 drivers/scsi/pm8001/pm8001_hwi.c | 14 +++++++-------
 drivers/scsi/pm8001/pm80xx_hwi.c | 13 ++++++-------
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index e20a1d4db026..c0215a35a7b5 100644
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

