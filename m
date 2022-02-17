Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B707C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240799AbiBQNa3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:30:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240907AbiBQNaY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:24 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD67E2AE73A
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104609; x=1676640609;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GPbMoL3MX4jnOalYG4xolb6yV5fav/eAI5AHjuo0FmU=;
  b=mpi8Fjpmsp0ErIBheKyRBxEOqDmGVhCXW5xeKGM8T5fNCYqJrG46qGlV
   GvWrqjlmZhpSFXPbAIyRL9BFutHZBkPVmJdVef8ZMLDQYhVD6sHOZAWwd
   HfwlpYQBDBh5NlrHdPcx20xAB4VvMkLiKUyGrhb4Td8RMYEL7Ls3e28Ew
   nlbYx8gKeob9vWWlwkrcj9SPj3q+UUQWUILdpnOsoVy9MPWdMk7ogyAxL
   apVfklWBaYSaNr2f2Q7SU/NVJHkVGGHrHiTnPcqN4kp+SOPfxqIg8wsGc
   63OiHptSJRxnZ3XuLWcbiTfGQedfG0IN4njR2oEkwRbVIG0kn5IW5dXAr
   A==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303141"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:09 +0800
IronPort-SDR: ohAs7CjcPBTOUt5qHFX5DFHgDePj8vDiNIKa9VYI+hYI6g/iBvbKdGlBmRvB2V4wkSIUvjjLyH
 ublcFGq+Kl/S7J0ZN83lVUvvvZ4D6J4EsI3qAfSjVFNdomZz0TZcXV3Go4lytGTn3y+b4AdW3A
 17qZ3WfYhOYBg18i2khPOqUM12jGG1/EDB+RLqgsTo3+t08QwYZbhKCuWkEPCJvAJvAeaT/wxV
 XJjRhsF1B26ThydacEtw5z4Uoz4p4HdyW2xyoEkSxOZ6B1WaQ3qr+p7z7Rd1RvEQ102ybB6pki
 HpRo5sl4RaHKTWnBni2BkSGU
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:01:48 -0800
IronPort-SDR: cYI4+fj0C96zGMunI/bVnqzOSArhERu/HOpsZaMeM/cDks+Dspfp6AwMBLOqZlTLjqlm/+A+ku
 wI3jBXXuWutrD9PeIk50Wyd2dZL7HOBbb5FqDoOYu18R/1cCyviV3NXbb8NLEZeTPm4NdOspSz
 WBWi/kHQKW7Sj2h8FHqXAozvp0tC3m2lzXxq41tu6wQEmYB853eNmICF4a7z0fVDtZODBH5hxv
 YING/Sei8HKChmV+fVhUx6MR34lMRl+JkGEhrgbNYlohQQZfNB9WZ49dro+sGNLPZ1bEYtQ/yq
 T6Q=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:10 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jzwg52rxgz1SVp6
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:09 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104608; x=1647696609; bh=GPbMoL3MX4jnOalYG4
        xolb6yV5fav/eAI5AHjuo0FmU=; b=ZKO7aWtgc2BiYC6dYFQ/hI7EuwNEUa23h1
        PKmje/ddscTNv++hhEcnl3e741H/5DEpj6NJKwyhS/qcnThnCG7E//RyUPJS4S6w
        GNT2bW/OXEkSaYYB9jhfdqyEb9jOsEkpsvoEUuO8u8ZGb6WDm8u8DmLP/EuYAMVy
        t0qCGpv3r5o5kb/ol8YBF5LTYVaoSJlC7EvNrB/aY0nljuVN5AnPBc2lgysTG499
        8HPvJEYL5rE7N8UTqso1RK0LEWJggCo34x1Jlw5/Aofyl0aIkq47JdElelyMyCZo
        EP4wfZHpjnwSe/vs2hUFfMfHFZOR/PmatRBLKzcoaW8Kc6TLjHOA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 3-7auYmdcTLx for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:08 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jzwg35pKCz1SHwl;
        Thu, 17 Feb 2022 05:30:07 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 07/31] scsi: pm8001: Fix payload initialization in pm80xx_set_thermal_config()
Date:   Thu, 17 Feb 2022 22:29:32 +0900
Message-Id: <20220217132956.484818-8-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
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
index 0b3386a3c508..b303bc347f3d 100644
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

