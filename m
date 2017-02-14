From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 12/16] aacraid: Skip IOP reset on controller panic(SMART Family)
Date: Tue, 14 Feb 2017 12:44:42 -0800
Message-ID: <20170214204446.14808-13-RaghavaAditya.Renukunta@microsemi.com>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0072.outbound.protection.outlook.com ([104.47.41.72]:39804
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751717AbdBODWl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Feb 2017 22:22:41 -0500
In-Reply-To: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de, dan.carpenter@oracle.com

When the SMART family of controller panic (KERNEL_PANIC) , they do not
honor IOP resets. So better to skip it and directly perform a IWBR reset.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Reviewed-by: David Carroll <David.Carroll@microsemi.com>
---
 drivers/scsi/aacraid/src.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index b23c818..5bb9865 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -714,6 +714,12 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled, u8 reset_type)
 		pr_err("%s%d: adapter kernel panic'd %x.\n",
 				dev->name, dev->id, bled);
 
+	/*
+	 * WHen there is a BlinkLED, IOP_RESET has not effect
+	 */
+	if (bled >= 2 && dev->sa_firmware && (reset_type & HW_IOP_RESET))
+		reset_type &= ~HW_IOP_RESET;
+
 	dev->a_ops.adapter_enable_int = aac_src_disable_interrupt;
 
 	switch (reset_type) {
-- 
2.7.4
