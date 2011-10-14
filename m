From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 07/37] tfm_fc: use transport_handle_cdb_direct
Date: Fri, 14 Oct 2011 00:41:39 +0000
Message-ID: <1318552929-13341-8-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Kiran Patil <kiran.patil@intel.com>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

ft_send_work is always called from workqueue context, which means we can
handle the CDB directly instead of doing another context switch.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_fc/tfc_cmd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 3c6c5a1..c2d148d 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -639,7 +639,7 @@ static void ft_send_work(struct work_struct *work)
 		transport_generic_free_cmd(se_cmd, 0, 0);
 		return;
 	}
-	transport_generic_handle_cdb(se_cmd);
+	transport_handle_cdb_direct(se_cmd);
 	return;
 
 err:
-- 
1.5.6.5
