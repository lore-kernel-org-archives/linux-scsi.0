From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 2.5] fix megaraid driver compile error
Date: 06 Feb 2003 11:20:47 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1044559247.4858.49.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This moves access of the host element to device since host has been
removed from struct scsi_cmnd.


===== drivers/scsi/megaraid.c 1.32 vs edited =====
--- 1.32/drivers/scsi/megaraid.c        Fri Jan  3 10:58:49 2003
+++ edited/drivers/scsi/megaraid.c      Thu Feb  6 10:18:43 2003
@@ -4515,7 +4515,7 @@
                if(scsicmd == NULL) return -ENOMEM;

                memset(scsicmd, 0, sizeof(Scsi_Cmnd));
-               scsicmd->host = shpnt;
+               scsicmd->device->host = shpnt;

                if( outlen || inlen ) {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
@@ -4652,7 +4652,7 @@
                if(scsicmd == NULL) return -ENOMEM;

                memset(scsicmd, 0, sizeof(Scsi_Cmnd));
-               scsicmd->host = shpnt;
+               scsicmd->device->host = shpnt;

                if (outlen || inlen) {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
-- 
Mark Haverkamp <markh@osdl.org>

