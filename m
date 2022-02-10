Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F4B4C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 11:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241084AbiBJLnB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:43:01 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241154AbiBJLmp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 06:42:45 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E444C1019
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644493367; x=1676029367;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=q29mMJqlbDLunlNIuDMRbjAb6cPg/7LfvEGK91gjkoQ=;
  b=F8v7vvlr1jtQ5/4K/yVlStHg9GPyjo7KRJEnD6Imlf/2o7RGZ01VjIPb
   Af8mdPe0Ea20jGwld1VnAli8V4T/1GYMsfPEE297UcGVWiAV2o7H+TbBX
   SzZzYueb+tLWDBOXiYfayguAG/d646avwIXSCZyZ4k+ukDlce0yhmK6I3
   ED5D7CBGbkuoLEEa7BBt92LFQefT9EmiKdtmatmmRYh3ABWnx4qV01bnw
   W3k0Q9OD2vaIf3qQL3tEeSaeXQTfiglgHV0s3pHkKWgTYY2MbanCg7Uoy
   LI+pm66aDN/ZH0dBJWSZu/aRsAT26CY806zLvFV1Jta/6Yxvna7A9R4uu
   g==;
X-IronPort-AV: E=Sophos;i="5.88,358,1635177600"; 
   d="scan'208";a="193575665"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 19:42:47 +0800
IronPort-SDR: f7Sc/hwBlP1qBRI8SQeQJAytklw/MsOzyyc9V+3u1iNFMOZGpnCN/7AL+jaxdawfr34jSyLz9b
 JfhdW82OuyB9YNTn8FKw8M7KLYU8RL2QtZnMU2Dbb18s1sdljlSj4h+gQugl1OUz+bf56upUHI
 rwic7XnIbXHFpCrm5Q4/AA2bil+0jqxpb6geCEtXDCdzfrN/f2KoRR4qkRux1NIjpC+7sYPi+r
 uhjptALafCegkCKjTEHuEiPojXUrza1dEfDCOBxRl7dru/iIT1s7/TJjIGKQb+a2DVVJ7fRGRd
 qCDj+XhXTUk6bDQcokuy8iNd
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:15:43 -0800
IronPort-SDR: qSKaA2RuqO/yfxwLRQdYsvZqxSXRN1NccyI+upChv8M79ZtWUIlHcHDBr40GZYE1sqTW9wMcA4
 CXXN1O2bc9mL/TwyR70a5rIhjEcBjZflJB9zmhTik2zLtylbdOznMoQ0ftmbhTa/0oGJq8IJn4
 kYJwBdXfHiDmXNba0ixYfPu6priJGkXrUeE8iiGEZg0wVGc/1EH9Y0fkMPALC104Vy3JG97zYo
 NNZWzyJBnChitEA14rNS9Z+eKztFoe2WrGGdzNBAsM559p2lxSiG8T7rT79ZxDnWalv5vqx6CY
 LCc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:42:47 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvZcQ3kBcz1SVny
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:46 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644493366; x=1647085367; bh=q29mMJqlbDLunlNIuD
        MRbjAb6cPg/7LfvEGK91gjkoQ=; b=UOwD3gqHVpke8O4siGF+E+CWKKt6+US6rx
        7r9VZpzQzk4arrLRYX/MtOxlRp2wB+qgj/KPXizpkHjxMNAHhxBw08anwRpweQvD
        VmzuKKVza6GvSY1wjnaeUvjik2Wkcf/N40ueINvCWfPMpFsmVyuAFuGE3qVjD8g+
        WGxMoHDz9eO9SeQOfuJpHbT6k1AF6FREANOLwm2vLK5ACEMGY3CSdnnMwafA2XqV
        cZCdJoeJMZB7vxTetJvaSCiwqKwVBlCsl5lDfgb5mlC9wpNUM3mDC6Zg0q4/wOKD
        4XaGRhrLfIZ4Fw+S4T5X58uL6HyplyOMQ7M8qPRoyaZOWPiejJ2w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id xYAFKWVTL-y5 for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 03:42:46 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvZcP11w3z1SHwl;
        Thu, 10 Feb 2022 03:42:44 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH 18/20] scsi: pm8001: fix NCQ NON DATA command completion handling
Date:   Thu, 10 Feb 2022 20:42:16 +0900
Message-Id: <20220210114218.632725-19-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

NCQ NON DATA is an NCQ command with the DMA_NONE DMA direction and so a
register-device-to-host-FIS response is expected for it.

However, for an IO_SUCCESS case, mpi_sata_completion() expects a
set-device-bits-FIS for any ata task with an use_ncq field true, which
includes NCQ NON DATA commands.

Fix this to correctly treat NCQ NON DATA commands as non-data by also
testing for the DMA_NONE DMA direction.

Fixes: dbf9bfe61571 ("[SCSI] pm8001: add SAS/SATA HBA driver")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 3 ++-
 drivers/scsi/pm8001/pm80xx_hwi.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index 9d982eb970fe..8095eb0b04f7 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2418,7 +2418,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_=
ha, void *piomb)
 				len =3D sizeof(struct pio_setup_fis);
 				pm8001_dbg(pm8001_ha, IO,
 					   "PIO read len =3D %d\n", len);
-			} else if (t->ata_task.use_ncq) {
+			} else if (t->ata_task.use_ncq &&
+				   t->data_dir !=3D DMA_NONE) {
 				len =3D sizeof(struct set_dev_bits_fis);
 				pm8001_dbg(pm8001_ha, IO, "FPDMA len =3D %d\n",
 					   len);
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 44071a97d23b..4d88c0dbcefc 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2510,7 +2510,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_=
ha,
 				len =3D sizeof(struct pio_setup_fis);
 				pm8001_dbg(pm8001_ha, IO,
 					   "PIO read len =3D %d\n", len);
-			} else if (t->ata_task.use_ncq) {
+			} else if (t->ata_task.use_ncq &&
+				   t->data_dir !=3D DMA_NONE) {
 				len =3D sizeof(struct set_dev_bits_fis);
 				pm8001_dbg(pm8001_ha, IO, "FPDMA len =3D %d\n",
 					   len);
--=20
2.34.1

