From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/6] target: Send UA on ALUA target port group change
Date: Thu, 11 Jun 2015 10:01:27 +0200
Message-ID: <1434009689-112909-5-git-send-email-hare@suse.de>
References: <1434009689-112909-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1434009689-112909-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

When the ALUA target port group changes an INQUIRY DATA CHANGE
UA needs to be sent.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_alua.c | 7 +++++++
 drivers/target/target_core_ua.h   | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index aa2e4b1..edaf1b9 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1880,12 +1880,19 @@ static void core_alua_put_tg_pt_gp_from_name(
 static void __target_attach_tg_pt_gp(struct se_lun *lun,
 		struct t10_alua_tg_pt_gp *tg_pt_gp)
 {
+	struct se_dev_entry *se_deve;
+
 	assert_spin_locked(&lun->lun_tg_pt_gp_lock);
 
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
 	lun->lun_tg_pt_gp = tg_pt_gp;
 	list_add_tail(&lun->lun_tg_pt_gp_link, &tg_pt_gp->tg_pt_gp_lun_list);
 	tg_pt_gp->tg_pt_gp_members++;
+	spin_lock_bh(&lun->lun_deve_lock);
+	list_for_each_entry(se_deve, &lun->lun_deve_list, lun_link)
+		core_scsi3_ua_allocate(se_deve, 0x3f,
+				       ASCQ_3FH_INQUIRY_DATA_HAS_CHANGED);
+	spin_unlock_bh(&lun->lun_deve_lock);
 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 }
 
diff --git a/drivers/target/target_core_ua.h b/drivers/target/target_core_ua.h
index a9c4693..948ae1e 100644
--- a/drivers/target/target_core_ua.h
+++ b/drivers/target/target_core_ua.h
@@ -25,6 +25,8 @@
 
 #define ASCQ_2CH_PREVIOUS_RESERVATION_CONFLICT_STATUS		0x09
 
+#define ASCQ_3FH_INQUIRY_DATA_HAS_CHANGED			0x03
+
 extern struct kmem_cache *se_ua_cache;
 
 extern sense_reason_t target_scsi3_ua_check(struct se_cmd *);
-- 
1.8.5.2
