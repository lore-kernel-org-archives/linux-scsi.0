Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81178C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:30:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240920AbiBQNan (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:30:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240922AbiBQNab (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:31 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314F12782B3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104617; x=1676640617;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=isMoapX0/B1MJOpyA8jNGojhP/ZUw4xSusWBtiS0O8M=;
  b=HErr+5bL8/7nKQQQgS8eaSPmXla2z9JMgcw4xoIoscji01zMxHA20gic
   RTt5GyNkyM9e733MnkedvHzbb2rjvzT3fcZBibU+xi30yvJVRSGoP9FHF
   GDctGOXAgd8GxVuDiJutr5ghiBd7ZIEgj8bn+LH7mNTxKy1C3Wx1z60az
   08ZzZ2CCuSAjsjLTIEyJIaSxcHAQKmKM/MYIHD6jhqG1XBzOId9E5ONCn
   bUIMgwhALyHDHZ/Jzjq4q9CjyiaxLte8tn/Oa9YD5rhqwHAJrB0J6c64a
   GQ5xX0RkJCv2xfNPQonq0ZpLD3DUa5OC2HdPrgGU7j1RNn5L18lKksGDF
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303170"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:17 +0800
IronPort-SDR: 5rgU+/jjy6drvfmIVemkwYym5fE5uaXckP5xRbuJ/tYJM0S30rZZjz5MwO0JTr0TBo/IQUO+3Y
 WBSUtG86gCH+lg0eceM68uj+Fz3dwjY12w1ynoQ3YYJHZB964Sf4LyeI5Lzk6s5Dh4efREMzj+
 0DbaG3yLmGrmm9CPle4Nil+WR990z8pL3c/GhtyTiiMl2SbskLI0aUK1sko9nIrzOe1IfJjnPK
 iLTaNZDnmS2q3x8Rzb51esGxyYoGeGKBpTMLWKn7X1WOYMlX21s1NmQIAC/hv64hW3UYLsH6y3
 Al1yam/LpJgZM08p8dT3dvk8
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:01:55 -0800
IronPort-SDR: at0CWflymjf/Z+LrY1dnSllrSOPD01OTDf7/TQRq0E/rkc7d/2vbm1jttEHnhBHM6W5w/7KV4i
 4w6pD6vOYHqrIoITpvMK+AaZyl9f5k21LddTYRy0e9SCtoxMioAgQXfKmWGVsmdr4w88QjFebM
 WYkdjw74K26Em0M0zVIDqhZo7kdxnA7XZYtvv+2isTuEjyBH7Hav+37X9ypUTwGi0hL/aigwSl
 cm7nzgHRpMt+Pdzgr7rqr5E9BSA7gnNhGy5g5NoMFnQU8kAvzZ6vc+3ViMJJBUk1sO7tkLhnWa
 4Ao=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:17 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JzwgD6028z1SVp1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:16 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104616; x=1647696617; bh=isMoapX0/B1MJOpyA8
        jNGojhP/ZUw4xSusWBtiS0O8M=; b=tRyP8cnmHPEXRLcDbDeTjJZUt1fpoTZ5zw
        au0e8wyKU8WRQee4zs8T0V6wsKDJen70CdKFzs7phvYlirDQ4GNnIqvBv8/Fic2b
        R3F52+q617/GNQ0gCvxTZyVNm4/pbm5zhmKDIlk/WDhzGCQmvZWnMiX4WhnLoR/1
        Mn9v05O3zcMokyVNvW97Yu160wcEz1TjTkUhBqTqLGxjQFFnCToTyid20+51Z9Pt
        VwjLbHtnEcCtAy/Yjkbx/txEKYauFyrInimOqfboHep8eM2klrIzhUu7aAQ3kpTM
        FMomwFY8vq5OcKV9byhlXZV0muxtYl6QOTEXeCmCH0XjqRT8h71A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 2Xdw9WDVTOWA for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:16 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JzwgC0dhSz1SHwl;
        Thu, 17 Feb 2022 05:30:14 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 12/31] scsi: pm8001: Fix use of struct set_phy_profile_req fields
Date:   Thu, 17 Feb 2022 22:29:37 +0900
Message-Id: <20220217132956.484818-13-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In mpi_set_phy_profile_req() and pm8001_set_phy_profile_single(), use
cpu_to_le32() to initialize the ppc_phyid field of struct
set_phy_profile_req. Furthermore, fix the definition of the reserved
field of this structure to be an array of __le32, to match the use of
cpu_to_le32() when assigning values. These changes remove several sparse
type warnings.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 12 +++++++-----
 drivers/scsi/pm8001/pm80xx_hwi.h |  2 +-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 1f3b01c70f24..60c305f987b5 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4970,12 +4970,13 @@ static void mpi_set_phy_profile_req(struct pm8001=
_hba_info *pm8001_ha,
 		pm8001_dbg(pm8001_ha, FAIL, "Invalid tag\n");
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag =3D cpu_to_le32(tag);
-	payload.ppc_phyid =3D (((operation & 0xF) << 8) | (phyid  & 0xFF));
+	payload.ppc_phyid =3D
+		cpu_to_le32(((operation & 0xF) << 8) | (phyid  & 0xFF));
 	pm8001_dbg(pm8001_ha, INIT,
 		   " phy profile command for phy %x ,length is %d\n",
-		   payload.ppc_phyid, length);
+		   le32_to_cpu(payload.ppc_phyid), length);
 	for (i =3D length; i < (length + PHY_DWORD_LENGTH - 1); i++) {
-		payload.reserved[j] =3D  cpu_to_le32(*((u32 *)buf + i));
+		payload.reserved[j] =3D cpu_to_le32(*((u32 *)buf + i));
 		j++;
 	}
 	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
@@ -5015,8 +5016,9 @@ void pm8001_set_phy_profile_single(struct pm8001_hb=
a_info *pm8001_ha,
 	opc =3D OPC_INB_SET_PHY_PROFILE;
=20
 	payload.tag =3D cpu_to_le32(tag);
-	payload.ppc_phyid =3D (((SAS_PHY_ANALOG_SETTINGS_PAGE & 0xF) << 8)
-				| (phy & 0xFF));
+	payload.ppc_phyid =3D
+		cpu_to_le32(((SAS_PHY_ANALOG_SETTINGS_PAGE & 0xF) << 8)
+			    | (phy & 0xFF));
=20
 	for (i =3D 0; i < length; i++)
 		payload.reserved[i] =3D cpu_to_le32(*(buf + i));
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80x=
x_hwi.h
index c41ed039c92a..d66b49323d49 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -972,7 +972,7 @@ struct dek_mgmt_req {
 struct set_phy_profile_req {
 	__le32	tag;
 	__le32	ppc_phyid;
-	u32	reserved[29];
+	__le32	reserved[29];
 } __attribute__((packed, aligned(4)));
=20
 /**
--=20
2.34.1

