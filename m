From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [PATCH V8 7/9] aacraid: IOCTL fix
Date: Fri, 28 Aug 2015 06:38:39 -0400
Message-ID: <1440758321-2996-8-git-send-email-Mahesh.Rajashekhara@pmcs.com>
References: <1440758321-2996-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:54195 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751981AbbH1KjJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Aug 2015 06:39:09 -0400
In-Reply-To: <1440758321-2996-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, Murthy.Bhat@pmcs.com, Karthikeya.Sunkesula@pmcs.com, aacraid@pmc-sierra.com, Harry.Yang@pmcs.com, Rich.Bono@pmcs.com

Driver blocks ioctls once it received shutdown/suspend request during
suspend/hybernation. This patch unblocks ioctls on resume path.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Murthy Bhat <Murthy.Bhat@pmcs.com>
Reviewed-by: Karthikeya Sunkesula <Karthikeya.Sunkesula@pmcs.com>
Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
Changes from V2:
None
 drivers/scsi/aacraid/linit.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 37375cf..3b6e5c6 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1448,6 +1448,11 @@ static int aac_resume(struct pci_dev *pdev)
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

