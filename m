From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 7/8] target_core_alua: disallow READ_CAPACITY when in standby
Date: Thu, 18 Jun 2015 11:43:41 +0200
Message-ID: <1434620622-65391-8-git-send-email-hare@suse.de>
References: <1434620622-65391-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1434620622-65391-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Strictly speaking SPC doesn't require READ CAPACITY and friends
to be supported while in the port is in standby.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_alua.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index edaf1b9..a62e58b 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -561,16 +561,7 @@ static inline int core_alua_state_standby(
 	case REPORT_LUNS:
 	case RECEIVE_DIAGNOSTIC:
 	case SEND_DIAGNOSTIC:
-	case READ_CAPACITY:
 		return 0;
-	case SERVICE_ACTION_IN_16:
-		switch (cdb[1] & 0x1f) {
-		case SAI_READ_CAPACITY_16:
-			return 0;
-		default:
-			set_ascq(cmd, ASCQ_04H_ALUA_TG_PT_STANDBY);
-			return 1;
-		}
 	case MAINTENANCE_IN:
 		switch (cdb[1] & 0x1f) {
 		case MI_REPORT_TARGET_PGS:
-- 
1.8.5.2
