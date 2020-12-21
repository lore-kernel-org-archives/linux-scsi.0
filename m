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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F6F2C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 02:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01D4622EBD
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 02:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgLUCk3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 21:40:29 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42112 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbgLUCk3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 21:40:29 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BL2cf8O112034;
        Mon, 21 Dec 2020 02:39:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=XfygN+tle3uqg1kO8O3ZG3mr0CTPrlCINAI1Xs7IN3s=;
 b=JLuB3Rn0eYHDnW8G2c/zBnHSFhX53qH2l/aG47/TXFv4QxdVIRNcNSnuyTlVMzeLollG
 En4Sug1FM/0TsY+oVj3EhlbtYrV2Pr9t6jKCW0F5Lf4suqqx/UxYnM7c4/xkkibVxZxS
 dfkRWRySAhuU5ZopgO/U7z9pg3qSZWr56EAR96c+CFgMxtligzIJkPDX8du2zQKBaTFd
 wB1fn0iq457ki2iaJTI5ADEtMBvPpZPUbhXPR9ribEKc/ltCYQAD0+0XmOHEOqVW6bH+
 DuoARMsKJsaD27A0MkhR2ojZMJjVACZI4zpH7BlgSVSh9y/XYEDVUsuHbP9h9vxIVvi7 AA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 35h8xquawk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 21 Dec 2020 02:39:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BL2ZT8O055626;
        Mon, 21 Dec 2020 02:37:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 35hu9p8f59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Dec 2020 02:37:29 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BL2bRHC009405;
        Mon, 21 Dec 2020 02:37:27 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 20 Dec 2020 18:37:27 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
Subject: [PATCH 6/6 V3] libiscsi: reset max/exp cmdsn during recovery
Date:   Sun, 20 Dec 2020 20:37:06 -0600
Message-Id: <1608518226-30376-7-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608518226-30376-1-git-send-email-michael.christie@oracle.com>
References: <1608518226-30376-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9841 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012210018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9841 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 impostorscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012210018
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we lose the session then relogin, but the new cmdsn window has
shrunk (due to something like an admin changing a setting) we will
have the old exp/max_cmdsn values and will never be able to update
them. For example, max_cmdsn would be 64, but if on the target the
user set the window to be smaller then the target could try to return
the max_cmdsn as 32. We will see that new max_cmdsn in the rsp but
because it's lower than the old max_cmdsn when the window was larger
we will not update it.

So this patch has us reset the windown values during session
cleanup so they can be updated after a new login.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f1ade91..ff6ba78 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3268,6 +3268,13 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
 	spin_unlock_bh(&session->frwd_lock);
 
 	/*
+	 * The target could have reduced it's window size between logins, so
+	 * we have to reset max/exp cmdsn so we can see the new values.
+	 */
+	spin_lock_bh(&session->back_lock);
+	session->max_cmdsn = session->exp_cmdsn = session->cmdsn + 1;
+	spin_unlock_bh(&session->back_lock);
+	/*
 	 * Unblock xmitworker(), Login Phase will pass through.
 	 */
 	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
-- 
1.8.3.1

