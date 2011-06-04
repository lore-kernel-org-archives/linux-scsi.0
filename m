From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/7] iscsi-target: Clear map_sg usage for non ISTATE_SEND_DATAIN ops
Date: Fri,  3 Jun 2011 18:18:14 -0700
Message-ID: <1307150298-23921-4-git-send-email-nab@linux-iscsi.org>
References: <1307150298-23921-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm27-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.188]:44370
	"HELO nm27-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752110Ab1FDBTB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2011 21:19:01 -0400
In-Reply-To: <1307150298-23921-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug in iscsi_target_tx_thread() where 'map_sg' was not
being cleared after ISTATE_SEND_DATAIN and causing iscsit_fe_sendpage_sg()
to be called for non ISTATE_SEND_DATAIN + non ISCSI_OP_SCSI_CMD payloads.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 5a14318..8dedfbf 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3743,6 +3743,7 @@ check_rsp_state:
 					goto transport_err;
 				}
 			}
+			map_sg = 0;
 			iscsit_unmap_iovec(cmd);
 
 			spin_lock_bh(&cmd->istate_lock);
-- 
1.7.2.5

