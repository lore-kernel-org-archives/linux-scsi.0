Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B1BDC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:19:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239260AbiBNCTn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:19:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238144AbiBNCTm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:19:42 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 870E354BF3
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805172; x=1676341172;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=SkJwsNHfA/V1wKHVsC8Ec66YD9n/n5yPSoHBwobqogA=;
  b=W6FGJSAWMKn+M/LB2OSC8WREcWtlfY8HzGnYeDTI7F5gJdpjZXLBMFkb
   Qd1SyAUqFsvdf8JjFh0egH75q3vFSzDZtsWuQYeqxREPKLjPHFcHarkwj
   PTguLd6+iaAWP4d0rZ6OJl7AwFNayG6IUziqQgw9zJw2NN5NCa3PbTyyb
   tPSliAh7uIj5T80j7CvCUvnp3OqIjhm2+8C006dyX0seCUnVgYRJ5r42B
   KOi28Zck2PTWbI15dpe0x093P8JvCWiuGHuaSE5lmI6aXCxx7bIhT2hDI
   90X6ngxAFpkEX93R8ejhDn/K2VGn2LrDdJ1eZjNBmDUd5Uk8ohEJsg5h6
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819747"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:19:31 +0800
IronPort-SDR: 1dPZZhQr+d9xaH4+VZa1gcRgXdsZRM/Q6rUoXEDKRu7cqfiB4uZXN2SsdeHoimHgGr2avkD/fc
 CWxvOWNgR8WF+InaF9sLYVDuSvOcEWlIligPLfMwIYL9FrvDtcfDyN1YaRw0NmOimwne7OVpdS
 R2us1LTaT3ga8SuAfJ/4l7rYZtk9IHlsizDpNrmoDHW+RFoOlpNcZ0SjVJkDuQ80zoIk9YyvpX
 5RWGpgmNFjSazgna66tKfLCW3hUX9Mxr5aVDXghKP7SuqbXL2GQSkJQTjMlyd5AV0jy6mmACX7
 pKvnG2bMXgAXKPgD8ykJkmoK
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:23 -0800
IronPort-SDR: WWGw9Wz8/7wZbZ/Uuf8tGFNMQfhLJlwjwWV0UXNhsdazogkvQCb1RymZJT62IQCi7P/BwIpyl6
 63zCM9IkY+ZgJhUxoYOo4fpORpx11Z/ZbYW6r626t6a8KUKy1QQLf5yZCdaIYfb46cGYK5yfh6
 C9144v8T2hLBxav8LK5lMxavhAxpnxDaP4HBYGwY8N8FGJushm9AR91Prafd7oYzSR/Ls51/VN
 ZdVFmpnB45lxACcGGsdZWtYhUOH7HkMqeHPCubgSKBHxlJ/Apf/V52Kl4+gfULQIO81Sdiwc/q
 o+Y=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:19:32 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jxnwh0zfKz1SVp3
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:32 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805171; x=1647397172; bh=SkJwsNHfA/V1wKHVsC
        8Ec66YD9n/n5yPSoHBwobqogA=; b=W+MRUcRjW9xXlVifZyhJBahckpyrcY1swY
        6KaFDU68Ih7efPgPd+oaaAzx8v0d3JAUwu0dp2tvcqt/Ygja26ummTyct6gqUogD
        bT6oAOg/N4y3lXNCXW4N6J9DCKndmY51/HFFFmRAkLMlbPETURPzAfhpkes5OG+v
        C4LvoqAllL02X8/AG/kl0H14DoK5/NVSd774I80nggCveSjP56p2b5Jqu4SxsFSp
        2RY9qUQJw4o6qvGUE9fo8tBBfTmHRQsr8L5V87evCYLtgeUOfDaBtJER85Ji2ev1
        kcYKR0L1w95lvk5BOtTEd6CZgqPb1tS2vgGVUWiBMKR8x/4GGZdg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id BCVQ-VhwwyOg for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:19:31 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jxnwf514Rz1SHwl;
        Sun, 13 Feb 2022 18:19:30 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 01/31] scsi: libsas: Fix sas_ata_qc_issue() handling of NCQ NON DATA commands
Date:   Mon, 14 Feb 2022 11:17:17 +0900
Message-Id: <20220214021747.4976-2-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
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
index e0030a093994..50f779088b6e 100644
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

