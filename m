Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0433DC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbiBRDP7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:15:59 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:58548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbiBRDPn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:43 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD281BBF58
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154118; x=1676690118;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g7EBBD7qLhE1YqM6ddgx33476kZlCQryWeE4NMPtD5c=;
  b=P3WVjMQl7ZCZOvoiwr9H3e2Nz5Bi7hs0LalTzgulp+qmVzxIRALcWpZU
   enK+tD5/wIV2HO7KKavoZPtnZpBg5YLIOXSE6JmdOkHGCaMPagTDfZV9c
   Pwv8sqWuPCWA0klJf5QYRvgvSQ7xXpLpCoLvzgvXGWXf0iCzISORLQPPF
   380CKbKP7BilJVXxJPcJoqzYgHtdBicyzt8CPVHOTB1d/WBoLpqysdLte
   kFT7rHc0AgCgmySjB1VMnl6QXnEpL6kWE8Pk43XG3U+IhpFGY6jyFaogV
   6QhdvYm3ZIUn0CUnKmW99FrIyFhuIq7ZzLTahqHhvKtyQ7jZDdd9es6JO
   g==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="198074189"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:15:18 +0800
IronPort-SDR: Kkhkm+0vuDdw6WWDAjJrYGAMUrfrofg+k+Jue8OtTALwUhspjrLXfLRdiZ7B7xoBF7BHa3ne22
 tkFAYzOtLfUG4QTUg+GnbqFk4fBLoWBDL1oGXoeW7Ia2nyE/rJAb24hrUSmGUjmuT8Y9Y6jd4b
 0nDjWHIms51ydN6iEdIC8CribboS2frULd5QMj9K7mGdzuNyLyEOmg2vDlJ0+o+h4Ka5KhpXYc
 JqhOIqxb9xNgCqCTYNtuiVHl0f5zINfPINJyc1jEVNcCJp2aSG4G4n2OZ6VD3BTtnN2Vm5CJ8G
 mpcbY+OPOHC+2gi8sNcF6Mmy
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:46:57 -0800
IronPort-SDR: RuP6VkkNxGYXYc0DTZVFbiZwhNFSSsK0dNJNM1o5ef9ECIoUoPWYtKaEnOnG3sguOIaDWbqwLy
 3IhKGHzw1FUA/vkTiHSrHpL/c2smnbfPKTFd1ZVRfLTnQfB0g4G9G0RBc6GxT8BKZGLhf3PGni
 FQTWGW93iV3yr/yyCxnwtkenyTKIksTh8QXl5CThpzJ99HbeZI5+cYgPzHZ3SAEIpqBufodEQr
 NxoPN8TqsOKaeyaIwbpXxNhKzhudJsBCaRmyu24Xh/ZhIRuV8cfVkfGy1/O0BMhg/GO1IxjAiN
 EgY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:15:19 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0GzB5ysPz1SVp1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:18 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154118; x=1647746119; bh=g7EBBD7qLhE1YqM6dd
        gx33476kZlCQryWeE4NMPtD5c=; b=XsPdkwrqnMV3t1CeBppH5T00WGB650EuV8
        Jd2qNJTvfWR88jpSBrNwvVE/sw6sfIIGa1ta14OE4WeM5GdMALtJr+oLMgvl85F7
        xAQqxEt2c6fZcB2bd/KhlSOv8bPkeYOUQVs9TOwOmLltYSCyblKOYfWdChD11Yyj
        Blzr9Z7+e/knw8M4WkJMQtwmQKdr85hGQzcV0Abm5SuXG9JgalHAnGxeGoXVMcOh
        lu/JvXx4vj2DDCoiizdUjoqBRoTWjeFjCDQcqNZ2WoPRFuCi63STTBzCZoqP3JZ1
        AncJXl+pcHSM3U+SHBQiSPtMeEjQN26kaqKe5LXVClePW0xuTckw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 268xDrJ4qa-F for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:15:18 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0Gz91hYzz1SVnx;
        Thu, 17 Feb 2022 19:15:16 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 21/31] scsi: pm8001: Fix tag leaks on error
Date:   Fri, 18 Feb 2022 12:14:35 +0900
Message-Id: <20220218031445.548767-22-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In pm8001_chip_set_dev_state_req(), pm8001_chip_fw_flash_update_req(),
pm80xx_chip_phy_ctl_req() and pm8001_chip_reg_dev_req() add missing
calls to pm8001_tag_free() to free the allocated tag when
pm8001_mpi_build_cmd() fails.

Similarly, in pm8001_exec_internal_task_abort(), if the chip
->task_abort method fails, the tag allocated for the abort request task
must be freed. Add the missing call to pm8001_tag_free().

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 9 +++++++++
 drivers/scsi/pm8001/pm8001_sas.c | 2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c | 9 +++++++--
 3 files changed, 17 insertions(+), 3 deletions(-)

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
index d0f5feb4f2d3..3e186cd6792d 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -843,10 +843,10 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_i=
nfo *pm8001_ha,
=20
 		res =3D PM8001_CHIP_DISP->task_abort(pm8001_ha,
 			pm8001_dev, flag, task_tag, ccb_tag);
-
 		if (res) {
 			del_timer(&task->slow_task->timer);
 			pm8001_dbg(pm8001_ha, FAIL, "Executing internal task failed\n");
+			pm8001_tag_free(pm8001_ha, ccb_tag);
 			goto ex_err;
 		}
 		wait_for_completion(&task->slow_task->completion);
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index cc46e2013eeb..4419fdb0db78 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4915,8 +4915,13 @@ static int pm80xx_chip_phy_ctl_req(struct pm8001_h=
ba_info *pm8001_ha,
 	payload.tag =3D cpu_to_le32(tag);
 	payload.phyop_phyid =3D
 		cpu_to_le32(((phy_op & 0xFF) << 8) | (phyId & 0xFF));
-	return pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
-			sizeof(payload), 0);
+
+	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+				  sizeof(payload), 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
+
+	return rc;
 }
=20
 static u32 pm80xx_chip_is_our_interrupt(struct pm8001_hba_info *pm8001_h=
a)
--=20
2.34.1

