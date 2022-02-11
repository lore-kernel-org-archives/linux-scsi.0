Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18DF8C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347729AbiBKHh2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:37:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347718AbiBKHhV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:21 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B01B10F4
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565039; x=1676101039;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=ljE5lfdxexuRaDu5qOXZpYyWAr/KrWbmU1oOByCCssA=;
  b=PtQ0uEUR978s+8fs/4mbRTjHkMO72hsCqFFrEoztsvUDBYidymK9uLdp
   S3hahuSPVAfKLCyUwd1PFhEVfMsmE50mjz9q3bsC5nYyfMPbpNq3b9V4O
   KMQOh3swHsE/94ZkWXt7rTLOb9PYbZ5odQXEJOLaswOfeCDnPkd1TJY1s
   RPcMR8E1ODB6WzG53j8uzVxSE8x4ICWOBmC8WNFltdbw9iInQxkSBuvvK
   BgZD7hki3OFxWEQkgmY7sTsf9jlQflP+V2BRfgpR2FD9/1WBLACWO0JjJ
   hDc3cN7CPqfzh6MbvnGBwUQ50R3IUpnCUzbRLG3ny0DNBIPDhBRUmc3sI
   g==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675143"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:19 +0800
IronPort-SDR: G1dAfxvz8EtZoSRdyxEz80LcmTbkBNM7B+L7KgCNLWRhD2q+bIo0dFnReQHbgDvc0rTxz/ajtf
 TOYLmpRZYb/H6wKx9kX/TdymNoMpFI8XQnoqT13BxCwj9P1L5js5DNlV7wQe3E+IFBGHziMjau
 uWTL1hvlWTLLsa8+qWmEkU24nX5AX3bM/fD7KcSFUvQyBfTh/lcbwOJy6Sn9lvgyewti/s82QC
 UNtvUW4ucbARSprN+nWvhpadNSe6cDa96yt3K/E7NWIwnp6UpFwhLTlP+1lhFC9NZxzkS4pBKq
 NgMcy3YREOBQQkxxAJoCTTbH
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:09:07 -0800
IronPort-SDR: VTYpcKzEYbJD1SGMrJcQTHDGBNMixHXQL4YXbNnqmOQFA14qpDI0Qq4c3s8L1i2y0BfKepN7nn
 et7tDnzgiYX97xCSCgXI2Bnkxzvv73qsX86IES7DQY4FNedlyan/EuCyLv/vejg5O2Rgs762EV
 d5GxF1RwYQvYWu9jEtn4z8BsCjip63J7GKxzHtkOZBi0nolFSlNrJe/5TgwrtCfOWV7I3QeI0e
 a5/ghd6hjqK+fVB/i+O4AXTtGpCQCUJql6nSY6ZaNa5AilXINUenxiV+03eI4DHMmhGImwLIMw
 f7Q=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:21 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw56m74l9z1SVp4
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:20 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565040; x=1647157041; bh=ljE5lfdxexuRaDu5qO
        XZpYyWAr/KrWbmU1oOByCCssA=; b=hYJow+GKIPsx9pmHOv14DS1V6z3OTXgZSU
        uW7LpC7EHhPtZUpQdlAM5ka7kyKK7TuLTceYXUN6zfS2n4XhodVrLpr4cUOVs1F7
        vwPrDJiqGDgTUllfxif52AVx7pM2LVYh59W0urF5X9hBtrEV6uXWmfYoHUsXyUh7
        xNe1QtFvMiDJJZlqWhQ4cmhIU81vvfaV9HMg2iME/V7MX97wHyowlc0+/YcFRhNr
        KAHJntJojTiHT0IsC+rQ21J8rBIuLOhh0As0r6d5kxk3J++8Pe0+vWxATuuLz08N
        Y0UI/TbFc4NGV+7ZqdXqQQuEGnKld6Cn0wiOh0mFcLXc067Mvupg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id VGRw1_n8tg8x for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:20 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw56l2gsGz1Rwrw;
        Thu, 10 Feb 2022 23:37:19 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 11/24] scsi: pm8001: fix le32 values handling in pm80xx_set_sas_protocol_timer_config()
Date:   Fri, 11 Feb 2022 16:36:51 +0900
Message-Id: <20220211073704.963993-12-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
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
index 6f8bdbd24156..ea1f250e4b42 100644
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

