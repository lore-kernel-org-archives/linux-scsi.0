From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH] [SCSI] Improve SCSI_LOGGING Kconfig entry
Date: Wed, 14 Jan 2009 11:14:32 -0800
Message-ID: <20090114191432.20337.74957.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:35632 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbZANTOe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2009 14:14:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: robert.w.love@intel.com

The Kconfig entry for SCSI_LOGGING refers the reader to
drivers/scsi/scsi.c, but I didn't find any useful information
there. There is certainly logging code in that file, but the
logging types and logging levels are described in
drivers/scsi/scsi_logging.h.

Also, the procfs file referred to in the section is incorrect.
It should be /proc/sys/dev/scsi/logging_level and not
/proc/scsi/scsi.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/Kconfig |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 256c7be..3710ad1 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -224,14 +224,15 @@ config SCSI_LOGGING
 	  can enable logging by saying Y to "/proc file system support" and
 	  "Sysctl support" below and executing the command
 
-	  echo "scsi log token [level]" > /proc/scsi/scsi
+	  echo <bitmask> > /proc/sys/dev/scsi/logging_level
 
-	  at boot time after the /proc file system has been mounted.
+	  where <bitmask> is a four byte value representing the logging type
+	  and logging level for each type of logging selected.
 
-	  There are a number of things that can be used for 'token' (you can
-	  find them in the source: <file:drivers/scsi/scsi.c>), and this
-	  allows you to select the types of information you want, and the
-	  level allows you to select the level of verbosity.
+	  There are a number of logging types and you can find them in the
+	  source at <file:drivers/scsi/scsi_logging.h>. The logging levels
+	  are also described in that file and they determine the verbosity of
+	  the logging for each logging type.
 
 	  If you say N here, it may be harder to track down some types of SCSI
 	  problems. If you say Y here your kernel will be somewhat larger, but

