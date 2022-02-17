Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D567BC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240817AbiBQNaa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:30:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240922AbiBQNa0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:26 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9149B2AED89
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104612; x=1676640612;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZHWwvTnBQeYLbzDlAXDuq3Laac+akeFkIm/67YdCyPU=;
  b=BOHE6RHDjImcB15zNDwhFh1+hu2gi/6mgHh46nyic/dqeTrGVIYo1p9W
   epFunu8lFRwP/HrUZTKbBvfH3TOjSANh4VCnorYFx2r3plkDJns29MqWQ
   9Me7phtsYOzlroKuYumQZL5xwo4W+ryyeGsYFAdPJIhRO2CoiuGBzB029
   1iOhVDAqD4R5yVDWSkhWcj3Yq+yv7E7MAQHi96GEOJ5jcpWQs6a1DVw61
   S7p3cSP19F4lgf45ZcAKhb+jUuHWZln1q0jInA8p65TKtIYnhiRqEmUd/
   USfMEHARepLgE4L/Jgs04ysqltKQftUdX1y3wFbt1GHgHDrWwLQOPKZC7
   w==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303157"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:12 +0800
IronPort-SDR: eJ8gnuJ+HI8Jyt4AFXZx/LBEbW3ZbZmhK01Nb8Z6MPrOvNOeIBFa/njkkGFPVrLbCswsTX7PGi
 OKBLtuLpxZFj/oQSK77ZgIquk3Cwexzr39ltxI0KMYhl+Agsf/gI3pg440/tJPK8lomJqTnG8K
 5PcIpDLh5+wgUpljdrMX67/qXa5BKpDWIrPnYj8L/dFY5PEFDQIf2NwRD83oUVAjyFxY8uUZhb
 Acb7vfYGglDCRsb5f4CZg4LSqSf/DTZtFBOEM0TuMItpTmPew2OURA5n5nsgvSaiP5pBDuUuos
 Q+yA8rbawwszDEL0tl9w4KwQ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:01:51 -0800
IronPort-SDR: iNucdLnoZYN6Zcj4KXO0P2OLqfXhBnEdtcccY4ZXVp9gA8dfbW1EtwwOBDzUTaRa+Pm819Nd4L
 uIMy1PaAvDFkYYRwCwXpzpnvi/NROSArDZQqliHTZRDcX3z3+HXELJNxOBJnTgQCZckttoKuSI
 /e1UAg8EGK+G/pbriZNu/zHYmMcF12aXhCznF0elzf8ZzbuDxu1Fxcco/kp1I0SVpJl8NtX13z
 X3VgtouKvF6xO3olIfFgxLniv9hgNbrxhr+Ho0GKPj9srp007wSmiLwWVU94mvOK/ZAisZlHqV
 c2w=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:13 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jzwg81PyYz1SVp1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:12 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104611; x=1647696612; bh=ZHWwvTnBQeYLbzDlAX
        Duq3Laac+akeFkIm/67YdCyPU=; b=mii4MaPu3fQcqpoix2dOaxCkRqeEbHefAl
        17F9Cys/yoXg1lijqUlXxg8/EDpkVScn0Hvz28v+uKsE6gZI/s2mzeyGEz5F9B8c
        P+XWhcT2XRgDVtRZuhCL1xviwhjuKmlBJ9J0m1HtcXOcR6R46a/oHHstDX30Padq
        4jclSh7ZA9TbYu65DbeQCLI1gIRSx2BjQ8GO+tzDPBBj2Bj66rk/6GfpDfgLzuOR
        FyKh0NAieGgIx3Zm9oOdbJtuvGq2NHI6Lf/xHEbiAIOXW72Husi2PWdSaOoeikIC
        9nZdpJWre3AyHPGHADB16swMH1nZLm+Q3HJv5Zlgbqv3xxKh69pA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 9ockk91SXc8s for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:11 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jzwg64FKFz1Rwrw;
        Thu, 17 Feb 2022 05:30:10 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 09/31] scsi: pm8001: Fix payload initialization in pm80xx_encrypt_update()
Date:   Thu, 17 Feb 2022 22:29:34 +0900
Message-Id: <20220217132956.484818-10-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All fields of the kek_mgmt_req structure have the type __le32. So make
sure to use cpu_to_le32() to initialize them. This suppresses the sparse
warning:

warning: incorrect type in assignment (different base types)
   expected restricted __le32 [addressable] [assigned] [usertype] new_cur=
idx_ksop
   got int

Fixes: 5860992db55c ("[SCSI] pm80xx: Added SPCv/ve specific hardware func=
tionalities and relevant changes in common files")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index e6fb89138030..b06d5ded45ca 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1405,12 +1405,13 @@ static int pm80xx_encrypt_update(struct pm8001_hb=
a_info *pm8001_ha)
 	/* Currently only one key is used. New KEK index is 1.
 	 * Current KEK index is 1. Store KEK to NVRAM is 1.
 	 */
-	payload.new_curidx_ksop =3D ((1 << 24) | (1 << 16) | (1 << 8) |
-					KEK_MGMT_SUBOP_KEYCARDUPDATE);
+	payload.new_curidx_ksop =3D
+		cpu_to_le32(((1 << 24) | (1 << 16) | (1 << 8) |
+			     KEK_MGMT_SUBOP_KEYCARDUPDATE));
=20
 	pm8001_dbg(pm8001_ha, DEV,
 		   "Saving Encryption info to flash. payload 0x%x\n",
-		   payload.new_curidx_ksop);
+		   le32_to_cpu(payload.new_curidx_ksop));
=20
 	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
 			sizeof(payload), 0);
--=20
2.34.1

