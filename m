From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] scsi: fix NCR5380 section mismatch
Date: Tue, 22 Jan 2008 21:39:33 -0800
Message-ID: <20080122213933.d12c3d39.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:23206 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbYAWFl7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jan 2008 00:41:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <James.Bottomley@HansenPartnership.com>, akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Many release() methods that are not __exit or __devexit call this
__devexit function, so remove its "__devexit" attribute.

scsi/g_NCR5380.c:
WARNING: vmlinux.o(.text+0xadaf8c): Section mismatch: reference to .exit.text:NCR5380_exit (between 'generic_NCR5380_release_resources' and 'generic_NCR5380_biosparam')
WARNING: vmlinux.o(.text+0xadd18c): Section mismatch: reference to .exit.text:NCR5380_exit (between 'generic_NCR5380_release_resources' and 'generic_NCR5380_biosparam')
scsi/pas16.c, seagate.c:
WARNING: vmlinux.o(.text+0xb29e91): Section mismatch: reference to .exit.text:NCR5380_exit (between 'pas16_release' and 'seagate_st0x_info')
t128.c:
WARNING: vmlinux.o(.text+0xb2a774): Section mismatch: reference to .exit.text:NCR5380_exit (between 't128_release' and 't128_biosparam')
dtc.c, sym2/sym_fw.c:
WARNING: vmlinux.o(.text+0xb2f215): Section mismatch: reference to .exit.text:NCR5380_exit (between 'dtc_release' and 'sym_fw1_patch')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/NCR5380.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc8-git5.orig/drivers/scsi/NCR5380.c
+++ linux-2.6.24-rc8-git5/drivers/scsi/NCR5380.c
@@ -932,7 +932,7 @@ static int __devinit NCR5380_init(struct
  *	@instance: adapter to remove
  */
 
-static void __devexit NCR5380_exit(struct Scsi_Host *instance)
+static void NCR5380_exit(struct Scsi_Host *instance)
 {
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 
