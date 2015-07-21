From: Spencer Baugh <sbaugh@catern.com>
Subject: [PATCH] target/iscsi: Fix double free of a TUR followed by a solicited NOPOUT
Date: Tue, 21 Jul 2015 15:07:56 -0700
Message-ID: <1437516477-30554-4-git-send-email-sbaugh@catern.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Andy Grover <agrover@redhat.com>, Alexei Potashnik <alexei@purestorage.com>, Christophe Vu-Brugier <cvubrugier@fastmail.fm>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>, Spencer Baugh <sbaugh@catern.com>
List-Id: linux-scsi@vger.kernel.org

From: Alexei Potashnik <alexei@purestorage.com>

Make sure all non-READ SCSI commands get targ_xfer_tag initialized
to 0xffffffff, not just WRITEs.

Double-free of a TUR cmd object occurs under the following scenario:

1. TUR received (targ_xfer_tag is uninitialized and left at 0)
2. TUR status sent
3. First unsolicited NOPIN is sent to initiator (gets targ_xfer_tag of 0)
4. NOPOUT for NOPIN (with TTT=0) arrives
 - its ExpStatSN acks TUR status, TUR is queued for removal
 - LIO tries to find NOPIN with TTT=0, but finds the same TUR instead,
   TUR is queued for removal for the 2nd time

Signed-off-by: Alexei Potashnik <alexei@purestorage.com>
Signed-off-by: Spencer Baugh <sbaugh@catern.com>
---
 drivers/target/iscsi/iscsi_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index a4cf58c..ebb1ece 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -970,7 +970,7 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	conn->sess->init_task_tag = cmd->init_task_tag = hdr->itt;
 	if (hdr->flags & ISCSI_FLAG_CMD_READ) {
 		cmd->targ_xfer_tag = session_get_next_ttt(conn->sess);
-	} else if (hdr->flags & ISCSI_FLAG_CMD_WRITE)
+	} else
 		cmd->targ_xfer_tag = 0xFFFFFFFF;
 	cmd->cmd_sn		= be32_to_cpu(hdr->cmdsn);
 	cmd->exp_stat_sn	= be32_to_cpu(hdr->exp_statsn);
-- 
2.4.3
