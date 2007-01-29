From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 11/14] qla2xxx: Allow NVRAM updates to immediately go into affect.
Date: Mon, 29 Jan 2007 10:22:28 -0800
Message-ID: <11700949512755-git-send-email-andrew.vasquez@qlogic.com>
References: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47719 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbXA2SWq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2007 13:22:46 -0500
In-Reply-To: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 834c404..8081b63 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -140,6 +140,8 @@ qla2x00_sysfs_write_nvram(struct kobject *kobj, char *buf, loff_t off,
 	ha->isp_ops.write_nvram(ha, (uint8_t *)buf, ha->nvram_base, count);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
+	set_bit(ISP_ABORT_NEEDED, &ha->dpc_flags);
+
 	return (count);
 }
 
-- 
1.5.0.rc2.gdbaa0

