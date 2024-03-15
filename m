Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B34182BF
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 10:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710497191; cv=none; b=MDj54tKXzx5O8DeIii1CJ8G9k7qgkrYLYZPkQQbcPUJclxC0uJTQdH78Ay7aAZ/fYROiKarZenR7VE5g6MFbwF2/txWZCSnQDBwTZ9Ue6fpDQJJ/bw8FtMwK+8S4iUjNbwsvExc4ZJY6XKjfe6WQV2W7NNa4ITnNIVQaI2L/yIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710497191; c=relaxed/simple;
	bh=j1X1Yf++OMbBarXOI3AE83b7LSwuZCwJFiZct/LPDaQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I4GrmBKUKnpaxUK1f7J+VTsDjPc2ARptkiRGkMeZJh44dIf5zL2mUDmyVXm1MFyO9qzUMC9fZfWdrpvydiWgLe9PA07vrtCDbeJnRQrT7WYIrp6EcjhAJpcCme8d2VSV7wu7FGJ21VKtPvwDSHwsddo2oq/wZE5zF8g0u5yaaU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=MVGr5G6D; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="MVGr5G6D"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 42F8eL3l005217
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 03:06:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=t23veuEWtOz3RqASGNERkIGFQomb3bTm0R89QfH/CuA=; b=MVG
	r5G6D4LLNuZG/trNZsm8nOPpnxWFIn7ZS41Mvf+P4ojkRjqRnAXGHhDH5yd1bnOr
	XANi+mO/guRx+ehwh3vjOmUQuxWJ6n2toI6nI2NZSQLQ3iOoWsP/PEaVX4FXgh6W
	N3fNzKfVUYbPD4tzao98eoavwe2xQ9OsGYIc65Tn419Pj/KYngEbsCSpnnirN7X2
	wjkU1QRyjbOP7qEY1rM5E1xlSYoiuQmOm/NhpPsquV0WUT9BzxzDbsfaOaeb1mOl
	qkvCg3ACCUyAbhoaXhgnCqcaRF2at4mO2ej+fjYQFUgqdkRXzgbbje17ynfSJ6qw
	Im1Mtz0IRJVq9vfWcBg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3wvk1c080n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 03:06:28 -0700 (PDT)
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Fri, 15 Mar
 2024 03:06:27 -0700
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Fri, 15 Mar 2024 03:06:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1258.12 via Frontend
 Transport; Fri, 15 Mar 2024 03:06:27 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id C9A983F703F;
	Fri, 15 Mar 2024 03:06:25 -0700 (PDT)
From: Saurav Kashyap <skashyap@marvell.com>
To: <martin.petersen@oracle.com>
CC: <GR-QLogic-Storage-Upstream@marvell.com>, <linux-scsi@vger.kernel.org>,
        Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>
Subject: [PATCH 2/3] qedf: Wait for stag work during unload.
Date: Fri, 15 Mar 2024 15:35:59 +0530
Message-ID: <20240315100600.19568-3-skashyap@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240315100600.19568-1-skashyap@marvell.com>
References: <20240315100600.19568-1-skashyap@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: XJAeODjhGV2AyoTHV82WBL8-2r0KrmuR
X-Proofpoint-ORIG-GUID: XJAeODjhGV2AyoTHV82WBL8-2r0KrmuR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-14_13,2024-03-13_01,2023-05-22_02

If stag work is already schedule and unload is called, it can
lead to issues as unload cleanups the work element, wait for
stag work to get completed before cleanup during unload.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qedf/qedf.h      |  1 +
 drivers/scsi/qedf/qedf_main.c | 26 +++++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index 5058e01b65a2..98afdfe63600 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -363,6 +363,7 @@ struct qedf_ctx {
 #define QEDF_IN_RECOVERY		5
 #define QEDF_DBG_STOP_IO		6
 #define QEDF_PROBING			8
+#define QEDF_STAG_IN_PROGRESS		9
 	unsigned long flags; /* Miscellaneous state flags */
 	int fipvlan_retries;
 	u8 num_queues;
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index e882aec86765..d441054dadb7 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -318,11 +318,18 @@ static struct fc_seq *qedf_elsct_send(struct fc_lport *lport, u32 did,
 	 */
 	if (resp == fc_lport_flogi_resp) {
 		qedf->flogi_cnt++;
+		qedf->flogi_pending++;
+
+		if (test_bit(QEDF_UNLOADING, &qedf->flags)) {
+			QEDF_ERR(&qedf->dbg_ctx, "Driver unloading\n");
+			qedf->flogi_pending = 0;
+		}
+
 		if (qedf->flogi_pending >= QEDF_FLOGI_RETRY_CNT) {
 			schedule_delayed_work(&qedf->stag_work, 2);
 			return NULL;
 		}
-		qedf->flogi_pending++;
+
 		return fc_elsct_send(lport, did, fp, op, qedf_flogi_resp,
 		    arg, timeout);
 	}
@@ -913,6 +920,7 @@ void qedf_ctx_soft_reset(struct fc_lport *lport)
 	struct qed_link_output if_link;
 
 	if (lport->vport) {
+		clear_bit(QEDF_STAG_IN_PROGRESS, &qedf->flags);
 		printk_ratelimited("Cannot issue host reset on NPIV port.\n");
 		return;
 	}
@@ -938,6 +946,7 @@ void qedf_ctx_soft_reset(struct fc_lport *lport)
 	if (!if_link.link_up) {
 		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC,
 			  "Physical link is not up.\n");
+		clear_bit(QEDF_STAG_IN_PROGRESS, &qedf->flags);
 		return;
 	}
 	/* Flush and wait to make sure link down is processed */
@@ -950,6 +959,7 @@ void qedf_ctx_soft_reset(struct fc_lport *lport)
 		  "Queue link up work.\n");
 	queue_delayed_work(qedf->link_update_wq, &qedf->link_update,
 	    0);
+	clear_bit(QEDF_STAG_IN_PROGRESS, &qedf->flags);
 }
 
 /* Reset the host by gracefully logging out and then logging back in */
@@ -3721,6 +3731,7 @@ static void __qedf_remove(struct pci_dev *pdev, int mode)
 {
 	struct qedf_ctx *qedf;
 	int rc;
+	int cnt = 0;
 
 	if (!pdev) {
 		QEDF_ERR(NULL, "pdev is NULL.\n");
@@ -3738,6 +3749,17 @@ static void __qedf_remove(struct pci_dev *pdev, int mode)
 		return;
 	}
 
+stag_in_prog:
+	if (test_bit(QEDF_STAG_IN_PROGRESS, &qedf->flags)) {
+		QEDF_ERR(&qedf->dbg_ctx, "Stag in progress, cnt=%d.\n", cnt);
+		cnt++;
+
+		if (cnt < 5) {
+			msleep(500);
+			goto stag_in_prog;
+		}
+	}
+
 	if (mode != QEDF_MODE_RECOVERY)
 		set_bit(QEDF_UNLOADING, &qedf->flags);
 
@@ -4013,6 +4035,8 @@ void qedf_stag_change_work(struct work_struct *work)
 		return;
 	}
 
+	set_bit(QEDF_STAG_IN_PROGRESS, &qedf->flags);
+
 	printk_ratelimited("[%s]:[%s:%d]:%d: Performing software context reset.",
 			dev_name(&qedf->pdev->dev), __func__, __LINE__,
 			qedf->dbg_ctx.host_no);
-- 
2.23.1

