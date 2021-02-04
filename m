Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE459C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 07:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85FBD64F41
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 07:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbhBDHuN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 02:50:13 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:49333 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232190AbhBDHuD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 02:50:03 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UNpogdn_1612424916;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0UNpogdn_1612424916)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 04 Feb 2021 15:48:37 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     intel-linux-scu@intel.com
Cc:     artur.paszkiewicz@intel.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] scsi: isci: Remove redundant initialization of variable 'status'
Date:   Thu,  4 Feb 2021 15:48:35 +0800
Message-Id: <1612424915-106608-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch removes unneeded return variables.
It fixes the following warning detected by coccinelle:
./drivers/scsi/isci/request.c:1483:17-23: Unneeded variable: "status".
Return "SCI_SUCCESS" on line 1503
./drivers/scsi/isci/request.c:2157:17-23: Unneeded variable: "status".
Return "SCI_SUCCESS" on line 2177

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/scsi/isci/request.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 6e08179..8676282 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -1480,8 +1480,6 @@ static enum sci_status sci_stp_request_pio_data_in_copy_data(
 stp_request_pio_await_h2d_completion_tc_event(struct isci_request *ireq,
 					      u32 completion_code)
 {
-	enum sci_status status = SCI_SUCCESS;
-
 	switch (SCU_GET_COMPLETION_TL_STATUS(completion_code)) {
 	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_GOOD):
 		ireq->scu_status = SCU_TASK_DONE_GOOD;
@@ -1500,7 +1498,7 @@ static enum sci_status sci_stp_request_pio_data_in_copy_data(
 		break;
 	}
 
-	return status;
+	return SCI_SUCCESS;
 }
 
 static enum sci_status
@@ -2154,8 +2152,6 @@ static enum sci_status stp_request_udma_await_tc_event(struct isci_request *ireq
 static enum sci_status atapi_raw_completion(struct isci_request *ireq, u32 completion_code,
 						  enum sci_base_request_states next)
 {
-	enum sci_status status = SCI_SUCCESS;
-
 	switch (SCU_GET_COMPLETION_TL_STATUS(completion_code)) {
 	case SCU_MAKE_COMPLETION_STATUS(SCU_TASK_DONE_GOOD):
 		ireq->scu_status = SCU_TASK_DONE_GOOD;
@@ -2174,7 +2170,7 @@ static enum sci_status atapi_raw_completion(struct isci_request *ireq, u32 compl
 		break;
 	}
 
-	return status;
+	return SCI_SUCCESS;
 }
 
 static enum sci_status atapi_data_tc_completion_handler(struct isci_request *ireq,
-- 
1.8.3.1

