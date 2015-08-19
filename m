From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: [PATCH 2/2] ipr: Enable SIS pipe commands for SIS-32 devices.
Date: Wed, 19 Aug 2015 11:47:06 -0300
Message-ID: <1439995626-16202-2-git-send-email-krisman@linux.vnet.ibm.com>
References: <1439995626-16202-1-git-send-email-krisman@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:51363 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbbHSOrb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Aug 2015 10:47:31 -0400
Received: from /spool/local
	by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <krisman@linux.vnet.ibm.com>;
	Wed, 19 Aug 2015 11:47:27 -0300
Received: from d24relay03.br.ibm.com (d24relay03.br.ibm.com [9.13.184.25])
	by d24dlp02.br.ibm.com (Postfix) with ESMTP id 7EB8E1DC006F
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2015 10:46:23 -0400 (EDT)
Received: from d24av04.br.ibm.com (d24av04.br.ibm.com [9.8.31.97])
	by d24relay03.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7JEjsWL5833014
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2015 11:45:54 -0300
Received: from d24av04.br.ibm.com (localhost [127.0.0.1])
	by d24av04.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7JElO5e021342
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2015 11:47:24 -0300
In-Reply-To: <1439995626-16202-1-git-send-email-krisman@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>

Remove unnecessary check that disabled SIS pipe commands for SIS-32
devices.  This change was sufficient to enable raw mode and send SIS
pipe commands for a 57B3 device.

Fixes: f8ee25d7d239 ("ipr: AF DASD raw mode implementation in ipr driver")
Signed-off-by: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
---
 drivers/scsi/ipr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index db0c2cf..b19719f 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4554,7 +4554,7 @@ static ssize_t ipr_store_raw_mode(struct device *dev,
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	res = (struct ipr_resource_entry *)sdev->hostdata;
 	if (res) {
-		if (ioa_cfg->sis64 && ipr_is_af_dasd_device(res)) {
+		if (ipr_is_af_dasd_device(res)) {
 			res->raw_mode = simple_strtoul(buf, NULL, 10);
 			len = strlen(buf);
 			if (res->sdev)
-- 
2.1.0

