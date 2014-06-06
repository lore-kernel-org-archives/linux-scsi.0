From: shirishpargaonkar@gmail.com
Subject: [PATCH] bnx2fc: Do not log error for netevents that need no action
Date: Fri,  6 Jun 2014 13:05:59 -0500
Message-ID: <1402077959-13170-1-git-send-email-spargaonkar@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:59649 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbaFFSGI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2014 14:06:08 -0400
Received: by mail-oa0-f41.google.com with SMTP id m1so3248327oag.0
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jun 2014 11:06:08 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eddie.wai@broadcom.com, fcoe-devel@open-fcoe.org, Shirish Pargaonkar <shirishpargaonkar@gmail.com>

From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>


Do not log error for netevents that need no action such as
NETDEV_REGISTER 0x0005, NETDEV_CHANGEADDR, and NETDEV_CHANGENAME.
It results in logging error messages such as these

[   35.315872] bnx2fc: Unknown netevent 5
[   35.315935] bnx2fc: Unknown netevent 8
[   35.353866] bnx2fc: Unknown netevent 10

and generating bug reports.
Remove logging this message as an ERROR instead of turning them into
either DEBUG or INFO level messages.


Signed-by: Shirish Pargaonkar <spargaonkar@suse.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 1d41f4b..c7388a8 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -856,7 +856,6 @@ static void bnx2fc_indicate_netevent(void *context, unsigned long event,
 		return;
 
 	default:
-		printk(KERN_ERR PFX "Unknown netevent %ld", event);
 		return;
 	}
 
-- 
1.8.3.2

