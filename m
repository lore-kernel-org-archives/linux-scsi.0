Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2524BC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240823AbiBQNbB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:31:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240931AbiBQNal (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:41 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002282AF90F
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104626; x=1676640626;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/T+9kSoSa358h9hTSLs4JZ/Z6YNlu4T63rCI1ItSowk=;
  b=A7f2SXjVTk+RSyW8gjx8ZZeOGyZIukLY3AwV5XzRWTwvcCzqCsc5spqp
   qu1eI1gT1EIUaFK/x7WuW4OGWln81kunYfNRR15J+WPKKgmDVxkb1esc4
   UtrG1nVpfwJhQXEVXy8ufmaMy0nXHDyE+pIRVXsfIZcwuUlBSF5XbKcdX
   QlbzxR5swng/zMkf1o65/y44cvIsNEQM8Me3KTa2YohdVQb59CbfR2xmP
   LYXp9/TuHAIa9uC4man7srHC7dTf3vQGEXPV8MfirlG0F87vTmneOFXC6
   3OTQe6AF7FGBV7uDthwpe9ZiJM9sBAWKv5nW/AVwj2+pOP1KmBu24n05x
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303215"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:25 +0800
IronPort-SDR: hYuHzBBANpB6TOvFJpFjnF6IrY867BFNSI1NZw3SJaNi3x967KILnHpm2vdRmtu2ojntkosvGR
 CrWh1wXDFCeVrE1qT8oUHsBBM231zd9JvIC3KXtrDjOK3fFY9awdxriIb91zgfKb/aq7Mq53/A
 bsFuXxfFgDj3xvqBsSwzYINUf6wP1PGpyHnPrajsDwndYa6E4zN/NZ+kyS42NcfY0/vqtIoUtH
 HlKV0hZDPT9lsPR03lxeNNcAfOICrjFk79mApEQB/D7kWJ6obJ09tHj07i8BzMB/0PPnlOgzMH
 aubn3lS7v9HNx/RwiL1J7sRw
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:02:04 -0800
IronPort-SDR: nTTal7MzTNrWHO9b3AjXr5HzIjn+QlfNpIBLVzQBOMmMO6ZibkZketZLHQP26D719MbafQ883Z
 0VKToQTXe/hL41WNXkFrW7ZTiU50c7N+Ojse9vGXxxn+NJ4aRlqb812vMr+PCmHz8GD1BRW/Ha
 WThykwMJ9JOu9g1vBwnJnx0+CPk1hEcXuVecOvao2FHVMBKzROY1d7mqLKIB3i8Ft0/2+nCSgy
 S9zKq0SpWGvnZNGZZHXkKTJgrwxcEFFgBLhmjPw1s3Wd/zou6S0GJlABU5FFxsKPKrzm2RSDlQ
 2iA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:26 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JzwgP2QGQz1SVp2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:25 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104624; x=1647696625; bh=/T+9kSoSa358h9hTSL
        s4JZ/Z6YNlu4T63rCI1ItSowk=; b=I/GJ1Jqr2RumsiYDPBsgX5Hh/OWb7pZNzk
        ZMlhiDJvVG0ssxM/NiPGikze8G20phNOqkkH47HlvwVcvYbmfO38Wq+hDIh3Q5Pf
        Fnr43PzRyDlX4KxG8wHIY47dkurQJs/MbYwJTz7Hhth/sL9HsQMFwgMDa+zUo1CJ
        eezh9+/owbuMi23l84S2XohyhiamolB27QfUFZt7my8zP+wpRJTGrYDopytxMSxA
        U6GMZ87gcAWjnF7cdf2r7mIX0ILQpMWsYgUHRSwCqRaUesMbTonz48VhgSGNmQi3
        PFuPQfVPyihX0IyL6n2hNxRxl1ldh+Folr7ee6mmj5y4v5GmvPZQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id oV-td7bFNLAT for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:24 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JzwgM5kNlz1SHwl;
        Thu, 17 Feb 2022 05:30:23 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 18/31] scsi: pm8001: Fix pm80xx_chip_phy_ctl_req()
Date:   Thu, 17 Feb 2022 22:29:43 +0900
Message-Id: <20220217132956.484818-19-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If pm8001_mpi_build_cmd() fails, the allocated tag should be freed.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 76260d06b6be..a5a99d23cfbe 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4920,8 +4920,13 @@ static int pm80xx_chip_phy_ctl_req(struct pm8001_h=
ba_info *pm8001_ha,
 	payload.tag =3D cpu_to_le32(tag);
 	payload.phyop_phyid =3D
 		cpu_to_le32(((phy_op & 0xFF) << 8) | (phyId & 0xFF));
-	return pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
-			sizeof(payload), 0);
+
+	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+				  sizeof(payload), 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
+
+	return rc;
 }
=20
 static u32 pm80xx_chip_is_our_interrupt(struct pm8001_hba_info *pm8001_h=
a)
--=20
2.34.1

