From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] ses: Fix racy cleanup of /sys in remove_dev()
Date: Thu, 24 Aug 2017 15:13:52 +0200
Message-ID: <1503580432-105307-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42760 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751349AbdHXNN4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Aug 2017 09:13:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Calvin Owens <calvinowens@fb.com>

From: Calvin Owens <calvinowens@fb.com>

Currently we free the resources backing the enclosure device before we
call device_unregister(). This is racy: during rmmod of low-level SCSI
drivers that hook into enclosure, we end up with a small window of time
during which writing to /sys can OOPS. Example trace with mpt3sas:

  general protection fault: 0000 [#1] SMP KASAN
  Modules linked in: mpt3sas(-) <...>
  RIP: [<ffffffffa0388a98>] ses_get_page2_descriptor.isra.6+0x38/0x220 [ses]
  Call Trace:
   [<ffffffffa0389d14>] ses_set_fault+0xf4/0x400 [ses]
   [<ffffffffa0361069>] set_component_fault+0xa9/0xf0 [enclosure]
   [<ffffffff8205bffc>] dev_attr_store+0x3c/0x70
   [<ffffffff81677df5>] sysfs_kf_write+0x115/0x180
   [<ffffffff81675725>] kernfs_fop_write+0x275/0x3a0
   [<ffffffff8151f810>] __vfs_write+0xe0/0x3e0
   [<ffffffff8152281f>] vfs_write+0x13f/0x4a0
   [<ffffffff81526731>] SyS_write+0x111/0x230
   [<ffffffff828b401b>] entry_SYSCALL_64_fastpath+0x13/0x94

Fortunately the solution is extremely simple: call device_unregister()
before we free the resources, and the race no longer exists. The driver
core holds a reference over ->remove_dev(), so AFAICT this is safe.

Bugzilla: https://bugzilla.suse.com/show_bug.cgi?id=989094
Signed-off-by: Calvin Owens <calvinowens@fb.com>
Acked-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/ses.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index a3f9350..ea7066c 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -818,8 +818,6 @@ static void ses_intf_remove_enclosure(struct scsi_device *sdev)
 	if (!edev)
 		return;
 
-	enclosure_unregister(edev);
-
 	ses_dev = edev->scratch;
 	edev->scratch = NULL;
 
@@ -831,6 +829,7 @@ static void ses_intf_remove_enclosure(struct scsi_device *sdev)
 	kfree(edev->component[0].scratch);
 
 	put_device(&edev->edev);
+	enclosure_unregister(edev);
 }
 
 static void ses_intf_remove(struct device *cdev,
-- 
1.8.5.6
