Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99D4AC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240931AbiBQNbD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:31:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240953AbiBQNax (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:53 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4712AF3C9
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104631; x=1676640631;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dH4sxA9AmlZnS/GYur+GQZPteUwIE//gjMPrygAXHE4=;
  b=ir1b2QH8XhvqAhjq3cHMYGSlkiNmFJN4qpA+hEwedHL+HFjciMpwSydJ
   A9+kKGwygEVnmNPpZ2oQQenTCDzQA63uR0KGi230QJUMcvaMS1yqWiFs9
   Lj6a61AIYpODbW5KUMNi11jV3/raROK3grWwYaIki1wRT3a+hzUL+um3+
   s4JG0rvZ0a90czgxPFAAhBCWzeSPFbByljolRDYFgRi8chCgEh8aPOig4
   WCy2ysc6RVHTfu/4RqYowB8JkLdC7egjbB8dremFrA8d9Td1lPfZhQngF
   YWNeprUrnJcMYIaaRCVJxO9WH/WRUTEMWErRdgKVntFuXo1clCROhMss4
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303221"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:31 +0800
IronPort-SDR: c0kraIp17BaaceelQccjjCeJTheEJUHQsPQfU/5Yoi1k/DfE0+2T0XihqIPgVKoYj9izyyOo+p
 pOT3NDezZlZYvtu18QChEIPR+6ODm4PI0PGvLi3X+eIe+GBM4IC4o6ED1Gn6KSL2shLu3RP38r
 Azbuj3qiQmtjqhnJlFOWW/SwIsDr0soO2XYG5bPKu3gEyyeWmiCYsejOMfAmc2wOQNFiWUt+hU
 WdTZrjVlKiTyU0omatI2KSYDoB5AXPFrW/EO9VTh81Q0fZT1esC07BYHOCizsCccXdZCmJbIIV
 KSCIYTyYzqY0umMKyKFcE6XW
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:02:10 -0800
IronPort-SDR: zesvOpAdR44Fw6U3wGeKJ8+j9ZzQVQOxnjj3YaVwB89+AD4UsIqSq918sl7gZeDcua9M6dlB3Y
 b5xgreWKVeZbEmj4njzcup8Ltg66649r1B9dFWdRmQh5acufBvBMPRSGij96fTOjhz9Yiz4ttb
 vZXT6hE29U3ZWYwAWj9wf3lzRYlWRj/skkKnTskD29XceUU2kRRMBM//+OYMSbXEsYqV3efwKI
 ekt4XyrB1Vc6TnKF7xze4BQYmdp/yXAQD3eQ3BT6xDfbUNsI+3iOWMyMQztcsZg+gL3Owlx7lp
 EQc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:32 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JzwgW1hDJz1SVp2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:31 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104630; x=1647696631; bh=dH4sxA9AmlZnS/GYur
        +GQZPteUwIE//gjMPrygAXHE4=; b=Zr/F/ACcpYr/Whkb7YKMciJR1BQ5mkgWb1
        HuMioXDUPJ8UwHCGtJEle3ERuNU/tcWx3fqRCz/qafhzfINCgBRa5f8/8TMSlz8m
        7514aaQkdYFBZSbKi7xbDOREqEIuGT+6MfodX2LWmUuaz9Yd/DTwwuoZn1oVW2px
        +wLeLyxZR8aRyTYmnaPokbuEnhkm7sLbaTX9puta7NjOV0W2atEZKq1/Z1mKcAU9
        01uevxoBor/42qWdZb20jZPl9psaH5BU13RLRO4AJrJG5SvxxXpdSSSj7C4cbU1K
        CcJYVPNqe26NMCLZ51aUF0eradMqUvzaeEY5QJX2Tst5EsdBgX5Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 4osQ7H2u9pKi for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:30 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JzwgT3jt3z1SVnx;
        Thu, 17 Feb 2022 05:30:29 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 22/31] scsi: pm8001: Fix tag leaks on error
