From: "jack wang" <jack_wang@usish.com>
Subject: RE: [patch] pm8001: potential null dereference inpm8001_dev_gone_notify()
Date: Fri, 23 Apr 2010 20:16:25 +0800
Message-ID: <23094BDAA2D949B792874EAB2C42FB3D@usish.com.cn>
References: <20100423120104.GG29093@bicker>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:43344 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab0DWMQd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Apr 2010 08:16:33 -0400
In-Reply-To: <20100423120104.GG29093@bicker>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Dan Carpenter' <error27@gmail.com>
Cc: lindar_liu@usish.com, "'James E.J. Bottomley'" <James.Bottomley@suse.de>, 'Tom Peng' <tom_peng@usish.com>, 'Jiri Kosina' <jkosina@suse.cz>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org


In the original code we dereferenced "pm8001_dev" before checking if it 
was null.  This patch moves the dereference inside the condition.

This was found by a static checker (smatch).  I looked, but I couldn't 
tell if "pm8001_dev" dev was ever actually null.  The approach in this 
patch seemed like the safest response.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/pm8001/pm8001_sas.c
b/drivers/scsi/pm8001/pm8001_sas.c
index bff4f51..cd02cea 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -885,11 +885,13 @@ static void pm8001_dev_gone_notify(struct
domain_device *dev)
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


[Jack] Acked-by: Jack Wang <jack_wang@usish.com>
Thanks!

