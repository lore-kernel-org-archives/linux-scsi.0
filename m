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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D76C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 02:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C68022DCC
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 02:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbgLUCio (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 21:38:44 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39882 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgLUCio (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 21:38:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BL2VBUJ087338;
        Mon, 21 Dec 2020 02:37:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=4Hw6B0msMp6SoSnumOr1CgssFJCEMvswu+0H5lRPs+4=;
 b=B9kizJqO22YHeHh0Kl12wSnfBc25Vo7G6yPg3xgdFxXjRVmDf1vozMsU+aKnXnsrIp3Q
 RxebOPpeMa/enuLmTUMAHBZBrGkMYK3x7Cy08XymFdUP+LodIQ87SSQyHHig5SpuFj7P
 Y7nmJuS+2Oec7ZymTfSE6aoOGUJ14XVI+qQf/RtBH483KLClIwe2aYqFGwheC21nhUNF
 36xZn7nOX5h2bYwP2IHGjMIlTc2LTWIc9LL7E8IcNnu9vS7/2vIJ/RAnH7+C07sRkEyd
 S553oO1OsTNx9wZXtoelRTo0vqdhd4LzNRIdmlbmXr8jlOtUAl6c01XX6Lk+s0Q9Rtvx sA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 35h8xquaug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 21 Dec 2020 02:37:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BL2ZUBr081666;
        Mon, 21 Dec 2020 02:37:30 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 35hu3kugct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Dec 2020 02:37:30 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BL2bP5T009374;
        Mon, 21 Dec 2020 02:37:26 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 20 Dec 2020 18:37:25 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
Subject: [PATCH 4/6 V3] libiscsi: add helper to calc max scsi cmds per session
Date:   Sun, 20 Dec 2020 20:37:04 -0600
Message-Id: <1608518226-30376-5-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608518226-30376-1-git-send-email-michael.christie@oracle.com>
References: <1608518226-30376-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9841 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012210018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9841 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 impostorscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012210017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch just breaks out the code that calculates the number
of scsi cmds that will be used for a scsi session. It also adds
a check that we don't go over the host's can_queue value.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 81 ++++++++++++++++++++++++++++++-------------------
 include/scsi/libiscsi.h |  2 ++
 2 files changed, 51 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 796465e..f1ade91 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2648,6 +2648,51 @@ void iscsi_pool_free(struct iscsi_pool *q)
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_free);
 
+int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,
+				 uint16_t requested_cmds_max)
+{
+	int scsi_cmds, total_cmds = requested_cmds_max;
+
+	if (!total_cmds)
+		total_cmds = ISCSI_DEF_XMIT_CMDS_MAX;
+	/*
+	 * The iscsi layer needs some tasks for nop handling and tmfs,
+	 * so the cmds_max must at least be greater than ISCSI_MGMT_CMDS_MAX
+	 * + 1 command for scsi IO.
+	 */
+	if (total_cmds < ISCSI_TOTAL_CMDS_MIN) {
+		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue must be a power of two that is at least %d.\n",
+		       total_cmds, ISCSI_TOTAL_CMDS_MIN);
+		return -EINVAL;
+	}
+
+	if (total_cmds > ISCSI_TOTAL_CMDS_MAX) {
+		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue must be a power of 2 less than or equal to %d.\n",
+		       requested_cmds_max, ISCSI_TOTAL_CMDS_MAX);
+		total_cmds = ISCSI_TOTAL_CMDS_MAX;
+	}
+
+	if (!is_power_of_2(total_cmds)) {
+		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue must be a power of 2.\n",
+		       total_cmds);
+		total_cmds = rounddown_pow_of_two(total_cmds);
+		if (total_cmds < ISCSI_TOTAL_CMDS_MIN)
+			return -EINVAL;
+		printk(KERN_INFO "iscsi: Rounding can_queue to %d.\n",
+		       total_cmds);
+	}
+
+	scsi_cmds = total_cmds - ISCSI_MGMT_CMDS_MAX;
+	if (shost->can_queue && scsi_cmds > shost->can_queue) {
+		scsi_cmds = shost->can_queue - ISCSI_MGMT_CMDS_MAX;
+		printk(KERN_INFO "iscsi: requested cmds_max %u higher than driver limit. Using driver max %u\n",
+		       requested_cmds_max, shost->can_queue);
+	}
+
+	return scsi_cmds;
+}
+EXPORT_SYMBOL_GPL(iscsi_host_get_max_scsi_cmds);
+
 /**
  * iscsi_host_add - add host to system
  * @shost: scsi host
@@ -2800,7 +2845,7 @@ struct iscsi_cls_session *
 	struct iscsi_host *ihost = shost_priv(shost);
 	struct iscsi_session *session;
 	struct iscsi_cls_session *cls_session;
-	int cmd_i, scsi_cmds, total_cmds = cmds_max;
+	int cmd_i, scsi_cmds;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ihost->lock, flags);
@@ -2811,37 +2856,9 @@ struct iscsi_cls_session *
 	ihost->num_sessions++;
 	spin_unlock_irqrestore(&ihost->lock, flags);
 
-	if (!total_cmds)
-		total_cmds = ISCSI_DEF_XMIT_CMDS_MAX;
-	/*
-	 * The iscsi layer needs some tasks for nop handling and tmfs,
-	 * so the cmds_max must at least be greater than ISCSI_MGMT_CMDS_MAX
-	 * + 1 command for scsi IO.
-	 */
-	if (total_cmds < ISCSI_TOTAL_CMDS_MIN) {
-		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue "
-		       "must be a power of two that is at least %d.\n",
-		       total_cmds, ISCSI_TOTAL_CMDS_MIN);
+	scsi_cmds = iscsi_host_get_max_scsi_cmds(shost, cmds_max);
+	if (scsi_cmds < 0)
 		goto dec_session_count;
