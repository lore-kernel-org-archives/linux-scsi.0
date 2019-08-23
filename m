Return-Path: <SRS0=qm3h=WT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41BFCC3A589
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 04:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EB9C2341F
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 04:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbfHWECh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Aug 2019 00:02:37 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4772 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725951AbfHWECh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Aug 2019 00:02:37 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id DE2A86D44B4D10D0A3E1;
        Fri, 23 Aug 2019 12:02:15 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Fri, 23 Aug 2019
 12:02:07 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH] scsi: isci: remove set but not used variable 'index'
Date:   Fri, 23 Aug 2019 12:08:39 +0800
Message-ID: <1566533319-23019-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/isci/host.c: In function sci_controller_complete_io:
drivers/scsi/isci/host.c:2674:6: warning: variable index set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/isci/host.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 7b5deae..7ebfa3c 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -2671,7 +2671,6 @@ enum sci_status sci_controller_complete_io(struct isci_host *ihost,
 					   struct isci_request *ireq)
 {
 	enum sci_status status;
-	u16 index;

 	switch (ihost->sm.current_state_id) {
 	case SCIC_STOPPING:
@@ -2682,7 +2681,6 @@ enum sci_status sci_controller_complete_io(struct isci_host *ihost,
 		if (status != SCI_SUCCESS)
 			return status;

-		index = ISCI_TAG_TCI(ireq->io_tag);
 		clear_bit(IREQ_ACTIVE, &ireq->flags);
 		return SCI_SUCCESS;
 	default:
--
2.7.4

