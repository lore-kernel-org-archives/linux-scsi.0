Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E6ADC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240961AbiBQNbm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:31:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240960AbiBQNax (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:53 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEF22AF904
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104635; x=1676640635;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lIlYnltmhjd3cKqECKtBTm2hPz1j+eWYgrjEBXycxZI=;
  b=A+u9MaZhxzNjMhtofvWBQmWCJhTylJW9wePltX3V5m8Pirw8jf/U67VP
   irDOCJ1D1HFMQ08maztM5wL8EIs2jAe3y7OSR/X2+t310joUEr8H3prsz
   9Qat25Md6vGXWALy1Cm32dlzmpgl/AbyoETSLBZEXXXL4FSUoR094IgQB
   L3/vaXpiQL1Foo1dUgGjglgfbSkUq9CCPM9QR3CfGeyzBp/fucqRxIHAL
   B5zENHhcICjPp9guA0Bc2Gc3YIYtrV6bLhPe6zfM+QvRN1edkRC4NqoGQ
   8ZYpGUgXE+PVwuWfV8u1hFivkVT7jQjPt8B0zJhdOoNWZ974K/lJzaDXL
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303233"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:35 +0800
IronPort-SDR: hb3TVuZbh78CWkViChvaz9ISQ5IQr8MLp4HE5Ai+kytldZn8RNIfkjx3RfrecVFhSFV4/uMCYm
 WGHLbp9OYq/7e4Oun7siDPoSNheIS/wb6vPKgOdCRa0ZeZw8bpRsQuaaalGarHhXPc9msSBSSx
 +0uwngf20VYskbqapnFHPCSrWR61MFPUlTR7PLlPLbjUxyiSl+GnMU7HqOuS/kTn7Dxh0gUbil
 dHSO+aMk+uKWHHMqgycJ1OhspoInWk58kTAPBTU5GG62sOByg8+uTmQz+Oip9kleG9iTE31hCL
 E+NbmcwmVaQzW268LZgqfY7S
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:02:14 -0800
IronPort-SDR: UrwdDVayj9BFi23zrTuFbwID9/0+mTN98hpAmI0O515+RvsMgbcWfSIOh0y5bSK0tanStKYJZ+
 8KUSf7fnFKZSxchKx1ZxKdK0+RE9uIQAbF43JFAl83Ud+Hqu+FLS4viBT6Mf3YJix6zsLVOgA+
 GHBWT4tSe0I/7AYtojjMtpISG2dSW0Y6GBVBQd3w4q0wbZQkN9P1yo2LyUBX4AAQcuAYhq0XUG
 Y0X7mh12+AjHL4Yw/EBryyxSzJD4hmOPwRPgH9uGlCRp0FvoP9LPCPKpHnLnhzpHRO1qOe2ZE2
 0l8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:36 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jzwgb1P5Cz1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:35 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104634; x=1647696635; bh=lIlYnltmhjd3cKqECK
        tBTm2hPz1j+eWYgrjEBXycxZI=; b=JJNCKpSW4GuF33/VgJ/5GrLYYFF6ZbHI/z
        lPZ0DVg03hJev85xzBV9CX/WX1SrB5dzJZZVoPKtocW/WmlS9fRSIiw9injtDVqm
        Z3QAT7hmE7H85XPwHsgk3AArnIeKHSb2eUSyXvd3VIUKyp5iFeTbacuGCSy60jtO
        To+h3axW8/izlK+7HfnU1qC5Cf0NFif703BSK+09NvdlPJemzWhw0Ru6LuIOKoSU
        hXgz+ilEl00esjDC/jo+eapHY/dg88jXJRGW76X4PkVVhMUWKbb42k2Cv8PWFT6s
        ANowTywHiOkZ+iugxyx8XNVWzWGxzJ+u3c6AUIFlBZJz+HSkz+qw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 1h_1ud4UivyG for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:34 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JzwgY4XShz1Rwrw;
        Thu, 17 Feb 2022 05:30:33 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 25/31] scsi: pm8001: Simplify pm8001_get_ncq_tag()
Date:   Thu, 17 Feb 2022 22:29:50 +0900
Message-Id: <20220217132956.484818-26-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To detect if a command is NCQ, there is no need to test all possible NCQ
command codes. Instead, use ata_is_ncq() to test the command protocol.

Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
index 0440777a9135..1e60ad82635e 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -304,16 +304,12 @@ static int pm8001_task_prep_smp(struct pm8001_hba_i=
nfo *pm8001_ha,
 u32 pm8001_get_ncq_tag(struct sas_task *task, u32 *tag)
 {
 	struct ata_queued_cmd *qc =3D task->uldd_task;
-	if (qc) {
-		if (qc->tf.command =3D=3D ATA_CMD_FPDMA_WRITE ||
-		    qc->tf.command =3D=3D ATA_CMD_FPDMA_READ ||
-		    qc->tf.command =3D=3D ATA_CMD_FPDMA_RECV ||
-		    qc->tf.command =3D=3D ATA_CMD_FPDMA_SEND ||
-		    qc->tf.command =3D=3D ATA_CMD_NCQ_NON_DATA) {
-			*tag =3D qc->tag;
-			return 1;
-		}
+
+	if (qc && ata_is_ncq(qc->tf.protocol)) {
+		*tag =3D qc->tag;
+		return 1;
 	}
+
 	return 0;
 }
=20
--=20
2.34.1

