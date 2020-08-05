Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B1BC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 04:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DE492177B
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 04:46:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="PqfUKWQA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgHEEqz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 00:46:55 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8664 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725868AbgHEEqz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 00:46:55 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0754ZZxp023966
        for <linux-scsi@vger.kernel.org>; Tue, 4 Aug 2020 21:46:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=eJl5oTVIZhf51hQcKv0eC8odGNRBaC8s508+9KjLF74=;
 b=PqfUKWQAeoJawyPGAgZASolCI6PbpB3nrvvG7z0+Yz8tf0qYnhguXIiEyOo7RVzqTR+g
 A1ZdpCMm4eWXVT1EoFdGHMCGYGE39wnVSCJGvAT/NZdrR3VjnGe5WLRib4gXZTafnBkq
 slSY0Ivn9ZofmBzvLsET8W7J+ZIpasOKF8VtP9OCYpgvV0XyQnsaavtASdFPUIZf3kvm
 dZatJbJTKxAXP/TDTIaFKpzIKQPgrVVrtUdOHQobNMoe4L3aLKSiNj1R9432cevKkXWl
 eglhATXwUw6BDRNLvcMwZtlRpCxXEO03aNGCMVuc9dVbDqh++i3ozca0E03ilZdbLieI 2w== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 32n8fex8gm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2020 21:46:54 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 4 Aug
 2020 21:46:53 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 4 Aug
 2020 21:46:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 4 Aug 2020 21:46:52 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id DA4A93F703F;
        Tue,  4 Aug 2020 21:46:51 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0754kpkt030628;
        Tue, 4 Aug 2020 21:46:51 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0754kpn5030619;
        Tue, 4 Aug 2020 21:46:51 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 06/10] qla2xxx: Allow ql2xextended_error_logging special value 1 to be set anytime
Date:   Tue, 4 Aug 2020 21:43:58 -0700
Message-ID: <20200805044402.30543-7-njavali@marvell.com>
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

From: Arun Easi <aeasi@marvell.com>

ql2xextended_error_logging could now be set anytime to 1 to get the default
mask value, as opposed to load time only.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_dbg.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 91eb6901815c..e1d7de63e8f8 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -380,5 +380,8 @@ extern int qla24xx_soft_reset(struct qla_hw_data *);
 static inline int
 ql_mask_match(uint level)
 {
+	if (ql2xextended_error_logging == 1)
+		ql2xextended_error_logging = QL_DBG_DEFAULT1_MASK;
+
 	return (level & ql2xextended_error_logging) == level;
 }
-- 
2.19.0.rc0

