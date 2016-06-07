From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 05/16] target: Setup target_iostate memory in __target_execute_cmd
Date: Tue,  7 Jun 2016 04:12:30 +0000
Message-ID: <1465272761-26045-6-git-send-email-nab@linux-iscsi.org>
References: <1465272761-26045-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:55978 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbcFGENi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2016 00:13:38 -0400
In-Reply-To: <1465272761-26045-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch sets up the required target_iostate pointers to
se_cmd->execute_cmd() via existing sbc_ops.

This includes:

   - struct se_device,
   - struct target_iomem,
   - and ->t_comp_func() callback.

Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 2207624..4156059 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1797,6 +1797,12 @@ void __target_execute_cmd(struct se_cmd *cmd, bool do_checks)
 			goto err;
 		}
 	}
+	/*
+	 * Setup t_iostate + t_iomem for backend device submission
+	 */
+	cmd->t_iostate.se_dev = cmd->se_dev;
+	cmd->t_iostate.iomem = &cmd->t_iomem;
+	cmd->t_iostate.t_comp_func = &target_complete_ios;
 
 	ret = cmd->execute_cmd(cmd);
 	if (!ret)
-- 
1.9.1

