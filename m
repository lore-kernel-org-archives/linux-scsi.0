Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA4D2C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 04:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C844120842
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 04:44:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="fH9Bevtp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbgHEEo4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 00:44:56 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43384 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725868AbgHEEo4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 00:44:56 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0754Zabr024038
        for <linux-scsi@vger.kernel.org>; Tue, 4 Aug 2020 21:44:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=keO6RQE7AHicSzwC/28V3NU5LTL/X5A7fx69ZebubgQ=;
 b=fH9Bevtpm11H33TNdLKyXHqp8k8KjeLmsyOVE0kICLYJAFGHnJD4L+DOyCh537j20w+H
 2bh2y8zcCnQvfW0QPUiKEBc6i8w5FadNJn9uauVtcz9mNBY6MF6KjC4cqqnfhuXjEpcK
 pbPjVSrUpGvo+tTQWyh6+BIyysetmwrA60OvtP77UiG5Dlyky8L51tPMgy1+yAJBJr6P
 5NUlhMyf1lwvb8HGL4G6WQ+VfKJO85wcAUc4TcqLhPHHWHbr7VwPqyniIN/fX1PXbRF+
 0722h109His2xvy8chHlANxa4Gu3WOlyiXqvTe/Oo5TFdit7X/JF/x6KGZtynMISer/f 6A== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 32n8fex8bb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2020 21:44:54 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 4 Aug
 2020 21:44:52 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 4 Aug
 2020 21:44:51 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 4 Aug 2020 21:44:51 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 44C873F703F;
        Tue,  4 Aug 2020 21:44:51 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0754ipO2030591;
        Tue, 4 Aug 2020 21:44:51 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0754ipm6030582;
        Tue, 4 Aug 2020 21:44:51 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 01/10] qla2xxx: flush all sessions on zone disable
Date:   Tue, 4 Aug 2020 21:43:53 -0700
Message-ID: <20200805044402.30543-2-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200805044402.30543-1-njavali@marvell.com>
References: <20200805044402.30543-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-05_03:2020-08-03,2020-08-05 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

On Zone Disable, certain switch would ignore all
commands. This cause timeout for both switch
scan command and abort of that command. On detection
of this condition, all sessions will be shutdown.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 42c3ad27f1cb..c5529da1df59 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3734,6 +3734,18 @@ static void qla2x00_async_gpnft_gnnft_sp_done(srb_t *sp, int res)
 		unsigned long flags;
 		const char *name = sp->name;
 
+		if (res == QLA_OS_TIMER_EXPIRED) {
+			/* switch is ignoring all commands.
+			 * This might be a zone disable behavior.
+			 * This means we hit 64s timeout.
+			 * 22s GPNFT + 44s Abort = 64s
+			 */
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			       "%s: Switch Zone check please .\n",
+			       name);
+			qla2x00_mark_all_devices_lost(vha);
+		}
+
 		/*
 		 * We are in an Interrupt context, queue up this
 		 * sp for GNNFT_DONE work. This will allow all
-- 
2.19.0.rc0

