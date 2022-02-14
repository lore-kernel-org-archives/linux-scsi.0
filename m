Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC86C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239303AbiBNCUQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:20:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239306AbiBNCUH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:20:07 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C5AF54FA0
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805199; x=1676341199;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=/y3raaEYqVXYgjRW12cIVzd6Yqgw6SYmQ8gCxfOl3Us=;
  b=ZaKa4vWIyGPYlIm6q700Eqp2vKMR7kIZ2Ayu8pOl9k+dNRWG9q+OGimX
   nsxem2CIeHs5d4T06D/z/Lb5XsvZimu9lSTTdVb/T7c8UJo4d0scZtnG6
   AKzUbebZw0Kz1pxnuIkRvpPgmTC8jWsMUkf59xKyDq76p1ssC55cYOKN5
   FGuHdt9ZYTvRSipteoAxsTU2Iov+FS+XtEWfse1zVyfiQJmcom3+NVh3r
   Y7O1rp6y3RXa57R0AdKo3ZVctXdcovSODGIiL7TNGru65gj54GYzqQXTZ
   qjSXc+qEPu+Uuy0SeUgXgKRa4ermtA6REFEX0nKsvs9aNjgzQgofXnbaZ
   A==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819809"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:19:58 +0800
IronPort-SDR: JIZSlp/ChvD1ZIBTK9crvVEaPQyzDRKVuCE0efaCZKFsqsTxhrpopnu19OICqb1HBZrgDMxDjS
 djSRFeNy7VjdK8/quKkO+yuWqLNrZCJs95KXzei58yV+PxojJlLywR9f6JFNBV/QS0bDk0C/8h
 dCT/u0j4LxP0pP0/af70e0YEEchF/5dWyXdAhYonfm8e1OJsQIIvQKC1fRR38MG+/73taauX8i
 yCxp7w3AVDqiOh/d54P+5b7NlepXudPD9/XbBfTH0IGz/4kJ7HH9GFylXOmzqTk8DWHKkTYp7p
 oKMza6zasjuP6vVsYKzqdqKD
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:51 -0800
IronPort-SDR: goEhiIabWMu5iOOA9sdnGpLWAjuzF9X8XVu4XzIytPlx87MxXTWUojc5JfBiUFEG1rSOOrKBKN
 H6EU3z1gIZLN5I8ZHoP6ej5SqbEephfaIvY1r1Vv+NQfPlj7HzH0ToQI6STVrcsaLLRL/LYZdK
 dG/cllZOwweQIATEpiEzLJadvktgqZEtG8tcIZYmPw0xmQMEyYaaU4JWDBkFYYU91VeWoyFejY
 dSmlYrOV7JprCztnvRjEjECv+N3sFtI5mjgFRBHH7Z2+EjjNq7M2nedZPmXrVJbYJN12sAxUcL
 u/g=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:20:00 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JxnxD0XFFz1SVp2
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:20:00 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805199; x=1647397200; bh=/y3raaEYqVXYgjRW12
        cIVzd6Yqgw6SYmQ8gCxfOl3Us=; b=fykqWdPTYGC89c+x43OR1+a8o8/V3twBx3
        2njBgdnGw4mqOatdgZ8f4Qd6JMcrSklTZ3Mdvloey6Z8lVj3n+zUyj8oRIt0RHIj
        ZeIXh/cLZOCfuunyIUzHzF4MH3/0J4d+VRjB2zKcZJ4zTAXRFCyViwD+Db1zm/+0
        gUmWuTaOgnHMW1a46a489k4BROx/tLIincyyHiMIgvvPTvQFZJI+vjVr1+HqKodw
        TGLJzcBQw/nWD8RrdEXevmTRkR6GoeaH+luoo9B0/KvY436aK+a2x/iVxWQEpeDv
        GryNS7ITXIOfm0jYu3FYUx0zmE2OyimItY+NRCp3scc4yMB8oMgg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id r2__3bZLkO2x for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:19:59 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JxnxB5jVMz1Rwrw;
        Sun, 13 Feb 2022 18:19:58 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 23/31] scsi: pm8001: fix memory leak in pm8001_chip_fw_flash_update_req()
Date:   Mon, 14 Feb 2022 11:17:39 +0900
Message-Id: <20220214021747.4976-24-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In pm8001_chip_fw_flash_update_build(), if
pm8001_chip_fw_flash_update_build() fails, the struct fw_control_ex
allocated must be freed.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index 2eff6e2f6cf9..978b1bd60334 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4890,8 +4890,10 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_=
info *pm8001_ha,
 	ccb->ccb_tag =3D tag;
 	rc =3D pm8001_chip_fw_flash_update_build(pm8001_ha, &flash_update_info,
 		tag);
-	if (rc)
+	if (rc) {
+		kfree(fw_control_context);
 		pm8001_tag_free(pm8001_ha, tag);
+	}
=20
 	return rc;
 }
--=20
2.34.1

