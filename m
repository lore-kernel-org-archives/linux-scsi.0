Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D34E1C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243417AbiBTDTL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:19:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243375AbiBTDTE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:19:04 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0980A340D0
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327123; x=1676863123;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XHnl2/M7VbXK4hf62VEy+cdvARX61GHwvczUM/MOT6g=;
  b=U/nUCc8OgkhfpJPwaZa1NSvrG+w8/Lrke7SvrggTetMApmITI6LbzdoV
   HNk5C2eRRu3toS/+g/EgVP4M0Ia8AdHSmegQklo4A8F+MWz4XPw3l0LHS
   PGsNBYiuX3afLlHJ26tO4J2o3zOwHrRy17UrrwF/vqBAqPbEU2m+wKL8q
   4amuS+NNnW+Pm9yLF99/M3yCfz5mn/Hzef4xW9ox68XpwBsy4fIIs8JEG
   Si/Lfh/do8pJY6LAuoT3Z7rTZaZY56aBtn9FpTFK81yW5vFqgDK8XLg0/
   LA8M5NVu6RDl98sl919uwQv9RPxjTQVaXu3HlBh5FGTIvWkvnqOn+Irpx
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405793"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:43 +0800
IronPort-SDR: JbOMjgXMHokbTBOsGuE7Ucg1np6N9FEvTnWksy1Pn7SM1BPna+HOdL6+2pQaJ8Hjrh8B7TSaru
 yN7Pk6aecd+f/97+pDM5aC15vrU+CcwG15eQDGzwiTMuKKL3U7MA4OJY0lvrGzQ0P6sze8NEWv
 4dW06+jB/FCmH+BYpT5S4dYqVo3R+x6y1rrfMdtmRh0x7WnIlSs58aK5STBomDLGyrQ1wyD5fY
 4sf5fkykVxPboZMNhokq7NjxJSnHsRU0opE0MqcHULJG+kSTl9iTcob8mKZl5Fo2j6f57z1+I5
 kCNQAmSLF8+Ey95r70t6+2eP
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:50:19 -0800
IronPort-SDR: Jo0IW/0rL0YxSNpojHHoqtUYrpPg6h90vNQjteI49gP0C0Q+1nGTbZCJWcW7CZw4iu+MU1KdWE
 O5pzWSyo8LL9AFN4fxMOwTFsEIpD31E0FOFFpmU55u15kFdI2X0R5bZ+SVi5KaiAsBefBECLBf
 jlJzOkgvzy9oW6Ls2NERJQYfJjU6O06fW1yKf8kQCDLQW8blk9fynalTbaJgwkGCXm+YfPsgv1
 SsTp7Qb0Tpm1ufgW0iARLlo6r9xNfIlER15SusVZ3Tw+7hPwpbK9/qSjlOChjL5hix3WXRat86
 FV0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:44 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1VyC3Vszz1SVp0
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:43 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327123; x=1647919124; bh=XHnl2/M7VbXK4hf62V
        Ey+cdvARX61GHwvczUM/MOT6g=; b=twIVr+OFRNKo321imBCNXSrwkZh2lkxVav
        68WUz+9rEEOtHmDrs/fDkEp99xYJiQMvQmPBHWVl9gG8Z4EyX3HsxOO8AsTZK+/h
        Ga4BMT4jenPZM/IlTiGVUWbvUugvoQG4XplIVoLxwSzkdGI55Py1l3hN8F7Xzg7S
        I3XMfCS1S9PODjDWJf+htAq2G5cq5nKeYA618QlAA9SgW3h3ScWvjTIPZnpgloN9
        xTxMmtOHGjdiAICNr2SglgG6C6kte8GowEjq99vKMCjei028m5hwXYLa4FXCStR3
        xFMFYUfLQQIUZfix1m4+dqxi3ggWg+a6ZC+eYcB/Qx1rpLTcy8+Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id VJIZRKdMwOJv for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:43 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1Vy95pv8z1Rvlx;
        Sat, 19 Feb 2022 19:18:41 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 20/31] scsi: pm8001: Fix task leak in pm8001_send_abort_all()
Date:   Sun, 20 Feb 2022 12:17:59 +0900
Message-Id: <20220220031810.738362-21-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
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
index 6f9ee77cc576..defac9855d9e 100644
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

