From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 02/14] target: Add DIF CHECK_CONDITION ASC/ASCQ exception cases
Date: Wed,  8 Jan 2014 20:15:45 +0000
Message-ID: <1389212157-14540-3-git-send-email-nab@daterainc.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49834 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbaAHUgS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jan 2014 15:36:18 -0500
In-Reply-To: <1389212157-14540-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for DIF related CHECK_CONDITION ASC/ASCQ
exception cases into transport_send_check_condition_and_sense().

This includes:

  LOGICAL BLOCK GUARD CHECK FAILED
  LOGICAL BLOCK APPLICATION TAG CHECK FAILED
  LOGICAL BLOCK REFERENCE TAG CHECK FAILED

that used by DIF TYPE1 and TYPE3 failure cases.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   30 ++++++++++++++++++++++++++++++
 include/target/target_core_base.h      |    3 +++
 2 files changed, 33 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 91953da..707ee17 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2648,6 +2648,36 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
 		buffer[SPC_ASC_KEY_OFFSET] = 0x1d;
 		buffer[SPC_ASCQ_KEY_OFFSET] = 0x00;
 		break;
+	case TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED:
+		/* CURRENT ERROR */
+		buffer[0] = 0x70;
+		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
+		/* ILLEGAL REQUEST */
+		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
+		/* LOGICAL BLOCK GUARD CHECK FAILED */
+		buffer[SPC_ASC_KEY_OFFSET] = 0x10;
+		buffer[SPC_ASCQ_KEY_OFFSET] = 0x01;
+		break;
+	case TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED:
+		/* CURRENT ERROR */
+		buffer[0] = 0x70;
+		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
+		/* ILLEGAL REQUEST */
+		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
+		/* LOGICAL BLOCK APPLICATION TAG CHECK FAILED */
+		buffer[SPC_ASC_KEY_OFFSET] = 0x10;
+		buffer[SPC_ASCQ_KEY_OFFSET] = 0x02;
+		break;
+	case TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED:
+		/* CURRENT ERROR */
+		buffer[0] = 0x70;
+		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
+		/* ILLEGAL REQUEST */
+		buffer[SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
+		/* LOGICAL BLOCK REFERENCE TAG CHECK FAILED */
+		buffer[SPC_ASC_KEY_OFFSET] = 0x10;
+		buffer[SPC_ASCQ_KEY_OFFSET] = 0x03;
+		break;
 	case TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE:
 	default:
 		/* CURRENT ERROR */
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 15f402c..9a6e091 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -206,6 +206,9 @@ enum tcm_sense_reason_table {
 	TCM_OUT_OF_RESOURCES			= R(0x12),
 	TCM_PARAMETER_LIST_LENGTH_ERROR		= R(0x13),
 	TCM_MISCOMPARE_VERIFY			= R(0x14),
+	TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED	= R(0x15),
+	TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED	= R(0x16),
+	TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED	= R(0x17),
 #undef R
 };
 
-- 
1.7.10.4

