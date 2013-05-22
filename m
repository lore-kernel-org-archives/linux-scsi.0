From: Marc Dietrich <marvin24@gmx.de>
Subject: [PATCH 1/2] SCSI: nsp32: replace large udelay by mdelay
Date: Wed, 22 May 2013 21:48:41 +0200
Message-ID: <495d02a8263a553dd3f67b354f5ec9beb784a5d3.1369251478.git.marvin24@gmx.de>
References: <cover.1369251478.git.marvin24@gmx.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1369251478.git.marvin24@gmx.de>
In-Reply-To: <cover.1369251478.git.marvin24@gmx.de>
References: <cover.1369251478.git.marvin24@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: GOTO Masanori <gotom@debian.or.jp>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

ARM has a maximum of 2000 usec delay. Use mdelay for larger delays.
This affects distro kernels mostly.

Cc: GOTO Masanori <gotom@debian.or.jp>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Marc Dietrich <marvin24@gmx.de>
---
 drivers/scsi/nsp32.c |    2 +-
 drivers/scsi/nsp32.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 1e3879d..e2f796f 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -2899,7 +2899,7 @@ static void nsp32_do_bus_reset(nsp32_hw_data *data)
 	 * reset SCSI bus
 	 */
 	nsp32_write1(base, SCSI_BUS_CONTROL, BUSCTL_RST);
-	udelay(RESET_HOLD_TIME);
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
1.7.9.5
