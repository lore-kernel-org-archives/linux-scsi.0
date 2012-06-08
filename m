From: mathieu.poirier@linaro.org
Subject: [PATCH RESEND 5/7] scsi/atp870u: use mdelay instead of large udelay
Date: Fri,  8 Jun 2012 15:53:34 -0600
Message-ID: <1339192416-27026-6-git-send-email-mathieu.poirier@linaro.org>
References: <1339192416-27026-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1339192416-27026-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, linux-kernel@vger.kernel.org, arnd@arndb.de, mathieu.poirier@linaro.org
List-Id: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Some architectures like ARM cannot handle large numbers as
arguments to udelay, so the drivers should use mdelay when
delaying for multiple miliseconds.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/scsi/atp870u.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 68ce085..86ad079 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1173,7 +1173,7 @@ wait_io1:
 	outw(val, tmport);
 	outb(2, 0x80);
 TCM_SYNC:
-	udelay(0x800);
+	mdelay(2);
 	if ((inb(tmport) & 0x80) == 0x00) {	/* bsy ? */
 		outw(0, tmport--);
 		outb(0, tmport);
-- 
1.7.5.4
