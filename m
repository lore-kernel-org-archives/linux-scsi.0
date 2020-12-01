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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A407C64E7B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 21:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2569C2084C
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 21:31:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BmEbJHmf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388076AbgLAVbD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 16:31:03 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46688 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbgLAVbC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 16:31:02 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LTILo018671;
        Tue, 1 Dec 2020 21:30:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=00Zr2SVzXyr2MZpcZ6QDW2xtDcP75Hl+13WArqet4o0=;
 b=BmEbJHmfuhsKsAsVgK4WMX/hGJz11ctHTx9af/m1T5n1bJ4OH+9zjH0T8Gcm2G7mAfgz
 QkXk6JttUrdeSaS3P/DBsR411CJ43hF0wtH+GGEAtZ3gyUfzKK2h4YP04mlqHfS+0cq2
 BL1AWgknSblChu5/vf28wjnztPqzdYUAbzYHjiDP1aT9jlfkwzDsf6ZCEwIeQVYu5PPe
 iCKJimMp7oL7p45r5IRUMzD5Z4aqxyz+TrWW+H4Zhfekr5KS1Pnfk5J6bFYrsrxHyIsd
 rkxOdwpRXE1KC6fKFaspRI+0DTvfVmVCEyAIZEpUE4KMM+eHuDbUwknPEabkR7SCMwkh gA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 353dyqmy1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 21:30:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LBKsZ163974;
        Tue, 1 Dec 2020 21:30:09 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3540fxkwky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 21:30:09 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B1LU7Yd021021;
        Tue, 1 Dec 2020 21:30:07 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 13:30:07 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com,
        jitendra.bhivare@broadcom.com, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, varun@chelsio.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH 04/15] iscsi class: drop session lock in iscsi_session_chkready
Date:   Tue,  1 Dec 2020 15:29:45 -0600
Message-Id: <1606858196-5421-5-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
References: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010130
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

