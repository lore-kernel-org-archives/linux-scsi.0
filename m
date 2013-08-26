From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v3 03/13] target: Add TCM_MISCOMPARE_VERIFY sense handling
Date: Mon, 26 Aug 2013 21:13:36 +0000
Message-ID: <1377551626-27447-4-git-send-email-nab@daterainc.com>
References: <1377551626-27447-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1377551626-27447-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, Kent Overstreet <kmo@daterainc.com>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

This patch adds TCM_MISCOMPARE_VERIFY (ASC=0x1d, ASCQ=0x00) sense
handling to transport_send_check_condition_and_sense(), which is
required for a COMPARE_AND_WRITE comparision failure.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/target_core_transport.c |    9 +++++++++
 include/target/target_core_base.h      |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 53d1d75..3d3dc97 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2791,6 +2791,15 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
 		buffer[SPC_ASC_KEY_OFFSET] = asc;
 		buffer[SPC_ASCQ_KEY_OFFSET] = ascq;
 		break;
+	case TCM_MISCOMPARE_VERIFY:
+		/* CURRENT ERROR */
+		buffer[0] = 0x70;
+		buffer[SPC_ADD_SENSE_LEN_OFFSET] = 10;
+		buffer[SPC_SENSE_KEY_OFFSET] = MISCOMPARE;
+		/* MISCOMPARE DURING VERIFY OPERATION */
+		buffer[SPC_ASC_KEY_OFFSET] = 0x1d;
+		buffer[SPC_ASCQ_KEY_OFFSET] = 0x00;
+		break;
 	case TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE:
 	default:
 		/* CURRENT ERROR */
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 6e946f3..fac25c5 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -197,6 +197,7 @@ enum tcm_sense_reason_table {
 	TCM_ADDRESS_OUT_OF_RANGE		= R(0x11),
 	TCM_OUT_OF_RESOURCES			= R(0x12),
 	TCM_PARAMETER_LIST_LENGTH_ERROR		= R(0x13),
+	TCM_MISCOMPARE_VERIFY			= R(0x14),
 #undef R
 };
 
-- 
1.7.2.5
