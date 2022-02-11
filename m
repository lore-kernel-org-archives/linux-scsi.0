Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE79C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347730AbiBKHh3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:37:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347708AbiBKHhU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:20 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A8E10E1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565038; x=1676101038;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=9iGRnRm6RVIa0BEI369iHW7Fp1wTznqFrwMpZVlIlQQ=;
  b=O2m/P6anOPvHJce92hdfdJlCNUZWFF6bnHd612LECdmA/rGMNnPD7aG4
   EZ0EjednQ8eKpcFErBtyETYUZfjgVreF8ZxS7nf1s8Nbmob14PspJvXwG
   /8z9t092s2sOfYl2f379psIQQPNrVjlwR4khxMCecruXpZYWAMn67Y3lq
   VOMQpL1gEsU+75q45i3mjEqbMwO1DZhmbVv8+T3vX/kpEBNqdkcqNXpkH
   SWh8IAzsEt/n3Yedcwmb2ialXlevs0B3bGkCGf667fXJW6nYaRBVdDqHk
   kuV8ey2/X+fyGNWd7uCvRIggrg48jELRwpVlTI1vvBiRL7CpYdWYZcoZK
   g==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675140"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:17 +0800
IronPort-SDR: 2ubfnBseZiSfgzJf1fEfiaQ1aNXD/Umt+xB16g+0aYyqpXe9JDiygwRBUTSPHicfzmUyOPvnKv
 PY2bkqL1Hb9lczHuopqiCR8cv8mVgtlVqQp7FgBlmMnLJuEhETUByeUXi3w1Gx4bje15odT3di
 6FSoyu/gZStVTLogREqk90QwKwbDApganoRrmLikDg+wmYsZFjGEQTJ050HWOalywV9VERzipo
 21+KJfq7a55t6FD1GpXZjwv5U9sp0Yg79y5Z89EAk2Ufo8yJ7uwpU5V6teQtAbqZ+p73q2brMJ
 zOYWzrWnk0lGp58+KTgIY09y
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:09:06 -0800
IronPort-SDR: PiKfdSNoLYi9zKiJ6wFbKx8FZ02tWxxGQDTeVnCkz3ShdDcuaS58410a3Aa42xXAMHUqnLJi2E
 qn6WKsxbCLSMrFAbz7fz9On/0XPMuM9Uht6OMvfu++soViYEWeCAD8Vfhw00KUMywzBuWKghES
 fJSCowHOkNkf6mDFOn5404qwu5UT0wwVAMwRd3mXf4nE3aAgFbaSQPqRCDMnaiQ8CrqsCOQJt5
 EZuXOp2kDNJAx0ueq99jpGY9GonaaiC4qxBbgHK9qh/sQ0n54x/vPPvxMDFgnNmpeyz2mxnlJb
 opE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:20 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw56l3nP8z1SVp4
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:19 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565039; x=1647157040; bh=9iGRnRm6RVIa0BEI36
        9iHW7Fp1wTznqFrwMpZVlIlQQ=; b=oT6FB0LLPolhVIkeUk18JenPpoD4K1QPCJ
        M3qi1tKXW7jyGFp1nYmth2/3QYCcHEFE10R+1Ou5cU5Kupm40I2Qt3oQ90MYKr8y
        /S6O8ANq9W1C23ZrgseMMkkJDu0rHvzdOXG3Roim5fza+Rfvo8XCZ1lMvct/uAZy
        ijNpxjhdegadnUTFDOc3dUepH0Xx+/tzZVIAQDHBat8gykDcvYYWnwlgEuLEBbOB
        bnO2fQz2huqNTRdV0SumnAY2C6Zgl47+y+BoMi8HEkvRyqpsVPudgSavIyPfFPKQ
        jTsEtdtCTUwyt3j/E5QwikeypqWwBCYFfuMRc7l9flEGSoNijRTA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id FLtD366zBGNn for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:19 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw56k17YVz1SVp0;
        Thu, 10 Feb 2022 23:37:18 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 10/24] scsi: pm8001: fix payload initialization in pm80xx_set_thermal_config()
Date:   Fri, 11 Feb 2022 16:36:50 +0900
Message-Id: <20220211073704.963993-11-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The fields of the set_ctrl_cfg_req structure have the __le32 type, so
use cpu_to_le32() to assign them. This removes the sparse warnings:

warning: incorrect type in assignment (different base types)
    expected restricted __le32
    got unsigned int

Fixes: 842784e0d15b ("pm80xx: Update For Thermal Page Code")
Fixes: f5860992db55 ("[SCSI] pm80xx: Added SPCv/ve specific hardware func=
tionalities and relevant changes in common files")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index b04ab4a1822d..6f8bdbd24156 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1201,9 +1201,11 @@ pm80xx_set_thermal_config(struct pm8001_hba_info *=
pm8001_ha)
 	else
 		page_code =3D THERMAL_PAGE_CODE_8H;
=20
-	payload.cfg_pg[0] =3D (THERMAL_LOG_ENABLE << 9) |
-				(THERMAL_ENABLE << 8) | page_code;
-	payload.cfg_pg[1] =3D (LTEMPHIL << 24) | (RTEMPHIL << 8);
+	payload.cfg_pg[0] =3D
+		cpu_to_le32((THERMAL_LOG_ENABLE << 9) |
+			    (THERMAL_ENABLE << 8) | page_code);
+	payload.cfg_pg[1] =3D
+		cpu_to_le32((LTEMPHIL << 24) | (RTEMPHIL << 8));
=20
 	pm8001_dbg(pm8001_ha, DEV,
 		   "Setting up thermal config. cfg_pg 0 0x%x cfg_pg 1 0x%x\n",
--=20
2.34.1

