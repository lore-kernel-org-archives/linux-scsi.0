Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB7F2C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbiBRDQH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:16:07 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:59020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbiBRDPu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:50 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEC9168082
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154134; x=1676690134;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ot2ANyjiSvfWLWkj+FYcOdGIqJ4Hq++lbLMv8ADJsaM=;
  b=AUcg2cOUQBtmq8jMSVLBHNZmSmxT/QA3QLWZvbQz5CZ9gWMdAfXpyhgP
   bFjkzoJ9zl+jINw59FwK0FPbn9IO4mdHVjf8g/hanufjbNdYG2ym3o1n8
   nHbrbyV3ll4Kdcmhw1fvBwaPY5t9zoc4PhWsgSLdo/mhzsaVu5wC3+iFt
   5+ojQIWzo8k/3EPlYj73oc4HnOvdw7rtCzFFL4untIFJRPGBYRSHT3HmD
   jMfTyOlNoXAmtenT8RDnhzfiaS2zQBw9ijF+txUaJtLDrPrpiVWKI8kgl
   yhXnpt+z7pPKK8B4lwRB50+8Q+CIub44/Z7kjqnvCrXJuvoQsWPac5JkZ
   w==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="192180429"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:15:33 +0800
IronPort-SDR: cKoGV9vu/ipPoWkFp2XaGbmXPbnyn5HGtm+O2TppS7WUEb3tiRiJ7/UkZfetv+ygc9ncsSBlmL
 a+U6W5rPmXs7EXEA6JrYSDE0vHT//YxZiRJ2VS99c3yNoDDmjaxL4c9/g324ORceNVVv07c67B
 X7z0IlmzO/pJGJ9CNrldir19WsnyDoEjT/RyB3nxp2/Js0RK3AaHyE7MWjk4HX65psfCmbkyOO
 P6UZKrmJkDdPVrP4ARd9FkzAi4JW3jCFUOm+nNkA6Vxw2WkmyhKl5DZFJaiIFS6qC3ir97hHhr
 iUzAEe19OXDcSPvbzkdyBUZq
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:47:11 -0800
IronPort-SDR: wG4oyu2wtoaJwvmGfWhx87Pmg+LASzs7ak6jVfSLPmuKtwVyIcGRgmBArPLc6foGbd4qIWRnK+
 lTTLvZqaD9NCVE621f0IdKj5hPFITO7ZuSvhBKW9W/QzKfDSU2Cuf2Vv7yqQQ2ciYd2JqZXcnw
 rbSV93lUGGURoaIYRsyzbAHGbCqfRjI6jt9eVQqBdO5AMZoKnA4UHX+kOF/HgDCMrF/0MIC1nM
 +BRC3SMKXYJTb3wnNv4nQ/OsUX9elASo7uBV6tKLXGDdZF75fYouQj9uRoLW8PP1HfmPQiPck9
 Fkg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:15:34 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0GzT4v9Pz1SVp3
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:33 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154133; x=1647746134; bh=Ot2ANyjiSvfWLWkj+F
        YcOdGIqJ4Hq++lbLMv8ADJsaM=; b=P5+Rjxpge+2r6pCJY1K5yaYNaE8KPjRzsi
        dM0LTsYtUCn1DkNtC22qo2bf2H8uH5rj1qwACj7uk3W79UVRIiVeFFcc62hLpBr+
        HQt8eP/MJDCymAa4U5a18C+LBn27Kk98q8IAaxWr1b5WRJMrw8L1zOfLV5hwxE3Q
        TkyUUbFxCBDKS4lNypyLk5Fm5vqFsVGlvWoM5KasPTHWmMtoHQxrJaEr5kyHU5gS
        2psLQMZJcfaj4he2Zh0GgbWYGsPoDnwWeg7hAbS4sGc1/r05S1KnPf+UrsVzA67V
        dE3/nY481k2P+ZZGXoGPgosrYErzx9Mez8xPdZUcKKDlvgcip6tA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id XYz5gqaeei5N for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:15:33 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0GzR4SvBz1SHwl;
        Thu, 17 Feb 2022 19:15:31 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 30/31] scsi: pm8001: improve pm80XX_send_abort_all()
Date:   Fri, 18 Feb 2022 12:14:44 +0900
Message-Id: <20220218031445.548767-31-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
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
index c2dbadb5d91e..edf83b8a6bd0 100644
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

