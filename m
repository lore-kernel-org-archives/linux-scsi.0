Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC50C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 02:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A1DF22DCC
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 02:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgLUCia (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 21:38:30 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:38570 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgLUCi3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 21:38:29 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BL2UMQI102551;
        Mon, 21 Dec 2020 02:37:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=PMi4j0kU8U3BQem9TfgoSNxAN0JzFCnc5oDmAJqyptI=;
 b=BtCkp0yNg+UQSoH07n76c11yrbYnzB81ixgRh0nL8gHJnZs1FXXcsb4QJQS7QRm5ZfWA
 xEGc1rk3ZtAS9ILnv2iwTBC1fIhyjd0xJ59E5mU2yQAp8IMSmqTvTFoqEBJK31dkSATB
 TuV4P9Nnc3hRCOu9oLv1JhauPZ+JoyCw7llUs+fz/JbDN0NdO85ZxxxlyerPNDvMwUJb
 dwRsJQCNjtwhVWwFcCoa3XRWu+/MED6jX+xBYTePc8I87NQXZnqO3Eqx9gUxeDdju8tZ
 G0WtcuK6tFsmnIVKWmdJV2Sdgxi8ckO/Frdfjw7cxUwf8SHFe4LKibs27F8nMN/N10q5 IA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 35h71augrj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 21 Dec 2020 02:37:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BL2aaJb119613;
        Mon, 21 Dec 2020 02:37:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 35huev06g1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Dec 2020 02:37:31 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BL2bNmr013169;
        Mon, 21 Dec 2020 02:37:26 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 20 Dec 2020 18:37:23 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
Subject: [PATCH 1/6 V3] libiscsi: fix iscsi_prep_scsi_cmd_pdu error handling
Date:   Sun, 20 Dec 2020 20:37:01 -0600
Message-Id: <1608518226-30376-2-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608518226-30376-1-git-send-email-michael.christie@oracle.com>
References: <1608518226-30376-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9841 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012210018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9841 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 impostorscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012210017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If iscsi_prep_scsi_cmd_pdu fails we try to add it back to the
cmdqueue, but we leave it partially setup. We don't have functions
that can undo the pdu and init task setup. We only have cleanup_task
which can cleanup both parts. So this has us just fail the cmd and
go through the standard cleanup routine and then have scsi-ml retry
it like is done when it fails in the queuecommand path.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/libiscsi.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f9314f1..ee0786b 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1532,14 +1532,9 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
 		}
 		rc = iscsi_prep_scsi_cmd_pdu(conn->task);
 		if (rc) {
-			if (rc == -ENOMEM || rc == -EACCES) {
-				spin_lock_bh(&conn->taskqueuelock);
-				list_add_tail(&conn->task->running,
-					      &conn->cmdqueue);
-				conn->task = NULL;
-				spin_unlock_bh(&conn->taskqueuelock);
-				goto done;
-			} else
+			if (rc == -ENOMEM || rc == -EACCES)
+				fail_scsi_task(conn->task, DID_IMM_RETRY);
+			else
 				fail_scsi_task(conn->task, DID_ABORT);
 			spin_lock_bh(&conn->taskqueuelock);
 			continue;
-- 
1.8.3.1

