Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 209C6C433E4
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 04:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFB8520857
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 04:35:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f8mM+vIZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgF0EfZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Jun 2020 00:35:25 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39056 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgF0EfY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2020 00:35:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R4X03n118380;
        Sat, 27 Jun 2020 04:35:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=xfALCTNiUytLnfV1dbweiTUu9AvHamL/fQ+ICFQjfL4=;
 b=f8mM+vIZeJ1CED2ZN5EJ/wOy3+ZMAfFlzcyTCmGVOiGKy71LJ/+8+z1swqkWnuSasE41
 vs7kdWS7CNYM4iq8dswA4PISGZMWOUfPVp5poffztYaqmlcxkav0B/I34Rfplns7aeCA
 aNCwXu4E7uJeyiz9ORFWWhgKqkpXW2zbcyE/AV7ZdR9KuwkLZTb+ZX9RJ6faluz7VWnw
 bHG+guy+uKp0YdeaIN0P34Glw4Nk5XwifQpPXlhYd0XvKpyPA7DTaxmYBuDRZaaw0CTI
 Sy7pxIHxGYsoNjmn4T6yUoad/5cCFGJFPLNo+M0DAyOPFBJiekUwDBSvMKFNdLNXqZvT xw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31wwhr83sm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 27 Jun 2020 04:35:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R4Y94x121992;
        Sat, 27 Jun 2020 04:35:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31wv58v8a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Jun 2020 04:35:16 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05R4ZFLg004220;
        Sat, 27 Jun 2020 04:35:15 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 27 Jun 2020 04:35:14 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hare@suse.de, bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [RFC PATCH 06/10] tcm_loop: fix nexus races
