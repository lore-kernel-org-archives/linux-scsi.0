From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix fusion Kconfig oddities
Date: Sat, 21 Feb 2004 20:34:59 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040221193459.GA10200@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:59556 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261610AbUBUTfZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Feb 2004 14:35:25 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Emoore@lsil.com
Cc: linux-scsi@vger.kernel.org

 - don't let FUSION depend on BLK_DEV_SD, no other LLDD does
 - remove option FUSION_BOOT
 - remove some overly verbose marketing blurb to make the help
   text more similar to others
 - remove dead comments


--- 1.3/drivers/message/fusion/Kconfig	Fri Sep 12 05:19:35 2003
+++ edited/drivers/message/fusion/Kconfig	Sat Feb 21 20:39:48 2004
@@ -3,7 +3,6 @@
 
 config FUSION
 	tristate "Fusion MPT (base + ScsiHost) drivers"
-	depends on BLK_DEV_SD
 	---help---
 	  LSI Logic Fusion(TM) Message Passing Technology (MPT) device support
 	  provides high performance SCSI host initiator, and LAN [1] interface
@@ -14,41 +13,6 @@
 
 	  [1] LAN is not supported on parallel SCSI medium.
 
-	  These drivers require a Fusion MPT compatible PCI adapter installed
-	  in the host system.  MPT adapters contain specialized I/O processors
-	  to handle I/O workload, and more importantly to offload this work
-	  from the host CPU(s).
-
-	  If you have Fusion MPT hardware and want to use it, you can say
-	  Y or M here to add MPT (base + ScsiHost) drivers.
-	  <Y> = build lib (fusion), and link [static] into the kernel [2]
-	  proper
-	  <M> = compiled as [dynamic] modules [3] named: (mptbase,
-	  mptscsih)
-
-	  [2] In order enable capability to boot the linux kernel
-	  natively from a Fusion MPT target device, you MUST
-	  answer Y here! (currently requires CONFIG_BLK_DEV_SD)
-	  [3] To compile this support as modules, choose M here.
-
-	  If unsure, say N.
-
-	  If you say Y or M here you will get a choice of these
-	  additional protocol and support module options:         Module Name:
-	  <M>   Enhanced SCSI error reporting                     (isense)
-	  <M>   Fusion MPT misc device (ioctl) driver             (mptctl)
-	  <M>   Fusion MPT LAN driver                             (mptlan)
-
-	  ---
-	  Fusion MPT is trademark of LSI Logic Corporation, and its
-	  architecture is based on LSI Logic's Message Passing Interface (MPI)
-	  specification.
-
-config FUSION_BOOT
-	bool
-	depends on FUSION=y
-	default y
-
 config FUSION_MAX_SGE
 	int "Maximum number of scatter gather entries"
 	depends on FUSION
@@ -62,7 +26,6 @@
 	  necessary (or recommended) unless the user will be running 
 	  large I/O's via the raw interface.
 
-#  How can we force these options to module or nothing?
 config FUSION_ISENSE
 	tristate "Enhanced SCSI error reporting"
 	depends on MODULES && FUSION && m
@@ -132,17 +95,4 @@
 
 	  If unsure whether you really want or need this, say N.
 
-	  NOTES: This feature is NOT available nor supported for linux-2.2.x
-	  kernels.  You must be building a linux-2.3.x or linux-2.4.x kernel
-	  in order to configure this option.
-	  Support for building this feature into the linux kernel is not
-	  yet available.
-
-#  if [ "$CONFIG_FUSION_LAN" != "n" ]; then
-#    define_bool CONFIG_NET_FC y
-#  fi
-# These <should> be define_tristate, but we leave them define_bool
-# for backward compatibility with pre-linux-2.2.15 kernels.
-# (Bugzilla:fibrebugs, #384)
 endmenu
-
