From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 08/21] target: Fix write payload exception handling with ->new_cmd_map
Date: Wed, 17 Aug 2011 23:17:12 +0000
Message-ID: <1313623045-15916-9-git-send-email-nab@linux-iscsi.org>
References: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58321 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab1HQXm3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2011 19:42:29 -0400
In-Reply-To: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug for fabrics using tfo->new_cmd_map() that
are expect transport_generic_request_failure() to be calling
transport_send_check_condition_and_sense() for both READ and WRITE,
instead of only for READ exceptions.

This was originally observed with a failed WRITE_SAME_16 w/ unmap=0
using tcm_loop.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index cc5a339..fd7d451 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2053,8 +2053,14 @@ static void transport_generic_request_failure(
 		cmd->scsi_sense_reason = TCM_UNSUPPORTED_SCSI_OPCODE;
 		break;
 	}
-
-	if (!sc)
+	/*
+	 * If a fabric does not define a cmd->se_tfo->new_cmd_map caller,
+	 * make the call to transport_send_check_condition_and_sense()
+	 * directly.  Otherwise expect the fabric to make the call to
+	 * transport_send_check_condition_and_sense() after handling
+	 * possible unsoliticied write data payloads.
+	 */
+	if (!sc && !cmd->se_tfo->new_cmd_map)
 		transport_new_cmd_failure(cmd);
 	else {
 		ret = transport_send_check_condition_and_sense(cmd,
-- 
1.7.6

