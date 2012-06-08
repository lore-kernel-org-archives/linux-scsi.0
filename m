From: mathieu.poirier@linaro.org
Subject: [PATCH RESEND 2/7] scsi/nsp32: don't pass large values into udelay
Date: Fri,  8 Jun 2012 15:53:31 -0600
Message-ID: <1339192416-27026-3-git-send-email-mathieu.poirier@linaro.org>
References: <1339192416-27026-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1339192416-27026-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, linux-kernel@vger.kernel.org, arnd@arndb.de, mathieu.poirier@linaro.org
List-Id: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This results in __bad_udelay warnings on some architectures.
Found on ARM randconfig builds.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/scsi/nsp32.c |    3 ++-
 drivers/scsi/nsp32.h |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 62b6168..cc36543 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -2926,7 +2926,8 @@ static void nsp32_do_bus_reset(nsp32_hw_data *data)
 	 * reset SCSI bus
 	 */
 	nsp32_write1(base, SCSI_BUS_CONTROL, BUSCTL_RST);
-	udelay(RESET_HOLD_TIME);
+	/* FIXME: we should not run with IRQs disabled for 10ms here */
+	mdelay(RESET_HOLD_TIME);
 	nsp32_write1(base, SCSI_BUS_CONTROL, 0);
 	for(i = 0; i < 5; i++) {
 		intrdat = nsp32_read2(base, IRQ_STATUS); /* dummy read */
diff --git a/drivers/scsi/nsp32.h b/drivers/scsi/nsp32.h
index c022182..b2b3dc6 100644
--- a/drivers/scsi/nsp32.h
+++ b/drivers/scsi/nsp32.h
@@ -605,7 +605,7 @@ typedef struct _nsp32_hw_data {
 /*
  * TIME definition
  */
-#define RESET_HOLD_TIME		10000	/* reset time in us (SCSI-2 says the
+#define RESET_HOLD_TIME		10	/* reset time in ms (SCSI-2 says the
 					   minimum is 25us) */
 #define SEL_TIMEOUT_TIME	10000	/* 250ms defined in SCSI specification
 					   (25.6us/1unit) */
-- 
1.7.5.4
