Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CC4EC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238471AbiBTDSr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:18:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233859AbiBTDSl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:18:41 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BDA7340D1
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327099; x=1676863099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7ywyhY05CndcdCJ1fh6/B5S14WqsyWHdIQgte1owJ9Q=;
  b=c3T6CTdaZT0SMDZFgZn5hNhq5Yfw3XX2WenKH8393EIL2gXuL92enRls
   2h8kbfrHLrnIGl1hwGa2Z8jcOxKJKiiUUr/Vaw8bTWIyQbzh90JtphOa7
   KTrWaCYSggVdVjrjwKdq182yq+Y3diDJZDdPwcqlGLcK4LrAjv8L0fzcl
   fQ4vipmkOMliRxtNHIdRKvUKZQYjg90rek4FQpMm6ganiWxxsdBY4ACUI
   R0lXMxX0O9JceUBOtYqWBV+b2cKyVRFjJIVZqTMFbVXsdu9ktW7JXFaJ1
   ugYpWlbZuCy/q1whQFaFikzL9BepJHQ7j3kD07A+js4t8imqpmE3+NgFv
   g==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405736"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:19 +0800
IronPort-SDR: d/EzlWCg8O6W+9hhgufckSmxK2BnJldVU0dGkYrZYyXjOeeqXzBBN8cyzAd0YnTJJGvwuQi+CV
 WYJY3Cm5ps3/C1bvtT/P1SrP05878TOTES0D7i8cQwsFFDxMpnS8ufBUShPPBQPcK+dHRRCfJ5
 cEzpMmAcwYfdvCPTywLSNL0+m9r4SYwuSXFeme8zA7a2gUb9os1QRZictNlHia1pRsoE7PrAfo
 pmWTZescRfDnwcNO9wBiO3LOImQme9XHpymmw/w7kVcfbYdMnjVl32wNsMkPZCfuVZxl0yGUC6
 ohGewE7hyZdCmJSjZh64gWoF
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:49:56 -0800
IronPort-SDR: 7wLvpCkUJC2BZKSQE6yykrxgiYqMg04pmECerH2wuExZYhkSSi8jnaJIuddNpP7bA5Q9pYd2QZ
 d4m/RI1Y2mS3L/eWQ6U2DttTe9yBYFp5r/O/Mkv9KLqCvnSsegNY40vDPcu00bB7evS6Z6QrcG
 IOtH7MgEZ6yXybPCuiqG4y2OmGESVM1FLMgqltrdVc6+leHUy6KxqKEPuB0oorUvXt9DEKhkqg
 HbwIZYA9HXLQlF0EjVzZJaGqUzOvccL5H/rXXceMnRPz3dNBEEpAPjFp1YReH+goCcPU2IZ0Zk
 s48=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:21 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1Vxm3mtkz1SVp1
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:20 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327100; x=1647919101; bh=7ywyhY05CndcdCJ1fh
        6/B5S14WqsyWHdIQgte1owJ9Q=; b=WIjVcczMEZ8nVXU2C9lf8nuHnpPFlVfoNO
        n54Iypk+M5XbfwuqaqFOHoOlSBMHhyKdbJFUvyOLxXLW7DhaoFwziTqReFKVRA//
        5DmmWVZt+WDc+DLUlA0kqtH0ad/94V7PJEopbwa6jg7DN/Z9OJe+4V/YGo7ZkpoY
        jBX4n8SU1um2bWafCsmTuUaPZGgJpj8E/7hHESc5pS/bMqSiO4b1TNeqWT8J92/Y
        xe/LwaIA6fYGCi+dsbUmBBnkrKcQVf6JV6bpJ8gZIOTUO1pQ5lMOBAy3PYjUEaCX
        DA4zawLixQLCgg5fBKhADVLLV+gNcwPPN70zaNAF5vfwcePC1DOQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id qaMzj-hUVEHS for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:20 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1Vxk6pdGz1Rvlx;
        Sat, 19 Feb 2022 19:18:18 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 04/31] scsi: pm8001: Fix command initialization in pm80XX_send_read_log()
Date:   Sun, 20 Feb 2022 12:17:43 +0900
Message-Id: <20220220031810.738362-5-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
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
index 575c6ecfdce3..dab75b481618 100644
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

