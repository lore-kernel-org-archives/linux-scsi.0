From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 042/103] target: Fix WRITE_SAME_16 t_task_lba assignment bug
Date: Thu, 21 Jul 2011 00:07:54 -0700
Message-ID: <1311232135-6653-43-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm6.access.bullet.mail.sp2.yahoo.com ([98.139.44.133]:35584
	"HELO nm6.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752030Ab1GUHJR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:09:17 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug in the assignment of cmd->t_task.t_task_lba with
WRITE_SAME_16 to correctly use get_unaligned_be64() for the 64-bit LBA.

Reported-by: Chris Greiveldinger <chris.greiveldinger@rnanetworks.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d0cd601..a29f6d3 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3417,7 +3417,7 @@ static int transport_generic_cmd_sequencer(
 		if (sector_ret)
 			goto out_unsupported_cdb;
 		size = transport_get_size(sectors, cdb, cmd);
-		cmd->t_task.t_task_lba = get_unaligned_be16(&cdb[2]);
+		cmd->t_task.t_task_lba = get_unaligned_be64(&cdb[2]);
 		passthrough = (dev->transport->transport_type ==
 				TRANSPORT_PLUGIN_PHBA_PDEV);
 		/*
-- 
1.7.6

