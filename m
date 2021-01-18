Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B521EC433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 804F322B39
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388530AbhARUgS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 15:36:18 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40484 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388982AbhARUfn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 15:35:43 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10IKYkL5084987;
        Mon, 18 Jan 2021 20:34:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=9kR/uqcr3DUrbmi5GJibMX/mFWUTCZq8s086OXOQuqY=;
 b=ghVL+7OYW+mJoUFF5mt26WJvKIkcKOxEsrHVlgktXSETaa65R6ZocnmQb890MNCnS9nV
 ogFSrgbieA5mLvmFVIXH/+IzMlgjEJqMT8RsJBiY+0yVUa9W62ROkpQWqstjeGX2jF8y
 Sza/qZCsdOt6e7HHPgJ8329XpW/kiWpGU8aiYiqIYWNJLlof+GCMJkkH5o+k0U8byRXF
 gEjY1KKA8H2ZtWHt61mEHqqdvPL/yAyXwI65/rytO7OYyADbNkYzv4wqw/cC4BkYwSo4
 7xAbgA91H866y98CBmgVYQCXhXxsUqfLGKeV/P43GCtOhEVJoJrmN6AqXGgFXU2a5zZ4 DQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 363r3kphkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jan 2021 20:34:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10IKQKof061935;
        Mon, 18 Jan 2021 20:34:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 364a1wsuwh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Jan 2021 20:34:45 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10IKYjge004858;
        Mon, 18 Jan 2021 20:34:45 GMT
Received: from localhost.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 18 Jan 2021 12:34:44 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
Subject: [PATCH 5/7] libiscsi: add helper to calc max scsi cmds per session
Date:   Mon, 18 Jan 2021 14:34:28 -0600
Message-Id: <20210118203430.4921-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210118203430.4921-1-michael.christie@oracle.com>
References: <20210118203430.4921-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9868 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101180123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9868 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 impostorscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101180124
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch just breaks out the code that calculates the number
of scsi cmds that will be used for a scsi session. It also adds
a check that we don't go over the host's can_queue value.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/libiscsi.c | 84 +++++++++++++++++++++++++----------------
 include/scsi/libiscsi.h |  2 +
 2 files changed, 54 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index b271d3accd2a..195006a08e0d 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2648,6 +2648,54 @@ void iscsi_pool_free(struct iscsi_pool *q)
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_free);
 
+int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,
+				 uint16_t requested_cmds_max)
+{
+	int scsi_cmds, total_cmds = requested_cmds_max;
+
+check:
+	if (!total_cmds)
+		total_cmds = ISCSI_DEF_XMIT_CMDS_MAX;
+	/*
+	 * The iscsi layer needs some tasks for nop handling and tmfs,
+	 * so the cmds_max must at least be greater than ISCSI_MGMT_CMDS_MAX
+	 * + 1 command for scsi IO.
+	 */
+	if (total_cmds < ISCSI_TOTAL_CMDS_MIN) {
+		printk(KERN_ERR "iscsi: invalid max cmds of %d. Must be a power of two that is at least %d.\n",
+		       total_cmds, ISCSI_TOTAL_CMDS_MIN);
+		return -EINVAL;
+	}
+
+	if (total_cmds > ISCSI_TOTAL_CMDS_MAX) {
+		printk(KERN_ERR "iscsi: invalid max cmds of %d. Must be a power of 2 less than or equal to %d.\n",
+		       requested_cmds_max, ISCSI_TOTAL_CMDS_MAX);
+		total_cmds = ISCSI_TOTAL_CMDS_MAX;
+	}
+
+	if (!is_power_of_2(total_cmds)) {
+		printk(KERN_ERR "iscsi: invalid max cmds of %d. Must be a power of 2.\n",
+		       total_cmds);
+		total_cmds = rounddown_pow_of_two(total_cmds);
+		if (total_cmds < ISCSI_TOTAL_CMDS_MIN)
+			return -EINVAL;
+		printk(KERN_INFO "iscsi: Rounding max cmds to %d.\n",
+		       total_cmds);
+	}
+
+	scsi_cmds = total_cmds - ISCSI_MGMT_CMDS_MAX;
+	if (shost->can_queue && scsi_cmds > shost->can_queue) {
+		total_cmds = shost->can_queue;
+
+		printk(KERN_INFO "iscsi: requested max cmds %u is higher than driver limit. Using driver limit %u\n",
+		       requested_cmds_max, shost->can_queue);
+		goto check;
+	}
+
+	return scsi_cmds;
+}
+EXPORT_SYMBOL_GPL(iscsi_host_get_max_scsi_cmds);
+
 /**
  * iscsi_host_add - add host to system
  * @shost: scsi host
@@ -2801,7 +2849,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	struct iscsi_host *ihost = shost_priv(shost);
 	struct iscsi_session *session;
 	struct iscsi_cls_session *cls_session;
-	int cmd_i, scsi_cmds, total_cmds = cmds_max;
+	int cmd_i, scsi_cmds;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ihost->lock, flags);
@@ -2812,37 +2860,9 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
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
@@ -2858,7 +2878,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	session->lu_reset_timeout = 15;
 	session->abort_timeout = 10;
 	session->scsi_cmds_max = scsi_cmds;
-	session->cmds_max = total_cmds;
+	session->cmds_max = scsi_cmds + ISCSI_MGMT_CMDS_MAX;
 	session->queued_cmdsn = session->cmdsn = initial_cmdsn;
 	session->exp_cmdsn = initial_cmdsn + 1;
 	session->max_cmdsn = initial_cmdsn + 1;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 44a9554aea62..02f966e9358f 100644
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
2.25.1

