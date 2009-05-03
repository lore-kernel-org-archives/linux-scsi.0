From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
Subject: [PATCH] set CONFIG_SCSI_MULTI_LUN by default and update help
Date: Sun, 03 May 2009 15:57:30 +0200
Message-ID: <49FDA2CA.4040601@tremplin-utc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailservice.tudelft.nl ([130.161.131.5]:21174 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbZECN6P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2009 09:58:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>

Hello, 

Here is a patch against 2.6.30-rc4, but probably material for 2.6.31,
which should avoid a couple of people to have the same problem as me.

Eric
==

I had to set CONFIG_SCSI_MULTI_LUN to y in order to get my SE W595
working when plugging it as a mass storage. Looking at SCSI option to
get a phone behaving correctly was convoluted to say the
least. There are quite a few other reports about USB card readers
needing this option as well.

This patch improves the help text to make the use of the option more
obvious and also defaults it to Y. I couldn't find any explicit reports
of devices not working because of multiple LUNs probing, but only
reports of people would had heard of such reports. In addition, every
mainstream distro have this option activated, so it should definitely
not be too dangerous.

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
---
 drivers/scsi/Kconfig |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 8ed2990..1aa1d7d 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -191,20 +191,18 @@ config SCSI_ENCLOSURE
 	  it has an enclosure device.  Selecting this option will just allow
 	  certain enclosure conditions to be reported and is not required.
 
-comment "Some SCSI devices (e.g. CD jukebox) support multiple LUNs"
-	depends on SCSI
-
 config SCSI_MULTI_LUN
 	bool "Probe all LUNs on each SCSI device"
 	depends on SCSI
+	default y
 	help
-	  If you have a SCSI device that supports more than one LUN (Logical
-	  Unit Number), e.g. a CD jukebox, and only one LUN is detected, you
-	  can say Y here to force the SCSI driver to probe for multiple LUNs.
-	  A SCSI device with multiple LUNs acts logically like multiple SCSI
-	  devices. The vast majority of SCSI devices have only one LUN, and
-	  so most people can say N here. The max_luns boot/module parameter 
-	  allows to override this setting.
+	  Some devices support more than one LUN (Logical Unit Number) in order
+	  to allow access to several media, e.g. CD jukebox, USB card reader,
+	  mobile phone in mass storage mode. This option forces the kernel to
+	  probe for all LUNs by default. This setting can be overriden by
+	  max_luns boot/module parameter. You want to say Y here unless you
+	  have one of those rare devices which reacts in an unexpected way when
+	  probed for multiple LUNs.
 
 config SCSI_CONSTANTS
 	bool "Verbose SCSI error reporting (kernel size +=12K)"
-- 
1.6.2.4


