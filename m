From: Marc Gonzalez <marc.w.gonzalez@free.fr>
Subject: [PATCH v5 2/2] scsi: ufs: Remove unused device quirks
Date: Mon, 11 Feb 2019 14:33:28 +0100
Message-ID: <43265449-30e1-d514-3ffd-fc38530dac67@free.fr>
References: <494cd639-89a7-8868-b63a-ea7cdcba9777@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <494cd639-89a7-8868-b63a-ea7cdcba9777@free.fr>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Jeffrey Hugo <jhugo@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Joao Pinto <jpinto@synopsys.com>, Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>, Bart Van Assche <bart.vanassche@wdc.com>, Stanislav Nijnikov <stanislav.nijnikov@wdc.com>, Alex Lemberg <alex.lemberg@wdc.com>, Ohad Sharabi <ohad.sharabi@wdc.com>, Venkat Gopalakrishnan <venkatg@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

The UFSHC driver defines a few quirks that are not used anywhere:

UFS_DEVICE_QUIRK_BROKEN_LCC
UFS_DEVICE_NO_VCCQ
UFS_DEVICE_QUIRK_NO_LINK_OFF
UFS_DEVICE_NO_FASTAUTO

Let's remove them.

Signed-off-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
---
 drivers/scsi/ufs/ufs_quirks.h | 29 -----------------------------
 drivers/scsi/ufs/ufshcd.c     |  4 ----
 2 files changed, 33 deletions(-)

diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.h
index 5d2dfdb41a6f..a9bbd34d6b16 100644
--- a/drivers/scsi/ufs/ufs_quirks.h
+++ b/drivers/scsi/ufs/ufs_quirks.h
@@ -44,21 +44,6 @@ struct ufs_dev_fix {
 	.quirk = (_quirk),		   \
 }
 
-/*
- * If UFS device is having issue in processing LCC (Line Control
- * Command) coming from UFS host controller then enable this quirk.
- * When this quirk is enabled, host controller driver should disable
- * the LCC transmission on UFS host controller (by clearing
- * TX_LCC_ENABLE attribute of host to 0).
- */
-#define UFS_DEVICE_QUIRK_BROKEN_LCC (1 << 0)
-
-/*
- * Some UFS devices don't need VCCQ rail for device operations. Enabling this
- * quirk for such devices will make sure that VCCQ rail is not voted.
- */
-#define UFS_DEVICE_NO_VCCQ (1 << 1)
-
 /*
  * Some vendor's UFS device sends back to back NACs for the DL data frames
  * causing the host controller to raise the DFES error status. Sometimes
@@ -84,13 +69,6 @@ struct ufs_dev_fix {
  */
 #define UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS (1 << 2)
 
-/*
- * Some UFS devices may not work properly after resume if the link was kept
- * in off state during suspend. Enabling this quirk will not allow the
- * link to be kept in off state during suspend.
- */
-#define UFS_DEVICE_QUIRK_NO_LINK_OFF	(1 << 3)
-
 /*
  * Few Toshiba UFS device models advertise RX_MIN_ACTIVATETIME_CAPABILITY as
  * 600us which may not be enough for reliable hibern8 exit hardware sequence
@@ -100,13 +78,6 @@ struct ufs_dev_fix {
  */
 #define UFS_DEVICE_QUIRK_PA_TACTIVATE	(1 << 4)
 
-/*
- * Some UFS memory devices may have really low read/write throughput in
- * FAST AUTO mode, enable this quirk to make sure that FAST AUTO mode is
- * never enabled for such devices.
- */
-#define UFS_DEVICE_NO_FASTAUTO		(1 << 5)
-
 /*
  * It seems some UFS devices may keep drawing more than sleep current
  * (atleast for 500us) from UFS rails (especially from VCCQ rail).
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a5bfcf04fdba..54ed1f8db1bf 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -219,11 +219,8 @@ static struct ufs_dev_fix ufs_fixups[] = {
 	/* UFS cards deviations table */
 	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
 		UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM),
-	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL, UFS_DEVICE_NO_VCCQ),
 	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
 		UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS),
-	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
-		UFS_DEVICE_NO_FASTAUTO),
 	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
 		UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE),
 	UFS_FIX(UFS_VENDOR_TOSHIBA, UFS_ANY_MODEL,
@@ -232,7 +229,6 @@ static struct ufs_dev_fix ufs_fixups[] = {
 		UFS_DEVICE_QUIRK_PA_TACTIVATE),
 	UFS_FIX(UFS_VENDOR_TOSHIBA, "THGLF2G9D8KBADG",
 		UFS_DEVICE_QUIRK_PA_TACTIVATE),
-	UFS_FIX(UFS_VENDOR_SKHYNIX, UFS_ANY_MODEL, UFS_DEVICE_NO_VCCQ),
 	UFS_FIX(UFS_VENDOR_SKHYNIX, UFS_ANY_MODEL,
 		UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME),
 	UFS_FIX(UFS_VENDOR_SKHYNIX, "hB8aL1" /*H28U62301AMR*/,
-- 
2.17.1
