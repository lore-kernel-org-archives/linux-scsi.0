Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 115B4C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239297AbiBNCUH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:20:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239291AbiBNCUB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:20:01 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B0B54BF2
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805191; x=1676341191;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=5md3sK84QuUpHn35PdxcI4RezoMmvUN8R0P8iTKh5C4=;
  b=fTOGtJ/zh7MSkH26FYCcwxRSpdDcXU7IjLIyUdcJI0LckR+voiSqI7B3
   8mhTk7XhkktNfEu5i3cOGPYXa3Syj/kzHAa3+WPfE+QAXjbYr8e6zT7Of
   pOy0ILn5HmtMTlH+CPaTIaKh1wjNdbH5LYzVTyVNnwiNo735HV0Q1Oh/w
   sDJh8tQ9V6SpEKmBmyz2PypBOmRPuKPfOTA+3mO1X7bMjNG8phrfmkBnS
   x6Rpr1Mn56YuCR1Ydm4B+BXqq+/UkLEjaZDo3VE74Xvxi+Rs77SwAiP4Z
   KZXaCFKuqnjTPAf/kIyiisOwC4Q/0wh5u4p5RSZ6NYGF3Zybe1mzZ1NYZ
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819786"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:19:51 +0800
IronPort-SDR: NKL1fDq+KkK2xbFocl2hsWBAOotzoveyLsTMAf8dCau9IUHLtrNI2jW4sPUH2hHec1m8aXVP2t
 phLyneQ5ucG2VyIheM+JcWovXmZ3SR6ybEGhU8P0qB8kAcmQuBeEGxtylJ63qhKZGrHEU7Mp/H
 TawG1+AJFfhlxVg5EPIem0eHjJQXhnrQNpo70PhEhyc4gQ4ZG7/+G3yCDiCLnMOSIhbCYE+2B0
 QcF5A2d7n+0JvrtX/60Fj+kRYB8OpzxQbwSe/gleM7de5upsVu7ivMesZ7wqCVK/rxVEupE5Yn
 1pYyByZuUFHVm7AiTqGm5yhK
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:43 -0800
IronPort-SDR: 5ox+C6Ax63qhPzbuSvzSSOFRt3Cbjk5ckT48PavqQlWjmVa27D/H51qnp78wTZn5JqLVMHsJFs
 4a/XSKy9j2RbbkzhqMOAOq25hjAxRUqI0iK55iFILzvscW5BP+aOllMJn2kyFWDnlP56dAJu7X
 ABOXjgSHTsRGYx1Oe7kpvJgvrSZ1+MrxbkvQam86kLZbwXJ18VnGJGYkpzZDyM64xdLYQhBvnG
 qHVwF3iZ/wbxQE/YtGP+0i4qz1/XbYDZdZjZEG+E0+jn23ndFGcJYes2vUymMkiTzyyuVwm425
 okY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:19:53 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jxnx42t4vz1SVp2
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:52 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805191; x=1647397192; bh=5md3sK84QuUpHn35Pd
        xcI4RezoMmvUN8R0P8iTKh5C4=; b=dvehZ2Fn0c29Bc7wxQIyBgb+gfkzpBtR01
        3xYzNdquCKzHZnqpT/nK526yeN9wQGdpVXz20X8PUu+OQjp95Me3nzi6OLrVbFCB
        9OhpU8Jl/KlDaGzI9A0Uiqsq3pEAgniF4/NYdFxoQ+cv4DALlS14lbQwICi6tst0
        qEFC9ostEGRS0kzZiHY4CXJZWQELQ9NFZ7q0n3xsjTHlvFETbzrVdmN39Q/hcjf4
        Swf4Rin/eN7/8x8rNEN6Z4vKs4FNqrv8/CJFpGrOiT9RKpO6FozAkV920JdbDVT0
        f3ZXAREZHfcLx1H/wA9Q+hK/6758MaA4l90I7yNK8hhpK2SbAKdw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id rL2rNw19BX6k for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:19:51 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jxnx26RqBz1Rwrw;
        Sun, 13 Feb 2022 18:19:50 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 17/31] scsi: pm8001: Fix pm8001_tag_alloc() failures handling
Date:   Mon, 14 Feb 2022 11:17:33 +0900
Message-Id: <20220214021747.4976-18-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In mpi_set_phy_profile_req() and in pm8001_set_phy_profile_single(), if
pm8001_tag_alloc() fails to allocate a new tag, a warning message is
issued but the uninitialized tag variable is still used to build a
command. Avoid this by returning early in case of tag allocation
failure.

Also make sure to always return the error code returned by
pm8001_tag_alloc() when this function fails instead of an arbitrary
value.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 413b01cc2a84..b0b6dc643916 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1191,7 +1191,7 @@ pm80xx_set_thermal_config(struct pm8001_hba_info *p=
m8001_ha)
 	memset(&payload, 0, sizeof(struct set_ctrl_cfg_req));
 	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
 	if (rc)
-		return -1;
+		return rc;
=20
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag =3D cpu_to_le32(tag);
@@ -1240,7 +1240,7 @@ pm80xx_set_sas_protocol_timer_config(struct pm8001_=
hba_info *pm8001_ha)
 	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
=20
 	if (rc)
-		return -1;
+		return rc;
=20
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag =3D cpu_to_le32(tag);
@@ -1398,7 +1398,7 @@ static int pm80xx_encrypt_update(struct pm8001_hba_=
info *pm8001_ha)
 	memset(&payload, 0, sizeof(struct kek_mgmt_req));
 	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
 	if (rc)
-		return -1;
+		return rc;
=20
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag =3D cpu_to_le32(tag);
@@ -4979,8 +4979,11 @@ static void mpi_set_phy_profile_req(struct pm8001_=
hba_info *pm8001_ha,
=20
 	memset(&payload, 0, sizeof(payload));
 	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc)
+	if (rc) {
 		pm8001_dbg(pm8001_ha, FAIL, "Invalid tag\n");
+		return;
+	}
+
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag =3D cpu_to_le32(tag);
 	payload.ppc_phyid =3D
@@ -5022,8 +5025,10 @@ void pm8001_set_phy_profile_single(struct pm8001_h=
ba_info *pm8001_ha,
 	memset(&payload, 0, sizeof(payload));
=20
 	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc)
+	if (rc) {
 		pm8001_dbg(pm8001_ha, INIT, "Invalid tag\n");
+		return;
+	}
=20
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	opc =3D OPC_INB_SET_PHY_PROFILE;
--=20
2.34.1

