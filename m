From: Dan Carpenter <error27@gmail.com>
Subject: [patch] [SCSI] megaraid: remove a spurious IRQ enable
Date: Sat, 30 Jul 2011 11:39:20 +0300
Message-ID: <20110730083920.GC5575@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51611 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab1G3IlU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Jul 2011 04:41:20 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "open list:MEGARAID SCSI DRI..." <linux-scsi@vger.kernel.org>, kernel-janitors@vger.kernel.org

This is a static checker fix.  We took this lock with spin_lock()
so we should unlock it with spin_unlock() instead of
spin_unlock_irq().

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Not tested.

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index ad13363..57782d9 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -2731,7 +2731,7 @@ megaraid_reset_handler(struct scsi_cmnd *scp)
 	}
 
  out:
-	spin_unlock_irq(&adapter->lock);
+	spin_unlock(&adapter->lock);
 	return rval;
 }
 
