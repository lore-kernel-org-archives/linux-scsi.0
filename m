Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C5BC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243373AbiBTDTD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:19:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241170AbiBTDS4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:18:56 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4EE8340D2
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327115; x=1676863115;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+9fKbn8w8UkJ7eV+ZqVWq14jYorsWkfFH+qUx4KFby0=;
  b=FKqG6mOSQjvH9iFZRvl43ksYNUu5hRQf/iHWuilRyLHTJCKBw3j8nBAP
   oPNbC+1GnRVSxcWSuZVG1zSa+P1qvaPqbqYj9quZPbz6zL/47yTEdtaSx
   ltAS324bXiValTSrTBj/jffpHQK9byZlgHQg6PK+LXV9Oqrq7jU9REDJI
   idyQ78Ya1MDwH3+xYn4aJHkCIyZZDYnKVTbTuDq3R+xvIf15lok8rkkGG
   r5JGTlmXm9ibXHtpxcWUAX8nsGYdPgZHC1i6AqTW0LxGQyCWtFPOC1C03
   RnlsJTH/lehTBVPw9BX9tgkhecAwiXbwq1glUAGa0v+PJJdEPk0h2H1Li
   w==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405776"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:35 +0800
IronPort-SDR: Y/Rkh6kCueeraGzObAD9alTb7h6VpknEGCgv8mx1dteot7xxDbOumoe0RXHFqGU6ksOTfL7rK8
 /Iw2EXfWSYAXonN8hEahfGRlZ5y+bNiOU07e4Tj5v1czyX+YTD51C0EUAYSwIfvWBH/L/1Hydx
 MOUEdqI3ZyM0OynmzfKh/c3zwYyoUHoQBzfrDjxJ75xTgITEnz1yG3vXJt4AqJLovxGgaO5bSv
 t9ss3ND1YmaY3l9p1tg7butzQWkrepx5QMQGvpJpE6GYUlEJaI+kuyYhRT+lTdV+fo0M1J7r9r
 CRDXZMCbGfAYBuMZASRuKUoJ
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:50:12 -0800
IronPort-SDR: np/i3tZG+n4jmcSCLwikxzth/CBZRw7cMRe3CK4NFQpegjU7h+ytYQu9l2/b2MLPVvvdcUYsjF
 0JluPulbmsOSiN9QtkQcDwn+UXuQnCXqU/3Ltja39h9wZijyPaZ1bJnesdd1GvfM9dLIQts5bK
 y131mqhAXP7EaxnHBXGLiUp6mkmyy0B9aBw9FirCIMnfA/NBBH1oZlcQ628n5AxE74wd82yJp3
 bKiPa5/yQOUNapypW+gZgHWAaDVUjvTu74mCJ9lv1L9CSmtL1S2xxeaKLfvcYuPn1BJbs1vdeG
 tZA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:37 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1Vy42LTgz1SVp3
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:36 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327115; x=1647919116; bh=+9fKbn8w8UkJ7eV+Zq
        VWq14jYorsWkfFH+qUx4KFby0=; b=AgHzIWuji9XarDOHGqHmsyZSEH/IVufdA7
        pOrHMa3BbnDSVAifMiLfmoGLfDSgvWczZEYtOTLFQI5A267DslldUyDEYtoE1aXF
        ITBXXXEgpMqjmN6z/guyB5dycVBeYqLG1jcT2yZVCzykkMPC57QdaBqQxBoISfIU
        dhhJSRkqGqs08XD5KxG2eV+sJXWGgaA+TSST/gnJGxXLiVfpNEmr2JSybEYtubrd
        szZ5riwKhPiTOdISshFH2v/pvCKEVRuLnZSOlCbj44lTNJ6PNYKi518h1NmEz420
        2EiwvXApQZde20j4tEf1fls/I4Bvd/lEUPFr7rt/ndKkr0MkAPXw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id L50bCx4XFiKf for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:35 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1Vy2564fz1Rwrw;
        Sat, 19 Feb 2022 19:18:34 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 15/31] scsi: pm8001: Fix NCQ NON DATA command completion handling
Date:   Sun, 20 Feb 2022 12:17:54 +0900
Message-Id: <20220220031810.738362-16-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
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
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 3 ++-
 drivers/scsi/pm8001/pm80xx_hwi.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index c680baa5ef24..35eda16a2743 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2415,7 +2415,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_=
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
index 3deb89b11d2f..ac2178a13e4c 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2507,7 +2507,8 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_=
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

