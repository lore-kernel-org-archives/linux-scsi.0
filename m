Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2BFDC71155
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 21:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62B172086A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 21:31:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pOZbGUaJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388128AbgLAVbD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 16:31:03 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57246 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729335AbgLAVbC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 16:31:02 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LSuTP081049;
        Tue, 1 Dec 2020 21:30:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=fkRovDNiYxLoydWfMZ9RPNbtQ5bCCtqKzQ4tk6IreQM=;
 b=pOZbGUaJVzWYWZk7mE2nbk4UyJzSJ5HDRpr6mH74dGG0Y6LDwXOGrUwoS4XVJAC3Dxcm
 JTFFgYbihJSJrgvPfNvvMixTCnlIThu1lYZgEZA+w+D63ku2+v5ayVJR9wGhdbmutBXT
 Yon4zhx9Vi+0stCGzhZrVoF9sDRUXLrgjOvVbj/lLgzJ5AlPY5x73TD7kafXTyTlqVEO
 dX9Z4LFA8WeB9b+LU5OXGnou8vwp62rZkzPQ1H48CEHuAqP2p1nkpRPOUVR8rhEL8emy
 Lcmcu+p567jthBWQEJ+cgUtNYLl/FK1jN7UsyZ2d8zgMmg1RY4dIyZSAA1CtmWFtph4Q iQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 353egkmw5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 21:30:13 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LBL7C164011;
        Tue, 1 Dec 2020 21:30:12 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3540fxkwpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 21:30:12 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B1LU9qU021009;
        Tue, 1 Dec 2020 21:30:11 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 13:30:08 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com,
        jitendra.bhivare@broadcom.com, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, varun@chelsio.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH 06/15] libiscsi: drop frwd lock for session state
Date:   Tue,  1 Dec 2020 15:29:47 -0600
Message-Id: <1606858196-5421-7-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
References: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This drops the frwd lock for the session state checks in queuecommand.
Like with the transport class case, we only need it as a hint since when
the session is cleaned up we will block the session which flushes the
queues, and then we clean up all running IO. So the locking just prevents
cleaning up extra cmds.

It is still needed:
1. when accessing suspend_tx in queuecomand because drivers that
implement ep_disconnect will set that bit from disconnect (called
before stop) and expect that no new commands will be queued to it.
Note that the comment for this was wrong and that is fixed in this
patch.

2. the list addition for the drivers that use the iscsi xmit wq.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 10 +++++++---
 include/scsi/libiscsi.h |  5 +++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 1296a10..12bfb5a 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1704,7 +1704,6 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 
 	cls_session = starget_to_session(scsi_target(sc->device));
 	session = cls_session->dd_data;
-	spin_lock_bh(&session->frwd_lock);
 
 	reason = iscsi_session_chkready(cls_session);
 	if (reason) {
@@ -1761,7 +1760,9 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 		goto fault;
 	}
 
+	spin_lock_bh(&session->frwd_lock);
 	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
+		spin_unlock_bh(&session->frwd_lock);
 		reason = FAILURE_SESSION_IN_RECOVERY;
 		sc->result = DID_REQUEUE << 16;
 		goto fault;
@@ -1769,6 +1770,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 
 	task = iscsi_alloc_task(conn, sc);
 	if (!task) {
+		spin_unlock_bh(&session->frwd_lock);
 		reason = FAILURE_OOM;
 		goto reject;
 	}
@@ -1803,21 +1805,23 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	return 0;
 
 prepd_reject:
+	spin_unlock_bh(&session->frwd_lock);
+
 	spin_lock_bh(&session->back_lock);
 	iscsi_complete_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
 	spin_unlock_bh(&session->back_lock);
 reject:
-	spin_unlock_bh(&session->frwd_lock);
 	ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
 			  sc->cmnd[0], reason);
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
 prepd_fault:
+	spin_unlock_bh(&session->frwd_lock);
+
 	spin_lock_bh(&session->back_lock);
 	iscsi_complete_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
 	spin_unlock_bh(&session->back_lock);
 fault:
-	spin_unlock_bh(&session->frwd_lock);
 	ISCSI_DBG_SESSION(session, "iscsi: cmd 0x%x is not queued (%d)\n",
 			  sc->cmnd[0], reason);
 	scsi_set_resid(sc, scsi_bufflen(sc));
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index b649ec5..25dbc5d 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -326,8 +326,9 @@ struct iscsi_session {
 	 * can enclose the mutual exclusion zone protected by the backward lock
 	 * but not vice versa.
 	 */
-	spinlock_t		frwd_lock;	/* protects session state, *
-						 * cmdsn and session       *
+	spinlock_t		frwd_lock;	/* protects session state  *
+						 * in the eh paths, cmdsn  *
+						 * suspend bit and session *
 						 * resources:              *
 						 * - cmdpool kfifo_out ,   *
 						 * - mgmtpool, queues	   */
-- 
1.8.3.1

