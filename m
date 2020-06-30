Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA6E6C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 23:35:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FA2D20722
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 23:35:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E+qJGHob"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgF3Xfu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 19:35:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35496 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbgF3Xft (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 19:35:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UNWLe1011137;
        Tue, 30 Jun 2020 23:35:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=vVICrlJAS2PqSjeeB2xQKLiJ2RKt33flFfhW6cec9QA=;
 b=E+qJGHobcy3fK6x9dEGLqBLaP5vdj66Z4/z5lSyB7DWhqmpkx5L2jAjo+6DEjOBlW2gs
 AAaIh9J9OaWK01ku6jIeaIMi40t/WL2z6LLpdm8n1f6VUOHws0Qo7d2TWNSSLLck0sCN
 uTfd0gc2PRIVMxig+AeeaRDsD4ZvL0nS0YNZGNYP3n+w65tlvOAQ523mUifZ8CWS6pGC
 jMk/RFoMdY2rCAlAmvc6EUA0D+gB5NTOAC9ES4xVCdW9U5tJpUy4sbNqCiH8yqH/PBIO
 wOGJWQqPtXD1wMf7W3mspKq5J13LXy+bnkPckuQUSX7Nr2ZVVDwqMPk2j0CKAg7TfmSH 3g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31wxrn7byy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 30 Jun 2020 23:35:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05UNWhgY137074;
        Tue, 30 Jun 2020 23:35:40 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31xg14ps0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jun 2020 23:35:40 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05UNZbtr008588;
        Tue, 30 Jun 2020 23:35:39 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jun 2020 23:35:37 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     cleech@redhat.com, lduncan@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [PATCH 4/4] iscsi class: remove sessdestroylist
Date:   Tue, 30 Jun 2020 18:35:34 -0500
Message-Id: <1593560134-28148-5-git-send-email-michael.christie@oracle.com>
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
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1011
 malwarescore=0 phishscore=0 adultscore=0 cotscore=-2147483648
 lowpriorityscore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300163
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Just delete the sess from the session list instead of adding it to some
list we never use.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2b3af43..85a68cb 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1623,7 +1623,6 @@ static DECLARE_TRANSPORT_CLASS(iscsi_connection_class,
 static DEFINE_MUTEX(conn_mutex);
 
 static LIST_HEAD(sesslist);
-static LIST_HEAD(sessdestroylist);
 static DEFINE_SPINLOCK(sesslock);
 static LIST_HEAD(connlist);
 static LIST_HEAD(connlist_err);
@@ -2204,7 +2203,8 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
 	ISCSI_DBG_TRANS_SESSION(session, "Removing session\n");
 
 	spin_lock_irqsave(&sesslock, flags);
-	list_del(&session->sess_list);
+	if (!list_empty(&session->sess_list))
+		list_del(&session->sess_list);
 	spin_unlock_irqrestore(&sesslock, flags);
 
 	flush_work(&session->block_work);
@@ -3679,7 +3679,7 @@ static int iscsi_logout_flashnode_sid(struct iscsi_transport *transport,
 
 			/* Prevent this session from being found again */
 			spin_lock_irqsave(&sesslock, flags);
-			list_move(&session->sess_list, &sessdestroylist);
+			list_del_init(&session->sess_list);
 			spin_unlock_irqrestore(&sesslock, flags);
 
 			queue_work(iscsi_destroy_workq, &session->destroy_work);
-- 
1.8.3.1

