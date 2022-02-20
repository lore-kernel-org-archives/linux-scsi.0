Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2552EC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239777AbiBTDSw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:18:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237906AbiBTDSp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:18:45 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB6A340CD
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327104; x=1676863104;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QveB5a+85eplIPaj4PtIIZ6/INt1r9nE8RbC6a9EBNw=;
  b=Tcyq09cEQAgX2MdVpY+5NK7xmiO/CUCu56BNvMV7ODeDwmtGzRnOqADR
   649IfFsMkYTriS0N0xzhXEBpJDAtjTMnteKDZCo44/9avDy10Zoqap4c1
   nhdksHprDGCGXKC+PxOJrC7pPRkyVnsnfCbiQMW8626Suaj4r7QFlIDVp
   qsAFED2oq5UCeoXhrqkbzzOJVSZlD1cVAyYmnH3gXzklTITL+r+P8Odq3
   z6oJDMdEZAaHfcL34v2l0u0bcTk/ftuSa7hCERJLSQUWeUnUzmw/qkviM
   sHYZUXUbzMEFNGR+ZGDy0x6O/LI00cY+GRtQw5ynlD2oYADVBZhILN6mz
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405749"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:24 +0800
IronPort-SDR: ViGUMU7PBCCwUPIpX4eYYVn6AqSXJFgTLbAGGdzwX3zkQqIscuBr0XmzjCEZwq2ZaC3rriHp/2
 wZcaK5gregNs+jBbkikjUFnsL1iPxOv9/xGkrRI9c0FL1dHaFnacz0v5xEbbmEW02lZErX6d1b
 XyFkIUtQ5SPeE7dRZN8e/QlVn1nBZvoiONpXpGr3CrtUXdKvH0pVFb2Mk7gkUArI2Zcuoeaz4p
 Iw0F6gtCx2huVZ4o3pA3T7Xu1W8B0IdXHw1yZxHaxV7Dt6RhHGau89PR0ufL9l3Csfkr/LGEYL
 g8dNfE/ayRRmu4dZdnMYzwzm
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:50:00 -0800
IronPort-SDR: GDq8zRZQ0hsXx/IiVCmFdg+290VytsxoBkBp0DhuyAVP/EJArhYmNG2vdcQq/yCRhPgPVxuCDA
 oRlJmVmQIMIGSo2ds1FC+OuXJX3PLG1iHX8yreNdQYE7RYlbBvzb63Jkm8gOLczHrnBENtY72A
 pVmbBE3uSYg3Zw+HSad0V5YJrJTlKfzfEGVJXfKerCXSa00w9HgEwvAP79aqBT5bcktefz/NLO
 s+0Nyz/2JtBdm6Vj16ovNrLjZQwYq1ri83GRJVgybXgFE/a8MB3HlQfkOR7dOeVAI2RyTKHQDS
 pIs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:25 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1Vxr5D2yz1SVp3
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:24 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327104; x=1647919105; bh=QveB5a+85eplIPaj4P
        tIIZ6/INt1r9nE8RbC6a9EBNw=; b=esJxp/a+QURTtWT00kOe7rFkcOkkAY0yOF
        oedI5IsXbWQ4dBskbhGJCt+cEC39yjHhtUHTmkoKNssM4FC1RuOCN39/xqO/eYld
        v2oDqDqcdshSweg34aJaN6n8XD05MHcC5WNQqWm/ISMZHIQBJMAlLCfjMvMA3Rcl
        wUMiBbq1/OIJexACRcu4O7HAOPn79O1bh/YhncuOx5IOElS8NV3LvLQHOhik5Z7E
        c43dXQYEXulXyBVUUtJq/qN4Ht7dCLTD7kQpIplYRKdXPU/GGyI/FDN833KuH4xQ
        rRo4tAYRItkHkFaU8PArjCB5LuiAKGbXgUPjSvBXHfcC5krJOEgg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id cUETIVvw4GIG for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:24 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1Vxq0rffz1Rwrw;
        Sat, 19 Feb 2022 19:18:22 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 07/31] scsi: pm8001: Fix payload initialization in pm80xx_set_thermal_config()
Date:   Sun, 20 Feb 2022 12:17:46 +0900
Message-Id: <20220220031810.738362-8-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
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
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 0b3386a3c508..b303bc347f3d 100644
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