-	}
-
-	if (total_cmds > ISCSI_TOTAL_CMDS_MAX) {
-		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue "
-		       "must be a power of 2 less than or equal to %d.\n",
-		       cmds_max, ISCSI_TOTAL_CMDS_MAX);
-		total_cmds = ISCSI_TOTAL_CMDS_MAX;
-	}
-
-	if (!is_power_of_2(total_cmds)) {
-		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue "
-		       "must be a power of 2.\n", total_cmds);
-		total_cmds = rounddown_pow_of_two(total_cmds);
-		if (total_cmds < ISCSI_TOTAL_CMDS_MIN)
-			goto dec_session_count;
-		printk(KERN_INFO "iscsi: Rounding can_queue to %d.\n",
-		       total_cmds);
-	}
-	scsi_cmds = total_cmds - ISCSI_MGMT_CMDS_MAX;
 
 	cls_session = iscsi_alloc_session(shost, iscsit,
 					  sizeof(struct iscsi_session) +
@@ -2857,7 +2874,7 @@ struct iscsi_cls_session *
 	session->lu_reset_timeout = 15;
 	session->abort_timeout = 10;
 	session->scsi_cmds_max = scsi_cmds;
-	session->cmds_max = total_cmds;
+	session->cmds_max = scsi_cmds + ISCSI_MGMT_CMDS_MAX;
 	session->queued_cmdsn = session->cmdsn = initial_cmdsn;
 	session->exp_cmdsn = initial_cmdsn + 1;
 	session->max_cmdsn = initial_cmdsn + 1;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 44a9554..02f966e 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -395,6 +395,8 @@ extern struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 extern void iscsi_host_remove(struct Scsi_Host *shost);
 extern void iscsi_host_free(struct Scsi_Host *shost);
 extern int iscsi_target_alloc(struct scsi_target *starget);
+extern int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,
+					uint16_t requested_cmds_max);
 
 /*
  * session management
-- 
1.8.3.1

