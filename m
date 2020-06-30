Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B6AC433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 23:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8164320780
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 23:35:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zHzAgH+5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgF3Xfu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 19:35:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35498 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgF3Xft (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 19:35:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UNWGTv011121;
        Tue, 30 Jun 2020 23:35:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=6YsuJ3mlzl9g2yunSMZCeNPAfaw2piOOPLje1+wpPwA=;
 b=zHzAgH+5djDBbt8n/o8+vmprB4OK1lW5/1vKHgpXJEwiBp7NhpJeMZ0cih+hJyGOhadv
 nNh1Qas6SNmjKp6t5T8XU5CEdnsTKc99tucT5CGnZOt3WO9SD5JJhBUvea9LB4vD/N4e
 gHTk0EMptJsfyL2jMWzEJgA1brFdg1IIwc/rUyKDjyFKtp6Qlzrm4ybSyDZtP3lllzlL
 1nUG+aOb2bVQEun0HmfBO8Mc7NUnlaCzhAMJ3F5Zyt5YPQ2bDV2kSRsgsN78ozwhzI2Z
 Z3JzuJY02eoYIC8BEL67lDzFvecEftx1G8rZCWPuAMRK0andjIaU6AaJZ3PDPJF+7/hk kw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31wxrn7c00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 23:35:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UNWhWt137113;
        Tue, 30 Jun 2020 23:35:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31xg14ps08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 23:35:40 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05UNZaXr002884;
        Tue, 30 Jun 2020 23:35:39 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 23:35:36 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     cleech@redhat.com, lduncan@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [PATCH 3/4] iscsi class: optimize work queue flush use
Date:   Tue, 30 Jun 2020 18:35:33 -0500
Message-Id: <1593560134-28148-4-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593560134-28148-1-git-send-email-michael.christie@oracle.com>
References: <1593560134-28148-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006300163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9668 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300163
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no need for one session to flush the entire
iscsi_eh_timer_workq when removing/unblocking a session. During removal
we need to make sure our works are not running anymore. And
iscsi_unblock_session only needs to make sure it's work is done. The
unblock work function will flush/cancel the works it has conflicts with.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2be28d8..2b3af43 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1979,10 +1979,11 @@ void iscsi_unblock_session(struct iscsi_cls_session *session)
 {
 	queue_work(iscsi_eh_timer_workq, &session->unblock_work);
 	/*
-	 * make sure all the events have completed before tell the driver
-	 * it is safe
+	 * Blocking the session can be done from any context so we only
+	 * queue the block work. Make sure the unblock work has completed
+	 * because it flushes/cancels the other works and updates the state.
 	 */
-	flush_workqueue(iscsi_eh_timer_workq);
+	flush_work(&session->unblock_work);
 }
 EXPORT_SYMBOL_GPL(iscsi_unblock_session);
 
@@ -2206,11 +2207,9 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
 	list_del(&session->sess_list);
 	spin_unlock_irqrestore(&sesslock, flags);
 
-	/* make sure there are no blocks/unblocks queued */
-	flush_workqueue(iscsi_eh_timer_workq);
-	/* make sure the timedout callout is not running */
-	if (!cancel_delayed_work(&session->recovery_work))
-		flush_workqueue(iscsi_eh_timer_workq);
+	flush_work(&session->block_work);
+	flush_work(&session->unblock_work);
+	cancel_delayed_work_sync(&session->recovery_work);
 	/*
 	 * If we are blocked let commands flow again. The lld or iscsi
 	 * layer should set up the queuecommand to fail commands.
-- 
1.8.3.1

