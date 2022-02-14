Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5722C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239355AbiBNCUR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:20:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239322AbiBNCUG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:20:06 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4115355BC0
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805197; x=1676341197;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=vWpTHLH/qDB7R7jOtg82y/gQrcakEeDhri5rs8gln9c=;
  b=SbOHybQeM3mpeqMbJE5A7QbUlTMBFVGAbY5MjBV0r+mzWWnLJntpHZBi
   DTMMqIZGjIGak40cNdfQ0wKu+IhcvUfJzbwXIciPqKsIM1VuGz7NwSw3G
   j6HG84lPmWvsvC0qZddKwbtHGpqPgp3UicEGsXQKuwvQEynvHgdPNyskL
   KhRcEukf9/q3/zKiEPpLuMEtIoZChsppq/uYDdsDolhqykER4mT5AGaD1
   zSkvQ4F9JjYTeEnOnB579hD8Vj2Z4YvWdksAFRFsas5+dH31SXvU5Dvrl
   HOdbicxXL8mJXVKhMIhRQT8abI8F+EAfbLWiJsEhwDum/qeO/PlP2MFCh
   A==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819804"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:19:57 +0800
IronPort-SDR: pr4/SVgxOwcrDnVlJ6ouj/fNpjQdCjy3nxI+NjxsmnCzVB2zRT5w8UImhxlbbRK2W12sZrFvTW
 24Xl54uwui+z/1E6gkoy88pJuq0Bh6Grp5/vYQDBF1ym6uXjpPFcH8Tl+TEGjyQ65sDTRkrsED
 u6wKpCNr4pksTopKx0Y+JQNpMT3ma2fU62NUtk1X1503s3j5RAGSPxdVXmQ7VTZ2acTZQ6LcHd
 kKX4Nh9MPa3AXINbcQjBgqOH96Ungx//7wLBb13fQ/Oujg8ORKCzYIDoHT8LVo3ShMdGnJgSIb
 iDdyE4Eh1RR4u3pRGGBTg4pL
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:50 -0800
IronPort-SDR: S707ojhYtLy5yFoQkK+SDa1JmdOtJEiCVrjV8MWHwARXAyiiGoCM4upbjUfNGz76H8GIeBaVZW
 KEc+qP03cwLliZxWD2u+tjsdhQTCsOtWga1unBmnrAsmdyO6UqgEMb3rDOepZSmMuXHFevsyB4
 /2g2kx0Ee3h1dr20wrx49+NxXpAOCQP3tMYvlcPmyE0PqHKOwM9aWfgSMFHn8WyqqGhEVHyTB1
 MJnNquOTx50KHtwIQewMCusPnuY3BoDa8delgQRclLE7z/Mued2z3Dd0LrFZifYNspU231Lm9q
 NG4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:19:59 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JxnxB5sYPz1SVnx
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:58 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805198; x=1647397199; bh=vWpTHLH/qDB7R7jOtg
        82y/gQrcakEeDhri5rs8gln9c=; b=PUwBH76xk8J5rGDx3clyUYCv4WRtFHbi9D
        S3yPGoQpKsgLE1s+Iv35PIlOlOT/F09mg6Kq9DibXC2gOYnyukpsfF8VEu34jtXt
        29/mkhljOAb6CPs+zfhRI34pAKA6qxvfdoJKGPOqBJkoCKaevgI1K81tukwjW7eT
        nFfK/a5G/dzgd2bP84KnvRJK4f5xs0+sCNF6DCRyVCZR4M+rjs4iLTVzqEBWsO7q
        mCpu4z8DQOCqsUSQ7MrWxCI06MncL6cNWbVwtMnLjLSvSLxFRKC8Gqqx4aA+eIAZ
        Eh8Nz+ejHZCPtOTn5y5XhkaY9Lzg/26mzIDxnxuKpbyEeoLL9C7w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id tdJw6A1vY1HH for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:19:58 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jxnx92tKKz1SHwl;
        Sun, 13 Feb 2022 18:19:57 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 22/31] scsi: pm8001: Fix tag leaks on error
Date:   Mon, 14 Feb 2022 11:17:38 +0900
Message-Id: <20220214021747.4976-23-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
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
index 5886c7a83238..2eff6e2f6cf9 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4475,6 +4475,9 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hb=
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
@@ -4887,6 +4890,9 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_i=
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
@@ -4991,6 +4997,9 @@ pm8001_chip_set_dev_state_req(struct pm8001_hba_inf=
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
index d9b8d61b7578..1e7031400294 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -829,7 +829,8 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_inf=
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
@@ -838,36 +839,38 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_i=
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

