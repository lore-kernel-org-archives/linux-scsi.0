From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 3/9] target/spc: Only expose PI inquiry bits when supported by fabric
Date: Thu,  3 Apr 2014 09:35:47 +0000
Message-ID: <1396517753-23546-4-git-send-email-nab@daterainc.com>
References: <1396517753-23546-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:61338 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbaDCJ7C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2014 05:59:02 -0400
Received: by mail-oa0-f50.google.com with SMTP id i7so1667630oag.23
        for <linux-scsi@vger.kernel.org>; Thu, 03 Apr 2014 02:59:01 -0700 (PDT)
In-Reply-To: <1396517753-23546-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Only expose standard INQUIRY PROTECT=1 and EVPD=0x86 TYPE1/TYPE3
PI control bits if the session + fabric support DIX PASS operations.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_spc.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 3bebc71..d4c6a31 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -71,6 +71,7 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
 {
 	struct se_lun *lun = cmd->se_lun;
 	struct se_device *dev = cmd->se_dev;
+	struct se_session *sess = cmd->se_sess;
 
 	/* Set RMB (removable media) for tape devices */
 	if (dev->transport->get_device_type(dev) == TYPE_TAPE)
@@ -101,10 +102,13 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
 	if (dev->dev_attrib.emulate_3pc)
 		buf[5] |= 0x8;
 	/*
-	 * Set Protection (PROTECT) bit when DIF has been enabled.
+	 * Set Protection (PROTECT) bit when DIF has been enabled on the
+	 * device, and the transport supports VERIFY + PASS.
 	 */
-	if (dev->dev_attrib.pi_prot_type)
-		buf[5] |= 0x1;
+	if (sess->sup_prot_ops & (TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS)) {
+		if (dev->dev_attrib.pi_prot_type)
+			buf[5] |= 0x1;
+	}
 
 	buf[7] = 0x2; /* CmdQue=1 */
 
@@ -473,16 +477,19 @@ static sense_reason_t
 spc_emulate_evpd_86(struct se_cmd *cmd, unsigned char *buf)
 {
 	struct se_device *dev = cmd->se_dev;
+	struct se_session *sess = cmd->se_sess;
 
 	buf[3] = 0x3c;
 	/*
 	 * Set GRD_CHK + REF_CHK for TYPE1 protection, or GRD_CHK
 	 * only for TYPE3 protection.
 	 */
-	if (dev->dev_attrib.pi_prot_type == TARGET_DIF_TYPE1_PROT)
-		buf[4] = 0x5;
-	else if (dev->dev_attrib.pi_prot_type == TARGET_DIF_TYPE3_PROT)
-		buf[4] = 0x4;
+	if (sess->sup_prot_ops & (TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS)) {
+		if (dev->dev_attrib.pi_prot_type == TARGET_DIF_TYPE1_PROT)
+			buf[4] = 0x5;
+		else if (dev->dev_attrib.pi_prot_type == TARGET_DIF_TYPE3_PROT)
+			buf[4] = 0x4;
+	}
 
 	/* Set HEADSUP, ORDSUP, SIMPSUP */
 	buf[5] = 0x07;
-- 
1.7.10.4

