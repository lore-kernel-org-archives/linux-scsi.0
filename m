Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4602C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239307AbiBNCUB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:20:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239289AbiBNCTw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:19:52 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758A654BF2
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805185; x=1676341185;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=bHQOfB2LDNW6/HN86h9WS/6qfZKtSpm7HW83n+JZIm0=;
  b=HbsRFJ+U5/ovRXTJYQ4DPNsVyQloIyWtsiOkMmjgSGFgxxDU2Ws2HMIO
   oIExxYy95sDVAVF41NS1VhWR0u235ZYKAOKVMOB+vROx0ZU6NiT4MBZrI
   yzdycREa2mHaIoxvOlRBeW6St8YHRCmkq2js7StEVns/sXvkttWRGd4Ko
   64qscUAQyyjriPZBDP188r1TFPSeSdbv/GbEPFIzabXcPpNLCKDhkfCLB
   XfomA7OzWwdm21zqD5TPjUIFxla+g0J2KZOQRNtoXkTv7fT5fVVpdlzSt
   kt8zptX968o22KZ1tbyVey1C/czCLjcdi3PfY7dONCo3hYj99LaHgw19Q
   A==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819778"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:19:44 +0800
IronPort-SDR: 938wwIiKLbLmzFooRQwhKvidshubN8elfZVKYEAMGTkfisNaYjZtD0mcvYOxSjXIUweMHkg8KU
 WrZs0mpK+J2UGnYCuLF3tirPwflnfw/A9FeNIoOpYeVt88Bquh7gf7hWnRvVW95RDPgGuqG5KK
 IOexcrGkF5kt/R1zAWOgdSi3PogUzzxs8BKB4Gs55URLmbkwjq+NGwSbPtdJZexCPLyCTVirjl
 4kBvoaKzKjCbCSq/eYfn+vOZkgu2tq4rq8FFfBJPEpuofvNx3GsFU2lZD85gG9de58H5n5r1Ri
 aME1YRVrx9eWT5r9wzX2CeSH
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:37 -0800
IronPort-SDR: EVV1B6W4CM3dWD3G3AMC+WOuQ61OXJ4jPvI4/Gt733ny5AH5GpbDBGXEwlyDKeY35WIK3mixJA
 hblXHoJrpa9fr0Y+YbH56durWgDBz+qFGKuV7hBE5VJyeXfYW3maTVLJ1OlYnV7eJ7LKqmMCXB
 kDT9qryoYIknYDyMjgCARDP5AclQ3aALZgCUjQLKdXfhI8QU53Dr/2eGCEO2q7RPiFnHUWxmWE
 FubH1AcIE29IcXMDset6v2uoEfIi9heYW+cWj2XZs2DdXGR4W+JRknk0w0sYuELMFylFu/+XZl
 LC8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:19:46 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jxnwy02sQz1SVp0
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:46 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805185; x=1647397186; bh=bHQOfB2LDNW6/HN86h
        9WS/6qfZKtSpm7HW83n+JZIm0=; b=lk/8OAibGlN2EDaDWl+k1SnvNcUXy2QB/4
        Joh/ddozIiTZu2l5PURoJMS6cvEUnU0aV0wKyC9Kd3OcOWumpbEHC7HrTvwjXksl
        H9fDvvEr7XL3eFA0kwK6HqaW1AVjRf98TEseU8z7lPPI3QNfVurEdeBOL6EYxs79
        Wl6CY4JvrkrhIP+Jv6nGqNxzHAGQhe5hH9Ymi8jwfI0pov2nHFbeq/ibW71sTk6i
        qBP7YTed9WPEeu1QAhTKHnCeCQCONtstyjv1XIFntcl2m+RVdLTDyshNRLNoGLCh
        q8E+sAumieoQTRBaH8NenfdWLyvTfdFyRkoUt2tQgNN4w8njQBlA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id XPOVH_KkN_yv for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:19:45 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jxnww3gp7z1SVnx;
        Sun, 13 Feb 2022 18:19:44 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 12/31] scsi: pm8001: Fix use of struct set_phy_profile_req fields
Date:   Mon, 14 Feb 2022 11:17:28 +0900
Message-Id: <20220214021747.4976-13-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
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
index 8ebefdb18c85..ad2e40425fbf 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4982,12 +4982,13 @@ static void mpi_set_phy_profile_req(struct pm8001=
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
@@ -5027,8 +5028,9 @@ void pm8001_set_phy_profile_single(struct pm8001_hb=
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
index c7e5d93bea92..7cb59e38e67a 100644
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

