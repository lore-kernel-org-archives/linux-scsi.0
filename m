Return-Path: <SRS0=rQSi=EH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 268F3C2D0A3
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Nov 2020 19:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C260322254
	for <linux-scsi@archiver.kernel.org>; Sun,  1 Nov 2020 19:01:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QpnIIJ0W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbgKATBu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 1 Nov 2020 14:01:50 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33416 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbgKATBt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Nov 2020 14:01:49 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A1IuFeN016861;
        Sun, 1 Nov 2020 19:01:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Bobyo1h70K9i0iaAxqGM0ThE+w4Z7GeMwIiiCmDh0nM=;
 b=QpnIIJ0WVvLQm1M+9Zqq+CmF56eg7BQ466FcCZk+ybQAfiUptuNTRsvMXWYoqfThCQea
 T2jO6xm/ynGTW5A4ZkFXekylIQsSdnrWOrS+lZfTkdgh3d9vQknSfD7X9KURtDnda3tb
 kfx/5sm9zZWLKBuVPjay/G5tTbBSANXJaCepSKFM+znM4iIeV3lihPzedcbIKtd0J7aW
 kGBqkvU9RC3zSrZA/mxCVz48Ky7DRiDwowok1paEDbVFJFMlmE06dMQi5M60GT38YsTV
 SCdevLltUJCCB4b4nPnYH1pgbly/3MoBD++qEKkM9XXyCM33lv4wzKpf1zLyHj/w5z4T DA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34hhb1sbey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 01 Nov 2020 19:01:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A1IsfUn125706;
        Sun, 1 Nov 2020 18:59:46 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 34hvrmef59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 01 Nov 2020 18:59:46 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A1IxgVt013109;
        Sun, 1 Nov 2020 18:59:45 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 01 Nov 2020 10:59:42 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     himanshu.madhani@oracle.com, njavali@marvell.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 1/8] target: fix lun ref count handling
Date:   Sun,  1 Nov 2020 12:59:27 -0600
Message-Id: <1604257174-4524-2-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604257174-4524-1-git-send-email-michael.christie@oracle.com>
References: <1604257174-4524-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9792 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011010154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9792 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011010154
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
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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

