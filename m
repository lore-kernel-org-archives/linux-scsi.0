From: Zhouyang Jia <jiazhouyang09@gmail.com>
Subject: [PATCH] scsi: gdth: add error handling for register_chrdev
Date: Mon, 11 Jun 2018 16:35:48 +0800
Message-ID: <1528706148-35044-1-git-send-email-jiazhouyang09@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Zhouyang Jia <jiazhouyang09@gmail.com>, Achim Leubner <achim_leubner@adaptec.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When register_chrdev fails, the lack of error-handling code may
cause unexpected results.

This patch adds error-handling code after calling register_chrdev.

Signed-off-by: Zhouyang Jia <jiazhouyang09@gmail.com>
---
 drivers/scsi/gdth.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 8560479..d5a2af8 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -5198,6 +5198,11 @@ static int __init gdth_init(void)
 	TRACE2(("gdth_detect() %d controller detected\n", gdth_ctr_count));
 
 	major = register_chrdev(0,"gdth", &gdth_fops);
+	if (major < 0) {
+		printk("GDT-HA: Unable to register char device gdth.\n");
+		return major;
+	}
+
 	register_reboot_notifier(&gdth_notifier);
 	gdth_polling = FALSE;
 	return 0;
-- 
2.7.4
