Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F05C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 16:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 365F661157
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 16:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352350AbhIHQsz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 12:48:55 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32070 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352281AbhIHQsv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 12:48:51 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1889r440000993;
        Wed, 8 Sep 2021 09:47:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=cEsZrphM1+7aefjyvW6p0CyFlNf+uiDpClD9OEPwa9c=;
 b=VUlQedM0iIwUN6/Y2bW+0DZ70CfwA328Iq8RT08EfQ4A5FneJa1FrG092Ftim8+qukpi
 MjDsOUzC2VJpa/DUGuksuLxYv/9U5kHYrtnRuUfjGD1uPVSB6g7uckPyB0aFtz7QZnw+
 lxV1zn3WTKqI9sVunsSrSI55/2iFOBOR1RDRr72KVMLkrU/Iio+h4FiWQn0a8NEAtN6h
 l1km3fhmBqSclKgaBNAPVnjMERW+XLMUV6ag3/UddI20ZB7sqEMiDMHyQ1xgD9yiboED
 rj75iTqpwvpdIFY/tdmS/qD1zJT+TXzoe0kLbSI+A5CiIjpp82IjQjOuqMRLNWTXadgk vg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3axtxc1kh8-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 08 Sep 2021 09:47:42 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Sep
 2021 09:47:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 8 Sep 2021 09:47:39 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id CB70B3F70AA;
        Wed,  8 Sep 2021 09:47:38 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 188Glc7J019319;
        Wed, 8 Sep 2021 09:47:38 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 188GlcYb019318;
        Wed, 8 Sep 2021 09:47:38 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <djeffery@redhat.com>,
        <loberman@redhat.com>
Subject: [PATCH v2 09/10] qla2xxx: Fix use after free in eh_abort path
Date:   Wed, 8 Sep 2021 09:46:21 -0700
Message-ID: <20210908164622.19240-10-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210908164622.19240-1-njavali@marvell.com>
References: <20210908164622.19240-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: AlxQKHpuhtT61ioc0aVVDPQkndYFT28R
X-Proofpoint-GUID: AlxQKHpuhtT61ioc0aVVDPQkndYFT28R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-08_06,2021-09-07_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

In eh_abort path, driver prematurely exit the call to upper layer.
This patch would check for command is aborted / completed by FW
before exiting the call.

9 [ffff8b1ebf803c00] page_fault at ffffffffb0389778
  [exception RIP: qla2x00_status_entry+0x48d]
  RIP: ffffffffc04fa62d  RSP: ffff8b1ebf803cb0  RFLAGS: 00010082
  RAX: 00000000ffffffff  RBX: 00000000000e0000  RCX: 0000000000000000
  RDX: 0000000000000000  RSI: 00000000000013d8  RDI: fffff3253db78440
  RBP: ffff8b1ebf803dd0   R8: ffff8b1ebcd9b0c0   R9: 0000000000000000
  R10: ffff8b1e38a30808  R11: 0000000000001000  R12: 00000000000003e9
  R13: 0000000000000000  R14: ffff8b1ebcd9d740  R15: 0000000000000028
  ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
10 [ffff8b1ebf803cb0] enqueue_entity at ffffffffafce708f
11 [ffff8b1ebf803d00] enqueue_task_fair at ffffffffafce7b88
12 [ffff8b1ebf803dd8] qla24xx_process_response_queue at ffffffffc04fc9a6
[qla2xxx]
13 [ffff8b1ebf803e78] qla24xx_msix_rsp_q at ffffffffc04ff01b [qla2xxx]
14 [ffff8b1ebf803eb0] __handle_irq_event_percpu at ffffffffafd50714

Fixes: f45bca8c5052 ("scsi: qla2xxx: Fix double scsi_done for abort path")
Cc: stable@vger.kernel.org
Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0c446438dcd3..03ff2596715b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1258,6 +1258,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	uint32_t ratov_j;
 	struct qla_qpair *qpair;
 	unsigned long flags;
+	int fast_fail_status = SUCCESS;
 
 	if (qla2x00_isp_reg_stat(ha)) {
 		ql_log(ql_log_info, vha, 0x8042,
@@ -1266,9 +1267,10 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		return FAILED;
 	}
 
+	/* Save any FAST_IO_FAIL value to return later if abort succeeds */
 	ret = fc_block_scsi_eh(cmd);
 	if (ret != 0)
-		return ret;
+		fast_fail_status = ret;
 
 	sp = scsi_cmd_priv(cmd);
 	qpair = sp->qpair;
@@ -1276,7 +1278,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	vha->cmd_timeout_cnt++;
 
 	if ((sp->fcport && sp->fcport->deleted) || !qpair)
-		return SUCCESS;
+		return fast_fail_status != SUCCESS ? fast_fail_status : FAILED;
 
 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
 	sp->comp = &comp;
@@ -1311,7 +1313,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 			    __func__, ha->r_a_tov/10);
 			ret = FAILED;
 		} else {
-			ret = SUCCESS;
+			ret = fast_fail_status;
 		}
 		break;
 	default:
-- 
2.19.0.rc0

