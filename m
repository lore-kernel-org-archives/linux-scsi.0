Return-Path: <SRS0=SQ1Y=2D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0444C2D0BF
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Dec 2019 06:43:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 812A3214D8
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Dec 2019 06:43:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbfLMGnq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Dec 2019 01:43:46 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7683 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725535AbfLMGnq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Dec 2019 01:43:46 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B40A7448E9CDB00B5F6A;
        Fri, 13 Dec 2019 14:43:39 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Fri, 13 Dec 2019 14:43:30 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <mikecyr@linux.ibm.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chenzhou10@huawei.com>
Subject: [PATCH] scsi: ibmvscsi_tgt: remove set but not used variables 'iue' and 'sd'
Date:   Fri, 13 Dec 2019 14:40:42 +0800
Message-ID: <20191213064042.161840-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c: In function ibmvscsis_send_messages:
drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c:1888:19: warning: variable iue set but not used [-Wunused-but-set-variable]
drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c: In function ibmvscsis_queue_data_in:
drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c:3806:8: warning: variable sd set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 54b8c6f..d9e94e8 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -1877,7 +1877,6 @@ static void ibmvscsis_send_messages(struct scsi_info *vscsi)
 	 */
 	struct viosrp_crq *crq = (struct viosrp_crq *)&msg_hi;
 	struct ibmvscsis_cmd *cmd, *nxt;
-	struct iu_entry *iue;
 	long rc = ADAPT_SUCCESS;
 	bool retry = false;
 
@@ -1931,8 +1930,6 @@ static void ibmvscsis_send_messages(struct scsi_info *vscsi)
 					 */
 					vscsi->credit += 1;
 				} else {
-					iue = cmd->iue;
-
 					crq->valid = VALID_CMD_RESP_EL;
 					crq->format = cmd->rsp.format;
 
@@ -3796,7 +3793,6 @@ static int ibmvscsis_queue_data_in(struct se_cmd *se_cmd)
 						 se_cmd);
 	struct iu_entry *iue = cmd->iue;
 	struct scsi_info *vscsi = cmd->adapter;
-	char *sd;
 	uint len = 0;
 	int rc;
 
@@ -3804,7 +3800,6 @@ static int ibmvscsis_queue_data_in(struct se_cmd *se_cmd)
 			       1);
 	if (rc) {
 		dev_err(&vscsi->dev, "srp_transfer_data failed: %d\n", rc);
-		sd = se_cmd->sense_buffer;
 		se_cmd->scsi_sense_length = 18;
 		memset(se_cmd->sense_buffer, 0, se_cmd->scsi_sense_length);
 		/* Logical Unit Communication Time-out asc/ascq = 0x0801 */
-- 
2.7.4

