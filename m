From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: ufs: select CONFIG_NLS
Date: Thu, 17 Mar 2016 13:29:52 +0100
Message-ID: <1458217819-2802119-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Yaniv Gardi <ygardi@codeaurora.org>, Stephen Boyd <sboyd@codeaurora.org>, James Bottomley <JBottomley@Odin.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

A recent change to ufshcd introduced a call to utf16s_to_utf8s,
a function that is provided by the NLS module, so we get a link
error when that is not present:

drivers/scsi/built-in.o: In function `ufshcd_read_string_desc':
:(.text+0x124d0): undefined reference to `utf16s_to_utf8s'

This adds a Kconfig 'select' statement to avoid the build error.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: b573d484e4ff ("scsi: ufs: add support to read device and string descriptors")
---
 drivers/scsi/ufs/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 5f4530744e0a..097894a1fab5 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -37,6 +37,7 @@ config SCSI_UFSHCD
 	depends on SCSI && SCSI_DMA
 	select PM_DEVFREQ
 	select DEVFREQ_GOV_SIMPLE_ONDEMAND
+	select NLS
 	---help---
 	This selects the support for UFS devices in Linux, say Y and make
 	  sure that you know the name of your UFS host adapter (the card
-- 
2.7.0
