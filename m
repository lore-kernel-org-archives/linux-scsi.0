From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/5] tcm_loop: Check for valid hba in tcm_loop_drop_nexus()
Date: Wed, 16 Oct 2013 09:12:52 +0200
Message-ID: <1381907576-81857-2-git-send-email-hare@suse.de>
References: <1381907576-81857-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1381907576-81857-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/loopback/tcm_loop.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 0f6d69d..57d5a95 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -932,7 +932,10 @@ static int tcm_loop_drop_nexus(
 	struct tcm_loop_nexus *tl_nexus;
 	struct tcm_loop_hba *tl_hba = tpg->tl_hba;
 
-	tl_nexus = tpg->tl_hba->tl_nexus;
+	if (!tl_hba)
+		return -ENODEV;
+
+	tl_nexus = tl_hba->tl_nexus;
 	if (!tl_nexus)
 		return -ENODEV;
 
-- 
1.7.12.4
