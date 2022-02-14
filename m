Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44938C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239306AbiBNCUm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:20:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239341AbiBNCUM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:20:12 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A258F55489
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805204; x=1676341204;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=pb3Ko9QU691TbENd5ll2DCHRdG0rUb90DZqsx6AsgzE=;
  b=WWLhjTcNj+hf0oXRs7kMlD0lEsrDjNRNvFMhPFYX0/u2qK9IJhU8deb1
   jDZqM/5fYGOpl4AWmzJN9DknZlzymu5XK0FuHCWl6Dn7YerxjyLI1svEo
   c1dtFW1xcl0TH9sze7uw5okjN5iBOTiaGSd451gGX26fkeXO06vkTnBgm
   yxqIlWrvYBRwMvCsglINMoNW94MyhGwz0VUhVeMPDARIAF1ofHz94sPPL
   oj5+m1Vvb52vBSv/P5sgxAQcs62l3YB4dycKqFGHnckzufY0eTRaX0sIu
   OdWLQAZ8dUW6Iv+MdlI+wXDpj8NuXcTO5z0sDdACq2obobrfajFAB6Y6K
   g==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819825"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:20:04 +0800
IronPort-SDR: nK/nlQdorh4pEc5ODmKRQEgfY7h7zEC8UW0F0N1R14Leb+cE2UA435WVNyZoqZiK2lb4TmJ/Cm
 Klxnu/2aDAYNYa+Y2SHioR/mTp2vNuISUduBAyNBNRAEdiB4TlZRUauHLQNe49diAKGFzzmg1n
 F/riOUWFyXEhBuqx+3gV5Je1qAZPt34HLvMr0swopn6SuWyAeSBtpi25hQA+ukQJ33vHTS/p2Q
 PHK21VlBYemDrGk2CmlrLDdA2ahhtBZkafi8qOq+mGM3kwBatqH3dq0WUG+xQsxhu/5nUJ3DBk
 Ni9H3KYzIbpy7O73Gqqn4NzW
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:56 -0800
IronPort-SDR: YH/5cGqRLZ0B9pkS1p4mlZ+HVVjOmo3OuVRhEB6EvqvPiBSqy4lpfAAMjTl9EgabFpMd/tGPoO
 19yHqAplxdyteQM7QWu9/+cYSfpoThu+EYtGavagKqBiKSO+4ICBnNyaPxaf+vnxLBsAvKDQTD
 wmvGGhLAawObFpt0Dekpc95jWD6U+PImjZV7YY0e8kloYof0u4aaR6QDd3osU1V38cinrXw0D8
 tLPRsF5/cY/QSWgsePxOze4mP+9DM2p0NShRcdQ2WwuGV9pKUL3T7vpCXO8UYjA55eWV7aXf/z
 4ww=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:20:05 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JxnxK1QcSz1SVp3
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:20:05 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805204; x=1647397205; bh=pb3Ko9QU691TbENd5l
        l2DCHRdG0rUb90DZqsx6AsgzE=; b=uwr9Q7TwBBtSYn65k0OLKSWTPqVp6XYnQ2
        g71fCt0k8RKKCh0nJHa9XgsiHQPW2gjoluvKzV4Loo3cNJXzU4lnDdFZZVYMGSHC
        TDkI+D3tuAtQeaLWPV0xbmjX4Ajmz/aZee3r6EU3fZFiMXF9joK95b/xiAqmc6yU
        LQdb4/C6+hTH5KotyZ0NQuPalooQU+hZicRQ0NmCQGkVoJVIXSbGy278NPk/2ZE+
        8/YN6Xeo4XuBSZ5v+7fddhD2PWJjj/liO7MOnvEvuTKvDAhZApfvj5hmZQuSI8u8
        lsHGYAIAhehYi9qTirTynSv0kcgUFEaWH37a+OU4GmII/CE5qLiA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id VvbS02cXfSyz for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:20:04 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JxnxH4tVnz1Rwrw;
        Sun, 13 Feb 2022 18:20:03 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 27/31] scsi: pm8001: Cleanup pm8001_queue_command()
Date:   Mon, 14 Feb 2022 11:17:43 +0900
Message-Id: <20220214021747.4976-28-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Avoid repeatedly declaring "struct task_status_struct *ts" to handle
error cases by declaring this variable for the entire function scope.
This allows simplifying the error cases, and together with the addition
of blank lines make the code more readable.

Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
index cbcb56b56a2f..d08cbf3ef879 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -381,54 +381,53 @@ static int pm8001_task_exec(struct sas_task *task,
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

