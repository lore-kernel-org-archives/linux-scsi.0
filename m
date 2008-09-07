From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] fix scsi_netlink compile warning
Date: Mon, 8 Sep 2008 02:07:12 +0900
Message-ID: <20080908020631Y.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:35102 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbYIGRH1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Sep 2008 13:07:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

drivers/scsi/scsi_netlink.c: In function 'scsi_nl_remove_driver':
drivers/scsi/scsi_netlink.c:475: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'u64'

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_netlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_netlink.c b/drivers/scsi/scsi_netlink.c
index 4651f2d..b37e133 100644
--- a/drivers/scsi/scsi_netlink.c
+++ b/drivers/scsi/scsi_netlink.c
@@ -472,7 +472,7 @@ scsi_nl_remove_driver(u64 vendor_id)
 	spin_unlock_irqrestore(&scsi_nl_lock, flags);
 
 	printk(KERN_ERR "%s: removal of driver failed - vendor_id 0x%llx\n",
-				__func__, vendor_id);
+	       __func__, (unsigned long long)vendor_id);
 	return;
 }
 EXPORT_SYMBOL_GPL(scsi_nl_remove_driver);
-- 
1.5.4.2

