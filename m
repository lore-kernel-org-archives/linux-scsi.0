Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41E44CCA47B
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 11:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238503AbiFHL73 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 07:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238501AbiFHL7P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 07:59:15 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F408F24CC9B
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 04:59:13 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2581X4Nj020925
        for <linux-scsi@vger.kernel.org>; Wed, 8 Jun 2022 04:59:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Cq9IHdeSoYBhNHDMVLEhc8GXGr7u13Tu03niAhAWyEc=;
 b=RoQgaMTekWiW+nlMWebY6+9zIG/pYiZWt7bSwjW4XtOQEzcCIp98HQYPfihd+rchAXOn
 7CW1MPWKOkbRGDSAIx0l9yKxQAt5LNbBsfTBhAQC/0v1yFTXViccuKu4eh4HVkuQiCU6
 HfBO6G1h+LbkErRorDjMqENsiPjf1j9i2MAlwlhJtXEdgpPkfNhRLHM/daD0FYPCBv3N
 EGYrUp7A7ffjqX6bfYslmSeHE/McfQrr3KqYGNNplqB0WcDr3v1FnJVMfeP73fwn0Mn5
 oKpP0+o17coQ5eeIT3vE+tDPSSyQ0IEc6ev7PpVRbX8e2wfFG9UHo+go5dVLwLaDIsca 4w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gjb7pbsag-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jun 2022 04:59:13 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Jun
 2022 04:58:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 8 Jun 2022 04:58:56 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B92333F7086;
        Wed,  8 Jun 2022 04:58:56 -0700 (PDT)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 09/10] qla2xxx: edif: Fix slow session tear down
Date:   Wed, 8 Jun 2022 04:58:48 -0700
Message-ID: <20220608115849.16693-10-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220608115849.16693-1-njavali@marvell.com>
References: <20220608115849.16693-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: lAY4dCrJ93v93212M6f8ADe0t9GOIf_n
X-Proofpoint-ORIG-GUID: lAY4dCrJ93v93212M6f8ADe0t9GOIf_n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_03,2022-06-07_02,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

User experience slow recovery when target device went through
a stop/start of the authentication application (app_stop/app_start).

Between the period of app_stop and app_start on the target device,
target device choose to send ELS Reject for any receive AUTH ELS command.
At this time, authentication application does not do els reject
if it encounters error.

Therefore, AUTH ELS reject signify authentication application
is not running. If driver pass up the AUTH ELS Reject to the
authentication application, then it would result in authentication
application retrying/resending the same AUTH ELS command again + delay.

As a work around, driver would trigger a session tear down where
it tell the local authentication application to also tear down.
At the next relogin, both side would be synchronize.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 8e6831953e7c..d87c53bc014b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2245,9 +2245,9 @@ qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
 				res = DID_ERROR << 16;
 			}
 
-			if (logit) {
-				if (sp->remap.remapped &&
-				    ((u8 *)sp->remap.rsp.buf)[0] == ELS_LS_RJT) {
+			if (sp->remap.remapped &&
+			    ((u8 *)sp->remap.rsp.buf)[0] == ELS_LS_RJT) {
+				if (logit) {
 					ql_dbg(ql_dbg_user, vha, 0x503f,
 					    "%s IOCB Done LS_RJT hdl=%x comp_status=0x%x\n",
 					    type, sp->handle, comp_status);
@@ -2259,18 +2259,24 @@ qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
 						pkt)->total_byte_count),
 					    e->s_id[0], e->s_id[2], e->s_id[1],
 					    e->d_id[2], e->d_id[1], e->d_id[0]);
-				} else {
-					ql_log(ql_log_info, vha, 0x503f,
-					    "%s IOCB Done hdl=%x comp_status=0x%x\n",
-					    type, sp->handle, comp_status);
-					ql_log(ql_log_info, vha, 0x503f,
-					    "subcode 1=0x%x subcode 2=0x%x bytes=0x%x %02x%02x%02x -> %02x%02x%02x\n",
-					    fw_status[1], fw_status[2],
-					    le32_to_cpu(((struct els_sts_entry_24xx *)
-						pkt)->total_byte_count),
-					    e->s_id[0], e->s_id[2], e->s_id[1],
-					    e->d_id[2], e->d_id[1], e->d_id[0]);
 				}
+				if (sp->fcport && sp->fcport->flags & FCF_FCSP_DEVICE &&
+				    sp->type == SRB_ELS_CMD_HST_NOLOGIN) {
+					ql_dbg(ql_dbg_edif, vha, 0x911e,
+					    "%s rcv reject. Sched delete\n", __func__);
+					qlt_schedule_sess_for_deletion(sp->fcport);
+				}
+			} else if (logit) {
+				ql_log(ql_log_info, vha, 0x503f,
+				    "%s IOCB Done hdl=%x comp_status=0x%x\n",
+				    type, sp->handle, comp_status);
+				ql_log(ql_log_info, vha, 0x503f,
+				    "subcode 1=0x%x subcode 2=0x%x bytes=0x%x %02x%02x%02x -> %02x%02x%02x\n",
+				    fw_status[1], fw_status[2],
+				    le32_to_cpu(((struct els_sts_entry_24xx *)
+				    pkt)->total_byte_count),
+				    e->s_id[0], e->s_id[2], e->s_id[1],
+				    e->d_id[2], e->d_id[1], e->d_id[0]);
 			}
 		}
 		goto els_ct_done;
-- 
2.19.0.rc0

