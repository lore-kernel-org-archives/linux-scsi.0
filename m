Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C10C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243413AbiBTDTL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:19:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240614AbiBTDTD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:19:03 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17226340CD
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327122; x=1676863122;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I/9M3iBe0UPPyMeEFV/Y0UfCTDQKGPaDwzMHmZnBLAU=;
  b=KNx4xHQQhiDJaWznC1NcDt51L6o6M7lD2DWNU2uPeeq++fm+mtLFfmVk
   eYKKl0ILnXdVXItGjquWrXaXfa6NGy72EEa7dl7Hbd8x/U5YH1NUcWmkU
   R4RlvC64zkdIKlaiz7XGkbj71oh5ssbOPkRV1UfIA6GZmuF3+mWIKXlpn
   bV1IsZkYrLMcD/EVqE+Zc2uEnxlmpheosm6GLGtTr0/sC4ms8bhfpBGwC
   LCf0VWlPf4261ALp1lF+Ooq4r2ABygEeJqavN8r3a1bY3IrzRZEXAxp7G
   DxXulMwo+ZYCB6W++cFEOiLyEvb5nKLPI7DX+9FFQnQzdgpwLe+geV4re
   A==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405789"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:42 +0800
IronPort-SDR: PbFvW/gQioto8FGDZXMIK4XJg/6zFyCWZGdQXA8JEla+0uDpKttsnm0YafdkOIc5zAti/n7DSZ
 7IVQLpIAnTgahSkD52U+bZRuL5e5tx6fUdOvT6hLHpMXlGgsqHxYjmPCyGG8M094RS1g/+PM4+
 pXf5XtNM9JkRfqQ/NNWbUVjVJuO3H1bGfdrm91r3q6rG1bL5srWH0kyTeEwJP2b4sEEayNyfkv
 8RZ8wzI36VTWgQ5DydIBYM410mXbMfuoHcciD6oZUYrEsPwZH5sYxHYpW3tZi9pLxqLgowPe4P
 ghlgaFUm6nUjQWFzZPXEU3FT
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:50:18 -0800
IronPort-SDR: +XHHgtpYErAXxbiZvm2+/GcIOa0mUeFBsfuT84chlEnLbBEnqMyb1nmCjtlWWzjNgO5jkqq7zy
 yZbNBLnF7YiUqm1AI6ytbfN9r+AUu8rG2LsH7P3OWFxGOQ3f2KRZcs62zM3UH96Sp1Ax/69Xkx
 8ULa0abjh0jHlCWQ+xJer800OOVkuF6BY5o3QzL0JVqdOF5FEUgqd2JWGEdIC7KJDUx7+O2REy
 iLOEd2eCe3uv7HqO34vJz31ryAxRR2+Y7jSklCld+QtIcY3hBy7XuNGXgcxkZAmi0iJawJTNmm
 Fzk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:43 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1VyB3jPzz1SVp2
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:42 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327121; x=1647919122; bh=I/9M3iBe0UPPyMeEFV
        /Y0UfCTDQKGPaDwzMHmZnBLAU=; b=sNh2aI29OGiXbDD/hBkoNgK+jlUNc6yJEa
        nB0gIF2zyalwb7nD5Jy/sZOVQkiA3D1mTzX8yyONt10T1F9Yl8GOSyz45cZF1Rpp
        iGonemKGNR6TzByGo80DvxLGDxbyIjR1QKceU1uq0Zdz+zf+0+N5SvjlyfpZDgtQ
        IEQSKRQxoNqr8CZjKrlhpTga1/vBSgnPxXriDv3pBBwhphXg2aOPnECnu8T0p7Pb
        A/D6Qclo45UGRy38bNu+Nwr+xQa4QV0dJwbrak/thpj7Vxg/nJWV2rti5EdegNqR
        O2z5AOHv7yiaaFXbFLxGNMDje3pLPRZTCaG4QCxryLVXhYju7jXg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 0_yzCgdqYXQB for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:41 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1Vy82WGWz1Rwrw;
        Sat, 19 Feb 2022 19:18:40 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 19/31] scsi: pm8001: Fix tag values handling
Date:   Sun, 20 Feb 2022 12:17:58 +0900
Message-Id: <20220220031810.738362-20-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The function pm8001_tag_alloc() determines free tags using the function
find_first_zero_bit() which can return 0 when the first bit of the
bitmap being inspected is 0. As such, tag 0 is a valid tag value that
should not be dismissed as invalid. Fix the functions pm8001_work_fn(),
mpi_sata_completion(), pm8001_mpi_task_abort_resp() and
pm8001_open_reject_retry() to not dismiss 0 tags as invalid.

