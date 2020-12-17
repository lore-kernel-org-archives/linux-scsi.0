Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E8FC35270
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE30F2388E
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgLQGn1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 01:43:27 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47792 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgLQGn0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2020 01:43:26 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6Tk7u164200;
        Thu, 17 Dec 2020 06:42:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=cc20LU3ca+oS4aOayzS8H7mmdPCfIOHidDK/nqgEJTw=;
 b=Q/KvoVTgG4Fs2ecoHMAqy8mHNBUyi/5jmo+ZifNXsxDh+z1FSolu9ijlAQozVU4KZbQc
 JwObJW8hnWMDzoZ+EF8WBVsdDz7qXvTasEdJadqKdOQppYe0Bj8l0mL96TNxpTxCBSUK
 VfMfTB7FDuY57/RZZdhGhnO4tOw9ZyUZfFcNDUT0cnAJ7KtoYeiYNMrBQbrSueF1oyts
 tPx9E5caIpQ+zrDFeOv/EqAtaJ4tpkD1Y3ikgGDWlMAgTgLdc0V+EyV7R7gXqlFIdV6b
 esSnv1wI5fKAp+9/N0t6rcjOlgvnENmgzuOnMlYmNS/Ln5+M5v5okTSItzX+Qb+T+lUH rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35cntmbue5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Dec 2020 06:42:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6VFoC178150;
        Thu, 17 Dec 2020 06:42:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 35e6jts200-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 06:42:35 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BH6gYva019169;
        Thu, 17 Dec 2020 06:42:34 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Dec 2020 22:42:34 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH 16/22] be2iscsi: use scsi_host_busy_iter
Date:   Thu, 17 Dec 2020 00:42:06 -0600
Message-Id: <1608187332-4434-17-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
References: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170047
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the iscsi scsi_host_busy_iter helper so we are not digging
into libiscsi structs and because the session cmds array is
being removed.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/be2iscsi/be_main.c | 97 ++++++++++++++++++++++++-----------------
 1 file changed, 57 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 221ce17..bb305ee 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -265,19 +265,59 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 	return iscsi_eh_abort(sc);
 }
 
+struct beiscsi_invldt_cmd_tbl {
+	struct invldt_cmd_tbl tbl[BE_INVLDT_CMD_TBL_SZ];
+	struct iscsi_task *task[BE_INVLDT_CMD_TBL_SZ];
+};
+
+static bool beiscsi_dev_reset_sc_iter(struct scsi_cmnd *sc, void *data,
+				      bool rsvd)
+{
+	struct iscsi_task *task = (struct iscsi_task *)sc->SCp.ptr;
+	struct iscsi_sc_iter_data *iter_data = data;
+	struct beiscsi_invldt_cmd_tbl *inv_tbl = iter_data->data;
+	struct beiscsi_conn *beiscsi_conn = iter_data->conn->dd_data;
+	struct beiscsi_hba *phba = beiscsi_conn->phba;
+	int nents = iter_data->rc;
+	struct beiscsi_io_task *io_task;
+
+	/*
+	 * Can't fit in more cmds? Normally this won't happen b'coz
+	 * BEISCSI_CMD_PER_LUN is same as BE_INVLDT_CMD_TBL_SZ.
+	 */
+	if (iter_data->rc == BE_INVLDT_CMD_TBL_SZ)
+		return false;
+
+	/* get a task ref till FW processes the req for the ICD used */
+	__iscsi_get_task(task);
+	io_task = task->dd_data;
+	/* mark WRB invalid which have been not processed by FW yet */
+	if (is_chip_be2_be3r(phba)) {
+		AMAP_SET_BITS(struct amap_iscsi_wrb, invld,
+			      io_task->pwrb_handle->pwrb, 1);
+	} else {
+		AMAP_SET_BITS(struct amap_iscsi_wrb_v2, invld,
+			      io_task->pwrb_handle->pwrb, 1);
+	}
+
+	inv_tbl->tbl[nents].cid = beiscsi_conn->beiscsi_conn_cid;
+	inv_tbl->tbl[nents].icd = io_task->psgl_handle->sgl_index;
+	inv_tbl->task[nents] = task;
+	nents++;
+
+	iter_data->rc = nents;
+	return true;
+}
+
 static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 {
-	struct beiscsi_invldt_cmd_tbl {
-		struct invldt_cmd_tbl tbl[BE_INVLDT_CMD_TBL_SZ];
-		struct iscsi_task *task[BE_INVLDT_CMD_TBL_SZ];
-	} *inv_tbl;
+	struct iscsi_sc_iter_data iter_data;
+	struct beiscsi_invldt_cmd_tbl *inv_tbl;
 	struct iscsi_cls_session *cls_session;
 	struct beiscsi_conn *beiscsi_conn;
-	struct beiscsi_io_task *io_task;
 	struct iscsi_session *session;
 	struct beiscsi_hba *phba;
 	struct iscsi_conn *conn;
-	struct iscsi_task *task;
 	unsigned int i, nents;
 	int rc, more = 0;
 
@@ -301,45 +341,22 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 			    "BM_%d : invldt_cmd_tbl alloc failed\n");
 		return FAILED;
 	}
-	nents = 0;
-	/* take back_lock to prevent task from getting cleaned up under us */
-	spin_lock(&session->back_lock);
-	for (i = 0; i < conn->session->cmds_max; i++) {
-		task = conn->session->cmds[i];
-		if (!task->sc)
-			continue;
 
-		if (sc->device->lun != task->sc->device->lun)
-			continue;
-		/**
-		 * Can't fit in more cmds? Normally this won't happen b'coz
-		 * BEISCSI_CMD_PER_LUN is same as BE_INVLDT_CMD_TBL_SZ.
-		 */
-		if (nents == BE_INVLDT_CMD_TBL_SZ) {
-			more = 1;
-			break;
-		}
+	iter_data.data = inv_tbl;
+	iter_data.conn = conn;
+	iter_data.lun = sc->device->lun;
+	iter_data.rc = 0;
+	iter_data.fn = beiscsi_dev_reset_sc_iter;
 
-		/* get a task ref till FW processes the req for the ICD used */
-		__iscsi_get_task(task);
-		io_task = task->dd_data;
-		/* mark WRB invalid which have been not processed by FW yet */
-		if (is_chip_be2_be3r(phba)) {
-			AMAP_SET_BITS(struct amap_iscsi_wrb, invld,
-				      io_task->pwrb_handle->pwrb, 1);
-		} else {
-			AMAP_SET_BITS(struct amap_iscsi_wrb_v2, invld,
-				      io_task->pwrb_handle->pwrb, 1);
-		}
-
-		inv_tbl->tbl[nents].cid = beiscsi_conn->beiscsi_conn_cid;
-		inv_tbl->tbl[nents].icd = io_task->psgl_handle->sgl_index;
-		inv_tbl->task[nents] = task;
-		nents++;
-	}
+	spin_lock(&session->back_lock);
+	iscsi_conn_for_each_sc(session->host, &iter_data);
 	spin_unlock(&session->back_lock);
 	spin_unlock_bh(&session->frwd_lock);
 
+	nents = iter_data.rc;
+	if (nents == BE_INVLDT_CMD_TBL_SZ)
+		more = 1;
+
 	rc = SUCCESS;
 	if (!nents)
 		goto end_reset;
-- 
1.8.3.1

