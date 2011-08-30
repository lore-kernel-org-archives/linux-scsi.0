From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 4/8] bnx2fc: Validate vlan id in NETDEV_UNREGISTER
 handler
Date: Tue, 30 Aug 2011 15:54:50 -0700
Message-ID: <1314744894-24710-5-git-send-email-bprakash@broadcom.com>
References: <1314744894-24710-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3371 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab1H3WzG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2011 18:55:06 -0400
In-Reply-To: <1314744894-24710-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, nsujir@broadcom.com, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Nithin Nayak Sujir <nsujir@broadcom.com>

When bnx2fc receives an UNREGISTER event on a vlan interface it calls
destroy on all interfaces that matches the physical interface. Add
vlan_id check to destroy only the vlan interface that generated the
event.

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index ba88ddb..886938d 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -838,9 +838,9 @@ static void bnx2fc_indicate_netevent(void *context, unsigned long event,
 			return;
 		mutex_lock(&bnx2fc_dev_lock);
 		list_for_each_entry_safe(interface, tmp, &if_list, list) {
-			if (interface->hba != hba)
-				continue;
-			__bnx2fc_destroy(interface);
+			if (interface->hba == hba &&
+			    interface->vlan_id == (vlan_id & VLAN_VID_MASK))
+				__bnx2fc_destroy(interface);
 		}
 		mutex_unlock(&bnx2fc_dev_lock);
 		return;
-- 
1.7.0.6


