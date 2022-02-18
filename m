Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EC24C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbiBRDPM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:15:12 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbiBRDPI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:08 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885F3888D1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:14:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154093; x=1676690093;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8IJQAYYmg8RPwzlveiqyKuKOi4pmaoiH3Uli4OVOdwo=;
  b=b9OVl9JDzMOXGy9H7fX5h2ajqST6Pzc14m7M0gz2k5X6Az6wn7NQga92
   OXrmmlJ75lyprRdIcHWNJnU378ku0qHwsDOnRzDokXdyEc2bEvJL6eOyP
   xJOaIy/tajwgBU3sV7QOUIqQwAbP7VMImyx29QqnePHIBA2hBvP/crJEt
   P8CpBMY1ncDH/U/JsXDjP9iii9mqXqFHN7kO2v7S6Zdahe/K+qeK7p6hW
   tq9+7HrjqiOJT9oGUuwEciUU1io9PmXOI2E20IjdXluJv6HBHPm1ygc0q
   C6i5YGtdhXruCroiuzr2ZuEuCnHdAGdACVVz0vMcEltLGASMZ5D9VbRjZ
   A==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="194225703"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:14:53 +0800
IronPort-SDR: uxSQWhNP4gvMmlFGHChoJm0E/I1aAp1X7uXUah9OHKtW97ztwbPW/xmtOtNvSYEl6wx2kP9SbK
 52fJmZc97JscRctNToRvw/OLH6bl1YqNLeWeMhd+tunX5RFYSN5lmfLsTK4+VfNtjjQVw+xPLb
 SzddmNpFLfBXivZdK9dOoxnB0cUyAaciUOPOgFCvWFm/U3bA+PMFdC8UQI52fNOvwhA7ohwkvp
 Sisd3UrN7uBlr6PBihZDMqZCIsCSF/xYU8d04lU45CUXwF8DhGqti0wr5hG4wokYxEoshxF4ZW
 OXQQCq839cQLjuCAR21oN2NP
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:46:30 -0800
IronPort-SDR: c3fliS+H7gEyeyG/gPgWApM0oX22LKUD7Frv0RUTDal+z4DCawRzBxWqj6IPF5lGmwG7zGAtIh
 zwz01ekq3J4eBp7I0UHjNa93jeG3SgwLtrQ2aGKIT1xv5nsqQ+tHXB0pFv5RoZjisZO3/Xh0IZ
 LSX7Lg36Olkxv/+Ku1RPaDnsbrxkABUUmEPsY+CeESABDgBJ8yttbbStPWO6KRJfjG585+UHBV
 rBJIxg6AScK5ZtL1LRJ4M2z3PHEuxU6LqILk4S7GmEtjxW+ZJHR+WDGIwERcH47hpDM4Zb+Eca
 Esc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:14:52 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0Gyg6T5Fz1SVp2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:14:51 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154091; x=1647746092; bh=8IJQAYYmg8RPwzlvei
        qyKuKOi4pmaoiH3Uli4OVOdwo=; b=lITQAkYSotqSaXMsepawRqyhOZLl7aixLf
        BibxfajQnyXymcj2LGotNzPj+AxGP+ssL+BM6Nar3nthnT0mdd8vl6OzSFecr9PW
        4Ftdn+y25YkBgl/j8VBuO5vvBqnFo+xCWg5phTff8SnAcJO1+GBIbQKWpSKVJ6Za
        wUwROjACiYbV17YaWtBSp99mQqWQz/K4XYofFj2zhcljKOcC9weY5te5bTxJzA7c
        00baGZH9gcGlCyaZccWhQ8Yx4S6WI3FfsDIEWlDeTfk7kZnaU+3xxtEdmHDDzHdm
        5xtwD/sSEQVWDuS5ePY/GRBwBQX0cmxqE2PMfOCPrfOSaNRPChoA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id KAzTsactANad for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:14:51 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0Gyf26Lqz1Rwrw;
        Thu, 17 Feb 2022 19:14:50 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 02/31] scsi: pm8001: Fix __iomem pointer use in pm8001_phy_control()
Date:   Fri, 18 Feb 2022 12:14:16 +0900
Message-Id: <20220218031445.548767-3-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Avoid the sparse warning "warning: cast removes address space '__iomem'
of expression" by declaring the qp pointer as "u32 __iomem *".
Accordingly, change the accesses to the qp array to use readl().

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
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

