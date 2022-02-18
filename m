Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D0FC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbiBRDRi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:17:38 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:58532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbiBRDPo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:44 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6111BBF70
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154122; x=1676690122;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tlHIdFApo5g6hgALfBkITWbmb7bVUTixO9xcTWj6QPw=;
  b=qNn514jwNMBFovOJbDmOYdQs6zBCT7pgQNKYKbdtVuq/lD1O3l337gU7
   WmS+sHiDX1yHPi+kwkZdRjRgv3zka1hYCXpubTdbfpgzzfXFOQxfbsLL+
   mbseIdnJUF077ebzgbEjmdvRZicQcBbRAk9l8M2qJeYQUB2tQQDebuDqW
   UpyV1t9BetCc6Q+um8iWNaL1l3/UZcb4hJD/ycIDSd2cb0JJkBcsDkJYX
   RO63H6zjgvbzDZAbc1ErKCeAwZB602Uwxq/6vAkBpGWQo9efovfoRHtof
   B37odRXWfLVP+3OarqfTGuYpVd89Yhoc0cWMtPS0ziuXJLvMbY0PNYfd5
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="198074198"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:15:22 +0800
IronPort-SDR: m8Z5yXsRTpymrC/iNrpVRaMwSP8a3rb3nf6c9bXHunkRyZ3qysQS5wj0XcL6oDld+k9NMZ7sRW
 9OmrmZR5bE8yzbDaTZZ+yD47Q/S0tysHAVi511JLtRper5ZJvRHRa+hYrh/lyqQGai+NcewyMZ
 5wQwEszqaDfE56NC08bX+bN82zWU+7qgcc2RHlgfP4JN7YBYH5BgyYeJM34jKIr8t4YgIdWABF
 coxlkSAVkk+WFP0KHhgUCn3DqMrSFS2lgsqDcEHIjhxN9Z3co9lN5Rq7c8ga1/0PMnSzVPitip
 d2QkbyeBITDDSN7dH4QYZ5f2
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:47:01 -0800
IronPort-SDR: gcCLiBeuOlUDHtUUt5h31/R2Svtc+XLEcvGHlU7MVPnsg6xW9745OCboLDCVq/kypOQ0hERLDP
 X9Jjfh92SDZzkT1a7JBMHTPEqhpdyvgpvTcs+pgr8eWOkkpNgsvPtwFd2eUX10LCNkxEj3ZUkG
 MnlUUaSPx8mLJ2PBkXFlVDKkPwS5C1Wlkr6wApNCmFQAvrpSffITxrM3TO4z444eqL6TzPP9/8
 Sl2Zu48HWU32EOxwZF31rHVSpfP5ZIDfFrTHXOkbpugt0HxNNkKyfztH65Xsv2yo9qLrgIuQOj
 /PE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:15:23 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0GzH08FDz1SVp4
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:23 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154122; x=1647746123; bh=tlHIdFApo5g6hgALfB
        kITWbmb7bVUTixO9xcTWj6QPw=; b=O+Dki+ZZDFDu05JMo/YJq3KS+lenmuQvzA
        praSPXzIf3qCEDB1cOURhwAo3h+SUFU441zFy/RrEMO+fhD7C+KM7uNMJRSlS1ma
        eFbpkr6NJ1T4Z5+dlitrIY0ZevlxTTUf49c/4PTLAaYxdZbzvmGexouHP43tklbn
        69oTYql1mUazNkTD9/HiRYlQs1YT+K8Uwj0s42MVZcLlBYaxBjeIwYQ+CE75IMoK
        NMaW+O+vPrrxVqEPzjfVpgZqpTWSlFlZBtNqTz/iutg3aryFuwWqrIRqvR6C9itP
        EkZfAXpn2I4QOqHuEaYRQoe8mpdPCdszYF1cL4KO1tFHkCt/L62w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Ja9cBsloVKHs for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:15:22 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0GzF2zh4z1Rwrw;
        Thu, 17 Feb 2022 19:15:21 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 24/31] scsi: pm8001: Cleanup pm8001_exec_internal_task_abort()
Date:   Fri, 18 Feb 2022 12:14:38 +0900
Message-Id: <20220218031445.548767-25-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
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
index 3e186cd6792d..98a25f158615 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -829,50 +829,54 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_i=
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

