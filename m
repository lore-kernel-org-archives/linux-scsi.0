Return-Path: <SRS0=TRkT=B4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C032FC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 12:34:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F2EA206B5
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Aug 2020 12:34:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="UmAW7216"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgHRMeR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Aug 2020 08:34:17 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39204 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726688AbgHRMeH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Aug 2020 08:34:07 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07ICViIK026313
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2020 05:34:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=w2zHdnYFW/DS4x2zboVRrbKv1TQe6rPoStPkEEqdCjE=;
 b=UmAW7216S36NkdlUoULPXqjENa8YzPfDUd9s7+NYXPxDl4tBl5BILuxoe4d5yF55+UNR
 +t5OBzdndFf7/8/q1NqcnaKgEZk7npbcdpfm3LBQKoH+hHEFd908dZnka6kCp5uidiEc
 w0sbBP8iQspi89ZXLJNQz9vonp8k2XL3YHHz5+Cbt3rt2Z030RxFx2jkTmamuVeiBdhS
 HwLKm/L5Hy0joUq/oQCyHncQvs/tHR/xoCtXwhd+ker8VOV2JHiIthavpGfKBBPtp/96
 953MJH7XyHJTlz+0botGdI3AeIVbCO14700dNG9obWYEYwbUERfNuCXvfWSBwUWcvhfc pQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3304hhjckp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2020 05:34:05 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 18 Aug
 2020 05:34:03 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 18 Aug 2020 05:34:03 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C5DF13F7044;
        Tue, 18 Aug 2020 05:34:03 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 07ICY335020429;
        Tue, 18 Aug 2020 05:34:03 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 07ICY3nb020420;
        Tue, 18 Aug 2020 05:34:03 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 04/12] qla2xxx: Honor status qualifier in FCP_RSP per spec
Date:   Tue, 18 Aug 2020 05:31:55 -0700
Message-ID: <20200818123203.20361-5-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200818123203.20361-1-njavali@marvell.com>
References: <20200818123203.20361-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_07:2020-08-18,2020-08-18 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

FCP-4 (referred FCP-4 rev-2b) identifies the earlier known "retry delay
timer" field as "status qualifier", which is described in SAM-5 and
later specs. This fix makes appropriate driver side modifications to
honor the new definition. The SAM document referred was SAM-6 rev-5.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_fw.h     |  2 +-
 drivers/scsi/qla2xxx/qla_inline.h | 38 +++++++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_isr.c    | 18 ++++-----------
 3 files changed, 40 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index bba1b77fba7e..f0052d75849c 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -619,7 +619,7 @@ struct sts_entry_24xx {
 #define SF_NVME_ERSP            BIT_6
 #define SF_FCP_RSP_DMA		BIT_0
 
-	__le16	retry_delay;
+	__le16	status_qualifier;
 	__le16	scsi_status;		/* SCSI status. */
 #define SS_CONFIRMATION_REQ		BIT_12
 
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 861dc522723c..5501b4c581ec 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -266,11 +266,41 @@ qla2x00_handle_mbx_completion(struct qla_hw_data *ha, int status)
 }
 
 static inline void
-qla2x00_set_retry_delay_timestamp(fc_port_t *fcport, uint16_t retry_delay)
+qla2x00_set_retry_delay_timestamp(fc_port_t *fcport, uint16_t sts_qual)
 {
-	if (retry_delay)
-		fcport->retry_delay_timestamp = jiffies +
-		    (retry_delay * HZ / 10);
+	u8 scope;
+	u16 qual;
+#define SQ_SCOPE_MASK		0xc000 /* SAM-6 rev5 5.3.2 */
+#define SQ_SCOPE_SHIFT		14
+#define SQ_QUAL_MASK		0x3fff
+
+#define SQ_MAX_WAIT_SEC		60 /* Max I/O hold off time in seconds. */
+#define SQ_MAX_WAIT_TIME	(SQ_MAX_WAIT_SEC * 10) /* in 100ms. */
+
+	if (!sts_qual) /* Common case. */
+		return;
+
+	scope = (sts_qual & SQ_SCOPE_MASK) >> SQ_SCOPE_SHIFT;
+	/* Handle only scope 1 or 2, which is for I-T nexus. */
+	if (scope != 1 && scope != 2)
+		return;
+
+	/* Skip processing, if retry delay timer is already in effect. */
+	if (fcport->retry_delay_timestamp &&
+	    time_before(jiffies, fcport->retry_delay_timestamp))
+		return;
+
+	qual = sts_qual & SQ_QUAL_MASK;
+	if (qual < 1 || qual > 0x3fef)
+		return;
+	qual = min(qual, (u16)SQ_MAX_WAIT_TIME);
+
+	/* qual is expressed in 100ms increments. */
+	fcport->retry_delay_timestamp = jiffies + (qual * HZ / 10);
+
+	ql_log(ql_log_warn, fcport->vha, 0x5101,
+	       "%8phC: I/O throttling requested (status qualifier = %04xh), holding off I/Os for %ums.\n",
+	       fcport->port_name, sts_qual, qual * 100);
 }
 
 static inline bool
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ab5275dbc338..d38dd6520b53 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2855,7 +2855,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	int logit = 1;
 	int res = 0;
 	uint16_t state_flags = 0;
-	uint16_t retry_delay = 0;
+	uint16_t sts_qual = 0;
 
 	if (IS_FWI2_CAPABLE(ha)) {
 		comp_status = le16_to_cpu(sts24->comp_status);
@@ -2953,8 +2953,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	sense_len = par_sense_len = rsp_info_len = resid_len =
 	    fw_resid_len = 0;
 	if (IS_FWI2_CAPABLE(ha)) {
-		u16 sts24_retry_delay = le16_to_cpu(sts24->retry_delay);
-
 		if (scsi_status & SS_SENSE_LEN_VALID)
 			sense_len = le32_to_cpu(sts24->sense_len);
 		if (scsi_status & SS_RESPONSE_INFO_LEN_VALID)
@@ -2968,13 +2966,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		host_to_fcp_swap(sts24->data, sizeof(sts24->data));
 		ox_id = le16_to_cpu(sts24->ox_id);
 		par_sense_len = sizeof(sts24->data);
-		/* Valid values of the retry delay timer are 0x1-0xffef */
-		if (sts24_retry_delay > 0 && sts24_retry_delay < 0xfff1) {
-			retry_delay = sts24_retry_delay & 0x3fff;
-			ql_dbg(ql_dbg_io, sp->vha, 0x3033,
-			    "%s: scope=%#x retry_delay=%#x\n", __func__,
-			    sts24_retry_delay >> 14, retry_delay);
-		}
+		sts_qual = le16_to_cpu(sts24->status_qualifier);
 	} else {
 		if (scsi_status & SS_SENSE_LEN_VALID)
 			sense_len = le16_to_cpu(sts->req_sense_length);
@@ -3012,9 +3004,9 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	 * Check retry_delay_timer value if we receive a busy or
 	 * queue full.
 	 */
-	if (lscsi_status == SAM_STAT_TASK_SET_FULL ||
-	    lscsi_status == SAM_STAT_BUSY)
-		qla2x00_set_retry_delay_timestamp(fcport, retry_delay);
+	if (unlikely(lscsi_status == SAM_STAT_TASK_SET_FULL ||
+		     lscsi_status == SAM_STAT_BUSY))
+		qla2x00_set_retry_delay_timestamp(fcport, sts_qual);
 
 	/*
 	 * Based on Host and scsi status generate status code for Linux
-- 
2.19.0.rc0

