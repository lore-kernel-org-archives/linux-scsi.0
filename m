Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A81DC433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 04:35:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0623220857
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 04:35:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OC9PZvv/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgF0Ef1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Jun 2020 00:35:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39066 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgF0EfY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2020 00:35:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R4WwjT118325;
        Sat, 27 Jun 2020 04:35:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=8L/ZL5jJJSa8I22MCpSzYKeHPvESS5q4cLy8M6wJXLg=;
 b=OC9PZvv/AEniVrWYD0WBUToUmvYsupHNyhYUlLW232CJC8R+b0/V2bizD/wJnBrGYcsA
 652TEoteFkc6wN5pZidhyIf0DrdE1xzRfGqa4pycF/lPocYwMUpI7ScM7yrrf2K2sUtY
 0Mpy/8CaLrWJP3omHGAa/j++mvbsx7hJFQaG0EL4YpYVJnkwi3BuKO+8ls4s36a86Bsh
 zlOvwCUctEURiphqLxA5I9F6IMrXHONPI5EG90ajKbRrzTEZ2vyf0cHVvKE1LW3dw1SO
 2EoED3B7iBi2kWs6Kt6+ZWK+Wts8KrfW1Ne+w/oU6FqDpfv8GhUyNoRbYpLmEVAcLh74 ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 31wwhr83sk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 27 Jun 2020 04:35:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R4Y9eF122011;
        Sat, 27 Jun 2020 04:35:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31wv58v89q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Jun 2020 04:35:15 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05R4ZE2Y010374;
        Sat, 27 Jun 2020 04:35:14 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 27 Jun 2020 04:35:13 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hare@suse.de, bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [RFC PATCH 04/10] target: fix xcopy sess release leak
Date:   Fri, 26 Jun 2020 23:35:03 -0500
Message-Id: <1593232509-13720-5-git-send-email-michael.christie@oracle.com>
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

transport_init_session can allocate memory via percpu_ref_init, and
target_xcopy_release_pt never frees it. This adds a
transport_uninit_session function to handle cleanup of resources
allocated in the init function.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_internal.h  |  1 +
 drivers/target/target_core_transport.c |  7 ++++++-
 drivers/target/target_core_xcopy.c     | 11 +++++++++--
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 8533444..e7b3c6e 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -138,6 +138,7 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(struct se_portal_group *tpg,
 void	release_se_kmem_caches(void);
 u32	scsi_get_new_index(scsi_index_t);
 void	transport_subsystem_check_init(void);
+void	transport_uninit_session(struct se_session *);
 unsigned char *transport_dump_cmd_direction(struct se_cmd *);
 void	transport_dump_dev_state(struct se_device *, char *, int *);
 void	transport_dump_dev_info(struct se_device *, struct se_lun *,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3d06f52..0da9bba 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -239,6 +239,11 @@ int transport_init_session(struct se_session *se_sess)
 }
 EXPORT_SYMBOL(transport_init_session);
 
+void transport_uninit_session(struct se_session *se_sess)
+{
+	percpu_ref_exit(&se_sess->cmd_count);
+}
+
 /**
  * transport_alloc_session - allocate a session object and initialize it
  * @sup_prot_ops: bitmask that defines which T10-PI modes are supported.
@@ -594,7 +599,7 @@ void transport_free_session(struct se_session *se_sess)
 		sbitmap_queue_free(&se_sess->sess_tag_pool);
 		kvfree(se_sess->sess_cmd_map);
 	}
-	percpu_ref_exit(&se_sess->cmd_count);
+	transport_uninit_session(se_sess);
 	ida_simple_remove(&se_sess_ida, se_sess->sid);
 	kmem_cache_free(se_sess_cache, se_sess);
 }
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 0d00ccb..44e15d7 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -474,7 +474,7 @@ int target_xcopy_setup_pt(void)
 	memset(&xcopy_pt_sess, 0, sizeof(struct se_session));
 	ret = transport_init_session(&xcopy_pt_sess);
 	if (ret < 0)
-		return ret;
+		goto destroy_wq;
 
 	xcopy_pt_nacl.se_tpg = &xcopy_pt_tpg;
 	xcopy_pt_nacl.nacl_sess = &xcopy_pt_sess;
@@ -483,12 +483,19 @@ int target_xcopy_setup_pt(void)
 	xcopy_pt_sess.se_node_acl = &xcopy_pt_nacl;
 
 	return 0;
+
+destroy_wq:
+	destroy_workqueue(xcopy_wq);
+	xcopy_wq = NULL;
+	return ret;
 }
 
 void target_xcopy_release_pt(void)
 {
-	if (xcopy_wq)
+	if (xcopy_wq) {
 		destroy_workqueue(xcopy_wq);
+		transport_uninit_session(&xcopy_pt_sess);
+	}
 }
 
 /*
-- 
1.8.3.1

