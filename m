From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/6] target: Send UA upon LUN RESET tmr completion
Date: Thu, 11 Jun 2015 10:01:28 +0200
Message-ID: <1434009689-112909-6-git-send-email-hare@suse.de>
References: <1434009689-112909-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465AbbFKIBf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jun 2015 04:01:35 -0400
In-Reply-To: <1434009689-112909-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>

SAM mandates that an BUS DEVICE RESET FUNCTION OCCURRED
UA needs to be send after a LUN RESET tmr has completed.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_transport.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index a0e0d3a..bb60c0c4 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3064,6 +3064,17 @@ static void target_tmr_work(struct work_struct *work)
 		ret = core_tmr_lun_reset(dev, tmr, NULL, NULL);
 		tmr->response = (!ret) ? TMR_FUNCTION_COMPLETE :
 					 TMR_FUNCTION_REJECTED;
+		if (tmr->response == TMR_FUNCTION_COMPLETE) {
+			struct se_dev_entry *deve;
+
+			rcu_read_lock();
+			deve = target_nacl_find_deve(cmd->se_sess->se_node_acl,
+						     cmd->orig_fe_lun);
+			if (deve)
+				core_scsi3_ua_allocate(deve, 0x29,
+					ASCQ_29H_BUS_DEVICE_RESET_FUNCTION_OCCURRED);
+			rcu_read_unlock();
+		}
 		break;
 	case TMR_TARGET_WARM_RESET:
 		tmr->response = TMR_FUNCTION_REJECTED;
-- 
1.8.5.2

