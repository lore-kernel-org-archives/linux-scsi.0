From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 14/32] target: Remove extra percpu_ref_init
Date: Fri, 13 Dec 2013 15:59:02 -0800
Message-ID: <1386979160-6928-15-git-send-email-agrover@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1386979160-6928-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

lun->lun_ref is also initialized in core_tpg_post_addlun, so it doesn't
need to be done in core_tpg_setup_virtual_lun0.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_tpg.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 8771b23..2f6df57 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -658,10 +658,6 @@ static int core_tpg_setup_virtual_lun0(struct se_portal_group *se_tpg)
 	spin_lock_init(&lun->lun_sep_lock);
 	init_completion(&lun->lun_ref_comp);
 
-	ret = percpu_ref_init(&lun->lun_ref, core_tpg_lun_ref_release);
-	if (ret < 0)
-		return ret;
-
 	ret = core_tpg_post_addlun(se_tpg, lun, lun_access, dev);
 	if (ret < 0) {
 		percpu_ref_cancel_init(&lun->lun_ref);
-- 
1.7.1
