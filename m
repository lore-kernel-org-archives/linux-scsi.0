Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC66FC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 11:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241105AbiBJLmZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:42:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241058AbiBJLmY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 06:42:24 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AEB1019
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644493346; x=1676029346;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=V82tCpFaYvpcK1xKWfEXtOUXB3QC/wmQbMrXpEthOUo=;
  b=TVNbJO0c6fJe5WEGPvN9NIbEsMzx6KMlTv9zXFIgAm5fpJVr/Fj2LO/Z
   HXy6nH5Y8Hz3rwZQ9jwAMgbDot5ZF+aiYceLX8SCxZCVTlaNZGxDX0Pzm
   IUZk9C2trU+sECaANetms8Ev/Jn5nRLgiy2IyCB+52Otgt6dawwGH26o6
   o0aOu9JRcDePQdDNIHHznBAzF3/Wyha86hCwlCkmYJEvhG7BOwj7BjEc0
   1EJ+RNYOH+HPGnQYcXzTLTyj14uUDGSFk1N2yrASt4wG2CUTjsE5PczGA
   JgV5JI/webtpVgSoKN4W4XeyRLSQDZbv/rTfqgsTW/jyyxxw7nMr5wofz
   w==;
X-IronPort-AV: E=Sophos;i="5.88,358,1635177600"; 
   d="scan'208";a="193575605"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 19:42:25 +0800
IronPort-SDR: nNIoH7F5UZBL7eCoT5faJfsRTdK5AKaaeWf19BXLMjCBUzVBtq5BDIks3kGtmMTbVdvfRrO6AU
 hRL2rvxUy7VgS4LwIGPyaX3tne9jlBw/CqIn/zTBLHYZLbLCJZAg+VMzIHkyA4B7TJRAAR0tOu
 PydwW/D2A/GQQzuVM0is7StSzZyMECi17fKjCM1Le1u8Tj01O27dZUj/E3KaoWN7rYbLA+bB5B
 iAykKNxMCVJ2vpTFTszQ0w5381qjJ3+31vJXMObcOEg6HAEEo47JhmfVLC43e2MOfgGej2oECz
 fpDApxakiBvcN0y+JdJEKBCh
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:15:22 -0800
IronPort-SDR: q94iWborlo3LVyhrudGy20WEUPui+BcNwzJNFYq4NdG/66KM+lYRXUuR41l1KAsS9trXw0UnRh
 iqPcv5UCLAyJaRh+mRWGQuCYF9NRjThYMob7qfmhXkoSDWnFos8KF1ehp4zQbHnkD7tVf/0P45
 dPywHt4SZPGGWiqgCbZK5l+I+M2g2XH8qvXZVr+gqIYHQXoNSw84tMQy2DL4ZTzGyV6xl4oINS
 F2g7+ZnSt7Xsqu6M8YCSa4c6CH/vuvvSvY8U4PyodufupWikttCMY2+lM16DdTNkFpwsZpFwCw
 9Xk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:42:25 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvZc05tHHz1SVp2
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:24 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644493344; x=1647085345; bh=V82tCpFaYvpcK1xKWf
        EXtOUXB3QC/wmQbMrXpEthOUo=; b=TtJ3/Lk8eMusVlAuxf8Yqt00LjDP4uSRKK
        uPldJrZun7cHXvghQTe8RTOK3n4yOszMhY69OVWygHuo+IChyl9ZXiyxGXq4+fG1
        q3N4+Jy0VLpgVdSPmIbfBa1tR1z9gYWjSEtOdZ9leVyNyi+lDSt8n2KNFDNiDdSH
        oV0azj4hlkmpe0Ix8Q7ihY7jBAs+4b/AIw67tBk48KIHQYRKUOBccWtQgy0Dxf6k
        kIGzxTDPLvV5BV/c8F1OXiKv4aYVOcoCGXsjW0BmIHot7TQAXXh2sh+A6lLFxflR
        ByoONN8kmGhROReS9ffAggSjDxV9iQVdhsuOV6zbwY7m/NOP3xGQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id wAuUImQVHUF5 for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 03:42:24 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvZbz2ndmz1SHwl;
        Thu, 10 Feb 2022 03:42:23 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH 01/20] scsi: libsas: fix sas_ata_qc_issue() handling of NCQ NON DATA commands
Date:   Thu, 10 Feb 2022 20:41:59 +0900
Message-Id: <20220210114218.632725-2-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To detect for the DMA_NONE (no data transfer) DMA direction,
sas_ata_qc_issue() tests if the command protocol is ATA_PROT_NODATA.
This test does not include the ATA_CMD_NCQ_NON_DATA command as this
command protocol is defined as ATA_PROT_NCQ_NODATA (equal to
ATA_PROT_FLAG_NCQ) and not as ATA_PROT_NODATA.

To include both NCQ and non-NCQ commands when testing for the DMA_NONE
DMA direction, use "!ata_is_data()".

Fixes: 176ddd89171d ("scsi: libsas: Reset num_scatter if libata marks qc =
as NODATA")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/libsas/sas_ata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.=
c
index a315715b3622..7e0cde710fc3 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -197,7 +197,7 @@ static unsigned int sas_ata_qc_issue(struct ata_queue=
d_cmd *qc)
 		task->total_xfer_len =3D qc->nbytes;
 		task->num_scatter =3D qc->n_elem;
 		task->data_dir =3D qc->dma_dir;
-	} else if (qc->tf.protocol =3D=3D ATA_PROT_NODATA) {
+	} else if (!ata_is_data(qc->tf.protocol)) {
 		task->data_dir =3D DMA_NONE;
 	} else {
 		for_each_sg(qc->sg, sg, qc->n_elem, si)
--=20
2.34.1

