Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B70C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239296AbiBNCT6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:19:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239227AbiBNCTr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:19:47 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C5454FA0
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805179; x=1676341179;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=KDIZnht9JbMO/oQkD5bZFpkpgjYcz/UzkAqRFrp1J34=;
  b=ckF+IvNGYL3OjbS0mKLetdW8gwxasJOqm83d906LEB3CbjvBWWm+/fPR
   3I2xtuDF6VDGZHZP+muujbirPr6BIi23yuewNs6XnRsT453Fze9viNx96
   EBSSZP+NsLDhZGF49B73cyBRAj53Xi35iE3o+MsnXw62MLg57nAUC6ZVa
   Bc1dYxobN6X6zehkoi5tG+JVazKbh1wd/el1NKlyV4bW5egsxSgoBPahj
   vDfBH6Uea9j71tlNGpprlz+ToUq/D4IKsFLgI3JP+r5M5gNsZW8E3Z37J
   DwC9c+kCTuP5myTwRqEXbYSrsQUKEuFPWPDxNM/v27JBjunl+AhUyTlAC
   w==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819769"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:19:39 +0800
IronPort-SDR: rmZK6s+vIj5nK7vxUcPywlkjm1fkJJAUD8eg0yJ5lXLe2PNZ1aIf1JYmbSuGjdZLXj4qqUdKO6
 5Q2BRBD/hmmTAhmhl0JNjKp5ZgozUhelVpfIwjgQb8fMfNAPTQF009uNxU9azoLkd6pmeJUj7t
 tog79IAquIQBqlexNzmAXhhnqCml0J8xYu/fyjGlWNqDs/KJrltbppzxcqRbbs4KpEJUaDnKQI
 gqPezsTkCKN1ifNX5t8XsxLPdxnETsHHF+Cmu04nlyYFGIkeUURg0JaOwXLytxH6cDNepyzyPi
 B2tlu/ELaxOabh5U4K0sp6i5
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:32 -0800
IronPort-SDR: qM7agTZAKKn6/kb16U1oBGBZ7xZAKePpaW3GgMvp6UFYVNLQpdNxSU8l3LAhQLTcQu7HrUd2Ix
 4SnbJlGOlMPeIAkkTMLt4GSxi5C2ezP0MuF/7TgZwKQfKOSGv8Rzzb98gmEPhcDCUj2HDNA9Yp
 ELQ+BdFn74rCMfiGcu9d1NUR9Vu3PmUW+e5k2xc0O3xvcvWEdCxj6ATmeCaweufi/BiqlZrGuW
 diMmcebQq7Wf6R13f+BEzQvM66P0RCRPBwVZlk2TtXbhEuc3+EF73CpOF8dfZVkylYiqOYkmCp
 FP4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:19:41 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jxnwr5ZBTz1SVnx
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:40 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805180; x=1647397181; bh=KDIZnht9JbMO/oQkD5
        bZFpkpgjYcz/UzkAqRFrp1J34=; b=c8n7YRbwukAgKmKv4ouBv2jC37YZyDwdrO
        nnI+R/IrFFAi90sT1EcuSdvkCxbcKk18PUC05j59yw9nWeTqC4O57/FCM5t5zX8f
        OWhAydCkECzT3m0d99Q0ExtQrQp2z5POdWhPY9Itu+jhVCf2Y15Ga/sbxYigkS2Q
        UQHehqfK5gRG/UHhcM8fGW7WXqLYKN9EsZCL3rq1lNiMDW6rv5aGEr5hB+eU4kU4
        M3kmZdPDi9I23PMQPwvOINy3cGqKWF4xpj7lcERWkK1ETS2JVEhNwlJepyuux4TU
        YTma/M4CJ09t5A8OIYQIgG46ELV9xefaEFEJCPt+r9rwfEa6WYpg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Jpqxaw8C7AHL for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:19:40 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jxnwq1dd6z1Rwrw;
        Sun, 13 Feb 2022 18:19:39 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 08/31] scsi: pm8001: Fix le32 values handling in pm80xx_set_sas_protocol_timer_config()
Date:   Mon, 14 Feb 2022 11:17:24 +0900
Message-Id: <20220214021747.4976-9-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
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
index f9c4cec514fb..108e4743fe81 100644
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

