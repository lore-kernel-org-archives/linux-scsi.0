From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Mark i2o config broken on 64-bit platforms.
Date: Wed, 09 Jul 2008 12:35:47 +0100
Message-ID: <20080709113547.19235.15424.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757256AbYGILh3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2008 07:37:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: alan@redhat.com, Markus.Lidel@shadowconnect.com, vvs@sw.ru, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Mark i2o config broken on 64-bit platforms as it generates these:

In file included from drivers/message/i2o/config-osm.c:39:
drivers/message/i2o/i2o_config.c: In function 'i2o_cfg_passthru':
drivers/message/i2o/i2o_config.c:889: warning: cast to pointer from integer of different size
drivers/message/i2o/i2o_config.c:945: warning: cast to pointer from integer of different size

which are apparently non-trivial to fix (eg: inserting a cast through unsigned
long is not correct according to Linus).  This would be due to struct
sg_simple_element only having a 32-bit addr_bus value.

There are also a number of "TODO 64bit fix" comments.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/message/i2o/Kconfig |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)


diff --git a/drivers/message/i2o/Kconfig b/drivers/message/i2o/Kconfig
index 5afa0e3..c102225 100644
--- a/drivers/message/i2o/Kconfig
+++ b/drivers/message/i2o/Kconfig
@@ -54,7 +54,7 @@ config I2O_EXT_ADAPTEC_DMA64
 
 config I2O_CONFIG
 	tristate "I2O Configuration support"
-	depends on VIRT_TO_BUS
+	depends on VIRT_TO_BUS && (BROKEN || !64BIT)
 	---help---
 	  Say Y for support of the configuration interface for the I2O adapters.
 	  If you have a RAID controller from Adaptec and you want to use the
@@ -66,6 +66,8 @@ config I2O_CONFIG
 	  Note: If you want to use the new API you have to download the
 	  i2o_config patch from http://i2o.shadowconnect.com/
 
+	  Note: This is broken on 64-bit architectures.
+
 config I2O_CONFIG_OLD_IOCTL
 	bool "Enable ioctls (OBSOLETE)"
 	depends on I2O_CONFIG

