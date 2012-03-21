From: santosh nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH] [SCSI] megaraid: add error handling for failed kmalloc() in mega_internal_command().
Date: Wed, 21 Mar 2012 22:59:44 +0530
Message-ID: <1332350984-7280-1-git-send-email-santoshprasadnayak@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34349 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565Ab2CURbS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Mar 2012 13:31:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: megaraidlinux@lsi.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, Santosh Nayak <santoshprasadnayak@gmail.com>

From: Santosh Nayak <santoshprasadnayak@gmail.com>

Add error handling after kzalloc() call to avoid null dereference.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 drivers/scsi/megaraid.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 4d39a9f..41e7b42 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4438,6 +4438,10 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
 	memset(scb, 0, sizeof(scb_t));
 
 	sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
+	if (unlikely(!sdev)) {
+		printk(KERN_ERR "%s: failed to alloc memory\n", __func__);
+		return -ENOMEM;
+	}
 	scmd->device = sdev;
 
 	memset(adapter->int_cdb, 0, sizeof(adapter->int_cdb));
-- 
1.7.4.4

