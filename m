From: Nick Warne <nick@ukfsn.org>
Subject: Fw: scsi_wait_scan Kconfig option
Date: Fri, 7 Dec 2007 19:39:53 +0000
Message-ID: <20071207193953.0c544044@linuxamd.linicks.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/Zgvza4JfVWrY=9hKodox5pX"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from s2.ukfsn.org ([217.158.120.143]:45376 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757198AbXLGTkA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2007 14:40:00 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.ukfsn.org (Postfix) with ESMTP id 9A0C9DEC9E
	for <linux-scsi@vger.kernel.org>; Fri,  7 Dec 2007 19:40:55 +0000 (GMT)
Received: from mail.ukfsn.org ([127.0.0.1])
	by localhost (smtp-filter.ukfsn.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Q-2Ai3v6uXvu for <linux-scsi@vger.kernel.org>;
	Fri,  7 Dec 2007 19:40:55 +0000 (GMT)
Received: from linuxamd.linicks.net (unknown [87.127.191.50])
	by mail.ukfsn.org (Postfix) with ESMTP id B610ADF417
	for <linux-scsi@vger.kernel.org>; Fri,  7 Dec 2007 19:40:54 +0000 (GMT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--MP_/Zgvza4JfVWrY=9hKodox5pX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


Hi all,

Please see below.

Nick

Begin forwarded message:

Date: Fri, 7 Dec 2007 19:12:42 +0000
From: Nick Warne <nick@ukfsn.org>
To: linux-kernel@vger.kernel.org
Subject: scsi_wait_scan Kconfig option



Hi all,

I am bringing this up again - primarily as I forgot about it after
patching my build tree ages ago:

http://lkml.org/lkml/2007/10/27/68

Today I built and installed git for the first time and cloned Linus'
tree (very trick!).

I try not to build a modular kernel, but only have modules ON due to
nVidia (sigh).  So I was semi-surprised when I saw the scsi_wait_scan
module being built again, yet NO WHERE in menuconfig is it present to
turn OFF.  Even if I hand edit .config, make puts it back again...


.config
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set
CONFIG_SCSI_WAIT_SCAN=m



I have attached my patch again :-)

Nick
-- 
Free Software Foundation Associate Member 5508

-- 
Free Software Foundation Associate Member 5508
--MP_/Zgvza4JfVWrY=9hKodox5pX
Content-Type: text/x-patch; name=scsi_wait.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=scsi_wait.patch

--- linux-current/drivers/scsi/Kconfig_old	2007-10-20 12:44:50.000000000 +0100
+++ linux-current/drivers/scsi/Kconfig	2007-10-20 12:57:13.000000000 +0100
@@ -248,10 +248,17 @@
 	  or async on the kernel's command line.
 
 config SCSI_WAIT_SCAN
-	tristate
+	tristate "Wait for SCSI scan completion"
 	default m
 	depends on SCSI
 	depends on MODULES
+	help
+	  The SCSI subsystem can probe for devices while the rest of the
+	  system continues booting, and even probe devices on different
+	  busses in parallel, leading to a significant speed-up.
+
+	  You can load the scsi_wait_scan module to ensure that all scans
+	  have completed.
 
 menu "SCSI Transports"
 	depends on SCSI

--MP_/Zgvza4JfVWrY=9hKodox5pX--
