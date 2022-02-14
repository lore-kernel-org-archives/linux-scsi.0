Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D635BC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:20:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239345AbiBNCUO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:20:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239304AbiBNCUA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:20:00 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C1255493
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805188; x=1676341188;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=mAjreO3fKTJBiy5H8LkeQRjqGGc5QjmbGOA3kmDk7eQ=;
  b=L/YIi3l8V+pH+WIk2i9pIorgAcAyPxoNclcX8QbtTB/1uUsYG8GOP81C
   E6I8ITDGsq2PZUbCk8ElnVix7lWQImZPghknIZ9BikxzduSTwe2RUb4dW
   H0yJTU8PvqSFNnZvqneXM733HpXg+iOg0T9NR/xnyU5Lppx+YiklEvBOb
   dPabEvnhpKSvDylE4QKw2U2hSVMOSMw4hmGM/c6Pc4aLE2CLYegP5gTIu
   LKEG7X6x783YvL3TVZBjCZv4kVCO5/uAC+8dT/Bl1H5FXRK1510g3jQ8d
   tuqfCKYo0+bqDUh49+TPgPlJ3PU6PEiE8757WkWYVty+o0aBsA9H6Fnj5
   w==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819783"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:19:48 +0800
IronPort-SDR: DnS9ZeKV63XXSMqy8fv1URBtxXb+n50UXB/cUWcEnXgi9ZBhV+RHpCOcumb3Bqs005J1L1AdX9
 EU3N+vUjQvqcqDkTLMs5n/0fI8lkq6pugG65vOXQ5SdKL2ZIhQPG8jFReFRs31UuBKNSfG9lmV
 nCINzfuVfF9xuzXnSEvRyP/FfFD93B9ZdCyz1V2zNPEB8hwFNOJx9UF5sU6OhpB+nlC83YOP9M
 ie0oVFBuzKZ0hIpTx1hq9Y4ABUYJEquyjP+OZkhBANWyqhSoXIFjxhvdSImVDSfQ3GoOrHfPPv
 f1eI+ELvbise6hDmqrrbVI/u
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:41 -0800
IronPort-SDR: Bi9sBDjvomsvMPWt+2Zoql8pa6V6bP168awXD2/asu+iVovfzqVBjye5wPqM8RKOLOTjHvJgpj
 xJNnmksKhQyA0vbR93wyPByEDjXs3DF8CHNTQZa3NunWDh+T22AGs2JhTxjkVqt1hHdPUa+rBN
 do4U815RsCQthb+dbgEeNgcYlctWEM48/3S8se9aRVXv1wQzgfF+7w9S71BfEzXcIrscrzvZWo
 1Q9esOfR61dWTc6oW89mlw8G+xJuHLbWWIbw2yNRgxEBuh2o8o/fIQ35pS2J+LVUW1QCTSaxhV
 hZ4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:19:50 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jxnx15ZNHz1SVnx
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:49 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805189; x=1647397190; bh=mAjreO3fKTJBiy5H8L
        keQRjqGGc5QjmbGOA3kmDk7eQ=; b=GNZ/73MbkcMaC8rjAwSYiij1hbLEuYLyAd
        7FKG4zY7LgtfvqyvUqhYoU3jYwarMYyt25JnX1qmEElfj2jXNALKJhLV85gmLa6e
        /9OYGSvwG/w6G5S2vK8qZV5ge4nmwTbD0fje4ZE9tk0kp7EBIeIusqoRZOragQIV
        /dnW13BhnrWhpZF481th+/o7+B5OTSqBSyZVXgYHUYm8nWCN9R+V44fKHjAC6JAn
        gRuz31ay3qlhw0BNgTp0ef7+t7EUBhDIYltGbsXrKdSSTSt6rPfikfr0U5qCtM5S
        qIOe3Z2BjfRdzAq3tuF7cif14GZUajJ8VfDe8a2EpGPfK0xnlerg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 04gAz_sRElFZ for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:19:49 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jxnx02snLz1Rwrw;
        Sun, 13 Feb 2022 18:19:48 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 15/31] scsi: pm8001: Fix NCQ NON DATA command completion handling
Date:   Mon, 14 Feb 2022 11:17:31 +0900
Message-Id: <20220214021747.4976-16-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
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
index 3c667e67cd2e..10a78312fbaf 100644
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
index e3b03ddc26f8..082b6353d3fb 100644
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

