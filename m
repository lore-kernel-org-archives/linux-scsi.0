Return-Path: <SRS0=iUlB=7U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A01C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:36:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A6592075A
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Jun 2020 20:36:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R2RtpXB2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgFGUg0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Jun 2020 16:36:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:42510 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728031AbgFGUgX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2020 16:36:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KXKjW018709;
        Sun, 7 Jun 2020 20:36:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=vaeqOCKgTp4Hi3KEGgTLBBXur8g9IgguEpuaki/Okj4=;
 b=R2RtpXB28iJluViIQ4RpaTSJhcO9JaiN9a0izgm2M3sc1VX3KSzyFTY/j0prAp6PFozJ
 fy6DtSy3AUWHDXEAZYyaI8ugrRfHhn8dkXCfBIX7zUvUtgEOSyjUKMijX/HMZseaIsRq
 UVI68xEAVA5NfVcPD807b3AOEdkW6rM2xQMyCfG668W70RZFsK5vPFJ9ywkdzcnhHxvK
 CdI+btrBeMWg3Vev7BafbZk+BFwQpR0E4OgHFgTG+xDoURaX0DcNSczaIEi6aTJa7Ubg
 KjHfvZzYBN74vniOHrUQIQH/TIXluveUJiiqcXq1uSiqw9Z+t+9EjfHub/PHQf1gemP2 fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31g33kv0qt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 07 Jun 2020 20:36:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 057KSJtO020342;
        Sun, 7 Jun 2020 20:36:17 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 31gn205nef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Jun 2020 20:36:16 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 057KaFQZ003672;
        Sun, 7 Jun 2020 20:36:15 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 07 Jun 2020 13:36:15 -0700
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH 12/17] target: hook most target users into sysfs API
Date:   Sun,  7 Jun 2020 15:35:59 -0500
Message-Id: <1591562164-9766-13-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=2 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006070161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9645 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 adultscore=0 spamscore=0
 cotscore=-2147483648 malwarescore=0 phishscore=0 mlxscore=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006070161
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This hooks lio core and all the targets but iscsi into the sysfs API.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/Makefile                |  1 +
 drivers/target/target_core_configfs.c  |  3 +++
 drivers/target/target_core_internal.h  |  1 +
 drivers/target/target_core_transport.c | 38 ++++++++++++++++++++++++++++------
 4 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 4563474..4a7246e 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 target_core_mod-y		:= target_core_configfs.o \
+				   target_core_sysfs.o \
 				   target_core_device.o \
 				   target_core_fabric_configfs.o \
 				   target_core_fabric_lib.o \
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index ff82b21f..c23552b 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3537,6 +3537,7 @@ static int __init target_core_init_configfs(void)
 		goto out;
 
 	target_init_dbroot();
+	target_sysfs_init();
 
 	return 0;
 
@@ -3555,6 +3556,8 @@ static int __init target_core_init_configfs(void)
 
 static void __exit target_core_exit_configfs(void)
 {
+	target_sysfs_exit();
+
 	configfs_remove_default_groups(&alua_lu_gps_group);
 	configfs_remove_default_groups(&alua_group);
 	configfs_remove_default_groups(&target_core_hbagroup);
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 93bf5fed..23d9a0e 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -157,6 +157,7 @@ void	transport_dump_dev_info(struct se_device *, struct se_lun *,
 bool	target_check_wce(struct se_device *dev);
 bool	target_check_fua(struct se_device *dev);
 void	__target_execute_cmd(struct se_cmd *, bool);
+void	__target_free_session(struct se_session *se_sess);
 
 /* target_core_stat.c */
 void	target_stat_setup_dev_default_groups(struct se_device *);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5d6d736..34da12a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/ratelimit.h>
 #include <linux/vmalloc.h>
+#include <linux/device.h>
 #include <asm/unaligned.h>
 #include <net/sock.h>
 #include <net/tcp.h>
@@ -251,14 +252,27 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 				" se_sess_cache\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	ret = transport_init_session(se_sess);
-	if (ret < 0) {
+
+	ret = target_sysfs_init_session(se_sess);
+	if (ret) {
 		kmem_cache_free(se_sess_cache, se_sess);
 		return ERR_PTR(ret);
 	}
-	se_sess->sup_prot_ops = sup_prot_ops;
+	/*
+	 * After this point we switch from handlng the freeing of the sess
+	 * to using the se_sess->dev refcounting.
+	 */
 
+	ret = transport_init_session(se_sess);
+	if (ret < 0)
+		goto put_dev;
+
+	se_sess->sup_prot_ops = sup_prot_ops;
 	return se_sess;
+
+put_dev:
+	put_device(&se_sess->dev);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(transport_alloc_session);
 
@@ -457,6 +471,10 @@ struct se_session *
 		rc = -EACCES;
 		goto free_sess;
 	}
+
+	rc = target_sysfs_add_session(tpg, sess);
+	if (rc)
+		goto free_sess;
 	/*
 	 * Go ahead and perform any remaining fabric setup that is
 	 * required before transport_register_session().
@@ -464,12 +482,14 @@ struct se_session *
 	if (callback != NULL) {
 		rc = callback(tpg, sess, private);
 		if (rc)
-			goto free_sess;
+			goto rm_sysfs;
 	}
 
 	transport_register_session(tpg, sess->se_node_acl, sess, private);
 	return sess;
 
+rm_sysfs:
+	target_sysfs_remove_session(sess);
 free_sess:
 	transport_free_session(sess);
 	return ERR_PTR(rc);
@@ -597,12 +617,17 @@ void transport_free_session(struct se_session *se_sess)
 		sbitmap_queue_free(&se_sess->sess_tag_pool);
 		kvfree(se_sess->sess_cmd_map);
 	}
-	target_free_transport_id(se_sess->tpt_id);
 	percpu_ref_exit(&se_sess->cmd_count);
-	kmem_cache_free(se_sess_cache, se_sess);
+	put_device(&se_sess->dev);
 }
 EXPORT_SYMBOL(transport_free_session);
 
+void __target_free_session(struct se_session *se_sess)
+{
+	target_free_transport_id(se_sess->tpt_id);
+	kmem_cache_free(se_sess_cache, se_sess);
+}
+
 static int target_release_res(struct se_device *dev, void *data)
 {
 	struct se_session *sess = data;
@@ -651,6 +676,7 @@ void transport_deregister_session(struct se_session *se_sess)
 
 void target_remove_session(struct se_session *se_sess)
 {
+	target_sysfs_remove_session(se_sess);
 	transport_deregister_session_configfs(se_sess);
 	transport_deregister_session(se_sess);
 }
-- 
1.8.3.1

