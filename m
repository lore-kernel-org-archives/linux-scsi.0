Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF7FC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240767AbiBQNap (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:30:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240927AbiBQNal (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:41 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8200B2AF900
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104621; x=1676640621;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I0yWM4Uw/bytOgd0fDYDX3YttfdAB2/YpBuXlQAFqBM=;
  b=oiZTPZwctCfmLMETwQn8BPagBedFG/GfVnXHiPQ+8KspAbEK9zLH2Ku7
   M/h570XeOIZ8zy8wabhqRs+KOCUokYS7PxR/I540yl6uqjy2VqsZLxBG4
   75GwXvyn605rFcM9jQdIfJ1nqcEUf7eFdcain8CdlrOaLOEod/e+kOMh2
   ckYKka/J8HNdThs0QXGDTdqzRuWGEXF8bzjenRfiZsfs5bFQOXoGxsj43
   zZYZUsMHCCvHcyrf3HuInhcxfcZ5FdExXfgBKFMioMeL94fDX58OutG4Q
   wtBtJLufEEZT/5uJ6/51QmhoeW4opg7WqyTlQGaS79R2vSjOFrBK8a54I
   A==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303187"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:21 +0800
IronPort-SDR: kbi8oerXJboVx9lKL3sV5EqZoe6yqm2Frakab64DWyKRr4IwBhZr1/yr0AqokGmlt5Abcjd8Aw
 6nZGqbSpY1N20w1RXN/PWBooWryCt4B+FBx8aHEF7Lo4cSui7YbbQtrfrh8FkMfQKZt9iqCiHf
 hxobWnhr3zrQ2WjRTgT2WGnwC3yvflX93lfFtgmR1/ZTgWHRnBZAqKYT+JhChLGcoMmF+71Cl5
 HCNaJmz+0S9/bwznv/u8GQMEt6cRxIp7X2ti7ewv9S03+j2VTTmD97tgmmbjqqJiZ9/jLr6zQw
 0kCR8p2hRZTx5fEnn89lqsf+
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:02:00 -0800
IronPort-SDR: wAM11K86sFBVR8CydEsi/baBvCraI6Qxj2LKqiC9iDIgel3BqIDZMqBJ68F1opYC+tP2tG6QQN
 Wf9/edIIJWVqOJjCD93XwigV9Sl7bOS1AjSghqZVnohdkrP8Y7dhRqe3H8oQ1BTO4Og5JtdzoR
 KewZ0efeUxH9pJXup0vdVDxsfDmOwvesX4X9xHQzp3hXV/u0nxLGVDzrWHhy5Vk71LspoVejwA
 pl3R6NyaAWQX1aBHQj694M7g6jsHsbFQbwkUT5CZWA6EB4bBhKNudqtWSeHWPLgPXbttMn+juZ
 k4Q=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:22 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JzwgK0wyMz1SVp2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:21 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104620; x=1647696621; bh=I0yWM4Uw/bytOgd0fD
        YDX3YttfdAB2/YpBuXlQAFqBM=; b=d0CvfOj3VYJ8+FZxuhWQhGC6x/3+W6EO3P
        D0yHgyhakshKx0mHlszDb+cYFfTHqpv6T8j54zypCOgK/avrURTJ+BTzIzAO3HYC
        udzeuxCiDtT8bV+erixqF9fN574AejrKluqUBEi0XEB36YZwGF24iWJlSYgUXptf
        c1IKjbrkv/FHkWTDYZGJ9iTrBLurSakXP+S6qGM4U0WNf9ddLE+cym4kTs8TrJ2O
        a4ZPqIb620MR6Pr8/lqSIQtxZw48Qi1rhHPdg2/KN6uQlmdagOVLtTd3cu/PISfX
        WreWSYas2rEeRcXo6vtCP+nCdvxXmp9n/9H/++6EsQN12Y4OfSnQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 36wbF907_IOM for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:20 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JzwgH3TGbz1Rwrw;
        Thu, 17 Feb 2022 05:30:19 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 15/31] scsi: pm8001: Fix NCQ NON DATA command completion handling
Date:   Thu, 17 Feb 2022 22:29:40 +0900
Message-Id: <20220217132956.484818-16-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
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

