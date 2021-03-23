Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91F4DC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 04:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61DD461994
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 04:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhCWEpB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:45:01 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56822 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229590AbhCWEoh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Mar 2021 00:44:37 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12N4fAOi010256
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 21:44:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=RxkZVSVNTiMWrhCwbvxfZ5lxjbS2fOoxl0/BOqISO2I=;
 b=FwZ9GLVLxnZJxzmlSQ66uqT+wFGxZkHxh6RnUSvunDkeDEpO5NB07rKLl2XOXpUucZye
 kNRPVNvSpXUda4TcwKhQ0Libw92njE9VC4ERInjKr3l8iiiKnEfVx0Mpblkq4C3dJZtz
 QF6aptxKWUfQn4JBKD/heeEqY6xgHxnzfOkEdamVly6LuzVNxhqBQ2cmGGw5fvPl6py0
 Y77zBh+/Qstaahy+C+sGXZwF8kfzReCX6f2CGE6xXV1mAhKOLHTKtglM67pjqlJNDKwc
 fKvDeTkM8PiuTUx9lEs9s//ZJqO4zAI5RkkFDBcLmcsuZqX6cSegPu+98SYjpCDJBtTJ 1Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 37dgjnygva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 21:44:36 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 21:44:34 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 21:44:34 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 83B9F3F703F;
        Mon, 22 Mar 2021 21:44:34 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 12N4iYlL026720;
        Mon, 22 Mar 2021 21:44:34 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 12N4iYVf026718;
        Mon, 22 Mar 2021 21:44:34 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 03/11] qla2xxx: fix stuck session
Date:   Mon, 22 Mar 2021 21:42:49 -0700
Message-ID: <20210323044257.26664-4-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210323044257.26664-1-njavali@marvell.com>
References: <20210323044257.26664-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-23_01:2021-03-22,2021-03-23 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Session was stuck due to explicit logout to target was timed out.
The target was in an unresponsive state. This timeout induced an error
to the GNL command from moving forward.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c   | 1 +
 drivers/scsi/qla2xxx/qla_target.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

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
index c48daf52725d..fa8c4dae8dce 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1029,7 +1029,7 @@ void qlt_free_session_done(struct work_struct *work)
 			}
 			msleep(100);
 			cnt++;
-			if (cnt > 200)
+			if (cnt > 230)
 				break;
 		}
 
-- 
2.19.0.rc0

