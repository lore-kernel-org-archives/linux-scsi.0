Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 625CCC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239338AbiBNCUJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:20:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239300AbiBNCT6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:19:58 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0942F5548A
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805187; x=1676341187;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=t/WNZKYeyLBwFXhlFGTVtK2Melx7SSJT0u5Enyjx12E=;
  b=pWIALOa/F0Zjdj/bLZONzZRZAlPpSKSY2C+Sr/fa9QfPP4CL2yoRrT1y
   1pN6iVQcUJ8eZv1v8sb/I2gj3w2gG8tZLlSDjCkjKBWCOp6MasGN1WjJS
   SVmr3Mp/RGikcgzdB/49IsoB6qXWupFNZaD5Zv6BTJBsB4Gqmk6sKQFH4
   QvcDYxF2geyOry54zzXL3hhlCtLf5oyMyVLqXxvHZpqw1ZdvAvraXolQ3
   0t+vGxydExfzvob3OGXPt6PPAuftae6mS6Z3DxuAR/C+Mad9thisV+3Do
   Dj6+ELN7hN2Jd+w17VkVIdrxOJhZ/d0TTqQSXy3pky1WunysSlAgknXTn
   A==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819781"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:19:47 +0800
IronPort-SDR: II0ObshelsijRI4kSpu3qH1F8bGt7CavQbFV2QLP1c0zHzIznfrCn+VjHMo7BS2LmQbdRtEA4J
 0unFsyUReQlZJKkHFACKPKPv1WXk+AbNCJ62aQ8DTnDJun2mgsKM/RrmfFocBQyQcN4jUKwiNL
 L9rrY8hK9kuVnrYc7mdhjPYwQRWkB+q1rVuSgnz1reeceUQr23bqG8IpSLL92s4Or5yokV7X/K
 +/OWtAo6h11FC9abiLk+1xmTFDHH9KaJSHDVL2/HCu+XbT61i+CaVVlob1+peEEhWh3ojwhWLr
 zsJc0UyjB8UfeVnJH7NyM2hz
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:40 -0800
IronPort-SDR: qIRdADW0JfPdjro2iHr7FG/jOe4SIdF2e3kTo0kKmWqkPVBE1DQL07lWrvgYLfG1FAK12My5VT
 j5BYxGrfgIUebmppZk3CSgbKuuVACAZztrNyPJLbMpIIcly6bRxmanMy7yHmALT4CCuAHyEyai
 SmZsTVi3bc2SS4bMCOp1QM/rY3FRH1G74kvNrii76iAFlosAfWeWd3AQXaprP4mc0KxbzL+kpp
 43xyVzlIb5AOu20+EBvJ09LpcA46Dp5PcdPnOkjDB097EDPpRgHpSk6992WMM3vDijVbEjtY0E
 md0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:19:49 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jxnx04L50z1SVp6
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:48 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805188; x=1647397189; bh=t/WNZKYeyLBwFXhlFG
        TVtK2Melx7SSJT0u5Enyjx12E=; b=X7Ov9HkqEy+odnptvgxtR8M3KkwFBRrlfT
        jha3I+umrMNhsSuZ15/eUtNsqSPmMnDhLOVBkXrYOh2ls09i6YNiTqDp1p7NnUc7
        MSc6sJzCchK2B3O5uU+pJ3FXoMGs0aRnhDPMK/1wG4Npqxp5TaU4YBlHofT+R4L1
        nyQ/ZHbvk0jvNgpXI7lb/nD0cMKq4ohJrM5qVQskCBia9jr9UDyk1RfJR/jROzWA
        Zjb76SM5oCsu3M+J3f6cizIKp5C/XO0Z0n2qvwzz8/kEiBbPzJZILaSqT1fH2+yu
        FZkrCyr6d4F/uaCssxnUWyvntYYJoRDf0UrrV9HDyr/OVg1aJvIw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id d3dacjywPhOh for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:19:48 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jxnwz0P2Cz1SVp0;
        Sun, 13 Feb 2022 18:19:46 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 14/31] scsi: pm8001: Fix NCQ NON DATA command task initialization
Date:   Mon, 14 Feb 2022 11:17:30 +0900
Message-Id: <20220214021747.4976-15-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
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
index 3893bd470bcc..3c667e67cd2e 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4282,22 +4282,22 @@ static int pm8001_chip_sata_req(struct pm8001_hba=
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
index ad2e40425fbf..e3b03ddc26f8 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4558,22 +4558,21 @@ static int pm80xx_chip_sata_req(struct pm8001_hba=
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

