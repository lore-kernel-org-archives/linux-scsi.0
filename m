Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7054FC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237502AbiBTDTh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:19:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243407AbiBTDTJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:19:09 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F3C340D2
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327129; x=1676863129;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1xeafIdaW3IGXUiFvb5jh90tQpCsmAXWyaCBFXB/Ung=;
  b=S+wHt2RU/XVu6/MXvWFNlYu8WsNPE+QAQGfywg7t5TCdx4hKXxz412qk
   XCG5heXDJrKd23NAyQE9I4ByWSibo1jJv2El0Phqj+1w8r5f6h0h/VquU
   zv1FQrIn/kurHJHasGgcR62nSt05pnvm51M+pGkD57R3KgoYnzAgU/b0U
   K/itQHQQ4CEK2lJOb4ojO/vITVzjWjWFoLqHZEUkLG2Sk8eK9IIpNtqxp
   uH8Fjo4W5ZL4n8O0Fd1f9nvkZS6nAfRatusIm9SdJsFTk9G4ubc8UBcG4
   uqUiAdYsq/sLicfFwQA0uQYPIvOahTg1J3AXcIEtwAKNbX/Nn1u+JRouP
   w==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405811"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:48 +0800
IronPort-SDR: Mjb1nh+hZg1zHoLInEnWdgSRGp75ihvka7CRNoG2s5rnVo1CtHGsgh8muPdotgXMlWnnErpnlC
 jtacnNL049pW3zOBc/C3W5J6KpNFGNXLxCKeQHkkVffWU/TglcS0cbS0WjL1SywdtUmY2cgF2R
 kHCinfXyv6rk73kjFZ7Mnd6ct3Gea1juDzY//2bsoquMAx3SFmRhM6oyPVtB6ggyW7ms4jg21G
 1e8y2BhgGIMU6V+k3upyXj8qZAe0e51dVgbjXq5jsfw2JLAVasGbykTFQNAbj8ZwhS0ix5mDBp
 N7kHWFjjaFYzoDKp07TtzZ0c
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:50:24 -0800
IronPort-SDR: vSo8yqqxOOPaX4IqI1xM3oMZvUtHu8JTxqeq2OZ3lFSLNnLaEaBQn2H8ikKUnQYLji5vferD4t
 Z3KMma4PahrGJ/OvlPnl4SjuSMgm7c/klnSmv7kHu1X8xwfCY519ONtT7IlPy3NE49RdYo+ubV
 LLjsY8fv1BdXx7wVD6TXzPNIebn2t/lHtXZZGRXWG/ZxDqQvpivWt8FHB+bvVIPOOFvTjcPhP0
 ZIDVJKz5deotUoCbYOlhuNmTUMQAJxrguuU7bX+kaFJmxvjKD7Uh3iQCw/yknRfSzQBfr+Kx24
 Hhw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:49 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1VyJ6sZJz1SHwl
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:48 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327128; x=1647919129; bh=1xeafIdaW3IGXUiFvb
        5jh90tQpCsmAXWyaCBFXB/Ung=; b=kOJV/jyJTQpUNg+oLfNgb0uUWpa5yzMV3W
        QIYG1SMzyWudL92GNX386vbJfJ+noedR4dyJR6Hb1busRmxDBoh2spg1soi3efOk
        TMimqYs7ON7dVUxotKkxdJ/S5/J5B96Y/0ha3NAoqNNV8WUZDMV/fTwZqXAIP8id
        f6rYG+H/YUFu2+YzllSZjx08rEeAkEI0PGD3lCl25+Vse1nwncMS2pyH0aha6bIg
        xEC8mZ0yWWllCPASWf+T7Orkt8jvEnvLuIhgW/nH4BX5zG2ZSuV6FLnWEfklQAfR
        pLFu5H3/fTgEBVnVHrEyxI72iWbCyC1VScwM8S46agDrmj/kzDCA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id luBpD9a9Gouf for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:48 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1VyH35S7z1Rvlx;
        Sat, 19 Feb 2022 19:18:47 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 24/31] scsi: pm8001: Cleanup pm8001_exec_internal_task_abort()
Date:   Sun, 20 Feb 2022 12:18:03 +0900
Message-Id: <20220220031810.738362-25-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace the goto statement in the for loop with "break" and remove the
ex_err label. Also fix long lines, identation and blank lines to make
the code more readable.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 38 ++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
index c26f37c88cac..b41f3aa6ce3e 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -724,50 +724,54 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_i=
nfo *pm8001_ha,
 		task->task_proto =3D dev->tproto;
 		task->task_done =3D pm8001_task_done;
 		task->slow_task->timer.function =3D pm8001_tmf_timedout;
-		task->slow_task->timer.expires =3D jiffies + PM8001_TASK_TIMEOUT * HZ;
+		task->slow_task->timer.expires =3D
+			jiffies + PM8001_TASK_TIMEOUT * HZ;
 		add_timer(&task->slow_task->timer);
=20
 		res =3D pm8001_tag_alloc(pm8001_ha, &ccb_tag);
 		if (res)
-			goto ex_err;
+			break;
+
 		ccb =3D &pm8001_ha->ccb_info[ccb_tag];
 		ccb->device =3D pm8001_dev;
 		ccb->ccb_tag =3D ccb_tag;
 		ccb->task =3D task;
 		ccb->n_elem =3D 0;
=20
-		res =3D PM8001_CHIP_DISP->task_abort(pm8001_ha,
-			pm8001_dev, flag, task_tag, ccb_tag);
+		res =3D PM8001_CHIP_DISP->task_abort(pm8001_ha, pm8001_dev, flag,
+						   task_tag, ccb_tag);
 		if (res) {
 			del_timer(&task->slow_task->timer);
-			pm8001_dbg(pm8001_ha, FAIL, "Executing internal task failed\n");
+			pm8001_dbg(pm8001_ha, FAIL,
+				   "Executing internal task failed\n");
 			pm8001_tag_free(pm8001_ha, ccb_tag);
-			goto ex_err;
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

