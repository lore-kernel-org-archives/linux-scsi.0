Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3972EC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 23:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1118920722
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 23:37:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nXiq9CU3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgF3Xhs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 19:37:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51628 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgF3Xhs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 19:37:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UNWKeX049509;
        Tue, 30 Jun 2020 23:37:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=zIO5U64GcqdsevyjRjq2sBrQMtWI9BikmKZ41stJGWQ=;
 b=nXiq9CU34yRnnzbrfd11WcBnciGr1wBb9ZBF++33UthLwbIi/VsbS6P5y/0RCBRoVoKZ
 NPVTWFRv2Pvt4zhc3bJl2djze98CXgVwZ3lyh12AxIXObhfaQgRPX9zpIM0C5mVekXS9
 2d/n4qzzh1cpRSOQ1j9UawPwUvlF92hr+MYCNEyFUuxkU4bo+h0qSBaVGbfJkIRTN36g
 7GR6ayLBgD/u6cqXCkuXM2bHbe/a9Ip2/lyS8Li+WT/CFVWIFeL0y/Hp/6nOZuhyLXvZ
 /AidzTEOP4nzMcePPRj6hcFDnUNtJmE1R4/WYsZt5sGbCh3OO1+ve9ljFjeAHD9k0xOn IQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31xx1dv8cm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 23:37:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UNWcMt187560;
        Tue, 30 Jun 2020 23:35:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 31y52jj1q2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 23:35:41 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05UNZZFk008583;
        Tue, 30 Jun 2020 23:35:40 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 23:35:35 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     cleech@redhat.com, lduncan@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [PATCH 1/4] iscsi class: make sure the block/recovery work are done
Date:   Tue, 30 Jun 2020 18:35:31 -0500
Message-Id: <1593560134-28148-2-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593560134-28148-1-git-send-email-michael.christie@oracle.com>
References: <1593560134-28148-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300163
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When max_active=1 we knew the block work was always before the
unblock and the recovery work had either run or was pending behind the
unblock. With the patch to enable max_active=2:

commit 3ce419662dd4c9cf8db7869c4972ad51ccdf2ee3
Author: Bob Liu <bob.liu@oracle.com>
Date:   Tue May 5 09:19:08 2020 +0800

    scsi: iscsi: Register sysfs for iscsi workqueue

for the iscsi_eh_timer_workq we could have the block or recovery work
works on different threads than the unblock. __iscsi_unblock_session
only tries to cancel the recovery work and so the block work could be
running still, or the recovery work could be running (non pending state)
or we could race and the unblock work could run cancel_delayed_work then
the block work could queue the recovery work.

This patches fixes this by making sure the block and recovery works are
done before updating the session state and its devices.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index f4cc08e..bbf2eb7 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1947,10 +1947,11 @@ static void __iscsi_unblock_session(struct work_struct *work)
 
 	ISCSI_DBG_TRANS_SESSION(session, "Unblocking session\n");
 	/*
-	 * The recovery and unblock work get run from the same workqueue,
-	 * so try to cancel it if it was going to run after this unblock.
+	 * Make sure we do not race with the block or recovery work, so
+	 * they can't overwrite our state update here.
 	 */
-	cancel_delayed_work(&session->recovery_work);
+	flush_work(&session->block_work);
+	cancel_delayed_work_sync(&session->recovery_work);
 	spin_lock_irqsave(&session->lock, flags);
 	session->state = ISCSI_SESSION_LOGGED_IN;
 	spin_unlock_irqrestore(&session->lock, flags);
-- 
1.8.3.1

