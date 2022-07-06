Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE55CCA480
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jul 2022 23:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbiGFXee (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jul 2022 19:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234177AbiGFXec (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2022 19:34:32 -0400
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7BC2C665;
        Wed,  6 Jul 2022 16:34:32 -0700 (PDT)
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 70B87C06E7;
        Wed,  6 Jul 2022 23:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1657150472; bh=sssFnbK7YbZe7A5/J1ruA6k6G3/8G/yNcmvmNc2Hg8s=;
        h=Date:In-Reply-To:References:From:Subject:To:Cc:From;
        b=PeVQg7EWiysa81JH922CCsx0pBS7zs2qworbNuQjJeP477ykARdF9d6CEt8eZYB/E
         i1koKlpsWacs0WQoP2zV/heAr3hPauCyOSfsemdY0ewukzKNCYrtC4l2Fx9oy1c8jn
         iEyaIzQYdFtzdFBXfjKHVHeLEVl4dS3emHpB5pHmjepYemJP49wC6s8bCg3KBVaRSJ
         wSMEmK8zFpBZxEbjnt/EmfNA5fQxzci45Il+B9ODNTyWrFcjmD594PpWxqasWIw4hf
         uXwKdC0lDRVMNgZK2y1/NclyWPKgDCBbFjQIqqhnGICRvWfFFKnlcPn952d7APi95Y
         fVVgG1bUAL5lA==
Received: from te-lab16-v2 (nanobot.internal.synopsys.com [10.204.48.11])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client did not present a certificate)
        by mailhost.synopsys.com (Postfix) with ESMTPSA id C4452A0063;
        Wed,  6 Jul 2022 23:34:29 +0000 (UTC)
Received: by te-lab16-v2 (sSMTP sendmail emulation); Wed, 06 Jul 2022 16:34:29 -0700
Date:   Wed, 06 Jul 2022 16:34:29 -0700
Message-Id: <118900ffaf094a279f7799ac9d2c73265c889121.1657149962.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 01/36] target: Handle MI_REPORT_SUPPORTED_OPERATION_CODES
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        linux-usb@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Microsoft Windows checks for MI_REPORT_SUPPORTED_OPERATION_CODES. Let's
handle this MAINTENANCE_IN command and report supported commands.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
---
 drivers/target/target_core_alua.c | 66 +++++++++++++++++++++++++++++++
 drivers/target/target_core_alua.h |  2 +
 drivers/target/target_core_spc.c  | 14 ++++++-
 3 files changed, 80 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index b56ef8af66e7..20cfcb70805d 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -259,6 +259,72 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 	return 0;
 }
 
+/*
+ * REPORT_SUPPORTED_OPERATION_CODES
+ *
+ * See spc4r17 section 6.27
+ */
+sense_reason_t
+target_emulate_report_supported_opcodes(struct se_cmd *cmd)
+{
+	unsigned char *cdb = cmd->t_task_cdb;
+	unsigned char *buf;
+	u8 supported = 0;
+
+	if (cdb[2] != 1) {
+		pr_warn("Invalid command format %d\n", cdb[2]);
+		goto out;
+	}
+
+	buf = transport_kmap_data_sg(cmd);
+	if (!buf)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+	switch (cdb[3]) {
+	case INQUIRY:
+	case MODE_SENSE:
+	case MODE_SENSE_10:
+	case READ_CAPACITY:
+	case SERVICE_ACTION_IN_16:
+	case REPORT_LUNS:
+	case REQUEST_SENSE:
+	case SYNCHRONIZE_CACHE:
+	case REZERO_UNIT:
+	case SEEK_6:
+	case SEEK_10:
+	case TEST_UNIT_READY:
+	case SEND_DIAGNOSTIC:
+	case MAINTENANCE_IN:
+	case READ_6:
+	case READ_10:
+	case READ_16:
+	case WRITE_6:
+	case WRITE_10:
+	case WRITE_16:
+	case VERIFY_16:
+	case MODE_SELECT:
+	case MODE_SELECT_10:
+	case START_STOP:
+	case SECURITY_PROTOCOL_IN:
+	case SECURITY_PROTOCOL_OUT:
+		supported = 3;
+		break;
+	case ATA_12:
+	case ATA_16:
+	case VERIFY:
+	case ZBC_IN:
+	case ZBC_OUT:
+	default:
+		break;
+	}
+
+	transport_kunmap_data_sg(cmd);
+out:
+	buf[1] = supported;
+	target_complete_cmd(cmd, SAM_STAT_GOOD);
+	return 0;
+}
+
 /*
  * SET_TARGET_PORT_GROUPS for explicit ALUA operation.
  *
diff --git a/drivers/target/target_core_alua.h b/drivers/target/target_core_alua.h
index fc9637cce825..7941e4dd4f97 100644
--- a/drivers/target/target_core_alua.h
+++ b/drivers/target/target_core_alua.h
@@ -82,6 +82,8 @@ extern struct kmem_cache *t10_alua_tg_pt_gp_cache;
 extern struct kmem_cache *t10_alua_lba_map_cache;
 extern struct kmem_cache *t10_alua_lba_map_mem_cache;
 
+extern sense_reason_t
+target_emulate_report_supported_opcodes(struct se_cmd *cmd);
 extern sense_reason_t target_emulate_report_target_port_groups(struct se_cmd *);
 extern sense_reason_t target_emulate_set_target_port_groups(struct se_cmd *);
 extern sense_reason_t target_emulate_report_referrals(struct se_cmd *);
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index c14441c89bed..dd799158609d 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1425,15 +1425,25 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 		break;
 	case MAINTENANCE_IN:
 		if (dev->transport->get_device_type(dev) != TYPE_ROM) {
+			u8 action = cdb[1] & 0x1f;
+
 			/*
 			 * MAINTENANCE_IN from SCC-2
 			 * Check for emulated MI_REPORT_TARGET_PGS
 			 */
-			if ((cdb[1] & 0x1f) == MI_REPORT_TARGET_PGS) {
+			if (action == MI_REPORT_TARGET_PGS) {
 				cmd->execute_cmd =
 					target_emulate_report_target_port_groups;
+
+				*size = get_unaligned_be32(&cdb[6]);
+			}
+
+			if (action == MI_REPORT_SUPPORTED_OPERATION_CODES) {
+				cmd->execute_cmd =
+					target_emulate_report_supported_opcodes;
+
+				*size = get_unaligned_be16(&cdb[2]);
 			}
-			*size = get_unaligned_be32(&cdb[6]);
 		} else {
 			/*
 			 * GPCMD_SEND_KEY from multi media commands
-- 
2.28.0

