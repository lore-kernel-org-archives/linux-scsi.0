From: Bernhard Walle <bwalle@suse.de>
Subject: [PATCH] Update version information
Date: Sat, 22 Sep 2007 21:55:19 +0200
Message-ID: <20070922195519.GA5274@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:33774 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbXIVTzW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Sep 2007 15:55:22 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, aacraid@adaptec.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

This patch just makes the version number in ips.c and ips.h consistent. It
seems that this has been forgotten in a60768e2d43eb30a1adb8a119aeac35dc0d03ef6.

It also removes code duplication, each number is now only once in the code to
avoid similar errors in the future.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 drivers/scsi/ips.c |    4 ++--
 drivers/scsi/ips.h |   11 ++++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -204,8 +204,8 @@ module_param(ips, charp, 0);
 /*
  * DRIVER_VER
  */
-#define IPS_VERSION_HIGH        "7.12"
-#define IPS_VERSION_LOW         ".05 "
+#define IPS_VERSION_HIGH        IPS_VER_MAJOR_STRING "." IPS_VER_MINOR_STRING
+#define IPS_VERSION_LOW         "." IPS_VER_BUILD_STRING " "
 
 #if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
 #warning "This driver has only been tested on the x86/ia64/x86_64 platforms"
--- a/drivers/scsi/ips.h
+++ b/drivers/scsi/ips.h
@@ -1172,12 +1172,13 @@ typedef struct {
 *************************************************************************/
 
 #define IPS_VER_MAJOR 7
-#define IPS_VER_MAJOR_STRING "7"
+#define IPS_VER_MAJOR_STRING __stringify(IPS_VER_MAJOR)
 #define IPS_VER_MINOR 12
-#define IPS_VER_MINOR_STRING "12"
-#define IPS_VER_BUILD 02
-#define IPS_VER_BUILD_STRING "02"
-#define IPS_VER_STRING "7.12.02"
+#define IPS_VER_MINOR_STRING __stringify(IPS_VER_MINOR)
+#define IPS_VER_BUILD 05
+#define IPS_VER_BUILD_STRING __stringify(IPS_VER_BUILD)
+#define IPS_VER_STRING IPS_VER_MAJOR_STRING "." \
+		IPS_VER_MINOR_STRING "." IPS_VER_BUILD_STRING
 #define IPS_RELEASE_ID 0x00020000
 #define IPS_BUILD_IDENT 761
 #define IPS_LEGALCOPYRIGHT_STRING "(C) Copyright IBM Corp. 1994, 2002. All Rights Reserved."
