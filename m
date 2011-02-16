From: michaelc@cs.wisc.edu
Subject: [PATCH 03/17] BNX2I: Added handling for unsupported iSCSI offload hba
Date: Wed, 16 Feb 2011 15:04:27 -0600
Message-ID: <1297890281-9076-4-git-send-email-michaelc@cs.wisc.edu>
References: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377Ab1BPVEc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2011 16:04:32 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1GL4WqO009063
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:32 -0500
Received: from meanminna.corp.redhat.com (vpn-11-254.rdu.redhat.com [10.11.11.254])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1GL4Tsq004636
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:32 -0500
In-Reply-To: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Eddie Wai <eddie.wai@broadcom.com>

The hba will now be unregistered and freed when iSCSI offload
is not supported by the NIC.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/bnx2i/bnx2i_init.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 72a7b2d..6afaa34 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -161,6 +161,21 @@ void bnx2i_start(void *handle)
 	struct bnx2i_hba *hba = handle;
 	int i = HZ;
 
+	if (!hba->cnic->max_iscsi_conn) {
+		printk(KERN_ALERT "bnx2i: dev %s does not support "
+			"iSCSI\n", hba->netdev->name);
+
+		if (test_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic)) {
+			mutex_lock(&bnx2i_dev_lock);
+			list_del_init(&hba->link);
+			adapter_count--;
+			hba->cnic->unregister_device(hba->cnic, CNIC_ULP_ISCSI);
+			clear_bit(BNX2I_CNIC_REGISTERED, &hba->reg_with_cnic);
+			mutex_unlock(&bnx2i_dev_lock);
+			bnx2i_free_hba(hba);
+		}
+		return;
+	}
 	bnx2i_send_fw_iscsi_init_msg(hba);
 	while (!test_bit(ADAPTER_STATE_UP, &hba->adapter_state) && i--)
 		msleep(BNX2I_INIT_POLL_TIME);
-- 
1.7.2.3