Date:   Fri, 26 Jun 2020 23:35:05 -0500
Message-Id: <1593232509-13720-7-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006270030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 priorityscore=1501 clxscore=1015 cotscore=-2147483648
 mlxscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006270030
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We could be freeing the loop nexus while accessing it from other
configfs files, and we could have multiple writers to the nexus file.
This adds a mutex aroung these operations like is done in other modules
that have the nexus configfs interface.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/loopback/tcm_loop.c | 30 ++++++++++++++++++++++++++----
 drivers/target/loopback/tcm_loop.h |  1 +
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 70eb87e..570dff2 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -720,14 +720,18 @@ static int tcm_loop_make_nexus(
 	struct tcm_loop_nexus *tl_nexus;
 	int ret;
 
+	mutex_lock(&tl_tpg->tl_nexus_mutex);
 	if (tl_tpg->tl_nexus) {
 		pr_debug("tl_tpg->tl_nexus already exists\n");
+		mutex_unlock(&tl_tpg->tl_nexus_mutex);
 		return -EEXIST;
 	}
 
 	tl_nexus = kzalloc(sizeof(*tl_nexus), GFP_KERNEL);
-	if (!tl_nexus)
+	if (!tl_nexus) {
+		mutex_unlock(&tl_tpg->tl_nexus_mutex);
 		return -ENOMEM;
+	}
 
 	tl_nexus->se_sess = target_setup_session(&tl_tpg->tl_se_tpg, 0, 0,
 					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS,
@@ -735,8 +739,10 @@ static int tcm_loop_make_nexus(
 	if (IS_ERR(tl_nexus->se_sess)) {
 		ret = PTR_ERR(tl_nexus->se_sess);
 		kfree(tl_nexus);
+		mutex_unlock(&tl_tpg->tl_nexus_mutex);
 		return ret;
 	}
+	mutex_unlock(&tl_tpg->tl_nexus_mutex);
 
 	pr_debug("TCM_Loop_ConfigFS: Established I_T Nexus to emulated %s Initiator Port: %s\n",
 		 tcm_loop_dump_proto_id(tl_hba), name);
@@ -749,17 +755,23 @@ static int tcm_loop_drop_nexus(
 	struct se_session *se_sess;
 	struct tcm_loop_nexus *tl_nexus;
 
+	mutex_lock(&tpg->tl_nexus_mutex);
 	tl_nexus = tpg->tl_nexus;
-	if (!tl_nexus)
+	if (!tl_nexus) {
+		mutex_unlock(&tpg->tl_nexus_mutex);
 		return -ENODEV;
+	}
 
 	se_sess = tl_nexus->se_sess;
-	if (!se_sess)
+	if (!se_sess) {
+		mutex_unlock(&tpg->tl_nexus_mutex);
 		return -ENODEV;
+	}
 
 	if (atomic_read(&tpg->tl_tpg_port_count)) {
 		pr_err("Unable to remove TCM_Loop I_T Nexus with active TPG port count: %d\n",
 		       atomic_read(&tpg->tl_tpg_port_count));
+		mutex_unlock(&tpg->tl_nexus_mutex);
 		return -EPERM;
 	}
 
@@ -771,6 +783,8 @@ static int tcm_loop_drop_nexus(
 	 */
 	target_remove_session(se_sess);
 	tpg->tl_nexus = NULL;
+	mutex_unlock(&tpg->tl_nexus_mutex);
+
 	kfree(tl_nexus);
 	return 0;
 }
@@ -785,12 +799,16 @@ static ssize_t tcm_loop_tpg_nexus_show(struct config_item *item, char *page)
 	struct tcm_loop_nexus *tl_nexus;
 	ssize_t ret;
 
+	mutex_lock(&tl_tpg->tl_nexus_mutex);
 	tl_nexus = tl_tpg->tl_nexus;
-	if (!tl_nexus)
+	if (!tl_nexus) {
+		mutex_unlock(&tl_tpg->tl_nexus_mutex);
 		return -ENODEV;
+	}
 
 	ret = snprintf(page, PAGE_SIZE, "%s\n",
 		tl_nexus->se_sess->se_node_acl->initiatorname);
+	mutex_unlock(&tl_tpg->tl_nexus_mutex);
 
 	return ret;
 }
@@ -909,11 +927,14 @@ static ssize_t tcm_loop_tpg_transport_status_store(struct config_item *item,
 	}
 	if (!strncmp(page, "offline", 7)) {
 		tl_tpg->tl_transport_status = TCM_TRANSPORT_OFFLINE;
+
+		mutex_lock(&tl_tpg->tl_nexus_mutex);
 		if (tl_tpg->tl_nexus) {
 			struct se_session *tl_sess = tl_tpg->tl_nexus->se_sess;
 
 			core_allocate_nexus_loss_ua(tl_sess->se_node_acl);
 		}
+		mutex_unlock(&tl_tpg->tl_nexus_mutex);
 		return count;
 	}
 	return -EINVAL;
@@ -968,6 +989,7 @@ static struct se_portal_group *tcm_loop_make_naa_tpg(struct se_wwn *wwn,
 	tl_tpg = &tl_hba->tl_hba_tpgs[tpgt];
 	tl_tpg->tl_hba = tl_hba;
 	tl_tpg->tl_tpgt = tpgt;
+	mutex_init(&tl_tpg->tl_nexus_mutex);
 	/*
 	 * Register the tl_tpg as a emulated TCM Target Endpoint
 	 */
diff --git a/drivers/target/loopback/tcm_loop.h b/drivers/target/loopback/tcm_loop.h
index d311090..88a4eff 100644
--- a/drivers/target/loopback/tcm_loop.h
+++ b/drivers/target/loopback/tcm_loop.h
@@ -40,6 +40,7 @@ struct tcm_loop_tpg {
 	struct se_portal_group tl_se_tpg;
 	struct tcm_loop_hba *tl_hba;
 	struct tcm_loop_nexus *tl_nexus;
+	struct mutex tl_nexus_mutex;
 };
 
 struct tcm_loop_hba {
-- 
1.8.3.1

