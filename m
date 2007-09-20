From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 11/19] qla2xxx: Use the correct pointer-address during NVRAM writes.
Date: Thu, 20 Sep 2007 14:07:42 -0700
Message-ID: <1190322470-15543-11-git-send-email-andrew.vasquez@qlogic.com>
References: <20070920210422.GE8456@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:11180 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbXITVH5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 17:07:57 -0400
In-Reply-To: <20070920210422.GE8456@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Original code, incorrectly passed the address-of a pointer rather
than the pointer value itself.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 8e7e00c..445d583 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -146,7 +146,7 @@ qla2x00_sysfs_write_nvram(struct kobject *kobj,
 	/* Write NVRAM. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	ha->isp_ops->write_nvram(ha, (uint8_t *)buf, ha->nvram_base, count);
-	ha->isp_ops->read_nvram(ha, (uint8_t *)&ha->nvram, ha->nvram_base,
+	ha->isp_ops->read_nvram(ha, (uint8_t *)ha->nvram, ha->nvram_base,
 	    count);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-- 
1.5.3.2.80.g077d6f

