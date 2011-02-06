From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Fix bogus return in transport_add_device_to_core_hba failure path
Date: Sat,  5 Feb 2011 17:57:03 -0800
Message-ID: <1296957423-30480-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp103.sbc.mail.ac4.yahoo.com ([76.13.13.242]:46581 "HELO
	smtp103.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751640Ab1BFB4p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Feb 2011 20:56:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Julia Lawall <julia@diku.dk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes a bogus conditional+return check within the failure path
of transport_add_device_to_core_hba().  This breakage was introduced during
the v4 conversion to remove struct se_cmd passthrough ops for INQUIRY /
READ_CAPCITY during struct se_device creation and registration process.

Reported-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b2fc558..123bd94 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1622,7 +1622,7 @@ struct se_device *transport_add_device_to_core_hba(
 	const char *inquiry_prod,
 	const char *inquiry_rev)
 {
-	int ret = 0, force_pt;
+	int force_pt;
 	struct se_device  *dev;
 
 	dev = kzalloc(sizeof(struct se_device), GFP_KERNEL);
@@ -1739,9 +1739,8 @@ struct se_device *transport_add_device_to_core_hba(
 	}
 	scsi_dump_inquiry(dev);
 
+	return dev;
 out:
-	if (!ret)
-		return dev;
 	kthread_stop(dev->process_thread);
 
 	spin_lock(&hba->device_lock);
-- 
1.5.6.5

