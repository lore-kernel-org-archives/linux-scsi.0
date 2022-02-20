Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1540EC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243427AbiBTDTa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:19:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242505AbiBTDTF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:19:05 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E80340CD
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327125; x=1676863125;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cVLfE2ARMTCIVjN7No5d+rL7rcPTNAHsN17sOgkyRHA=;
  b=DZTZZGEND18YDe0d0mvQgPkQv3iycgZZmBDiQ+atEURyWXiCacC8rWOB
   JFdUX4Go8zC4bVvmrIW0QKVISRRRKe7azb7PYJ1BKC70Lpdi2bjxvSwUk
   AsLlUTZfGL4kMBN+xDVuN6mkaK+pFMgrLt0ZI/cNggBTyhD0IkHq9qweJ
   w1e5nOxo/ooJUP6yO7RoGc4F6ueLHlWMCp6UNV73d/Io1K8wqFwv3B6mr
   p7n6kJnYe2CrdpMVqkWgkf+Q3J5c4vWHNsT8NoDG8M2Yysf7rsPHBUkQV
   lJQ4Io5d19sw76HRMbSW71ihJIU2PMfE1Tosqjs6mKZ6wVMVSpxYYs896
   g==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405798"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:45 +0800
IronPort-SDR: CZxND97Gi3iX86R6CURjACxNRrx+kATSY0wjn2mjL3h9q0oehDWdsmNUVfn75sA21D5L23tpGj
 mLocHz0e8J4vuDE7v+izzNwTrnesNmkyHexsLmEHpEaj+Cmz+xmuYl0COh7CPgT0w30OmBIX/b
 XyZJynOBf8oxftzF8uZKYlJYbRfaCBcMrtWTVHDhhRdMZS1XJFnIKTViYlEpS2IolzkFUySZfI
 enccybjaB5KI+AM2r8Jz25uL7AS5AXi9Oc7Z+A52g4NMHjfNQpDamnxBsE7k2e4gDi0eDvvfdp
 HC/QjRgN5gp7GCFRFVCAmo/K
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:50:20 -0800
IronPort-SDR: 0GWGC0a65uNzCMz0sbq2VihT8UfWn7mHeWmVHbWm7QKar5HCXO2WxVJyeFj/i7uMrz77HvP8jM
 onCoz4rugVyLxQdjnpKBGVunG6jug9sajwvpWNKJSs1JY50tvT/NAOvJ7+Y4VhY+ftQOnTFbWi
 7f7MWlT5BGqPaFGFdnetdCVOOoM3uqYq0O/TLpWAhjwxbwHZkki02h0EYm3VPVxcdod14JCRAD
 Pf00tuO/bkffEMNluhF40qpV6EpVNv6SAqJTl7iGGFU0MxDBMJHDvZNZtflUGRrObkUwbB7CJV
 gog=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:45 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1VyF07Wnz1SVp1
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:45 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327124; x=1647919125; bh=cVLfE2ARMTCIVjN7No
        5d+rL7rcPTNAHsN17sOgkyRHA=; b=O4HRkAZ8LndCUURBS/hQmPWXxNM4iZIa+y
        q+8R04XbVLHTKmKCYDPVWyLsNWiBnt8D4/A/nP3U0EIGjyCNmLw2C18wR5rBmPT1
        mMWRGWrgFZuhMn+VYIQb6Z0aDl6SulL4LyemHWHHgXAo8OpDnE+Q5adCQeuzzMcj
        surjIAn5jPrm3xF0Eaw2NP2HlERBU73sPCzpumjsA4ha6mnWr/1da5ptrtH72kFF
        +faYvuVEpAb57qG7aZxqHhG7QMcGAVbx0VRfpNARS22DydMqpphK0jILW/fUmV78
        3Qd/Q0QQMYmOmryLfXNdYuiQTDbEYfGIo69+CPgjSaALrvUustyA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 8TOe5WTRDuUe for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:44 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1VyC2kPjz1Rwrw;
        Sat, 19 Feb 2022 19:18:43 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 21/31] scsi: pm8001: Fix tag leaks on error
Date:   Sun, 20 Feb 2022 12:18:00 +0900
Message-Id: <20220220031810.738362-22-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
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
index defac9855d9e..ba7cefb803c3 100644
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
index f409dfa049c0..c26f37c88cac 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -738,10 +738,10 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_i=
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

