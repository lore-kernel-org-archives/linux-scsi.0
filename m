Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C03C4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347715AbiBKHhZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:37:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347712AbiBKHhS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:18 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42171111C
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565034; x=1676101034;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=paa3TCfl6M+XAYMYGpNges4WtY+xxDK1wI5MkwlKq2o=;
  b=TxijJvBtEfM5bMYxp+qW1vVQvIj/kPMNViNt+GpFyYzOs+5DEfbMJ1gs
   +4ihXcvBtM9yuusZoYlpdP4QT02WxdVmByHKtvdjja9UJfclLFLtCPu24
   kb46174s1adVZUiwbyuNRm21+tASnw7toMCRzM6V14ZrOSnw6Z9TaNuyn
   qecWoa2GmYz9wfoC7dUeMvGvm1AyaVvXX84PUjszV3kB3qILxN/uJMscS
   8oYwMjQ2y5mz+bL0iwcScwk52FN/0d45KZDsHmbMtY4+EN10FuHoap4Yd
   oOSiUvTyMxAerlpBdWfEMMTqXpFoItmKCtB+cJSlmG5sWswpomA1PsaXz
   A==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675132"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:14 +0800
IronPort-SDR: rW0lbo979rH4V3elH8G/ZLmZd++Y6W5/SNmvOg6JVr9byQGQyv9zB659liLQvApLGckGS1unBv
 tNzZ9Fx8+UIC2dlmQyVjgH92RMMqloCwX85geJE6OWW54s0wJa6aLQ+VWuTAacBzLv9a/EGQei
 QttUGuzofrFGmZeDz17gg1vT6Z3ja+FyfEBk8fylnQ5OELyu91Kw0HuV21/aBp4dR9Z06cwCk9
 2INPv44GI+LAU7xLjQLAoB8K1pN+qIfefMAvDpw8zS2i70w8xlX7x6T+G4oCZhS4Uq9f05KXql
 6dyhg+qD4o9FhPAcdn+pL3ZK
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:09:02 -0800
IronPort-SDR: mzwCxsqR/JINgL2cuctR8zfPElVcmz0UNGgEWw0Gv5D12tUyMLYUvJfH4+p0NhUuu9Gb5qBVv5
 RISF9UsjSXY4G9jJigXj+CvnnBFrHGWmOeHmcPdTo6ITkpVW7IQf0tPwHx7DlN5hhlCmJDkop0
 gOXVdfBP0WJ8kkRQKuutH8ZAbnCJswQSag7A9dDXbUNqmHhcWe3ZGaMFH/3N6XtEKqhmDUaqm1
 Q3ewC1AeX6DTv/1dLJZlE+2pmF9v0S77HpxaM99mQuhHzGJyOdZQ6DP1cW5SZnJc8rH6U4r8Cw
 nk4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:16 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw56g5tfBz1SVny
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:15 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565035; x=1647157036; bh=paa3TCfl6M+XAYMYGp
        Nges4WtY+xxDK1wI5MkwlKq2o=; b=R37/TAcnagO6GYOUrVs/dfO/M0m7LVG8Qx
        /Kif3X/EODmab83MDhEXo0B5yIe1Omt+mUyThWI7dSD+BF78FZwg2Es+X0XH8o9P
        90EXgL0D9P3Ae5mENv4y4kK3ps12VYExwfIB6003GsXT5CqOO0aModBy7jkEO+0/
        u0NpmH2PXfpj6e28RaKybZb1En39kht3hBu1NXSFSMoLV+dAhLyoPMW6lyonrhx4
        1kKl1BHvogIBT/UFBTYVS3NMVJviZKHP/CkD018IYeS/FKKgUC5GEcm7h5IA+05G
        1s1pl7K9pzblb6JuXCD3sY2UO2Zsj0R6eH79KwEQbEu0p5GGsdcQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id hOyCdYqPzwyY for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:15 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw56f2zFhz1SHwl;
        Thu, 10 Feb 2022 23:37:14 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 07/24] scsi: pm8001: Fix command initialization in pm80XX_send_read_log()
Date:   Fri, 11 Feb 2022 16:36:47 +0900
Message-Id: <20220211073704.963993-8-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
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
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index 9ec310b795c3..d978f7226206 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1865,7 +1865,7 @@ static void pm8001_send_read_log(struct pm8001_hba_=
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
index 9d20f8009b89..ec6b970e05a1 100644
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

