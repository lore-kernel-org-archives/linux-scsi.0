From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 04/16] SCSI: ARM: make fas216_dumpinfo function conditional
Date: Fri,  5 Oct 2012 16:55:18 +0200
Message-ID: <1349448930-23976-5-git-send-email-arnd@arndb.de>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1349448930-23976-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org, Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The fas216_dumpinfo function is only used by __fas216_checkmagic,
which is conditionally compiled, so we should put both functions
inside of the same #ifdef.

Without this patch, building rpc_defconfig results in:

drivers/scsi/arm/fas216.c:182:13: warning: 'fas216_dumpinfo' defined but not used [-Wunused-function]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/arm/fas216.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 6206a66..737554c 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -179,6 +179,7 @@ static void print_SCp(struct scsi_pointer *SCp, const char *prefix, const char *
 		SCp->buffers_residual, suffix);
 }
 
+#ifdef CHECK_STRUCTURE
 static void fas216_dumpinfo(FAS216_Info *info)
 {
 	static int used = 0;
@@ -223,7 +224,6 @@ static void fas216_dumpinfo(FAS216_Info *info)
 		info->internal_done, info->magic_end);
 }
 
-#ifdef CHECK_STRUCTURE
 static void __fas216_checkmagic(FAS216_Info *info, const char *func)
 {
 	int corruption = 0;
-- 
1.7.10
