Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 476ECC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbiBRDRj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:17:39 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:58512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbiBRDPn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:43 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288711BB725
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154113; x=1676690113;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aFrF4rJ6wByeGWngQJkFybPJUoSWqcmYvM759TiDF+A=;
  b=pwlAduCHMdXht/9GEeLdBIQq0yLiHi6Xug+UUvfm2Qv3izWAwEgnGtAC
   VToKsAG5oW7fLnPK6PNkJjGARwIt0GOU0nalF2CgGrC+jFtWhqBe1xml7
   R87qiarnlhMaEADKYErrCNJ8GKGMFwSow9hoyR07zuoEpQRa5f9H5JP4z
   E6od8J/xKGKi+uQYeOWTMrox3bGlsehnsUq4Iwa+k2UTsyGgM8GN8PCHK
   3kVXviMl1xTq98Z2pVJ7qP98SeIQAgdWdffXzi1m/6dDyppbpiSaFUu6K
   akYMXQc0FDlIDbUccnYh6JE9qbTH/80p6sBRWx69zGlIQ6fm+5ijJH2jf
   g==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="194225804"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:15:13 +0800
IronPort-SDR: Mdljyg12KKdwGAbStibixYroh9zCwGnGrhMZaKfD7Yyy+KGMs25+1vCY1y5rS70M7hNLZtRWqg
 KcQ89zTNJhUMvczWINLr8s7lnOx1i4W2RUkm3kluarix/aHhE9HguORxr43wVRV9sBiQwEQFY5
 RbplKm/5ipDjpibJdV3Z2C1b/XHUVDDj5SUYeifndZvdg41CfH2/dqtBrBfvL13FhIA27TR65n
 jtNtT5LW2CmveXXRXQtwxiHeLMlT3kIzmllHMhhZbl/MtlWDbZvcdM8KfFjD+b5kdk+gIpp8HQ
 0sHc/K5p7HRGTxLebSd+SSmR
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:46:51 -0800
IronPort-SDR: P1AkybG3e61Kk/+Qa+WSppxIyWYhmCmiy95ebG+jxkl5V45ddeQtF376WPLiJM/wgT9cVUbOCl
 jtjFziBqHerdezwSm9KApOTO47puiURfy8Reh6M3OZIGoGaeWkHNASwhbOSU2mn1ItT9msUvud
 RY+7t/W6qgbd7S4Ks/XkBBOlRGBIrDxgswAoaIDbckzPhKlnxLuPbHygoX8jadQ6uK3Ki5ecsb
 Z1V4LD7XlDy7cU2SaNzE8JML/73A+Ob0WOg2Bw7gqNc7EAwwD0eZhXtG5f/Uh4tOZHjVAqQJ/e
 Zt8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:15:13 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0Gz45yJvz1SVp3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:12 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154112; x=1647746113; bh=aFrF4rJ6wByeGWngQJ
        kFybPJUoSWqcmYvM759TiDF+A=; b=Irb6sSipA2G0d/3qXnduOnlumgjOmjm0OW
        kZo1fQczD6G0PVTFeMo1Zlqwk3uoAFdbugDIvhbn8rGBJ9XhdzXIqZPdmodd7hj0
        aAxBvjfv8kSHtAUPr7vV2TH3x3sLcldNuJDsnbDzJvlcjRCXz/iJZUCr9ptJKud8
        tph75me+3zvzRinsMyxy9BYPbJnzFLQJblzLJ0hkjU2s2uGykYhB+G34x0xlBOf2
        IibbzuzDN7A+OqSbAoYWQ65aQKB/zT+d674VOE5XxSf4QwFQ5sZ9XrTXp81puWU0
        jNC3nSfvAAJv+mbq/3Si3M48a6xOuMU0748FVpBo7eLOEpNqsopg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id AHliiNMqBwhH for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:15:12 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0Gz31Jwzz1Rwrw;
        Thu, 17 Feb 2022 19:15:10 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 17/31] scsi: pm8001: Fix pm8001_tag_alloc() failures handling
Date:   Fri, 18 Feb 2022 12:14:31 +0900
Message-Id: <20220218031445.548767-18-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
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
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
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

