Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C03C2C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239256AbiBNCTn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:19:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbiBNCTm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:19:42 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2131454F9C
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805172; x=1676341172;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=uXzLxgeccty7QOgadCe0iEfQD3Sy7wUCBB0p18oBuSI=;
  b=k1iX59Ffm3/FpI2RjtefAWiP0nhDa8D9B6dvdiQdm8Uvz74QgMNBBjU3
   mbGomQGSvyKOb60BpaKARDmQM3bNa4wUdeOTfrJ9IspLwno1KFefMu6Or
   /kcp8zv5vtRq5AoueJAyf1TN+/poscLXmlkGVyhw1Mt5Gi59ulZAfwUX4
   brhRvW1Ij67obkYWZ/UQM89lFTFA4eH1ShrwqFcMC4cMCGZOsmnNZdJkd
   t9UfcIIeIkHlbvaxsm3gQGxalm7JxrqAJVVUGZSDDZZowsRNpwdFa91OH
   i4qLjtJFMPxxZRSWcLwEJn9gc8JoU2q7J8znHTQRICGwoNuCZlyrgbDHN
   g==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819748"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:19:32 +0800
IronPort-SDR: UV3WYegQ+IyyJSwv1xQQM/CSTC/KyrzENJgizeoJ7s/grX0wpSO/4PbmarbPcGJoMo34znOkbM
 IdWT1HN9ivl2vqotvvXksu+qnYjA65QLdP4SAvOC+MzKCCm+vuH590VwhDy6RjvKA34n8GXG1C
 Kmn7wvNyTfRZEwNdn2QqLQSyrcbf/hYvUZ/MCuZHF+NroMActYI4erEPBEGDFDTB0iVDDfPfwY
 mVEy98PbDHB8g2wSpM31+Sm8RYCgbDh9iKs4pw4YVNdMA2vb/8cAJUm7GP18jMb90R3XpDX/is
 KBtw98uKOXwf3hkjUVWTiuFl
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:24 -0800
IronPort-SDR: NmbNsCimoRIBK3zmfEIWYXc5q0ef/+DXdY6tk6RfOuCPACY3yQGZJq2jw0FNNER7CGZI9kEk7I
 CxXXggkfsLkkLxqW8eq/BYKGXC8jvWjCLFXza6IwILG2DCjivZkIA+yrSGNa+6IWsJFX2FRePE
 DgBtzMABK0DkPRMPNRS4XbxqQNkcWJr+2TcJ3AlyMtnJFbGLKAAAMm09vVyHDeQ0MqASQjWjb7
 /DTfLW+ly+FmnnhffNrx3kZochG9yX/J3FZOjLaxunU+pBcL0H6pzc6l7LhCNDBk2rJWTLw8+u
 yRs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:19:34 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jxnwj396Dz1SVp3
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:33 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805172; x=1647397173; bh=uXzLxgeccty7QOgadC
        e0iEfQD3Sy7wUCBB0p18oBuSI=; b=EvTYF5+CYmquNZul12vbD0CJVz/AliNX9E
        x0b/maURuXMtilBQ8l3AvBrrKw45HvSnvX+LBLgEbwmkETnAnG+3ekpi+2iickUf
        +KNStM1aLvk6Po2i6gmf0fM2+mXMSpeBVaEN46fZX1r6TyLuBQfzm53IFMpuIOlf
        c9MNrU9Am2+YqHQF1jNJiCXXFr5ocgQnh0mC73ihlYBtqjVFwlRd1GPGO5ACTx0b
        /Ne1THPIAS4ZcI3M3KLrLbwo+Yhr1epFCsg9rjw0Xj1B9dw07BW3lBlUhuTuA5ZQ
        UfwRLc5KU6Bvm7Ih5lVi9PULgFB/Wp0gTiVwJP4FJ1DQTTg5dI3g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 4HqdDefkmBoO for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:19:32 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jxnwg6LzLz1Rwrw;
        Sun, 13 Feb 2022 18:19:31 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 02/31] scsi: pm8001: Fix __iomem pointer use in pm8001_phy_control()
Date:   Mon, 14 Feb 2022 11:17:18 +0900
Message-Id: <20220214021747.4976-3-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Avoid the sparse warning "warning: cast removes address space '__iomem'
of expression" by declaring the qp pointer as "u32 __iomem *".
Accordingly, change the accesses to the qp array to use readl().

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
index b3530f53df25..6062664e8698 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -234,14 +234,13 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy,=
 enum phy_func func,
 		}
 		{
 			struct sas_phy *phy =3D sas_phy->phy;
-			uint32_t *qp =3D (uint32_t *)(((char *)
-				pm8001_ha->io_mem[2].memvirtaddr)
-				+ 0x1034 + (0x4000 * (phy_id & 3)));
-
-			phy->invalid_dword_count =3D qp[0];
-			phy->running_disparity_error_count =3D qp[1];
-			phy->loss_of_dword_sync_count =3D qp[3];
-			phy->phy_reset_problem_count =3D qp[4];
+			u32 __iomem *qp =3D pm8001_ha->io_mem[2].memvirtaddr
+				+ 0x1034 + (0x4000 * (phy_id & 3));
+
+			phy->invalid_dword_count =3D readl(qp);
+			phy->running_disparity_error_count =3D readl(&qp[1]);
+			phy->loss_of_dword_sync_count =3D readl(&qp[3]);
+			phy->phy_reset_problem_count =3D readl(&qp[4]);
 		}
 		if (pm8001_ha->chip_id =3D=3D chip_8001)
 			pm8001_bar4_shift(pm8001_ha, 0);
--=20
2.34.1

