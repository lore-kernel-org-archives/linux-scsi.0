Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E258FC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240925AbiBQNbB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:31:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240929AbiBQNal (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:41 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ECE2AF904
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104624; x=1676640624;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TVMRHdQyTJllbT9N8v3MkuVcvUSR3sbRM1CaOETmwwQ=;
  b=mfmpNRsISmmScbb3mgEZSL366IncDXYnKSfa7+exeZBrZT1tdXmiuzPq
   k9FvyEW+vvliGMAZ5DmwmtGon9QwxAXsa8W3DIHY6uCFa67e+1cI293e1
   xvaasCgBVS3bnkz+iI56jx2lYHn8/o13Imo4DPzJwsZ6DyuzKTslrHcb5
   1xzJW0/r6X4YIvh5hYToWVX1erru+8oSJrqwi2DN7TsMku3bZ3O8Vmso7
   mAwjPfkvrRG3ZxXx61FLInXZKjuw3wp6Ih1g5OhWmiJLgrSQiskPXU8b+
   QlD5NoELmWMhj3+cGD3oGaoWV3GVU17zvppJf8X7IR6I2dqi2UpG5rz9H
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303210"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:24 +0800
IronPort-SDR: 2qm9/HUnoDHuH2mvyPPKmf0pQjhe5tNxFEa9Wm467vassXM9vJgVG6mmRCXRzilu3DeW/prSty
 CzpZjXQF5sdybZlFOvBDTAkqyeqjbZTEMQx0TLqNyUSChCfx8pqj0boJCYDgK/haiSiMSuOacj
 j6IlNxg5pe7MT6MCVCaAqGqUYfXSO6t57MXH/zoBgT6VL4QVnQlU4y7aZSH4bl6rl8vmehlOhC
 KcIgZ3l1PtRMUnTVYA1lnCLsR8LZRXfYh7xrV1Kz5uCiYSKPd8RzzMKXb2LzCBP0Zko4geDjjX
 nLSy/KeLYlA3P6cLblE1wWL+
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:02:03 -0800
IronPort-SDR: 7RsJXVrEm0RCp0VwkKh7s7KW/KWrhmqmRKbFzn1vahX4P7+plrnK49V6J2YA1YijofW2+o/pS8
 4D1N8SKx8BEEvuXoHHrVfBUUBKFwtcI2hDnuzVdeg8aFkmov4fq2MvuAas7Kzq+kbSRbvUhh9+
 +Txc7Zj0N5fuLMpPCNOUEhRxsgpamAxzw4gh32vdlfCkfzpN/kE15sFKgOwuzojP4MI+1esT/Y
 03SjGk2NEHnZcqBg0si5vlgZ5yx8u0wlbqoNA8FS2o50vAAGhYYN4HrZbDW/HU9qiL/SLTKo2k
 kPE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:24 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JzwgN0f7Wz1SVp4
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:24 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104623; x=1647696624; bh=TVMRHdQyTJllbT9N8v
        3MkuVcvUSR3sbRM1CaOETmwwQ=; b=Dvr9iIPP0L2bO8iaRhmi11OCEwQ94Q6qdm
        51t/n79s2XTV+7/NwaxaKF2pvIR2vPn41Xl+hMuND9SSYKrwuczfKWdazFtp26AY
        kN7mkhYGEhcB1a8zaMgmU0Jx0oNhWT0t25maxygSvWua/NcEKMlXCk6NjTymp2rl
        0UuJtQ56koDc9tNwzpJhPUqEuzl0VHPgQDmcJ+RmaCCG2T175XqZjY729hX3Y/eq
        Xi+qSucOHpFwGS34mDsFNHgmuOeIu1bDvbOmPTgVmObcPThFpNqI8M0AgI97Ijg0
        JBhZRdWGW2+LsbNx5TbWvSXcAORBbEdF/fQY80Hukt6YGbPevuXA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6YAe_Gds6twE for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:23 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JzwgL2yZmz1Rwrw;
        Thu, 17 Feb 2022 05:30:22 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 17/31] scsi: pm8001: Fix pm8001_tag_alloc() failures handling
Date:   Thu, 17 Feb 2022 22:29:42 +0900
Message-Id: <20220217132956.484818-18-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
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
Reviewed-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 8fd38e54f07c..76260d06b6be 100644
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
@@ -4967,8 +4967,11 @@ static void mpi_set_phy_profile_req(struct pm8001_=
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
@@ -5010,8 +5013,10 @@ void pm8001_set_phy_profile_single(struct pm8001_h=
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

