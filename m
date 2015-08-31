From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH] scsi_scan: don't dump trace when scsi_prep_async_scan() is called twice
Date: Mon, 31 Aug 2015 17:00:53 +0200
Message-ID: <1441033253-24595-1-git-send-email-vkuznets@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020AbbHaPA4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Aug 2015 11:00:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>, Long Li <longli@microsoft.com>, Dexuan Cui <decui@microsoft.com>

The only user of scsi_prep_async_scan() is scsi_scan_host() and it handles
the situation correctly. Move 'called twice' reporting to debug level as
well.

The issue is observed on Hyper-V: on any device add/remove event storvsc
driver calls scsi_scan_host() and in case previous scan is still running
we get the message and stack dump on console.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/scsi/scsi_scan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index f9f3f82..01ad016 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1712,8 +1712,7 @@ static struct async_scan_data *scsi_prep_async_scan(struct Scsi_Host *shost)
 		return NULL;
 
 	if (shost->async_scan) {
-		shost_printk(KERN_INFO, shost, "%s called twice\n", __func__);
-		dump_stack();
+		shost_printk(KERN_DEBUG, shost, "%s called twice\n", __func__);
 		return NULL;
 	}
 
-- 
2.4.3

