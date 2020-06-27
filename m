Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9AEC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 04:35:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BB6F2089D
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 04:35:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iYQQaZaa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgF0EfY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Jun 2020 00:35:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39054 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbgF0EfY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2020 00:35:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R4Y1ki119310;
        Sat, 27 Jun 2020 04:35:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=b3D4jm4aEOnw78Xypa/uwSDc0ZpLBdNt43Rpb2vlEOM=;
 b=iYQQaZaaqiT0EZYU1+dJ43/L/MJcdo4YGNAJF6p7DLLYEhDlZQ1tPCSajMTaRt5TYCnG
 JbCy26uXajVW0s3Tg/eGkTHyJhCXRlHdZ5Fc/hUBvr2nCd1CfMkIfRtwU0EpdISxjLy8
 t1yOeKRyaX8r2euczoviC95Lk197qNRP2Rc9AFN+yOaceU+KX6OHE2VKXLX2f1qpu6Bh
 P/PWv9JC+Ng0ZTbw4mQ5JmzrdKPjANXDPP2YtLRsGFXJ4M5sKYpkMoHlrnnRXCiEHe3q
 RBumt7m8gWT6bVZumTlB1HV0Bve+jaBQk4BCAmcfgOHsI0smfjub8YFM67HWA5FNsF4D oA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31wwhr83sj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 27 Jun 2020 04:35:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R4Y92K121991;
        Sat, 27 Jun 2020 04:35:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31wv58v89n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Jun 2020 04:35:15 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05R4ZBni010305;
        Sat, 27 Jun 2020 04:35:11 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 27 Jun 2020 04:35:11 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hare@suse.de, bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [RFC PATCH 01/10] target: add common session id
Date:   Fri, 26 Jun 2020 23:35:00 -0500
Message-Id: <1593232509-13720-2-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2 bulkscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006270030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 priorityscore=1501 clxscore=1015 cotscore=-2147483648
 mlxscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 spamscore=0 suspectscore=2 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006270030
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The iscsi target and lio core, use a unique session id for a
couple uses like scsiAttIntrPortIndex, and transport specifics
like logging sessions under a tpgt.

This adds a common id that is managed by lio core, which lio
core and all transports can use. It will also then be used
for in the next patches for the session identifier value used
for the configfs dir name.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---

V3:
This is actually the 3rd version of this patch. Bart, in one
version you requested that it be per tpg or target. I did that
but then I reversed here.

Userspace apps would prefer that it's module wide, so that they
can have a single lookup table when exporting a device through
multiple targets. Also to keep compat with the old iscsi mod
use cases, we needed it to be module wide.

 drivers/target/target_core_transport.c | 22 +++++++++++++++++++---
 include/target/target_core_base.h      |  1 +
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 90ecdd7..3d06f52 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -50,6 +50,8 @@
 struct kmem_cache *t10_alua_lba_map_cache;
 struct kmem_cache *t10_alua_lba_map_mem_cache;
 
+static DEFINE_IDA(se_sess_ida);
+
 static void transport_complete_task_attr(struct se_cmd *cmd);
 static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason);
 static void transport_handle_queue_full(struct se_cmd *cmd,
@@ -153,6 +155,7 @@ int init_se_kmem_caches(void)
 
 void release_se_kmem_caches(void)
 {
+	ida_destroy(&se_sess_ida);
 	destroy_workqueue(target_completion_wq);
 	kmem_cache_destroy(se_sess_cache);
 	kmem_cache_destroy(se_ua_cache);
@@ -251,14 +254,26 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 				" se_sess_cache\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	ret = transport_init_session(se_sess);
+
+	ret = ida_simple_get(&se_sess_ida, 1, 0, GFP_KERNEL);
 	if (ret < 0) {
-		kmem_cache_free(se_sess_cache, se_sess);
-		return ERR_PTR(ret);
+		pr_err("Unable to allocate session index.\n");
+		goto free_sess;
 	}
+	se_sess->sid = ret;
+
+	ret = transport_init_session(se_sess);
+	if (ret < 0)
+		goto free_ida;
 	se_sess->sup_prot_ops = sup_prot_ops;
 
 	return se_sess;
+
+free_ida:
+	ida_simple_remove(&se_sess_ida, se_sess->sid);
+free_sess:
+	kmem_cache_free(se_sess_cache, se_sess);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(transport_alloc_session);
 
@@ -580,6 +595,7 @@ void transport_free_session(struct se_session *se_sess)
 		kvfree(se_sess->sess_cmd_map);
 	}
 	percpu_ref_exit(&se_sess->cmd_count);
+	ida_simple_remove(&se_sess_ida, se_sess->sid);
 	kmem_cache_free(se_sess_cache, se_sess);
 }
 EXPORT_SYMBOL(transport_free_session);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 18c3f27..adea3bd 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -623,6 +623,7 @@ struct se_session {
 	wait_queue_head_t	cmd_list_wq;
 	void			*sess_cmd_map;
 	struct sbitmap_queue	sess_tag_pool;
+	int			sid;
 };
 
 struct se_device;
-- 
1.8.3.1

