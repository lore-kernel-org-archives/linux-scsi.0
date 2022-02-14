Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0173C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239359AbiBNCUT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:20:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239325AbiBNCUG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:20:06 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EC3554A7
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805196; x=1676341196;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=Fmm9tQdadAc/BhpzhkDgviV9BX5k3UMAUui9NnnnwY4=;
  b=mzqhPtAEVnGsaE9ZsxO9d9/DIDhZkGBitHerLC/hNqBO5rs/mhKa7hGV
   PUAQv0M+r/2KTP1tY5jTXx/PmiGi8KA8H41hdCGpg3kkK9azUHfqhRbaU
   cqxbpEP11+YTCehPnrX9A2UtPluu+agnXMbiLPzUik/2LDV1H0ca0TSBD
   mra9HvFEnYbvGcxzTvv9I0S7GQkwk8CGo3A654hwqv5iTjBgY646SBQU4
   Hv1IEm1OGO6SXHMmGD0fsCr+bce3K0YzEKQRJQhcNAU/ij7Vj9VgU/abz
   LeCegXQu2+FljnB2TGw/IT7wOZtLpWJefhhKg17ZIhsNWC4P5BcY2nkOG
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819802"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:19:56 +0800
IronPort-SDR: 5kzX8w3wFXb3/zjg3vSgK1yJuvkrMmZMKwj5V5OyXmL/9S/eq7NMq8GDuoomtNjo8NN5/jYlne
 smYSimxgLmUrdFZ2zlwNsisTGkludrD3wa2COnxQEvjoNJJbhMZ6moTedlXl7tyOGxfivZr8mO
 B24MSyOYxIZzo5NMaSnBJVjrtP6evoABW+e5KwuNPZycrLXEJm2YX5aLJdpb55OrxjnAhZj+ox
 Heh/tKFN0/G68wj7WhtTYbEvg9gnqhu0Zy5tAAdHa4M14b/dqBeHS2wX402l9WDV9XEaZM8fNq
 JDuW9tBWRDItOvZhpMk47t9M
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:49 -0800
IronPort-SDR: s5o7YgGKs4yPKE4BSdYQdClBIprDJhmL0hBAXwlNqAojdNckksIp7cvm3xN3YPpIHlHBNvZqKw
 IsDAIxcWakhaAXPqd9WVVNpC8NB4qtzM0pZjhwogqHZh4YbPI4h+WbANCVCcM/BbYplna38uIB
 Cu2SkNuExIcMWxlsmss89n8y62NAKR6M93Un2udXO+YWsMxmBh0BJvPk6MCOXv7iyE8d76EqD3
 7t3pcf4H8Ic5D1sEP6tCnkvk2baexs7j7gLdAJlHIMqZ7YMc1e1AHEFl7UpRPP5JbX0FiSR1QZ
 FqI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:19:58 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jxnx93R41z1SVp2
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:57 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805197; x=1647397198; bh=Fmm9tQdadAc/Bhpzhk
        DgviV9BX5k3UMAUui9NnnnwY4=; b=lLSHcwPi2qvzUy6pqqzOsKlmVZHS+FteD5
        dvZvQXn19b08583LMQEEZPrPwv2ygEWvItTat7qJXF3rWLjlt7eI3NnSxpcEj7GW
        ZWc36zhiuzPOWtE7r+lDwUWFL+czCwgxNzF4TA+oe/VP6fHp9mGF4wyIS9et2n2e
        4uRPGmJ6zZ0lPR1/BIbeqSzqU0U1wILhJnp1gh5oWJWO9BoAqkrYaaC0R+peL8Nx
        TOe6n7rhWSNQtyLSPPu6XTSLgZ7T2FbWAOv+vQh6lxCDzJDMp0rTaURu3qVTnv9H
        NVPC07rvDKLJg81a8lXBjysTIDwdNk4FywAHS9m+xunCrFszmqZQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id h1QSB-clmBZz for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:19:57 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jxnx773lQz1Rwrw;
        Sun, 13 Feb 2022 18:19:55 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 21/31] scsi: pm8001: Fix task leak in pm8001_send_abort_all()
Date:   Mon, 14 Feb 2022 11:17:37 +0900
Message-Id: <20220214021747.4976-22-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In pm8001_send_abort_all(), make sure to free the allocated sas task
if pm8001_tag_alloc() or pm8001_mpi_build_cmd() fail.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index 640e8473ce06..5886c7a83238 100644
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

