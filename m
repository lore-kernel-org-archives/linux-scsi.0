From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 07/15] target: Add internal READ_INSERT support
Date: Mon, 30 Mar 2015 03:28:16 +0000
Message-ID: <1427686104-14231-8-git-send-email-nab@daterainc.com>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds READ_INSERT support in target_check_read_prot() that
invokes sbc_dif_generate() when LIO is responsible for generating the
outgoing T10-PI.

Required for supporting fabrics that exchange protection information,
and would like to function with un-protected devices.

Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index e603e34..12b13da 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1994,6 +1994,12 @@ static bool target_check_read_prot(struct se_cmd *cmd)
 			}
 		}
 		break;
+	case TARGET_PROT_DIN_INSERT:
+		if (cmd->se_sess->sup_prot_ops & TARGET_PROT_DIN_INSERT)
+			break;
+
+		sbc_dif_generate(cmd);
+		break;
 	default:
 		break;
 	}
-- 
1.9.1
