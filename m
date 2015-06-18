From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/8] tcm_loop: Rescan SCSI target on transport online
Date: Thu, 18 Jun 2015 11:43:39 +0200
Message-ID: <1434620622-65391-6-git-send-email-hare@suse.de>
References: <1434620622-65391-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1434620622-65391-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Setting the transport status to 'online' needs to rescan the
target, as some devices might have been added while the transport
has been offline.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/loopback/tcm_loop.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 6c724dd..7db31f3 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -1082,7 +1082,16 @@ static ssize_t tcm_loop_tpg_store_transport_status(
 			struct tcm_loop_tpg, tl_se_tpg);
 
 	if (!strncmp(page, "online", 6)) {
+		int status = tl_tpg->tl_transport_status;
+
 		tl_tpg->tl_transport_status = TCM_TRANSPORT_ONLINE;
+		if (status != tl_tpg->tl_transport_status &&
+		    tl_tpg->tl_hba->tl_proto_id == SCSI_PROTOCOL_SAS) {
+			struct sas_rphy *rphy = tl_tpg->sas_rphy;
+
+			scsi_scan_target(&rphy->dev, 0, rphy->scsi_target_id,
+					 SCAN_WILD_CARD, 0);
+		}
 		return count;
 	}
 	if (!strncmp(page, "offline", 7)) {
-- 
1.8.5.2
