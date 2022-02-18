Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96029C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbiBRDP5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:15:57 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiBRDPn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:43 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626131BBF52
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154118; x=1676690118;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ig1uYjC9rTuwTN1Ykh0XxJsNqojO83JkUIq8tDwJTbo=;
  b=dJpGHJBHqhF3BXuQZODEzf4tXfpxr7sYBHfDO/OtRsuWg+a9MQ8cvgLW
   H13sbudGf+FZjGLa6mjhHKbP9QllwvC9xUtfTKsyB9ixL6UCXOtxKpNpg
   OdUxfJM569mAxGr3CSOKbexr3mCiKWe7M0mMAIN9yYRodVWInOG8sLCw+
   T4n9A0YSjG+aFGsKGfH1P0e/vkP66QFoJ1gtvmTX42inaBFJ1mVbIyFSF
   oNgQvFTAlD2AgevYyZkT/N5F+IZlI/FbqqqyGYIxOWFpglV5gsM9PhVvq
   xcn2lK9ic2TCTBwhzALXqTy2AyfOGFsDcL2FQ/RE48HxzxfqEcATNt3+7
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="297362825"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:15:17 +0800
IronPort-SDR: zZdUel99JoZeE5lKW+wZOOByMMoPQkGEaBo/d54uSSo12mOIPXcBTWkl0tNj6MOxGrKqbcCE08
 MyqDBE/v+6SsDQAXVeQVmNDxCKFjB0XDjBEdn9tssNGMINW4NHzbdfWHWG6MlfgQoKGqv0IyyK
 sIDl0+35W7bN3G2NxnAMYTHBNJJz/pf/qqNbWeS98rH22CCdHjvedFNWD4tVYr0pXYnDZam75l
 a5ZP9/kYDDjPKTplqrwNHUyG+Nh3GZgX2je7t3dOMn8Zy83G6iL8afuBzp8epcchPQvYU+7v5i
 RXI2vphb/xp5TEATzoyw/o8R
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:46:55 -0800
IronPort-SDR: LGdT5Zo8S5UwoPOvD99IMwjRTzzwSO/D+ZRXP9o75W8quZKy+aCw3MueIH9cZkdo0NFeYzwKNK
 nV8oSf4cHRcLwJ3jzqn2ZI8bX+oLVPXPYIFhvT8kCRRPMMtEwvQyafgCMVkic/YqRRUlI4Xnbs
 5LE8i1SGOUvmu+8gO1FqCYH9eU/gTcJLKEg6MtgMdiPR7+DS5i9RCBdhDQpKlZQH39B/nZcXqw
 oY3Cb3rvpox+xW7WLp5WlHpTFy8Z0vFYWYviO9cv9d2CvjG5lDMR/Of71pqy98ICYprnBt8OyJ
 snQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:15:17 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0Gz92ZDGz1SVp2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:17 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154116; x=1647746117; bh=ig1uYjC9rTuwTN1Ykh
        0XxJsNqojO83JkUIq8tDwJTbo=; b=UkSYW1XeRDNSva1kKniW9GYgBPAwUXjzeN
        2j4/Olqs8dE8YNpRZFp9swpEg1wLDR8v3gKWrUA/UmPor9RbgZsk2tgt3IM6z28x
        kuK0h94tHsrOR/MSQsrIE72vy1zzkboTB26+v180DXBmfYBZp4fXzrYmOh8DUdu0
        k/aS7ma3b1l/x+H0IGbEG1qUGi8c30xCddvq0fLLM2tJwldxAWFhbhHWIm0AVdzF
        kwuHp2CTPemyeKmZKC7mC9H0zi4JQRqIWkj+2A5wfdfP9XePkmx5B5a+Cl+HcRT2
        5L3riUzdJ/BiDc/RmSEHzvCrA8BmvwFSWPqqJPxonobcvtDGMlVQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 1X9VwA_XukBo for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:15:16 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0Gz74FsSz1SHwl;
        Thu, 17 Feb 2022 19:15:15 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 20/31] scsi: pm8001: Fix task leak in pm8001_send_abort_all()
Date:   Fri, 18 Feb 2022 12:14:34 +0900
Message-Id: <20220218031445.548767-21-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In pm8001_send_abort_all(), make sure to free the allocated sas task
if pm8001_tag_alloc() or pm8001_mpi_build_cmd() fail.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index 3dc628b0384d..cc96e58454c8 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1764,7 +1764,6 @@ static void pm8001_send_abort_all(struct pm8001_hba=
_info *pm8001_ha,
 	}
=20
 	task =3D sas_alloc_slow_task(GFP_ATOMIC);
-
 	if (!task) {
 		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate task\n");
 		return;
@@ -1773,8 +1772,10 @@ static void pm8001_send_abort_all(struct pm8001_hb=
a_info *pm8001_ha,
 	task->task_done =3D pm8001_task_done;
=20
 	res =3D pm8001_tag_alloc(pm8001_ha, &ccb_tag);
-	if (res)
+	if (res) {
+		sas_free_task(task);
 		return;
+	}
=20
 	ccb =3D &pm8001_ha->ccb_info[ccb_tag];
 	ccb->device =3D pm8001_ha_dev;
@@ -1791,8 +1792,10 @@ static void pm8001_send_abort_all(struct pm8001_hb=
a_info *pm8001_ha,
=20
 	ret =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort,
 			sizeof(task_abort), 0);
-	if (ret)
+	if (ret) {
+		sas_free_task(task);
 		pm8001_tag_free(pm8001_ha, ccb_tag);
+	}
=20
 }
=20
--=20
2.34.1

