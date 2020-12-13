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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9B7C4167B
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13AE22310B
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Dec 2020 03:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390159AbgLMDKh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Dec 2020 22:10:37 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57180 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388749AbgLMDKF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Dec 2020 22:10:05 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD35lKG075302;
        Sun, 13 Dec 2020 03:09:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=MDvY8GNiKFjvMCjjqwTmiq+siKQJfK4D0bE4TBJRIFk=;
 b=AAe4fh8o7ckIwdnzf3jXzzrBXbJbShPC+9A7kVaD1TBrt1SFT99OxsrFewEv+oORvNz3
 BLy5RAzPXLTTwZIg+4eXCxJCJOUS5n+2vD6NWrfQBX0+YY7kB70CmMegaMafI/vJVnWJ
 uBA3dCBQMJ4uBXGP4goJJz/9eIndfFk92JCi0+FvxTBAwAUGhmJTVb70qEKRjBCbNcEe
 f09BZ2DtJ+6L+x+pXqtthQTLw5ZfGOkDw+4DHxuVwtBdRWOqFWUZwfJaRmRqbdQU/qTH
 +VEZuA8f7nyX65eqB0R3LCGhQdRNgjMFxMVw9GxwOBdZBXdrKt1n5p9dIVF1l3quENMQ vw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 35cn9r1jb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 13 Dec 2020 03:09:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BD34rix122123;
        Sun, 13 Dec 2020 03:09:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 35d7mnkn1p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Dec 2020 03:09:14 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BD39DOH015098;
        Sun, 13 Dec 2020 03:09:13 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 12 Dec 2020 19:09:12 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [RFC PATCH 17/18] libiscsi: drop back_lock from xmit path
Date:   Sat, 12 Dec 2020 21:08:45 -0600
Message-Id: <1607828926-3658-18-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607828926-3658-1-git-send-email-michael.christie@oracle.com>
References: <1607828926-3658-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9833 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=878 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012130023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9833 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=905
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012130023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We have a proper refcount on the task so if we get a rsp while R2Ts are
queued then we will not crash. We only need to check if a rsp has been
processed and if we race it's ok since with a bad target we could get
this rsp at any time like after dropping the lock and starting to send
data so the lock use doesn't matter.

This patch just drops the lock since we will eventually either see
the updated state and stop early or we will send all the data. Either
way we will not free the task until all refs have been dropped.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f4881f0..05e329b 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1537,8 +1537,6 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, bool has_extra_ref)
 		/* done with this task */
 		task->last_xfer = jiffies;
 	}
-	/* regular RX path uses back_lock */
-	spin_lock(&conn->session->back_lock);
 	if (rc && task->state == ISCSI_TASK_RUNNING) {
 		/*
 		 * get an extra ref that is released next time we access it
@@ -1547,7 +1545,6 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, bool has_extra_ref)
 		iscsi_get_task(task);
 		conn->task = task;
 	}
-	spin_unlock(&conn->session->back_lock);
 
 put_task:
 	iscsi_put_task(task);
-- 
1.8.3.1

