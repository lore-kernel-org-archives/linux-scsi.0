From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/3] tcm: Add XDWRITEREAD_10 passthrough support
Date: Tue, 21 Sep 2010 23:09:01 -0700
Message-ID: <1285135741-8371-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:45480 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751834Ab0IVGJD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Sep 2010 02:09:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds the simple check for TCM/pSCSI usage with XDWRITE_READ10
to follow commit ba3d8e3f13 and perform the BIDI-COMMAND passthrough.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index e514ffc..6976f93 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -5566,6 +5566,13 @@ static int transport_generic_cmd_sequencer(
 		transport_get_maps(cmd);
 		cmd->transport_split_cdb = &split_cdb_XX_10;
 		cmd->transport_get_lba = &transport_lba_32;
+		passthrough = (TRANSPORT(dev)->transport_type ==
+				TRANSPORT_PLUGIN_PHBA_PDEV);
+		/*
+		 * Skip the remaining assignments for TCM/PSCSI passthrough
+		 */
+		if (passthrough)
+			break;
 		/*
 		 * Setup BIDI XOR callback to be run during transport_generic_complete_ok()
 		 */
-- 
1.5.6.5

