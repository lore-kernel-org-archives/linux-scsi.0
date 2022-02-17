Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8666BC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:30:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240595AbiBQNaQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:30:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239103AbiBQNaP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:15 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9EA2AE2BE
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104601; x=1676640601;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MDhhb181EccMwnLd3hc+xNPmlMVSvpeLw+Zq8aeckxg=;
  b=L3UV+Hsl2Y53eAYyvwNWRUrOZ3yUiMJviQkTK03yiUAj70V8A1MU8LYx
   wpYzVftRdWp1fuYGJ9ZqobtP61KNEi/AsOTZ/n/qOzI76s1cgPzDshzEU
   N/TfL1A2lBikqvd8gTSaJuV8H/ZhUigV5MLl17UQWJt2bmlfNIN/fE33j
   5rFseY4LW3HLAolAEUHw1QWBAbhwVRrQygRYfFDz1rtkAnAuorb62Taxg
   /yMkG2r9H41/DRYwTpwa6L5FhmjYOjiBNEnGchuFsxes1NV9OOswaP+JI
   XO54u85ajXiHhD12u+4lfiLl/ORyt9+ZQcl3kmlkWZ/IdWtYhZ0dpiwjE
   A==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303129"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:01 +0800
IronPort-SDR: eC0SZq9v40aBy0evUopx0NXUGiSOYuxio3SjHluLpnXoZObZ242T+G7uMNUf0OsOZq9n0rT/1Q
 Y9ZjsyB9HjFg7C+KC15t4fidSw8I0p8z1fZ3WLR7vfycEuXO6BHZ0xQTOmeZmGJDJlq71fW8Di
 fgykIDXkz8kWIwPMFESsKV9pE+QnSGDMhqvZ6o3buQ3HcMKXcuVoYZz3hEY5enyL8DUo2NUTxp
 cm248RMUEDxB9oa0z5KthiUheBo5E83QWEWAvmic4e9Bngepx+tt5xj4JNiEbsjVrChma/2U2Q
 sy+egMkDVpCy5GIySnTrAU4q
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:01:40 -0800
IronPort-SDR: 6eO3CShNA3fWxzIjp2OQDPYesUspKV0/aZ2jzGJz5I8HID9DbtSV5TKEbUZGLksBpjteBKUqDo
 qTDG9lfnhtXLFTkgDvjiWMTDkNkd4QtczMl9hoz13W7g11GOtiUmkZTtteGNoUyXYWiSXt6AWi
 Fl0jgkxdbMJYemPCJV7uarywDIeHIrsc7ecRNA4FjfnshB3W4H4uanak/7Z9j3IFBwf5Z25jFo
 0UoCfQFJUGGHdpnSSCHiX2tldPcaXp8oMgCuWVPf4+eVICd/a4kZk+u1PowWxiAPsoAJJ5zRWY
 eGo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:01 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jzwfw6dzwz1SVp2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:00 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104600; x=1647696601; bh=MDhhb181EccMwnLd3h
        c+xNPmlMVSvpeLw+Zq8aeckxg=; b=q9YI+6ffJSQ0ABDJ8yYYFHC7d4L2NQUa19
        frPzdC5DpTDW74Cv8GXSr0hqXPxyYHVaPcinFWAlYvwSwGcmJaykSeKW/Cm8gYIk
        s+qLnY9kEZdrz58lQIbA3n/LhhZe1x3AAVbZb7renS3CC6J3XIdXD0HJL4tapMZb
        K0rjabVMuQrjamY24b1DIoMFUEQ1XOkGu2Nsv2zrYYYGTRNLVJmTFlkBJR7IF0X2
        eOCx4fxEgg13Orh5VqglHgYL38qSPicFMwPe/FT8+fJJ7lxemdRo91Z9SiGbUqIZ
        t53CnchsPk6ONZnkBWt4LIi8xzS6ZIQFDnyw2x9IlaGnfjLISAsg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id anKfEu7KwslM for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:00 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jzwfv24Dkz1SHwl;
        Thu, 17 Feb 2022 05:29:58 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 01/31] scsi: libsas: Fix sas_ata_qc_issue() handling of NCQ NON DATA commands
Date:   Thu, 17 Feb 2022 22:29:26 +0900
Message-Id: <20220217132956.484818-2-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
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

