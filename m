Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2FD6C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 11:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241124AbiBJLnC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:43:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241152AbiBJLmo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 06:42:44 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8644C60
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644493366; x=1676029366;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=rlXxGp033QXTb1RelNIInaFL24iqKoMEzE7qeVpmiTw=;
  b=nNlb+ecqM3Tg8CZWMSP2amPZU3cV+f7dD1Gx4/Tob+0dejwUAj1tjpQ2
   Owcm+hFChnaht/57PgsfrZb5CNWuvC0ZVTDmPIw3yLPS5UEWGlgdRLVT/
   bCWIkdKI2rRz7fWKENfPpsP4E1+xfafaeaP9j3PYjFuPLcEZIKQ/dvl8z
   1DaTSQ8KRV1zmtrFRklyO0yZ0JX8/7wpmuScfnnQXQ1HRtuPVr6fP3EV5
   uU6RwAA2vg4Qx90JkvvvNFwZH7c5tSjEcwRZxGss2zo0CpSw1L0yohIBq
   E1rvymxshwODuSeDsd22s73C2hoe6c/Jtce9wAfYkSoAinmAqDoP2CwHS
   w==;
X-IronPort-AV: E=Sophos;i="5.88,358,1635177600"; 
   d="scan'208";a="193575664"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 19:42:46 +0800
IronPort-SDR: wnQrJhxSnuRD16GcQIqE/IVrdib/KRn+Sr/qhIbNK49oG5d6ynBVG6ldy+wJqafLJYZ5213vQD
 vP6q1jGNGRlAEtYhWV/TjyJ3NvaF3az8siOYZ5cD0OPMFZ9k0hOzEvtBObR733DceXJgYfsYyL
 8Z4xk3lZbv3/ivGI7gF8/GTEwvFgSanvf+fFv0QO7jfIpcy2ph3r7P6H06ZnpfPLGhgE83wD9z
 tYLQRTHGi65Bp1610S3TBQvi0uw/CqHRnHfO+cUCk5RNgm2ya66j6Yo7vQKjGb5LJiDghtTgRn
 4mfZYTMxW7UPqMbaXr6ot/eT
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:15:42 -0800
IronPort-SDR: bbd31btjjbh4UzV2PNTKi04v/A8EdaB225HhJRZkFDjp9p/WGV6wy4rgtlTKcUUkEb7n2o8JNH
 0FGiTlz7PC/44x9tiQMgyLfFKP0gnwaN7H+UQqTLT3zo39tL3V2Xy9WVSAynUvaw77AyafU9q2
 S9ckaz5jCxXVN3Z8iNdzQLwyIp01gIRWM8iSrLKEt97SJ7f9ADPb/eGv9R+RGHGKqfq/DiBnUb
 X7+ZtFRDDZyIT3Z4BGTvYgY8NitpBxu2vfEyh44o1hUbTujRoGsasao36ClNjEUCBnpnLlJ6FS
 1rA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:42:46 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvZcP1qMtz1SVnx
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:45 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644493364; x=1647085365; bh=rlXxGp033QXTb1RelN
        IInaFL24iqKoMEzE7qeVpmiTw=; b=qEPWu9hzNQt9kjdOxruiOyZ4H6g4/r89/l
        ZzjMftffBL2BcXfNxGulSkK6J1rR3Ke45lkYn9XwlnWRiHk+robsDa0Sk8y683rW
        dn2/eLcg7bwErVyuCTMqQqe7h2aYW+3xSZl0j9xpUmHleMnJ3qnVLy6oXHJ3KPTw
        WPUMb/SR7s6K/MLwdS+PNO6LsJ26OnT+5+TPqJFrdjHGvFjfeYndyHIslU6Lz56k
        KVIlHwTgISfbZl5hwF11FHHgX9B4KngmiS2+UA+TxbHA6YbKutWj7iYlet4ATWhR
        GDJ/FkOR+HvfNuZLCpoKOYghN8bFMZUFoaywg92IgvGMD72UVyfg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id KY4Qn7q_gvMi for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 03:42:44 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvZcM5Rw1z1Rwrw;
        Thu, 10 Feb 2022 03:42:43 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH 17/20] scsi: pm8001: fix NCQ NON DATA command task initialization
Date:   Thu, 10 Feb 2022 20:42:15 +0900
Message-Id: <20220210114218.632725-18-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
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
index dc0a84c81189..44071a97d23b 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4551,22 +4551,21 @@ static int pm80xx_chip_sata_req(struct pm8001_hba=
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

