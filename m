From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 6/8] scsi-ml: Makefile and Kconfig changes for tgt
Date: Thu, 16 Nov 2006 19:24:18 +0900
Message-ID: <20061116192418F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:19842 "EHLO
	tama55.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1423660AbWKPKYU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Nov 2006 05:24:20 -0500
Received: from mfs34.rdh.ecl.ntt.co.jp (mfs34.rdh.ecl.ntt.co.jp [129.60.39.114])
	by tama55.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id kAGAOB1r008672
	for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2006 19:24:11 +0900 (JST)
Received: from mfs34.rdh.ecl.ntt.co.jp (localhost [127.0.0.1])
	by mfs34.rdh.ecl.ntt.co.jp (Postfix) with ESMTP id F27C920AE2A
	for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2006 19:24:10 +0900 (JST)
Received: from nttmail3.ecl.ntt.co.jp (nttmail3.ecl.ntt.co.jp [129.60.39.100])
	by mfs34.rdh.ecl.ntt.co.jp (Postfix) with ESMTP id BB07A20AE28
	for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2006 19:24:10 +0900 (JST)
Received: from dmailsv1.y.ecl.ntt.co.jp (dmailsv1.y.ecl.ntt.co.jp [129.60.53.14])
	by nttmail3.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id kAGAOARb013193
	for <linux-scsi@vger.kernel.org>; Thu, 16 Nov 2006 19:24:10 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Makefile and Kconfig for tgt.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
---
 drivers/scsi/Kconfig  |    7 +++++++
 drivers/scsi/Makefile |    3 +++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 9540eb8..7e25094 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -29,6 +29,13 @@ config SCSI
 	  However, do not compile this as a module if your root file system
 	  (the one containing the directory /) is located on a SCSI device.
 
+config SCSI_TGT
+	tristate "SCSI target support"
+	depends on SCSI && EXPERIMENTAL
+	---help---
+	  If you want to use SCSI target mode drivers enable this option.
+	  If you choose M, the module will be called scsi_tgt.
+
 config SCSI_NETLINK
 	bool
 	default	n
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index bcca39c..7b2e634 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -21,6 +21,7 @@ CFLAGS_seagate.o =   -DARBITRATE -DPARIT
 subdir-$(CONFIG_PCMCIA)		+= pcmcia
 
 obj-$(CONFIG_SCSI)		+= scsi_mod.o
+obj-$(CONFIG_SCSI_TGT)		+= scsi_tgt.o
 
 obj-$(CONFIG_RAID_ATTRS)	+= raid_class.o
 
@@ -149,6 +150,8 @@ scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
 
+scsi_tgt-y			+= scsi_tgt_lib.o scsi_tgt_if.o
+
 sd_mod-objs	:= sd.o
 sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
 ncr53c8xx-flags-$(CONFIG_SCSI_ZALON) \
-- 
1.4.3.2

