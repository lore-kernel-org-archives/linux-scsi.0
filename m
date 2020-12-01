Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D823FC83014
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 21:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AC4B2084C
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 21:31:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="va1tVhGK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388547AbgLAVbE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 16:31:04 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46690 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729276AbgLAVbC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 16:31:02 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LTSZL019066;
        Tue, 1 Dec 2020 21:30:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=WXTJyZ7YhzW2sn1TTiainNRd9+fFo7YBpgxjXDod+nI=;
 b=va1tVhGKfYUGYZ9xE3AoNrZvkPMsoQRGo5K6crs9mi31AElTDHqZvBwqcjTgUZDsVWmh
 iqRqX4/BYsryu6o79jLUOzwvzKjpUwcl3sfMaTe1R/DwRjl/df5vfXICiGnAt5CJzIdL
 Zn/R49VyIA2KEDlwnqnwLSkNao1MYdE96r6YkaZyMQngknlDP+taxNAKdqdrOZpo2y4j
 xODtIl6AkWsI3+U4qNXOi8YcQZJPK8JvBIDwzNLv+093nqHnQag8mMWNzK58iHBzye9j
 tnhvTdztS8C7teAIg3K9aBn3wwLzzXm7VNmeIeyMpPFzuOCQaZa8aZSBKdUF/pEwX8Gk qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 353dyqmy26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 01 Dec 2020 21:30:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LAP5g068034;
        Tue, 1 Dec 2020 21:30:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35404ndkkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Dec 2020 21:30:11 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B1LUA6c018348;
        Tue, 1 Dec 2020 21:30:10 GMT
Received: from ol2.localdomain (/73.88.28.6)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 13:30:10 -0800
From:   Mike Christie <michael.christie@oracle.com>
To:     subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com,
        jitendra.bhivare@broadcom.com, lduncan@suse.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, varun@chelsio.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: [PATCH 08/15] iser, be2iscsi, qla4xxx: set scsi_host_template cmd_size
Date:   Tue,  1 Dec 2020 15:29:49 -0600
Message-Id: <1606858196-5421-9-git-send-email-michael.christie@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
References: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010129
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=2 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010130
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
index cd3189b..91bc822 100644
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
index 5942d2a..ea1ef77 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2830,6 +2830,23 @@ static void iscsi_host_dec_session_cnt(struct Scsi_Host *shost)
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
index e918af7..c2283f9 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -460,6 +460,7 @@ extern int __iscsi_complete_pdu(struct iscsi_conn *, struct iscsi_hdr *,
 extern void __iscsi_get_task(struct iscsi_task *task);
 extern void iscsi_complete_scsi_task(struct iscsi_task *task,
 				     uint32_t exp_cmdsn, uint32_t max_cmdsn);
+extern int iscsi_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd);
 
 /*
  * generic helpers
-- 
1.8.3.1

