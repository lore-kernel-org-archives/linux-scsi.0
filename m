From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V2 11/15] aacraid: Skip IOP reset on controller panic(SMART Family)
Date: Thu, 16 Feb 2017 12:51:20 -0800
Message-ID: <20170216205124.20271-12-RaghavaAditya.Renukunta@microsemi.com>
References: <20170216205124.20271-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0080.outbound.protection.outlook.com ([104.47.38.80]:64128
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755356AbdBQD2T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 22:28:19 -0500
In-Reply-To: <20170216205124.20271-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de, dan.carpenter@oracle.com

When the SMART family of controller panic (KERNEL_PANIC) , they do not
honor IOP resets. So better to skip it and directly perform a IWBR reset.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Reviewed-by: David Carroll <David.Carroll@microsemi.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

---
Changes in V2:
Removed unnecessary brackets and fixed a spelling mistake

 drivers/scsi/aacraid/src.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index b23c818..9b11e1a 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -714,6 +714,12 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled, u8 reset_type)
 		pr_err("%s%d: adapter kernel panic'd %x.\n",
 				dev->name, dev->id, bled);
 
+	/*
+	 * When there is a BlinkLED, IOP_RESET has not effect
+	 */
+	if (bled >= 2 && dev->sa_firmware && reset_type & HW_IOP_RESET)
+		reset_type &= ~HW_IOP_RESET;
+
 	dev->a_ops.adapter_enable_int = aac_src_disable_interrupt;
 
 	switch (reset_type) {
-- 
2.7.4
