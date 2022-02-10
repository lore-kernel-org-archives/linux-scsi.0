Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A45B7C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 11:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241152AbiBJLnD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:43:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241164AbiBJLmr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 06:42:47 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464611022
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644493369; x=1676029369;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=35QePzbOKeA+/Ffi5CHtsZ5USOZqrahcT8z3vAl3Wv8=;
  b=Pe93bV537hAl7DjfMmC2+lL/tCsfrgUFu8AnFi5XH4GE7uv/+GpqUJMY
   H5hWvCT5Q/ilKFfBnqpltUozAzVblzOaIAN0V0AI1EDfJREaxPvFA6xek
   Axc+B+hMvBTwzUa3OsFnu0aLd5c3IjGRomz0ih4OzYftSC0J+WSVJe6am
   C6ntmD0+OlFitpLl8w4HQotV/F1cIZTuYFDuG+BDEn2yfYRNolOQ3v7of
   dEnDSN5bHpK/LHjXRiENygBsYLKa1YEmXZsGoB/yjyGhntxb4LTOIrTtS
   yfjaLgxvTJZVIBJwpqPZGxT3tF6gVeeuSqlMobUuJZXZelsFDwrg4mznM
   A==;
X-IronPort-AV: E=Sophos;i="5.88,358,1635177600"; 
   d="scan'208";a="193575669"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 19:42:48 +0800
IronPort-SDR: XAWCeaJmptwjKCituU5oUwpZ1GAgEAF1wdoHY01II45KgtzGf92O6e9nACeBjuRrM4H4MK/A8z
 xaEM8QRUwHCvlzwJFg2Y6erq4yKJMaYI+SowgRyDhwPVmo8fB9IZRZWDBB1+n6j9oesu8cbbJb
 48IjvlJpnKH5jNLncsdDLLjo0f6fRkGyYLzxRg5AQ15UnI+9Ut+jLDFzCDb9zmnwkia6orbTYm
 X31RgmRo0gAW3LespLTM7dUhvlBM2Hb6nDL+u36fe1aQPtMjNRCYHwUDUcSTCnYSMkYzFv0GAL
 SSJixAoyaVwyslcWTXke7JaL
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:15:45 -0800
IronPort-SDR: BdNkxjJ0ZpvF0twW8Ce0kzHCxOFKVOsDMNNyCRjJXjKDH2IsejJ7jJm/xkp+upmViDarGReVH4
 cGV/JhWn1CZuhly7UJl3iGyHwOirck/pZ5RuTunmKp5QX1zXpwmVVpdezKFpEF3QaADFSR+SMI
 okbFFnml3OD0OEHE0fNcdFWRBOifyaPlXlKNFUOwqfJ+AB/UArc/inXnqznH8fcD7qFsFHy2gQ
 gnFq/PQ0Z3WJmSKKIFeuYnFls7u3aaanqKcklCttJKg13LlRbnWjlCURtOk/tbS9r6D0JESmhu
 H1Y=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:42:48 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvZcR5mTLz1SVny
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:47 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644493367; x=1647085368; bh=35QePzbOKeA+/Ffi5C
        HtsZ5USOZqrahcT8z3vAl3Wv8=; b=IvsgSWQS/0PFm1cTVJ4J+MhtirTpMesnvE
        waCGTg0zmdFVBv7QxfcuVEHCpdXRYipxCy8bUSk65/2UhCaCrjX7Ck+pIf9azNKs
        hSb8l5MAXy+brdLh39XCIQZxffovQ2JN0y8S8igljMHh8rM693GmzcRdA0Y+hJOU
        6R5GQkL4LGyznTWm13095P7FpzrT9u0NTmQrlG29cQfXeqLTqETtEuSaRMP1K+oC
        bH3GxHtLaorfT9a6eiSsbjrLFN51uxgo8X73xZ2jwWjR9S+Qok4xEQ+j1/UX0Agk
        Pcie/R5znW3AL3F1Xf4UX1JmxlU0YwtQY/UoS0LbDHNnDzSjxiQQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id dRI-Lglc76we for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 03:42:47 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvZcQ2lWLz1Rwrw;
        Thu, 10 Feb 2022 03:42:46 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH 19/20] scsi: pm8001: cleanup pm8001_queue_command()
Date:   Thu, 10 Feb 2022 20:42:17 +0900
Message-Id: <20220210114218.632725-20-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Avoid repeatedly declaring "struct task_status_struct *ts" to handle
error cases by declaring this variable for the entire function scope.
This allows simplifying the error cases, and together with the addition
of blank lines make the code more readable.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
index 711eaf81f546..929d3d3c9d3b 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -383,54 +383,53 @@ static int pm8001_task_exec(struct sas_task *task,
 	struct pm8001_device *pm8001_dev;
 	struct pm8001_port *port =3D NULL;
 	struct sas_task *t =3D task;
+	struct task_status_struct *ts =3D &t->task_status;
 	struct pm8001_ccb_info *ccb;
 	u32 tag =3D 0xdeadbeef, rc =3D 0, n_elem =3D 0;
 	unsigned long flags =3D 0;
 	enum sas_protocol task_proto =3D t->task_proto;
=20
 	if (!dev->port) {
-		struct task_status_struct *tsm =3D &t->task_status;
-		tsm->resp =3D SAS_TASK_UNDELIVERED;
-		tsm->stat =3D SAS_PHY_DOWN;
+		ts->resp =3D SAS_TASK_UNDELIVERED;
+		ts->stat =3D SAS_PHY_DOWN;
 		if (dev->dev_type !=3D SAS_SATA_DEV)
 			t->task_done(t);
 		return 0;
 	}
+
 	pm8001_ha =3D pm8001_find_ha_by_dev(task->dev);
 	if (pm8001_ha->controller_fatal_error) {
-		struct task_status_struct *ts =3D &t->task_status;
-
 		ts->resp =3D SAS_TASK_UNDELIVERED;
 		t->task_done(t);
 		return 0;
 	}
+
 	pm8001_dbg(pm8001_ha, IO, "pm8001_task_exec device\n");
+
 	spin_lock_irqsave(&pm8001_ha->lock, flags);
+
 	do {
 		dev =3D t->dev;
 		pm8001_dev =3D dev->lldd_dev;
 		port =3D &pm8001_ha->port[sas_find_local_port_id(dev)];
+
 		if (DEV_IS_GONE(pm8001_dev) || !port->port_attached) {
+			ts->resp =3D SAS_TASK_UNDELIVERED;
+			ts->stat =3D SAS_PHY_DOWN;
 			if (sas_protocol_ata(task_proto)) {
-				struct task_status_struct *ts =3D &t->task_status;
-				ts->resp =3D SAS_TASK_UNDELIVERED;
-				ts->stat =3D SAS_PHY_DOWN;
-
 				spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 				t->task_done(t);
 				spin_lock_irqsave(&pm8001_ha->lock, flags);
-				continue;
 			} else {
-				struct task_status_struct *ts =3D &t->task_status;
-				ts->resp =3D SAS_TASK_UNDELIVERED;
-				ts->stat =3D SAS_PHY_DOWN;
 				t->task_done(t);
-				continue;
 			}
+			continue;
 		}
+
 		rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
 		if (rc)
 			goto err_out;
+
 		ccb =3D &pm8001_ha->ccb_info[tag];
=20
 		if (!sas_protocol_ata(task_proto)) {
--=20
2.34.1

