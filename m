Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD21AC2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 19:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D055222E9
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 19:17:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YzAGogtd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgKQTQt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 14:16:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1676 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727967AbgKQTQs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 14:16:48 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHJ46EU131792;
        Tue, 17 Nov 2020 14:16:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5XcJ05CAGkFq71RzTXs/KEH2powNALmDBsiZonG8fBg=;
 b=YzAGogtd77tWFBmNmXw7Ra6fLCPsSscprTGkI4kCz69k+TeLKGh4MxsOEzhj0IVqVwqZ
 UO6SpI3q4K2q9PnTgh7fo8mVZubCxejDZJaPuJT8h0JoO3o8F0vAvqUREx+h7o7MDbHv
 /rJKW33ZYIhpNsD6A534XH/2c3v51vPQgUZtQdL3JKbU8OYgikVBVODSam7rxjXvuZpv
 oy0Ro/difLFdK4WcwAyrsylWDuWm/bY0LjlrZkxR3GUNRb0Ot5fPwqxtfop+BNY0WiIB
 AO6YHJzfGia/K49q9qPVz0m6H/8FN1mFSpWao0IORSldtlwx0MtPxQw+9025rUUB1Q60 mA== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34v961y6xp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 14:16:42 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AHJ7r3h009345;
        Tue, 17 Nov 2020 19:16:41 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03wdc.us.ibm.com with ESMTP id 34t6v90v7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 Nov 2020 19:16:40 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AHJGXF628639824
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 19:16:33 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 702B7C6059;
        Tue, 17 Nov 2020 19:16:39 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0C4B4C6057;
        Tue, 17 Nov 2020 19:16:38 +0000 (GMT)
Received: from vios4361.aus.stglabs.ibm.com (unknown [9.3.43.61])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 17 Nov 2020 19:16:38 +0000 (GMT)
From:   Tyrel Datwyler <tyreld@linux.ibm.com>
To:     james.bottomley@hansenpartnership.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        brking@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 1/6] ibmvfc: deduplicate common ibmvfc_cmd init code
Date:   Tue, 17 Nov 2020 13:16:31 -0600
Message-Id: <20201117191636.131127-2-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117191636.131127-1-tyreld@linux.ibm.com>
References: <20201117191636.131127-1-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_07:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 suspectscore=1 lowpriorityscore=0 spamscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 clxscore=1015 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170137
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The virtual FC frame command exchaned with the VIOS is used for device
reset and command abort TMF as well as normally queued commands. When
initializing the ibmvfc_cmd there several elements of the command that
are set the same way regardless of the command type.

Deduplicate code by moving these commonally set fields into a
initialization helper routine, namely ibmvfc_init_vfc_cmd().

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 56 +++++++++++++++-------------------
 1 file changed, 24 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 3922441a117d..316902074abe 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -1646,6 +1646,25 @@ static inline int ibmvfc_host_chkready(struct ibmvfc_host *vhost)
 	return result;
 }
 
