From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/8] target: Issue Power-On/Reset UA upon LUN instantiation
Date: Thu, 18 Jun 2015 11:43:40 +0200
Message-ID: <1434620622-65391-7-git-send-email-hare@suse.de>
References: <1434620622-65391-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1434620622-65391-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Whenever a LUN is being assigned we should be sending out an
Power-On/Reset UA.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_device.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 52676a0..88d6070 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -363,9 +363,11 @@ int core_enable_device_list_for_node(
 		rcu_read_lock();
 		hlist_for_each_entry_rcu(tmp, &nacl->lun_entry_hlist, link) {
 			if (tmp == new)
-				continue;
-			core_scsi3_ua_allocate(tmp, 0x3F,
-				ASCQ_3FH_REPORTED_LUNS_DATA_HAS_CHANGED);
+				core_scsi3_ua_allocate(tmp, 0x29,
+					ASCQ_29H_POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURED);
+			else
+				core_scsi3_ua_allocate(tmp, 0x3F,
+					ASCQ_3FH_REPORTED_LUNS_DATA_HAS_CHANGED);
 		}
 		rcu_read_unlock();
 
@@ -385,9 +387,11 @@ int core_enable_device_list_for_node(
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(tmp, &nacl->lun_entry_hlist, link) {
 		if (tmp == new)
-			continue;
-		core_scsi3_ua_allocate(tmp, 0x3F,
-			ASCQ_3FH_REPORTED_LUNS_DATA_HAS_CHANGED);
+			core_scsi3_ua_allocate(tmp, 0x29,
+				ASCQ_29H_POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURED);
+		else
+			core_scsi3_ua_allocate(tmp, 0x3F,
+				ASCQ_3FH_REPORTED_LUNS_DATA_HAS_CHANGED);
 	}
 	rcu_read_unlock();
 	return 0;
-- 
1.8.5.2
