From: Girish K S <girish.shivananjappa@linaro.org>
Subject: [RFC RESEND 4/4] SCSI: UFS: Added support of PCI/PLTFM for UFS
Date: Tue, 15 May 2012 15:06:27 +0530
Message-ID: <1337074587-29021-5-git-send-email-girish.shivananjappa@linaro.org>
References: <1337074587-29021-1-git-send-email-girish.shivananjappa@linaro.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55186 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab2EOJho (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2012 05:37:44 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so7292170pbb.19
        for <linux-scsi@vger.kernel.org>; Tue, 15 May 2012 02:37:43 -0700 (PDT)
In-Reply-To: <1337074587-29021-1-git-send-email-girish.shivananjappa@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, vinholikatti@gmail.com, santoshsy@gmail.com, patches@linaro.org, Girish K S <girish.shivananjappa@linaro.org>

This patch modifies the Kconfig and the Makefile to
add support for PCI and Platform config options to the
UFS core driver. If the device is attached to the core
throught pci,then PCI option has to be selected in the
menuconfig. For more information read the help section
of Kconfig file.

Signed-off-by: Girish K S <girish.shivananjappa@linaro.org>
---
 drivers/scsi/ufs/Kconfig  |   32 +++++++++++++++++++++++++++++---
 drivers/scsi/ufs/Makefile |    2 ++
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 8f27f9d..70f3a71 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -44,6 +44,32 @@
 
 config SCSI_UFSHCD
 	tristate "Universal Flash Storage host controller driver"
-	depends on PCI && SCSI
-	---help---
-	This is a generic driver which supports PCIe UFS Host controllers.
+	depends on SCSI
+	help
+	This is a generic driver which supports UFS Host controllers.
+	This option is selected automatically if the SCSI option is
+	selected. This is a core ufs driver.
+
+config SCSI_UFSHCD_PCI
+	tristate "Universal Flash Storage host support on PCI bus"
+	depends on SCSI_UFSHCD && PCI
+	help
+	  This selects the PCI bus for the Universal Flash Storage IP.
+	  Select this option if the IP is present on PCI platform.
+
+	  If you have a controller with this interface, say Y or M here.
+
+	  If unsure, say N.
+
+config SCSI_UFSHCD_PLTFM
+	tristate "Universal Flash Storage host support as platform device"
+	depends on SCSI_UFSHCD
+	help
+	  This selects the common helper functions support for Host Controller
+	  Interface based platform driver. Please select this option if the IP
+	  is present as a platform device. This is the common interface for the
+	  UFS Host Controller IP.
+
+	  If you have a controller with this interface, say Y or M here.
+
+	  If unsure, say N.
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index adf7895..fc56471 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -1,2 +1,4 @@
 # UFSHCD makefile
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
+obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
+obj-$(CONFIG_SCSI_UFSHCD_PLTFM) += ufshcd-pltfm.o
-- 
1.7.4.1