Date:   Thu, 17 Feb 2022 22:29:47 +0900
Message-Id: <20220217132956.484818-23-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In pm8001_chip_set_dev_state_req(), pm8001_chip_fw_flash_update_req()
and pm8001_chip_reg_dev_req() add missing calls to pm8001_tag_free() to
free the allocated tag when pm8001_mpi_build_cmd() fails.

Similarly, in pm8001_exec_internal_task_abort(), if the chip
->task_abort method fails, the tag allocated for the abort request task
must be freed. Add the missing call to pm8001_tag_free(). Also remove
the useless ex_err label and use "break" instead of "goto" statements
in the retry loop.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c |  9 +++++++++
 drivers/scsi/pm8001/pm8001_sas.c | 33 +++++++++++++++++---------------
 2 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index cc96e58454c8..431fc9160637 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4458,6 +4458,9 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hb=
a_info *pm8001_ha,
 		SAS_ADDR_SIZE);
 	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
 			sizeof(payload), 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
+
 	return rc;
 }
=20
@@ -4870,6 +4873,9 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_i=
nfo *pm8001_ha,
 	ccb->ccb_tag =3D tag;
 	rc =3D pm8001_chip_fw_flash_update_build(pm8001_ha, &flash_update_info,
 		tag);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
+
 	return rc;
 }
=20
@@ -4974,6 +4980,9 @@ pm8001_chip_set_dev_state_req(struct pm8001_hba_inf=
o *pm8001_ha,
 	payload.nds =3D cpu_to_le32(state);
 	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
 			sizeof(payload), 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
+
 	return rc;
=20
 }
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
index d0f5feb4f2d3..0440777a9135 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -834,7 +834,8 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_inf=
o *pm8001_ha,
=20
 		res =3D pm8001_tag_alloc(pm8001_ha, &ccb_tag);
 		if (res)
-			goto ex_err;
+			break;
+
 		ccb =3D &pm8001_ha->ccb_info[ccb_tag];
 		ccb->device =3D pm8001_dev;
 		ccb->ccb_tag =3D ccb_tag;
@@ -843,36 +844,38 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_i=
nfo *pm8001_ha,
=20
 		res =3D PM8001_CHIP_DISP->task_abort(pm8001_ha,
 			pm8001_dev, flag, task_tag, ccb_tag);
-
 		if (res) {
 			del_timer(&task->slow_task->timer);
-			pm8001_dbg(pm8001_ha, FAIL, "Executing internal task failed\n");
-			goto ex_err;
+			pm8001_dbg(pm8001_ha, FAIL,
+				   "Executing internal task failed\n");
+			pm8001_tag_free(pm8001_ha, ccb_tag);
+			break;
 		}
+
 		wait_for_completion(&task->slow_task->completion);
 		res =3D TMF_RESP_FUNC_FAILED;
+
 		/* Even TMF timed out, return direct. */
 		if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
 			pm8001_dbg(pm8001_ha, FAIL, "TMF task timeout.\n");
-			goto ex_err;
+			break;
 		}
=20
 		if (task->task_status.resp =3D=3D SAS_TASK_COMPLETE &&
 			task->task_status.stat =3D=3D SAS_SAM_STAT_GOOD) {
 			res =3D TMF_RESP_FUNC_COMPLETE;
 			break;
-
-		} else {
-			pm8001_dbg(pm8001_ha, EH,
-				   " Task to dev %016llx response: 0x%x status 0x%x\n",
-				   SAS_ADDR(dev->sas_addr),
-				   task->task_status.resp,
-				   task->task_status.stat);
-			sas_free_task(task);
-			task =3D NULL;
 		}
+
+		pm8001_dbg(pm8001_ha, EH,
+			   " Task to dev %016llx response: 0x%x status 0x%x\n",
+			   SAS_ADDR(dev->sas_addr),
+			   task->task_status.resp,
+			   task->task_status.stat);
+		sas_free_task(task);
+		task =3D NULL;
 	}
-ex_err:
+
 	BUG_ON(retry =3D=3D 3 && task !=3D NULL);
 	sas_free_task(task);
 	return res;
--=20
2.34.1

