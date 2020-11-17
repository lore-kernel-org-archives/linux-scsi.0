Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DDA7C64E7B
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 19:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 499392223D
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 19:17:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="O+cmqdFb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgKQTRD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 14:17:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30276 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728188AbgKQTQu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 14:16:50 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHJ2UPG142139;
        Tue, 17 Nov 2020 14:16:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wfTh43yo6tR8KKm47aaimz3ojUmx2IDDWAJTc7aRuK0=;
 b=O+cmqdFbaP8vw1lDVj82WQMxPmFZWiXLrQ9FOlU5hjL+j8yzqudxbw5PXAZs2zLZ/g4w
 JplnpbsCuuGo5y8vUAxCd5qDP9QUNfjrJLqIUAhy98CNpu9ygdA2l9N59PlKWuUL+5Wj
 xrMHPR06Hv0L9AQlBDvJEkCQEVGqjLXnddJgmWAy004HzeaKWwSbCa+DaNWPcF+4AnnY
 rSpz+xQxi4U2Rl19HwbfOZcio2rUr6hhIJwvo+NazYoAbMJnljW/vboxAuLMPgMSFLFm
 nX/sMMtXu/ClE6Xc9nmbeY/ExrgkiC75DIWbewoZ+OIqlwTmociAx3pseU9MbCn5yhsT Yw== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34vevtc8vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 14:16:43 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHJ8LpD004754;
        Tue, 17 Nov 2020 19:16:42 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04wdc.us.ibm.com with ESMTP id 34t6v90qmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 19:16:42 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHJGfXq66781582
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 19:16:41 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E293C6057;
        Tue, 17 Nov 2020 19:16:41 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9DC88C6055;
        Tue, 17 Nov 2020 19:16:40 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 19:16:40 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 4/6] ibmvfc: add FC payload retrieval routines for versioned vfcFrames
Date:   Tue, 17 Nov 2020 13:16:34 -0600
Message-Id: <20201117191636.131127-5-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117191636.131127-1-tyreld@linux.ibm.com>
References: <20201117191636.131127-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_07:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 spamscore=0 malwarescore=0 suspectscore=1 clxscore=1015
 impostorscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170133
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The FC iu and response payloads are located at different offsets
depending on the ibmvfc_cmd version. This is a result of the version 2
vfcFrame definition adding an extra 64bytes of reserved space to the
structure prior to the payloads.

Add helper routines to determine the current vfcFrame version and
returning pointers to the proper iu or response structures within that
ibmvfc_cmd.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 75 +++++++++++++++++++++++-----------
 1 file changed, 52 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index a68602cd1255..4549cdee2cc0 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -145,6 +145,24 @@ static int ibmvfc_check_caps(struct ibmvfc_host *vhost, unsigned long cap_flags)
 	return (host_caps & cap_flags) ? 1 : 0;
 }
 
