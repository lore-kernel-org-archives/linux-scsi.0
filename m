From: Roland Dreier <roland@kernel.org>
Subject: [PATCH] iscsi-target: Fix memory leak if iscsit_alloc_buffs() fails
Date: Thu, 23 Feb 2012 17:28:43 -0800
Message-ID: <1330046923-4034-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

The function kzalloc()s sgl, but if page allocation fails, it never
frees sgl on the page_alloc_failed path.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/target/iscsi/iscsi_target.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 9cd2837..529bf3b 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -830,6 +830,7 @@ page_alloc_failed:
 		__free_page(sg_page(&sgl[i]));
 		i--;
 	}
+	kfree(sgl);
 	kfree(cmd->t_mem_sg);
 	cmd->t_mem_sg = NULL;
 	return -ENOMEM;
-- 
1.7.9
