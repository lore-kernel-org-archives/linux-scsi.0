Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D82C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239285AbiBNCTw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:19:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238144AbiBNCTn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:19:43 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A602254BF2
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805176; x=1676341176;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=jMxdxrU0dqTbaKqxZXzj06nBG69eVj9OnhNN0zbXqww=;
  b=m2irhwEf3/6n1MWF6O5W7qeXVGfWCLpVw1io37pDEHGHzOQKNACw82Uj
   SGLnWc0HcL1NF8PlaluBZ+kOFQOMdxIxd2M7t0Rt4kUogpVDb2Zap58VC
   HRUNLpdfp8339iViIX7d29LVIYsmQoPcvWpaxKyQWV/jOpxuVb8nftvOU
   LofRBTLqZeLR8J2sMJi0l+BeUPyw++w0Et9UM6ovs3NcC8E4ZjZg8VrXK
   jEvRnqcwjbzzCxnSkZ6HnTa0EGCKlYHCKBPRhSKT5a/p/aksJVAIK3tyf
   b8iJQTGMXvmhMttc8dFrCUMXy834+iQy01svQa7MLjeuCWvbQr4XK3+lA
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819757"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:19:36 +0800
IronPort-SDR: GLm1LchmgD2oOXTRsavrGmIMqFnxLaxDaFO5hzlHAijcS8KHQQ4pAwJ+cEt6lXcjPBMI0M4jtA
 h/cn30uIETKBJDVKKs9nOpArNi5Ickmh7jiBJ4sdTiwSbJd0qvjEFXNRvMzSbDrngPWsOuxGP4
 HMesw+crcu0unuYOdZtPJCD62kAAtBb0ocn6hWACP7tSB0oEHYPMdb7iiiyrJPkAntM6Q71Yyo
 Mz6NRWZl2oKJcuF+t/dlXiSufhUE/T8NYR05rknTaEnNmlLH8uCojjeCX/YcUTk4n/ZOabWaco
 p6wjmnVwDe6eCtUUe3oLcrgi
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:28 -0800
IronPort-SDR: QzqvXqNCoemb2/bvLSFjr8T/qHVr0UvW+Utq5Wdtj2z9Fi6yQ+eSY/+lG6n1b0aVpmZqwSir/T
 tQHQeDWLU2UYQI4vew6010PAlQmfZhLXl9+WdQapl4+oFCn4u9u7/CMH2YgqNR4vT/vDeerVyv
 AZpzzgH40fUHixr838oXkUO7f4g6pumqP2KReoXyFuFRigqumB2JaUbj3py08zkBcZNJXzPCzT
 rL0aJoCIuEbDybNhih3mMdz8XEaN4AtfqIUD8F6K6PBxDjnLbZ/SfaPv0TjlHoev4zSSIzvifH
 c7A=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:19:37 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jxnwn01T8z1SVp4
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:36 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805176; x=1647397177; bh=jMxdxrU0dqTbaKqxZX
        zj06nBG69eVj9OnhNN0zbXqww=; b=iSV6XSLwDuR9B2Jl5k2yqwX5940i0+e4CG
        JEhtNAgd+ngJngCU9ys9CkNJ3K6+sGmlOxDAjNomCwMitIMDiJ/jMV/5o9aw/aif
        +dWKNDEZhvJeFp//G31eDNCrT98rIDJmWU+vdoqSwWoMo2vZitfTFV4TFYgbYhV2
        nAzcJA4GbEXewUYsUHtJ8c9FtinO3E2RmJ89kO94wb3Vjxd1ITDngXP1qTZH+zrD
        ZWH6gksyZRgEKz0pMnMPW3ApIna3ILiEN7JgxIMZoOCmnSUJHsubcBy7hYh94e1L
        4ZRL4gu5xdevYyiMcnJ9JZY8q+NyVqT4bYJvBJ6WHS97dhgzbGQg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 2g5f3d1sgLdg for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:19:36 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jxnwl3qTVz1SHwl;
        Sun, 13 Feb 2022 18:19:35 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 05/31] scsi: pm8001: Fix pm80xx_pci_mem_copy() interface
Date:   Mon, 14 Feb 2022 11:17:21 +0900
Message-Id: <20220214021747.4976-6-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The declaration of the local variable destination1 in
pm80xx_pci_mem_copy() as a pointer to a u32 results in the sparse
warning:

warning: incorrect type in assignment (different base types)
    expected unsigned int [usertype]
    got restricted __le32 [usertype]

Furthermore, the destination" argument of pm80xx_pci_mem_copy() is
wrongly declared with the const attribute.

Fix both problems by changing the type of the "destination" argument
to "__le32 *" and use this argument directly inside the
pm80xx_pci_mem_copy() function, thus removing the need for the
destination1 local variable.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index aa0c4566db4f..8a2d4087d405 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -67,18 +67,16 @@ int pm80xx_bar4_shift(struct pm8001_hba_info *pm8001_=
ha, u32 shift_value)
 }
=20
 static void pm80xx_pci_mem_copy(struct pm8001_hba_info  *pm8001_ha, u32 =
soffset,
-				const void *destination,
+				__le32 *destination,
 				u32 dw_count, u32 bus_base_number)
 {
 	u32 index, value, offset;
-	u32 *destination1;
-	destination1 =3D (u32 *)destination;
=20
-	for (index =3D 0; index < dw_count; index +=3D 4, destination1++) {
+	for (index =3D 0; index < dw_count; index +=3D 4, destination++) {
 		offset =3D (soffset + index);
 		if (offset < (64 * 1024)) {
 			value =3D pm8001_cr32(pm8001_ha, bus_base_number, offset);
-			*destination1 =3D  cpu_to_le32(value);
+			*destination =3D cpu_to_le32(value);
 		}
 	}
 	return;
--=20
2.34.1

