Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15EB2C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 10:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E15352065D
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 10:12:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="S3vgEgiR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbgENKMG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 06:12:06 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:54280 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725974AbgENKMG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 May 2020 06:12:06 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04EAA8oM018694
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 03:12:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=nnqpgDUb6DqAOOFhlNa/F4Hi5P+pcwvGwFzDTMDdiJo=;
 b=S3vgEgiRPTRKmm1lbnKUIKSVFkBmNorEbP3z4S1N/PDcdOEwH2MudNp0L8fkvHuNZFt8
 T9EQr0wAiKPuQUxG4Pdo4VMN9ljSkSu6QuxW8SD3IX3V6RIx3/zxi3dnDwXZ4pe1Hqd1
 6RRHHk4NoGblS4jrNRpwt4STn8ygZJZX1YXrUlIXT+0nBVJo4MJuf/fBq1UVESCLndf4
 o0Uaz6NGCQXYMt1f843al4Ve7gTGpajtMvuOpulfWtsjXoehtpdMIhLXID4n3v3mwIwD
 avUorQX/DQkOCWFpA4fRlFHML1gPtYFssP/OdaTyWm2WgxVjPt0AkwiwPrc960N47EAW Dg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 3100xk1stk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 03:12:05 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 May
 2020 03:12:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 14 May 2020 03:12:02 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id BC1533F704D;
        Thu, 14 May 2020 03:12:02 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 04EAC2cB010095;
        Thu, 14 May 2020 03:12:02 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 04EAC2FX010094;
        Thu, 14 May 2020 03:12:02 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 3/3] qla2xxx: Pass SCM counters to the application.
Date:   Thu, 14 May 2020 03:10:26 -0700
Message-ID: <20200514101026.10040-4-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200514101026.10040-1-njavali@marvell.com>
References: <20200514101026.10040-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_02:2020-05-13,2020-05-14 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shyam Sundar <ssundar@marvell.com>

Implement 3 functions to pass on SAN congestion management
related counters tracked by the driver, up to the Marvell
application using the BSG interface.

Signed-off-by: Shyam Sundar <ssundar@marvell.com>
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 114 +++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_bsg.h |   3 +
 2 files changed, 117 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 97b51c477972..bd898bbdd44d 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2446,6 +2446,111 @@ qla2x00_get_flash_image_status(struct bsg_job *bsg_job)
 	return 0;
 }
 
+static int
+qla2x00_get_drv_attr(struct bsg_job *bsg_job)
+{
+	struct qla_drv_attr drv_attr;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+
+	memset(&drv_attr, 0, sizeof(struct qla_drv_attr));
+	/* Additional check should be added if SCM is not enabled
+	 * by default for a given driver version.
+	 */
+	drv_attr.attributes |= QLA_DRV_ATTR_SCM_SUPPORTED;
+
+	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+			    bsg_job->reply_payload.sg_cnt, &drv_attr,
+			    sizeof(struct qla_drv_attr));
+
+	bsg_reply->reply_payload_rcv_len = sizeof(struct qla_drv_attr);
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = EXT_STATUS_OK;
+
+	bsg_job->reply_len = sizeof(*bsg_job->reply);
+	bsg_reply->result = DID_OK << 16;
+	bsg_job_done(bsg_job, bsg_reply->result,
+		     bsg_reply->reply_payload_rcv_len);
+
+	return 0;
+}
+
+static int
+qla2x00_get_port_scm(struct bsg_job *bsg_job)
+{
+	struct Scsi_Host *shost = fc_bsg_to_shost(bsg_job);
+	scsi_qla_host_t *vha = shost_priv(shost);
+	struct qla_hw_data *ha = vha->hw;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+
+	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+		return -EPERM;
+
+	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+			    bsg_job->reply_payload.sg_cnt, &vha->scm_stats,
+			    sizeof(struct qla_scm_port));
+
+	bsg_reply->reply_payload_rcv_len = sizeof(struct qla_scm_port);
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = EXT_STATUS_OK;
+
+	bsg_job->reply_len = sizeof(*bsg_job->reply);
+	bsg_reply->result = DID_OK << 16;
+	bsg_job_done(bsg_job, bsg_reply->result,
+		     bsg_reply->reply_payload_rcv_len);
+
+	return 0;
+}
+
+static int
+qla2x00_get_target_scm(struct bsg_job *bsg_job)
+{
+	struct Scsi_Host *shost = fc_bsg_to_shost(bsg_job);
+	scsi_qla_host_t *vha = shost_priv(shost);
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+	struct qla_hw_data *ha = vha->hw;
+	fc_port_t *fcport =  NULL;
+	int rval;
+	struct qla_scm_target *scm_stats = NULL;
+
+	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+		return -EPERM;
+
+	scm_stats = kzalloc(sizeof(*scm_stats), GFP_KERNEL);
+	if (!scm_stats) {
+		ql_log(ql_log_warn, vha, 0x7024,
+		       "Failed to allocate memory for target scm stats.\n");
+		return -ENOMEM;
+	}
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+			  bsg_job->request_payload.sg_cnt, scm_stats,
+			  sizeof(struct qla_scm_target));
+
+	fcport = qla2x00_find_fcport_by_wwpn(vha, scm_stats->wwpn, 0);
+	if (fcport) {
+		/* Copy SCM Target data to local struct, keep WWPN from user */
+		memcpy(&scm_stats->current_events,
+		       &fcport->scm_stats.current_events,
+		       (sizeof(struct qla_scm_target) -
+			sizeof(scm_stats->wwpn)));
+		sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+				    bsg_job->reply_payload.sg_cnt, scm_stats,
+				    sizeof(struct qla_scm_target));
+		rval = EXT_STATUS_OK;
+	} else {
+		rval = EXT_STATUS_ERR;
+	}
+
+	bsg_reply->reply_payload_rcv_len = sizeof(struct qla_scm_target);
+	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = rval;
+
+	bsg_job->reply_len = sizeof(*bsg_job->reply);
+	bsg_reply->result = DID_OK << 16;
+	bsg_job_done(bsg_job, bsg_reply->result,
+		     bsg_reply->reply_payload_rcv_len);
+
+	kfree(scm_stats);
+	return 0;
+}
+
 static int
 qla2x00_process_vendor_specific(struct bsg_job *bsg_job)
 {
@@ -2522,6 +2627,15 @@ qla2x00_process_vendor_specific(struct bsg_job *bsg_job)
 	case QL_VND_SS_GET_FLASH_IMAGE_STATUS:
 		return qla2x00_get_flash_image_status(bsg_job);
 
+	case QL_VND_GET_PORT_SCM:
+		return qla2x00_get_port_scm(bsg_job);
+
+	case QL_VND_GET_TARGET_SCM:
+		return qla2x00_get_target_scm(bsg_job);
+
+	case QL_VND_GET_DRV_ATTR:
+		return qla2x00_get_drv_attr(bsg_job);
+
 	default:
 		return -ENOSYS;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
index 0b308859047c..c7cf5f772ad3 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_bsg.h
@@ -32,6 +32,9 @@
 #define QL_VND_DPORT_DIAGNOSTICS	0x19
 #define QL_VND_GET_PRIV_STATS_EX	0x1A
 #define QL_VND_SS_GET_FLASH_IMAGE_STATUS	0x1E
+#define QL_VND_GET_PORT_SCM		0x20
+#define QL_VND_GET_TARGET_SCM		0x21
+#define QL_VND_GET_DRV_ATTR		0x22
 
 /* BSG Vendor specific subcode returns */
 #define EXT_STATUS_OK			0
-- 
2.19.0.rc0

