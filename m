Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D65C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:45:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 022B020672
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:45:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MVaCBzij"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgGBBp3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 21:45:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34922 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728131AbgGBBp3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 21:45:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0621d0Ek155850;
        Thu, 2 Jul 2020 01:45:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=tE3kFlaOk7xz7kinaT/6Uao6WzALtlB8cSTjFtmf16M=;
 b=MVaCBzijXTqH6no+1xausGKUlF2NhcBh1UYdxf44E5uDfOjr4j4WN2s3wXacfmRtITEP
 p9vLzScePY24RxlGSieoRtFE0KyFG5aQe+XHRO8NXvVw2EyP4v9mUQOt9ePP+vQReh6Z
 e82tUIsto+S7vAYtY55QmTZu44pejzxOjCxdtyiQJBdC0J3HTsXODBf9+MycLeyTuVH+
 m082RK6atuOgTiIBH76AZ1hF0z5MCmdkLmiCHfNgBwZJ881voqyyrUrvXOeFkS1YACxg
 goIizCI+oem7/1g4f8n76ZMJbAhDFn6OxKXqmGvAnt3LRJt7FiP+MpmhL+sBqQqCBzzl Rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31xx1e2hy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 02 Jul 2020 01:45:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0621glKO050688;
        Thu, 2 Jul 2020 01:43:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 31xg17stfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jul 2020 01:43:25 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0621hOlh022092;
        Thu, 2 Jul 2020 01:43:24 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jul 2020 01:43:24 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, bstroesser@ts.fujitsu.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH 2/7] target: fix xcopy sess release leak
Date:   Wed,  1 Jul 2020 20:43:18 -0500
Message-Id: <1593654203-12442-3-git-send-email-michael.christie@oracle.com>
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
index 90ecdd7..e6e1fa6 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -236,6 +236,11 @@ int transport_init_session(struct se_session *se_sess)
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
@@ -579,7 +584,7 @@ void transport_free_session(struct se_session *se_sess)
 		sbitmap_queue_free(&se_sess->sess_tag_pool);
 		kvfree(se_sess->sess_cmd_map);
 	}
-	percpu_ref_exit(&se_sess->cmd_count);
+	transport_uninit_session(se_sess);
 	kmem_cache_free(se_sess_cache, se_sess);
 }
 EXPORT_SYMBOL(transport_free_session);
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

