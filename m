Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF2DC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbiBTDSi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:18:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiBTDSh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:18:37 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E00340D0
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327096; x=1676863096;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=irf9kVvrFWPtjmT/Y9qUzAV7O6VBkyqkzMJlMmbKmPE=;
  b=aEfiobw9TdIax0+2hDE6ZW9NfjbKEejod+svgc9G/QTBdzpcLP9u3gmb
   h65PgHFynVKEWDTo+I9FViDeJO8sMtoBgKddAAkRv9W4nRum3MxBTwSME
   sto7Sh9OKrSxHG+A4MNmygRc+loVK5CG7r9vn7doadHlTWwcWFKmBbPCP
   UTlePfRC/zxnx2b6rqX2nSOq+mksovmXz62QVww/7OSDXyBJs5hn/4Y9n
   hFH0W6BvwsMUhGogl0QKZ26iaddputWiLAZATtyEAJ7epV3kPbaX+L2gp
   FB+PWQI4McktRY6oawO42sQMafHqSJwBP0jZe9vBkswAvc0/nkQcdYcId
   w==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405725"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:15 +0800
IronPort-SDR: F/btDo+TbyQDDgbPAYjWWDSKhuPRH/GwBRikX1r9cNI2idXO7v7OyY1yg+4LapEu933P9FYEG7
 2JRVDrCzA6O34LcOOIt6mWIQdr3RcRfK8a9uxx5q9I8ahaHbTEy4ZdIS4b5XhpQJtXFYSgQApG
 ocTpv+hYbp/YTgkAMN//rqV/Vmocn2dqIjmfzTVttmgDMbl22gqDxFVixM6VyB9ldueMOW5HB/
 C4EkQBKsfYD0wYataNFwLb6AjN8ahT5uk/8X6JUJZJdrCf11ND0kIAIqW0AKAuu2CsI5CHIPN9
 TefSIxfuJGRjpynjpU/JLdn9
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:49:52 -0800
IronPort-SDR: iyI298WQ7I2R3+HG9NXZDnV9R4oPAIb7KHIhZvxrb+QAP5brcZo/fj9jaYQdzpxzuWoLR6NnL/
 hgO946kMR2snWvfrQ+hw910CAeKQ0sA7bgCzVoe4sWGR0TKIlnEDuCfkDeGSwbx/7sWY73dEG3
 EeW7F8vId+/Av8jUI+hH5WdpMYR/aTDbinSOc83BhHDfFAsafG1gR9+eTygqErhSE9w8wMXrXo
 ci2DtgPFBp6IqnQZm2eelLNf4JhzHeNWr/Z9+NKSqpXdnc4LTWz46KqPn6AVXi/j37RgORUPel
 ixE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:17 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1Vxh3LNbz1SVp2
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:16 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327095; x=1647919096; bh=irf9kVvrFWPtjmT/Y9
        qUzAV7O6VBkyqkzMJlMmbKmPE=; b=m2vIjEBPF3FkORVB8AEOEwpba++eOSJ6wA
        oLcKVK3oRku70ApKxB14Sat1bhO914xmesthHh3Eiy4eP5unjtvnkrmd72Me89Cy
        3tSTNy2GlQ4UYOSEfzA/+KVHAc+fvsH2HYlIgV9Y/iv2Rgb4BMh8NyANIN/Ha5TH
        uRw+CfVPwkjt51RshPgHYcSUp8NXdgT5egbWE+r3Xe+uMSISzPuedR5YqzW3yEiJ
        YgeLQiVdoZ16Wa2qfIK0J3A8rG5KYvrjXdzx93xpWHMp2YCIIfLlGSHLvNfb/Coy
        0M5yaLfMB2Em0pY8yyIqAckzGz2MY385BoBB8sLay9v8Y8mwoCMA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id UHq8a9yHV0AN for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:15 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1Vxf5p0Sz1Rwrw;
        Sat, 19 Feb 2022 19:18:14 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 01/31] scsi: libsas: Fix sas_ata_qc_issue() handling of NCQ NON DATA commands
Date:   Sun, 20 Feb 2022 12:17:40 +0900
Message-Id: <20220220031810.738362-2-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
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
Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/libsas/sas_ata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.=
c
index d89ffb357f14..dd4ae5e8cb5c 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -195,7 +195,7 @@ static unsigned int sas_ata_qc_issue(struct ata_queue=
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

