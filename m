Return-Path: <SRS0=yW27=AM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF55C433E1
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 19:48:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9AE22082F
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 19:48:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="z/xlZnmm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgGATsB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 15:48:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46678 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbgGATsB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 15:48:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061JlOpC028715;
        Wed, 1 Jul 2020 19:47:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=4A+5oamYVYQ5K0erulFWe9Yz5d1LSJG/20lN2f0CJFA=;
 b=z/xlZnmmSERbQEIAxGbMqVLnD3ahKxTsxbaksOsvX5cdCX0qyLkNjIwSIclch2E2IPYn
 75chPFj/m79RvWrqmhMZbf8v2F2QnSSCaRPVkoQ47nlzY0JmmSc6iawPW+4IA/jXthhH
 rVeSt9Ig1eVXfYtjvBRisvhEChyg4gUCOLPryHbpDzHXPRdw3TrAaVkUYFTvRavPdGVy
 HcZRjFy3rI0667v4UNMku0sDgZiKNhDyXEMkH4HGNiy60XBRCjieV3De2FL0IwAVNCgd
 KvfRgwseE0gBO9JIVkST/dx+zniMJCBjH6+lvXL57tgXKm0l8giiSC+8lURWG2LukDtZ 1g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31ywrbttuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 01 Jul 2020 19:47:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061JccDx114198;
        Wed, 1 Jul 2020 19:47:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 31xfvueanv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jul 2020 19:47:52 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 061JlpFq006410;
        Wed, 1 Jul 2020 19:47:51 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Jul 2020 19:47:51 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     cleech@redhat.com, lduncan@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [PATCH 2/3] iscsi class: optimize work queue flush use
Date:   Wed,  1 Jul 2020 14:47:47 -0500
Message-Id: <1593632868-6808-3-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593632868-6808-1-git-send-email-michael.christie@oracle.com>
References: <1593632868-6808-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 clxscore=1015 cotscore=-2147483648 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007010138
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
index 2cd2610ecfaf..80b442a2b4c8 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1978,10 +1978,11 @@ void iscsi_unblock_session(struct iscsi_cls_session *session)
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
 
@@ -2205,11 +2206,9 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
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
2.18.2

