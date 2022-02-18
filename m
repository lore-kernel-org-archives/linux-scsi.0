Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0382CC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbiBRDPP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:15:15 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiBRDPK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:10 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1CEE6DB8
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154095; x=1676690095;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hIyOX+6jIqSb2Fpc+Y+ejgZhw2rZ7ZNLwrTdrjMSzOw=;
  b=O3yZegk642P6FT2KsdtEN3AmubYAM8tItjzFOrtvPSJgZyNQa0BLJEjo
   xPKsDS6EAGo8jrNWXL9gDaUixhsEy7MmG9WGPs9glq76czZhNBcP/ZApc
   ElcScsXOBgSi+umhvl1wyY/Un8dC5Vfe34moLZqO576/xHvkDSWbYqSkC
   9D+i0ec5AuBNMP+zU8VrOb2bsdgPFQvRU50IhpRC5rLYYyi6xPipkprcR
   Fqybc/oYzCR1v7hI4Y8fIQrHRE8bHgwhISGr+TlXQzruOSbac802ceSjG
   UDd5oQGVpN6YzsC5Sc8XK+XWeKuOAiOXlq6wkK61HemPv+1FTx2/fGL+Z
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="194225712"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:14:55 +0800
IronPort-SDR: AKzBVorCRPjINbfvkptrirpWgq1vNXb5yrTTp+lJJ6K5Tc7Cuapc3vNYZd9tUaMRULk+1h/ouZ
 ZZHBq7S71QXYb7xApD0HUoHSy/Iepa9yNu1+CdeljxdwkppnwegY2IDp3dAMk4z/DL/0wGPYiy
 RaiLeuLVZj2HWQ8fRuBp4IuQO39ln+UyAtJmW0Zt2sgXhppXrQUQURA4DFSKYWhhOlMBuJe/Sr
 JdJ6+64VRJyHE2bcYlSe6/iDO2sB6T4AcG3RyztWHO+KUMRDckcdwSprhG4cXn2HI2VasJhJNS
 bTr46Uf1vm1gCWN3+mniLAp9
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:46:32 -0800
IronPort-SDR: UL11W49RZqPZvQBg8MlcLaFBzww+LZiQ13SsLVcgxy4UjUQH/usdl9l8jDyMHdq7U/uIN7Tng3
 z/VFKhlaz2mF//CjDVjuCOz5SpIyWZmYrXQoDlt2pDEleXwqZFWA7yXCiIJJyswCZT+WXDBJLp
 0X1AnDTh37JO7ZZLaQgUDHnhWH+l+vgs057LwbsJ4Py75agNQvuLFxLQkHHa+3CnCdLfq+Egiu
 x5WfApmFI5DjsSgnI5Ib+CMSAtNSGWd8MNF3dSqnK11+8dpiofrUWhffEwvgr0g0eSXT+SU9U/
 h5k=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:14:54 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0Gyk37LTz1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:14:54 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154093; x=1647746094; bh=hIyOX+6jIqSb2Fpc+Y
        +ejgZhw2rZ7ZNLwrTdrjMSzOw=; b=Evshxea/vlBhQBHNxtfECc+mxBf3owLID3
        euHa6DHJlW5UwNxkx5cYnrOFLz+lOEg/aUvEagiXF4bR/ZNW23btWtuWKbtd3w7A
        uwkudw8PYiLOY9EOUR36B+G2/EzTlbvKsfIMj9CZyDgTcRwlFLcEU8DgcqqnHmYc
        VsvYYHzbTP/N2FLPSjc9M4e7yeTu96q0Mycf8FekqPT9w9VvBk2GEfmH/kcEIsAj
        mkGh7K6WnI9Jb+ReD+wwzYedXaKy6cneI36UMQKgnbQ0bSn+gXIBUiFOLfXjdV8T
        JxKjisPH69V9I5UaOoJMJxRa2dTx6eemPdhxvqNAr37YWLuOac6g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id JrzMiupjKodJ for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:14:53 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0Gyh6RbPz1Rwrw;
        Thu, 17 Feb 2022 19:14:52 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 04/31] scsi: pm8001: Fix command initialization in pm80XX_send_read_log()
Date:   Fri, 18 Feb 2022 12:14:18 +0900
Message-Id: <20220218031445.548767-5-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the sata_cmd struct is zeroed out before its fields are
initialized, there is no need for using "|=3D" to initialize the
ncqtag_atap_dir_m field. Using a standard assignment removes the sparse
warning:

warning: invalid assignment: |=3D

Also, since the ncqtag_atap_dir_m field has type __le32, use
cpu_to_le32() to generate the assigned value.

Fixes: c6b9ef5779c3 ("[SCSI] pm80xx: NCQ error handling changes")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index 4683fee87b84..817bba65feb3 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1864,7 +1864,7 @@ static void pm8001_send_read_log(struct pm8001_hba_=
info *pm8001_ha,
=20
 	sata_cmd.tag =3D cpu_to_le32(ccb_tag);
 	sata_cmd.device_id =3D cpu_to_le32(pm8001_ha_dev->device_id);
-	sata_cmd.ncqtag_atap_dir_m |=3D ((0x1 << 7) | (0x5 << 9));
+	sata_cmd.ncqtag_atap_dir_m =3D cpu_to_le32((0x1 << 7) | (0x5 << 9));
 	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
=20
 	res =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd,
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index b83500ef3d86..f1663a10693a 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1882,7 +1882,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_=
info *pm8001_ha,
=20
 	sata_cmd.tag =3D cpu_to_le32(ccb_tag);
 	sata_cmd.device_id =3D cpu_to_le32(pm8001_ha_dev->device_id);
-	sata_cmd.ncqtag_atap_dir_m_dad |=3D ((0x1 << 7) | (0x5 << 9));
+	sata_cmd.ncqtag_atap_dir_m_dad =3D cpu_to_le32(((0x1 << 7) | (0x5 << 9)=
));
 	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
=20
 	res =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd,
--=20
2.34.1

