Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA9F0C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 11:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241146AbiBJLmo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:42:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241136AbiBJLml (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 06:42:41 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A7B1029
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644493358; x=1676029358;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=ZWrSXM1hykW2G2gy5Fsaq5oKKtBp9OoMP2U/QSrvZ/I=;
  b=KVxnCfbHdhQotHIrsGCzDpDCQhZESrI1yt1qu46ClqH15TYlgv0KtQuL
   dpS36fOdFAeBrU2cBJT4FvotJPY+B0zxaWcpKGyzXNSGRsmLtrxkzuvuS
   WDteOifzYRZ1i1PedNAv11tCPN7JBYuUQiIqdi0i3OStyggWyJnPMR1+B
   rcxYWiTtZqtr4p5FFBy80GfbUCIo+PM0VVRLhaktOEibAISKOkww+XVaA
   7Nr6TC8f37R8AinkILw8pLZJqGjUWL6vTkT+vpGzo7NiRixr4Ou7z2kDH
   kLUXUFvwrMUZ/p03jz6QUamv7MEmunfAxHf7Elc0jS3X1Rz0yYa/sNEaR
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,358,1635177600"; 
   d="scan'208";a="193575648"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 19:42:38 +0800
IronPort-SDR: bnZfIXX6uZQejJnmShmb0xt9Hp/cb1sYic+OCYPhkTPa2t5RI/YWcJ89LhFS9K8108PaSUReQW
 NAqr789JWnZ7awEA6tDlumxNHEH9tiww6MoYLi4ntZWe/E6ozHzmsnPwIyXoTV5K6qBiJ7vxv2
 qq/bNLR/AGuh7LA1ewwX4VarV1oDfb4tvSGKEoDMRehqW3UpeK5nyGwaMDM/PIVd0YChKnlXOu
 Wf4SCV6J7EMSpABmuj0JI1neG43nBNiE+jeZvl5OBpV0exi9UG2VFJTB22Xy1Iahj3lCzmfzVG
 qqwqitvNnZ1RsJhwJIp03eWj
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:15:34 -0800
IronPort-SDR: hrif1rqpoxzUpPrsldr26bVXJubSfMaxQAQtaNloyMIylB/ev2GnbMSJt7LhaWCaEieKzJSCOu
 y4DY5z5KjXUoSKA5OUVy5/ZDy08O2wKu/JlD7K+hMJO5Q23sdDM6WPLqJY6tIf2jOhPqjVnosy
 ulDjSRGU6J7IYsKu3Uk3eNLUP2mv4d6GjEzIM0aE33Pa3rfQ9aD1N/nN3VF0jhJKuic1bgQm9u
 +RyZ4cLLEhEHix+hPBay7UL4gdFWuK0E4AtfsUHl5LrAStgxW792x082GpUx7j66rTqm2RQSiW
 lhs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:42:38 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvZcF32Gjz1SVp3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:37 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644493356; x=1647085357; bh=ZWrSXM1hykW2G2gy5F
        saq5oKKtBp9OoMP2U/QSrvZ/I=; b=NSe2upmmLwWaXo+879evy89guPu0Ytvrn8
        w5bKqDXflRLntI+YA9bjA24E9zV31pDkF+sIWGIOY+bVIDN8FBYuIU7PuzN8oaFD
        DuUMrBO4MsaQS3scRPGTWYfQ0z0sdR1IMWpZzGSMqlpvAg3BB13GynM5dHtZdYZ8
        inZzBi1MeQokSeAMem6hX+GtJntP8RTStAwpRumCPQXbPiCb0aMhCW5abJ7Xy994
        TGiAG0ngrU7cAMnAU7Kp9UD/3e4ge9ZPwBFwFBU0Gmqb9VekficWV5XV3Rum76qL
        kmJvsX8DYmIRopiAplF3ncMWzYwEy+O7m6ongrEWZaY5JZLV35ZQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Os17nCGU7tEf for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 03:42:36 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvZcC5hHbz1SHwl;
        Thu, 10 Feb 2022 03:42:35 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH 11/20] scsi: pm8001: fix le32 values handling in pm80xx_set_sas_protocol_timer_config()
Date:   Thu, 10 Feb 2022 20:42:09 +0900
Message-Id: <20220210114218.632725-12-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
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
index 9c7383fb4bdc..84322d694391 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1246,43 +1246,41 @@ pm80xx_set_sas_protocol_timer_config(struct pm800=
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

