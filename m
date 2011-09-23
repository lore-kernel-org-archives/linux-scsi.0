From: Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] scsi: SCSI_ISCI needs to select SCSI_SAS_HOST_SMP, fixes
 build error
Date: Fri, 23 Sep 2011 15:43:54 -0700
Message-ID: <4E7D0BAA.3080900@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:46604 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751583Ab1IWWn4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2011 18:43:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: JBottomley@parallels.com, Andrew Morton <akpm@linux-foundation.org>, intel-linux-scu@intel.com, Linus Torvalds <torvalds@linux-foundation.org>

From: Randy Dunlap <rdunlap@xenotime.net>

SCSI_ISCI needs to select SCSI_SAS_HOST_SMP to ensure that all
needed symbols are available to it.

Fixes this build error:
ERROR: "try_test_sas_gpio_gp_bit" [drivers/scsi/isci/isci.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/scsi/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Found in linux-next, but also applies to mainline.

--- next-2011-0923.orig/drivers/scsi/Kconfig
+++ next-2011-0923/drivers/scsi/Kconfig
@@ -847,6 +847,7 @@ config SCSI_ISCI
 	# (temporary): known alpha quality driver
 	depends on EXPERIMENTAL
 	select SCSI_SAS_LIBSAS
+	select SCSI_SAS_HOST_SMP
 	---help---
 	  This driver supports the 6Gb/s SAS capabilities of the storage
 	  control unit found in the Intel(R) C600 series chipset.
