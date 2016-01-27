From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/7] scsi: fas216: avoid fas216_log_setup for loadable module
Date: Wed, 27 Jan 2016 16:57:20 +0100
Message-ID: <1453910247-3447628-5-git-send-email-arnd@arndb.de>
References: <1453910247-3447628-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453910247-3447628-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, James.Bottomley@HansenPartnership.com
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@odin.com>, Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We get a warning for the fas216 driver when it is compiled as
a loadable module, as the __setup() functions are never called
then:

scsi/arm/fas216.c:101:19: warning: 'fas216_log_setup' defined but not used [-Wunused-function]
 static int __init fas216_log_setup(char *str)

This adds an #ifndef MODULE around the definition to shut up
the warning and clarify for the reader when it is used or not.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/arm/fas216.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index decdc71b6b86..24388795ee9a 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -98,6 +98,7 @@ static int level_mask = LOG_ERROR;
 
 module_param(level_mask, int, 0644);
 
+#ifndef MODULE
 static int __init fas216_log_setup(char *str)
 {
 	char *s;
@@ -138,6 +139,7 @@ static int __init fas216_log_setup(char *str)
 }
 
 __setup("fas216_logging=", fas216_log_setup);
+#endif
 
 static inline unsigned char fas216_readb(FAS216_Info *info, unsigned int reg)
 {
-- 
2.7.0
