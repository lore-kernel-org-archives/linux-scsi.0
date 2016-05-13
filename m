From: Calvin Owens <calvinowens@fb.com>
Subject: [PATCH] ses: Fix racy cleanup of /sys in remove_dev()
Date: Fri, 13 May 2016 13:28:21 -0700
Message-ID: <4912ec551a8ec01181cc3e7ad1e01d3d36758810.1463170976.git.calvinowens@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6902 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753334AbcEMU2h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 May 2016 16:28:37 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.16.0.11/8.16.0.11) with SMTP id u4DKQ6Iv027855
	for <linux-scsi@vger.kernel.org>; Fri, 13 May 2016 13:28:36 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by m0089730.ppops.net with ESMTP id 22wj0qha9u-1
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 13 May 2016 13:28:36 -0700
Received: from facebook.com (2401:db00:11:d0be:face:0:1b:0)	by
 mx-out.facebook.com (10.103.99.99) with ESMTP	id
 44472140194911e687f80002c9dfb610-b0ee6c50 for <linux-scsi@vger.kernel.org>;
	Fri, 13 May 2016 13:28:35 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, calvinowens@fb.com

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

Signed-off-by: Calvin Owens <calvinowens@fb.com>
---
 drivers/scsi/ses.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 53ef1cb..0e8601a 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -778,6 +778,8 @@ static void ses_intf_remove_enclosure(struct scsi_device *sdev)
 	if (!edev)
 		return;
 
+	enclosure_unregister(edev);
+
 	ses_dev = edev->scratch;
 	edev->scratch = NULL;
 
@@ -789,7 +791,6 @@ static void ses_intf_remove_enclosure(struct scsi_device *sdev)
 	kfree(edev->component[0].scratch);
 
 	put_device(&edev->edev);
-	enclosure_unregister(edev);
 }
 
 static void ses_intf_remove(struct device *cdev,
-- 
2.8.0.rc2