+static struct ibmvfc_fcp_cmd_iu *ibmvfc_get_fcp_iu(struct ibmvfc_host *vhost,
+						   struct ibmvfc_cmd *vfc_cmd)
+{
+	if (ibmvfc_check_caps(vhost, IBMVFC_HANDLE_VF_WWPN))
+		return &vfc_cmd->v2.iu;
+	else
+		return &vfc_cmd->v1.iu;
+}
+
+static struct ibmvfc_fcp_rsp *ibmvfc_get_fcp_rsp(struct ibmvfc_host *vhost,
+						 struct ibmvfc_cmd *vfc_cmd)
+{
+	if (ibmvfc_check_caps(vhost, IBMVFC_HANDLE_VF_WWPN))
+		return &vfc_cmd->v2.rsp;
+	else
+		return &vfc_cmd->v1.rsp;
+}
+
 #ifdef CONFIG_SCSI_IBMVFC_TRACE
 /**
  * ibmvfc_trc_start - Log a start trace entry
@@ -156,7 +174,7 @@ static void ibmvfc_trc_start(struct ibmvfc_event *evt)
 	struct ibmvfc_host *vhost = evt->vhost;
 	struct ibmvfc_cmd *vfc_cmd = &evt->iu.cmd;
 	struct ibmvfc_mad_common *mad = &evt->iu.mad_common;
-	struct ibmvfc_fcp_cmd_iu *iu = &vfc_cmd->v1.iu;
+	struct ibmvfc_fcp_cmd_iu *iu = ibmvfc_get_fcp_iu(vhost, vfc_cmd);
 	struct ibmvfc_trace_entry *entry;
 
 	entry = &vhost->trace[vhost->trace_index++];
@@ -191,8 +209,8 @@ static void ibmvfc_trc_end(struct ibmvfc_event *evt)
 	struct ibmvfc_host *vhost = evt->vhost;
 	struct ibmvfc_cmd *vfc_cmd = &evt->xfer_iu->cmd;
 	struct ibmvfc_mad_common *mad = &evt->xfer_iu->mad_common;
-	struct ibmvfc_fcp_cmd_iu *iu = &vfc_cmd->v1.iu;
-	struct ibmvfc_fcp_rsp *rsp = &vfc_cmd->v1.rsp;
+	struct ibmvfc_fcp_cmd_iu *iu = ibmvfc_get_fcp_iu(vhost, vfc_cmd);
+	struct ibmvfc_fcp_rsp *rsp = ibmvfc_get_fcp_rsp(vhost, vfc_cmd);
 	struct ibmvfc_trace_entry *entry = &vhost->trace[vhost->trace_index++];
 
 	entry->evt = evt;
@@ -270,10 +288,10 @@ static const char *ibmvfc_get_cmd_error(u16 status, u16 error)
  * Return value:
  *	SCSI result value to return for completed command
  **/
