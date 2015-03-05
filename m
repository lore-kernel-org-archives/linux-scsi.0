From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH] target: Fix virtual LUN=0 target_configure_device failure OOPs
Date: Thu,  5 Mar 2015 06:16:56 +0000
Message-ID: <1425536216-2478-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:41145 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbbCEGu4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2015 01:50:56 -0500
Received: by obcva8 with SMTP id va8so794235obc.8
        for <linux-scsi@vger.kernel.org>; Wed, 04 Mar 2015 22:50:55 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Claudio Fleiner <cmf@daterainc.com>, Christoph Hellwig <hch@lst.de>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a NULL pointer dereference triggered by a late
target_configure_device() -> alloc_workqueue() failure that results
in target_free_device() being called with DF_CONFIGURED already set,
which subsequently OOPses in destroy_workqueue() code.

Currently this only happens at modprobe target_core_mod time when
core_dev_setup_virtual_lun0() -> target_configure_device() fails,
and the explicit target_free_device() gets called.

To address this bug originally introduced by commit 0fd97ccf45, go
ahead and move DF_CONFIGURED to end of target_configure_device()
code to handle this special failure case.

Reported-by: Claudio Fleiner <cmf@daterainc.com>
Cc: Claudio Fleiner <cmf@daterainc.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 37449bd..7fc5eae 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1548,8 +1548,6 @@ int target_configure_device(struct se_device *dev)
 	ret = dev->transport->configure_device(dev);
 	if (ret)
 		goto out;
-	dev->dev_flags |= DF_CONFIGURED;
-
 	/*
 	 * XXX: there is not much point to have two different values here..
 	 */
@@ -1611,6 +1609,8 @@ int target_configure_device(struct se_device *dev)
 	list_add_tail(&dev->g_dev_node, &g_device_list);
 	mutex_unlock(&g_device_mutex);
 
+	dev->dev_flags |= DF_CONFIGURED;
+
 	return 0;
 
 out_free_alua:
-- 
1.9.1

