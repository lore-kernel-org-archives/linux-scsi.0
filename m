From: akpm@osdl.org
Subject: [patch 30/31] scsi: clean up warnings in Advansys driver
Date: Thu, 08 Jun 2006 22:24:05 -0700
Message-ID: <200606090524.k595O5dX032361@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:26077 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965175AbWFIFYO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 01:24:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, ken@krwtech.com, jeffreyfreeman@syncleus.com


From: Ken Witherow <ken@krwtech.com>

Fix typecast warnings and switch from check_region to request_region

(akpm: Ken and Jeffrey Phillips Freeman <jeffreyfreeman@syncleus.com> are
possible advansys testers)

Signed-off-by: Ken Witherow <ken@krwtech.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/advansys.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/advansys.c~scsi-clean-up-warnings-in-advansys-driver drivers/scsi/advansys.c
--- devel/drivers/scsi/advansys.c~scsi-clean-up-warnings-in-advansys-driver	2006-04-30 00:13:25.000000000 -0700
+++ devel-akpm/drivers/scsi/advansys.c	2006-04-30 00:13:25.000000000 -0700
@@ -4415,7 +4415,7 @@ advansys_detect(struct scsi_host_templat
                         ASC_DBG1(1,
                                 "advansys_detect: probing I/O port 0x%x...\n",
                             iop);
-                        if (check_region(iop, ASC_IOADR_GAP) != 0) {
+			if (!request_region(iop, ASC_IOADR_GAP, "advansys")){
                             printk(
 "AdvanSys SCSI: specified I/O Port 0x%X is busy\n", iop);
                             /* Don't try this I/O port twice. */
@@ -4425,6 +4425,7 @@ advansys_detect(struct scsi_host_templat
                             printk(
 "AdvanSys SCSI: specified I/O Port 0x%X has no adapter\n", iop);
                             /* Don't try this I/O port twice. */
+			    release_region(iop, ASC_IOADR_GAP);
                             asc_ioport[ioport] = 0;
                             goto ioport_try_again;
                         } else {
@@ -4443,6 +4444,7 @@ advansys_detect(struct scsi_host_templat
                                   * 'ioport' past this board.
                                   */
                                  ioport++;
+				 release_region(iop, ASC_IOADR_GAP);
                                  goto ioport_try_again;
                             }
                         }
@@ -9752,13 +9754,14 @@ AscSearchIOPortAddr11(
     }
     for (; i < ASC_IOADR_TABLE_MAX_IX; i++) {
         iop_base = _asc_def_iop_base[i];
-        if (check_region(iop_base, ASC_IOADR_GAP) != 0) {
+	if (!request_region(iop_base, ASC_IOADR_GAP, "advansys")){
             ASC_DBG1(1,
                "AscSearchIOPortAddr11: check_region() failed I/O port 0x%x\n",
                      iop_base);
             continue;
         }
         ASC_DBG1(1, "AscSearchIOPortAddr11: probing I/O port 0x%x\n", iop_base);
+	release_region(iop_base, ASC_IOADR_GAP);
         if (AscFindSignature(iop_base)) {
             return (iop_base);
         }
_
