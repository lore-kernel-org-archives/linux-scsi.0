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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFD2BC2BBCA
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A08423884
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgLQGnU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 01:43:20 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:47652 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgLQGnR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2020 01:43:17 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6TrrL164257;
        Thu, 17 Dec 2020 06:42:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=up1FB0VaxJd7CcKaOce0cLFTurd/hpj+G7LtFqauk2Y=;
 b=zUvuVid+uiEkh4INDwy8de1hZY2fA1Fs54fpgGl+LdhgyyTJ6t9wGiZ8Y0U4Iz+zuhh0
 KegJFnisvGr9ZE4jAdgjOe/E0QyaIJfp0/mOqhsKFSi7ciHZBbWJwRIHVvIJorhERcqT
 yODxoGTOxaiDOzYfakzzvh1YANCxsIt4XDaUfsa3y7QBBQMX5aJDxaOjv5OHISQUZyhw
 06UmaEg2HIUNj6i6G3iB+HcQqY+TIDR1pfEjY5jmmZc8CnD0ug9X17mdEMsisZqpDAzc
 MkMXG7M3UH2Exr8/Vw1tjyJ9J6w63QUxjyQ9hA1Q0Z90vLqoBJqj0+tZJVnDlJlEQB/q vg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35cntmbudm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Dec 2020 06:42:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6VCVC019997;
        Thu, 17 Dec 2020 06:42:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 35e6esvfr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 06:42:25 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BH6gOkS018113;
        Thu, 17 Dec 2020 06:42:24 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Dec 2020 22:42:24 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH 05/22] iscsi class: drop session lock in iscsi_session_chkready
Date:   Thu, 17 Dec 2020 00:41:55 -0600
Message-Id: <1608187332-4434-6-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
References: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
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

The session lock in iscsi_session_chkready is not needed because when we
transition from logged into to another state we will blocked and/or
remove the devices under the session, so no new IO will be sent the
drivers after the block/remove. IO that races with the block/removal is
cleaned up by the drivers when it handles all outstanding IO, so this
just added an extra lock in the main IO path. This patch removes the
lock like other transport classes.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2eb3e4f..e9ad04a 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1701,10 +1701,8 @@ static const char *iscsi_session_state_name(int state)
 
 int iscsi_session_chkready(struct iscsi_cls_session *session)
 {
-	unsigned long flags;
 	int err;
 
-	spin_lock_irqsave(&session->lock, flags);
 	switch (session->state) {
 	case ISCSI_SESSION_LOGGED_IN:
 		err = 0;
@@ -1719,7 +1717,6 @@ int iscsi_session_chkready(struct iscsi_cls_session *session)
 		err = DID_NO_CONNECT << 16;
 		break;
 	}
-	spin_unlock_irqrestore(&session->lock, flags);
 	return err;
 }
 EXPORT_SYMBOL_GPL(iscsi_session_chkready);
-- 
1.8.3.1

