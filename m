From: Dan Carpenter <error27@gmail.com>
Subject: [patch] pm8001: potential null dereference in
	pm8001_dev_gone_notify()
Date: Fri, 23 Apr 2010 14:01:04 +0200
Message-ID: <20100423120104.GG29093@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34180 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757300Ab0DWMBP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Apr 2010 08:01:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jack_wang@usish.com
Cc: lindar_liu@usish.com, "James E.J. Bottomley" <James.Bottomley@suse.de>, Tom Peng <tom_peng@usish.com>, Jiri Kosina <jkosina@suse.cz>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

In the original code we dereferenced "pm8001_dev" before checking if it 
was null.  This patch moves the dereference inside the condition.

This was found by a static checker (smatch).  I looked, but I couldn't 
tell if "pm8001_dev" dev was ever actually null.  The approach in this 
patch seemed like the safest response.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index bff4f51..cd02cea 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -885,11 +885,13 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 	u32 tag;
 	struct pm8001_hba_info *pm8001_ha;
 	struct pm8001_device *pm8001_dev = dev->lldd_dev;
-	u32 device_id = pm8001_dev->device_id;
+
 	pm8001_ha = pm8001_find_ha_by_dev(dev);
 	spin_lock_irqsave(&pm8001_ha->lock, flags);
 	pm8001_tag_alloc(pm8001_ha, &tag);
 	if (pm8001_dev) {
+		u32 device_id = pm8001_dev->device_id;
+
 		PM8001_DISC_DBG(pm8001_ha,
 			pm8001_printk("found dev[%d:%x] is gone.\n",
 			pm8001_dev->device_id, pm8001_dev->dev_type));
