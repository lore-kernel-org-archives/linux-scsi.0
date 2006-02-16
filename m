From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 6/6] scsi tgt: Makefile and Kconfig changes
Date: Thu, 16 Feb 2006 13:53:47 -0600
Message-ID: <1140119627.20193.55.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50336 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1030631AbWBPTy1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2006 14:54:27 -0500
Received: from [192.168.0.3] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id k1GJsQ3R019509
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 16 Feb 2006 13:54:27 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Subject: [PATCH] scsi-ml: Makefile and Kconfig changes for stgt


Makefile and Kconfig stuff.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>


---

 drivers/scsi/Kconfig  |    7 +++++++
 drivers/scsi/Makefile |    3 +++
 2 files changed, 10 insertions(+), 0 deletions(-)

22ae7de0990701d140759af4a9b7070bf4409414
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 3c606cf..d09c792 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -27,6 +27,13 @@ config SCSI
 	  However, do not compile this as a module if your root file system
 	  (the one containing the directory /) is located on a SCSI device.
 
+config SCSI_TGT
+	tristate "SCSI target support"
+	depends on SCSI && EXPERIMENTAL
+	---help---
+	  If you want to use SCSI target mode drivers enable this option.
+	  If you choose M, the module will be called scsi_tgt.
+
 config SCSI_PROC_FS
 	bool "legacy /proc/scsi/ support"
 	depends on SCSI && PROC_FS
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 320e765..3d81b8d 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -21,6 +21,7 @@ CFLAGS_seagate.o =   -DARBITRATE -DPARIT
 subdir-$(CONFIG_PCMCIA)		+= pcmcia
 
 obj-$(CONFIG_SCSI)		+= scsi_mod.o
+obj-$(CONFIG_SCSI_TGT)		+= scsi_tgt.o
 
 obj-$(CONFIG_RAID_ATTRS)	+= raid_class.o
 
@@ -155,6 +156,8 @@ scsi_mod-y			+= scsi.o hosts.o scsi_ioct
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
 
+scsi_tgt-y			+= scsi_tgt_lib.o scsi_tgt_if.o
+
 sd_mod-objs	:= sd.o
 sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
 ncr53c8xx-flags-$(CONFIG_SCSI_ZALON) \
-- 
1.1.3


