From: bo yang <boyang1288@gmail.com>
Subject: [PATCH 5/5] scsi: megaraid_sas - Version and documentation update
Date: Wed, 11 Aug 2010 17:12:35 -0400
Message-ID: <AANLkTinKvoMkoPunxLrYw6TF1kCcc1WYfy-QHNv_c+hD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f66.google.com ([209.85.160.66]:55772 "EHLO
	mail-pw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab0HKV3a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Aug 2010 17:29:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bo.yang@lsi.com, James.Bottomley@HansenPartnership.com, James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org

Update the version and documentation.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
 Documentation/scsi/ChangeLog.megaraid_sas |   16 +++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas.h      |    6 +++---
 2 files changed, 18 insertions(+), 4 deletions(-)

diff -rupN old/Documentation/scsi/ChangeLog.megaraid_sas
new/Documentation/scsi/ChangeLog.megaraid_sas
--- old/Documentation/scsi/ChangeLog.megaraid_sas	2010-08-10
05:00:31.000000000 -0400
+++ new/Documentation/scsi/ChangeLog.megaraid_sas	2010-08-10
05:09:38.000000000 -0400
@@ -2,7 +2,7 @@
 			(emaild-id:megaraidlinux@lsi.com)
 			Bo Yang

-2 Current Version : 00.00.04.17.1-rc1
+2 Current Version : 00.00.04.31-rc1
 3 Older Version   : 00.00.04.17.1-rc1

 1.	Add the Online Controller Reset (OCR) to the Driver.
@@ -31,6 +31,20 @@
 		e). In driver's IOCTL routine, the application cmds will wait for the
 		OCR to finish, then issue the cmds to FW.
 		
+		f). Before driver kill adapter, driver will do last chance of
+		OCR to see if driver can bring back the FW.
+
+2.	Add the support update flag to the driver to tell LSI megaraid_sas
+	application which driver will support the device update.  So application
+	will not need to do the device update after application add/del the device
+	from the system.
+3.	In driver's timeout routine, driver will do three time reset if fw is in
+	failed state.  Driver will kill adapter if can't bring back FW after the
+	this three times reset.
+4.	Add the input parameter max_sectors to 1MB support to our GEN2 controller.
+	customer can use the input paramenter max_sectors to add 1MB support to GEN2
+	controller.
+
 1 Release Date    : Thur.  Oct 29, 2009 09:12:45 PST 2009 -
 			(emaild-id:megaraidlinux@lsi.com)
 			Bo Yang
diff -rupN old/drivers/scsi/megaraid/megaraid_sas.h
new/drivers/scsi/megaraid/megaraid_sas.h
--- old/drivers/scsi/megaraid/megaraid_sas.h	2010-08-10 04:51:39.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.h	2010-08-10 04:36:15.000000000 -0400
@@ -18,9 +18,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION			"00.00.04.17.1-rc1"
-#define MEGASAS_RELDATE			"Oct. 29, 2009"
-#define MEGASAS_EXT_VERSION		"Thu. Oct. 29, 11:41:51 PST 2009"
+#define MEGASAS_VERSION			"00.00.04.31-rc1"
+#define MEGASAS_RELDATE			"May 3, 2010"
+#define MEGASAS_EXT_VERSION		"Mon. May 3, 11:41:51 PST 2010"

 /*
  * Device IDs
