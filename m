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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D32F0C4361B
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6DF023899
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 06:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgLQGn2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Dec 2020 01:43:28 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:54890 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgLQGnU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Dec 2020 01:43:20 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6UL6q147226;
        Thu, 17 Dec 2020 06:42:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=z2akESREri0R+PDnqWRYuuaxfCNjX4vbrQaAXPIC1Es=;
 b=fvwXyPSESdodK+hmWqSsgigtqoX4pkLYOQpQbcxlj6tp9cHeSne3/43U8HLjvS+mZzla
 JJUCmdbFE6T5qWK2bYHQmSXTVQgqrUdo8Wfxc9rYNCpC6mSti7kIIonCJ3c35ljH6wA/
 fXzJepSSXxGFlELcAj796ayvVkUb2T7eaLb0wksARLimmENxRsQxG0JbtMeQSVzB5wSI
 vO3ynou6Sz5FzmzZ5AfVwyxp0ybtBpudua9IyFG5kUbhKQ2gbbpQjdJjjpmY51ia1oiy
 E3ZuvdF2Nf6Dym6uUbKWq0f6KayZebCfzohe2oMccg8iCx5Yq1AeTQ7/DOb9AnTGZzH+ Ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35ckcbm1r7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Dec 2020 06:42:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BH6VCk2020060;
        Thu, 17 Dec 2020 06:42:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 35e6esvftd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 06:42:30 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BH6gUcS018262;
        Thu, 17 Dec 2020 06:42:30 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Dec 2020 22:42:29 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        varun@chelsio.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
Subject: [PATCH 11/22] iser, be2iscsi, qla4xxx: set scsi_host_template cmd_size
Date:   Thu, 17 Dec 2020 00:42:01 -0600
Message-Id: <1608187332-4434-12-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
References: <1608187332-4434-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012170047
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_host_template cmd_size so the block/scsi-ml layers allocate
the iscsi structs for the driver. This patch includes the easy drivers
that just needed to set the size and a helper to init the iscsi task.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |  3 +++
 drivers/scsi/be2iscsi/be_main.c          |  2 ++
 drivers/scsi/libiscsi.c                  | 17 +++++++++++++++++
 drivers/scsi/qla4xxx/ql4_os.c            |  3 +++
 include/scsi/libiscsi.h                  |  1 +
 5 files changed, 26 insertions(+)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 3690e28..96f44eb 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -976,6 +976,9 @@ static umode_t iser_attr_is_visible(int param_type, int param)
 	.proc_name              = "iscsi_iser",
 	.this_id                = -1,
 	.track_queue_depth	= 1,
+	.cmd_size		= sizeof(struct iscsi_iser_task) +
+				  sizeof(struct iscsi_task),
+	.init_cmd_priv		= iscsi_init_cmd_priv,
 };
 
 static struct iscsi_transport iscsi_iser_transport = {
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 5c3513a..221ce17 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -401,6 +401,8 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	.cmd_per_lun = BEISCSI_CMD_PER_LUN,
 	.vendor_id = SCSI_NL_VID_TYPE_PCI | BE_VENDOR_ID,
 	.track_queue_depth = 1,
+	.cmd_size = sizeof(struct beiscsi_io_task) + sizeof(struct iscsi_task),
+	.init_cmd_priv = iscsi_init_cmd_priv,
 };
 
 static struct scsi_transport_template *beiscsi_scsi_transport;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 9833fc3..0c9e220 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2795,6 +2795,23 @@ static void iscsi_host_dec_session_cnt(struct Scsi_Host *shost)
 	scsi_host_put(shost);
 }
 
+static void iscsi_init_task(struct iscsi_task *task)
+{
+	task->dd_data = &task[1];
+	task->itt = ISCSI_RESERVED_TAG;
+	task->state = ISCSI_TASK_FREE;
+	INIT_LIST_HEAD(&task->running);
+}
+
+int iscsi_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *sc)
+{
+	struct iscsi_task *task = scsi_cmd_priv(sc);
+
+	iscsi_init_task(task);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iscsi_init_cmd_priv);
+
 /**
  * iscsi_session_setup - create iscsi cls session and host and session
  * @iscsit: iscsi transport template
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6996942..c20b7c3 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -239,6 +239,9 @@ static int qla4xxx_sysfs_ddb_logout(struct iscsi_bus_flash_session *fnode_sess,
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
 	.sg_tablesize		= SG_ALL,
+	.cmd_size		= sizeof(struct ql4_task_data) +
+				  sizeof(struct iscsi_task),
+	.init_cmd_priv		= iscsi_init_cmd_priv,
 
 	.max_sectors		= 0xFFFF,
 	.shost_attrs		= qla4xxx_host_attrs,
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 2f99ad6..4f6ca2d 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -458,6 +458,7 @@ extern int __iscsi_complete_pdu(struct iscsi_conn *, struct iscsi_hdr *,
 extern void __iscsi_get_task(struct iscsi_task *task);
 extern void iscsi_complete_scsi_task(struct iscsi_task *task,
 				     uint32_t exp_cmdsn, uint32_t max_cmdsn);
+extern int iscsi_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd);
 
 /*
  * generic helpers
-- 
1.8.3.1

