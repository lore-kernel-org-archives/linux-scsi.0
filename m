Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15A0C3A5A2
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 14:11:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96F7121743
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 14:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733309AbfHVOL3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 10:11:29 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4763 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733285AbfHVOL3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Aug 2019 10:11:29 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6D540538ACD6F6321CBC;
        Thu, 22 Aug 2019 22:11:24 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Thu, 22 Aug 2019
 22:11:15 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <anil.gurumurthy@qlogic.com>, <sudarsana.kalluru@qlogic.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH 2/4] scsi: bfa: remove set but not used variable 'rp'
Date:   Thu, 22 Aug 2019 22:17:44 +0800
Message-ID: <1566483466-120175-3-git-send-email-zhengbin13@huawei.com>
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

drivers/scsi/bfa/bfa_fcpim.c: In function bfa_fcpim_lunmask_delete:
drivers/scsi/bfa/bfa_fcpim.c:2346:22: warning: variable rp set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/bfa/bfa_fcpim.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 284baa3..63e936d 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -2335,7 +2335,6 @@ bfa_fcpim_lunmask_delete(struct bfa_s *bfa, u16 vf_id, wwn_t *pwwn,
 			 wwn_t rpwwn, struct scsi_lun lun)
 {
 	struct bfa_lun_mask_s	*lunm_list;
-	struct bfa_rport_s	*rp = NULL;
 	struct bfa_fcs_lport_s *port = NULL;
 	struct bfa_fcs_rport_s *rp_fcs;
 	int	i;
@@ -2356,8 +2355,6 @@ bfa_fcpim_lunmask_delete(struct bfa_s *bfa, u16 vf_id, wwn_t *pwwn,
 		if (port) {
 			*pwwn = port->port_cfg.pwwn;
 			rp_fcs = bfa_fcs_lport_get_rport_by_pwwn(port, rpwwn);
-			if (rp_fcs)
-				rp = rp_fcs->bfa_rport;
 		}
 	}

--
2.7.4

