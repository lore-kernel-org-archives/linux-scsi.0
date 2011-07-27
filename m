From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] target: Change TCM_NON_EXISTENT_LUN response to ASC=LOGICAL UNIT NOT SUPPORTED
Date: Wed, 27 Jul 2011 00:45:16 +0000
Message-ID: <1311727518-1927-2-git-send-email-nab@linux-iscsi.org>
References: <1311727518-1927-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:52610 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab1G0BI5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2011 21:08:57 -0400
In-Reply-To: <1311727518-1927-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Roland Dreier <roland@purestorage.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes transport_send_check_condition_and_sense() for
TCM_NON_EXISTENT_LUN emulation to use 0x25 (LOGICAL UNIT NOT SUPPORTED)
instead of the original 0x20 (INVALID COMMAND OPERATION CODE).  This is
helpful to distinguish between TCM_UNSUPPORTED_SCSI_OPCODE ASC=0x20
exceptions.

Signed-off-by: Nicholas A. Bellinger <nab@risingtidesystems.com>
---
 drivers/target/target_core_transport.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 301d5a0..ebf56cd 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4701,6 +4701,13 @@ int transport_send_check_condition_and_sense(
 	 */
 	switch (reason) {
 	case TCM_NON_EXISTENT_LUN:
+		/* CURRENT ERROR */
+		buffer[offset] = 0x70;
+		/* ILLEGAL REQUEST */
+		buffer[offset+SPC_SENSE_KEY_OFFSET] = ILLEGAL_REQUEST;
+		/* LOGICAL UNIT NOT SUPPORTED */
+		buffer[offset+SPC_ASC_KEY_OFFSET] = 0x25;
+		break;
 	case TCM_UNSUPPORTED_SCSI_OPCODE:
 	case TCM_SECTOR_COUNT_TOO_MANY:
 		/* CURRENT ERROR */
-- 
1.7.2.5

