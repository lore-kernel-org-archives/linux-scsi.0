Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A86C3A5A1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 14:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BE8F21743
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 14:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733298AbfHVOL0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 10:11:26 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4764 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731783AbfHVOL0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Aug 2019 10:11:26 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7232EEAE61AF47E94D3F;
        Thu, 22 Aug 2019 22:11:24 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Thu, 22 Aug 2019
 22:11:15 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <anil.gurumurthy@qlogic.com>, <sudarsana.kalluru@qlogic.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH 3/4] scsi: bfa: remove set but not used variable 'adisc'
Date:   Thu, 22 Aug 2019 22:17:45 +0800
Message-ID: <1566483466-120175-4-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566483466-120175-1-git-send-email-zhengbin13@huawei.com>
References: <1566483466-120175-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/bfa/bfa_fcs_rport.c: In function bfa_fcs_rport_process_adisc:
drivers/scsi/bfa/bfa_fcs_rport.c:2251:21: warning: variable adisc set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/bfa/bfa_fcs_rport.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index 82801b3..271f052 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -2240,15 +2240,12 @@ bfa_fcs_rport_process_adisc(struct bfa_fcs_rport_s *rport,
 	struct bfa_fcxp_s *fcxp;
 	struct fchs_s	fchs;
 	struct bfa_fcs_lport_s *port = rport->port;
-	struct fc_adisc_s	*adisc;

 	bfa_trc(port->fcs, rx_fchs->s_id);
 	bfa_trc(port->fcs, rx_fchs->d_id);

 	rport->stats.adisc_rcvd++;

-	adisc = (struct fc_adisc_s *) (rx_fchs + 1);
-
 	/*
 	 * Accept if the itnim for this rport is online.
 	 * Else reject the ADISC.
--
2.7.4

