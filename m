From: "jack wang" <jack_wang@usish.com>
Subject: [PATCH 5/9] pm8001:fix potential NULL pointer dereference
Date: Mon, 7 Dec 2009 17:22:55 +0800
Message-ID: <D81A6649F91A4CF89FC9254CE8FA7CF9@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:53058 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759300AbZLGJWv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2009 04:22:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, 'Lindar Liu' <lindar_liu@usish.com>, 'Kevin Ao' <aoqingyun@usish.com>, 'jack wang' <jack_wang@usish.com>


Signed-off-by: Jack Wang <jack_wang@usish.com>
---
 drivers/scsi/pm8001/pm8001_sas.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c
b/drivers/scsi/pm8001/pm8001_sas.c
index 49721c8..487f78f 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -616,11 +616,11 @@ static int pm8001_dev_found_notify(struct
domain_device *dev)
 	spin_lock_irqsave(&pm8001_ha->lock, flags);
 
 	pm8001_device = pm8001_alloc_dev(pm8001_ha);
-	pm8001_device->sas_device = dev;
 	if (!pm8001_device) {
 		res = -1;
 		goto found_out;
 	}
+	pm8001_device->sas_device = dev;
 	dev->lldd_dev = pm8001_device;
 	pm8001_device->dev_type = dev->dev_type;
 	pm8001_device->dcompletion = &completion;
-- 
1.6.5.1.1367.gcd48


