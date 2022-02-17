Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B73CC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240767AbiBQNa1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:30:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240920AbiBQNaZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:25 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A2F2AE709
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104611; x=1676640611;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C/MxlaPrgWa7HKKsPS5Az5xF33j9DbaItS7xYyT3z4Q=;
  b=nXSEV0kcGB2AKvbKHcvcUqKrIku4uZ1eTzTlAvUk2SI2NVUBeqHyAePV
   xFdE1h4Fb/wEDLKWDBzbd/SvGtJDrgKxKlFKqxe/srOxusPeT5s2E+N+g
   1sgZsV7F0XoA97AuG146hSzPW54nEnlTvtWHuoSqnb6W3foJkb6Wh/ubA
   490ctrTlTOkrY0GkYS1eUFpPpY40lcAl47ht5d/uoyA4xb/39nPv/Righ
   riCwqZaSQCYY1nbWOkggjOZTGSPfrxY/ET72eVKlFdK4rEht9T3hiZPQH
   hZhegQDrTQMNqohQHlL5t795vnBa6geNz65JFw4CF7ktyLxOaxWslRtWF
   g==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303149"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:11 +0800
IronPort-SDR: EFrCBrH/vb8zSsWae0NOl8rp6neTuL3HyZ1ID8wmyEbZ3CBVkubru8fA8ONLmWfThT/TwrPx7l
 boE4vheYGQtXSCQgez+g/pk8yAaMp9fHT/HyoODT8nL+mXIfxhhlYfIDSiPkMjEH+WGcUCO7tP
 HZG8Ow1p8iZtqtNnM2L8W2Iv2G1upYi+puk8qZV3+nbwcrtvTQ7/LUBgYtXgUx8h94TTYcdTsE
 wAC00YYVzoiQ+wcTj0jzVKG4oY706T4/MLzc7JhVekwlsODgbRb2bBK+jbu9DvC6CRbHIjAviC
 ezAsQikNHGMo8aBps403RXOp
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:01:50 -0800
IronPort-SDR: 3Bt8KLswaSJ9DN0sIO4WOtSGOYXm4GbreqsFYUUenfDO4BWPBcRJUZdeCLc/OIR1UPpmm73M7b
 aqTH0WomCn5dVunLsxxrtB++FbvBbJrRjlP8V5FvnjoY5bTH1AyO1uSEKAkDpIl5gWPuGbdOly
 brj6MCdmqWok+lZn4qbfxGBvaZjF4v4AhczBRPbbzuyGe0APsM7C6+I7kKCGgyrAz3rXfl4eqL
 8qQwAMByivjoYWfwI0dNacWWqsGXoSPkANi7Kv2sQb/nN1w/JMvQT8QrFbloAkAY81tuPoP6Jx
 qII=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:11 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jzwg66NLgz1SVp4
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:10 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104610; x=1647696611; bh=C/MxlaPrgWa7HKKsPS
        5Az5xF33j9DbaItS7xYyT3z4Q=; b=qIchhI7whiD482742EYAPn4LNmZ1CM0U0L
        uxJyUQoo1UVhGq7jZ//LNj6ee1lRyIkcxzqsvKFumQuDr7fppiR3JH3tGS2dXKZm
        1hvWYueEOcmBfNGlTf78lRmE27kyUsyZirKNlF7LqvtvfS8kTCEo/NZimQ9PMjjn
        nkI2SbEZ/rAhgJbsw7MRM8ygQIoYEtfS914VDvMzCPj1Td1as5QZTglcjNplkAQD
        NDM82WyZnwohstueSVAXZA+4mS6uJJP5YcAFRjrsDVdccDDsng891v1I32xF6luf
        K3iG7lqbqEdcA777NdZ7QKC2u5OrJ0Xo9Xl0HqDvudn9jnjcqY8g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id srfIRaaQbHyI for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:10 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jzwg51LQdz1SVnx;
        Thu, 17 Feb 2022 05:30:08 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 08/31] scsi: pm8001: Fix le32 values handling in pm80xx_set_sas_protocol_timer_config()
Date:   Thu, 17 Feb 2022 22:29:33 +0900
Message-Id: <20220217132956.484818-9-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All fields of the SASProtocolTimerConfig structure have the __le32 type.
As such, use cpu_to_le32() to initialize them. This change suppresses
many sparse warnings:

warning: incorrect type in assignment (different base types)
   expected restricted __le32 [addressable] [usertype] pageCode
   got int

Note that the check to limit the value of the STP_IDLE_TMO field is
removed as this field is initialized using the fixed (and small) value
defined by the STP_IDLE_TIME macro.

The pm8001_dbg() calls printing the values of the SASProtocolTimerConfig
structure fileds are changed to use le32_to_cpu() to present the values
in human readable form.

