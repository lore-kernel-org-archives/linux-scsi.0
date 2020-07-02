Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 639FFC433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 377CD207D4
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:43:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Chb3hAH+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgGBBne (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 21:43:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:33894 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727921AbgGBBna (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 21:43:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0621cIKZ155693;
        Thu, 2 Jul 2020 01:43:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=tFE1yMrA+uD5SlqaHhouo3Fj/+2xAemq79ePyl1jqkM=;
 b=Chb3hAH+DU3bdrHYH171otJywMndy3md9672rjhvcLYEbt0Bey3/12QHFEo1czMEL8kX
 wjdJ7IMP3AxTXEs/6FY8FIf1gjpOoheAf4+7MhWYRlfybKhRJfzaGjlaVyDHElYypdzi
 qu3hiYzNFfknaBWthawCoMnyQub6mnxkmtbm/ePLAYcCWSth2F9+xtvu5iFF6wKeVbg8
 bXdqNm4RlHeOHpt1zOBUHv8fFJZP5ZiFew7NyU2jDv4Iqj8/hAWIJPYuA9dKS+IsUPjb
 Vn8LcKUEspJQB58AMjJ7s+RTvhniogAYEB0uRnbxgmYuRXkc12/vF2qUlgfIvGoxBKfb ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31xx1e2hun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 02 Jul 2020 01:43:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0621gp30051099;
        Thu, 2 Jul 2020 01:43:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31xg17stfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jul 2020 01:43:26 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0621hOfZ017085;
        Thu, 2 Jul 2020 01:43:24 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 01:43:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, bstroesser@ts.fujitsu.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH 3/7] target: fix crash during SPEC_I_PT handling
Date:   Wed,  1 Jul 2020 20:43:19 -0500
Message-Id: <1593654203-12442-4-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
References: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=2 bulkscore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007020010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9669 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=2 mlxlogscore=999 cotscore=-2147483648 lowpriorityscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007020009
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

__core_scsi3_add_registration clears the t10_pr_registration
pr_reg_deve and does a core_scsi3_lunacl_undepend_item which does an
undepend and also does a kref_put from the get done in
__core_scsi3_alloc_registration. So when we get to the bottom of
core_scsi3_decode_spec_i_port the pr_reg_deve is NULL and we crash when
trying to access the local_pr_reg's pr_reg_deve. We've also done an extra
undepend for local_pr_reg and if we didn't crash on the NULL we would
have done an extra kref_put too.

This patch has us do a core_scsi3_lunacl_depend_item for local_pr_reg
and then let __core_scsi3_add_registration handle the cleanup for the
pr_reg_deve. We then just skip the undepend for the acl and tpg for the
local pr_reg.

The erorr path then works in a similar way, but we always do the
core_scsi3_lunacl_undepend_item since we never call
__core_scsi3_add_registration in that code path.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_pr.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 293f518..d5e6344 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1521,13 +1521,16 @@ static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 		kfree(tidh_new);
 		return TCM_INSUFFICIENT_REGISTRATION_RESOURCES;
 	}
+
+	if (core_scsi3_lunacl_depend_item(local_pr_reg->pr_reg_deve)) {
+		kfree(tidh_new);
+		kref_put(&local_pr_reg->pr_reg_deve->pr_kref,
+			 target_pr_kref_release);
+		kmem_cache_free(t10_pr_reg_cache, local_pr_reg);
+		return TCM_INSUFFICIENT_REGISTRATION_RESOURCES;
+	}
+
 	tidh_new->dest_pr_reg = local_pr_reg;
-	/*
-	 * The local I_T nexus does not hold any configfs dependances,
-	 * so we set tidh_new->dest_se_deve to NULL to prevent the
-	 * configfs_undepend_item() calls in the tid_dest_list loops below.
-	 */
-	tidh_new->dest_se_deve = NULL;
 	list_add_tail(&tidh_new->dest_list, &tid_dest_list);
 
 	if (cmd->data_length < 28) {
@@ -1816,12 +1819,9 @@ static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 			dest_node_acl->initiatorname, i_buf, (dest_se_deve) ?
 			dest_se_deve->mapped_lun : 0);
 
-		if (!dest_se_deve) {
-			kref_put(&local_pr_reg->pr_reg_deve->pr_kref,
-				 target_pr_kref_release);
+		if (dest_pr_reg == local_pr_reg)
 			continue;
-		}
-		core_scsi3_lunacl_undepend_item(dest_se_deve);
+
 		core_scsi3_nodeacl_undepend_item(dest_node_acl);
 		core_scsi3_tpg_undepend_item(dest_tpg);
 	}
@@ -1835,11 +1835,16 @@ static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 	 * including *dest_pr_reg and the configfs dependances..
 	 */
 	list_for_each_entry_safe(tidh, tidh_tmp, &tid_dest_list, dest_list) {
+		bool is_local = false;
+
 		dest_tpg = tidh->dest_tpg;
 		dest_node_acl = tidh->dest_node_acl;
 		dest_se_deve = tidh->dest_se_deve;
 		dest_pr_reg = tidh->dest_pr_reg;
 
+		if (dest_pr_reg == local_pr_reg)
+			is_local = true;
+
 		list_del(&tidh->dest_list);
 		kfree(tidh);
 		/*
@@ -1855,13 +1860,11 @@ static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 		}
 
 		kmem_cache_free(t10_pr_reg_cache, dest_pr_reg);
+		core_scsi3_lunacl_undepend_item(dest_se_deve);
 
-		if (!dest_se_deve) {
-			kref_put(&local_pr_reg->pr_reg_deve->pr_kref,
-				 target_pr_kref_release);
+		if (is_local)
 			continue;
-		}
-		core_scsi3_lunacl_undepend_item(dest_se_deve);
+
 		core_scsi3_nodeacl_undepend_item(dest_node_acl);
 		core_scsi3_tpg_undepend_item(dest_tpg);
 	}
-- 
1.8.3.1

