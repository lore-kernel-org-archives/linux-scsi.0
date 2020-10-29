Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EEC1C55178
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 09:55:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21F932076E
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 09:55:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JZEFTAxY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgJ2JzQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 05:55:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58680 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgJ2JzP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 05:55:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09T6ioCU037352;
        Thu, 29 Oct 2020 06:49:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=LIqXxII8R1PdUpYDGrZyozrQSO+LwSZruSt/jQNE33g=;
 b=JZEFTAxY+tawYGa81Fu4rf+sRGeaOP8KUfbreRfMDuTUzfdBB6f9b7tAndEUmlqot7wC
 vYzSymiNtPVO9LIdSXG0DMnyzDq1D1IhbY8hPygdtyr+WfFD7wLQPiJmdmoM3//1fIa+
 ms9GA8k3o4hepJO5Sx72FNub1fy93iVkNbmOpKGNdi377/WY5KDz4p8IPKvxOIsftCMg
 P8A+VXv0g05+RFxzZtVwjz36NFRkzTfqcu3NYrZQj2/fFxbQ/cI/PZGcJtzgiZg/nRG8
 2ahLuG65OWYEtTK+H/9tPgAdvsKY9Xoq4Yzc1rUf0NDUi/vIB5vq1CBlmlrCxF/seOXV BA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34dgm48pfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 06:49:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09T6kMet178500;
        Thu, 29 Oct 2020 06:49:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34cx1svd4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 06:49:41 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09T6neZ9014503;
        Thu, 29 Oct 2020 06:49:40 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 28 Oct 2020 23:49:40 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     himanshu.madhani@oracle.com, njavali@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH 1/8] target: fix lun ref count handling
Date:   Thu, 29 Oct 2020 01:49:24 -0500
Message-Id: <1603954171-11621-2-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603954171-11621-1-git-send-email-michael.christie@oracle.com>
References: <1603954171-11621-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9788 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290047
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This fixes 2 bugs in the lun refcounting.

1. For the TCM_WRITE_PROTECTED case we were returning an error after
taking a ref to the lun, but never dropping it (caller just send
status and drops cmd ref).

2. We still need to do a percpu_ref_tryget_live for the virt lun0 like
we do for other luns, because the tpg code does the refcount/wait
process like it does with other luns.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_device.c | 43 +++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 405d82d..1f673fb 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -65,6 +65,16 @@
 			atomic_long_add(se_cmd->data_length,
 					&deve->read_bytes);
 
+		if ((se_cmd->data_direction == DMA_TO_DEVICE) &&
+		    deve->lun_access_ro) {
+			pr_err("TARGET_CORE[%s]: Detected WRITE_PROTECTED LUN"
+				" Access for 0x%08llx\n",
+				se_cmd->se_tfo->fabric_name,
+				se_cmd->orig_fe_lun);
+			rcu_read_unlock();
+			return TCM_WRITE_PROTECTED;
+		}
+
 		se_lun = rcu_dereference(deve->se_lun);
 
 		if (!percpu_ref_tryget_live(&se_lun->lun_ref)) {
@@ -76,17 +86,6 @@
 		se_cmd->pr_res_key = deve->pr_res_key;
 		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
 		se_cmd->lun_ref_active = true;
-
-		if ((se_cmd->data_direction == DMA_TO_DEVICE) &&
-		    deve->lun_access_ro) {
-			pr_err("TARGET_CORE[%s]: Detected WRITE_PROTECTED LUN"
-				" Access for 0x%08llx\n",
-				se_cmd->se_tfo->fabric_name,
-				se_cmd->orig_fe_lun);
-			rcu_read_unlock();
-			ret = TCM_WRITE_PROTECTED;
-			goto ref_dev;
-		}
 	}
 out_unlock:
 	rcu_read_unlock();
@@ -106,21 +105,20 @@
 			return TCM_NON_EXISTENT_LUN;
 		}
 
-		se_lun = se_sess->se_tpg->tpg_virt_lun0;
-		se_cmd->se_lun = se_sess->se_tpg->tpg_virt_lun0;
-		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
-
-		percpu_ref_get(&se_lun->lun_ref);
-		se_cmd->lun_ref_active = true;
-
 		/*
 		 * Force WRITE PROTECT for virtual LUN 0
 		 */
 		if ((se_cmd->data_direction != DMA_FROM_DEVICE) &&
-		    (se_cmd->data_direction != DMA_NONE)) {
-			ret = TCM_WRITE_PROTECTED;
-			goto ref_dev;
-		}
+		    (se_cmd->data_direction != DMA_NONE))
+			return TCM_WRITE_PROTECTED;
+
+		se_lun = se_sess->se_tpg->tpg_virt_lun0;
+		if (!percpu_ref_tryget_live(&se_lun->lun_ref))
+			return TCM_NON_EXISTENT_LUN;
+
+		se_cmd->se_lun = se_sess->se_tpg->tpg_virt_lun0;
+		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
+		se_cmd->lun_ref_active = true;
 	}
 	/*
 	 * RCU reference protected by percpu se_lun->lun_ref taken above that
@@ -128,7 +126,6 @@
 	 * pointer can be kfree_rcu() by the final se_lun->lun_group put via
 	 * target_core_fabric_configfs.c:target_fabric_port_release
 	 */
-ref_dev:
 	se_cmd->se_dev = rcu_dereference_raw(se_lun->lun_se_dev);
 	atomic_long_inc(&se_cmd->se_dev->num_cmds);
 
-- 
1.8.3.1

