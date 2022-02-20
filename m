Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE76C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242899AbiBTDS7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:18:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239782AbiBTDSw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:18:52 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B16B340CD
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327111; x=1676863111;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lVB2sM0qCfqo8mvvo1uohffxKjaC+Yh2JveklQXFsqs=;
  b=qqxjA9ThcGvs0yy6XCSk5n/GuKNSI4fHwJzlujwnIOSC2Lsj1ldai369
   wp0KmvtRrMsrJD5Yzw6qZOEkCbp/xVmtbWeD0glsIux4l4eSpO8wlhnvn
   nMpgf/ol60ToVXprxiH/j/npWgzWpswKMSV0IMMLLxNo1+RxWC8LaEVBz
   2Idxx76H9sBK53cRRih7NfkxmN6/YXtdksFQd1djV09pDCAbdvL9NPd/1
   aTFxrgP4lP1/DsBH8FeMdO247jnuZuXxEm/e5nmxaoPxIe+6DkA0y+W7v
   x61vzer0XaQUuKsCbYk3ojG8zkkYxm4uboxB30HbrqQJsdKPu5kR0+HbT
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405763"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:31 +0800
IronPort-SDR: J2KJFKepD6Ub6fB191ErwJju0XgYKwk/oVIORnSIE9oIDAxuxC2abIxhq3n61DRLHjwBXUOxV9
 shZFvvLilmHtDQi140QCkcs8FVMKRtyg0t3dwwRzjl9GafesFtyCNDz/KiApMaqnUnfuuNRyhJ
 0+sBJkDlqdgHOvuQPFMmXefUNlDOTuMu9sc9zQn83bGFHXMTUbeO69XIub8q4fZrOu8oSQaZce
 VwGBtWQCJ6n3GE4saLrJSxoXEGV5azE3zNqVLKYNTsbpJDfSFbkvXf3p0ZNkuIzJf7z8zeU3J/
 kCaclJI9Wje+ZmmIRCuYOeGC
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:50:07 -0800
IronPort-SDR: xVc3QIZe6tmgBUdYCI/ZE6AvwsILrXnLTTW+9au3dLxWAx2aPdfn9zctXPX1NKpg4S8qtPhhps
 03OHZ1yAgP56Iy2x9p2i8BOp29B9nV+D1kk0i4zq37HulxPvcvEpa+wPbmorYRsthEPI+SI3Qr
 8j+6aFJ3ODa8Etcb3s0yXkbdrLiezCFb8BkWV1UyxSGBvGuZw0P4IJA0di+jmR5iqJ+LCxMNXx
 rGvQbRJOUjP7SCOZ3KRZpbITO4D6VX/edEIroAjbA7M3Q5zeIfrfctV7XB6e1jp7yUBWOeOn50
 lY4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:32 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1Vy00Dyvz1SVnx
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:32 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327111; x=1647919112; bh=lVB2sM0qCfqo8mvvo1
        uohffxKjaC+Yh2JveklQXFsqs=; b=gWeOvtA3Jbe5G3Y/O73r5lspqyUnGzMeYE
        sQcZ4Rxc8BKfnHuFj4PgtOvPZPz65OT0tC9L8lldS1AkB2WtS6JaZjsFj+tdz3rD
        QghAJ7TzXyR1+ygboWRHzIicwxof5s4LAh13zLKNoDgu3Ui9kRZDta1OL+LfejDr
        IA7QUIV7SQMslFuDcuEoE1XFUCRYUtr1ZQib/o/pidCgb8ytNpfUAEIHFnJsEMtg
        Ie6g5YoHH79paypLlVyOkiM2+bIhSwEooEzUz7MNnoAQXJG6Q6PvjxiM+rRa+dva
        IcWu339MXktoZmWloxHWrYrzrB51fq84BVjBCvw+9aYEEPtvOHhA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id OorrXS_lRvr8 for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:31 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1Vxy2jwMz1Rvlx;
        Sat, 19 Feb 2022 19:18:30 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 12/31] scsi: pm8001: Fix use of struct set_phy_profile_req fields
Date:   Sun, 20 Feb 2022 12:17:51 +0900
Message-Id: <20220220031810.738362-13-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
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
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
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

