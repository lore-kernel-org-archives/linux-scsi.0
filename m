From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1] drivers/scsi/megaraid/megaraid_sas_base.c: replace kmalloc/copy_from_user by memdup_user
Date: Fri, 30 May 2014 18:56:06 +0200
Message-ID: <1401468966-10029-1-git-send-email-fabf@skynet.be>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:28228 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015AbaE3Q4C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 May 2014 12:56:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index d84d02c..e0330ca 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5639,14 +5639,9 @@ static int megasas_mgmt_ioctl_fw(struct file *file, unsigned long arg)
 	unsigned long flags;
 	u32 wait_time = MEGASAS_RESET_WAIT_TIME;
 
-	ioc = kmalloc(sizeof(*ioc), GFP_KERNEL);
-	if (!ioc)
-		return -ENOMEM;
-
-	if (copy_from_user(ioc, user_ioc, sizeof(*ioc))) {
-		error = -EFAULT;
-		goto out_kfree_ioc;
-	}
+	ioc = memdup_user(user_ioc, sizeof(*ioc));
+	if (IS_ERR(ioc))
+		return PTR_ERR(ioc);
 
 	instance = megasas_lookup_instance(ioc->host_no);
 	if (!instance) {
-- 
1.8.4.5

