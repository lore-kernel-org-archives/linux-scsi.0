From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 30/31] target: Fix bogus return in transport_add_device_to_core_hba failure path
Date: Wed,  9 Feb 2011 15:35:05 -0800
Message-ID: <1297294506-23579-31-git-send-email-nab@linux-iscsi.org>
References: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm15-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.208]:31445 "HELO
	nm15-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756129Ab1BIXgG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2011 18:36:06 -0500
In-Reply-To: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

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
index c684956..a0589b5 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1623,7 +1623,7 @@ struct se_device *transport_add_device_to_core_hba(
 	const char *inquiry_prod,
 	const char *inquiry_rev)
 {
-	int ret = 0, force_pt;
+	int force_pt;
 	struct se_device  *dev;
 
 	dev = kzalloc(sizeof(struct se_device), GFP_KERNEL);
@@ -1740,9 +1740,8 @@ struct se_device *transport_add_device_to_core_hba(
 	}
 	scsi_dump_inquiry(dev);
 
+	return dev;
 out:
-	if (!ret)
-		return dev;
 	kthread_stop(dev->process_thread);
 
 	spin_lock(&hba->device_lock);
-- 
1.7.4

