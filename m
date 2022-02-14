Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1833C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239288AbiBNCT7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:19:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239278AbiBNCTq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:19:46 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B0754F9C
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805178; x=1676341178;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=iJwXDMeNXdwiuQiNAJCJFMRv0jlB2dyc+Scv5z3ZPjg=;
  b=kpGNZLz4lFZuMDB53ougvSWEamjl/Pzbo1WqarjfpX5A3thwZyxijUHg
   apCZTuIfZ2huK4eTjKhTRodQCOrLzT6Cb7ATaFoSqTTveBRCNXhVdYok1
   2GegvJ+CcvVsUFVQe5eZ6zTFSS52YTm49KeOfifcBOIXDk3gMzFkvTImp
   q8Inb1vPJUa1i4H8+j7//Gx8sqEMHtuEZw9VhIcB5ZGSswKSHq8H63fiE
   AimXAiR5Oar+jORcrfu1n0yUnGcllDUax2moiKkMav4DDw9wySHU2UctR
   OY1Q6gWnQ5zx0gfTmdaPXaxfvXkzccDozFRiMZMl9nnMbcdJiJOFfF8cY
   A==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819766"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:19:38 +0800
IronPort-SDR: ht8pVfiS533d/b9wXgB4XQhhuownmROTm9i/rqAXcTBklQ1SMz2nNRnObrDmPl+BfNpQmV+Qz+
 BmRgs1IcuKXhTR/D9u7K7sLwrJksaEr74rx7cziDc3R/Jb4vLlRVE1jDo38oBMaZFDkBy+0a1q
 rz1kW6ykfk/mn5rmw+e9eRc8EpVWIXk0ZR/YxJYtDiefIUJM6c17UfdKjJ/oJZANGfDM+xkje8
 JP8ubV00Y8lnlIo4aPxtZEY4ZF2MAdoHDQdnl/tOx8p1GmEjmiLTGASMSKtCWnhoGXqtHUKUMB
 tyD70LS/oAyr/virUCjb9tRL
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:30 -0800
IronPort-SDR: Wdj+pK/MxQcE41PdE+ntoDSzNFK+F0rFvAMcoVu9lQAEIiByYeZAW8pcP7sbN1dIfT6SphnRV7
 3ZQiKFZFoJ/V1T55uZjvH930je5kOVcE+uDzmxKgEXQjdwsBaMbbriUJgx6xoEd5JSILfBgd3n
 vTz/ZafXJpkD0XMBxVHArXDMa+CubLF8qj9G+4GPgREAZOHx0VCKqT7pV7AIhz94re6xxsOITN
 n8++e0YWuFueR9952wxHcUD8nqUeSbDiNSy4SVY9Wz6hmhizW7eqBfMkItv8ecOhfn1I3Zavyb
 zhg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:19:39 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jxnwq340Bz1SVp3
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:39 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805178; x=1647397179; bh=iJwXDMeNXdwiuQiNAJ
        CJFMRv0jlB2dyc+Scv5z3ZPjg=; b=tEMlG14Qg9I1ZoPxioqvNNO3Ma695CsU9g
        LAYW8E2hWlfYO2zc1Iz0hB4+W5czaCkXakn/j5HeBgeqWj3Fw5CAgHKMZTq7xlTh
        wvja1FVs+iv2K1rVxmAmq482OzqyuF7n7gFJQYd7SsgE5z78dWlBns8tsOZ5aWB6
        ipkgEkWpzOv7n5RrLf8MzzsGStaWtq+221bnKzkSqzCPTGqoTaD0DhtEXHIz6sKS
        L8C+JxUIpv9eZmskGVVkdhLpgPTqrOp8kEx0/Wutr0o4OHM81c05Tul4RqIl4sZ5
        8z5toZ9EUJZHX/MH6x7JiQJ9Tg4TzN7RXCXS0vQI9nDkY7ic+V5g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 5LYIz-aH8hlx for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:19:38 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jxnwn6lZqz1SHwl;
        Sun, 13 Feb 2022 18:19:37 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 07/31] scsi: pm8001: Fix payload initialization in pm80xx_set_thermal_config()
Date:   Mon, 14 Feb 2022 11:17:23 +0900
Message-Id: <20220214021747.4976-8-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The fields of the set_ctrl_cfg_req structure have the __le32 type, so
use cpu_to_le32() to assign them. This removes the sparse warnings:

warning: incorrect type in assignment (different base types)
    expected restricted __le32
    got unsigned int

Fixes: 842784e0d15b ("pm80xx: Update For Thermal Page Code")
Fixes: f5860992db55 ("[SCSI] pm80xx: Added SPCv/ve specific hardware func=
tionalities and relevant changes in common files")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 8a2d4087d405..f9c4cec514fb 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1201,9 +1201,11 @@ pm80xx_set_thermal_config(struct pm8001_hba_info *=
pm8001_ha)
 	else
 		page_code =3D THERMAL_PAGE_CODE_8H;
=20
-	payload.cfg_pg[0] =3D (THERMAL_LOG_ENABLE << 9) |
-				(THERMAL_ENABLE << 8) | page_code;
-	payload.cfg_pg[1] =3D (LTEMPHIL << 24) | (RTEMPHIL << 8);
+	payload.cfg_pg[0] =3D
+		cpu_to_le32((THERMAL_LOG_ENABLE << 9) |
+			    (THERMAL_ENABLE << 8) | page_code);
+	payload.cfg_pg[1] =3D
+		cpu_to_le32((LTEMPHIL << 24) | (RTEMPHIL << 8));
=20
 	pm8001_dbg(pm8001_ha, DEV,
 		   "Setting up thermal config. cfg_pg 0 0x%x cfg_pg 1 0x%x\n",
--=20
2.34.1

