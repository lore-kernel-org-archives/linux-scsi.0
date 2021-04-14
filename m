Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4DFBC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 12:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADA2561107
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 12:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350737AbhDNMRz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 08:17:55 -0400
Received: from mail-m17635.qiye.163.com ([59.111.176.35]:20660 "EHLO
        mail-m17635.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbhDNMRy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Apr 2021 08:17:54 -0400
Received: from wanjb-virtual-machine.localdomain (unknown [36.152.145.182])
        by mail-m17635.qiye.163.com (Hmail) with ESMTPA id B71FD40039D;
        Wed, 14 Apr 2021 20:17:31 +0800 (CST)
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] scsi: qla4xxx: Simplify judgement condition
Date:   Wed, 14 Apr 2021 20:17:26 +0800
Message-Id: <20210414121726.12503-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZGU0dSlZPGEtLQxhLTh0fGE5VEwETFhoSFyQUDg9ZV1kWGg8SFR0UWUFZT0tIVUpKS0
        hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6K006OAw4OT8LChMRLxopSgIw
        MAIwCxBVSlVKTUpDT0tJTU5JSUlOVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlI
        TVVKTklVSk9OVUpDSVlXWQgBWUFJS01MNwY+
X-HM-Tid: 0a78d050aefdd991kuwsb71fd40039d
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warning:

./drivers/scsi/qla4xxx/ql4_83xx.c:475:23-25: WARNING !A || A && B is
equivalent to !A || B

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/scsi/qla4xxx/ql4_83xx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_83xx.c b/drivers/scsi/qla4xxx/ql4_83xx.c
index 5f56122f6664..db41d90a5b6e 100644
--- a/drivers/scsi/qla4xxx/ql4_83xx.c
+++ b/drivers/scsi/qla4xxx/ql4_83xx.c
@@ -472,8 +472,7 @@ int qla4_83xx_can_perform_reset(struct scsi_qla_host *ha)
 		} else if (device_map[i].device_type == ISCSI_CLASS) {
 			if (drv_active & (1 << device_map[i].func_num)) {
 				if (!iscsi_present ||
-				    (iscsi_present &&
-				     (iscsi_func_low > device_map[i].func_num)))
+				iscsi_func_low > device_map[i].func_num)
 					iscsi_func_low = device_map[i].func_num;
 
 				iscsi_present++;
-- 
2.25.1

