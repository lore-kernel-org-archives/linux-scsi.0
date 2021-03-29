Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD3F2C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 08:55:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87A226192E
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 08:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbhC2IzO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 04:55:14 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29108 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236680AbhC2IyZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Mar 2021 04:54:25 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12T8oY2d001996;
        Mon, 29 Mar 2021 01:54:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=0bSF7o1em1nkzNNu2O78CNPwIu0uvbpPveLJ5XuQ/hc=;
 b=dcYVqxvzr16ObCIQg97HKZ2HbIJKGoBhmtzWw69Fmqz2Mw9gekum8xy8zl1soQ+az1Qu
 uGhIPyC0SlIRAdet4J5ePi2/SugojpNqtKwRiPfNLrkmY8j4D0/tz4AxAzzjpdncgsMA
 rbWQHCMufJX6CY4vmnsQS5TKjnCiPPeemODWjCl1+JEGN9NUgbgwh7Tg+vN/2ouzFHZP
 aTyNGvCUOUpWtmC3dURpeItUGIDeFTlC8u7afvpz3isFWDA9k4ZywyS8UMARaBFDSK7I
 cIAfsbucFhYbQY//m98r6cnNX3UakPZCrx2pddSxlt8OQUSygZiVEmd9BfyKBnrYiQdY vQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 37k63b8ve9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 01:54:08 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Mar
 2021 01:54:06 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 29 Mar 2021 01:54:06 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 6F8173F703F;
        Mon, 29 Mar 2021 01:54:06 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 12T8s6r7004430;
        Mon, 29 Mar 2021 01:54:06 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 12T8s6HJ004421;
        Mon, 29 Mar 2021 01:54:06 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <loberman@redhat.com>
Subject: [PATCH v2 03/12] qla2xxx: fix stuck session
Date:   Mon, 29 Mar 2021 01:52:20 -0700
Message-ID: <20210329085229.4367-4-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210329085229.4367-1-njavali@marvell.com>
References: <20210329085229.4367-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: nIqLTRNkRxMTtCu24PuaIrL5OWt66UT3
X-Proofpoint-GUID: nIqLTRNkRxMTtCu24PuaIrL5OWt66UT3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_04:2021-03-26,2021-03-29 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Session was stuck due to explicit logout to target was timed out.
The target was in an unresponsive state. This timeout induced an error
to the GNL command from moving forward.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/scsi/qla2xxx/qla_init.c   | 1 +
 drivers/scsi/qla2xxx/qla_target.c | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index af237c485389..f6dc8166e7ba 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -718,6 +718,7 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 		ql_dbg(ql_dbg_disc, vha, 0x20e0,
 		    "%s %8phC login gen changed\n",
 		    __func__, fcport->port_name);
+		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 		return;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index c48daf52725d..0d9117a30ff6 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1029,7 +1029,11 @@ void qlt_free_session_done(struct work_struct *work)
 			}
 			msleep(100);
 			cnt++;
-			if (cnt > 200)
+			/*
+			 * wait for logout to complete before advance. Otherwise,
+			 * straddling logout can interfere with relogin.
+			 */
+			if (cnt > 230)
 				break;
 		}
 
-- 
2.19.0.rc0

