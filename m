From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 10/13] target/fc: Use transport_generic_free_cmd for ft_sess_put in ft_send_tm
Date: Thu, 19 Jan 2012 13:39:20 -0800
Message-ID: <1327009163-10177-11-git-send-email-agrover@redhat.com>
References: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1327009163-10177-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kiran.patil@intel.com
List-Id: linux-scsi@vger.kernel.org

transport_generic_free_cmd will end up calling ft_sess_put, so it should
work just the same.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/tcm_fc/tfc_cmd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index e784514..da73d0a 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -400,7 +400,7 @@ static void ft_send_tm(struct ft_cmd *cmd)
 		ft_dump_cmd(cmd, __func__);
 		transport_send_check_condition_and_sense(&cmd->se_cmd,
 			cmd->se_cmd.scsi_sense_reason, 0);
-		ft_sess_put(cmd->sess);
+		transport_generic_free_cmd(&cmd->se_cmd, 0);
 		return;
 	}
 
-- 
1.7.1