The value 0xffffffff is used for invalid tags for unused ccb
information structures. Add the macro definition PM8001_INVALID_TAG to
define this value.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c  | 52 +++++++++++--------------------
 drivers/scsi/pm8001/pm8001_init.c |  3 +-
 drivers/scsi/pm8001/pm8001_sas.c  | 13 ++++----
 drivers/scsi/pm8001/pm8001_sas.h  |  2 ++
 drivers/scsi/pm8001/pm80xx_hwi.c  |  5 ---
 5 files changed, 28 insertions(+), 47 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index be57b9ae5486..6f9ee77cc576 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1522,7 +1522,6 @@ void pm8001_work_fn(struct work_struct *work)
 	case IO_XFER_ERROR_BREAK:
 	{	/* This one stashes the sas_task instead */
 		struct sas_task *t =3D (struct sas_task *)pm8001_dev;
-		u32 tag;
 		struct pm8001_ccb_info *ccb;
 		struct pm8001_hba_info *pm8001_ha =3D pw->pm8001_ha;
 		unsigned long flags, flags1;
@@ -1544,8 +1543,8 @@ void pm8001_work_fn(struct work_struct *work)
 		/* Search for a possible ccb that matches the task */
 		for (i =3D 0; ccb =3D NULL, i < PM8001_MAX_CCB; i++) {
 			ccb =3D &pm8001_ha->ccb_info[i];
-			tag =3D ccb->ccb_tag;
-			if ((tag !=3D 0xFFFFFFFF) && (ccb->task =3D=3D t))
+			if ((ccb->ccb_tag !=3D PM8001_INVALID_TAG) &&
+			    (ccb->task =3D=3D t))
 				break;
 		}
 		if (!ccb) {
@@ -1566,11 +1565,11 @@ void pm8001_work_fn(struct work_struct *work)
 			spin_unlock_irqrestore(&t->task_state_lock, flags1);
 			pm8001_dbg(pm8001_ha, FAIL, "task 0x%p done with event 0x%x resp 0x%x=
 stat 0x%x but aborted by upper layer!\n",
 				   t, pw->handler, ts->resp, ts->stat);
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free(pm8001_ha, t, ccb, ccb->ccb_tag);
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 		} else {
 			spin_unlock_irqrestore(&t->task_state_lock, flags1);
-			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
+			pm8001_ccb_task_free(pm8001_ha, t, ccb, ccb->ccb_tag);
 			mb();/* in order to force CPU ordering */
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			t->task_done(t);
@@ -1579,7 +1578,6 @@ void pm8001_work_fn(struct work_struct *work)
 	case IO_XFER_OPEN_RETRY_TIMEOUT:
 	{	/* This one stashes the sas_task instead */
 		struct sas_task *t =3D (struct sas_task *)pm8001_dev;
-		u32 tag;
 		struct pm8001_ccb_info *ccb;
 		struct pm8001_hba_info *pm8001_ha =3D pw->pm8001_ha;
 		unsigned long flags, flags1;
@@ -1613,8 +1611,8 @@ void pm8001_work_fn(struct work_struct *work)
 		/* Search for a possible ccb that matches the task */
 		for (i =3D 0; ccb =3D NULL, i < PM8001_MAX_CCB; i++) {
 			ccb =3D &pm8001_ha->ccb_info[i];
-			tag =3D ccb->ccb_tag;
-			if ((tag !=3D 0xFFFFFFFF) && (ccb->task =3D=3D t))
+			if ((ccb->ccb_tag !=3D PM8001_INVALID_TAG) &&
+			    (ccb->task =3D=3D t))
 				break;
 		}
 		if (!ccb) {
@@ -1685,19 +1683,13 @@ void pm8001_work_fn(struct work_struct *work)
 		struct task_status_struct *ts;
 		struct sas_task *task;
 		int i;
-		u32 tag, device_id;
+		u32 device_id;
=20
 		for (i =3D 0; ccb =3D NULL, i < PM8001_MAX_CCB; i++) {
 			ccb =3D &pm8001_ha->ccb_info[i];
 			task =3D ccb->task;
 			ts =3D &task->task_status;
-			tag =3D ccb->ccb_tag;
-			/* check if tag is NULL */
-			if (!tag) {
-				pm8001_dbg(pm8001_ha, FAIL,
-					"tag Null\n");
-				continue;
-			}
+
 			if (task !=3D NULL) {
 				dev =3D task->dev;
 				if (!dev) {
@@ -1706,10 +1698,11 @@ void pm8001_work_fn(struct work_struct *work)
 					continue;
 				}
 				/*complete sas task and update to top layer */
-				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
+				pm8001_ccb_task_free(pm8001_ha, task, ccb,
+						     ccb->ccb_tag);
 				ts->resp =3D SAS_TASK_COMPLETE;
 				task->task_done(task);
-			} else if (tag !=3D 0xFFFFFFFF) {
+			} else if (ccb->ccb_tag !=3D PM8001_INVALID_TAG) {
 				/* complete the internal commands/non-sas task */
 				pm8001_dev =3D ccb->device;
 				if (pm8001_dev->dcompletion) {
@@ -1717,7 +1710,7 @@ void pm8001_work_fn(struct work_struct *work)
 					pm8001_dev->dcompletion =3D NULL;
 				}
 				complete(pm8001_ha->nvmd_completion);
-				pm8001_tag_free(pm8001_ha, tag);
+				pm8001_tag_free(pm8001_ha, ccb->ccb_tag);
 			}
 		}
 		/* Deregister all the device ids  */
@@ -2313,11 +2306,6 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001=
_ha, void *piomb)
 	param =3D le32_to_cpu(psataPayload->param);
 	tag =3D le32_to_cpu(psataPayload->tag);
=20
-	if (!tag) {
-		pm8001_dbg(pm8001_ha, FAIL, "tag null\n");
-		return;
-	}
-
 	ccb =3D &pm8001_ha->ccb_info[tag];
 	t =3D ccb->task;
 	pm8001_dev =3D ccb->device;
@@ -3051,7 +3039,7 @@ void pm8001_mpi_set_dev_state_resp(struct pm8001_hb=
a_info *pm8001_ha,
 		   device_id, pds, nds, status);
 	complete(pm8001_dev->setds_completion);
 	ccb->task =3D NULL;
-	ccb->ccb_tag =3D 0xFFFFFFFF;
+	ccb->ccb_tag =3D PM8001_INVALID_TAG;
 	pm8001_tag_free(pm8001_ha, tag);
 }
=20
@@ -3069,7 +3057,7 @@ void pm8001_mpi_set_nvmd_resp(struct pm8001_hba_inf=
o *pm8001_ha, void *piomb)
 				dlen_status);
 	}
 	ccb->task =3D NULL;
