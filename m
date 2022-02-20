Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A15C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243405AbiBTDTj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:19:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243423AbiBTDTa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:19:30 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAF5340DE
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327140; x=1676863140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2Z+aMqX2UUAp+gMmZBRjOT5kqmxmwBLTUlXWPM74m6U=;
  b=Qz6jN6z4RfxeiNmUAHzOGsDyPOWpwiXoqXxYdo8HDjXqmDJCLOyjPWOa
   VlUFWSrhTEnmPww5nQTSaVgD2y2IPtxtjB/AJTweO1m8qHiE3Ft/+x5YV
   uqFKTFGDE+QIiMMpadqcmMNlJwjLU1ctcTNjAsV9er7uU8rcRZRK/YDzf
   vYjRdfDTWAt33grV+s4cOg8rqSiakSs54qU2hpVPULT9zP373F6v+PBtT
   5Gy+ieI/Ky0HbzUsykZ3dgCrUaSBLFm9uPNxzGxwTrl23lcdHvtNBb+or
   gflOztXTp+f/mWhEqZHX7xwwrqkIQdGby1hvVEC6xEG0Ou4WnZPmKFrhF
   A==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405830"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:59 +0800
IronPort-SDR: 5LK7X7iOcmDJsOsFCKqbULazvf2FEALzZ5vnx6wmi4w9b3ETNpKQX9mH9PIhJXPTsnb7mXKHf2
 +Vjh0fQ6Eu1nWd3iV7BDWk6jw/YR3rPTn1ngDKT9izrUHGy+OYgTTNybDhvOY62nayn8cSHoBY
 M4rk9XDJdCDo5OIjJ+7oumUBoy3xnRZkjAkhKGfWVizgJBGCgJLZ4ZSBXAYEAeXfOxTTSyy+fq
 R2XMeRsyoOdIeajqeGxkthMGOyTbkzm0021JZfDsiOe6m93BaXFJkNrmJ7pMpQncs6xPkmogHz
 FzgXRhuFTE4LKiX3OS1FhsGp
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:50:35 -0800
IronPort-SDR: wG6djnmun8EVzdRJr8xudpNPoQm2yEiiSMVYBUii13i+QK1uLuHMnHLCXGqrJNlECk2y2J7AJE
 6YwtaLlqNbp3imiJfTIImGyZd2ezducacUw1q0twGZDTzQr7eFaXGkkFbNoYSw+FZu0bRTCClD
 NEukwX+rSgQNdN0SoQACrsXFNFyNTldo/MtnQt9aCT2by4qlmFLZ+WB+sZjGPGSLNETThp8kI/
 KzeKHhuO8fdVazFRmDgwUDBubms/RliPHQrL67diPvCP5+qA4NQWI9PoxrR/ZXxgDjhVt48DnE
 mBc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:19:00 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1VyX02LKz1SVp2
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:19:00 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327139; x=1647919140; bh=2Z+aMqX2UUAp+gMmZB
        RjOT5kqmxmwBLTUlXWPM74m6U=; b=f/Qp/gWy1506/wPkRVA4LFH9d3ZPlVeOzG
        1DAXNTvKStoCvtiqrhwrxf0SZweJZUd62YK9a62OwX6yfal22qcuuD71ISKBlEZ7
        mgdUsAl471jTAzCp/MwztV1wjYGHGjpsCAiFf1/aAT/nKDgnFsMpbdfDTHJGu+GD
        FKRA3Su5HNMecAnhGXip501P4mL8kLq9IWJ03P4N7JMJq0ksNfkRFGVxHzlKhcLT
        7kffF0166XIKCQQPfOdhCldYRP3iRPdU6EKJ3Izd7CE55DE0y97Wd6EWB1yx2yg3
        EnfJXI9ak8EB3AvQNSb3D+/MrqwRYwAvTdEmIKtzSCodveb538zA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id rEb_fW6S3YNI for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:59 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1VyT6Q5Jz1Rvlx;
        Sat, 19 Feb 2022 19:18:57 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 30/31] scsi: pm8001: improve pm80XX_send_abort_all()
