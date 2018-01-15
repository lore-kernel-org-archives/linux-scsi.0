From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] mptfusion: Use snprintf() instead of open coded divisions
Date: Mon, 15 Jan 2018 19:05:58 +0200
Message-ID: <20180115170558.86823-1-andriy.shevchenko@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:37504 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935343AbeAORGc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Jan 2018 12:06:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Numbers up to 100 snprintf() prints without using a division.
Besides that the code looks more readable.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/message/fusion/mptctl.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 7b3b41368931..8d12017b9893 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -2481,24 +2481,13 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
 	else
 		karg.host_no =  -1;
 
-	/* Reformat the fw_version into a string
-	 */
-	karg.fw_version[0] = ioc->facts.FWVersion.Struct.Major >= 10 ?
-		((ioc->facts.FWVersion.Struct.Major / 10) + '0') : '0';
-	karg.fw_version[1] = (ioc->facts.FWVersion.Struct.Major % 10 ) + '0';
-	karg.fw_version[2] = '.';
-	karg.fw_version[3] = ioc->facts.FWVersion.Struct.Minor >= 10 ?
-		((ioc->facts.FWVersion.Struct.Minor / 10) + '0') : '0';
-	karg.fw_version[4] = (ioc->facts.FWVersion.Struct.Minor % 10 ) + '0';
-	karg.fw_version[5] = '.';
-	karg.fw_version[6] = ioc->facts.FWVersion.Struct.Unit >= 10 ?
-		((ioc->facts.FWVersion.Struct.Unit / 10) + '0') : '0';
-	karg.fw_version[7] = (ioc->facts.FWVersion.Struct.Unit % 10 ) + '0';
-	karg.fw_version[8] = '.';
-	karg.fw_version[9] = ioc->facts.FWVersion.Struct.Dev >= 10 ?
-		((ioc->facts.FWVersion.Struct.Dev / 10) + '0') : '0';
-	karg.fw_version[10] = (ioc->facts.FWVersion.Struct.Dev % 10 ) + '0';
-	karg.fw_version[11] = '\0';
+	/* Reformat the fw_version into a string */
+	snprintf(karg.fw_version, sizeof(karg.fw_version),
+		 "%.2hhu.%.2hhu.%.2hhu.%.2hhu",
+		 ioc->facts.FWVersion.Struct.Major,
+		 ioc->facts.FWVersion.Struct.Minor,
+		 ioc->facts.FWVersion.Struct.Unit,
+		 ioc->facts.FWVersion.Struct.Dev);
 
 	/* Issue a config request to get the device serial number
 	 */
-- 
2.15.1
