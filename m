From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Fix WRITE_SAME_16 lba assignment breakage
Date: Thu, 28 Jul 2011 05:00:09 +0000
Message-ID: <1311829209-22961-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43608 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab1G1FXs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2011 01:23:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug in WRITE_SAME_16 LBA assignment where get_unaligned_be16()
is incorrectly being used instead of get_unaligned_be64() for a 64-bit LBA.

This was introduced with:

commit 493457e1bb90e959f137ff317717a8cae77a0229
Author: Andy Grover <agrover@redhat.com>
Date:   Wed May 4 15:54:58 2011 -0700

    target: inline struct se_transport_task into struct se_cmd

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ebf56cd..3ccabc6 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3326,7 +3326,7 @@ static int transport_generic_cmd_sequencer(
 			goto out_invalid_cdb_field;
 		}
 
-		cmd->t_task_lba = get_unaligned_be16(&cdb[2]);
+		cmd->t_task_lba = get_unaligned_be64(&cdb[2]);
 		passthrough = (dev->transport->transport_type ==
 				TRANSPORT_PLUGIN_PHBA_PDEV);
 		/*
-- 
1.7.2.5

