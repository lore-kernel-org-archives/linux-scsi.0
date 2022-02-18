Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1EBCC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbiBRDPH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:15:07 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbiBRDPG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:06 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149ECC3C08
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154092; x=1676690092;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u85LIoy2ZxhE8wzXAPZ3ypOuEIVonuWRNbAo6YJw+pM=;
  b=XmyXiGRUyG8g5Bsn9GJz5evpLtkZpN+KEHrE5m6OesRuxSsD0JtqaHoW
   6WjrcEA7Ppbfu23bchEVoG32hj4MOYXwNQ/WHWFqPs4ev+Lon84asaO+R
   /66mFdsRPGl8W3ryrzJCOdrz+p4QCj2zVVJ0jbEmCtOBJ9gt/6uJIaAql
   5T1eogLe4llR6Sk5CjtrjguBKxO5frxfRLd25p3pyYgEBJGiTOHpROMYV
   fu6yERVVUWOgVn+yVsGQ1+Vf84Qx0hwspu6vagkaTMlucNSKobEGbFhG5
   dIOtdQgC5tZygWRNPr7nJnIoYmhNnHwJ0V3Mr6pxPN/rDK+ImQ9FGwe2o
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="194225697"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:14:51 +0800
IronPort-SDR: QnABjHRCn/SW94UDU/5Tc4UcSvDgwMaloqHdXqaia8Gx2MVxgC95ltXrraUpLRS6BWgj2I3ruO
 gXhxRb6d7qOJQFnttV2iu2pNbDpyL3bUI3SiCVGmxzjb2o4YgU9ojrqnTPt6H9cCQAdDAqZbfs
 JIioPi8cPc01eRlCrdyD0BJA2QXrZLmVNFy7zH8SaVtF7wv/id2Rw35IkrIJ8c5FR4gy0OkN76
 GN+l0XocuD2+BJjFf2mQMaLko5WVoijPralbhEZLywJ9MeZWPHl1Br2fLvhgsSDjJsOHqqM/Bj
 oJW0ri3n7R9Un5uzpX8U4msK
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:46:28 -0800
IronPort-SDR: NAxF8SS/lsJoRUduhYcRTEMSIp1djNZbHvQ3xlF2otjW97d9/v2pWYrrXe6bpsrnm0hiltMPLw
 xBwbv9E5bsl1bWm0K3iBrjTnSVt+tmZcUXEDV2jirl9iCa5d8/oKO0sJ2sDCWcuQLQdiX5Ia1f
 pRMtKFQOpdJKlorjTRnraU/IhCCqUdyCLgS6Y7hzS1fh3M3UPaeARMDzZgmLeAnkrGCRJxryRV
 II7BOrVZp6dUFpHPSG/UufUSaIsZV9VBQVsyA1YjirrhqB4rt3JTcajDjsmHxEwm8jJAp+pZ9T
 14E=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:14:51 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0Gyf4G3wz1SVp2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:14:50 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154090; x=1647746091; bh=u85LIoy2ZxhE8wzXAP
        Z3ypOuEIVonuWRNbAo6YJw+pM=; b=g0s5WpPTksgQ+GiTqbkn+cBcJGjRQsx9bm
        3nyX34VwPx7oidUhx1Tw8g1VQk6cgNHQBlt9/3CbTnfGRjf2beLYoqUUvyq53Xts
        j5fmHdo2wu4aXyF88yOY7RYzXLG3vMySCGYn6JS+YYhCtaw7YbnBpBlpVEmrvwX9
        E7R1iqj7ZTdVRxFWw34edP7vM9aTNelCC6CHf7B4blxFPnLSyr68vFSmyaRObyg+
        3eKHxeqV8DIuyKe3FQ1WvQbzPjWBrboQLUnAYipDHZz4Jz8IMBcjeNczEI3G2Vhp
        UB/00btnxhQyLA2FdiOhrSPIgFvmQHS+G2CNv5MWzy3RihkLY7lQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id uDP4MPdYEAz3 for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:14:50 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0Gyc5DzXz1SHwl;
        Thu, 17 Feb 2022 19:14:48 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 01/31] scsi: libsas: Fix sas_ata_qc_issue() handling of NCQ NON DATA commands
Date:   Fri, 18 Feb 2022 12:14:15 +0900
Message-Id: <20220218031445.548767-2-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
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

