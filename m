From: michaelc@cs.wisc.edu
Subject: [PATCH 5/6] iscsi_boot_sysfs: Fix a memory leak in iscsi_boot_destroy_kset()
Date: Fri, 20 Dec 2013 12:53:46 -0600
Message-ID: <1387565627-5218-6-git-send-email-michaelc@cs.wisc.edu>
References: <1387565627-5218-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:33116 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab3LTSyA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Dec 2013 13:54:00 -0500
Received: from localhost.localdomain (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id rBKIrs2b010889
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 20 Dec 2013 12:53:59 -0600
In-Reply-To: <1387565627-5218-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Ethan Zhao <ethan.kernel@gmail.com>

Load and unload iscsi_ibft module will cause kernel memory leak, fix it
in scsi/iscsi_boot_sysfs.c iscsi_boot_destroy_kset().

Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_boot_sysfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/iscsi_boot_sysfs.c b/drivers/scsi/iscsi_boot_sysfs.c
index 14c1c8f..680bf6f 100644
--- a/drivers/scsi/iscsi_boot_sysfs.c
+++ b/drivers/scsi/iscsi_boot_sysfs.c
@@ -490,5 +490,6 @@ void iscsi_boot_destroy_kset(struct iscsi_boot_kset *boot_kset)
 		iscsi_boot_remove_kobj(boot_kobj);
 
 	kset_unregister(boot_kset->kset);
+	kfree(boot_kset);
 }
 EXPORT_SYMBOL_GPL(iscsi_boot_destroy_kset);
-- 
1.7.1

