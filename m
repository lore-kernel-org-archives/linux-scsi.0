From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: [PATCH] ipr: Fix regression when loading firmware
Date: Thu, 25 Feb 2016 13:54:20 -0300
Message-ID: <1456419260-14916-1-git-send-email-krisman@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:38715 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760708AbcBYQyd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2016 11:54:33 -0500
Received: from localhost
	by e24smtp03.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
	Thu, 25 Feb 2016 13:54:31 -0300
Received: from d24relay02.br.ibm.com (d24relay02.br.ibm.com [9.13.184.26])
	by d24dlp01.br.ibm.com (Postfix) with ESMTP id 5C749352006E
	for <linux-scsi@vger.kernel.org>; Thu, 25 Feb 2016 11:54:20 -0500 (EST)
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.8.31.91])
	by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u1PFsjQt60096732
	for <linux-scsi@vger.kernel.org>; Thu, 25 Feb 2016 12:54:45 -0300
Received: from d24av01.br.ibm.com (localhost [127.0.0.1])
	by d24av01.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u1PGsSFS003296
	for <linux-scsi@vger.kernel.org>; Thu, 25 Feb 2016 13:54:28 -0300
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>, Insu Yun <wuninsu@gmail.com>

Commit d63c7dd5bcb9 ("ipr: Fix out-of-bounds null overwrite") removed the
end of line handling when storing the update_fw sysfs attribute.  This
changed the userpace API because it started refusing writes terminated
by a line feed, which broke the update tools we already have.

This patch re-adds that handling, so both a write terminated by a line
feed or not can make it through with the update.

Fixes: d63c7dd5bcb9 ("ipr: Fix out-of-bounds null overwrite")
Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: Insu Yun <wuninsu@gmail.com>
---
 drivers/scsi/ipr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 3b3e099..d6a691e 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4002,6 +4002,7 @@ static ssize_t ipr_store_update_fw(struct device *dev,
 	struct ipr_sglist *sglist;
 	char fname[100];
 	char *src;
+	char *endline;
 	int result, dnld_size;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -4009,6 +4010,10 @@ static ssize_t ipr_store_update_fw(struct device *dev,
 
 	snprintf(fname, sizeof(fname), "%s", buf);
 
+	endline = strchr(fname, '\n');
+	if (endline)
+		*endline = '\0';
+
 	if (request_firmware(&fw_entry, fname, &ioa_cfg->pdev->dev)) {
 		dev_err(&ioa_cfg->pdev->dev, "Firmware file %s not found\n", fname);
 		return -EIO;
-- 
2.1.0

