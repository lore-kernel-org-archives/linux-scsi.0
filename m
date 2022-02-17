Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F720C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240794AbiBQNaW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:30:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239103AbiBQNaR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:17 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3602782B3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104602; x=1676640602;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1yvh82HH2UmUw3aBo1/a9AgaELousAEViKy+r0E76aI=;
  b=rt+ia7gfcPFfH3ctNCvMeilBMOLgIvU2B+2A5Mc+Ez6KsqwDlk1H1iB8
   jgjbe8+aM1Aj5AFGFNdjoxrUmbhhE/GXoMQF2PRYno9UhtJKpzPYuSH+h
   0ZBfT6CRKD/qjKBwTbNSdaY6vACYmvfvbzg/I2k8QxGbdJOJSa+FFytSa
   24k07SpL56ewiJ+dqm2M3z7c48JhHbWgCzQoue+HNLp0AuikzmHYWiGCK
   qQUtjysrwA8EGIe94pBgkYBsxJhLJF5f7+rL74TlhaHKJveYO+GK+92tm
   K/kvEJfON5RkSVoUJCC76qKNC5H7zFNSdX5KDm759gav4lH7UnisIObeY
   w==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303131"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:02 +0800
IronPort-SDR: xKTOm6DPq1SuaYgMRzLPq+Y6PDdUcqxVD1bSc1L0B+MmLrwIlKyLJugS8ilBn+qwy0PwNkrGSs
 D/IqK4PFAfbKXJbYqY2lxSgUPePgbRuRLbEE5GeoNIGYWB8/hfatAdfbySpFu7/Ff5Ww/1PXxO
 86cQ3WC/8lKadLxfAkX1lU554QCItT0+oEjJ3gQiZOiHTWNCh/749QDCIWmFcaPG1AqIM2JhGw
 XpOT7cUGuweXYHODIJpP/ylPjfzd7tXmZB1Pbo6qcB1qhQ77Gk4dddKbzovUs0ngEi2Fy9NILc
 AQJo4x+H9SgBeUKjQQ/Ts0kR
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:01:41 -0800
IronPort-SDR: hHN8UBHBERC+kGsWK63Mb+rqnDdDC9Cu5V/x6gjtV38NLCHwCa1z2L2DURFyUSxADLB65jGg8X
 Lpe3dGhoSNNLTXYGBWhtYFd9D1uU8dovC9yJXbnK9C4WXO7nWiLD3rSAID07cj7U8G+bONmGvj
 nYZYPYibI0ENsmdSiOGjTqVEpgP+MLsHZGBW6hilLX8uyu0hpKis+wkhi/qhZXmen7OM0v76WF
 3DMKmL9bMisSDRuyhn8DfzTZnmc28g96IQY20AERk11iaJHdoEJsbBfWL1FIjTzQCAIP+XGViu
 ajU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:03 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jzwfy2YgFz1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:02 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104601; x=1647696602; bh=1yvh82HH2UmUw3aBo1
        /a9AgaELousAEViKy+r0E76aI=; b=BEr6xUjZuDkFVvPJ3AqFfLKCUvCLjnirK9
        OYh2qpsT2UslKPGJct5i+WA8wneYNcEqig2fdjNiwQxq1cu4QB332Xzv0rObDtIw
        n8oiZGVQqsdcuVpR65X76B5fL8bf+NCKfbauVU8T5L7vJ9OIzTF84VwoajvzHq4X
        +aLI8rl05ASOaTA6N/U4LzZje8Xa0SWVB01bp6X5UmACM7VeD9NJ8lxCaiIqec8w
        HI/Obz8u3yX3m0l6DAs1mV19edd8PLShFYJmd3GM6E54JwimLeiWq2JUgOKBBmZ9
        LZdOsZ3/cEwwzus/CmhWOCGploETdh84LXyBFZJ4bgp78ozVxlRg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 2TaZXoEgQMcU for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:01 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jzwfw5Pyzz1Rwrw;
        Thu, 17 Feb 2022 05:30:00 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 02/31] scsi: pm8001: Fix __iomem pointer use in pm8001_phy_control()
Date:   Thu, 17 Feb 2022 22:29:27 +0900
Message-Id: <20220217132956.484818-3-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Avoid the sparse warning "warning: cast removes address space '__iomem'
of expression" by declaring the qp pointer as "u32 __iomem *".
Accordingly, change the accesses to the qp array to use readl().

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
index 8c12fbb9c476..4ab0ea9483f2 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -234,14 +234,13 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy,=
 enum phy_func func,
 		}
 		{
 			struct sas_phy *phy =3D sas_phy->phy;
-			uint32_t *qp =3D (uint32_t *)(((char *)
-				pm8001_ha->io_mem[2].memvirtaddr)
-				+ 0x1034 + (0x4000 * (phy_id & 3)));
-
-			phy->invalid_dword_count =3D qp[0];
-			phy->running_disparity_error_count =3D qp[1];
-			phy->loss_of_dword_sync_count =3D qp[3];
-			phy->phy_reset_problem_count =3D qp[4];
+			u32 __iomem *qp =3D pm8001_ha->io_mem[2].memvirtaddr
+				+ 0x1034 + (0x4000 * (phy_id & 3));
+
+			phy->invalid_dword_count =3D readl(qp);
+			phy->running_disparity_error_count =3D readl(&qp[1]);
+			phy->loss_of_dword_sync_count =3D readl(&qp[3]);
+			phy->phy_reset_problem_count =3D readl(&qp[4]);
 		}
 		if (pm8001_ha->chip_id =3D=3D chip_8001)
 			pm8001_bar4_shift(pm8001_ha, 0);
--=20
2.34.1

