Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 615CFC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 11:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241135AbiBJLmf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:42:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241123AbiBJLmb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 06:42:31 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7111026
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644493353; x=1676029353;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=CeJzPK5/WkuMI+dI7emyt1AUY4copPziRAwmpxYlnw0=;
  b=qAFQjA3pUQv+U91R4hHmsHz7vaOZR3/KBq+xqNIL1RV1euiALm0rRfU7
   gICP0wGLDGPMgv0mg4/8b2YVEfYSGQxkQyEuwi6s1ePGMHF8ZseAqhzeS
   VnvYcmvY12FIlyoflLhsIXEJkSEh8MnCNO2/ZjNaVxXhJgGQM8U6tmHb1
   wib2mny6zjn/HujWr8JYXEc6JbQpnayUt+pV5ObNmA/0gAtZ9BhYTLy/P
   95dSq8kc5bAv4twYrQAG1quqG7bG0IABENUD37zJoY376u5T7watq6Hhz
   Yb8W5cxg8OGuErg2zoWty6hK66zUqCv/oUV2+ucPCO2zx/YmmFESTmJV0
   w==;
X-IronPort-AV: E=Sophos;i="5.88,358,1635177600"; 
   d="scan'208";a="193575634"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 19:42:33 +0800
IronPort-SDR: ekeE9Iku9B+sR2PJAL7LRezJpxXwErsdpxm5KTosuRg7B8srxmGtOzAyIoUJ9IbeFLkGWTjj2B
 fH9aSZilI9AjUlK02SzNnykeFRPpCtNXCVqSDAS2NGOsQ/9eAgpmh01z4P+P8kXmnFDiwvezUf
 RkiURmJo2d+rn2cO9Eazf7M8RjH8OPg7rwaf7P7l0VFKw+NTHj9XfPVYYtizUC59nVZnZmdamJ
 OCdl7X2Nnoli7ICREx3K3A0WSPU+Wq97QZ/7388kTEUM7zkvVNf9Hf0URo7f3KJFJRF9LAMOmB
 lYRQoMcVCjWgIz/fZ2+gK4Yc
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:15:29 -0800
IronPort-SDR: N+gTWQIGA3lUGy4GybPtMXjE975PmqRCR2pCcbfeCdnQShfGni21yPJdEsO0LsWy8+a/niXG2j
 m19BLNIBJWObanoYTJuspyGqlTYJYZy5i2lYB6/Ifwd/myBbLwxIl2t7K0nfJ3XyxpygFsHFIw
 MsCw/rbbrp9PBwsLVppgfvyF6/1hkMsKWSe45ZLESc9R1T9qJL+rwPn6li4WRIgVZ6FIivg34t
 ikbTKWuCzr6o7OnRTZR+fuaYCLVaT2m4RfFYkxfhrzvMS98hD/EVLFTcM2+4CkN156VSMvnz7i
 3UM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:42:33 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvZc81NwDz1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:32 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644493351; x=1647085352; bh=CeJzPK5/WkuMI+dI7e
        myt1AUY4copPziRAwmpxYlnw0=; b=AtNUDNF2Ihl7MO7wpfwRg2KUL5VxHOgXVm
        XsIfUuBZo7nv+HyvEztaQrzYUfpUjIqaChbrihk7ZdLn1kizJy7nihimXBoWCoG0
        nZ0ZNSXiXUlGU9lw5lO08fWNdVTzAVvK6l5SyGnxN4HTtIA8Wky7oVriBYZoE8ok
        nGaYyI0s2qeZAQoIPfNtQmg/ByZcW2WvK+GxvaxZhOH4Rg76LBE5lsC8GOfCvwCD
        F+K6IgDtxQMfpW7YeSYD9zEOJtvk11ioYyfhT3SJTxe+YjDFszNsy0sMAW2v8IxA
        NPePM8rRGpINHBukSCZ82JRO2Luu+DKa3d6cxRQ6gfM4551EPa6g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id MsTMR85-TzfD for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 03:42:31 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvZc65qZ5z1SHwl;
        Thu, 10 Feb 2022 03:42:30 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH 07/20] scsi: pm8001: Fix command initialization in pm80XX_send_read_log()
Date:   Thu, 10 Feb 2022 20:42:05 +0900
Message-Id: <20220210114218.632725-8-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
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

