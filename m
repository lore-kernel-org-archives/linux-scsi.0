From: <rajinikanth.pandurangan@pmcs.com>
Subject: [PATCH 7/9] [SCSI] aacraid: Unblock IOCTLs to controller once system resumed from suspend
Date: Wed, 13 May 2015 17:12:56 -0700
Message-ID: <1431562378-8514-8-git-send-email-rajinikanth.pandurangan@pmcs.com>
References: <1431562378-8514-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:53762 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933920AbbENAOn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2015 20:14:43 -0400
In-Reply-To: <1431562378-8514-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, rich.bono@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com, rajinikanth.pandurangan@pmcs.com

From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

Description:
	Driver blocks ioctls once it received shutdown/suspend request during
	suspend/hybernation. This patch unblocks ioctls on resume path.

Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
---
 drivers/scsi/aacraid/linit.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 62a928f..d977cd2 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1363,6 +1363,11 @@ static int aac_resume(struct pci_dev *pdev)
 	pci_set_master(pdev);
 	if (aac_acquire_resources(aac))
 		goto fail_device;
+	/*
+	* reset this flag to unblock ioctl() as it was set at
+	* aac_send_shutdown() to block ioctls from upperlayer
+	*/
+	aac->adapter_shutdown = 0;
 	scsi_unblock_requests(shost);
 
 	return 0;
-- 
1.9.3