-	ccb->ccb_tag =3D 0xFFFFFFFF;
+	ccb->ccb_tag =3D PM8001_INVALID_TAG;
 	pm8001_tag_free(pm8001_ha, tag);
 }
=20
@@ -3096,7 +3084,7 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm=
8001_ha, void *piomb)
 		 * freed by requesting path anywhere.
 		 */
 		ccb->task =3D NULL;
-		ccb->ccb_tag =3D 0xFFFFFFFF;
+		ccb->ccb_tag =3D PM8001_INVALID_TAG;
 		pm8001_tag_free(pm8001_ha, tag);
 		return;
 	}
@@ -3142,7 +3130,7 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm=
8001_ha, void *piomb)
 	complete(pm8001_ha->nvmd_completion);
 	pm8001_dbg(pm8001_ha, MSG, "Get nvmd data complete!\n");
 	ccb->task =3D NULL;
-	ccb->ccb_tag =3D 0xFFFFFFFF;
+	ccb->ccb_tag =3D PM8001_INVALID_TAG;
 	pm8001_tag_free(pm8001_ha, tag);
 }
=20
@@ -3555,7 +3543,7 @@ int pm8001_mpi_reg_resp(struct pm8001_hba_info *pm8=
001_ha, void *piomb)
 	}
 	complete(pm8001_dev->dcompletion);
 	ccb->task =3D NULL;
-	ccb->ccb_tag =3D 0xFFFFFFFF;
+	ccb->ccb_tag =3D PM8001_INVALID_TAG;
 	pm8001_tag_free(pm8001_ha, htag);
 	return 0;
 }
@@ -3627,7 +3615,7 @@ int pm8001_mpi_fw_flash_update_resp(struct pm8001_h=
ba_info *pm8001_ha,
 	}
 	kfree(ccb->fw_control_context);
 	ccb->task =3D NULL;
-	ccb->ccb_tag =3D 0xFFFFFFFF;
+	ccb->ccb_tag =3D PM8001_INVALID_TAG;
 	pm8001_tag_free(pm8001_ha, tag);
 	complete(pm8001_ha->nvmd_completion);
 	return 0;
