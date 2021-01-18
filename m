Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C5BC433E9
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:36:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4F3E22B39
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388980AbhARUgW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 15:36:22 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:40936 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394365AbhARUfw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 15:35:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10IKXXeH181892;
        Mon, 18 Jan 2021 20:34:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=4up9Di5+jLSiZ88Gvc1Cf2lvFn+rKKliDK1IcEHrPLo=;
 b=JQMlG0EVlho+2tua5QR7n0QDrKZYc3y9wLXyNV6Ky43y9VtFDkN12arCDym7NnT+JiS4
 8YrA/v0SfuLMunlnEv494r8xWPu1svgPhHUAyuhct0htoToXHEFlQ3QtQMe/oNZyUg6P
 S5KZna/hZ4Sb5A7YR01Ba68ApORTpM+bHNqC6PtpA7T5b99dUXc0/xKdJgcNnn1s2xDJ
 jMZYBjsQsSCGSUcVpciZjWsNn+2nSIXATCwEZDFyXqLbTjxs/1zN0Qw7D0AnsEP0vvrQ
 L0KrVfQ7EWZ549ScO4A4TO+IWr7L8fb7l9dH6BZ3HrfXhBUjOqd/TIebJd/GKyHXH/DT iQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 363xyhnxbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jan 2021 20:34:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10IKPPSS026139;
        Mon, 18 Jan 2021 20:34:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 364a2vhh1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jan 2021 20:34:46 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10IKYjl2026607;
        Mon, 18 Jan 2021 20:34:45 GMT
Received: from localhost.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Jan 2021 12:34:45 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
Subject: [PATCH 7/7] libiscsi: reset max/exp cmdsn during recovery
Date:   Mon, 18 Jan 2021 14:34:30 -0600
Message-Id: <20210118203430.4921-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210118203430.4921-1-michael.christie@oracle.com>
References: <20210118203430.4921-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9868 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101180123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9868 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 spamscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101180124
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
Reviewed-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/libiscsi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 195006a08e0d..be29837372c2 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3271,6 +3271,13 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
 		session->leadconn = conn;
 	spin_unlock_bh(&session->frwd_lock);
 
+	/*
+	 * The target could have reduced it's window size between logins, so
+	 * we have to reset max/exp cmdsn so we can see the new values.
+	 */
+	spin_lock_bh(&session->back_lock);
+	session->max_cmdsn = session->exp_cmdsn = session->cmdsn + 1;
+	spin_unlock_bh(&session->back_lock);
 	/*
 	 * Unblock xmitworker(), Login Phase will pass through.
 	 */
-- 
2.25.1

