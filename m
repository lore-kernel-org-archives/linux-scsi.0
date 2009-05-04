From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
Subject: [PATCH] Update wording of CONFIG_SCSI_MULTI_LUN help
Date: Mon, 04 May 2009 12:43:02 +0200
Message-ID: <49FEC6B6.50809@tremplin-utc.net>
References: <49FDA2CA.4040601@tremplin-utc.net> <1241362635.5596.34.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailservice.tudelft.nl ([130.161.131.5]:13140 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbZEDKnR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2009 06:43:17 -0400
In-Reply-To: <1241362635.5596.34.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, matthew@wil.cx, Matthew Dharm <mdharm-usb@one-eyed-alien.net>

Hello,
This is an updated version of the previous patch. It now leaves the
default option value to N, and a note explaining that SCSI-3+ devices
are not affected was added.

As it only makes the options more understandable without changing the
behaviour, it could be considered for 2.6.30, but I let you decide :-)

Eric

==
I had to set CONFIG_SCSI_MULTI_LUN to y in order to get my SE W595
working when plugging it as a mass storage. Looking at SCSI option to
get a phone behaving correctly was convoluted to say the least. There
are quite a few other reports about USB card readers needing this option
as well. This patch improves the help text to make the use of the option
more obvious.

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
---
 drivers/scsi/Kconfig |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 8ed2990..06bd7e3 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -191,20 +191,19 @@ config SCSI_ENCLOSURE
 	  it has an enclosure device.  Selecting this option will just allow
 	  certain enclosure conditions to be reported and is not required.
 
-comment "Some SCSI devices (e.g. CD jukebox) support multiple LUNs"
-	depends on SCSI
-
 config SCSI_MULTI_LUN
 	bool "Probe all LUNs on each SCSI device"
 	depends on SCSI
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
+	  max_luns boot/module parameter. Note that this option does not affect
+	  devices conforming to SCSI-3 or higher as they can explicitely report
+	  their number of LUNs. It is safe to say Y here unless you have one of
+	  those rare devices which reacts in an unexpected way when probed for
+	  multiple LUNs.
 
 config SCSI_CONSTANTS
 	bool "Verbose SCSI error reporting (kernel size +=12K)"
-- 
1.6.2.4

