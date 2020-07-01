Return-Path: <SRS0=yW27=AM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D5DC433E1
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 19:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F33E2082F
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 19:50:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xr5fLakO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgGATuB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 15:50:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48104 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgGATuA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 15:50:00 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061JlSOb028775;
        Wed, 1 Jul 2020 19:49:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=fkeYCcDXgVQDq+HY9xVcVR87x8sP6CtE5+xjL5dbZNM=;
 b=Xr5fLakO+YnlsVM/ZPOwmTiah45HD/xdwz0cs5EEh3HCtciEv4RhE4+DefB2cv5R0oY/
 FkfsezqXafLoMlswGnfK4EnHOttsAFrtD8SKI9qJCkBDl6QuUeJNbuozeMgnS1tNJID3
 Uiwkdw6o+w0RQt/rZKDk5raHhR2t582M6uoKWl9g/2U7/SvOJpDHemS/NbYbtn8+eAJf
 EejyxKUujBm0GoQqmmT/TcNuJcgr8q0haI0/c+BSYZlK0vVv+4n2Zi86C9s7afv4k6IB
 We4S9J6o1TRTQlemHi1jIriGc9em3xcw9rge/c2PLv84RRst4Z/qRnXBSeU5ulv/KI4+ KA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31ywrbtu59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 01 Jul 2020 19:49:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 061JccOg114140;
        Wed, 1 Jul 2020 19:47:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31xfvueap0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jul 2020 19:47:53 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 061JlqDD023179;
        Wed, 1 Jul 2020 19:47:52 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 01 Jul 2020 19:47:51 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     cleech@redhat.com, lduncan@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: [PATCH 3/3] iscsi class: remove sessdestroylist
Date:   Wed,  1 Jul 2020 14:47:48 -0500
Message-Id: <1593632868-6808-4-git-send-email-michael.christie@oracle.com>
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

Just delete the sess from the session list instead of adding it to some
list we never use.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 80b442a2b4c8..60e6bde1e96c 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1623,7 +1623,6 @@ static DEFINE_MUTEX(rx_queue_mutex);
 static DEFINE_MUTEX(conn_mutex);
 
 static LIST_HEAD(sesslist);
-static LIST_HEAD(sessdestroylist);
 static DEFINE_SPINLOCK(sesslock);
 static LIST_HEAD(connlist);
 static LIST_HEAD(connlist_err);
@@ -2203,7 +2202,8 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
 	ISCSI_DBG_TRANS_SESSION(session, "Removing session\n");
 
 	spin_lock_irqsave(&sesslock, flags);
-	list_del(&session->sess_list);
+	if (!list_empty(&session->sess_list))
+		list_del(&session->sess_list);
 	spin_unlock_irqrestore(&sesslock, flags);
 
 	flush_work(&session->block_work);
@@ -3678,7 +3678,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh, uint32_t *group)
 
 			/* Prevent this session from being found again */
 			spin_lock_irqsave(&sesslock, flags);
-			list_move(&session->sess_list, &sessdestroylist);
+			list_del_init(&session->sess_list);
 			spin_unlock_irqrestore(&sesslock, flags);
 
 			queue_work(iscsi_destroy_workq, &session->destroy_work);
-- 
2.18.2

