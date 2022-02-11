Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 797D3C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347741AbiBKHhj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:37:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347717AbiBKHhf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:35 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBAA25C3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565047; x=1676101047;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=WRJ7YjUS7L+40YA6RuU0P5ISAqIp3F+S+1UznVatJjM=;
  b=UtyxWvCC2Gli9r7SsyFpfTsuIepeoy9lwJqiNFrsAuRnkwcBjABEBxmK
   dirgNQm8jWNJd4LWIS3yz4Q00J7ZQRIiUzAGiWpTiGiIJKDBF1Pj2JnXp
   Qle1bTKsJuzRcvqArSFEriXu3xufztERHRdr4gjF+AtXO1UkVWBHgsQm0
   xjCgoc9Rd3RMgJpzLnzdZNn4wi2hgj/nz9JjSbA81uTCIxT6E9eNApmZU
   FQQsEGmLEi9uiJLhQ/dgQK2J8u+8X5zn1QLzS2TXKgq2KCn81/J9yxfcW
   wul7NuQWkPusSHIFxWSTPTbwnkBLmcVIblZvVPbVnqbLTZ6ehH8zyh7ol
   A==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675154"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:26 +0800
IronPort-SDR: 5DpO3iHkjWmJo0dCXcJRtK93wyhcYtEZhhVEAD2nUsv3+gbeiT1/wAAxVARtdc6B2VJKLRDmQ2
 x5+Q0swLZ6rAnnwD9wPCxRkNjxFa59V0ZR34EoQMsUL2QFisAyM1C5JFignpeT8XaAG0dZQjGe
 B1wy1uXPD+kedJUQ2604PEXJ1JwN9RkkmgrDWsmEPReBW5T9ZRNArYSifvQSx4TxWapkrNb90Q
 6+i8TvfyB73CsZN3yeLL9lVvlS3LgUMRMs4UVy9OPRqvepXETXxC8ainX12rK4uHzACtnRGZAA
 yfMCo1B84wda1Y35BHWlfpHV
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:09:15 -0800
IronPort-SDR: 9mOvN+4UjKEfZtLYETanNnLsZ+99xC7HnOnRODNPpzSN/ZMkNNC+E5H1nheJkWMhK7SAif1zsO
 eFpOI6DGpH/cSGlJeuOeqNDMc9k0CDvzQLdOWDM6VEvX4zUezmO8JydmJuLYBYd9Q14ylppbJ0
 mvBTAjF9sme6TLeizp8dnwbe1VDRmLDu81uG+WInEmpwS1QiXACxQJ+Ld6IdLL2VcMUe0x1U73
 wuEv2RMRK0qydLoIYUKs1T7UgLMbiJXOJNHbL3TzcbSfPn/xF+HwN7WHygr041zKrFpuCmtdg9
 i4o=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:29 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw56w3Yyqz1SVp1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:28 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565047; x=1647157048; bh=WRJ7YjUS7L+40YA6Ru
        U0P5ISAqIp3F+S+1UznVatJjM=; b=hwCQMfh7d6LM9G2nS2QM3OFdK9tplxvGaR
        M4x2Zlky+gFzlLozmSVrKEs8psC9M2TEL4oGroorN3popdhXhPd+pmHV/3KKM4qq
        JfOBkyZ8LuOvD0ChbVu1KUVpll4a4ZPwVw6suwAZUNwhiU4uTaQZZnJ7d5LI6UQi
        K9tuHmcdsO3o7V2HLOcUC8VQtUy5qY4pGlZNm8lzkRh+vXCgy6ifcpLSDoAc3s9t
        hv1rsui8+XHEHzYO5W3viNSBLgtcxP349JSf87WmJJwaiacHxd/5a6n5kCGqGN5L
        X94LHbGiBxu5pikxSc4WN9NdCjaK/F2JxbWzL0PE9x1XTfBi/DxQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id MwDNUolGKZtV for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:27 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw56v0GCQz1Rwrw;
        Thu, 10 Feb 2022 23:37:26 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 17/24] scsi: pm8001: fix NCQ NON DATA command task initialization
Date:   Fri, 11 Feb 2022 16:36:57 +0900
Message-Id: <20220211073704.963993-18-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
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
index 43c2ab90f711..9d982eb970fe 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4271,22 +4271,22 @@ static int pm8001_chip_sata_req(struct pm8001_hba=
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
index 288bad31b423..283b68d7da24 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4550,22 +4550,21 @@ static int pm80xx_chip_sata_req(struct pm8001_hba=
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

