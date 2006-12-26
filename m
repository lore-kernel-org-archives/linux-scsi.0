From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] cciss: build with PROC_FS=n
Date: Tue, 26 Dec 2006 09:34:17 -0800
Message-ID: <20061226093417.8965bf6b.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:28935 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932736AbWLZRgS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Dec 2006 12:36:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: mike.miller@hp.com, iss_storagedev@hp.com, akpm <akpm@osdl.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

RAID_UNKNOWN is used even when PROC_FS=n, so move it outside
of the CONFIG_PROC_FS block.

drivers/block/cciss.c:1910: error: 'RAID_UNKNOWN' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/block/cciss.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.20-rc2.orig/drivers/block/cciss.c
+++ linux-2.6.20-rc2/drivers/block/cciss.c
@@ -225,6 +225,8 @@ static inline CommandList_struct *remove
 
 #include "cciss_scsi.c"		/* For SCSI tape support */
 
+#define RAID_UNKNOWN 6
+
 #ifdef CONFIG_PROC_FS
 
 /*
@@ -232,7 +234,6 @@ static inline CommandList_struct *remove
  */
 #define ENG_GIG 1000000000
 #define ENG_GIG_FACTOR (ENG_GIG/512)
-#define RAID_UNKNOWN 6
 static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
 	"UNKNOWN"
 };


---