Date:   Sun, 20 Feb 2022 12:18:09 +0900
Message-Id: <20220220031810.738362-31-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Both pm8001_send_abort_all() and pm80xx_send_abort_all() are called only
for a non null device with the NCQ_READ_LOG_FLAG set, so remove the
device check on entry of these functions. Furthermore, setting the
NCQ_ABORT_ALL_FLAG device id flag and clearing the NCQ_READ_LOG_FLAG is
always done before calling these functions. Move these operations inside
the functions.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 14 ++++----------
 drivers/scsi/pm8001/pm80xx_hwi.c | 16 ++++------------
 2 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index 1569aa483af5..048ff41852c9 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1748,15 +1748,13 @@ static void pm8001_send_abort_all(struct pm8001_h=
ba_info *pm8001_ha,
 		struct pm8001_device *pm8001_ha_dev)
 {
 	struct pm8001_ccb_info *ccb;
-	struct sas_task *task =3D NULL;
+	struct sas_task *task;
 	struct task_abort_req task_abort;
 	u32 opc =3D OPC_INB_SATA_ABORT;
 	int ret;
=20
-	if (!pm8001_ha_dev) {
-		pm8001_dbg(pm8001_ha, FAIL, "dev is null\n");
-		return;
-	}
+	pm8001_ha_dev->id |=3D NCQ_ABORT_ALL_FLAG;
+	pm8001_ha_dev->id &=3D ~NCQ_READ_LOG_FLAG;
=20
 	task =3D sas_alloc_slow_task(GFP_ATOMIC);
 	if (!task) {
@@ -2358,11 +2356,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001=
_ha, void *piomb)
 			ts->stat =3D SAS_SAM_STAT_GOOD;
 			/* check if response is for SEND READ LOG */
 			if (pm8001_dev &&
-				(pm8001_dev->id & NCQ_READ_LOG_FLAG)) {
-				/* set new bit for abort_all */
-				pm8001_dev->id |=3D NCQ_ABORT_ALL_FLAG;
-				/* clear bit for read log */
-				pm8001_dev->id =3D pm8001_dev->id & 0x7FFFFFFF;
+			    (pm8001_dev->id & NCQ_READ_LOG_FLAG)) {
 				pm8001_send_abort_all(pm8001_ha, pm8001_dev);
 				/* Free the tag */
 				pm8001_tag_free(pm8001_ha, tag);
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index b5e1aaa0fd58..9bb31f66db85 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1761,23 +1761,19 @@ static void pm80xx_send_abort_all(struct pm8001_h=
ba_info *pm8001_ha,
 		struct pm8001_device *pm8001_ha_dev)
 {
 	struct pm8001_ccb_info *ccb;
-	struct sas_task *task =3D NULL;
+	struct sas_task *task;
 	struct task_abort_req task_abort;
 	u32 opc =3D OPC_INB_SATA_ABORT;
 	int ret;
=20
-	if (!pm8001_ha_dev) {
-		pm8001_dbg(pm8001_ha, FAIL, "dev is null\n");
-		return;
-	}
+	pm8001_ha_dev->id |=3D NCQ_ABORT_ALL_FLAG;
+	pm8001_ha_dev->id &=3D ~NCQ_READ_LOG_FLAG;
=20
 	task =3D sas_alloc_slow_task(GFP_ATOMIC);
-
 	if (!task) {
 		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate task\n");
 		return;
 	}
-
 	task->task_done =3D pm8001_task_done;
=20
 	ccb =3D pm8001_ccb_alloc(pm8001_ha, pm8001_ha_dev, task);
@@ -2446,11 +2442,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001=
_ha,
 			ts->stat =3D SAS_SAM_STAT_GOOD;
 			/* check if response is for SEND READ LOG */
 			if (pm8001_dev &&
-				(pm8001_dev->id & NCQ_READ_LOG_FLAG)) {
-				/* set new bit for abort_all */
-				pm8001_dev->id |=3D NCQ_ABORT_ALL_FLAG;
-				/* clear bit for read log */
-				pm8001_dev->id =3D pm8001_dev->id & 0x7FFFFFFF;
+			    (pm8001_dev->id & NCQ_READ_LOG_FLAG)) {
 				pm80xx_send_abort_all(pm8001_ha, pm8001_dev);
 				/* Free the tag */
 				pm8001_tag_free(pm8001_ha, tag);
--=20
2.34.1

