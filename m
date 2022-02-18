Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 006B9C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbiBRDP1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:15:27 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbiBRDPV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:21 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3B2120F7A
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154106; x=1676690106;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lVB2sM0qCfqo8mvvo1uohffxKjaC+Yh2JveklQXFsqs=;
  b=A1JBYECSNkKQeNiHniw2KGkcYGe3XWSaW5EIFwVLUz/kACoDVVqAqG9U
   tObm2FjyrImSQd8YErOpbGIcMiGs75/0uz3c5MC+PjhTnnpFFAWjTg8R0
   jQv+u1I6FQsj7JQd5vxvlMEmDBvaf7Q6RA18FvGyoA3XzskL7xrpFMKux
   Bum4YG+GjjOdTqx1xdsxKbKQ0ZFnibEgpQRXDXuql379ZCaXJM2IRwHaQ
   1gZW/MAoPRQOVFjaX68+ug0z4u79IexIQ1Kty/Os+e5nRADQfKnZlrJBG
   InuLRD9cMqaNwsPYt5AGI6fG8uOrFxG8BUKMhoNggM478hzBRYBl3VyAJ
   A==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="194225770"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:15:06 +0800
IronPort-SDR: 4oV6jlsRploWj+12OSHrOGa0zw8g7NSlO//FGohkYeJpd0G79e4egHRybyqMW4iw3MLd7vrjV+
 ix6cYDQIUHEqMpnAlV3whp+qw7bRaltRAdCikW0CJbnNjPpbicLvGNkhSsLmQrdwE+QsfIEpYy
 e5wKiGn40K9gMl2u5JZn57DqpU9uoHXRH8ubc4EhU6YxwHgpI2dT2tOEgebbZ7cXqh+e9bYvgV
 2NcrTKL2bfbwv0osok/p3VHzxSseNwm9SsvahXbGW5AuZPa1wqHaRG0P4bN1nnCSj3I71Yb96E
 5vKjH6pknici7Ehnid1NnovC
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:46:44 -0800
IronPort-SDR: z4QY46s2eisiK97TwRG4934x1gOG90Uo78m6xrXsxplVK0yCfYEZLQoSAHqpHHUd06CBO3c6dN
 kGM5sa6xszBh2T3BlooNBa4jY/9IaqB5bbOUf707giotowy7vXJwJfqohl8WKIbgO5/gAE4JF4
 RdVQnmY4mXxD6IYthfyTeqrO+KQUK9jjgWzed0HLiL8nfyKOYNLncRWXi7Rh8DQEC/KxtC4VD/
 EoS1Bw8GMg1kmkbA8lQRk6vxwNuyKclE6ImoMFHuF1iBptYNkjS3kdZ6JmYEJNnjEWI3Wq7AbF
 07I=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:15:06 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0Gyx5ZZfz1SVp2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:05 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154105; x=1647746106; bh=lVB2sM0qCfqo8mvvo1
        uohffxKjaC+Yh2JveklQXFsqs=; b=B3FkjmdTJS58RvMWLD73fXUSyaw7AXl618
        V0zEMNsSVv+zKaffUkByC3zmEdVo7mZDFLS3vx4/FGvSQ05zyQ2FfBupO1dZAu1w
        nl/+Dk1asOvJtDWkGtL65ii0WBiXrQx1S3Rmduw28RhkQ5H8B6nqzFgeintTyjK+
        yNnQ8QHNPyvJeY8LLF5hXoHe7RSWThVGNF3x5Ya8CKeGG7ird39sBzoELnRWdt2V
        +ZqbsI7Jiu/aK533cg9dOi5b5dtfAeek6rgBh9yeyOJr1E00hPR+TJUhxNGWCwSM
        xgnKCF3IJAAyX02+rCICAj/WI8UYo1TdKvIseaOs/PsX2MILre2g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id wa7UjYzhOVSt for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:15:05 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0Gyw0jBDz1SHwl;
        Thu, 17 Feb 2022 19:15:03 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 12/31] scsi: pm8001: Fix use of struct set_phy_profile_req fields
Date:   Fri, 18 Feb 2022 12:14:26 +0900
Message-Id: <20220218031445.548767-13-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
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