Fixes: a6cb3d012b98 ("[SCSI] pm80xx: thermal, sas controller config and e=
rror handling update")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 52 +++++++++++++++-----------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index b303bc347f3d..e6fb89138030 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1245,43 +1245,41 @@ pm80xx_set_sas_protocol_timer_config(struct pm800=
1_hba_info *pm8001_ha)
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag =3D cpu_to_le32(tag);
=20
-	SASConfigPage.pageCode        =3D  SAS_PROTOCOL_TIMER_CONFIG_PAGE;
-	SASConfigPage.MST_MSI         =3D  3 << 15;
-	SASConfigPage.STP_SSP_MCT_TMO =3D  (STP_MCT_TMO << 16) | SSP_MCT_TMO;
-	SASConfigPage.STP_FRM_TMO     =3D (SAS_MAX_OPEN_TIME << 24) |
-				(SMP_MAX_CONN_TIMER << 16) | STP_FRM_TIMER;
-	SASConfigPage.STP_IDLE_TMO    =3D  STP_IDLE_TIME;
-
-	if (SASConfigPage.STP_IDLE_TMO > 0x3FFFFFF)
-		SASConfigPage.STP_IDLE_TMO =3D 0x3FFFFFF;
-
-
-	SASConfigPage.OPNRJT_RTRY_INTVL =3D         (SAS_MFD << 16) |
-						SAS_OPNRJT_RTRY_INTVL;
-	SASConfigPage.Data_Cmd_OPNRJT_RTRY_TMO =3D  (SAS_DOPNRJT_RTRY_TMO << 16=
)
-						| SAS_COPNRJT_RTRY_TMO;
-	SASConfigPage.Data_Cmd_OPNRJT_RTRY_THR =3D  (SAS_DOPNRJT_RTRY_THR << 16=
)
-						| SAS_COPNRJT_RTRY_THR;
-	SASConfigPage.MAX_AIP =3D  SAS_MAX_AIP;
+	SASConfigPage.pageCode =3D cpu_to_le32(SAS_PROTOCOL_TIMER_CONFIG_PAGE);
+	SASConfigPage.MST_MSI =3D cpu_to_le32(3 << 15);
+	SASConfigPage.STP_SSP_MCT_TMO =3D
+		cpu_to_le32((STP_MCT_TMO << 16) | SSP_MCT_TMO);
+	SASConfigPage.STP_FRM_TMO =3D
+		cpu_to_le32((SAS_MAX_OPEN_TIME << 24) |
+			    (SMP_MAX_CONN_TIMER << 16) | STP_FRM_TIMER);
+	SASConfigPage.STP_IDLE_TMO =3D cpu_to_le32(STP_IDLE_TIME);
+
+	SASConfigPage.OPNRJT_RTRY_INTVL =3D
+		cpu_to_le32((SAS_MFD << 16) | SAS_OPNRJT_RTRY_INTVL);
+	SASConfigPage.Data_Cmd_OPNRJT_RTRY_TMO =3D
+		cpu_to_le32((SAS_DOPNRJT_RTRY_TMO << 16) | SAS_COPNRJT_RTRY_TMO);
+	SASConfigPage.Data_Cmd_OPNRJT_RTRY_THR =3D
+		cpu_to_le32((SAS_DOPNRJT_RTRY_THR << 16) | SAS_COPNRJT_RTRY_THR);
+	SASConfigPage.MAX_AIP =3D cpu_to_le32(SAS_MAX_AIP);
=20
 	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.pageCode 0x%08x\n",
-		   SASConfigPage.pageCode);
+		   le32_to_cpu(SASConfigPage.pageCode));
 	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.MST_MSI  0x%08x\n",
-		   SASConfigPage.MST_MSI);
+		   le32_to_cpu(SASConfigPage.MST_MSI));
 	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.STP_SSP_MCT_TMO  0x%08x\n",
-		   SASConfigPage.STP_SSP_MCT_TMO);
+		   le32_to_cpu(SASConfigPage.STP_SSP_MCT_TMO));
 	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.STP_FRM_TMO  0x%08x\n",
-		   SASConfigPage.STP_FRM_TMO);
+		   le32_to_cpu(SASConfigPage.STP_FRM_TMO));
 	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.STP_IDLE_TMO  0x%08x\n",
-		   SASConfigPage.STP_IDLE_TMO);
+		   le32_to_cpu(SASConfigPage.STP_IDLE_TMO));
 	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.OPNRJT_RTRY_INTVL  0x%08x\n"=
,
-		   SASConfigPage.OPNRJT_RTRY_INTVL);
+		   le32_to_cpu(SASConfigPage.OPNRJT_RTRY_INTVL));
 	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.Data_Cmd_OPNRJT_RTRY_TMO  0x=
%08x\n",
-		   SASConfigPage.Data_Cmd_OPNRJT_RTRY_TMO);
+		   le32_to_cpu(SASConfigPage.Data_Cmd_OPNRJT_RTRY_TMO));
 	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.Data_Cmd_OPNRJT_RTRY_THR  0x=
%08x\n",
-		   SASConfigPage.Data_Cmd_OPNRJT_RTRY_THR);
+		   le32_to_cpu(SASConfigPage.Data_Cmd_OPNRJT_RTRY_THR));
 	pm8001_dbg(pm8001_ha, INIT, "SASConfigPage.MAX_AIP  0x%08x\n",
-		   SASConfigPage.MAX_AIP);
+		   le32_to_cpu(SASConfigPage.MAX_AIP));
=20
 	memcpy(&payload.cfg_pg, &SASConfigPage,
 			 sizeof(SASProtocolTimerConfig_t));
--=20
2.34.1

