Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56002C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:15:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbiBRDPq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:15:46 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbiBRDP0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:26 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA93A1AD284
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154111; x=1676690111;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AtXsP68DA8SivwT19RlpE3NM6EAI2vFseddiKDScx9A=;
  b=ca3c7+/piZBcuiC4rqAcLjXk/Pte14UfiCOZixHiuUY6C4KXw9QSw578
   LdF+LWdrzbc/fe2Q5wzGDYzLLU4az15SC5fOZ+xerEw/1hxfnrX6EIjSx
   Y8DZCx0Pkk2ZjLhELDDED6C4WV/KYS1RJPh4JltytFXEUcUsSR/vB4tfg
   Ne8mBmyoCXxl+wOScdKBTABmgXLXp7aqMYpwN+pakjqU4y+qZYNsywU88
   1+HKeaE1uHSAv4c73gwRkidgDJZwj5n+Q3LaNt/bz5W9eW530hpyDAWrn
   fglDr4vcd78A2IbghyiLlmt/aA23z26kH/2nBfiezsIOEmnzqUrbV8sU6
   g==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="194225795"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:15:11 +0800
IronPort-SDR: f6hnrWsrWAYKC+Bg9E8wKKYFKZ6QxRVUDnedSgtXX+iAKr1Y2aYuCOapTOE3wOb/+lbTfTYbdu
 IwNUk96nskedVvVZnDH9R4gGxhXryxrC1qxKOl/axIx1wzm5JbIlGQkE5R7zahoip9WRDJrsBQ
 kcgmUAC3zvOGLus5h/VY3vqaXbeqdCeAu3K8c2IYFrmJ60AK127mjp/Dk1ZNpuiYJS9XqXsbyT
 iY9/maFhaEejx3y9rWZMb7keQCz2mMqSpUzg2gP+I5i0Ve4x/9NQYCJfWr1kRrRVoOgrGDMoV2
 5b90GRV7NY4Xbr0QFrm6oKvo
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:46:48 -0800
IronPort-SDR: 1hiGmmSpsF+PIFcZP754yWwkc/VaiOHpEHaDsG+d4Sula4YFrhCwJSI5B7OUMizSXb1RcNZo1r
 2M6HLDeSjTr1zUXJqaEG32T2DLAKgRmwt4xQWEXzQF4iv3kpNtv06xShneU6S+Ws4madGNZ9gu
 y2kmwkKsK2F/F9UPSaprwaLekdY/AmNsL54mTn97ZFOdt7jElAzwi8buN97id3jwMVAvCfUrUY
 tMinYnuq9LgSWt+nC7SxRKAYMQisyH01kBQB0gIU3qI5k7hLurHprME6uNLnSFCZIu0rYEQyn+
 wUY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:15:10 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0Gz170crz1SVp5
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:09 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154109; x=1647746110; bh=AtXsP68DA8SivwT19R
        lpE3NM6EAI2vFseddiKDScx9A=; b=GFL9GDSB7dB03/BLX+8rQnogbsQ5EbZgHz
        ceMbbXs4MQ3ewQ9/JU/L3Lkjny1G8n1HXWYKg1bOep2ZbUxx7R6tEtTNAvELTrxU
        Z3eB3ehLnOJTFUmwljeDZOwLZ0ZmHaFR5wnI/SmsZU1vzw8Ct4xnR8r6rYwE6Mcl
        yU/895jwTRRagx6Ze9BSQVifhZxAMaaImvGqjCwIGJbz93egurQTzt+fOkydmKMs
        MJa5fnk1O4tcFf3SWW/zJzQsz+I8UcK9khK7cucmuzYpqQ+iPeWofBy0jo7obSQE
        g4oUIC8bqOoze2XNoDdxfy6dotBru0vVBjRXIH9r/T/fZJD77DAA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id TsxxIKf0zYBt for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:15:09 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0Gz02mr2z1Rwrw;
        Thu, 17 Feb 2022 19:15:08 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 15/31] scsi: pm8001: Fix NCQ NON DATA command completion handling
Date:   Fri, 18 Feb 2022 12:14:29 +0900
Message-Id: <20220218031445.548767-16-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
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
index c0215a35a7b5..8149cc0d1ecd 100644
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

