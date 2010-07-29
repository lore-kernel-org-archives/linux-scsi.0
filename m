From: Kulikov Vasiliy <segooon@gmail.com>
Subject: [PATCH] scsi: ch: check put_user() result
Date: Thu, 29 Jul 2010 19:56:02 +0400
Message-ID: <1280418963-5984-1-git-send-email-segooon@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46550 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614Ab0G2P4Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jul 2010 11:56:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kernel-janitors@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, Davidlohr Bueso <dave@gnu.org>, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

put_user() may fail, if so return -EFAULT.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/scsi/ch.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 4799d43..978bf68 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -548,7 +548,10 @@ static int ch_gstatus(scsi_changer *ch, int type, unsigned char __user *dest)
 			retval = -EIO;
 			break;
 		}
-		put_user(data[2], dest+i);
+		if (put_user(data[2], dest+i)) {
+			retval = -EFAULT;
+			break;
+		}
 		if (data[2] & CESTATUS_EXCEPT)
 			vprintk("element 0x%x: asc=0x%x, ascq=0x%x\n",
 				ch->firsts[type]+i,
-- 
1.7.0.4