+static struct ibmvfc_cmd *ibmvfc_init_vfc_cmd(struct ibmvfc_event *evt, struct scsi_device *sdev)
+{
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
+	struct ibmvfc_cmd *vfc_cmd = &evt->iu.cmd;
+	size_t offset = offsetof(struct ibmvfc_cmd, rsp);
+
+	memset(vfc_cmd, 0, sizeof(*vfc_cmd));
+	vfc_cmd->resp.va = cpu_to_be64(be64_to_cpu(evt->crq.ioba) + offset);
+	vfc_cmd->resp.len = cpu_to_be32(sizeof(vfc_cmd->rsp));
+	vfc_cmd->frame_type = cpu_to_be32(IBMVFC_SCSI_FCP_TYPE);
+	vfc_cmd->payload_len = cpu_to_be32(sizeof(vfc_cmd->iu));
+	vfc_cmd->resp_len = cpu_to_be32(sizeof(vfc_cmd->rsp));
+	vfc_cmd->cancel_key = cpu_to_be32((unsigned long)sdev->hostdata);
+	vfc_cmd->tgt_scsi_id = cpu_to_be64(rport->port_id);
+	int_to_scsilun(sdev->lun, &vfc_cmd->iu.lun);
+
+	return vfc_cmd;
+}
+
 /**
  * ibmvfc_queuecommand - The queuecommand function of the scsi template
  * @cmnd:	struct scsi_cmnd to be executed
@@ -1675,17 +1694,10 @@ static int ibmvfc_queuecommand_lck(struct scsi_cmnd *cmnd,
 	ibmvfc_init_event(evt, ibmvfc_scsi_done, IBMVFC_CMD_FORMAT);
 	evt->cmnd = cmnd;
 	cmnd->scsi_done = done;
-	vfc_cmd = &evt->iu.cmd;
-	memset(vfc_cmd, 0, sizeof(*vfc_cmd));
-	vfc_cmd->resp.va = cpu_to_be64(be64_to_cpu(evt->crq.ioba) + offsetof(struct ibmvfc_cmd, rsp));
-	vfc_cmd->resp.len = cpu_to_be32(sizeof(vfc_cmd->rsp));
-	vfc_cmd->frame_type = cpu_to_be32(IBMVFC_SCSI_FCP_TYPE);
-	vfc_cmd->payload_len = cpu_to_be32(sizeof(vfc_cmd->iu));
-	vfc_cmd->resp_len = cpu_to_be32(sizeof(vfc_cmd->rsp));
-	vfc_cmd->cancel_key = cpu_to_be32((unsigned long)cmnd->device->hostdata);
-	vfc_cmd->tgt_scsi_id = cpu_to_be64(rport->port_id);
+
+	vfc_cmd = ibmvfc_init_vfc_cmd(evt, cmnd->device);
+
 	vfc_cmd->iu.xfer_len = cpu_to_be32(scsi_bufflen(cmnd));
-	int_to_scsilun(cmnd->device->lun, &vfc_cmd->iu.lun);
 	memcpy(vfc_cmd->iu.cdb, cmnd->cmnd, cmnd->cmd_len);
 
 	if (cmnd->flags & SCMD_TAGGED) {
@@ -2014,7 +2026,6 @@ static int ibmvfc_bsg_request(struct bsg_job *job)
 static int ibmvfc_reset_device(struct scsi_device *sdev, int type, char *desc)
 {
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
-	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	struct ibmvfc_cmd *tmf;
 	struct ibmvfc_event *evt = NULL;
 	union ibmvfc_iu rsp_iu;
@@ -2027,17 +2038,8 @@ static int ibmvfc_reset_device(struct scsi_device *sdev, int type, char *desc)
 	if (vhost->state == IBMVFC_ACTIVE) {
 		evt = ibmvfc_get_event(vhost);
 		ibmvfc_init_event(evt, ibmvfc_sync_completion, IBMVFC_CMD_FORMAT);
+		tmf = ibmvfc_init_vfc_cmd(evt, sdev);
 
-		tmf = &evt->iu.cmd;
-		memset(tmf, 0, sizeof(*tmf));
-		tmf->resp.va = cpu_to_be64(be64_to_cpu(evt->crq.ioba) + offsetof(struct ibmvfc_cmd, rsp));
-		tmf->resp.len = cpu_to_be32(sizeof(tmf->rsp));
-		tmf->frame_type = cpu_to_be32(IBMVFC_SCSI_FCP_TYPE);
-		tmf->payload_len = cpu_to_be32(sizeof(tmf->iu));
-		tmf->resp_len = cpu_to_be32(sizeof(tmf->rsp));
-		tmf->cancel_key = cpu_to_be32((unsigned long)sdev->hostdata);
-		tmf->tgt_scsi_id = cpu_to_be64(rport->port_id);
-		int_to_scsilun(sdev->lun, &tmf->iu.lun);
 		tmf->flags = cpu_to_be16((IBMVFC_NO_MEM_DESC | IBMVFC_TMF));
 		tmf->iu.tmf_flags = type;
 		evt->sync_iu = &rsp_iu;
@@ -2329,7 +2331,6 @@ static int ibmvfc_match_evt(struct ibmvfc_event *evt, void *match)
 static int ibmvfc_abort_task_set(struct scsi_device *sdev)
 {
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
-	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	struct ibmvfc_cmd *tmf;
 	struct ibmvfc_event *evt, *found_evt;
 	union ibmvfc_iu rsp_iu;
@@ -2357,17 +2358,8 @@ static int ibmvfc_abort_task_set(struct scsi_device *sdev)
 	if (vhost->state == IBMVFC_ACTIVE) {
 		evt = ibmvfc_get_event(vhost);
 		ibmvfc_init_event(evt, ibmvfc_sync_completion, IBMVFC_CMD_FORMAT);
+		tmf = ibmvfc_init_vfc_cmd(evt, sdev);
 
-		tmf = &evt->iu.cmd;
-		memset(tmf, 0, sizeof(*tmf));
-		tmf->resp.va = cpu_to_be64(be64_to_cpu(evt->crq.ioba) + offsetof(struct ibmvfc_cmd, rsp));
-		tmf->resp.len = cpu_to_be32(sizeof(tmf->rsp));
-		tmf->frame_type = cpu_to_be32(IBMVFC_SCSI_FCP_TYPE);
-		tmf->payload_len = cpu_to_be32(sizeof(tmf->iu));
-		tmf->resp_len = cpu_to_be32(sizeof(tmf->rsp));
-		tmf->cancel_key = cpu_to_be32((unsigned long)sdev->hostdata);
-		tmf->tgt_scsi_id = cpu_to_be64(rport->port_id);
-		int_to_scsilun(sdev->lun, &tmf->iu.lun);
 		tmf->flags = cpu_to_be16((IBMVFC_NO_MEM_DESC | IBMVFC_TMF));
 		tmf->iu.tmf_flags = IBMVFC_ABORT_TASK_SET;
 		evt->sync_iu = &rsp_iu;
-- 
2.27.0

