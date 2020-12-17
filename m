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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0516C3526E
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4D332389B
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgLQGnc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 01:43:32 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55062 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgLQGnb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2020 01:43:31 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6Toek146768;
        Thu, 17 Dec 2020 06:42:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=GA5wFcEDzzAptqA73Gi7KABUNaXVoBPMFQQVNw103Is=;
 b=YrrDMfH/edlS60idaMSYC1103DphLnsyyucAsGiNZ7SjrZG6/CTuemuS/MWSNX9h4Ngf
 ZTq4Mm+QdAU1eGkpaDTUWigSlRfsh/W2naerWDDAZVnaaQUfxqj4PnhTE8/0BnlEk9SA
 hB6d4NYY6DZF9N/4H5J5w+/xSZjoJXLD4dkzWMc1PJ/YfJrEK3QWj2jeKSlluE4KVrIF
 md3qzvjasJl5fE4GC6UXN+ziusV4rg4wMIKoZJx6jt31Om8BrmNxX5F/r08Lul7nC7da
 hVcd8I9Su0nhKl8gtVy6tnsiggs650ayUWot+AXF0wvYvz/jLsXi3wtGG+g+5p2Q6ENn Qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 35ckcbm1rf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Dec 2020 06:42:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6VGcL143512;
        Thu, 17 Dec 2020 06:42:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35d7eqfagu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 06:42:40 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BH6gciT006688;
        Thu, 17 Dec 2020 06:42:38 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Dec 2020 22:42:38 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH 21/22] libiscsi: drop back_lock from xmit path
Date:   Thu, 17 Dec 2020 00:42:11 -0600
Message-Id: <1608187332-4434-22-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
References: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxscore=0 mlxlogscore=960 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=987
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170047
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
index 869c38d..6516900 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1473,8 +1473,6 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, bool has_extra_ref)
 		/* done with this task */
 		task->last_xfer = jiffies;
 	}
-	/* regular RX path uses back_lock */
-	spin_lock(&conn->session->back_lock);
 	if (rc && task->state == ISCSI_TASK_RUNNING) {
 		/*
 		 * get an extra ref that is released next time we access it
@@ -1483,7 +1481,6 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, bool has_extra_ref)
 		iscsi_get_task(task);
 		conn->task = task;
 	}
-	spin_unlock(&conn->session->back_lock);
 
 put_task:
 	iscsi_put_task(task);
-- 
1.8.3.1

