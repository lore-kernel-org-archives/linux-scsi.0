From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] CISS: require same SCSI module support
Date: Tue, 21 Nov 2006 11:06:10 -0800
Message-ID: <20061121110610.d72e3976.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:52632 "EHLO
	rgminet01.oracle.com") by vger.kernel.org with ESMTP
	id S1031320AbWKUTGG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 14:06:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: mike.miller@hp.com, iss_storagedev@hp.com, akpm <akpm@osdl.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Building CCISS SCSI tape support in-kernel when SCSI=m causes build errors,
so require SCSI support to be =y or same as CCISS SCSI tape support.

drivers/built-in.o: In function `cciss_remove_one':
cciss.c:(.text+0x79d4c): undefined reference to `scsi_remove_host'
cciss.c:(.text+0x79d55): undefined reference to `scsi_host_put'
drivers/built-in.o: In function `cciss_update_non_disk_devices':
cciss.c:(.text+0x7bb54): undefined reference to `scsi_device_type'
cciss.c:(.text+0x7bcc8): undefined reference to `scsi_device_type'
cciss.c:(.text+0x7be81): undefined reference to `scsi_device_type'
cciss.c:(.text+0x7bf81): undefined reference to `scsi_device_type'
drivers/built-in.o: In function `cciss_proc_write':
cciss.c:(.text+0x7c175): undefined reference to `scsi_host_alloc'
cciss.c:(.text+0x7c1ed): undefined reference to `scsi_add_host'
cciss.c:(.text+0x7c1f9): undefined reference to `scsi_scan_host'
cciss.c:(.text+0x7c206): undefined reference to `scsi_host_put'
make: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/block/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2619-rc6g3.orig/drivers/block/Kconfig
+++ linux-2619-rc6g3/drivers/block/Kconfig
@@ -168,7 +168,8 @@ config BLK_CPQ_CISS_DA
 
 config CISS_SCSI_TAPE
 	bool "SCSI tape drive support for Smart Array 5xxx"
-	depends on BLK_CPQ_CISS_DA && SCSI && PROC_FS
+	depends on BLK_CPQ_CISS_DA && PROC_FS
+	depends on SCSI=y || SCSI=BLK_CPQ_CISS_DA
 	help
 	  When enabled (Y), this option allows SCSI tape drives and SCSI medium
 	  changers (tape robots) to be accessed via a Compaq 5xxx array 


---
