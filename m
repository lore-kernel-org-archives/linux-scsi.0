From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 06/16] BNX2I: Added code to handle the binding of an
 existing connection
Date: Wed, 10 Nov 2010 15:04:47 -0800
Message-ID: <1289430297-30221-7-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1955 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757410Ab0KJXDI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2010 18:03:08 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

This is the case when iscsid gets re-launched due to features like
iSCSI boot which requires the daemon to re-launch due to
pivot root.  If the code detected the connection had an existing
endpoint, the old endpoint must get cleaned up.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Acked-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 823e4fa..3b65c64 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1410,6 +1410,13 @@ static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
 				  hba->netdev->name);
 		return -EEXIST;
 	}
+	if (bnx2i_conn->ep) {
+		printk(KERN_ALERT "bnx2i: Binding to an existing endpoint "
+			"detected.  Disconnecting the old...\n");
+		mutex_lock(&hba->net_dev_lock);
+		bnx2i_hw_ep_disconnect(bnx2i_conn->ep);
+		mutex_unlock(&hba->net_dev_lock);
+	}
 	bnx2i_ep->conn = bnx2i_conn;
 	bnx2i_conn->ep = bnx2i_ep;
 	bnx2i_conn->iscsi_conn_cid = bnx2i_ep->ep_iscsi_cid;
-- 
1.7.0.5