-static int ibmvfc_get_err_result(struct ibmvfc_cmd *vfc_cmd)
+static int ibmvfc_get_err_result(struct ibmvfc_host *vhost, struct ibmvfc_cmd *vfc_cmd)
 {
 	int err;
-	struct ibmvfc_fcp_rsp *rsp = &vfc_cmd->v1.rsp;
+	struct ibmvfc_fcp_rsp *rsp = ibmvfc_get_fcp_rsp(vhost, vfc_cmd);
 	int fc_rsp_len = be32_to_cpu(rsp->fcp_rsp_len);
 
 	if ((rsp->flags & FCP_RSP_LEN_VALID) &&
@@ -1388,7 +1406,7 @@ static int ibmvfc_map_sg_data(struct scsi_cmnd *scmd,
 	int sg_mapped;
 	struct srp_direct_buf *data = &vfc_cmd->ioba;
 	struct ibmvfc_host *vhost = dev_get_drvdata(dev);
-	struct ibmvfc_fcp_cmd_iu *iu = &vfc_cmd->v1.iu;
+	struct ibmvfc_fcp_cmd_iu *iu = ibmvfc_get_fcp_iu(evt->vhost, vfc_cmd);
 
 	if (cls3_error)
 		vfc_cmd->flags |= cpu_to_be16(IBMVFC_CLASS_3_ERR);
@@ -1527,7 +1545,7 @@ static void ibmvfc_log_error(struct ibmvfc_event *evt)
 {
 	struct ibmvfc_cmd *vfc_cmd = &evt->xfer_iu->cmd;
 	struct ibmvfc_host *vhost = evt->vhost;
-	struct ibmvfc_fcp_rsp *rsp = &vfc_cmd->v1.rsp;
+	struct ibmvfc_fcp_rsp *rsp = ibmvfc_get_fcp_rsp(vhost, vfc_cmd);
 	struct scsi_cmnd *cmnd = evt->cmnd;
 	const char *err = unknown_error;
 	int index = ibmvfc_get_err_index(be16_to_cpu(vfc_cmd->status), be16_to_cpu(vfc_cmd->error));
@@ -1581,7 +1599,7 @@ static void ibmvfc_relogin(struct scsi_device *sdev)
 static void ibmvfc_scsi_done(struct ibmvfc_event *evt)
 {
 	struct ibmvfc_cmd *vfc_cmd = &evt->xfer_iu->cmd;
-	struct ibmvfc_fcp_rsp *rsp = &vfc_cmd->v1.rsp;
+	struct ibmvfc_fcp_rsp *rsp = ibmvfc_get_fcp_rsp(evt->vhost, vfc_cmd);
 	struct scsi_cmnd *cmnd = evt->cmnd;
 	u32 rsp_len = 0;
 	u32 sense_len = be32_to_cpu(rsp->fcp_sense_len);
@@ -1595,7 +1613,7 @@ static void ibmvfc_scsi_done(struct ibmvfc_event *evt)
 			scsi_set_resid(cmnd, 0);
 
 		if (vfc_cmd->status) {
-			cmnd->result = ibmvfc_get_err_result(vfc_cmd);
+			cmnd->result = ibmvfc_get_err_result(evt->vhost, vfc_cmd);
 
 			if (rsp->flags & FCP_RSP_LEN_VALID)
 				rsp_len = be32_to_cpu(rsp->fcp_rsp_len);
@@ -1660,18 +1678,23 @@ static inline int ibmvfc_host_chkready(struct ibmvfc_host *vhost)
 static struct ibmvfc_cmd *ibmvfc_init_vfc_cmd(struct ibmvfc_event *evt, struct scsi_device *sdev)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
+	struct ibmvfc_host *vhost = evt->vhost;
 	struct ibmvfc_cmd *vfc_cmd = &evt->iu.cmd;
-	size_t offset = offsetof(struct ibmvfc_cmd, v1.rsp);
+	size_t offset;
 
 	memset(vfc_cmd, 0, sizeof(*vfc_cmd));
+	if (be64_to_cpu(vhost->login_buf->resp.capabilities) & IBMVFC_HANDLE_VF_WWPN)
+		offset = offsetof(struct ibmvfc_cmd, v2.rsp);
+	else
+		offset = offsetof(struct ibmvfc_cmd, v1.rsp);
 	vfc_cmd->resp.va = cpu_to_be64(be64_to_cpu(evt->crq.ioba) + offset);
-	vfc_cmd->resp.len = cpu_to_be32(sizeof(vfc_cmd->v1.rsp));
+	vfc_cmd->resp.len = cpu_to_be32(sizeof(*rsp));
 	vfc_cmd->frame_type = cpu_to_be32(IBMVFC_SCSI_FCP_TYPE);
-	vfc_cmd->payload_len = cpu_to_be32(sizeof(vfc_cmd->v1.iu));
-	vfc_cmd->resp_len = cpu_to_be32(sizeof(vfc_cmd->v1.rsp));
+	vfc_cmd->payload_len = cpu_to_be32(sizeof(*iu));
+	vfc_cmd->resp_len = cpu_to_be32(sizeof(*rsp));
 	vfc_cmd->cancel_key = cpu_to_be32((unsigned long)sdev->hostdata);
 	vfc_cmd->tgt_scsi_id = cpu_to_be64(rport->port_id);
-	int_to_scsilun(sdev->lun, &vfc_cmd->v1.iu.lun);
+	int_to_scsilun(sdev->lun, &iu->lun);
 
 	return vfc_cmd;
 }
@@ -1690,6 +1713,7 @@ static int ibmvfc_queuecommand_lck(struct scsi_cmnd *cmnd,
 	struct ibmvfc_host *vhost = shost_priv(cmnd->device->host);
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	struct ibmvfc_cmd *vfc_cmd;
+	struct ibmvfc_fcp_cmd_iu *iu;
 	struct ibmvfc_event *evt;
 	int rc;
 
@@ -1707,13 +1731,14 @@ static int ibmvfc_queuecommand_lck(struct scsi_cmnd *cmnd,
 	cmnd->scsi_done = done;
 
 	vfc_cmd = ibmvfc_init_vfc_cmd(evt, cmnd->device);
+	iu = ibmvfc_get_fcp_iu(vhost, vfc_cmd);
 
-	vfc_cmd->v1.iu.xfer_len = cpu_to_be32(scsi_bufflen(cmnd));
-	memcpy(vfc_cmd->v1.iu.cdb, cmnd->cmnd, cmnd->cmd_len);
+	iu->xfer_len = cpu_to_be32(scsi_bufflen(cmnd));
+	memcpy(iu->cdb, cmnd->cmnd, cmnd->cmd_len);
 
 	if (cmnd->flags & SCMD_TAGGED) {
 		vfc_cmd->task_tag = cpu_to_be64(cmnd->tag);
-		vfc_cmd->v1.iu.pri_task_attr = IBMVFC_SIMPLE_TASK;
+		iu->pri_task_attr = IBMVFC_SIMPLE_TASK;
 	}
 
 	vfc_cmd->correlation = cpu_to_be64(evt);
@@ -2040,7 +2065,8 @@ static int ibmvfc_reset_device(struct scsi_device *sdev, int type, char *desc)
 	struct ibmvfc_cmd *tmf;
 	struct ibmvfc_event *evt = NULL;
 	union ibmvfc_iu rsp_iu;
-	struct ibmvfc_fcp_rsp *fc_rsp = &rsp_iu.cmd.v1.rsp;
+	struct ibmvfc_fcp_cmd_iu *iu;
+	struct ibmvfc_fcp_rsp *fc_rsp = ibmvfc_get_fcp_rsp(vhost, &rsp_iu.cmd);
 	int rsp_rc = -EBUSY;
 	unsigned long flags;
 	int rsp_code = 0;
@@ -2050,9 +2076,10 @@ static int ibmvfc_reset_device(struct scsi_device *sdev, int type, char *desc)
 		evt = ibmvfc_get_event(vhost);
 		ibmvfc_init_event(evt, ibmvfc_sync_completion, IBMVFC_CMD_FORMAT);
 		tmf = ibmvfc_init_vfc_cmd(evt, sdev);
+		iu = ibmvfc_get_fcp_iu(vhost, tmf);
 
 		tmf->flags = cpu_to_be16((IBMVFC_NO_MEM_DESC | IBMVFC_TMF));
-		tmf->v1.iu.tmf_flags = type;
+		iu->tmf_flags = type;
 		evt->sync_iu = &rsp_iu;
 
 		init_completion(&evt->comp);
@@ -2070,7 +2097,7 @@ static int ibmvfc_reset_device(struct scsi_device *sdev, int type, char *desc)
 	wait_for_completion(&evt->comp);
 
 	if (rsp_iu.cmd.status)
-		rsp_code = ibmvfc_get_err_result(&rsp_iu.cmd);
+		rsp_code = ibmvfc_get_err_result(vhost, &rsp_iu.cmd);
 
 	if (rsp_code) {
 		if (fc_rsp->flags & FCP_RSP_LEN_VALID)
@@ -2345,7 +2372,8 @@ static int ibmvfc_abort_task_set(struct scsi_device *sdev)
 	struct ibmvfc_cmd *tmf;
 	struct ibmvfc_event *evt, *found_evt;
 	union ibmvfc_iu rsp_iu;
-	struct ibmvfc_fcp_rsp *fc_rsp = &rsp_iu.cmd.v1.rsp;
+	struct ibmvfc_fcp_cmd_iu *iu;
+	struct ibmvfc_fcp_rsp *fc_rsp = ibmvfc_get_fcp_rsp(vhost, &rsp_iu.cmd);
 	int rc, rsp_rc = -EBUSY;
 	unsigned long flags, timeout = IBMVFC_ABORT_TIMEOUT;
 	int rsp_code = 0;
@@ -2370,9 +2398,10 @@ static int ibmvfc_abort_task_set(struct scsi_device *sdev)
 		evt = ibmvfc_get_event(vhost);
 		ibmvfc_init_event(evt, ibmvfc_sync_completion, IBMVFC_CMD_FORMAT);
 		tmf = ibmvfc_init_vfc_cmd(evt, sdev);
+		iu = ibmvfc_get_fcp_iu(vhost, tmf);
 
+		iu->tmf_flags = IBMVFC_ABORT_TASK_SET;
 		tmf->flags = cpu_to_be16((IBMVFC_NO_MEM_DESC | IBMVFC_TMF));
-		tmf->v1.iu.tmf_flags = IBMVFC_ABORT_TASK_SET;
 		evt->sync_iu = &rsp_iu;
 
 		tmf->correlation = cpu_to_be64(evt);
@@ -2421,7 +2450,7 @@ static int ibmvfc_abort_task_set(struct scsi_device *sdev)
 	}
 
 	if (rsp_iu.cmd.status)
-		rsp_code = ibmvfc_get_err_result(&rsp_iu.cmd);
+		rsp_code = ibmvfc_get_err_result(vhost, &rsp_iu.cmd);
 
 	if (rsp_code) {
 		if (fc_rsp->flags & FCP_RSP_LEN_VALID)
-- 
2.27.0

