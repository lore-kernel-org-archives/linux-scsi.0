Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69337C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:15:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbiBRDPs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:15:48 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbiBRDPZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:25 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0F312A757
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154109; x=1676690109;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cm4NHH8QFWFhsmZPJF6NC1uwQRhBpzoxbcq11J3AtIA=;
  b=YA+FllRDPXKlatBUdBJDR5ANiMju+rr44L5qO8pFS3JfNcVp1mXaPZdP
   HKU06gUTrP1RCFrd19ET6jWFJAyOsCsGMvjPqal5zWD52lkLozRtV7j26
   MqHiuq1iE2kjwmdnt48Uxgi+qpcAcodUW2G1ixtuhcMtMjlUnHWqNSsSE
   IFvZGlNW8cIYKRCI7H7JJxEiyNzyiLRxXMyPH/ZKacUlwQ/O/ExUz7liV
   ZNLSkgR5lkCsIGr1gU59yUGrl5fpnJ/JSEZ4Iy7NCVYKNQio2qoLsMupD
   O2S/RDORbgiSFSZ52qDDRk1fbNz5YE3NFeXGjPZzeu30B4Bi4xTWlvvhF
   w==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="194225786"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:15:09 +0800
IronPort-SDR: a5vrXCqxYDrZkxRFaFGn+i0m1Q7C1n5V69PvKJJblVM3JEqAbEWzN9CGDhZI6ti9pQsBLeKdq3
 U7/sChK9iSMXzgc/fyjWlgJ0AKPu9fwO4sajWJltZawfpAsHydsYuGDE5aVSl9iZXMI6Z9M4dl
 d80oDREjyGuYcApwCs+imlMmr8RYgoRlxKnc5vUAd8tndb30tL3opIZd8YNb7itKH5cD0cN6Ij
 /6tJK771Hz+uOduBhD060JCAJZhB4V1xDKtAbYbInEWCNYsoRS8ReFGDkAtFQpLKdblk4erZ7C
 TjWVLZc7Da8KUJG6Ake1uS7K
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:46:47 -0800
IronPort-SDR: 52XnIsdQKcrZjPUvMu9wmVcAuiloGk899sHjuH9tWI6fkWzre30MBge8RpucZihTbum6mae1Ia
 sOYZOs/QNayqaPjj8f1EyM/aBmDBlMtV+9qOMjlsdBM37tD0yMx9jjA23RDLQL7kTIe0+4I88c
 sUgGZOcced9S3OS5pvmNUK9jQx31n9mb3FxOZ3823zKhKtBZ4GdxNQDYt45TI+f4Ues3S1/3T+
 TGKprAGTzfWl4thJCJFXeWRCMyWn0peF3niVND2+j6j7hyxDma/by5T99OCNsIyU041qxs1jWo
 vx8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:15:09 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0Gz0531mz1SVp5
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:08 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154108; x=1647746109; bh=Cm4NHH8QFWFhsmZPJF
        6NC1uwQRhBpzoxbcq11J3AtIA=; b=DpGuEt2EvCNIpkShjp/yT7gdZUaXPTfVax
        5zdphz5JXyJwGduxlU92Lrnu47tJotO/aeyktos4xPswOOiM7k9LdWAIwENXSv1u
        ELib4PeoQFWUynZLRyiTtyywozC2N/wHsO/q6Q90LmKEkwi8n/WK+gXJU9poQaRy
        hk2qrcVePWdubvkyIB6R3iP9MZxyRF/8zoooHo16CoGgjB1usGkY+lvlUFBMZxbf
        2TQmOm0cfNL0ITuiSAwbLJNkpVXW+OI+oJQI6CHCv8spmhUJyH3ZKTXLO5lithST
        rBVRgIs9Hj1scEqXgnMl4Ach6LYdEH5e/mZSQplQcJEcUA0vjYsg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id pGkhVEjWiueP for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:15:08 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0Gyy6ky3z1SHwl;
        Thu, 17 Feb 2022 19:15:06 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 14/31] scsi: pm8001: Fix NCQ NON DATA command task initialization
Date:   Fri, 18 Feb 2022 12:14:28 +0900
Message-Id: <20220218031445.548767-15-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
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