@@ -3663,10 +3651,6 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_i=
nfo *pm8001_ha, void *piomb)
=20
 	status =3D le32_to_cpu(pPayload->status);
 	tag =3D le32_to_cpu(pPayload->tag);
-	if (!tag) {
-		pm8001_dbg(pm8001_ha, FAIL, " TAG NULL. RETURNING !!!\n");
-		return -1;
-	}
=20
 	scp =3D le32_to_cpu(pPayload->scp);
 	ccb =3D &pm8001_ha->ccb_info[tag];
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm80=
01_init.c
index 381105286953..9b04f1a6a67d 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1217,10 +1217,11 @@ pm8001_init_ccb_tag(struct pm8001_hba_info *pm800=
1_ha, struct Scsi_Host *shost,
 			goto err_out;
 		}
 		pm8001_ha->ccb_info[i].task =3D NULL;
-		pm8001_ha->ccb_info[i].ccb_tag =3D 0xffffffff;
+		pm8001_ha->ccb_info[i].ccb_tag =3D PM8001_INVALID_TAG;
 		pm8001_ha->ccb_info[i].device =3D NULL;
 		++pm8001_ha->tags_num;
 	}
+
 	return 0;
=20
 err_out_noccb:
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
index f5678be4c17b..f409dfa049c0 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -553,7 +553,7 @@ void pm8001_ccb_task_free(struct pm8001_hba_info *pm8=
001_ha,
=20
 	task->lldd_task =3D NULL;
 	ccb->task =3D NULL;
-	ccb->ccb_tag =3D 0xFFFFFFFF;
+	ccb->ccb_tag =3D PM8001_INVALID_TAG;
 	ccb->open_retry =3D 0;
 	pm8001_tag_free(pm8001_ha, ccb_idx);
 }
@@ -831,9 +831,11 @@ void pm8001_open_reject_retry(
 		struct task_status_struct *ts;
 		struct pm8001_device *pm8001_dev;
 		unsigned long flags1;
-		u32 tag;
 		struct pm8001_ccb_info *ccb =3D &pm8001_ha->ccb_info[i];
=20
+		if (ccb->ccb_tag =3D=3D PM8001_INVALID_TAG)
+			continue;
+
 		pm8001_dev =3D ccb->device;
 		if (!pm8001_dev || (pm8001_dev->dev_type =3D=3D SAS_PHY_UNUSED))
 			continue;
@@ -845,9 +847,6 @@ void pm8001_open_reject_retry(
 				continue;
 		} else if (pm8001_dev !=3D device_to_close)
 			continue;
-		tag =3D ccb->ccb_tag;
-		if (!tag || (tag =3D=3D 0xFFFFFFFF))
-			continue;
 		task =3D ccb->task;
 		if (!task || !task->task_done)
 			continue;
@@ -867,11 +866,11 @@ void pm8001_open_reject_retry(
 				& SAS_TASK_STATE_ABORTED))) {
 			spin_unlock_irqrestore(&task->task_state_lock,
 				flags1);
-			pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
+			pm8001_ccb_task_free(pm8001_ha, task, ccb, ccb->ccb_tag);
 		} else {
 			spin_unlock_irqrestore(&task->task_state_lock,
 				flags1);
-			pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
+			pm8001_ccb_task_free(pm8001_ha, task, ccb, ccb->ccb_tag);
 			mb();/* in order to force CPU ordering */
 			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 			task->task_done(task);
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm800=
1_sas.h
index d26f25186779..5082c7dc07ee 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -732,6 +732,8 @@ void pm8001_free_dev(struct pm8001_device *pm8001_dev=
);
 /* ctl shared API */
 extern const struct attribute_group *pm8001_host_groups[];
=20
+#define PM8001_INVALID_TAG	((u32)-1)
+
 static inline void
 pm8001_ccb_task_free_done(struct pm8001_hba_info *pm8001_ha,
 			struct sas_task *task, struct pm8001_ccb_info *ccb,
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 76260d06b6be..cc46e2013eeb 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2402,11 +2402,6 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001=
_ha,
 	param =3D le32_to_cpu(psataPayload->param);
 	tag =3D le32_to_cpu(psataPayload->tag);
=20
-	if (!tag) {
-		pm8001_dbg(pm8001_ha, FAIL, "tag null\n");
-		return;
-	}
-
 	ccb =3D &pm8001_ha->ccb_info[tag];
 	t =3D ccb->task;
 	pm8001_dev =3D ccb->device;
--=20
2.34.1

