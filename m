Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B56C25B08
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Aug 2022 08:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbiHQIey (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Aug 2022 04:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbiHQIeu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2022 04:34:50 -0400
Received: from out29-196.mail.aliyun.com (out29-196.mail.aliyun.com [115.124.29.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5332A5852F;
        Wed, 17 Aug 2022 01:34:46 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.14492|-1;BR=01201311R721S26rulernew998_84748_2000303;CH=blue;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00227074-0.000132166-0.997597;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047209;MF=michael@allwinnertech.com;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.OvM4IHQ_1660725283;
Received: from SunxiBot.allwinnertech.com(mailfrom:michael@allwinnertech.com fp:SMTPD_---.OvM4IHQ_1660725283)
          by smtp.aliyun-inc.com;
          Wed, 17 Aug 2022 16:34:43 +0800
From:   Michael Wu <michael@allwinnertech.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: core: Fix block I/O error of USB card reader during resume
Date:   Wed, 17 Aug 2022 16:34:38 +0800
Message-Id: <20220817083438.118293-1-michael@allwinnertech.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When accessing storage device via an USB card reader, a block I/O error
occurs during resume:

PM: suspend exit
sd 0: 0:0:0: [sda] tag#0 UNKNOWN(0x2003) Result: hostbyte=0x00 driverbyte
=0x08
sd 0: 0:0:0: [sda] tag#0 Sense Key : 0x6 [current]
sd 0: 0:0:0: [sda] tag#0 ASC=0x28 ASCQ=0x0
sd 0: 0:0:0: [sda] tag#0 CDB: opcode=0x28 28 00 00 17 ce e1 00 00 f0 00
blk_update_request: I/O error, dev sda, sector 1560289 op 0x0:(READ) flags
0x84700 phys_seg 19 prio class 0
sd 0: 0:0:0: [sda] tag#0 device offline or changed

Fix it by changing the action in scsi_io_completion_action() from
ACTION_FAIL to ACTION_RETRY by adding the condition `cmd->device->
lockable`.

Signed-off-by: Michael Wu <michael@allwinnertech.com>
---
 drivers/scsi/scsi_lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4dbd29ab1dcc..4bc480721947 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -704,7 +704,8 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 	} else if (sense_valid && sense_current) {
 		switch (sshdr.sense_key) {
 		case UNIT_ATTENTION:
-			if (cmd->device->removable) {
+			if (cmd->device->removable &&
+			    cmd->device->lockable) {
 				/* Detected disc change.  Set a bit
 				 * and quietly refuse further access.
 				 */
-- 
2.29.0

