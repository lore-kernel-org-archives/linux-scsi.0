Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 611B6C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 11:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241116AbiBJLma (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:42:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241107AbiBJLm1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 06:42:27 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE509101E
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644493349; x=1676029349;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=N3XJN8UajDt2lz2CuLZiwl5BwExscC5k8xty4uLPeNE=;
  b=DJhZVUs1y/63SPqQt7rn5YUHIJH1855iXwaVjE5eKXDYl13QvyRKnkKh
   7lw6Rx7lUcw587nBCFT9KtBOPozfTOZRg+KRzuZ3QuHxGZVfAyoFsU94v
   04H8IrpWPykALB0mjWxw6MNPWl1sGe+WG+Ec1K3iGWAtLudDIi166ZEMq
   N6HQdcNYantCQ/qwFmP9kIPStx+uowjnJQlOxBYfQR0EKgKExh3i2HSpy
   FLTnsFJwpK22F6QqaVkXbNuppEsfhYPbw5OaIcGqttoDE5StcnparBb9v
   GDzXalkdee/RCkj6s2syoEzGbIrkuv5BCLrrsO9jcoGWslQsRV3wztbYq
   w==;
X-IronPort-AV: E=Sophos;i="5.88,358,1635177600"; 
   d="scan'208";a="193575626"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 19:42:29 +0800
IronPort-SDR: eQ7LySPqBpmJKIrnqt9y7SCLLmr8bJ3jZYc8f8uH/Gqy5VIx305HkqfsdpS6cto1SxDMb4+x52
 EguG8vlAgf6ESOqieof82mhwT/DNxBDSnQVEjC7WrB5lenqcO6dwaV4/oEqnV864gsaW9vhe4p
 ZCfdjBgGiGwpH2BCgBUCMdvrUZKbSIbag9yMJcsRI4tezMuPw1DItt/DZ+hqMzElbEhHRmxWcA
 bqE9xOd6bfA/qN1PbsUyRaMFUyGbmZ3I7JP6OaEQLRIFL9R9e2owzIA/9hQYLpIBs/Qu36Fmix
 M+8pRo93XcDKZYdmDT0H83Ih
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:15:25 -0800
IronPort-SDR: 3LeuCNkKdDlkCzjGyIlyYt4gbTjmt9GFcql0Bx6p2hro8BCsOh3a3FOuuH0uMXFvNoKrmnW+C5
 gNwlb8qPeQlRUTQVAzpqZZtYsHGeeoQ7O8lplGmJxihrx4QqIsWMIFVDuEiql8jt7CFsVO+9S4
 QDoBmG8SDyEKHB97UffmDSDyn2aPSumoUqYTUzYy7P7xTpFOb3e7uKjH+xvwMAgsX1Nfhm5zad
 4p5wh4BWyELP5dewUPB9VgNH3d+eC0JeNkQ9uKd7+wTW65HWYQSH2NTPwF+zS72+9UQbC86whn
 qTY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:42:29 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvZc436Qhz1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:28 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644493348; x=1647085349; bh=N3XJN8UajDt2lz2CuL
        Ziwl5BwExscC5k8xty4uLPeNE=; b=ZyWCuBPp9toXQ6MEmjF/U5oTbKG6BHgE+h
        moQo7tn7UnEy9w14dlO+RFGNEymyv/MjXM+Nw0l6YMsNinEBoAm9WSYUmLnaA2yN
        p7+1Lg5TplZtXW6LSa8KvTqSew9A1DReRJGmRAUcfYoSWqBKXD64EX1d0ixXo5a+
        D3d/Gv38mOVa3QrCyGuOFeKv0YMwEbrdYgvB/HjyYeWO91QjkMhpfc/KynpAb/hu
        kJRkv8BDQScfp5oJxtRfQ/Ck+wIhtj7ee4dIt6yKTSkDcQ+TssPJ7y/vNbtdz0ot
        CAhJR/DqtlIUzlK2dqEGXCTUCJRD389YJW1masEixF2ySksYWR0g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id hhTb9MA7fvME for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 03:42:28 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvZc30cl0z1Rwrw;
        Thu, 10 Feb 2022 03:42:26 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH 04/20] scsi: pm8001: fix __iomem pointer use in pm8001_phy_control()
Date:   Thu, 10 Feb 2022 20:42:02 +0900
Message-Id: <20220210114218.632725-5-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Avoid the sparse warning "warning: cast removes address space '__iomem'
of expression" by using a local unsigned long variable to store an
iomem address.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
index 32edda3e55c6..6805c7f43e41 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -234,9 +234,10 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, =
enum phy_func func,
 		}
 		{
 			struct sas_phy *phy =3D sas_phy->phy;
-			uint32_t *qp =3D (uint32_t *)(((char *)
-				pm8001_ha->io_mem[2].memvirtaddr)
-				+ 0x1034 + (0x4000 * (phy_id & 3)));
+			unsigned long vaddr =3D (unsigned long)
+				pm8001_ha->io_mem[2].memvirtaddr;
+			uint32_t *qp =3D (uint32_t *)
+				(vaddr + 0x1034 + (0x4000 * (phy_id & 3)));
=20
 			phy->invalid_dword_count =3D qp[0];
 			phy->running_disparity_error_count =3D qp[1];
--=20
2.34.1

