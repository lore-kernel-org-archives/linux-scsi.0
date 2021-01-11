Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC43EC43332
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 00:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9E8522CB8
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 00:33:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405532AbhALAZp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:45 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32608 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403849AbhAKXNU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 18:13:20 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10BN3KCS142679;
        Mon, 11 Jan 2021 18:12:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qo5eJE63wZrxZvsoxpPAFKZcHlR5E2jJ3tsbMsgVvj8=;
 b=SXiLxgxb15MiDuyN3vRYL4CLEOG6NZs6/6y0r46sVQLVx6Ehr8J4jZ0ZdWXXgHMSOH+E
 JRpgxbWOOJicz2HcHFunIQLSAE32AqfaSuU2spHRicPNk36PWvkumtXInbuf423DAAhX
 YhURC9qu3X6aBZ1kvMDu0v218iJwY4ZRC3dQHxQUTNOsDo4T4RMW9we7+ebv52wlkeon
 xvW7m7Ijibdz+7ryEq/KMEN70TTx9iiGBuPzseRMyCMfkgVYiWlR6Ue8JgXb7lZo3Lp8
 KCmeCK0GGdvu2Y1h0/kvhjkFT37+gcy5EvAPuHfEdNz/4AiOXhvnNbgOgFhlU3zFyVRZ EA== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361001r8ps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 18:12:30 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10BN9qtq009897;
        Mon, 11 Jan 2021 23:12:29 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma02wdc.us.ibm.com with ESMTP id 35y448sy9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 23:12:29 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10BNCSuq28180980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jan 2021 23:12:28 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48C4C7805C;
        Mon, 11 Jan 2021 23:12:28 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB4E47805F;
        Mon, 11 Jan 2021 23:12:27 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 11 Jan 2021 23:12:27 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v4 01/21] ibmvfc: add vhost fields and defaults for MQ enablement
Date:   Mon, 11 Jan 2021 17:12:05 -0600
Message-Id: <20210111231225.105347-2-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210111231225.105347-1-tyreld@linux.ibm.com>
References: <20210111231225.105347-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_34:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 mlxscore=0 malwarescore=0 adultscore=0
 clxscore=1015 suspectscore=0 phishscore=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Introduce several new vhost fields for managing MQ state of the adapter
as well as initial defaults for MQ enablement.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 8 ++++++++
 drivers/scsi/ibmvscsi/ibmvfc.h | 9 +++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index ba95438a8912..9200fe49c57e 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -3302,6 +3302,7 @@ static struct scsi_host_template driver_template = {
 	.max_sectors = IBMVFC_MAX_SECTORS,
 	.shost_attrs = ibmvfc_attrs,
 	.track_queue_depth = 1,
+	.host_tagset = 1,
 };
 
 /**
@@ -5290,6 +5291,7 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	shost->max_sectors = IBMVFC_MAX_SECTORS;
 	shost->max_cmd_len = IBMVFC_MAX_CDB_LEN;
 	shost->unique_id = shost->host_no;
+	shost->nr_hw_queues = IBMVFC_MQ ? IBMVFC_SCSI_HW_QUEUES : 1;
 
 	vhost = shost_priv(shost);
 	INIT_LIST_HEAD(&vhost->targets);
@@ -5300,6 +5302,12 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	vhost->partition_number = -1;
 	vhost->log_level = log_level;
 	vhost->task_set = 1;
+
+	vhost->mq_enabled = IBMVFC_MQ;
+	vhost->client_scsi_channels = IBMVFC_SCSI_CHANNELS;
+	vhost->using_channels = 0;
+	vhost->do_enquiry = 1;
+
 	strcpy(vhost->partition_name, "UNKNOWN");
 	init_waitqueue_head(&vhost->work_wait_q);
 	init_waitqueue_head(&vhost->init_wait_q);
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 632e977449c5..dd6d89292867 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -41,6 +41,11 @@
 #define IBMVFC_DEFAULT_LOG_LEVEL	2
 #define IBMVFC_MAX_CDB_LEN		16
 #define IBMVFC_CLS3_ERROR		0
+#define IBMVFC_MQ			0
+#define IBMVFC_SCSI_CHANNELS		0
+#define IBMVFC_SCSI_HW_QUEUES		1
+#define IBMVFC_MIG_NO_SUB_TO_CRQ	0
+#define IBMVFC_MIG_NO_N_TO_M		0
 
 /*
  * Ensure we have resources for ERP and initialization:
@@ -840,6 +845,10 @@ struct ibmvfc_host {
 	int delay_init;
 	int scan_complete;
 	int logged_in;
+	int mq_enabled;
+	int using_channels;
+	int do_enquiry;
+	int client_scsi_channels;
 	int aborting_passthru;
 	int events_to_log;
 #define IBMVFC_AE_LINKUP	0x0001
-- 
2.27.0

