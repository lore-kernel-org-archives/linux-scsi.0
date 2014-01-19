From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 02/17] target: Add DIF CHECK_CONDITION ASC/ASCQ exception cases
Date: Sun, 19 Jan 2014 02:44:25 +0000
Message-ID: <1390099480-29013-3-git-send-email-nab@daterainc.com>
References: <1390099480-29013-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1390099480-29013-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roland Dreier <roland@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

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
index 18c828d..fa4fc04 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2674,6 +2674,36 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
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
index d98048b..0336d70 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -205,6 +205,9 @@ enum tcm_sense_reason_table {
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
