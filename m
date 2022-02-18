Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA659C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:15:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbiBRDPW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:15:22 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:56144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiBRDPP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:15 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B05142361
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154100; x=1676690100;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tEJfk/UE9FOASU+9JhmgRQlEK/ajrA/oKGoTSJqp5mA=;
  b=fi2YExuiKF3/OORXPnFgt5y4kYhvUSUmDGeT0t64ecNhD9OSr7If0cTy
   QoIloR8Cflc0O//qoA/zST/GmwiLxwu4+EQfzDH/IkCLznZjBvXzOIFBZ
   c6gZ8DL/CymQ/HaX1iUZYe7RBfG2QSnsXja/JgNHaINhQy5/olmBtDI1Q
   MYb9H48bQkE9ptOdTXZ8GFBqYF5nvVXEnWRFsKhiLys9bS2Z3AOMV2Pvk
   huG1zioDDaClUGCC3BjRbs7Nyijm5ALOjSzP/NHaeYx10SfD2VWlfVuXr
   ZyUm2F5NYe3w6gJq5Smom7E1PiQiVYAw7w2BJzCXoyqwfBK77JkbLXy47
   g==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="194225746"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:15:00 +0800
IronPort-SDR: X8JBYCTSk1FDbdJzhPCrm0QHpvd8VnpQA49wc3RKxuM67NG7yFKkpfPdr6UQIwV5TTS9VldCvO
 PlD89w4zlJXQI+tDLeY1qoIU0P5gs4m20+/a+DoRddZL+bcY8LE9pZeGWk9NAlZjFMClU8tmeE
 tckFKvywzjcJz78IOVWOOT3LeSH5pehGupmrY4HLNQwhoJ5Zv4J/RqXSfLk9W0Ptg1k56mP1cQ
 0xJSRVMXoMldai7EX8PvOL9JxM8pQsIknTZ5D2/Z7SKqj3p5uHLDjvN2LI/8avu8VM3+Bqs4+N
 FIZQWTcqpMyvb2BDlRbyClBA
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:46:38 -0800
IronPort-SDR: J37z8VpWZPhWsteigs4paHKTeUFUHxS6sDXDpmSV4zM0rpwgo39lRGsVSbK6wWy5pA0bG87DPk
 hA98r5LN3FdZyH1sItHyMV/g2cL3obd3IxVE1Z7CLhARGuHqmho3HSkdcy3hLrgxTiJ9KDKLr0
 fcyb5rfsMDD12V+0cGZ9R+Csa12XzX5FdhPMD4NHICaMICc3WZCjxp0JniGEwaVd9EDWdYm1bL
 n7khKCafhGkajpb+SRSAid4qpGEMDjTvG87uFuFurAnEsSMtt4U5fn3X1DWEjg0tgWBDQZBq+C
 /oU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:15:00 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0Gyr1DQZz1SVp4
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:00 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154099; x=1647746100; bh=tEJfk/UE9FOASU+9Jh
        mgRQlEK/ajrA/oKGoTSJqp5mA=; b=pQIcucPTpR8vq2xatQjLrqot45zdFlsbW6
        a9rUBxmHB+XfrJ5xVyt0eIX6qMLREKw7Auzf1RGmaFKj6W5AUKMFvUnk6+R82Tr1
        fXBOPhUrerJRg9JIPcq4DqGQvGDB8sMJmj+XI72zyp33Ckpk9o82qaOfTP8WWZRZ
        uB3nL16o7eVPdYekW+sMTK7z5anC7xEp2pkzdtqz6H2FiNGICqwlvP58JHSH29lL
        KtuUh/ATGlSWXnJpOT7p0ORBybi//IrtwsE77GQw1TDHnngjB357mnWKgV88dQWR
        d0QRppEyD3FnMLf2PR7nuGQr7fHp7jCZ9tAEKvN50HJgTiHuyOVw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id oEwY-UP1fVhb for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:14:59 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0Gyp35tyz1Rwrw;
        Thu, 17 Feb 2022 19:14:58 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 08/31] scsi: pm8001: Fix le32 values handling in pm80xx_set_sas_protocol_timer_config()
Date:   Fri, 18 Feb 2022 12:14:22 +0900
Message-Id: <20220218031445.548767-9-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
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
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
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

