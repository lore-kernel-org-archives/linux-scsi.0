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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 651AFC8301F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 21:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 035E02084C
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 21:31:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IzVjYdWv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389431AbgLAVbR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 16:31:17 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:57664 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389212AbgLAVbR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 16:31:17 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LSuFn081051;
        Tue, 1 Dec 2020 21:30:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=N0YnQBKlJajllbONjcZL6EQUDDZahTbINdKQ+U4dROU=;
 b=IzVjYdWvweOJm/fnbCyjF6KMyxkUEjFdgTFTGw4XzenA6uzh41a+rGLm6v4BFfs8lceb
 dHszfCmtB9+k/LAwM9ShGlPswRK1X9U9EvPFQ0TOWnrxradK7/MLOPGMVK+7P1vqZ5Of
 7SEaK6x1EOGHbqnBj0qcrlHP4p+B5fDPOyCcMqJ4Vd+MM4N0n6uoYUCMdpsM8xqeddan
 IG47g9ZPJFr+K2Elii+FHcC/B2EZn1NL4TkED0YiIwqLtKXind3Guwi+xlHtoCc07DMB
 d7ZwdLKsIpBj/cb+mH0i4bpUx+BREJstS/lRESWQAaNikdCvVk8JItDccYYcSOVMH8hs Lw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 353egkmw65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 21:30:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LUP5L121460;
        Tue, 1 Dec 2020 21:30:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 35404ndkqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 21:30:26 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B1LUFee021142;
        Tue, 1 Dec 2020 21:30:15 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 13:30:14 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com,
        jitendra.bhivare@broadcom.com, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, varun@chelsio.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH 14/15] libiscsi: drop back_lock from xmit path
Date:   Tue,  1 Dec 2020 15:29:55 -0600
Message-Id: <1606858196-5421-15-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
References: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=933 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=2
 phishscore=0 mlxlogscore=966 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have a proper refcount on the task so if we get a rsp while R2Ts are
queued then we will not crash. We only need to check if a rsp has been
processed and if we race it's ok since with a bad target we could get
this rsp at any time like after dropping the lock and starting to send
data so the lock use doesn't matter.

This patch just drops the lock since we will eventually either see
the updated state or we will send all the data and free the task.
I'm not 100% sure though and am thinking we might want to use READ/
WRITE_ONCE or use a barrier?

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 0643156..e020fba 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1529,8 +1529,6 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, bool has_extra_ref)
 		/* done with this task */
 		task->last_xfer = jiffies;
 	}
-	/* regular RX path uses back_lock */
-	spin_lock(&conn->session->back_lock);
 	if (rc && task->state == ISCSI_TASK_RUNNING) {
 		/*
 		 * get an extra ref that is released next time we access it
@@ -1539,7 +1537,6 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, bool has_extra_ref)
 		iscsi_get_task(task);
 		conn->task = task;
 	}
-	spin_unlock(&conn->session->back_lock);
 
 put_task:
 	iscsi_put_task(task);
-- 
1.8.3.1

